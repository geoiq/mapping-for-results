var proxy_host = "http://wbstaging.geocommons.com";    
var project_attributes = ["project title", "project id", "activity count", "financing", "sector1", "approval date"];

// , "General agriculture, fishing and forestry sector":"agriculture"
if(typeof(F1)=='undefined') {F1 = {}}
(function(){
  Object.size = function(obj) {
      var size = 0, key;
      for (key in obj) {
          if (obj.hasOwnProperty(key)) size++;
      }
      return size;
  };

  Object.include = function(arr, obj) {
    for(var i=0; i<arr.length; i++) {
      if (arr[i] == obj) return i;
    }
    return null;
  }

  Array.prototype.flatten = function flatten(){
     var flat = [];
     for (var i = 0, l = this.length; i < l; i++){
         var type = Object.prototype.toString.call(this[i]).split(' ').pop().split(']').shift().toLowerCase();
         if (type) { flat = flat.concat(/^(array|collection|arguments)$/.test(type) ? flatten.call(this[i]) : this[i]); }
     }
     return flat;
  };

  String.prototype.capitalize = function(){
    return this.replace( /(^|\s)([a-z])/g , function(m,p1,p2){ return p1+p2.toUpperCase(); } );
  };  
  
  F1.WorldBank = function(options) {  //constructor
    this.options = options;
    // F1.WorldBank.instances[options.id] = this;
  }

  F1.WorldBank.indicators = {
    "Poverty": {source: "finder:", title:"Poverty", subtitle: "Headcount Index", styles: { type: "CHOROPLETH",fill: { colors: [16709541,16698989,15500308,11422722,6694150], categories: 5, classificationNumClasses: 6, classificationType: "St Dev", opacity: 0.75, selectedAttribute: "poverty" }}, infosubtitle: null, table: null, description: "<p>These data sets involve econometric or quantitative indirect estimation procedures that combine spatial precision (such as censuses) with substantive depth (such as surveys). They have been developed and implemented by the World Bank Development Economics Research Group and colleagues, in collaboration with country teams for the implementation of Poverty Reduction Strategy Programmes.</p><p>Though spatial information may be used in the process of generating these estimates, the spatial data is generally separated prior to the analysis, reporting and dissemination of the poverty estimates. Thus, CIESIN’s database of sub-national small area estimates contains poverty and inequality data with reconstructed boundary information, using basic geographic information system (GIS) tools. (Text obtained from the source of data at <a href='http://sedac.ciesin.columbia.edu/povmap/methods_nat_sae.jsp'>CIESIN</a>)</p><p>Source: <a href='http://www.measuredhs.com/'>Demographic and Health Surveys (DHS)</a></p>"},
    "Malnutrition": {source: "finder:", title:"Child Malnutrition", subtitle: "Percentile weight of Children under 5", styles: { type: "CHOROPLETH", stroke: {color: 0x222222}, fill: { colors: [0x4A342C, 0x7C6253, 0xA4866D, 0xD1B79F, 0xEBD9C2], categories: 5, classificationNumClasses: 5, classificationType: "EQUAL INTERVAL", opacity: 0.75, selectedAttribute: "WFAB2SD" }}, infosubtitle: null, table: null, description: "Prevalence of child malnutrition is the percentage of children under age 5 whose height for age (stunting) is more than two standard deviations below the median for the international reference population ages 0-59 months. For children up to two years old height is measured by recumbent length. For older children height is measured by stature while standing. The data are based on the WHO's new child growth standards released in 2006.\nSource: World Health Organization, Global Database on Child Growth and Malnutrition.\nCatalog Sources: World Development Indicators"},
    "Infant Mortality": {source: "finder:", title:"Infant Mortality Rate", subtitle: "Per 1,000 live births", styles: { type: "CHOROPLETH", stroke: {color: 0x222222}, fill: { colors: [0xFEE5D9, 0xFCAE91, 0xFB6A4A, 0xDE2D26, 0xA50F15], categories: 5, classificationNumClasses: 5, classificationType: "EQUAL INTERVAL", opacity: 0.75, selectedAttribute: "IM1q0"}}, infosubtitle: null, table: null, description: "Mortality rate, infant (per 1,000 live births) Infant mortality rate is the number of infants dying before reaching one year of age, per 1,000 live births in a given year.\nSource: Inter-agency Group for Child Mortality Estimation (UNICEF, WHO, World Bank, UNPD, universities and research institutions).\nCatalog Source: World Development Indicators"},  
    "Maternal Health": {source: "finder:", title:"Births attended by skilled health staff ", subtitle: "% of Total", styles: { type: "CHOROPLETH",stroke: {color: 0x222222}, fill: { colors: [0x511483, 0x835BA4, 0xC090BD, 0xE3BBC2, 0xFCE3D7], categories: 5, classificationNumClasses: 5, classificationType: "EQUAL INTERVAL", opacity: 0.75, selectedAttribute: "DBHP"}}, infosubtitle: null,table: null, description: "Births attended by skilled health staff (% of total), are the percentage of deliveries attended by personnel trained to give the necessary supervision, care, and advice to women during pregnancy, labor, and the postpartum period; to conduct deliveries on their own; and to care for newborns.\nSource: UNICEF, State of the World's Children, Childinfo, and Demographic and Health Surveys by Macro International."},
    "Population": {source: "finder:", title:"Population", subtitle: "Total Number of People", styles: { type: "CHOROPLETH",stroke: {color: 0x222222}, fill: { colors: [0xEFF3FF, 0xBDD7E7, 0x6BAED6, 0x3182BD, 0x08519C], categories: 5, classificationNumClasses: 5, classificationType: "EQUAL INTERVAL", opacity: 0.75, selectedAttribute: "population from statoids"}}, infosubtitle: null, table: null, description: "The land area of the world is divided into countries (1). Most of the countries are, in turn, divided into smaller units. These units may be called states, provinces, regions, governorates, and so on. A phrase that describes them all is 'major administrative divisions of countries'.\n\nSource: <a href='http://www.statoids.com/ubo.html'>Statoids"}
	},
  F1.WorldBank.prototype = {
    init: function(map_id, region) {
      
      var self = this;
      this.activities = {};
      this.projects = {};
      this.visibleSectors = [];
      this.sectors = {};
      this.total_funding = 0;
      this.stylelayers = {};
      this.initialized = false;
      this.current_indicator = "Poverty";
      this.current_projects = true;
      this.region = region;
            
      // icons = {};
      // jq.each(self.sectors, function(sector) {
      //   icons[self.sectors[sector].name] = self.sectors[sector].icon;
      // });
      		
      this.wbicons = {"Agriculture, Fishing, and Forestry":"http://wbstaging.geocommons.com/images/icons/worldbank/agriculture-on.png","Communications":"http://wbstaging.geocommons.com/images/icons/worldbank/communication-on.png","Education":"http://wbstaging.geocommons.com/images/icons/worldbank/education-on.png","Energy and Mining":"http://wbstaging.geocommons.com/images/icons/worldbank/energy-on.png","Finance":"http://wbstaging.geocommons.com/images/icons/worldbank/finance-on.png","Health and Other Social Services":"http://wbstaging.geocommons.com/images/icons/worldbank/health-on.png","Industry and Trade":"http://wbstaging.geocommons.com/images/icons/worldbank/industry-on.png","Public Administration, Law, and Justice":"http://wbstaging.geocommons.com/images/icons/worldbank/public-on.png","Transportation":"http://wbstaging.geocommons.com/images/icons/worldbank/transportation-on.png","Water, Sanitation, and Flood Protection":"http://wbstaging.geocommons.com/images/icons/worldbank/water-on.png"};
      this.wbsectors = ["agriculture","public","education","health","water","transportation","energy","finance"]
      this.sectors = {
        "agriculture": {name: "Agriculture, Fishing, and Forestry", funding: 0, projects: [], activities: 0, shortname: "agriculture", icon: "http://wbstaging.geocommons.com/images/icons/worldbank/agriculture-on.png"}, 
        "communications": {name: "Communications", funding: 0, projects: [], activities: 0, shortname: "communications", icon: "http://wbstaging.geocommons.com/images/icons/worldbank/communication-on.png"},
        "education": {name: "Education", funding: 0, projects: [], activities: 0, shortname: "education", icon: "http://wbstaging.geocommons.com/images/icons/worldbank/education-on.png"}, 
        "energy": {name: "Energy and Mining", funding: 0, projects: [], activities: 0, shortname: "energy", icon: "http://wbstaging.geocommons.com/images/icons/worldbank/energy-on.png"},
        "finance": {name: "Finance", funding: 0, projects: [], activities: 0, shortname: "finance", icon: "http://wbstaging.geocommons.com/images/icons/worldbank/finance-on.png"},
        "health": {name: "Health and Other Social Services", funding: 0, projects: [], activities: 0, shortname: "health", icon: "http://wbstaging.geocommons.com/images/icons/worldbank/health-on.png"},
        "industry": {name: "Industry and Trade", funding: 0, projects: [], activities: 0, shortname: "industry", icon: "http://wbstaging.geocommons.com/images/icons/worldbank/industry-on.png"},
        "public": {name: "Public Administration, Law, and Justice", funding: 0, projects: [], activities: 0, shortname: "public", icon: "http://wbstaging.geocommons.com/images/icons/worldbank/public-on.png"},
        "water": {name: "Water, Sanitation, and Flood Protection", funding: 0, projects: [], activities: 0, shortname: "water", icon: "http://wbstaging.geocommons.com/images/icons/worldbank/water-on.png"},
        "transportation": {name: "Transportation", funding: 0, projects: [], activities: 0, shortname: "transportation", icon: "http://wbstaging.geocommons.com/images/icons/worldbank/transportation-on.png"}};
        
      this.sector_names = {};
      jq.each(self.sectors, function(sector) {return self.sector_names[self.sectors[sector].name] = sector });
        
      this.map = new F1.Maker.Map( { dom_id:"wb_map",map_id:map_id, 
                uiZoom: true,uiLayers: false,uiLegend: false,uiStyles: true,
                uiHeader: true,hideGCLogo: true,hideGILogo: true,
                core_host:  proxy_host + '/', finder_host:proxy_host + '/', maker_host: proxy_host + '/',
                onload: function() { self.loadedMap() }
      });
    },
    setBookmark: function(key, value) {
      
    },
    setState: function(location,indicator,project,sectors) {
      var self = this;
      if(location != null)
        setLocation("",location.lat,location.lon,location.zoom);
      if(indicator != null)
        this.setIndicator(indicator);
      if(sectors != null){
        jq.each(sectors, function(sector) {
          self.toggleSector(sectors[sector], true);
        })
          
      } else {
        this.toggleSector('none', false)
      }
      return false;
    },
    setLocation: function(region,lat,lon,zoom) {
      // this.setBookmark('region', region);
      this.map.swf.setCenterZoom(lat,lon,zoom);
      return false;
    },
    hideSectors: function() {
      var self = this;
      jq.each(self.sectors, function (sector) {
        self.map.addFilter(self.stylelayers["Project Locations"].order, {expression: "$[sector1] == " + self.sectors[sector].shortname});
      });
      return false;
    },
    setMapTitle: function() {
      var title = "";
      if(this.current_projects)
        title += "Projects by ";
      if(this.current_indicator)
        title += this.current_indicator;
        
      jq('#map-title').html(title)
      return false;
    },
    toggleSector: function(sector,visible) {
      var self = this;
      var visibleExpression = "";

      self.current_projects = visible;
      
      if(sector == "none") {
        self.map.showLayer(self.stylelayers["Project Locations"].order, visible);
        self.map.showLayer(self.stylelayers["Project Counts"].order, visible);        
      } else if(sector == 'all') {
        if(visible == null)
          visible = (jq("#sall").is(':checked'));
        if(visible) {
          jq.each(self.sectors, function(sector) {
            if(Object.include(self.visibleSectors, sector) == null)
              self.visibleSectors.push(sector);
          });
        } else {
          self.map.swf.clearFilters(self.stylelayers["Project Locations"].order);
          self.visibleSectors = [];
        }
        self.map.showLayer(self.stylelayers["Project Locations"].order, visible);
        self.map.showLayer(self.stylelayers["Project Counts"].order, !visible);
        jq('#layercontrol_sectors').html("By Sector");
      } else if(sector == 'counts_admin1') {
        self.map.showLayer(self.stylelayers["Project Counts"].order, visible);
        self.map.swf.clearFilters(self.stylelayers["Project Counts"].order);
        self.map.swf.addFilter(self.stylelayers["Project Counts"].order, {expression: "$[admprecision] == 'ADM1'"});
        self.map.showLayer(self.stylelayers["Project Locations"].order, !visible);
        jq('#layercontrol_sectors').html("Project Count");
      } else if(sector == 'counts_admin2') {
        self.map.showLayer(self.stylelayers["Project Counts"].order, visible);
        self.map.swf.clearFilters(self.stylelayers["Project Counts"].order);
        self.map.swf.addFilter(self.stylelayers["Project Counts"].order, {expression: "$[admprecision] == 'ADM2'"});

        self.map.showLayer(self.stylelayers["Project Locations"].order, !visible);        
        jq('#layercontrol_sectors').html("Project Count");
      } else if(sector == 'counts') {
        self.map.showLayer(self.stylelayers["Project Counts"].order, visible);
        self.map.showLayer(self.stylelayers["Project Locations"].order, !visible);
      } else if(sector == null) {
        self.map.showLayer(self.stylelayers["Project Locations"].order, false);
        self.map.showLayer(self.stylelayers["Project Counts"].order, false);
      } else {
        if(visible == null)
          visible = !(jq("#sectorcontrol_" + sector).hasClass('active'));

        if(visible == true){
          self.map.showLayer(self.stylelayers["Project Counts"].order, false);
          self.map.showLayer(self.stylelayers["Project Locations"].order, false);
          self.map.swf.removeFilter(self.stylelayers["Project Locations"].order, 
          {expression: self.complexSectorExpression(self.visibleSectors)});

          if(Object.include(self.visibleSectors, sector) == null) {
            self.visibleSectors.push(sector);    

            self.map.swf.addFilter(self.stylelayers["Project Locations"].order, 
            {expression: self.complexSectorExpression(self.visibleSectors)});
          }

          self.map.showLayer(self.stylelayers["Project Locations"].order, true);
          jq('#layercontrol_sectors').html("By Sector");

        } else if(visible == false){
          // self.map.showLayer(self.stylelayers["Project Counts"].order, false);
          self.map.swf.removeFilter(self.stylelayers["Project Locations"].order, 
          {expression: self.complexSectorExpression(self.visibleSectors)});
          self.visibleSectors = jQuery.grep(self.visibleSectors, function(value) {
            return value != sector;
          });
          self.map.swf.addFilter(self.stylelayers["Project Locations"].order, {expression: self.complexSectorExpression(self.visibleSectors)});
          jq('#layercontrol_sectors').html("Projects");
        }
      }
      self.setMapTitle();
      self.showVisibleSectors();
      //jq('#sector_funding_description').html("Description about " + sector);
      //self.sectorPieChart(sector);
      return false;
    },
    showVisibleSectors: function() {
      var self = this;
      var sectorcontrols = jq('.sectorcontrol');

      jq.each(sectorcontrols, function(sc) {
        var sector_dom = jq("#" + sectorcontrols[sc].id);
        var sector = sector_dom.attr("sector-name");

        if(Object.include(wb.visibleSectors, sector) != null) {
          sector_dom.removeClass('inactive').addClass('active');
        } else {
          sector_dom.removeClass('active').addClass('inactive');            
        }
      });
      return false;
    },
    complexSectorExpression: function(sectorFilters, sector_attribute) {
      var self = this;
      var expression = "";
      if(sector_attribute == null)
        sector_attribute = "sector1";
        
      for(var sector=0;sector<sectorFilters.length; sector++) {
        expression += "$["+sector_attribute+"] == '" + self.sectors[sectorFilters[sector]].name + "'";
        if(sector != sectorFilters.length-1)
          expression += " OR ";
      };
      return expression;
    },    
    setIndicator: function(indicator,visible) {
      var self = this;
      self.map.showLayer(self.stylelayers[self.current_indicator].order, false);
      if(indicator == null) {
        jq('#layercontrol_indicators').html("Indicators");
        self.map.showLayer(self.stylelayers[indicator].order, false);
      }
      else {
        jq('#layercontrol_indicators').html(indicator);
        
        var style = F1.WorldBank.indicators[indicator].styles;
        style.source = self.stylelayers[indicator].source;
        
        if(self.stylelayers[indicator].sharedLayer)
            self.map.setLayerStyle(self.stylelayers[indicator].order, style);
            
        var infotabs = [];
        if(F1.WorldBank.indicators[indicator].table != null)
          infotabs.push({title: "Data", type:"table", value:F1.WorldBank.indicators[indicator].table})
        if(F1.WorldBank.indicators[indicator].description != null)
          infotabs.push({title: "About", type: "text", value:F1.WorldBank.indicators[indicator].description})
        var infosub = F1.WorldBank.indicators[indicator].subtitle;
        if(F1.WorldBank.indicators[indicator].infosubtitle != null)
          infosub = F1.WorldBank.indicators[indicator].infosubtitle
          
        self.map.swf.addLayerInfoWindowFilter(self.stylelayers[indicator].order, {title: indicator + ": $["+ F1.WorldBank.indicators[indicator].styles.fill.selectedAttribute +"]", subtitle: infosub, tabs:infotabs});

        self.map.swf.setLayerTitle(self.stylelayers[indicator].order, F1.WorldBank.indicators[indicator].title);
        self.map.swf.setLayerSubTitle(self.stylelayers[indicator].order, F1.WorldBank.indicators[indicator].subtitle);
        self.map.showLayer(self.stylelayers[indicator].order, true);
      }
      self.current_indicator = indicator;
      self.setMapTitle();
      return false;
      
    },
    highlightProject: function(project_id) {
      var self = this;
      var highlightExpression = "$[project id] == '"+project_id+"'";
      this.map.swf.clearHighlights(self.stylelayers["Project Locations"].order);
      this.map.swf.addHighlight(self.stylelayers["Project Locations"].order,highlightExpression);
      return false;
      return false;
    },
    sortData: function(data) {
      var self = this;
      self.activities = jq.map(data.features, function(feature) { 
        if (feature) {
          attr = feature.attributes;
          if(self.projects[attr["project id"]] == null) { // first time we've seen this project ID
            var project = {};

            // Get the project level attributes
            for(var i = 0;i<project_attributes.length;i++) {
              if(project_attributes[i] != "activity count")
                project[project_attributes[i]] = attr[project_attributes[i]];
            }
            project["financing amount"] = attr["total amt"];
            project["financing"] = "$" + attr["total amt"] + " million";
            project["activity count"] = 0;
            self.projects[attr["project id"]] = project
            
            // Add to sector funding and project count
            var sector_name = project["sector1"];
            var wb_sector = self.sectors[self.sector_names[sector_name]];

            if(wb_sector == null)
              wb_sector = self.sectors["public"];
              
            wb_sector.funding += attr["total amt"];
            wb_sector.projects.push(project);
            self.total_funding += wb_sector.funding;
          }
          self.projects[attr["project id"]]["activity count"] += 1;

          return attr;
        }
      });      
    },
    projectTable: function(data) {
      var self = this;
      data.attributes["activity count"] = {original_name: "activity county", name: "Activities"}
      data.attributes["financing"] = {original_name: "financing", name: "Financing"}
      data.features = this.projects;

      F1.Visualizer.charts.grid(500, 960, data, "projects-table", project_attributes, {"project-id": "project id"});
      
      jq("#projects-table_grid tr").click(function() {
        self.highlightProject(jq(this).attr("project-id"));
      });
      jq("#projects-bar").click(function() {
          if(jQuery(this).hasClass("expanded")) {
            jq("#projects-table").hide("blind", { direction: "vertical" }, 2000);
            jq(this).removeClass("expanded").addClass("collapsed");      
          } else {
            jq("#projects-table").show("blind", { direction: "vertical" }, 2000);
            jq(this).removeClass("collapsed").addClass("expanded");  
          }
      });  


      jq('#project_count').html(Object.size(this.projects));
      jq('#activity_count').html(this.activities.length);
          
      
    },
    sectorPieChart: function(sector_name) {
      var self = this;

      var projects = [];
      var funding = 0;
      var sector_names = "";
      if(sector_name == "all") {
        for(var sn in self.sectors) {
          projects.push(self.sectors[sn].projects);
          funding += self.sectors[sn].funding;
        }
        projects = projects.flatten(); 
      } else {
        // projects = self.sectors[sector_name].projects;
        // funding = self.sectors[sector_name].funding;
        for(var sn=0;sn<self.visibleSectors.length;sn++) {
          if(self.sectors[self.visibleSectors[sn]] != null) {
            projects.push(self.sectors[self.visibleSectors[sn]].projects);
            funding += self.sectors[self.visibleSectors[sn]].funding;
            if(sn != 0){
              sector_names += ", ";
            }
            sector_names += self.visibleSectors[sn].capitalize();
          }
        }
        
        projects = projects.flatten();
      }
      
      if(projects.length == 0){
        jq('#chart-left-pie-chart').hide();
        jq('#sector_funding_total').html("There are no projects in this sector.");
        return;
      }
            
      jq('#sector_funding_title').html("Project Funding for " + sector_names + " Projects <a href='#footnote' title='(as of June 30,2010)'>[1]</a>")
      jq('#sector_funding_total').html(funding.toFixed(1) + " Million");
      
      var links = jq.map(projects, function (project) { 
          return "javascript:wb.highlighProject('" + project["project id"] + "');";  
        });
      
      pie_options = {"features":projects, 
          "attributes": {"data":{"name": "Funding","original_name": "financing amount"},
          "description":{"name": "Project","original_name": "project id"}, 
          "sort":{"name": "Funding","original_name": "financing amount"} } };
      jq('#chart-left-pie-chart').show();

      F1.Visualizer.charts.pie(180, 505, pie_options, "chart-left-pie-chart", {href: links });
    },
    sectorFundingBars: function() {
      var self = this;
      var s;
      var features = [];
      var links = [];

      for(s in self.sectors) { 
        features.push(self.sectors[s]);
        links.push( self.sectors[s]["sector"] );
      }

      jq('#funding_total').html(self.total_funding.toFixed(1) + " Million");
      
      bar_options = {"features":features, "attributes": {
            "data":{"name": "Financing", "original_name": "funding"}, 
            "description":{"name": "Sector", "original_name": "sector1"}, 
            "sort":{"name": "Total Amount","original_name": "funding"} } };
      F1.Visualizer.charts.bar(180, 455, bar_options, "chart-right-graph", {href: links, label: function() {
        return links[this.bar.index];
      }, onclick: function() {
          wb.toggleSector(links[this.bar.index]);
         }});
    },
    getLayers: function() {
      var self = this;
      var findlayers = ["Indicators", "Project Locations", "Project Counts", "Population", "Poverty", "Infant Mortality", "Maternal Health", "Malnutrition"];
      var possibleLayers = self.map.getLayers();
      var index;
      jq.each(possibleLayers, function(layer) {
        index = Object.include(findlayers, possibleLayers[layer].title);
        if(index != null){
          self.stylelayers[findlayers[index]] = {order: possibleLayers[layer].order, source: possibleLayers[layer].source, sharedLayer: false};
          if(Object.include(["Infant Mortality", "Population", "Poverty", "Maternal Health", "Malnutrition"], possibleLayers[layer].title)) {
            F1.WorldBank.indicators[possibleLayers[layer].title].styles.fill.selectedAttribute = possibleLayers[layer].styles.fill.selectedAttribute;
          }
          // self.map.swf.setLayerTitle(possibleLayers[layer].order, F1.WorldBank.indicators[possibleLayers[layer].title]);
          // self.map.swf.setLayerSubTitle(possibleLayers[layer].order, F1.WorldBank.indicators[possibleLayers[layer].subtitle]);
          findlayers.splice(index,1);
        }        
      })

      // second pass if we missed any
      jq.each(findlayers, function(layer) {
        self.stylelayers[findlayers[layer]] = {order: self.stylelayers["Indicators"].order, source: self.stylelayers["Indicators"].source, sharedLayer: true};
        // we'll set the title & subtitle later
      });

       
       
      jq('#download_data').attr('href','http://wbstaging.geocommons.com/datasets/' + self.stylelayers["Project Locations"].source.replace("finder:","")  + ".csv")
       return false;
    },
    styleMap: function() {
      var self = this;
            
      // icons
      self.map.swf.addLayerCategoryFilter(self.stylelayers["Project Locations"].order, {attribute:"sector1",categories:self.wbicons});
      
      // infowindow
      self.map.swf.addLayerInfoWindowFilter(self.stylelayers["Project Locations"].order, {title: "$[project title]", subtitle: "$[sector1]", tabs:[{title: "Financing", type: "text", value:"Project ID: <a target='_new' href='http://web.worldbank.org/external/projects/main?pagePK=64283627&piPK=73230&theSitePK=40941&menuPK=228424&Projectid=$[project id]'>$[project id]</a>\nProject Name: $[project title]\nSector:$[sector1]\nTotal Amount: $ $[total amt] million"}, {title: "Location", type: "text", value: "Province: $[adm1]\nDistrict: $[adm2]\n\n$[precision description]"}]});
      
      self.map.swf.addLayerInfoWindowFilter(self.stylelayers["Project Counts"].order, {title: "Projects: $[project count]", subtitle: "", tabs:[{title:"About", type:"text", value: "There are $[project count] active projects in the region."}]});
      
      // self.map.swf.addLayerInfoWindowFilter(self.stylelayers["Project Counts"].order, {title: "Projects: $[project count]", subtitle: "Total Projects working in $[adm1 name]", tabs:[{title: "Projects", type: "text", value:"<ul><li><a target='_new' href='http://web.worldbank.org/external/projects/main?pagePK=64283627&piPK=73230&theSitePK=40941&menuPK=228424&Projectid=$[pid1]'>$[pid1]</a></li><li><a target='_new' href='http://web.worldbank.org/external/projects/main?pagePK=64283627&piPK=73230&theSitePK=40941&menuPK=228424&Projectid=$[pid2]'>$[pid2]</a></li><li><a target='_new' href='http://web.worldbank.org/external/projects/main?pagePK=64283627&piPK=73230&theSitePK=40941&menuPK=228424&Projectid=$[pid3]'>$[pid3]</a></li><li><a target='_new' href='http://web.worldbank.org/external/projects/main?pagePK=64283627&piPK=73230&theSitePK=40941&menuPK=228424&Projectid=$[pid4]'>$[pid4]</a></li><li><a target='_new' href='http://web.worldbank.org/external/projects/main?pagePK=64283627&piPK=73230&theSitePK=40941&menuPK=228424&Projectid=$[pid5]'>$[pid5]</a></li><li><a target='_new' href='http://web.worldbank.org/external/projects/main?pagePK=64283627&piPK=73230&theSitePK=40941&menuPK=228424&Projectid=$[pid6]'>$[pid6]</a></li><li><a target='_new' href='http://web.worldbank.org/external/projects/main?pagePK=64283627&piPK=73230&theSitePK=40941&menuPK=228424&Projectid=$[pid7]'>$[pid7]</a></li><li><a target='_new' href='http://web.worldbank.org/external/projects/main?pagePK=64283627&piPK=73230&theSitePK=40941&menuPK=228424&Projectid=$[pid8]'>$[pid8]</a></li><li><a target='_new' href='http://web.worldbank.org/external/projects/main?pagePK=64283627&piPK=73230&theSitePK=40941&menuPK=228424&Projectid=$[pid9]'>$[pid9]</a></li><li><a target='_new' href='http://web.worldbank.org/external/projects/main?pagePK=64283627&piPK=73230&theSitePK=40941&menuPK=228424&Projectid=$[pid10]'>$[pid10]</a></li><li><a target='_new' href='http://web.worldbank.org/external/projects/main?pagePK=64283627&piPK=73230&theSitePK=40941&menuPK=228424&Projectid=$[pid11]'>$[pid11]</a></li><li><a target='_new' href='http://web.worldbank.org/external/projects/main?pagePK=64283627&piPK=73230&theSitePK=40941&menuPK=228424&Projectid=$[pid12]'>$[pid12]</a></li><li><a target='_new' href='http://web.worldbank.org/external/projects/main?pagePK=64283627&piPK=73230&theSitePK=40941&menuPK=228424&Projectid=$[pid13]'>$[pid13]</a></li><li><a target='_new' href='http://web.worldbank.org/external/projects/main?pagePK=64283627&piPK=73230&theSitePK=40941&menuPK=228424&Projectid=$[pid14]'>$[pid14]</a></li></ul>"}]});

    },
    styleLegend: function() {
      this.map.showControl("Legend",true);
      this.map.swf.setStyle( { legend: { buttonBgColor:0x92948C, buttonPlacement:"horizontal", buttonFontColor:0xFFFFFF, buttonBgAlpha:0.7,offset:{x:0,y:95}}});      
      return false;
    },
    highlightRegions: function(regions, region_attr) {
        var self = this;
        if(region_attr == null)
            region_attr = "Country";
        
        self.map.swf.clearHighlights(0);
        jq.map(regions,function(region) {
            self.map.swf.addHighlight(0, "$["+region_attr+"] == '"+region+"'");
        });
    },
    hideLoading: function() {
      jq("#loading").hide();
      jq(".loaded").show();
    },
    drawCharts: function() {
      var self = this;
      // jq("#sall").attr('checked', false); // clear the checkbox
      
      if( self.initialized ) {return;}

      self.getLayers(self.map);
      self.styleMap(self.map);
      F1.Visualizer.utils.get_data_from_flash(self.stylelayers["Project Locations"].source.replace("finder:",""),   
        function(data) {
          self.sortData(data);
          self.projectTable(data);
          wb.setIndicator("Poverty");
          wb.toggleSector("counts_admin1",true)
          self.hideLoading();
          // self.sectorFundingBars();
          self.initialized = true;
        }, self.map);
      },
      styleWorldMap: function() {
          var self = this;
         self.highlightRegions(["Kenya","Philippines","Bolivia"]);
          jq('#project_count').html("1,517");
          jq('#activity_count').html("12,000");
          
          self.map.swf.addLayerInfoWindowFilter(0, {title: "$[Country_1]", subtitle: "$[count] Projects", tabs: [{title:"About", type: "text", value: "There are currently $[count] active World Bank projects in $[Country_1].\n\nYou can explore the growing list of available project profiles in countries through the 'Locations' option at the bottom of the map."}]});
          
          
         self.hideLoading();
      },
      loadedMap: function() {
         var self = this;
         self.styleLegend();
         if(self.region != "World"){
            self.drawCharts();
         } else {
             self.styleWorldMap();
         }
      }
  }


})();  // preserving the global namespace
  
