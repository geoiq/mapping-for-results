require 'rubygems'
require 'sinatra'

# PLATFORM_API_URL = "http://wbstaging.geocommons.com"
# SUBDOMAIN = ""
# MAPS = {
#   :world => {:name => "World", :map => 1, :projects => nil, :region => nil},
#   :haiti => {:name => "Haiti", :map => 2, :projects => 13, :region => "Latin America and Caribbean"},
#   :bolivia => {:name => "Bolivia", :map => 3, :projects => nil, :region => "Latin America and Caribbean"},
#   :kenya => {:name => "Kenya", :map => 4, :projects => nil, :region => "Africa"},
#   :indonesia => {:name => "Indonesia", :map => 5, :projects => nil, :region => "East Asia and Pacific"}
# }

PLATFORM_API_URL = "http://geoiq.local"
SUBDOMAIN = ""
MAPS = {
  :world => {:name => "World", :map => 1, :projects => nil, :region => nil},
  :haiti => {:name => "Haiti", :map => 124, :projects => 1591, :region => "Latin America and Caribbean"},
  :bolivia => {:name => "Bolivia", :map => 3, :projects => nil, :region => "Latin America and Caribbean"},
  :kenya => {:name => "Kenya", :map => 4, :projects => nil, :region => "Africa"},
  :indonesia => {:name => "Indonesia", :map => 5, :projects => nil, :region => "East Asia and Pacific"}
}

require 'erb'

get '/' do
  @country = MAPS[:world]
  erb :index
end

get '/:country' do
  @country = MAPS[params[:country].to_sym]
  erb :index
end

helpers do
  # Embed a page partial
  # Usage: partial :foo
  def partial(page, options={})
    erb page, options.merge!(:layout => false)
  end
  
  # Create the link to the country in the footer
  # 
  # e.g Map / World / Latin America and Caribbean / Haiti
  def map_link(country, options={})
    link = "Map / "
    link += "<a href=\"#{SUBDOMAIN}/\" title='World Bank: World'>World</a>"
    unless @country[:region].nil?
      link += " / <a href=\"#{SUBDOMAIN}/#region:#{@country[:region].gsub(/ /,'').downcase}\">#{@country[:region]}</a> / #{@country[:name]}"
    end
    link
  end  
end