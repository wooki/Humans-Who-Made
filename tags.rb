#####################################
# script to check through domains with a humans.txt
# looking for keywords for using in tags
#####################################
require 'rubygems'
require 'mysql'
require 'uri'
require 'timeout'
require 'open-uri'
require 'json'
require 'highscore'

# max no of domains to check each time
max_domains = 300 

# connect
db = Mysql.init
db.options(Mysql::SET_CHARSET_NAME, 'utf8')
db.connect('localhost', 'dbuser', 'thalia', 'humans')

# use the domains in seed order for simplicity
sql =  "(SELECT domains.name, humans.id, domains.description FROM domains INNER JOIN humans on (domains.id = humans.domain_id) ORDER BY humans.last_seed LIMIT 0, #{max_domains})"

humans = db.query sql

# keep track of pairs of domains and tags
tags = Array.new

# check each domain with a humans file
humans.each { | human |
  puts "Human: #{human[0]}"
  begin
  if human[2]    
text = Highscore::Content.new human[2]
text.configure do
  set :multiplier, 2
  set :upper_case, 3
  set :long_words, 2
  set :long_words_threshold, 15
  set :vowels, 1                     # => default: 0 = not considered
  set :consonants, 5                 # => default: 0 = not considered  
  set :ignore_case, true             # => default: false
  set :word_pattern, /[\w]+[^\s0-9][\w]+/ # => default: /\w+/
end 

text.keywords.top(20).each do |keyword|
  puts keyword.text + ": " + keyword.weight.to_s
  tags.push({:domain => human[0], :tag => keyword.text}) if keyword.weight > 5.5
end
  end
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
