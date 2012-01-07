#####################################
# check through the latest domains that don't have
# humans, prefer the newest domains.
#####################################

require 'rubygems'
require 'mysql'
require 'uri'
require 'open-uri'
require 'net/http'
require 'nokogiri'

# html markers
html_markers = ['<html ', '<head ', '<body', '<p>', '<p ', '<a ', '<br>', '<br />']

# connect
db = Mysql.new('localhost', 'root', 'atreides', 'humans')

# get latest x domains without humans
domains = db.query "SELECT domains.name, domains.id FROM domains WHERE domains.id NOT IN (SELECT domain_id FROM humans) ORDER BY discovered DESC LIMIT 0, 2000"

domains.each { | domain |
  puts "domain: #{domain[0]}"
  
  url = "http://#{domain[0]}/humans.txt"
  
  begin
    
    # only use En encoded sites!
    #<meta content="text/html; charset=euc-kr" http-equiv="Content-Type">
    # hot the homepage and check the encoding!
    
    #doc = Nokogiri::HTML(open(url))
    doc = open(url)
    content = doc.read
    content.strip!
    
    # ignore html style content - likely a 404 page that sends 200, or spam!
    valid_content = true
    if !content or content == ''
      valid_content = false
    end
    if valid_content
      html_markers.each { | marker |
        if valid_content
          valid_content = false if content.include? marker
        end      
      }
    end
    
    if valid_content
      
      # insert new record
      db.query "INSERT INTO humans (domain_id, discovered, checked, txt) VALUES (#{domain[1]}, NOW(), NOW(), '#{Mysql.escape_string content}')"
      
    else
      puts " invalid content"
    end
  
  rescue EOFError
    puts " EOFError"
  rescue URI::InvalidURIError
    puts " URI::InvalidURIError"
  rescue Errno::ETIMEDOUT
    puts " Errno::ETIMEDOUT"
  rescue Errno::ECONNRESET
    puts " Errno::ECONNRESET"
  rescue Errno::ECONNREFUSED
    puts " Errno::ECONNREFUSED"
  rescue Timeout::Error
    puts " Timeout::Error"
  rescue SocketError
    puts " SocketError"
  rescue OpenURI::HTTPError
    puts " 404"
  rescue RuntimeError
    puts " Runtime Error - probably a redirect"
  end
  
   
}
