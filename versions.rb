#####################################
# check through the domians that do have
# humans - prefer ones that were checked longest ago
#####################################

require 'rubygems'
require 'mysql'
require 'uri'
require 'open-uri'
require 'net/http'
require 'nokogiri'

# html markers
html_markers = ['not found', 'does not exist', 'Page not found', '<META', '<script', '<SCRIPT', '<html>', '<HTML', '<!DOC', '<pre', '<html ', '<head ', '<body', '<p>', '<p ', '<a ', '<br>', '<br />']

# connect
db = Mysql.new('localhost', 'dbuser', 'thalia', 'humans')

# get humans, 
domains = db.query "SELECT domains.name, humans.id, humans.txt FROM humans INNER JOIN domains ON (humans.domain_id = domains.id) ORDER BY checked LIMIT 0, 25"

domains.each { | domain |
#  puts "domain: #{domain[0]}"
  
  url = "http://#{domain[0]}/humans.txt"
  
  begin
    
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
      
      if content.strip != domain[2].strip
 
puts "Updated Human: #{domain[0]}"     
        # copy the existing record into the "versions"
        db.query "INSERT INTO human_versions (domain_id, last_seen, txt) SELECT domain_id, checked, txt FROM humans WHERE id = #{domain[1]}"
        
        # update the existing record
        db.query "UPDATE humans SET checked = NOW(), txt = '#{db.escape_string content}' WHERE id = #{domain[1]}"
      
      else
#        puts " same content"
      end
            
    else
#      puts " invalid content"
    end
   
  rescue Mysql::Error
    puts " Mysql::Error "
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
