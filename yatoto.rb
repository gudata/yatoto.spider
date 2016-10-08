#!/usr/bin/env ruby
require 'bundler/setup'
require "pathological"
require 'vote'
require 'database'


# Somenotes
# http://ruby.bastardsbook.com/chapters/mechanize/
# http://stackoverflow.com/questions/6629579/using-ruby-with-mechanize-to-log-into-a-website
# http://stackoverflow.com/questions/15697049/finding-next-input-element-using-mechanize
# http://mechanize.rubyforge.org/EXAMPLES_rdoc.html

@database = Database.new(File.join(__dir__, 'posts.yml'))

users = [{
  email: 'someonev@gmail.com',
  password: 11223344,
  gender: 'male',
  },
]

users.each do |user|
  puts "user: #{user[:email]}"
  t = Vote.new user, @database
  t.login
  t.post

  [25, 13, 23, 16,24,21,17, 1, 22, 18, 20, 19].each do |number|
    t.watch_ad(number)

    wait = (rand(4)+1)
    puts "waiting ..#{wait} hours"
    sleep(wait.minutes)
  end

end
