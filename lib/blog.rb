require 'xmlrpc/client'
require 'params_check'
require 'mimemagic'
require 'nokogiri'

module Wordpress
  class Blog
    include ParamsCheck
    include Loggable

    def initialize(params = {})
      @blog_uri = URI.parse(check_param(params, :blog_uri))

      @xmlrpc_path = params[:xmlrpc_path] || "xmlrpc.php"

      @id = params[:blog_id] || 0

      @user = check_param(params, :user)

      @password = check_param(params, :password)

      if params[:proxy]
	@client = XMLRPC::Client.new2(URI.join(@blog_uri.to_s, @xmlrpc_path).to_s,params[:proxy])
      else
	@client = XMLRPC::Client.new2(URI.join(@blog_uri.to_s, @xmlrpc_path).to_s)
      end
    end #initialize

    def get_post(post_id)
      Wordpress::Post.from_struct(:metaWeblog,api_call("metaWeblog.getPost", post_id, @user, @password))
    end #get_post
		
    def recent_posts(number_of_posts)
      blog_api_call("metaWeblog.getRecentPosts",@id,@user,@password, number_of_posts).collect do |struct|
        Post.from_struct(:metaWeblog, struct)
      end
    end #recent_posts

    def publish(item,published=true)
      process_images(item) unless item.images.nil?
      case item
      when Wordpress::Post
        item.id = blog_api_call("metaWeblog.newPost", @id,@user,@password,item.to_struct(:metaWeblog), published).to_i
      when Wordpress::Page
        item.id = blog_api_call("wp.newPage", @id,@user,@password,item.to_struct(:wp), published).to_i
      else
        raise "Unknown item type: #{item}"
      end
      item.published = true
      return item
    end #publish

    def update(item)
      process_images(item) unless item.images.nil?
      case item
      when Post
        return api_call("metaWeblog.editPost", item.id, @user, @password, item.to_struct(:metaWeblog), item.published)
      when Page
        return api_call("wp.editPage", @id, item.id, @user, @password, item.to_struct(:wp), item.published)
      else
        raise "Unknown item type: #{item}"
      end
    end #update

    def delete(item)
      case item
      when Wordpress::Post
        return api_call("blogger.deletePost", "", item.id, @user, @password, true)
      when Wordpress::Page
        return blog_api_call("wp.deletePage", @id,@user,@password, item.id)
      else
        raise "Unknown item type: #{item}"
      end
    end

    def get_authors
      blog_api_call("wp.getAuthors",@id,@user,@password)
    end
    
    def get_post_status_list
      blog_api_call("wp.getPostStatusList",@id,@user,@password)
    end
    
    def get_users_blogs
	blog_api_call("wp.getUsersBlogs",@user,@password)
    end
 
    def get_page_list
      page_list = blog_api_call("wp.getPageList",@id,@user,@password).collect do |struct|
        Wordpress::Page.from_struct(:wp, struct)
      end
      # link pages list with each other
      page_list.each do |page|
        page.parent = page_list.find{|p| p.id == page.parent_id} if page.parent_id
      end
      page_list
    end #get_page_list

    def get_pages
      page_list =  blog_api_call("wp.getPages",@id,@user,@password,1000).collect do |struct|
        Wordpress::Page.from_struct(:wp, struct)
      end
      # link pages list with each other
      page_list.each do |page|
        page.parent = page_list.find{|p| p.id == page.parent_id} if page.parent_id
      end
      page_list

    end
    
    def get_page(page_id)
      Wordpress::Page.from_struct(:wp,blog_api_call("wp.getPage",@id,page_id,@user,@password))
    end #get_page
    def get_categories
      return api_call('wp.getCategories',@id,@user,@password)
    end

    def new_category(category)
      return api_call('wp.newCategory',@id,@user,@password,category)
    end


    def upload_file(file)
      struct = {
        :name => File.basename(file.path),
        :type => MimeMagic.by_magic(file).type,
        :bits => XMLRPC::Base64.new(File.open(file.path, "r").read),
        :overwrite => true
      }
      return blog_api_call("wp.uploadFile", struct)
    end

    def get_comment_status_list
      return api_call('wp.getCommentStatusList',@id,@user,@password)
    end

    def get_comment_count(post_id)
      return api_call('wp.getCommentCount',@id,@user,@password,post_id)
    end

    def get_comments(options={})
      # post status list http://codex.wordpress.org/XML-RPC_wp#wp.getCommentStatusList
      #  struct
      #  string hold
      #  string approve
      #  string spam
      #
      options[:post_id]||=0
      options[:status]||="approve"
      #options[:offset]||=0
      #options[:number]||=0
      api_call('wp.getComments',@id,@user,@password,options)
    end

    def get_comment(comment_id)
      api_call('wp.getComment',@id,@user,@password,comment_id)
    end
    def edit_comment(comment)
      options={}
      options['status']=comment['status']
      #options['date_created_gmt']=comment['date_created_gmt'] //date should be GMT, or you get a 500. let's just skip this for now :)
      options['content']=comment['content']
      options['author']=comment['author']
      options['author_url']=comment['author_url']
      options['author_email']=comment['author_email']
      api_call('wp.editComment',@id,@user,@password,comment['comment_id'],options)
    end

    def delete_comment(comment_id)
      api_call('wp.deleteComment',@id,@user,@password,comment_id)
    end

    private
    def process_images(item)
      doc = Nokogiri::HTML::DocumentFragment.parse(item.content)
      item.images.each do |image|

        raise ArgumentError, "Image not found (path: #{image[:file_path]})" unless File.exist?(image[:file_path])

        basename = File.basename(image[:file_path])
        uploaded_image = upload_file(File.open(image[:file_path], "rb"))
        raise "Image upload failed" if uploaded_image.nil?
        doc.css("img").each do |img|
          img['src'] = uploaded_image['url'] if img['src'].include?(basename)
        end
      end
      item.content = doc.to_html
    end #process_images

    def api_call(method_name, *args)
      begin
        return @client.call(method_name, *args)
      rescue XMLRPC::FaultException
        log.log_exception "Error while calling #{method_name}", $!
        raise APICallException, "Error while calling #{method_name}"
      end
    end #api_call

    def blog_api_call(method_name, *args)
      begin
        return @client.call(method_name,*args)
      rescue XMLRPC::FaultException
        log.log_exception "Error while calling #{method_name}", $!
        raise APICallException, "Error while calling #{method_name}"
      end
    end #call_client
  end
end
