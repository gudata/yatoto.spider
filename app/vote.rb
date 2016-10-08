require 'mechanize'
require 'active_support/core_ext'

class String
  def uncapitalize
    self[0, 1].mb_chars.downcase + self[1..-1]
  end
end

class Vote
  attr :agent

  def initialize user, database
    @user = user
    @agent = Mechanize.new
    @agent.follow_meta_refresh = true
    @database = database
  end

  def login
    page = agent.get('http://www.yatoto.com/')
    page.form_with(:id => 'quick-login') do |form|
      form.field_with(:name => 'user[email]').value = @user[:email]
      form.field_with(:name => 'user[password]').value = @user[:password]
      page = agent.submit(form, form.buttons.first)
    end
    puts "logged as..."
  end

  def get_happy
    @database['posts'].each_pair do |message, used|
      next if used.to_i == 1
      return message
    end
  end

  def mark_happy_used message
    @database.raw['posts'][message] = 1
    @database.save
  end


  def post
    page = agent.get('/posts')
    page.form_with(:id => 'new_post') do |form|
      message = get_happy
      gender = @user[:gender] == 'male' ? 'Днес съм щастлив, защото' : 'Днес съм щастлива, защото'
      form.field_with(:name => 'post[content]').value = "#{gender} #{message.uncapitalize}"
      mark_happy_used message
      puts "  we say: #{message}"
    end.submit
  end

  def show_links page
    page.links.each do |link|
      puts link.text
    end
  end

  def ticket_taken? page
    if page.parser.css('.no_more') and page.parser.css('.no_more').text.include? 'Ти вече взе билета за тази реклама'
      puts "  Вече сме взели"
      return true
    else
      return false
    end
  end

  def won? page
    if page.parser.css('.ticket_won_message') and page.parser.css('.ticket_won_message').text.include? 'Честито,'
      puts "  Взехме"
      return true
    else
      return false
    end
  end

  def watch_ad number
    puts "Get ticket for #{number}"
    agent.get("/ad/frames/#{number}/step1") do |page|
      return if ticket_taken?(page)
      puts "  Click 'Спечели билет'"
      page = agent.click(page.link_with(:text => /Спечели билет/))
      puts "  waiting 33sec"
      sleep(33)
      puts "  Click 'Вземи билета'"
      page = agent.click(page.link_with(:text => /Вземи билета/))
      won?(page)
    end
  end

end
