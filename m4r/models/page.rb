require(File.join(File.dirname(__FILE__), 'database'))
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
end


# DataMapper.finalize
# DataMapper.auto_migrate! # destructively clears the db
DataMapper.auto_upgrade! # just update, but don't clear the db
