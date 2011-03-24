# World Bank Projects API interface
# 
# Author: Andrew Turner
# Date: 01/25/2011
# 

%w{ rubygems yajl yajl/gzip yajl/deflate yajl/http_stream faster_csv  }.each {|gem| require gem}
module WorldBank

  WB_PROJECTS_API = "http://search.worldbank.org/api/projects?qterm=*:*&fl=id,project_name,boardapprovaldate,totalamt,grantamt,mjsector1,regionname,countryname,majorsector_percent,prodlinetext,productlinetype&status[]=active&rows=500&format=json&frmYear=ALL&toYear=ALL"

  PROJECT_FIELDS = ["id","project_name","totalamt","grantamt","mjsector1","boardapprovaldate","majorsector_percent","prodlinetext"]
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
    projects = paginated_projects(WB_PROJECTS_API + "&geocode=&regionname[]=" + region[:isocode])# .upcase.strip.gsub(/\s/,'+'))
  end
  def self.get_product_data(product)
    projects = paginated_projects(WB_PROJECTS_API + "&prodlinetext[]=" + product)
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
        
        name = project["prodlinetext"]
        calculations[:productline][name] = 0 unless calculations[:productline].include?(name)
        calculations[:productline][name] += amount
        project["majorsector_percent"].each do |percent|
            name = percent["Name"].strip
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
