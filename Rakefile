require 'rake/clean'

task :clean do
  CLEAN = FileList['**/*.json']
  puts 'JSON cleaned.'
end

task :clobber do
  CLOBBER = FileList['**/*.json']
  puts 'Everything cleaned.'
end

desc 'Run'
task :run do
  require './lib/cbradio.rb'
end

task :default => [:run]
