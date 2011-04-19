module Wordpress
  class Post
    include ContentItem

    ATTRIBUTE_MATCHES = {
      :metaWeblog => {
        :postid         => :id,
        :title          => :title,
        :description    => :content,
        :mt_excerpt     => :excerpt,
        :dateCreated    => :creation_date,
        :post_state     => :struct_published,
	:wp_author_display_name => :author_display_name,
	:permaLink 	=> :permaLink,
	:post_status 	=> :post_status
      },
      :wp => {
      }
    }

    attr_accessor(:published,:author_display_name,:permaLink,:post_status)

    def struct_published=(value)
      @published = value if [true, false].include? value
      @published = value == "publish" if value.kind_of? String
    end

    def struct_published()
      return "publish" if @published == true
      return nil
    end #struct_published

  end
end
