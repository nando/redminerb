# Copyright (c) The Cocktail Experience S.L. (2015) Fernando Garcia Samblas
require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rubocop/rake_task'
require './lib/redminerb'

RuboCop::RakeTask.new

Rake::TestTask.new(:spec) do |t|
  t.libs.push 'lib'
  t.test_files = FileList['spec/**/*_spec.rb']
  t.verbose = true
end

task default: [:spec]
