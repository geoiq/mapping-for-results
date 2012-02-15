# World Bank Projects API interface
# 
# Author: Andrew Turner
# Date: 01/25/2011
# 

%w{ rubygems yajl yajl/gzip yajl/deflate yajl/http_stream faster_csv  }.each {|gem| require gem}
module WorldBank

  SHORTNAMES = {
    "SOUTH ASIA" => "sa",
    "MIDDLE EAST AND NORTH AFRICA"  => "mena",
    "EAST ASIA AND PACIFIC" => "eap",
    "AFRICA" => "afr",
    "LATIN AMERICA AND CARIBBEAN" => "lac",
    "EUROPE AND CENTRAL ASIA" => "eca"
  }
  WB_PROJECTS_API = "http://search.worldbank.org/api/projects?qterm=*:*&fl=id,project_name,boardapprovaldate,totalamt,grantamt,mjsector1,regionname,countryshortname,countryname,majorsector_percent,prodlinetext,productlinetype,supplementprojectflg,countrycode&status[]=active&rows=500&format=json&frmYear=ALL&toYear=ALL" #&prodline[]=GE&prodline[]=PE&prodline[]=MT&prodline[]=RE&prodline[]=SF"

  WB_LOCATIONS_API = "http://search.worldbank.org/api/projects?qterm=*:*&fl=id,project_name,boardapprovaldate,totalamt,grantamt,mjsector1,regionname,countryshortname,countryname,majorsector_percent,prodlinetext,productlinetype,supplementprojectflg,countrycode,location,project_abstract,url&status[]=active&rows=500&format=json&frmYear=ALL&toYear=ALL" #&prodline[]=GE&prodline[]=PE&prodline[]=MT&prodline[]=RE&prodline[]=SF"
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
  def self.get_all_projects(limit = nil)
    i = 0
    project_count = 0
    total_projects = limit || 100
    projects = {}
    while(project_count < total_projects)
      url = URI.parse(WB_PROJECTS_API + "&os=#{500*i}") #&geocode=
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
    
  
  def self.get_active_projects(limit = nil)
    self.get_all_projects(limit)["projects"]
  end
  
  # Get List of projects by Country
  # @returns - a hash of project data:
  #     total   - total number of projects
  #     projects - array of projects
  def self.get_country_projects
    projects = self.get_active_projects
    countries = {}
    projects.each do |project_id, project|
      
      countries[project["countryname"]] = 0 unless countries.include?(project["countryname"])
      countries[project["countryname"]] += 1
    end
    return countries
  end
      
  def self.get_project_data(country)
    url = URI.parse(WB_PROJECTS_API + "&geocode=&countrycode[]=" + country.isocode)
    puts "Fetching: #{url}"
    projects_data = {}
    data = Yajl::HttpStream.get(url)
    projects_data["projects"] = data["projects"]
    # projects_data = Yajl::Parser.parse(open("#{country[:isocode]}.json").read)
    projects_data["total"] = projects_data["projects"].length
    
    return projects_data
  end

  def self.get_geocoded_projects
    projects = paginated_projects(WB_LOCATIONS_API + "&geocode=ON")
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
        amount = project["totalamt"].gsub(/,/,'').to_i / 1_000_000.0
        amount = project["grantamt"].gsub(/,/,'').to_i / 1_000_000.0 if(amount == 0)
        # Special filter from Johannes Kiess on April 4, 2011 for filtering only 'large' RE projects
        # next if project["prodlinetext"] == "Recipient Executed Activities" && amount < 5_000_000
        
        name = project["prodlinetext"]
        calculations[:productline][name] = 0 unless calculations[:productline].include?(name)
        calculations[:productline][name] += amount
        project["majorsector_percent"].each do |percent|
            name = percent["Name"].strip
            next if name.length == 0
            calculations[:sectors][name] = 0 unless calculations[:sectors].include?(name)
            calculations[:sectors][name] += percent["Percent"].to_i / 100.0 * amount
        end
       
        calculations[:regions][project[regionname]] = {:financing => 0, :shortname => SHORTNAMES[project[regionname]] ||  project[regionname]} unless calculations[:regions].include?(project[regionname])
        calculations[:regions][project[regionname]][:financing] += amount
    end
    calculations
  end
  
  
  # Filters out projects that shouldn't be counted as part of the overall total count of projects
  def self.filter_projects_count(projects)
    total = 0
    projects.each do |i,p|
      total += 1 if !p.keys.include?("supplementprojectflg") || p["supplementprojectflg"].downcase == "n"
    end
    
    total
  end
end
