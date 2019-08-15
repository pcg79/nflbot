require 'rubygems'
require 'bundler'

Bundler.setup :default, :development

unless ENV['RACK_ENV'] == 'production'
  require 'rspec/core'
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec) do |spec|
    spec.pattern = FileList['spec/**/*_spec.rb']
  end

  task default: [:spec]
end

Dir.glob('lib/tasks/*.rake').each { |r| load r}
