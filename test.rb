#####################################
# check through the latest domains that don't have
# humans, prefer the newest domains.
#####################################

require 'rubygems'
require 'mysql'

# connect
db = Mysql.init
db.options(Mysql::SET_CHARSET_NAME, 'utf8')
db.connect('localhost', 'dbuser', 'thalia', 'humans')

domains = db.query "SELECT title from domains where title like '%Wufoo%';"

domains.each { | domain |

  puts domain[0]

}    
