# CREATE TABLE projects (
#  timestamp              timestamp without time zone ,
#  project_id             String      ,
#  latitude               double precision            ,
#  longitude              double precision            ,
#  precision              String      ,
#  precision_description  text                        ,
#  user_id                String      ,
#  geonameid              String      ,
#  adm2                   String      ,
#  gaul02                 String      ,
#  gadm02                 String      ,
#  unsalb02               String      ,
#  project_title          character varying(250)      ,
#  description            text                        ,
#  adm1                   String      ,
#  gaul01                 String      ,
#  gadm01                 String      ,
#  unsalb01               String      ,
#  product_line           String      ,
#  country                String      ,
#  region                 String      ,
#  lending_instrument     String      ,
#  approval_date          timestamp without time zone ,
#  total_amt              String      ,
#  total_disb             String      ,
#  geoname                String      ,
#  source                 String      ,
#  source_url             text                        ,
#  mjsector_1             String      ,
#  development_objective  text                        ,
#  results                text                        );
require(File.join(File.dirname(__FILE__), 'database'))

require(File.join(File.dirname(__FILE__), '../','worldbank'))
include WorldBank

DataMapper::Property::String.length(255)

class Project
  include DataMapper::Resource

  property :id,     Serial    # An auto-increment integer key
  property :timestamp              ,DateTime
  property :project_id             ,String     
  property :latitude               ,Decimal, :scale => 0, :precision => 10          
  property :longitude              ,Decimal, :scale => 0, :precision => 10          
  property :precision              ,String     
  property :precision_description  ,Text                       
  property :user_id                ,String     
  property :geonameid              ,String     
  property :adm2                   ,String     
  property :gaul02                 ,String     
  property :gadm02                 ,String     
  property :unsalb02               ,String     
  property :project_title          ,String, :length => 250
  property :description            ,Text                       
  property :adm1                   ,String     
  property :gaul01                 ,String     
  property :gadm01                 ,String     
  property :unsalb01               ,String     
  property :product_line           ,String     
  property :country                ,String     
  property :region                 ,String     
  property :lending_instrument     ,String     
  property :approval_date          ,DateTime
  property :total_amt              ,String     
  property :total_disb             ,String     
  property :geoname                ,String     
  property :source                 ,String     
  property :source_url             ,Text                       
  property :mjsector_1             ,String
  property :mjsector_percent       ,Text    
  property :development_objective  ,Text                       
  property :results                ,Text                       

  def self.update
    projects  = WorldBank.get_geocoded_projects
    
    Project.destroy # Remove them. Remove them all.
    projects["projects"].each do |project_id, project|
      puts project_id
      if project["locations"].nil?
                Project.create!  :project_id => project_id,
                        :project_title => project["project_name"],
                        :mjsector_1 => project["mjsector1"],
                        :total_amt => project["totalamt"],
                        :total_disb => projects["grantamt"],
                        :mjsector_percent => project["majorsector_percent"],
                        :product_line => project["prodlinetext"],
                        :source_url => project["url"],
                        :description => project["project_abstract"],
                        :approval_date => project["boardapprovaldate"],
                        :region => project["regionname"],
                        :country => project["countryname"],
                        :latitude => nil,
                        :longitude => nil,
                        :region => nil
      else
       project["locations"].each do |location|
        Project.create! :project_id => project_id,
                        :project_title => project["project_name"],
                        :mjsector_1 => project["mjsector1"],
                        :total_amt => project["totalamt"],
                        :total_disb => projects["grantamt"],
                        :mjsector_percent => project["majorsector_percent"],
                        :product_line => project["prodlinetext"],
                        :source_url => project["url"],
                        :description => project["project_abstract"],
                        :approval_date => project["boardapprovaldate"],
                        :region => project["regionname"],
                        :country => project["countryname"],
                        :latitude => location["latitude"].to_f,
                        :longitude => location["longitude"].to_f,
                        :region => location["geoLocName"]
        end
      end
    end
  end
  
end


DataMapper.auto_migrate! # destructively clears the db
# DataMapper.auto_upgrade! # just update, but don't clear the db
DataMapper::Model.raise_on_save_failure = true
DataMapper.finalize
