%w{ rubygems m4r/models/page }.each {|gem| require gem}
#host = "http://localhost:4567"
host = "http://wbstaging.geocommons.com"
%w{map.js 404.html 500.html}.each do |page|
  puts "#{page}"
  system "curl #{host}/#{page} > #{page}"
end
@pages = Page.all :page_type => "page"
@pages.each do |pages|
  puts "#{pages.name}"
  system "curl #{host}#{page.url} > about/#{page.url}.html"
end

@regions = Page.all :page_type => "region"
@regions.each do |region|
  puts "#{region.name}"
  system "mkdir -p .#{region.url}"
end
@pages = Page.all
@pages.each do |page|
  puts "#{page.name}"
  system "mkdir -p .#{page.url}"
  system "curl #{host}#{page.url} > .#{page.url}.html"
  system "cp .#{page.url}.html .#{page.url}/index.html"
end
