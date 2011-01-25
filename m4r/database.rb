require 'datamapper'

# DataMapper.setup(:default, 'sqlite:///worldbank.db')
DataMapper.setup(:default, 'postgres://postgres@localhost/worldbank_dev')  

class Page
  include DataMapper::Resource

  property :id,     Serial    # An auto-increment integer key
  property :page_type, String
  property :name,   String    # A varchar type string, for short strings
  property :shortname, String
  property :map,    Text      # A text block, for longer string data.
  property :zoom,   String
  property :lat,    String
  property :lon,    String
  property :status, String
  property :parent_id, Integer

  property :isocode, String
  property :projects_count, Integer
  property :projects, Integer
  property :project_list, Object
  property :region, String
  property :indicators, Object
  property :adm1, Object
  property :results, Object
  property :locations_count, Integer
  property :locations_layer, Integer
end


# DataMapper.finalize
# DataMapper.auto_migrate!
# WorldBank.build_page_database(MAPS)