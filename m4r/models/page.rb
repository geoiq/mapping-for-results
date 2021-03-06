require(File.join(File.dirname(__FILE__), 'database'))

require(File.join(File.dirname(__FILE__), '../','worldbank'))
include WorldBank

class Page
  include DataMapper::Resource

  property :id,     Serial    # An auto-increment integer key
  property :page_type, String, :default => "country"
  property :name,   String    # A varchar type string, for short strings
  property :shortname, String
  property :map,    Text      # A text block, for longer string data.
  property :zoom,   String, :default  => "9"
  property :lat,    String, :default  => "0"
  property :lon,    String, :default  => "0"
  property :status, String, :default  => "closed"
  property :overview, Text
  property :content, Text
  property :data, Object, :default => {}

  # property :parent_id, Integer
  is :tree, :order => :name
  
  property :isocode, String, :default  => ""
  property :projects_count, Integer, :default  => 0
  property :region, String, :default  => "World"
  property :indicators, Object, :default => []
  property :adm1, Object
  property :results, Object, :default => []
  property :locations_count, Integer, :default  => 0
  property :locations_layer, Integer, :default  => 0
  property :sync_updated_at, DateTime
  
  def url(options = {})
    return "#{self.shortname}" if self.parent.nil?
    link = ""
    page = self
    while(page.parent != nil)
      link = "/#{page.shortname}" + link
      page = page.parent
    end
    link
  end
  
  # Returns the list of the hierarchy of this page
  def hierarchy
    p = self
    h = []
    while(p.parent != nil)
      h = [p] + h
      p = p.parent
    end
    h = [p] + h
    
    h
  end
  def update_data!
    self.data ||= {}
    case self.page_type
    when "world"
        @projects  = WorldBank.get_all_projects
        @financing = WorldBank.calculate_financing(@projects["projects"])
        self.projects_count = @projects["total"]
        self.data[:financing] = @financing
    when "region"
        @projects = WorldBank.get_region_data(self)
        self.projects_count = @projects["total"]
        @financing = WorldBank.calculate_financing(@projects["projects"], "countryname")
        self.data[:financing] = @financing
    when "country"
        @projects = WorldBank.get_project_data(self)
        self.projects_count = @projects["total"]
    else
	return
    end
    # @projects["total"] = WorldBank.filter_projects_count(@projects["projects"])
    data = self.data.merge(:projects => @projects["projects"])
    data = self.data.merge(:financing => @financing) unless @financing.nil?
    self.data = {}
    self.data = data
    self.sync_updated_at = Time.now
    self.save
  end

  
  def indicators
    return data[:indicators]
  end  
end


# DataMapper.auto_migrate! # destructively clears the db
DataMapper.auto_upgrade! # just update, but don't clear the db
DataMapper::Property::String.length(255)
DataMapper::Model.raise_on_save_failure = true
DataMapper.finalize
