require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "watir-page-helper"
  gem.homepage = "http://github.com/alisterscott/watir-page-helper"
  gem.license = "MIT"
  gem.summary = "A page helper for Watir/Watir-WebDriver that allows use easy access to elements."
  gem.description = "This is a page helper for Watir/Watir-WebDriver that allows use easy access to elements. See watir.com"
  gem.email = "alister.scott@gmail.com"
  gem.authors = ["Alister Scott"]
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

RSpec::Core::RakeTask.new(:rcov) do |t|
  t.rcov = true
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
