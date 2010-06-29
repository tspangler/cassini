require 'rubygems'
require 'sinatra'
require 'pony'

get '/' do
  'NO CARRIER'
end

post '/deploy' do
  # Plant the payload for the lander to download
  # Create a beacon file instructing the lander to GO AHEAD
  
  f = File.new('beacon.txt', 'w')
  f.puts('GA')
  f.close
  
  'Beacon deployed to beacon.txt'  
end

get '/abort' do
  # Mission Control POSTS an abort; the lander GETS an abort.
  
  # Remove beacon if it exists
  if File.exists?('beacon.txt')
    File.delete('beacon.txt')
    status = "Beacon deleted"
  else
    status = "No beacon found"
  end
  
  # Return status
  "Received abort code from lander. #{status}; mission aborted."
end

post '/abort' do
  # TODO: Modify payload to instruct lander to abort and shutdown
end

get '/payload' do
  # Send the payload to the lander, if it exists
  if File.exists?('beacon.txt') == false
    '404' # Send abort code if it doesn't
  else
    f = File.open('beacon.txt', 'r')
    lander_command = f.readline.chomp
    f.close
    
    # Send the GA command to the lander
    lander_command
  end
end

get '/ok' do  
  # Send success message to Mission Control
  Pony.mail(:to => 'user@example.com', :body => 'LANDER REPORTS SUCCESS! HAVE A NICE DAY.')

  'Success signal received from lander.'
end

get '/fail' do  
  # Send failure message to Mission Control
  Pony.mail(:to => 'user@example.com', :body => 'LANDER REPORTS FAILURE. ABORTING. :(')
  
  'Failure signal received from lander.'
end