# Mapping for Results view rendering helper methods
# 
# Author: Andrew Turner
# Date: 01/25/2011
# 

require 'sinatra/base'

module Sinatra
  module GeoiqHelper
    def login(url,login,pass)
      uri = URI.parse("#{url}/users/#{login}.json")
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
      request.basic_auth(login,pass)
      response = http.request(request)
      if(response.code == "200")
        cookies = response["set-cookie"].split(";").first.split("=")
        session[:f1_session_id] = cookies[0]
        session[:f1_session_auth] = cookies[1]
        return true
      else
        return false
      end
    end
  end
  module PartialHelper
    # Embed a page partial
    # Usage: partial :foo
    def partial(page, options={})
      erb page, options.merge!(:layout => false)
    end
  end
  module MappingHelper

    # Create the link to the country in the footer
    # 
    # e.g Map / World / Latin America and Caribbean / Haiti
    def map_link(country, options={})
      link = []
      while !country.nil? && country.page_type != "world"
        link << [%Q{<a class="breadcrumb-link #{(country.children.nil? || country.children.length != 0) ? '' : 'breadcrumb-last'}" href="#{country.url}">#{country.name}</a>}]
        country = country.parent
      end
      link << [%Q{<a class="breadcrumb-link" href="/" title='World Bank: World'>World</a>}]
      link.reverse.join("")
    end
    def cleanup_attributes(attribute, value)
      case attribute
      when /majorsector_percent/
        return value.to_json
      when /boardapprovaldate/
        return "'#{DateTime.parse(value).strftime("%b-%Y")}'"
      when /totalamt/
        return value.gsub(/,/,'').to_f / 1000000
      when /grantamt/
        return value.gsub(/,/,'').to_f / 1000000
        # return "$#{value} million"
      when /mjsector1/
        # return "'#{value.match(/([\w]{2})\!\$\!(.*)/)[2].gsub(/\b\w/){$&.upcase}.gsub(/And/,'and')}'"
        return "'#{(value["Name"] || "").strip}'"
      when /sector_code/
        return "'#{value["Code"]}'"
      else
        return "'#{value.gsub("'","")}'"
      end

    end

    def region_select(country, options = {})
      regions = Page.all(:order => [:name.asc], :fields => [:id,:name,:parent_id,:shortname])
      html = ""
      html << '<select name="page[region]" id="page[region]" >'
      regions.each do |region|
        html << "<option value='#{region.id}' #{country.region == region.name ? 'selected' : ""}>#{region.name} - #{region.parent_id}</option>"
      end
      html << "<option value='' #{country.region == '' ? 'selected' : ""}>-- root level</option>"      
      html << "</select>"
      html
    end

    # Returns 'active' if this rendered_page is the current page
    def active_class(rendered_page, current_page)
      if rendered_page[:shortname] == current_page[:shortname]
        return 'active'
      elsif (current_page.page_type == "country" && !current_page.parent.nil? && rendered_page[:shortname] == current_page.parent[:shortname])
        return 'active'
      end
      return ''   
    end
    def link_to_page(page, options = {})
      page.url(options)
    end
    def admin_link(page, options = {})
      html = ""
      link = page.url(options)
      html << %Q{<li><a href="#{link}">#{page.name}</a> } 
      if !page.sync_updated_at.nil? && page.data.include?(:projects) && !page.data[:projects].nil?
        html << %Q{ has #{page.data[:projects].length} projects as of #{page.sync_updated_at.strftime("%B %d, %Y")}. }
      end

      html << %Q{ You can <a href="/admin/#{page.id}/edit">edit</a> this page}
      html << %Q{, or <a href="/admin/#{page.id}/sync">sync with project API</a>.} unless page.page_type == "page"
      if((children = page.children).length > 0)
        html << "<ul>"
        children.each do |child|
          html << admin_link(child)
        end
        html << "</ul>"
      end      
      html << "</li>"
      html
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
          row.symbolize_keys!
          menu << %Q{<li><a href="#" onclick="wb.setLocation('#{ row[:name] }',#{ row[:lat] },#{ row[:lon] },#{ row[:zoom] }); return false">#{ row[:name] }</a></li>}
        end
        i += 1
        menu << "</ul></div>"
      end unless collection.length == 0

      return menu
    end
    def commify(number)
      c = { :value => "", :length => 0 }
      r = number.to_s.reverse.split("").inject(c) do |t, e|  
        iv, il = t[:value], t[:length]
        iv += ',' if il % 3 == 0 && il != 0    
        { :value => iv + e, :length => il + 1 }
      end
      r[:value].reverse!
    end    
  end
end
