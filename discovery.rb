#####################################
# script to check through domains with a humans.txt
# looking for links to other domains - if there are
# no known domains then use a default list.
#####################################
require 'rubygems'
require 'mysql'
require 'anemone'
require 'uri'

# max no of domains to check each time
max_domains = 5

# regex of domains that we want to ignore - in this case googles many not .com domains!
ignore_domains = /((\w+\.)?google\.\w\w\w?\.\w+)|((\w+\.)?google\.(?!com))/i

# connect
db = Mysql.new('localhost', 'root', 'atreides', 'humans')

# arrays of seed and new domains
seed_domains = Array.new
discovered_domains = Array.new

# use the domains that already have humans as seeds
humans = db.query "SELECT domains.name, humans.id FROM domains inner join humans on (domains.id = humans.domain_id) ORDER BY humans.last_seed LIMIT 0, #{max_domains}"
if humans.num_rows > 0
  seed_domains = humans  
else
  # if we have no humans use a default set of domains
  seed_domains.push ["www.jimcode.org", nil ]
end

# keep track of pairs of domains and tags
tags = Array.new

# iterate domains spidering each one and collecting a list of domains
# that it links to
seed_domains.each { | seed |
  
  db.query "UPDATE humans SET last_seed = NOW() WHERE id = #{seed[1]}" if seed[1]
  puts "Anemone is spidering #{seed[0]}"
  
  begin
    Anemone.crawl("http://#{seed[0]}", {:threads => 1, :depth_limit => 1}) do | anemone |
      anemone.on_every_page { | page |
        if page.doc
          
          # collect links
          page.doc.xpath('//a').each { | element |
            href = element.attr('href')
            tag = element.content
            if href
              domain = URI.parse(URI.escape href.strip).host
              tags.push({:domain => domain, :tag => tag[0, 100]}) if domain != seed[0] and tag and tag.strip != '' and domain and domain.strip != '' and !tag.include? "http"
              if domain and domain.strip != ''
                subdomains = domain.split(/\.|\//)
                subdomains.each { | subdomain |
#                  puts "tag: #{subdomain}"
                  tags.push({:domain => domain, :tag => subdomain[0, 100]}) if domain != seed[0] and subdomain and subdomain.strip != ''
                }
              end
              
              if domain and domain.strip != '' and !discovered_domains.include? domain
#                puts "href: #{URI.escape href.strip}"            
                discovered_domains.push domain              
              end            
            end
          }
          
        end      
      }
    end
  rescue URI::InvalidURIError
#    puts " URI::InvalidURIError #{seed[0]}"
  end
}

# save each discovered domain to the database unless it is already there
discovered_domains.each { | domain |
if !(domain =~ ignore_domains)
  db.query "INSERT IGNORE INTO domains (name, discovered) VALUES ('#{Mysql.escape_string domain}', NOW())"
end  
}

# create tags (ignore tags unless they start with a word character)
tags.each { | tag |
if !(tag[:domain] =~ ignore_domains) and tag[:tag] =~ /^\w/
  db.query "INSERT IGNORE INTO tags (name) VALUES ('#{Mysql.escape_string tag[:tag].strip}')"
  db.query "INSERT IGNORE INTO domain_tags (domain_id, tag_id) VALUES ((SELECT domains.id FROM domains WHERE domains.name = '#{Mysql.escape_string tag[:domain]}'), (SELECT tags.id FROM tags WHERE tags.name = '#{Mysql.escape_string tag[:tag].strip}'))"
end
}
