# World Bank Projects API interface
# 
# Author: Andrew Turner
# Date: 01/25/2011
# 

%w{ rubygems yajl yajl/gzip yajl/deflate yajl/http_stream faster_csv  }.each {|gem| require gem}
module WorldBank

  WB_PROJECTS_API = "http://search.worldbank.org/api/projects?qterm=*:*&fl=id,project_name,boardapprovaldate,totalamt,grantamt,mjsector1,regionname,countryname,majorsector_percent,prodline,productlinetype&status[]=active&rows=500&format=json&frmYear=ALL&toYear=ALL"
  WBSTAGING = {
    :world => {:name => "World", :map => 353, :projects_count => 1517, :locations_count => 15246, :pages => {
      :afr => {
        :name => "Africa",
        :map => 356,
        :zoom => 3, :lat => -4, :lon => 21,
        :locations_count => 4402, 
        :indicators => [], :adm1 => [], :results => [],
        :pages => {
          :kenya => {:name => "Kenya",
                    :type => "country",
                    :map => 255, :isocode => "KE", :region => "Africa", :status => "active",
                        :projects_count => 37, :locations_count => 265, 
              :results => [{:name  => "Country Profile", 
                  :link => "http://web.worldbank.org/WBSITE/EXTERNAL/COUNTRIES/AFRICAEXT/KENYAEXTN/0,,menuPK:356520~pagePK:141132~piPK:141107~theSitePK:356509,00.html"},
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
          :type => "region",
          :zoom => 4, :lat => 19, :lon => 105.5,
          :indicators => [], :adm1 => [], :results => [],
          :pages => {
            # 263
            :philippines => {:name => "Philippines", :type => "country", :isocode => "PH", :map => 355, :locations_layer => 642, :region => "East Asia and Pacific", :status => "active",
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
          :type => "region",
        :indicators => [], :adm1 => [], :results => [],
          :zoom => 4, :lat => 42.68, :lon => 68.90,
          :pages => {}
        },
        :mena => {
          :name => "Middle East and North Africa",
          :type => "region",          
          :indicators => [], :adm1 => [], :results => [],
          :zoom => 4, :lat => 26.1, :lon => 25.7,
          :pages => {}
        },
        :sar => {
          :name => "South Asia",
          :type => "region",          
        :indicators => [], :adm1 => [], :results => [],
          :zoom => 4, :lat => 15.5, :lon => 91.8,
          :pages => {}
        },                
      :lac =>  {
        :name => "Latin America and Caribbean",
          :type => "region",        
        :zoom => 3, :lat => -25, :lon => -57.8,
        :locations_count => 5192, 
        :indicators => [], :adm1 => [], :results => [],
        :map => 357,
        :pages => {
          :haiti => {:name => "Haiti", 
                        :type => "country",:map => 114, :isocode => "HT", :projects => 108, :region => "Latin America and Caribbean", :status => "active", 
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
          :bolivia => {:name => "Bolivia", 
                        :type => "country", :isocode => "BO", :map => 262, :region => "Latin America and Caribbean", :status => "active",
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

  PROJECT_FIELDS = ["id","project_name","totalamt","grantamt","mjsector1","boardapprovaldate","majorsector_percent","prodline"]
  SECTORS = {
    :public => {:name => "Public Administration, Law, and Justice"},
    :agriculture => {:name => "Agriculture, fishing, and forestry"},
    :health => {:name => "Health and other social services"},
    :communications => {:name => "Information and communications"},
    :energy => {:name => "Energy and mining"},
    :finance => {:name => "Finance"},
    :industry => {:name => "Industry and trade"},
    :transporation => {:name => "Transportation"},
    :water => {:name => "Water, sanitation and flood protection"},
    :education => {:name => "Education"}
    }

  MAPS = WBSTAGING # PLATFORM_API_URL =~ /geocommons/ ? WBSTAGING : LOCAL 

  def self.build_page_database(pages, parent = nil)
    pages.each do |key, values|
        @page = Page.create(
          :name         => values[:name],
          :shortname    => key.to_s,
          :isocode      => values[:isocode],
          :map          => values[:map],
          :page_type    => values[:type],
          :parent_id    => parent.nil? ? nil : parent.id,
          :projects_count => values[:projects_count],
          :locations_count => values[:locations_count] || 0,
          :indicators   => values[:indicators],          
          :region       => parent.nil? ? "" : parent.name,
          :locations_layer => values[:locations_layer],
          :sync_updated_at => Time.now
        )
        build_page_database(values[:pages], @page) unless values[:pages].nil?
    end
  end

  # 
  # 
  # @returns - a hash of project data:
  #     total   - total number of projects
  #     projects - array of projects
  def self.get_all_projects
    i = 0
    project_count = 0
    total_projects = 100
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
    url = URI.parse(WB_PROJECTS_API + "&geocode=&countrycode[]=" + country.isocode)
    puts "Fetching: #{url}"
    projects_data = Yajl::HttpStream.get(url)
    # projects_data = Yajl::Parser.parse(open("#{country[:isocode]}.json").read)

    return projects_data["projects"]
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
    total_projects = 100
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
    calculations = {:sectors => {}, :regions => {}, :productline => {}}
    projects.each do |project_id, project|
        # some projects are financed through loans, some are grants.
        amount = project["totalamt"].to_i
        amount = project["grantamt"].to_i if(amount == 0)
        
        name = project["prodline"]
        calculations[:productline][name] = 0 unless calculations[:productline].include?(name)
        calculations[:productline][name] += amount
        
        project["majorsector_percent"].each do |percent|
            name = percent["Name"].gsub(/\b\w/){$&.upcase}.strip.gsub(/And/,'and')
            next if name.length == 0
            calculations[:sectors][name] = 0 unless calculations[:sectors].include?(name)
            calculations[:sectors][name] += percent["Percent"].to_i / 100.0 * amount            
        end
        calculations[:regions][project[regionname]] = 0 unless calculations[:regions].include?(project[regionname])

        calculations[:regions][project[regionname]] += amount
    end
    calculations
  end
end
