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
require 'UniversalDetector' # character encodign detection
require 'iconv'

# limit the number of domains checked
max_domains = 25

# html markers
html_markers = ['<pre', '<html ', '<head ', '<body', '<p>', '<p ', '<a ', '<br>', '<br />']

# connect
db = Mysql.new('localhost', 'dbuser', 'thalia', 'humans')

# get latest x domains without humans
domains = db.query "SELECT domains.name, domains.id FROM domains WHERE domains.id NOT IN (SELECT domain_id FROM humans) ORDER BY human_checked LIMIT 0, #{max_domains}"

domains.each { | domain |
  puts "domain: #{domain[0]}"
  
  url = "http://#{domain[0]}/humans.txt"
  
  begin
    
    # load the homepage of the site and check for the language
    agent = Mechanize.new
    homepage = agent.get("http://#{domain[0]}")
    process = true
    if homepage and homepage.root and homepage.root.root
#    puts "lang: #{homepage.root.root['lang'].downcase}" if homepage.root.root['lang']
#    puts "Header: #{homepage.response['Content-Language'].downcase}" if homepage.response['Content-Language']
#    puts "lang: #{homepage.root.xpath('//meta[@http-equiv="Content-Language"]').first['content'].downcase}" if homepage.root.xpath('//meta[@http-equiv="Content-Language"]').first and homepage.root.xpath('//meta[@http-equiv="Content-Language"]').first['content']
    
    # extract the title and meta description if we can
    titles = homepage.root.xpath('//title')
    title = titles.first.content() if titles.length > 0
    descriptions = homepage.root.xpath('//meta[@name="description"]')
    description = descriptions.first['content'] if descriptions.length > 0
    
#    puts "title: #{title}"
#    puts "description: #{description}"
    
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
        puts "HUMANS: #{domain[0]}"
        
        if description
          encoding_detect = UniversalDetector::chardet(description)
          if encoding_detect and encoding_detect['encoding'] and encoding_detect['encoding'].downcase != 'utf-8'
            puts "   #{encoding_detect['encoding']} => #{encoding_detect['confidence']}"
            description = Iconv.conv('utf-8', encoding_detect['encoding'], description)
          end
        end
        if title
          encoding_detect = UniversalDetector::chardet(title)
          if encoding_detect and encoding_detect['encoding'] and encoding_detect['encoding'].downcase != 'utf-8'
            puts "   #{encoding_detect['encoding']} => #{encoding_detect['confidence']}"
            title = Iconv.conv('utf-8', encoding_detect['encoding'], title)
          end
        end
        
        encoding_detect = UniversalDetector::chardet(content)
        if encoding_detect['encoding'].downcase != 'utf-8'
          puts "   #{encoding_detect['encoding']} => #{encoding_detect['confidence']}"
          content = Iconv.conv('utf-8', encoding_detect['encoding'], content)
        end

        # insert new record
        db.query "INSERT INTO humans (domain_id, discovered, checked, txt) VALUES (#{domain[1]}, NOW(), NOW(), '#{Mysql.escape_string content}')"

if title and description
        db.query "UPDATE domains SET human_checked = NOW(), title = '#{Mysql.escape_string title}', description = '#{Mysql.escape_string description}' WHERE id = #{domain[1]}"
end        

      else
        puts " invalid content"
    	process = false
      end
    else
      puts " None English Content"
      process = false
    end
  
  rescue Net::HTTP::Persistent::Error
    process = false
    puts " Net::HTTP::Persistent::Error"
  rescue OpenSSL::SSL::SSLError
    process = false
    puts " OpenSSL::SSL::SSLError"
  rescue EOFError
    puts " EOFError"
    process = false
  rescue URI::InvalidURIError
    process = false
    puts " URI::InvalidURIError"
  rescue Errno::ETIMEDOUT
    puts " Errno::ETIMEDOUT"
    process = false
  rescue Errno::ECONNRESET
    process = false
    puts " Errno::ECONNRESET"
  rescue Errno::ECONNREFUSED
    puts " Errno::ECONNREFUSED"
    process = false
  rescue Timeout::Error
    puts " Timeout::Error"
    process = false
  rescue SocketError
    puts " SocketError"
    process = false
  rescue OpenURI::HTTPError
    puts " 404"
    process = false
  rescue RuntimeError
    puts " Runtime Error - probably a redirect"
    process = false
  end
  
  if !process
    db.query "UPDATE domains SET human_checked = NOW() WHERE id = #{domain[1]}"
  end
}
