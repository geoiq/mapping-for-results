%w{ rubygems sinatra/base open-uri erb json net/http}.each {|gem| require gem}

require 'helpers'
require 'models/page'
require 'lib/m4r_extensions.rb'
  
PLATFORM_API_URL  = "http://maps.worldbank.org"
DEVELOPMENT_API_URL = "http://wbstaging.geocommons.com"
# PRODUCTION_PATH = "/fortiusone/live/apps/geoiq/current/public/"
PRODUCTION_PATH = "../"
# PLATFORM_API_URL = "http://geoiq.local"

require "worldbank"
include WorldBank

# require 'sinatra/cache'

class MappingForResults < Sinatra::Base
  # register(Sinatra::Cache)
  # set :cache_enabled, true  # turn it on 
  # set :cache_output_dir, "/Users/ajturner/Projects/fortiusone/customers/WorldBank/wb-new/m4r/cache"
    
  # set :sessions, true
  # enable :sessions
  # set :reload_templates, true 

  helpers Sinatra::GeoiqHelper, Sinatra::PartialHelper, Sinatra::MappingHelper
  
  get '/' do
    @page = Page.first(:shortname => "world")
    @projects = @page.data[:projects]
    @financing = @page.data[:financing]
    
    # cache(erb :index)
    # headers 'Last-Modified' => @page.sync_updated_at.httpdate
    erb :index    
  end

  get '/world' do
    redirect '/'
  end

  not_found do
    erb :missing
  end
  error do
    erb :missing
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
  get '/countries.csv' do 
    @countries = WorldBank.get_country_projects

    csv_string = FasterCSV.generate do |csv|
      csv << (["countrycode","count"]).flatten
      @countries.each do |countrycode, count|
        csv << [countrycode, count]
      end
    end
    csv_string
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

  get '/script/:name.js' do 
    content_type 'application/javascript', :charset => 'utf-8'
    # cache(erb :map, :layout => false)

    headers 'Last-Modified' => Time.now.httpdate

    erb params[:name].to_sym, :layout => false    
  end

  # 
  # Admin
  # 

  get "/login" do 
    erb :login
  end

  post "/login" do
    if(login(PLATFORM_API_URL, params[:username], params[:password]))
      session[:username] = params[:username]
    end
  
    redirect "/admin"
  end

  get "/logout" do
    session[:f1_session_auth] = nil
    redirect "/"
  end

  before '/admin|/admin/*' do 
      # pass unless !authorized?
      # halt "<a href='/login'>Please Login</a>"
      redirect "/login" if(session == nil || session[:f1_session_auth] == nil)
  end
  
  get '/admin' do
      @pages = Page.all(:parent => nil)
      @page = Page.new
      erb :admin
  end
  get '/admin/:name/edit' do
      @page = Page.first(:id => params[:name])
      @page = Page.first(:shortname => params[:name]) if @page.nil?
      erb :edit
  end

  delete '/admin/:id' do
      @page = Page.get(params[:id])
      @page.destroy unless @page.nil?
      redirect "/admin"
  end
  get '/admin/:id/deploy' do
    host = DEVELOPMENT_API_URL
    path = PRODUCTION_PATH
    page = Page.get(params[:id])
    system "mkdir -p #{path}#{page.url}"
    system "curl #{host}#{page.url} > #{path}#{page.url}.html"
    system "curl '#{host}#{page.url}/embed?height=600&width=800' > #{path}#{page.url}/embed.html"
    system "cp #{path}#{page.url}.html #{path}#{page.url}/index.html"
    system "/usr/bin/git add #{path}#{page.url}.html #{path}#{page.url}/embed.html #{path}#{page.url}/index.html"
    system "/usr/bin/git pull"
    system "/usr/bin/git commit -m 'User update of #{page.url}'"
    system "/usr/bin/git push origin production"
    redirect "/admin/#{page.id}/edit"
  end
  get '/admin/new' do
      # @region = MAPS[:world][:regions][params[:region].to_sym]
      @page = Page.new
      erb :edit
  end

  get '/admin/all/sync' do
    Page.all(:page_type => "country").each {|p| p.update_data!}
    Page.all(:page_type => "region").each {|p| p.update_data!}
    Page.all(:page_type => "world").each {|p| p.update_data!}
    redirect "/admin"    
  end
  get '/admin/:shortname/sync' do
      @page = Page.first(:id => params[:shortname])
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

      @region = params[:page][:region].length == 0 ? nil : Page.get(params[:page][:region])
      @page.parent = @region
      @page.region = @region.name unless @region.nil?
      @page.save
      # cache_expire(@page.url)
      redirect "/admin/#{@page.id}/edit"
  end


  # 
  # Pages
  # 

  
  get '/:page' do
    @page = Page.first(:shortname => params[:page].downcase, :page_type => "page")
    pass if @page.nil?
    erb :about
  end
  
  get '/about/:page' do
    redirect "/about" if params[:page] == "about"
    @page = Page.first(:shortname => params[:page].downcase)
    erb :about
  end

  get '/:region' do
    @region = @page = Page.first(:shortname => params[:region].downcase)
puts "REgion!"
puts params[:region]
puts @region.name
    pass if @region.nil?
    if(params[:region] == "boost")
	    @title = "BOOST Initiative"
	    @additional_controls = nil
    end

    if(@page.nil?)
      erb :about
    elsif(@page.page_type == "page")
      erb :about
    else
      # headers 'Last-Modified' =>( @page.sync_updated_at || Time.now).httpdate
      @projects = @page.data[:projects]
      @financing  = @page.data[:financing]
      erb :index
    end
  end


  get '/productline/:product/charts' do
    @page = {:name => "World", :adm1 => "", :page_type => "productline"}

    @projects = WorldBank.get_product_data(params[:product].upcase)
    @financing ||= WorldBank.calculate_financing(@projects["projects"], "regionname")
  
    puts @projects.inspect
    @page[:projects_count] = @projects["total"]

    erb :charts, :layout => :embed
  end
  get '/:region/:country/embed' do
    # @region = MAPS[:world][:regions][params[:region].to_sym]
    @region = Page.first(:shortname => params[:region].downcase)
    @page = Page.first(:shortname => params[:country].downcase) #@region[:countries][params[:country].to_sym]
    @projects = @page.data[:projects]
    
    @page_subtitle = [@page[:name],@page[:region]].compact.join(", ") + " > "
    @embed = true
    erb :map_embed, :layout => :embed 
  end
  get '/:region/:country/:project/embed' do
    # @region = MAPS[:world][:regions][params[:region].to_sym]
    @region = Page.first(:shortname => params[:region].downcase)
    @page = Page.first(:shortname => params[:project].downcase) #@region[:countries][params[:country].to_sym]
    @projects = @page.data[:projects]
    
    @page_subtitle = [@page[:name],@page[:region]].compact.join(", ") + " > "
    @embed = true
    erb :map_embed, :layout => :embed 
  end
  
  get '/:region/:country' do
    # @region = MAPS[:world][:regions][params[:region].to_sym]
    @region = Page.first(:shortname => params[:region].downcase)
    if(@region.nil?)
      erb :about
    else
      @page = Page.first(:shortname => params[:country].downcase) #@region[:countries][params[:country].to_sym]
      redirect "/#{params[:region]}" if @page.nil?
      @projects = @page.data[:projects]
      
      @page_subtitle = [@page[:name],@page[:region]].compact.join(", ") + " > "
      
      # headers 'Last-Modified' =>( @page.sync_updated_at || Time.now).httpdate
      if(params[:embed] && params[:embed].to_s == "true")
        erb :map_embed, :layout => :embed
      elsif(@page.page_type == "country")
        erb :full, :layout => false
      elsif(@page.page_type == "page")
        erb :about
      else
        erb :index
      end
    end
  end
  get '/boost/:region/:country' do 
    @page = Page.last(:shortname => params[:country].downcase)
    @title = "BOOST Initiative"
    @additional_controls = nil
    @show_sidebar = false
    erb :full, :layout => false
  end
  get '/extractives/:region/:country' do 
    @page = Page.last(:shortname => params[:country].downcase)
    @additional_controls = :extractives_controls
    @title = "Mapping the Extractive Industries"
    erb :full, :layout => false
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
