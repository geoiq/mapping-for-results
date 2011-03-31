%w{ rubygems sinatra/base open-uri erb json}.each {|gem| require gem}

require 'helpers'
require 'models/page'
require 'lib/m4r_extensions.rb'
  
PLATFORM_API_URL  = "http://maps.worldbank.org"
SUBDOMAIN         = "http://maps.worldbank.org"
# PLATFORM_API_URL = "http://geoiq.local"
# SUBDOMAIN        = "http://geoiq.local"

require "worldbank"
include WorldBank
# WorldBank.build_page_database(MAPS)

# require 'sinatra/cache'

class MappingForResults < Sinatra::Base
  # register(Sinatra::Cache)
  # set :cache_enabled, true  # turn it on 
  # set :cache_output_dir, "/Users/ajturner/Projects/fortiusone/customers/WorldBank/wb-new/m4r/cache"
    
  helpers Sinatra::PartialHelper, Sinatra::MappingHelper
  
  get '/' do
    @page = Page.first(:shortname => "world")
    @projects = @page.data[:projects]
    @financing = @page.data[:financing]
    
    # cache(erb :index)
    erb :index    
  end

  get '/world' do
    @page = Page.first(:shortname => "world")
    @projects = @page.data[:projects]
    @financing = @page.data[:financing]
  
    @pages = Page.all( {:conditions => {:page_type => "country"}, :order => [:name.desc]})
  
    erb :home
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
    # cache(erb :map, :layout => false)
    erb :map, :layout => false    
  end

  # 
  # Admin
  # 

  get '/admin' do
      @pages = Page.all(:parent => nil)
      @page = Page.new
      erb :admin
  end
  get '/admin/:name/edit' do
      @page = Page.first(:shortname => params[:name])
      puts @page.data.keys
      erb :edit
  end

  get '/admin/new' do
      # @region = MAPS[:world][:regions][params[:region].to_sym]
      @page = Page.new
      erb :edit
  end

  get '/admin/:shortname/sync' do
      @page = Page.first(:shortname => params[:shortname])
      @page.update_data!
      redirect "/admin"
  end

  post '/admin/:id/update' do
      @id = params.delete("id")
      unless @id.nil? || @id == "new"
          @page = Page.get(@id)
          @page.update(params[:page])
      else
          @page = Page.first_or_create(params[:page])
      end
      # Memory pointers and serialization or something with DataMapper.
      data = {}
      params[:data].each do |k,v|
        data[k.to_sym] = params[:data][k].length == 0 ? nil : JSON.parse(params[:data][k])
      end

      @page.data = @page.data.merge(data)

      @region = Page.first(:name => params[:page][:region])
      @page.parent = @region    
      @page.save
      # cache_expire(@page.url)
      redirect "/admin/#{@page.shortname}/edit"    
  end


  # 
  # Pages
  # 

  get '/:region' do
    @region = @page = Page.first(:shortname => params[:region].downcase)
    if(@page.nil?)
      erb :about
    elsif(@page.page_type == "page")
      erb :wiki
    else
      @projects = @page.data[:projects]
      @financing  = @page.data[:financing]
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
    @region = Page.first(:shortname => params[:region].downcase)
    if(@region.nil?)
      erb :about
    else
      @page = Page.first(:shortname => params[:country].downcase) #@region[:countries][params[:country].to_sym]
      @projects = @page.data[:projects]
      
      if(params[:full].to_i == 1)
        # cache(erb :country)
        erb :full, :layout => false
      else
        erb :index
      end
    end
  end

  get '/:region/:country/:shortname' do
    # @region = MAPS[:world][:regions][params[:region].to_sym]
    @page = Page.first(:shortname => params[:shortname].downcase)
    if(@page.nil?)
      erb :about
    else
      erb :index # @page.page_type.to_sym
    end
  end
end
