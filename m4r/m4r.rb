require 'rubygems'
require 'sinatra'

SUBDOMAIN = ""
# MAPS = {
#   :world => {:name => "World", :map => 1, :projects => nil, :region => nil},
#   :haiti => {:name => "Haiti", :map => 2, :projects => 13, :region => "Latin America and Caribbean"},
#   :bolivia => {:name => "Bolivia", :map => 3, :projects => nil, :region => "Latin America and Caribbean"},
#   :kenya => {:name => "Kenya", :map => 4, :projects => nil, :region => "Africa"},
#   :indonesia => {:name => "Indonesia", :map => 5, :projects => nil, :region => "East Asia and Pacific"}
# }


WBSTAGING = {
  :world => {:name => "World", :map => 1, :projects => nil, :regions => {
    :afr => {
      :name => "Africa",
      :zoom => 3, :lat => -4, :lon => 21,
      :countries => {
        :kenya => {:name => "Kenya", :map => 4, :projects => nil, :region => "Africa"}
      }
    },
      :eap => {
        :name => "East Asia and Pacific",
        :zoom => 4, :lat => 19, :lon => 105.5,
        :countries => {
          :phillipines => {:name => "Phillipines", :map => 5, :projects => nil, :region => "East Asia and Pacific"}
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
        :haiti => {:name => "Haiti", :map => 49, :projects => 108, :region => "Latin America and Caribbean"},
        :bolivia => {:name => "Bolivia", :map => 3, :projects => nil, :region => "Latin America and Caribbean"}
      }
      }      
    }
  }
}

LOCAL = {
  :world => {:name => "World", :map => 1, :projects => nil, :regions => {
      :afr => {
        :name => "Africa",
        :zoom => 3, :lat => -4, :lon => 21,
        :countries => {
          :kenya => {:name => "Kenya", :map => 4, :projects => nil, :region => "Africa"}
        }
      },
      :eap => {
        :name => "East Asia and Pacific",
        :zoom => 4, :lat => 19, :lon => 105.5,
        :countries => {
          :phillipines => {:name => "Phillipines", :map => 5, :projects => nil, :region => "East Asia and Pacific"}
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
        :haiti => {:name => "Haiti", :map => 124, :projects => 1591, :region => "Latin America and Caribbean"},
        :bolivia => {:name => "Bolivia", :map => 3, :projects => nil, :region => "Latin America and Caribbean"}
      }
      }      
    }
  }
}

PLATFORM_API_URL = "http://wbstaging.geocommons.com"
# PLATFORM_API_URL = "http://geoiq.local"
MAPS = PLATFORM_API_URL =~ /geocommons/ ? WBSTAGING : LOCAL 

require 'erb'

get '/' do
  @country = MAPS[:world]
  erb :index
end

get '/:region/:country' do
  @region = MAPS[:world][:regions][params[:region].to_sym]
  @country = @region[:countries][params[:country].to_sym]
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
    link = %Q{<a class="breadcrumb-link" href="#{SUBDOMAIN}/" title='World Bank: World'>World</a>}    
    unless @country[:region].nil?
      link += %Q{<a class="breadcrumb-link" href="#{SUBDOMAIN}/#region:#{@country[:region].gsub(/ /,'').downcase}">#{@country[:region]}</a><span class="breadcrumb-link breadcrumb-last"><a class="active" href="#">#{@country[:name]}</a></span>}
    end
    link
  end  
end