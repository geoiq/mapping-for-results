require 'rubygems'
require 'sinatra'

PLATFORM_API_URL = "http://wbstaging.geocommons.com"
# PLATFORM_API_URL = "http://geoiq.local"
SUBDOMAIN = ""
# MAPS = {
#   :world => {:name => "World", :map => 1, :region => nil},
#   :haiti => {:name => "Haiti", :map => 2, :projects => 13, :region => "Latin America and Caribbean"},
#   :bolivia => {:name => "Bolivia", :map => 3, :region => "Latin America and Caribbean"},
#   :kenya => {:name => "Kenya", :map => 4, :region => "Africa"},
#   :indonesia => {:name => "Indonesia", :map => 5, :region => "East Asia and Pacific"}
# }


WBSTAGING = {
  :world => {:name => "World", :map => 1, :regions => {
    :afr => {
      :name => "Africa",
      :zoom => 3, :lat => -4, :lon => 21,
      :countries => {
        :kenya => {:name => "Kenya", :map => 255, :region => "Africa", :status => "active"}
      }
    },
      :eap => {
        :name => "East Asia and Pacific",
        :zoom => 4, :lat => 19, :lon => 105.5,
        :countries => {
          :philippines => {:name => "Philippines", :map => 263, :region => "East Asia and Pacific", :status => "inactive"}
        }
    },
      :eca => {
        :name => "Europe and Central Asia",
        :zoom => 4, :lat => 42.68, :lon => 68.90,
        :countries => {}
      },
      :mena => {
        :name => "Middle East and North Africa",
        :zoom => 4, :lat => 26.1, :lon => 25.7,
        :countries => {}
      },
      :sar => {
        :name => "South Asia",
        :zoom => 4, :lat => 15.5, :lon => 91.8,
        :countries => {}
      },                
    :lac =>  {
      :name => "Latin America and Caribbean",
      :zoom => 3, :lat => -25, :lon => -57.8,
      :countries => {
        :haiti => {:name => "Haiti", :map => 114, :projects => 108, :region => "Latin America and Caribbean", :status => "active", :adm1  => 
          [{ :name => "Grand-Anse", :zoom => 11, :lat => 18.53, :lon => -74.13},
            {:name => "Sud", :zoom => 10, :lat => 18.272, :lon => -73.72},
            {:name => "Nippes", :zoom => 10, :lat => 18.45, :lon => -73.313},
            {:name => "Sud-Est", :zoom => 10, :lat => 18.277, :lon => -72.369},
            {:name => "Ouest", :zoom => 10, :lat => 18.45, :lon => -72.266},
            {:name => "Centre", :zoom => 10, :lat => 18.98, :lon => -71.95},
            {:name => "Artibonite", :zoom => 11, :lat => 18.16, :lon => -72.53},
            {:name => "Nord-Est", :zoom => 11, :lat => 18.455, :lon => -71.9},
            {:name => "Nord", :zoom => 11, :lat => 19.577, :lon => -72.29},
            {:name => "Nord-Ouest", :zoom => 11, :lat => 19.65, :lon => -72.86},
            ]},
        :bolivia => {:name => "Bolivia", :map => 262, :region => "Latin America and Caribbean", :status => "active"}
      }
      }      
    }
  }
}

LOCAL = {
  :world => {:name => "World", :map => 1, :regions => {
      :afr => {
        :name => "Africa",
        :zoom => 3, :lat => -4, :lon => 21,
        :countries => {
          :kenya => {:name => "Kenya", :map => 4, :region => "Africa"}
        }
      },
      :eap => {
        :name => "East Asia and Pacific",
        :zoom => 4, :lat => 19, :lon => 105.5,
        :countries => {
          :phillipines => {:name => "Phillipines", :map => 5, :region => "East Asia and Pacific"}
        }
    },
      :eca => {
        :name => "Europe and Central Asia",
        :zoom => 4, :lat => 42.68, :lon => 68.90,
        :countries => {}
      },
      :mena => {
        :name => "Middle East and North Africa",
        :zoom => 4, :lat => 26.1, :lon => 25.7,
        :countries => {}
      },
      :sar => {
        :name => "South Asia",
        :zoom => 4, :lat => 15.5, :lon => 91.8,
        :countries => {}
      },            
    :lac =>  {
      :name => "Latin America and Caribbean",
      :zoom => 3, :lat => -25, :lon => -57.8,
      :countries => {
        :haiti => {:name => "Haiti", :map => 124, :projects => 1591, :region => "Latin America and Caribbean", :adm1  => 
          [{ :name => "Grand-Anse", :zoom => 11, :lat => 18.53, :lon => -74.13},
            {:name => "Sud", :zoom => 10, :lat => 18.28, :lon => -74.74},
            {:name => "Nippes", :zoom => 10, :lat => 18.41, :lon => -74.434},
            {:name => "Sud-Est", :zoom => 10, :lat => 18.277, :lon => -72.369},
            {:name => "Ouest", :zoom => 10, :lat => 18.45, :lon => -72.266},
            {:name => "Centre", :zoom => 10, :lat => 18.98, :lon => -71.95},
            {:name => "Artibonite", :zoom => 11, :lat => 18.16, :lon => -72.53},
            {:name => "Nord-Est", :zoom => 11, :lat => 18.455, :lon => -71.9},
            {:name => "Nord", :zoom => 11, :lat => 19.577, :lon => -72.29},
            {:name => "Nord-Ouest", :zoom => 11, :lat => 19.65, :lon => -72.86},
            ]},
        :bolivia => {:name => "Bolivia", :map => 3, :region => "Latin America and Caribbean"}
      }
      }      
    }
  }
}

SECTORS = {
  :public => {:name => "Public administration Law, Justice"},
  :agriculture => {:name => "Agriculture, fishing, forestry"},
  :health => {:name => "Health, other Social"},
  :communications => {:name => "Communications"},
  :energy => {:name => "Energy, Mining"},
  :finance => {:name => "Finance"},
  :industry => {:name => "Industry, trade"},
  :transporation => {:name => "Transportation"},
  :water => {:name => "Water, Sanitation, flood protection"},
  :education => {:name => "Education"}
  }


MAPS = PLATFORM_API_URL =~ /geocommons/ ? WBSTAGING : LOCAL 

require 'erb'

get '/' do
  @country = MAPS[:world]
  erb :index
end

get '/about' do 
  erb :about
end

get '/map.js' do 
  erb :map
end

get '/:region/:country' do
  @region = MAPS[:world][:regions][params[:region].to_sym]
  if(@region.nil?)
    erb :about
  else
    @country = @region[:countries][params[:country].to_sym]
    erb :index
  end
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
    link = %Q{<a class="breadcrumb-link" href="#{SUBDOMAIN}/" title='World Bank: World'>World</a>}    
    unless @country[:region].nil?
      link += %Q{<a class="breadcrumb-link" href="#{SUBDOMAIN}/#region:#{@country[:region].gsub(/ /,'').downcase}">#{@country[:region]}</a><span class="breadcrumb-link breadcrumb-last"><a class="active" href="#">#{@country[:name]}</a></span>}
    end
    link
  end  
end