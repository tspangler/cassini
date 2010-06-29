require 'rubygems'
require 'open-uri'
require 'mechanize'
require 'logger'

class Lander
  def initialize
    puts 'Lander activated.'
  end
  
  def fetch_payload
    send_signal_to_orbiter('payload')
  end

  def send_signal_to_orbiter(signal)
    open("http://url-to-orbiter.com/#{signal}").read
  end
  
  def execute_payload
    # Perform the predefined function specified in the payload
    # In this case, it's logging into Twitter using mechanize and posting a tweet with the time.
    
    # Create new mechanize agent using a junky browser
    agent = WWW::Mechanize.new { |a| a.user_agent_alias = 'Windows IE 7' }
    
    puts 'Getting Twitter login page...'
    page = agent.get('http://twitter.com/login')
        
    login_form = page.form_with(:action => 'https://twitter.com/sessions')

    login_form.field_with(:name => 'session[username_or_email]').value = 'username'
    login_form.field_with(:name => 'session[password]').value = 'password'
    
    new_page = agent.submit(login_form)
    
    # TODO: Check if the request completed successfully and return true or false based on that

    tweet_form = new_page.form_with(:action => 'http://twitter.com/status/update')
    tweet_form.status = Time.now.to_s.downcase
    
    new_page = agent.submit(tweet_form)

  	puts 'Landing successful. We have arrived!'
    return true
  end
  
  def shutdown
    puts 'Shutting down lander and all supporting systems.'
    
	  # This is the command for deploying on Windows (ugh)
	  system('shutdown.exe -s -f -t 0')
  end
end

# The class and the instructions are stored in the same file
lander = Lander.new

puts 'Fetching payload...'
payload = lander.fetch_payload

if payload == 'GA'
  puts "Payload is #{payload} - continuing operations."

  puts 'Executing payload...'
  if lander.execute_payload
    puts 'Sending OK signal to orbiter...result follows:'
    puts lander.send_signal_to_orbiter('ok')
  else
    puts 'Sending FAIL signal to orbiter...result follows:'
    puts lander.send_signal_to_orbiter('fail')
  end    
else
  puts "Payload is #{payload} - aborting opereations."

  puts 'Sending FAIL signal to orbiter...result follows:'
  puts lander.send_signal_to_orbiter('fail')
end

lander.shutdown