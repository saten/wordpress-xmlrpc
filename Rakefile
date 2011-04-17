require 'rubygems'
require 'rake'

begin
  require 'jeweler'

  Jeweler::Tasks.new do |gem|
    gem.name = "wordpress-xmlrpc-saten"
    gem.summary = %Q{This gem is supposed to simplify wordpress xmlrpc interaction}
    gem.description = %Q{Fork of discontinued wordpress-xmlrpc gem from Alexander Naumenko }
    gem.email = "saten.r@gmail.com"
    gem.homepage = "http://github.com/saten/wordpress-xmlrpc"
    gem.authors = ["Sante Rotondi"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_dependency 'log4r', '>=1.1.8'
    gem.add_dependency 'mimemagic', '>=0.1.5'
    gem.add_dependency 'nokogiri', '>=1.4.3.1'
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "wordpress-xmlrpc #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
