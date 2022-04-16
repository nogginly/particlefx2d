# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'

require 'yard'

YARD::Rake::YardocTask.new do |t|
  t.files = ['lib/**/*.rb']
  t.stats_options = ['--list-undoc']
end

RuboCop::RakeTask.new

desc 'Uninstall gem'
task :uninstall do
  puts 'Uninstalling'
  system 'gem uninstall particlefx2d --executables'
end

task default: %i[spec rubocop]
