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
require 'mechanize'

# limit the number of domains checked
max_domains = 25

# html markers
html_markers = ['<html ', '<head ', '<body', '<p>', '<p ', '<a ', '<br>', '<br />']

# connect
db = Mysql.new('localhost', 'root', 'atreides', 'humans')

# get latest x domains without humans
domains = db.query "SELECT domains.name, domains.id FROM domains WHERE domains.id NOT IN (SELECT domain_id FROM humans) ORDER BY discovered DESC LIMIT 0, #{max_domains}"

domains.each { | domain |
  puts "domain: #{domain[0]}"
  
  url = "http://#{domain[0]}/humans.txt"
  
  begin
    
    # load the homepage of the site and check for the language
    agent = Mechanize.new
    homepage = agent.get("http://#{domain[0]}")
    process = true
    if homepage and homepage.root and homepage.root.root
    puts "lang: #{homepage.root.root['lang'].downcase}" if homepage.root.root['lang']
    puts "Header: #{homepage.response['Content-Language'].downcase}" if homepage.response['Content-Language']
    puts "lang: #{homepage.root.xpath('//meta[@http-equiv="Content-Language"]').first['content'].downcase}" if homepage.root.xpath('//meta[@http-equiv="Content-Language"]').first and homepage.root.xpath('//meta[@http-equiv="Content-Language"]').first['content']
    
    # extract the title and meta description if we can
    titles = homepage.root.xpath('//title')
    title = titles.first.content() if titles.length > 0
    descriptions = homepage.root.xpath('//meta[@name="description"]')
    description = descriptions.first['content'] if descriptions.length > 0
    puts "title: #{title}"
    puts "description: #{description}"
    
    if (homepage.root.root['lang'] and
        (homepage.root.root['lang'].downcase != '' and
        homepage.root.root['lang'].downcase != 'en' and
        homepage.root.root['lang'].downcase != 'en-gb' and
        homepage.root.root['lang'].downcase != 'en-us'
        )) or
        ( homepage.response['Content-Language'] and
         (homepage.response['Content-Language'].downcase != '' and
         homepage.response['Content-Language'].downcase != 'en' and
         homepage.response['Content-Language'].downcase != 'en-gb' and
         homepage.response['Content-Language'].downcase != 'en-us'
        )) or
        ( homepage.root.xpath('//meta[@http-equiv="Content-Language"]').first and
          (
            homepage.root.xpath('//meta[@http-equiv="Content-Language"]').first['content'].downcase != '' and
            homepage.root.xpath('//meta[@http-equiv="Content-Language"]').first['content'].downcase != 'en' and
            homepage.root.xpath('//meta[@http-equiv="Content-Language"]').first['content'].downcase != 'en-gb' and
            homepage.root.xpath('//meta[@http-equiv="Content-Language"]').first['content'].downcase != 'en-us'
          )                
        )
       
       process = false
    end
    end
 
    if process
    
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
        db.query "INSERT INTO humans (domain_id, discovered, checked, txt, title, description) VALUES (#{domain[1]}, NOW(), NOW(), '#{Mysql.escape_string content}', '#{Mysql.escape_string title}', '#{Mysql.escape_string description}')"
        
      else
        puts " invalid content"
      end
    else
      puts " None English Content"
    end
  
  rescue Net::HTTP::Persistent::Error
    puts " Net::HTTP::Persistent::Error"
  rescue OpenSSL::SSL::SSLError
    puts " OpenSSL::SSL::SSLError"
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
