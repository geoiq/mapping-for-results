%w{ rubygems sinatra open-uri yajl erb  yajl/gzip yajl/deflate yajl/http_stream faster_csv json}.each {|gem| require gem}

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

module WorldBank


  WB_PROJECTS_API = "http://search.worldbank.org/api/projects?qterm=*:*&fl=id,project_name,boardapprovaldate,totalamt,mjsector1,regionname,countryname,majorsector_percent&status[]=active&rows=500&format=json&frmYear=ALL&toYear=ALL"
  WBSTAGING = {
    :world => {:name => "World", :map => 353, :projects_count => 1517, :locations_count => "15,246", :regions => {
      :afr => {
        :name => "Africa",
        :map => 356,
        :zoom => 3, :lat => -4, :lon => 21,
        :locations_count => 4402, 
        :indicators => [], :adm1 => [], :results => [],
        :countries => {
          :kenya => {:name => "Kenya", :map => 255, :isocode => "KE", :region => "Africa", :status => "active",
                        :projects_count => 37, :locations_count => 265, 
              :results => [{:name  => "Country Profile", :link => "http://web.worldbank.org/WBSITE/EXTERNAL/COUNTRIES/AFRICAEXT/KENYAEXTN/0,,menuPK:356520~pagePK:141132~piPK:141107~theSitePK:356509,00.html"},
                  {:name => "World Bank Approves US$100 Million Credit for Kenya’s Health Sector", :link => "http://web.worldbank.org/WBSITE/EXTERNAL/COUNTRIES/AFRICAEXT/KENYAEXTN/0,,contentMDK:22632909~menuPK:50003484~pagePK:2865066~piPK:2865079~theSitePK:356509,00.html"},
                  {:name => "World Bank Approves US$154.5 Million to Support Poorest People in Western Kenya", :link => "http://web.worldbank.org/WBSITE/EXTERNAL/COUNTRIES/AFRICAEXT/KENYAEXTN/0,,contentMDK:21275229~menuPK:356530~pagePK:2865066~piPK:2865079~theSitePK:356509,00.html"}],
              :indicators => ["Population","Poverty","Infant Mortality","Maternal Health","Malnutrition"],
              :adm1 => [{:name => "Rift Valley", :lat => 1.150021, :lon => 36.03213547, :zoom => 10},
                        {:name => "Eastern", :lat => 0.701907163, :lon => 37.75840251, :zoom => 10},
                        {:name => "Nairobi", :lat => -1.297822064, :lon => 36.88437406, :zoom => 10},
                        {:name => "Coast", :lat => -2.332949245, :lon => 39.56448882, :zoom => 10},
                        {:name => "Nyanza", :lat => -0.536004493, :lon => 34.63615441, :zoom => 10},
                        {:name => "Western", :lat => 0.55589916, :lon => 34.54934945, :zoom => 10},
                        {:name => "Central", :lat => -0.587079669, :lon => 36.84799556, :zoom => 10},
                        {:name => "North-Eastern", :lat => 1.112081207, :lon => 40.27493157, :zoom => 10}]}
        }
      },
        :eap => {
          :name => "East Asia and Pacific",
          :zoom => 4, :lat => 19, :lon => 105.5,
          :indicators => [], :adm1 => [], :results => [],
          :countries => {
            # 263
            :philippines => {:name => "Philippines", :isocode => "PH", :map => 355, :locations_layer => 642, :region => "East Asia and Pacific", :status => "active",
                        :projects_count => 48, :locations_count => 4764, 
              :results => [{:name  => "Country Profile", :link => "http://www.worldbank.org.ph/WBSITE/EXTERNAL/COUNTRIES/EASTASIAPACIFICEXT/PHILIPPINESEXTN/0,,contentMDK:20203978~menuPK:332990~pagePK:141137~piPK:141127~theSitePK:332982~isCURL:Y,00.html"},
                  {:name => "Kapitbisig Laban sa Kahirapan - Comprehensive And Integrated Delivery Of Social Services Project (KALAHI-CIDSS)", :link => "http://www.worldbank.org.ph/WBSITE/EXTERNAL/COUNTRIES/EASTASIAPACIFICEXT/PHILIPPINESEXTN/0,,contentMDK:22190322~pagePK:141137~piPK:141127~theSitePK:332982,00.html"},
                  {:name => "Laguna de Bay Institutional Strengthening and Community Participation (LISCOP) Project", :link => "http://www.worldbank.org.ph/WBSITE/EXTERNAL/COUNTRIES/EASTASIAPACIFICEXT/PHILIPPINESEXTN/0,,contentMDK:22149130~pagePK:141137~piPK:141127~theSitePK:332982,00.html"}],
              :indicators => ["Population","Poverty","Infant Mortality"],
              :adm1 => [{:name => "Abra", :zoom => 10, :lat => 17.567527, :lon => 120.794941},
                                  {:name => "Agusan del Norte", :zoom => 10, :lat => 9.059037, :lon => 125.486592},
                                  {:name => "Agusan del Sur", :zoom => 10, :lat => 8.585089, :lon => 125.801243},
                                  {:name => "Aklan", :zoom => 10, :lat => 11.655835, :lon => 122.210746},
                                  {:name => "Albay", :zoom => 10, :lat => 13.254595, :lon => 123.74786},
                                  {:name => "Antique", :zoom => 10, :lat => 11.262351, :lon => 121.804149},
                                  {:name => "Apayao", :zoom => 10, :lat => 18.082756, :lon => 121.208737},
                                  {:name => "Aurora", :zoom => 10, :lat => 15.782218, :lon => 121.531204},
                                  {:name => "Basilan", :zoom => 10, :lat => 6.592571, :lon => 121.918194},
                                  {:name => "Bataan", :zoom => 10, :lat => 14.646865, :lon => 120.42337},
                                  {:name => "Batanes", :zoom => 10, :lat => 20.69118, :lon => 121.906879},
                                  {:name => "Batangas", :zoom => 10, :lat => 13.882915, :lon => 120.979253},
                                  {:name => "Benguet", :zoom => 10, :lat => 16.561251, :lon => 120.687153},
                                  {:name => "Biliran", :zoom => 10, :lat => 11.639693, :lon => 124.436909},
                                  {:name => "Bohol", :zoom => 10, :lat => 9.886366, :lon => 124.163303},
                                  {:name => "Bukidnon", :zoom => 10, :lat => 7.997126, :lon => 124.969868},
                                  {:name => "Bulacan", :zoom => 10, :lat => 14.982197, :lon => 121.004082},
                                  {:name => "Cagayan", :zoom => 10, :lat => 18.098469, :lon => 121.763624},
                                  {:name => "Camarines Norte", :zoom => 10, :lat => 14.16887, :lon => 122.708367},
                                  {:name => "Camarines Sur", :zoom => 10, :lat => 13.695411, :lon => 123.275285},
                                  {:name => "Camiguin", :zoom => 10, :lat => 9.168087, :lon => 124.719917},
                                  {:name => "Capiz", :zoom => 10, :lat => 11.392941, :lon => 122.649322},
                                  {:name => "Catanduanes", :zoom => 10, :lat => 13.81286, :lon => 124.219413},
                                  {:name => "Cavite", :zoom => 10, :lat => 14.280806, :lon => 120.841812},
                                  {:name => "Cebu", :zoom => 10, :lat => 10.497094, :lon => 123.932636},
                                  {:name => "Compostela Valley", :zoom => 10, :lat => 7.537187, :lon => 125.985519},
                                  {:name => "Davao Oriental", :zoom => 10, :lat => 7.135033, :lon => 126.273895},
                                  {:name => "Davao del Norte", :zoom => 10, :lat => 7.44521, :lon => 125.597221},
                                  {:name => "Davao del Sur", :zoom => 10, :lat => 6.467025, :lon => 125.409031},
                                  {:name => "Dinagat Islands", :zoom => 10, :lat => 10.11219, :lon => 125.667114},
                                  {:name => "Eastern Samar", :zoom => 10, :lat => 11.657691, :lon => 125.379914},
                                  {:name => "Guimaras", :zoom => 10, :lat => 10.541448, :lon => 122.609016},
                                  {:name => "Ifugao", :zoom => 10, :lat => 16.837931, :lon => 121.234863},
                                  {:name => "Ilocos Norte", :zoom => 10, :lat => 18.177566, :lon => 120.694908},
                                  {:name => "Ilocos Sur", :zoom => 10, :lat => 17.281766, :lon => 120.601136},
                                  {:name => "Iloilo", :zoom => 10, :lat => 11.053214, :lon => 122.692081},
                                  {:name => "Isabela", :zoom => 10, :lat => 16.96888, :lon => 121.930089},
                                  {:name => "Kalinga", :zoom => 10, :lat => 17.428971, :lon => 121.294883},
                                  {:name => "La Union", :zoom => 10, :lat => 16.564462, :lon => 120.428967},
                                  {:name => "Laguna", :zoom => 10, :lat => 14.270006, :lon => 121.318863},
                                  {:name => "Lanao del Norte", :zoom => 10, :lat => 8.01737, :lon => 124.098134},
                                  {:name => "Lanao del Sur", :zoom => 10, :lat => 7.806245, :lon => 124.311505},
                                  {:name => "Leyte", :zoom => 10, :lat => 10.856604, :lon => 124.719127},
                                  {:name => "Maguindanao", :zoom => 10, :lat => 7.150931, :lon => 124.532055},
                                  {:name => "Marinduque", :zoom => 10, :lat => 13.379886, :lon => 121.996494},
                                  {:name => "Masbate", :zoom => 10, :lat => 12.465973, :lon => 123.473445},
                                  {:name => "Metropolitan Manila", :zoom => 10, :lat => 14.565295, :lon => 121.02451},
                                  {:name => "Misamis Occidental", :zoom => 10, :lat => 8.340137, :lon => 123.708461},
                                  {:name => "Misamis Oriental", :zoom => 10, :lat => 8.663879, :lon => 124.750557},
                                  {:name => "Mountain Province", :zoom => 10, :lat => 17.064435, :lon => 121.168349},
                                  {:name => "Negros Occidental", :zoom => 10, :lat => 10.232083, :lon => 122.968869},
                                  {:name => "Negros Oriental", :zoom => 10, :lat => 9.725808, :lon => 122.974472},
                                  {:name => "North Cotabato", :zoom => 10, :lat => 7.220846, :lon => 124.821053},
                                  {:name => "Northern Samar", :zoom => 10, :lat => 12.448762, :lon => 124.672325},
                                  {:name => "Nueva Ecija", :zoom => 10, :lat => 15.646295, :lon => 120.99451},
                                  {:name => "Nueva Vizcaya", :zoom => 10, :lat => 16.25949, :lon => 121.113323},
                                  {:name => "Occidental Mindoro", :zoom => 10, :lat => 12.976711, :lon => 120.889353},
                                  {:name => "Oriental Mindoro", :zoom => 10, :lat => 12.863195, :lon => 121.177631},
                                  {:name => "Palawan", :zoom => 10, :lat => 9.96771, :lon => 118.744877},
                                  {:name => "Pampanga", :zoom => 10, :lat => 15.019314, :lon => 120.6727},
                                  {:name => "Pangasinan", :zoom => 10, :lat => 16.031185, :lon => 120.335888},
                                  {:name => "Quezon", :zoom => 10, :lat => 12.820443, :lon => 123.235222},
                                  {:name => "Quirino", :zoom => 10, :lat => 16.279062, :lon => 121.712684},
                                  {:name => "Rizal", :zoom => 10, :lat => 14.59144, :lon => 121.281605},
                                  {:name => "Romblon", :zoom => 10, :lat => 12.531667, :lon => 122.189866},
                                  {:name => "Samar", :zoom => 10, :lat => 11.710444, :lon => 124.725887},
                                  {:name => "Sarangani", :zoom => 10, :lat => 6.018044, :lon => 124.944874},
                                  {:name => "Shariff Kabunsuan", :zoom => 10, :lat => 7.211433, :lon => 124.244213},
                                  {:name => "Siquijor", :zoom => 10, :lat => 9.197729, :lon => 123.576989},
                                  {:name => "Sorsogon", :zoom => 10, :lat => 12.820715, :lon => 123.839745},
                                  {:name => "South Cotabato", :zoom => 10, :lat => 6.312873, :lon => 124.77676},
                                  {:name => "Southern Leyte", :zoom => 10, :lat => 10.258482, :lon => 125.026027},
                                  {:name => "Sultan Kudarat", :zoom => 10, :lat => 6.498507, :lon => 124.606097},
                                  {:name => "Sulu", :zoom => 10, :lat => 6.049076, :lon => 121.162471},
                                  {:name => "Surigao del Norte", :zoom => 10, :lat => 9.898211, :lon => 125.787375},
                                  {:name => "Surigao del Sur", :zoom => 10, :lat => 8.702448, :lon => 126.101582},
                                  {:name => "Tarlac", :zoom => 10, :lat => 15.526071, :lon => 120.473053},
                                  {:name => "Tawi-Tawi", :zoom => 10, :lat => 5.119879, :lon => 119.933528},
                                  {:name => "Zambales", :zoom => 10, :lat => 15.291519, :lon => 120.123032},
                                  {:name => "Zamboanga Sibugay", :zoom => 10, :lat => 7.605444, :lon => 122.362936},
                                  {:name => "Zamboanga del Norte", :zoom => 10, :lat => 8.002766, :lon => 122.728325},
                                  {:name => "Zamboanga del Sur", :zoom => 10, :lat => 7.798519, :lon => 123.29261}]}
          }
      },
        :eca => {
          :name => "Europe and Central Asia",
        :indicators => [], :adm1 => [], :results => [],
          :zoom => 4, :lat => 42.68, :lon => 68.90,
          :countries => {}
        },
        :mena => {
          :name => "Middle East and North Africa",
          :indicators => [], :adm1 => [], :results => [],
          :zoom => 4, :lat => 26.1, :lon => 25.7,
          :countries => {}
        },
        :sar => {
          :name => "South Asia",
        :indicators => [], :adm1 => [], :results => [],
          :zoom => 4, :lat => 15.5, :lon => 91.8,
          :countries => {}
        },                
      :lac =>  {
        :name => "Latin America and Caribbean",
        :zoom => 3, :lat => -25, :lon => -57.8,
        :locations_count => 5192, 
        :indicators => [], :adm1 => [], :results => [],
        :map => 357,
        :countries => {
          :haiti => {:name => "Haiti", :map => 114, :isocode => "HT", :projects => 108, :region => "Latin America and Caribbean", :status => "active", 
                        :projects_count => 27, :locations_count => 319, 
              :results => [{:name => "IDA At Work: Haiti", :link => "http://web.worldbank.org/WBSITE/EXTERNAL/EXTABOUTUS/IDA/0,,contentMDK:21366516~pagePK:51236175~piPK:437394~theSitePK:73154,00.html"},
                  {:name => "Response to Haiti Earthquake", :link => "http://web.worldbank.org/WBSITE/EXTERNAL/COUNTRIES/LACEXT/HAITIEXTN/0,,contentMDK:22446701~pagePK:1497618~piPK:217854~theSitePK:338165,00.html"}
                  ],
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
          :bolivia => {:name => "Bolivia", :isocode => "BO", :map => 262, :region => "Latin America and Caribbean", :status => "active",
                        :projects_count => 17, :locations_count => 638, 
                      :adm1 => [{:name => "Chuquisaca", :zoom => 9, :lat => -19.91639089, :lon => -63.94717775},
                                {:name => "Cochabamba", :zoom => 9, :lat => -17.22959421, :lon => -65.59480594},
                                {:name => "El Beni", :zoom => 9, :lat => -13.42445187, :lon => -64.5442714},
                                {:name => "La Paz", :zoom => 9, :lat => -14.94456585, :lon => -68.18528065},
                                {:name => "Oruro", :zoom => 9, :lat => -18.59702433, :lon => -67.606991},
                                {:name => "Pando", :zoom => 9, :lat => -11.08158361, :lon => -67.42260436},
                                {:name => "Potosi", :zoom => 9, :lat => -20.34719881, :lon => -66.74823433},
                                {:name => "Santa Cruz", :zoom => 9, :lat => -16.96804972, :lon => -61.14741229},
                                {:name => "Tarija", :zoom => 9, :lat => -21.87133887, :lon => -63.8372801}],
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

  PROJECT_FIELDS = ["id","project_name","totalamt","mjsector1","boardapprovaldate","majorsector_percent"]
  SECTORS = {
    :public => {:name => "Public Administration, Law, and Justice"},
    :agriculture => {:name => "Agriculture, Fishing, and Forestry"},
    :health => {:name => "Health, other Social"},
    :communications => {:name => "Communications"},
    :energy => {:name => "Energy and Mining"},
    :finance => {:name => "Finance"},
    :industry => {:name => "Industry and Trade"},
    :transporation => {:name => "Transportation"},
    :water => {:name => "Water, Sanitation, and Flood Protection"},
    :education => {:name => "Education"}
    }

  MAPS = PLATFORM_API_URL =~ /geocommons/ ? WBSTAGING : LOCAL 

  def self.get_all_projects
    i = 0
    project_count = 0
    total_projects = 1000000
    projects = {}
    while(project_count < total_projects)
      url = URI.parse(WB_PROJECTS_API + "&geocode=&os=#{500*i}")
      projects_data = Yajl::HttpStream.get(url)
      if project_count == 0
        total_projects = projects_data["total"].to_i
        projects = projects_data
      end
      projects["projects"].merge!(projects_data["projects"])
      project_count += projects_data["rows"].to_i
      i += 1
    end
    projects
  end
    
  
  def self.get_active_projects       
    self.get_all_projects["projects"]
  end
  def self.get_project_data(country)
    url = URI.parse(WB_PROJECTS_API + "&geocode=&countrycode[]=" + country[:isocode])
    puts "Fetching: #{url}"
    projects_data = Yajl::HttpStream.get(url)
    # projects_data = Yajl::Parser.parse(open("#{country[:isocode]}.json").read)
    projects_total = projects_data["total"]
    country[:projects] = projects_total
    country[:project_list] = projects_data["projects"]
    country[:projects_count] = projects_total
    return country
  end
  
  def self.get_region_data(region)
    projects = paginated_projects(WB_PROJECTS_API + "&geocode=&regionname[]=" + region[:name].upcase.strip.gsub(/\s/,'+'))
  end
  def self.get_product_data(product)
    projects = paginated_projects(WB_PROJECTS_API + "&prodline[]=" + product)
    projects
  end
  
  def self.paginated_projects(uri)
    i = 0
    project_count = 0
    total_projects = 1000000
    projects = {}
    while(project_count < total_projects)
      url = URI.parse(uri + "&os=#{500*i}")

      projects_data = Yajl::HttpStream.get(url)
      if project_count == 0
        total_projects = projects_data["total"].to_i
        projects = projects_data
      end
      projects["projects"].merge!(projects_data["projects"])
      project_count += projects_data["rows"].to_i
      i += 1
    end
    projects
  end
  
  def self.calculate_financing(projects, regionname = "regionname")
    calculations = {:sectors => {}, :regions => {}}
    projects.each do |project_id, project|
        project["majorsector_percent"].each do |percent|
            name = percent["Name"].gsub(/\b\w/){$&.upcase}.strip.gsub(/And/,'and')
            next if name.length == 0
            calculations[:sectors][name] = 0 unless calculations[:sectors].include?(name)
            calculations[:sectors][name] += percent["Percent"].to_i / 100.0 * project["totalamt"].to_i
        end
        calculations[:regions][project[regionname]] = 0 unless calculations[:regions].include?(project[regionname])
        calculations[:regions][project[regionname]] += project["totalamt"].to_i
    end
    calculations
  end
end


include WorldBank

get '/' do
  @country = MAPS[:world]
  @projects ||= WorldBank.get_all_projects
  @financing ||= WorldBank.calculate_financing(@projects["projects"])
  @country[:projects_count] = @projects["total"]
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
  @country = @region = MAPS[:world][:regions][params[:region].to_sym]
  if(@region.nil?)
    erb :about
  else
    @projects = WorldBank.get_region_data(@region)
    @financing ||= WorldBank.calculate_financing(@projects["projects"], "countryname")
    
    @country[:projects_count] = @projects["total"]
    
    erb :index
  end
  
end

get '/productline/:product/charts' do
  @country = @region = {:name => "World", :adm1 => ""}

  @projects = WorldBank.get_product_data(params[:product].upcase)
  @financing ||= WorldBank.calculate_financing(@projects["projects"], "regionname")
  
  @country[:projects_count] = @projects["total"]
  
  erb :charts, :layout => :embed
end

get '/:region/:country' do
  @region = MAPS[:world][:regions][params[:region].to_sym]
  if(@region.nil?)
    erb :about
  else
    @country = @region[:countries][params[:country].to_sym]
    @country = WorldBank.get_project_data(@country)
    
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
  def cleanup_attributes(attribute, value)
    case attribute
    when /majorsector_percent/
      return value.to_json
    when /boardapprovaldate/
      return "'#{DateTime.parse(value).strftime("%b-%Y")}'"
    when /totalamt/
      return value.to_f
      # return "$#{value} million"
    when /mjsector1/
      # return "'#{value.match(/([\w]{2})\!\$\!(.*)/)[2].gsub(/\b\w/){$&.upcase}.gsub(/And/,'and')}'"
      return "'#{value.gsub(/\b\w/){$&.upcase}.gsub(/And/,'and').strip.gsub(/Sanitation /,'Sanitation, ')}'"
    when /sector_code/
      return "'#{value["Code"]}'"
    else
      return "'#{value}'"
    end

  end

  def menu_options(collection, options = {})
    menu = ""
    options[:max_height] ||= 6
    height = collection.length
    (3..5).each do |i|
      height = (collection.length / i).ceil if height > options[:max_height]
    end
    i = 1
    
    collection.each_slice(height) do |column|
      menu << "<div class=\"column column_#{i}\"><ul>"
      column.each do |row|
        menu << %Q{<li><a href="#" onclick="wb.setLocation('#{ row[:name] }',#{ row[:lat] },#{ row[:lon] },#{ row[:zoom] }); return false">#{ row[:name] }</a></li>}
      end
      i += 1
      menu << "</ul></div>"
    end unless collection.length == 0

    return menu
  end
end
