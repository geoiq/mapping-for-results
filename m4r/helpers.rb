# Mapping for Results view rendering helper methods
# 
# Author: Andrew Turner
# Date: 01/25/2011
# 

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
      return value.gsub(/,/,'').to_f / 1000000
    when /grantamt/
      return value.gsub(/,/,'').to_f / 1000000
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
