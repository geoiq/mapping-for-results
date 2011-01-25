%w{ rubygems sinatra open-uri erb json}.each {|gem| require gem}

require 'helpers'
require 'database'
  
PLATFORM_API_URL = "http://wbstaging.geocommons.com"
SUBDOMAIN="http://wbstaging.geocommons.com"

require "worldbank"
include WorldBank

get '/' do
  @country = Page.first(:shortname => "world")
  @projects ||= WorldBank.get_all_projects
  @financing ||= WorldBank.calculate_financing(@projects["projects"])
  @country.projects_count = @projects["total"]
  erb :index
end

get '/404' do 
  erb :missing
end

get '/500' do 
  erb :missing
end

get '/about' do 
  erb :about
end

get '/projects.csv' do 
  @projects = WorldBank.get_active_projects

  csv_string = FasterCSV.generate do |csv|
    csv << (WorldBank::PROJECT_FIELDS + ["latitude", "longitude"]).flatten

    @projects.each do |pid, project|
      # location_string = project["location"]
      # locations = []
      # location_string.scan(/([\d]{10})\!\$\!([\d\.-]+)\!\$\!([\d\.-]+)\!\$\!([\d\.-]+)\!\$\!([\w]{2})/) {|s| locations << s}
      locations = project["locations"] || []

      rows = WorldBank::PROJECT_FIELDS.collect {|f| f == "mjsector1" ? project[f]["Name"] : project[f] }
      if(locations.length == 0)
        # rows += [project["locations"]["location"]["latitude"], project["locations"]["location"]["longitude"]]
        rows += [0,0]
        csv << rows.flatten
      else
        locations.each do |loc|
          csv <<  (rows + [loc["latitude"], loc["longitude"]]).flatten      
        end
      end
    end
  end

  csv_string
end

get '/map.js' do 
  content_type 'application/javascript', :charset => 'utf-8'
  erb :map, :layout => false
end

get '/:region' do
  @country = @region = Page.first(:shortname => params[:region])
  if(@region.nil?)
    erb :about
  else
    @projects = @country.projects
    @financing ||= WorldBank.calculate_financing(country.projects["projects"], "countryname")
    erb :index
  end
end

get '/:region/update' do
  @country = @region = Page.first(:shortname => params[:region])
  country.project_list = @projects = WorldBank.get_region_data(@region)
  @country.projects_count = @projects["total"]
  country.save
  
  redirect "/#{params[:region]}"
end

get '/productline/:product/charts' do
  @country = @region = {:name => "World", :adm1 => ""}

  @projects = WorldBank.get_product_data(params[:product].upcase)
  @financing ||= WorldBank.calculate_financing(@projects["projects"], "regionname")
  
  @country[:projects_count] = @projects["total"]
  
  erb :charts, :layout => :embed
end

get '/:region/:country' do
  # @region = MAPS[:world][:regions][params[:region].to_sym]
  @region = Page.first(:shortname => params[:region])
  if(@region.nil?)
    erb :about
  else
    @country = Page.first(:shortname => params[:country], :parent_id => @region.id) #@region[:countries][params[:country].to_sym]
    
    erb :index
  end
end

get '/:region/:country/update' do
    @region = Page.first(:shortname => params[:region])
    @country = Page.first(:shortname => params[:country], :parent_id => @region.id) #@region[:countries][params[:country].to_sym]
    @country = WorldBank.get_project_data(@country)
    @country.save
    redirect "/#{params[:region]}/#{params[:country]}"
end
