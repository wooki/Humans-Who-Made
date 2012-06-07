#####################################
# script to check through domains with a humans.txt
# looking for keywords for using in tags
#####################################
require 'rubygems'
require 'mysql'
require 'uri'
require 'timeout'

# max no of domains to check each time
max_domains = 10 

# connect
db = Mysql.init
db.options(Mysql::SET_CHARSET_NAME, 'utf8')
db.connect('localhost', 'dbuser', 'thalia', 'humans')

# use the domains in seed order for simplicity
sql =  "(SELECT domains.name, humans.id FROM domains INNER JOIN humans on (domains.id = humans.domain_id) ORDER BY humans.last_seed LIMIT 0, #{max_domains})"

humans = db.query sql

# keep track of pairs of domains and tags
tags = Array.new

# check each domain with a humans file
humans.each { | human |
  puts "Human: #{human[:name]}"
  begin
    Timeout::timeout(30) {
      
      # load json from http://uridata.com/
      
      
      #tags.push({:domain => domain, :tag => tag) tag and tag.strip != ''
            
    }
  rescue Timeout::Error
    puts " Timeout::Error"
  rescue ArgumentError
  rescue URI::InvalidComponentError
    # puts " URI::InvalidComponentError #{seed[0]}"
  rescue URI::InvalidURIError
    # puts " URI::InvalidURIError #{seed[0]}"
  end
}
  
  # create tags (ignore tags unless they start with a word character)
tags.each { | tag |
  tag[:tag] = tag[:tag].encode('utf-8')
  puts "#{tag[:tag]} -> #{tag[:domain]}"
  db.query "INSERT IGNORE INTO tags (name) VALUES ('#{Mysql.escape_string tag[:tag].strip}')"
  db.query "INSERT IGNORE INTO domain_tags (domain_id, tag_id) VALUES ((SELECT domains.id FROM domains WHERE domains.name = '#{Mysql.escape_string tag[:domain]}'), (SELECT tags.id FROM tags WHERE tags.name = '#{Mysql.escape_string tag[:tag].strip}'))"
}
