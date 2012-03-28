require "test/unit"
require "rubygems"
require "selenium-client"
require "selenium/client"
require 'open-uri'
require 'json'

COUNTRIES = {:afr => ["kenya","tanzania","ghana"], :lac => ["haiti", "bolivia"]}
LOAD_TIMEOUT = 3
class Loadmap < Test::Unit::TestCase

  def setup
    @verification_errors = []
    @selenium = Selenium::Client::Driver.new \
      :host => "localhost",
      :port => 4444,
      :browser => "*firefox",
      #:url => "http://maps.worldbank.org/",
      :url => "http://staging.worldbank.geoiq.com/",
      :timeout_in_second => 60

    @path = File.dirname(File.expand_path(__FILE__)) + "/screenshots"
    @selenium.start_new_browser_session
  end
  
  def teardown
    @selenium.close_current_browser_session
    assert_equal [], @verification_errors
  end

  def load_country(country)
    puts country.inspect
    puts "Testing #{country["name"]}..."
    @selenium.click "link=#{country["name"]}"
    @selenium.wait_for_page_to_load "30000"
    assert !60.times{ break if (@selenium.is_element_present("id=project-info") rescue false); sleep 1 }
    sleep LOAD_TIMEOUT
    @selenium.capture_entire_page_screenshot "#{@path}/#{country["shortname"]}.png", ""

    country["indicators"].each do |indicator|
      @selenium.click "link=#{indicator}"
      sleep LOAD_TIMEOUT
      @selenium.capture_entire_page_screenshot "#{@path}/#{country["shortname"]} #{indicator}.png", ""
    end
    @selenium.click "css=a > path"
    @selenium.click "css=span.subtotal"
    puts "Tested #{country["name"]}"
  end
  def test_load
    countries = JSON.parse(open("http://worldbank.geoiq.com/countries.json").read)
    @selenium.open "/"
    assert !60.times{ break if (@selenium.is_element_present("id=sector_funding_total") rescue false); sleep 1 }
    sleep LOAD_TIMEOUT
    @selenium.capture_entire_page_screenshot "#{@path}/world.png", ""
    countries.each do |country|
      load_country(country)
    end
  end
end
