// cloud 2dd5ecb3ad41727ff88adbcc7b35e66998b7e004
 
// Generated Sun Jan 08 14:25:49 -0500 2012
(function () {
  var scriptBase;
  jq = null;
  maker_queue = null;

  if(typeof(F1)=='undefined') { F1 = {}; F1.Maker = {}; F1.Embed = {}}

  F1.blocker = true;
 
  if (window){
    window.log=function(){log.history=log.history||[];log.history.push(arguments);if(this.console){console.log(Array.prototype.slice.call(arguments))}};
  }
  
  F1.Maker.Map = function(options){
    var self = this;
    self.method_queue = [];
    maker_queue = options;
    this.methods = "showControl hideControl getExtent setExtent getCenterZoom getCenter setCenter setCenterZoom getZoom setZoom setBasemap getBasemap updateBasemap getMapProviderList getMapProvider setMapProvider getFeature getFeatures selectFeature addFilter getFilters clearFilters removeFilter doFilter removeAllFilters addFeature saveMap getLayers removeLayer addLayer showLayer getLayerGuidByIndex getLayer addFeatures loadFeatures addTimeFilter addTimeFilters setTimeFilter filterFeatures getMapStyle setMapStyle setStyle addStyle styleLayer setLayerStyle updateAttributes getAllAttributes setCallback addHighlight removeHighlight clearHighlights getHighlights addHighlight setLayerTitle setLayerSubTitle addLayerCategoryFilter setLayerInfoWindow addLayerInfoWindowFilter showEmbedWindow getLayerStyle getLayerColors setLayerColors setLayerOrder showEmbedWindow setSize setTitle setDescription setClassification setClassificationFromLayer setClassificationId getAttributes getLayerTitle setPermissions setTags getGeometries setLayerAttributes setLayerProperties getFilteredFeatureCount getVisibleFeatureCount getVisibleFeatures getLayerTemporalAttribute getTemporalResolution setTemporalResolution getTimeSlots setTimeSpan getTimeSpan getGlobalTimeSpan getVisibleTimeSpan setLayerTemporalAttribute getPixelsFromLocation getLocationFromPixels getFeaturesFromLocation openInfoWindow closeInfoWindow setLayerDynamics setLayerTooltip updateFeatures saveFeatures deleteFeatures deleteCallback getLayerFeatureChanges".split(/[ \t\n]+/);
    for (var i = 0; i < this.methods.length; ++i) {
      (function(name,self) {
          self[name] = function() {
            if (!self.ready) { // queue calls until api is ready
              self.method_queue.push([name,arguments])
            } else {
              if (self.wrapped_methods[name]) { 
                return self.wrapped_methods[name].apply(self,arguments) 
              }
            }
          }
      })(this.methods[i],this) // closure allows the wrapper function to know the function name
    }
    self.wrapped_methods = {};
    F1.Embed = this;
  }

  js_loaded = function(){
      setTimeout(function(){
          if (maker_queue !== undefined && maker_queue !== null){
              if (maker_queue.dom_id && !jq('#'+maker_queue.dom_id+'_embed').get().length) {
                  jq('<div id="'+ maker_queue.dom_id +'_embed" style="" />').appendTo(jq('#'+maker_queue.dom_id));
              }
              var f1map;
              setTimeout(function () {
                if (F1.blocker){
                  setTimeout(arguments.callee, 25);
                  return;
                }
                f1map = new F1.Maker.Map(maker_queue);
                // wrap map fn to local user embed var
                setTimeout(function () {
                  if (!f1map._layers) { // append_to node not yet ready
                    setTimeout(arguments.callee, 25);
                    return;
                  }
                  for (var meth in f1map){
                    F1.Embed[meth] = f1map[meth];
                  }
                }, 0);
              }, 0);
          }
          },100);
      }

  //old embed support for Maker.load_map
  if(typeof(Maker)=='undefined') { Maker = {};}
  Maker.load_map = function(dom_id,map_id){
    return F1.Maker.Map.apply(this,[{dom_id: dom_id, map_id: map_id}]);
  }

  var scripts = document.getElementsByTagName('script');
  for (var i = 0; i < scripts.length; i++) {
    var match = scripts[i].src.replace(/%20/g , '').match(/^(.*?)f1\.api\.js(\?\(\[?(.*?)\]?\))?.*$/);
    if (match != null) {
      scriptBase = match[1];
      var url_parts = scriptBase.split('/')
      F1.host = url_parts[0] + "//" + url_parts[2].replace(/maker./, '') // set the F1.host 
    } else {
      match = scripts[i].src.replace(/%20/g , '').match(/^(.*?)embed\.js(\?\(\[?(.*?)\]?\))?.*$/);
      if (match != null) {
        scriptBase = match[1];
        var url_parts = scriptBase.split('/');
        F1.host = url_parts[0] + "//" + url_parts[2];
      }
    }
  }

  var css_scripts = ['/stylesheets/external.min.css'];
  var head = document.getElementsByTagName("head")[0];
  for (var i = 0; i < css_scripts.length; i++){
    var fh = document.createElement("link");
    fh.type = "text/css";
    fh.rel = "stylesheet";
    fh.href = F1.host+css_scripts[i];
    head.appendChild(fh);
  }


  if(!f1_js_included) {

      function loadJS(global, oDOC, loadDoc, handler) {
        var head = oDOC.head || oDOC.getElementsByTagName("head");

        // loading code borrowed directly from LABjs itself
        setTimeout(function () {
            if ("item" in head) { // check if ref is still a live node list
                if (!head[0]) { // append_to node not yet ready
                    setTimeout(arguments.callee, 25);
                    return;
                }
                head = head[0]; 
            }
            var scriptElem = oDOC.createElement("script"),
                scriptdone = false;
            scriptElem.onload = scriptElem.onreadystatechange = function () {
                if ((scriptElem.readyState && scriptElem.readyState !== "complete" && scriptElem.readyState !== "loaded") || scriptdone) {
                    return false;
                }
                scriptElem.onload = scriptElem.onreadystatechange = null;
                scriptdone = true;
                handler(this);
            };
            scriptElem.src = scriptBase + loadDoc;
            head.insertBefore(scriptElem, head.firstChild);
        }, 0);

        // required: shim for FF <= 3.5 not having document.readyState
        if (oDOC.readyState == null && oDOC.addEventListener) {
            oDOC.readyState = "loading";
            oDOC.addEventListener("DOMContentLoaded", handler = function () {
                oDOC.removeEventListener("DOMContentLoaded", handler, false);
                oDOC.readyState = "complete";
            }, false);
        }
      }
      
      loadJS(window, document, 'LAB.min.js', function() {
        $LAB.script(scriptBase + "jquery-1.6.2.min.js").wait(function(){
          jq = jQuery.noConflict();
      
        $LAB.script("http://maps.worldbank.org/javascripts/external.min.js").wait()
            .script("http://maps.worldbank.org/javascripts/visualize.min.js").wait(function(){
            js_loaded()
        });
      
          });
      });
  }

  var f1_js_included = true;
})(); 
