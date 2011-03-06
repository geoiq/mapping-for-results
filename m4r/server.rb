%w{ rubygems sinatra open-uri erb json}.each {|gem| require gem}

require 'helpers'
require 'models/page'
  
PLATFORM_API_URL  = "http://maps.worldbank.org"
SUBDOMAIN         = "http://maps.worldbank.org"
# PLATFORM_API_URL = "http://geoiq.local"
# SUBDOMAIN        = "http://geoiq.local"

require "worldbank"
include WorldBank
# WorldBank.build_page_database(MAPS)

get '/' do
  @page = Page.first(:shortname => "world")
  @projects = @page.data[:projects]
  @financing = @page.data[:financing]
    
  erb :index
end

get '/404' do 
  erb :missing
end

get '/500' do 
  erb :missing
end

# get '/about' do 
#   erb :about
# end

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

# 
# Admin
# 

get '/admin' do
    @pages = Page.all(:parent_id => nil)
    @page = Page.new
    erb :admin
end
get '/admin/:name/edit' do
    # @region = MAPS[:world][:regions][params[:region].to_sym]
    @page = Page.first(:shortname => params[:name])
    erb :edit
end

get '/admin/new' do
    # @region = MAPS[:world][:regions][params[:region].to_sym]
    @page = Page.new
    erb :edit
end

get '/admin/:shortname/sync' do
    @page = Page.first(:shortname => params[:shortname])
    case @page.page_type
    when "world"
        @projects  = WorldBank.get_all_projects
        @financing = WorldBank.calculate_financing(@projects["projects"])
        @page.projects_count = @projects["total"]
        @page.data = {:projects => @projects["projects"], :financing => @financing }
    when "region"
        @projects = WorldBank.get_region_data(@page)
        @page.projects_count = @projects["total"]
        @financing = WorldBank.calculate_financing(@projects, "countryname")
        @page.data = {:projects => @projects, :financing => @financing }
    when "country"
        @projects = WorldBank.get_project_data(@page)
        @page.data = { :projects => @projects }
    end
    @page.projects_count = @page.data[:projects].length
    @page.sync_updated_at = Time.now
    @page.save
    redirect "/admin"
end

post '/admin/:id/update' do
    puts params.inspect
    @id = params.delete("id")
    puts "Updating: '#{@id}'"
    unless @id.nil? || @id == "new"
        @page = Page.get(@id)
        @page.update_attributes(params[:page])
    else
        @page = Page.first_or_create(params[:page])
    end
    @region = Page.first(:name => params[:page][:region])
    puts "Region? #{@region.inspect}"
    @page.parent = @region
    @page.save
    puts "Country: #{@page.inspect}"
    redirect "/admin"    
end


# 
# Pages
# 

get '/:region' do
  @region = @page = Page.first(:shortname => params[:region])
  if(@page.nil?)
    erb :about
  elsif(@page.page_type == "page")
    erb :wiki
  else
    @projects = @page.projects[:projects]
    @financing  = @page.projects[:financing]
    erb :index
  end
end


get '/productline/:product/charts' do
  @region = {:name => "World", :adm1 => ""}

  @projects = WorldBank.get_product_data(params[:product].upcase)
  @financing ||= WorldBank.calculate_financing(@projects["projects"], "regionname")
  
  @page[:projects_count] = @projects["total"]
  
  erb :charts, :layout => :embed
end

get '/:region/:country' do
  # @region = MAPS[:world][:regions][params[:region].to_sym]
  @region = Page.first(:shortname => params[:region])
  if(@region.nil?)
    erb :about
  else
    @page = Page.first(:shortname => params[:country]) #@region[:countries][params[:country].to_sym]
    @projects = @page.data[:projects]
    puts @projects.first.inspect
    erb :index
  end
end

get '/:region/:country/:shortname' do
  # @region = MAPS[:world][:regions][params[:region].to_sym]
  @page = Page.first(:shortname => params[:shortname])
  if(@page.nil?)
    erb :about
  else
    erb @page.page_type.to_sym
  end
end

