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
  :world => {:name => "World", :map => 353, :projects_count => 1517, :locations_count => 12000, :regions => {
    :afr => {
      :name => "Africa",
      :zoom => 3, :lat => -4, :lon => 21,
      :countries => {
        :kenya => {:name => "Kenya", :map => 255, :region => "Africa", :status => "active",
                      :projects_count => 37, :locations_count => 231, 
            :results => [{:name  => "Country Profile", :link => "http://web.worldbank.org/WBSITE/EXTERNAL/COUNTRIES/AFRICAEXT/KENYAEXTN/0,,menuPK:356520~pagePK:141132~piPK:141107~theSitePK:356509,00.html"},
                {:name => "World Bank Approves US$100 Million Credit for Kenya’s Health Sector", :link => "http://web.worldbank.org/WBSITE/EXTERNAL/COUNTRIES/AFRICAEXT/KENYAEXTN/0,,contentMDK:22632909~menuPK:50003484~pagePK:2865066~piPK:2865079~theSitePK:356509,00.html"},
                {:name => "World Bank Approves US$154.5 Million to Support Poorest People in Western Kenya", :link => "http://web.worldbank.org/WBSITE/EXTERNAL/COUNTRIES/AFRICAEXT/KENYAEXTN/0,,contentMDK:21275229~menuPK:356530~pagePK:2865066~piPK:2865079~theSitePK:356509,00.html"}],
                    :indicators => ["Population","Poverty","Infant Mortality","Maternal Health","Malnutrition"]}
      }
    },
      :eap => {
        :name => "East Asia and Pacific",
        :zoom => 4, :lat => 19, :lon => 105.5,
        :countries => {
          :philippines => {:name => "Philippines", :map => 263, :region => "East Asia and Pacific", :status => "active",
                      :projects_count => 48, :locations_count => 4764, 
            :results => [{:name  => "Country Profile", :link => "http://www.worldbank.org.ph/WBSITE/EXTERNAL/COUNTRIES/EASTASIAPACIFICEXT/PHILIPPINESEXTN/0,,contentMDK:20203978~menuPK:332990~pagePK:141137~piPK:141127~theSitePK:332982~isCURL:Y,00.html"},
                {:name => "Kapitbisig Laban sa Kahirapan - Comprehensive And Integrated Delivery Of Social Services Project (KALAHI-CIDSS)", :link => "http://www.worldbank.org.ph/WBSITE/EXTERNAL/COUNTRIES/EASTASIAPACIFICEXT/PHILIPPINESEXTN/0,,contentMDK:22190322~pagePK:141137~piPK:141127~theSitePK:332982,00.html"},
                {:name => "Laguna de Bay Institutional Strengthening and Community Participation (LISCOP) Project", :link => "http://www.worldbank.org.ph/WBSITE/EXTERNAL/COUNTRIES/EASTASIAPACIFICEXT/PHILIPPINESEXTN/0,,contentMDK:22149130~pagePK:141137~piPK:141127~theSitePK:332982,00.html"}],
                      :indicators => ["Population","Poverty","Infant Mortality"]}
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
        :haiti => {:name => "Haiti", :map => 114, :projects => 108, :region => "Latin America and Caribbean", :status => "inactive", 
                      :projects_count => 27, :locations_count => 319, 
            :results => [{:name  => "Country Profile", :link => "http://web.worldbank.org/WBSITE/EXTERNAL/COUNTRIES/LACEXT/HAITIEXTN/0,,contentMDK:22251393~pagePK:1497618~piPK:217854~theSitePK:338165,00.html#projects"},
                {:name => "Decentralized Infrastructure for Rural Transformation Project (IDTR)", :link => "http://web.worldbank.org/WBSITE/EXTERNAL/NEWS/0,,contentMDK:22707543~menuPK:141310~pagePK:34370~piPK:34424~theSitePK:4607,00.html"}],          
          :indicators => ["Population","Poverty","Infant Mortality","Malnutrition"],
          :adm1  => [{ :name => "Grand-Anse", :zoom => 11, :lat => 18.53, :lon => -74.13},
            {:name => "Sud", :zoom => 10, :lat => 18.272, :lon => -73.72},
            {:name => "Nippes", :zoom => 10, :lat => 18.45, :lon => -73.313},
            {:name => "Sud-Est", :zoom => 10, :lat => 18.277, :lon => -72.369},
            {:name => "Ouest", :zoom => 10, :lat => 18.45, :lon => -72.266},
            {:name => "Centre", :zoom => 10, :lat => 18.98, :lon => -71.95},
            {:name => "Artibonite", :zoom => 11, :lat => 18.16, :lon => -72.53},
            {:name => "Nord-Est", :zoom => 11, :lat => 18.455, :lon => -71.9},
            {:name => "Nord", :zoom => 11, :lat => 19.577, :lon => -72.29},
            {:name => "Nord-Ouest", :zoom => 11, :lat => 19.65, :lon => -72.86}
            ]},
        :bolivia => {:name => "Bolivia", :map => 262, :region => "Latin America and Caribbean", :status => "active",
                      :projects_count => 17, :locations_count => 638, 
                    :indicators => ["Population","Poverty","Infant Mortality","Maternal Health","Malnutrition"],
                    :results => [{:name  => "Country Profile", :link => "http://web.worldbank.org/WBSITE/EXTERNAL/COUNTRIES/LACEXT/BOLIVIAEXTN/0,,menuPK:322289~pagePK:141132~piPK:141107~theSitePK:322279,00.html#projects"},
                      {:name => "Decentralized Infrastructure for Rural Transformation Project (IDTR)", :link => "http://web.worldbank.org/WBSITE/EXTERNAL/NEWS/0,,contentMDK:22707543~menuPK:141310~pagePK:34370~piPK:34424~theSitePK:4607,00.html"},
                      {:name => "Improving Access to Essential Maternal and Child Health Services (2007)", :link => "http://web.worldbank.org/WBSITE/EXTERNAL/COUNTRIES/LACEXT/EXTLACPROJECTSRESULTS/0,,contentMDK:21217923~contenttypepk:64745485~dataclass:CNTRY~folderpk:64748632~mdk:82648~pagePK:64750647~piPK:64750659~projID:P060392~theSitePK:3177341,00.html"},
                      {:name => "Stimulating Local Economic Development and Regional Integration - the Abapo-Camiri Highway (2007)", :link => "http://web.worldbank.org/WBSITE/EXTERNAL/COUNTRIES/LACEXT/EXTLACPROJECTSRESULTS/0,,contentMDK:21359569~contenttypepk:64745485~dataclass:CNTRY~folderpk:64748632~mdk:82648~pagePK:64750647~piPK:64750659~projID:P055230~theSitePK:3177341,00.html"}]}
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
  :industry => {:name => "Industry and Trade"},
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

get '/404' do 
  erb :missing
end

get '/500' do 
  erb :missing
end

get '/about' do 
  erb :about
end

get '/map.js' do 
  content_type 'application/javascript', :charset => 'utf-8'
  erb :map, :layout => false
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