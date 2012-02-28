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
require 'yaml'

# limit the number of domains checked
max_domains = 25

# html markers
html_markers = YAML::load(File.open('html_markers.yaml'))

# connect
db = Mysql.init
db.options(Mysql::SET_CHARSET_NAME, 'utf8')
db.connect('localhost', 'dbuser', 'thalia', 'humans')

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
lang = ''
lang = homepage.root.root['lang'].downcase if homepage.root.root['lang']
lang = homepage.response['Content-Language'].downcase if homepage.response['Content-Language'] and lang == ''     
metalang = homepage.root.xpath('//meta[@http-equiv="Content-Language"]').first 
lang = metalang['content'].downcase if metalang and metalang['content'] and lang ==''

    if (lang != '' and
        lang != 'en' and
        lang != 'en-gb' and
        lang != 'en-us')
     
       process = false
end
    end
 
    if process
    
      #doc = Nokogiri::HTML(open(url))
      doc = open(url)
      content = doc.read
      
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
begin        
   content = content.encode('utf-8')
rescue Encoding::UndefinedConversionError
   puts " could not convert to utf-8"
end
        if content.gsub(/\s+/, "").strip != ''
        
          # insert new record
          db.query "INSERT INTO humans (domain_id, discovered, checked, txt) VALUES (#{domain[1]}, NOW(), NOW(), '#{Mysql.escape_string content}')"
  
          if title and description
            db.query "UPDATE domains SET lang = '#{lang}', human_checked = NOW(), title = '#{Mysql.escape_string title}', description = '#{Mysql.escape_string description}' WHERE id = #{domain[1]}"
          end        

        else
          puts " blank content"
          process = false
        end
      else
        puts " invalid content"
      	process = false
      end
    else
      puts " None English Content"
      process = false
    end

  rescue Zlib::GzipFile::NoFooter 
    puts " Zlib::GzipFile::NoFooter"
    process = false
  rescue NoMethodError
    puts " NoMethodError"
    process = false
  rescue Net::HTTPBadResponse
    puts " Net::HTTPBadResponse"
    process = false
  rescue Errno::EHOSTUNREACH
    puts " Errno::EHOSTUNREACH"
    process = false
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
