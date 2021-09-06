# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"].exclude("test/dummy_app/**/*")
end

namespace :test do
  task :system do
    sh <<~CMD
      yarn build &&
      cd test/dummy_app &&
      yarn &&
      bundle &&
      rake test:system
    CMD
  end
end

task default: [:test, :'test:system']
