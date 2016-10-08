#!/usr/bin/env ruby
require 'bundler/setup'
require "pathological"
require 'yaml'
require 'database'

@database = Database.new(File.join(__dir__, 'posts.yml'))

used = []
unused = []
@database.row['posts'].each do |p|
  puts p.inspect
end