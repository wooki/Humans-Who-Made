#####################################
# check existing domains against a regex
# that we want to ignore - or in this case
# remove from the database
#####################################
require 'rubygems'
require 'mysql'

html_markers = ['Page not found', '<META', '<script', '<SCRIPT', '<html>', '<HTML', '<!DOC', '<pre', '<html ', '<head ', '<body', '<p>', '<p ', '<a ', '<br>', '<br />']

# connect
db = Mysql.new('localhost', 'root', 'atreides', 'humans')

# load all domains
humans = db.query "SELECT domain_id, txt FROM humans"
humans.each { | human |
  
  # check if allowed
  html_markers.each { | marker |
    if human[1].include? marker or human[1].gsub(/\s+/, '').strip == ''   
      puts "remove: #{human[0]}"
      db.query("DELETE FROM domain_tags WHERE domain_id = #{human[0]}")
      db.query("DELETE FROM human_versions WHERE domain_id = #{human[0]}")
      db.query("DELETE FROM humans WHERE domain_id = #{human[0]}")
      db.query("DELETE FROM domains WHERE id = #{human[0]}")  
    end
  }
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



