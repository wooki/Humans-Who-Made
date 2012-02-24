#####################################
# check existing domains against a regex
# that we want to ignore - or in this case
# remove from the database
#####################################
require 'rubygems'
require 'mysql'

# regex of domains that we want to ignore
ignore_domains = /((\w+\.)?google\.\w\w\w?\.\w+)|((\w+\.)?google\.(?!com))/i

# connect
db = Mysql.new('localhost', 'dbuser', 'thalia', 'humans')

# load all domains
domains = db.query "SELECT * FROM domains"
domains.each { | domain |
  
  # check if allowed
  if domain[1] =~ ignore_domains
    
    puts "remove: #{domain[1]}"
    db.query("DELETE FROM domain_tags WHERE domain_id = #{domain[0]}")
    db.query("DELETE FROM human_versions WHERE domain_id = #{domain[0]}")
    db.query("DELETE FROM humans WHERE domain_id = #{domain[0]}")
    db.query("DELETE FROM domains WHERE id = #{domain[0]}")  
  end

}

# load all tags and remove any that don't start with a word character
tags = db.query "SELECT id, name FROM tags"
tags.each { | tag |

  if !(tag[1] =~ /^\w/)
    puts "remove tag: #{tag[1]}"
    db.query "DELETE FROM domain_tags where tag_id = #{tag[0]}"
    db.query "DELETE FROM tags where id = #{tag[0]}"
  end
}



