%w{ rubygems m4r/models/page }.each {|gem| require gem}
#HOST = "http://localHOST:4567"
#HOST = "http://wbstaging.geocommons.com"
HOST = "http://worldbank.geoiq.com"
def cache_country(page)
  puts "#{page.name}"
  system "mkdir -p .#{page.url}"
  #system "curl '#{HOST}/isocode/#{page.isocode}.png?height=221&width=545' > .#{page.url}.png"
  system "curl '#{HOST}/isocode/#{page.isocode}.png?height=221&width=545' > isocode/#{page.isocode}.png" unless page.isocode.nil? || page.isocode.length == 0
  system "curl #{HOST}#{page.url} > .#{page.url}.html"
  system "curl '#{HOST}#{page.url}/embed?height=600&width=800' > .#{page.url}/embed.html"
  system "cp .#{page.url}.html .#{page.url}/index.html"
end
%w{script/map.js script/extractives.js 404.html 500.html}.each do |page|
  puts "#{page}"
  system "curl #{HOST}/#{page} > #{page}"
end
=begin
@pages = Page.all :page_type => "page"
@pages.each do |page|
  puts "#{page.name} - #{page.id}"
  next if page.name =~ /BOOST/ 
  puts "curl #{HOST}/#{page.url.gsub(/^\//,'')} > #{page.url.gsub(/^\//,'')}.html"
  system "curl #{HOST}/#{page.url.gsub(/^\//,'')} > #{page.url.gsub(/^\//,'')}.html"
  puts "cp #{page.url.gsub(/^\//,'')}.html about/#{page.url.gsub(/^\//,'')}.html" 
  system "cp #{page.url.gsub(/^\//,'')}.html about/#{page.url.gsub(/^\//,'')}.html" 
end
system "curl #{HOST}/ > index.html"
system "cp index.html world.html"
puts "Starting Regions"
@regions = Page.all :page_type => "region"
@regions.each do |region|
  puts "#{region.name} - #{region.id}"
  system "curl #{HOST}#{region.url} > #{region.shortname}.html"
  system "cp #{region.shortname}.html #{region.shortname}/index.html"
  system "mkdir -p .#{region.url}"
  region.children.each do |country|
    cache_country(country)
  end
end
puts "Regions done"

@pages = Page.all :page_type => "country"
@pages.each do |page|
  cache_country(page)
end

cache_country(Page.first(:name => "Development Marketplace"))
=end
@pages = Page.all :page_type => "project"
@pages.each do |page|
  cache_country(page)
end

