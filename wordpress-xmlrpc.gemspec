# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{wordpress-xmlrpc}
  s.version = "0.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alexander Naumenko"]
  s.date = %q{2010-09-20}
  s.description = %q{Please do not fork it before directly contacint}
  s.email = %q{alecnmk@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "Gemfile",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "features/publish.feature",
     "features/step_definitions/basic_steps.rb",
     "features/step_definitions/mysql_steps.rb",
     "features/support/env.rb",
     "lib/blog.rb",
     "lib/exceptions.rb",
     "lib/loggable.rb",
     "lib/params_check.rb",
     "lib/post.rb",
     "lib/wordpress-xmlrpc.rb",
     "spec/blog_spec.rb",
     "spec/post_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "spec/support/files/post_picture.jpg",
     "wordpress-xmlrpc.gemspec"
  ]
  s.homepage = %q{http://github.com/alecnmk/wordpress-xmlrpc}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{This gem is supposed to simplify wordpress xmlrpc interaction}
  s.test_files = [
    "spec/spec_helper.rb",
     "spec/blog_spec.rb",
     "spec/post_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_runtime_dependency(%q<log4r>, [">= 1.1.8"])
      s.add_runtime_dependency(%q<mimemagic>, [">= 0.1.5"])
      s.add_runtime_dependency(%q<nokogiri>, [">= 1.4.3.1"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_dependency(%q<log4r>, [">= 1.1.8"])
      s.add_dependency(%q<mimemagic>, [">= 0.1.5"])
      s.add_dependency(%q<nokogiri>, [">= 1.4.3.1"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
    s.add_dependency(%q<log4r>, [">= 1.1.8"])
    s.add_dependency(%q<mimemagic>, [">= 0.1.5"])
    s.add_dependency(%q<nokogiri>, [">= 1.4.3.1"])
  end
end

