// define object to save state of items collapsed
state = new RollerState();
Drupal.behaviors.collapsible = function (c) {
 // Define function for expanding from the header
  // it selects the correct header and fires the show or hide function 
  // of the content
  jQuery(".collapsible-header",c).click(function() {
    if (jQuery(this).hasClass("expanded")) {
      jQuery(this).trigger("collapse");
    }
    else {
      jQuery(this).trigger("expand");
    }
  })
  .bind("expand", function () {
    var content_id = jQuery(this).attr("content_id");
    jQuery("#"+content_id).trigger('show');
    if (jQuery(this).is(":has(.expanded-header)")) {
      jQuery(this).find(".collapsed-header").css("display","none");
      jQuery(this).find(".expanded-header").css("display","block");
    }
    jQuery(this).addClass("expanded").removeClass("collapsed");
    state.remove(content_id);
  })
  .bind("collapse", function (e,noDelay) {
    var content_id = jQuery(this).attr("content_id");
    jQuery("#"+content_id).trigger('hide', noDelay);
    if (jQuery(this).is(":has:(.collapsed-header)")) {
      jQuery(this).find(".collapsed-header").css("display",'block');
      jQuery(this).find(".expanded-header").css("display",'none');
    }
    jQuery(this).addClass("collapsed").removeClass("expanded");;
    state.add(content_id);
  });
  // Define functions for hide and show on content using the params 
  // from the params attr
  jQuery(".collapsible-content",c).bind("hide", function(e, noDelay) {
    if (noDelay==true) {
      jQuery(this).hide();
    }
    else {
      params_string = jQuery(this).attr("params");
      params = eval('(' + params_string + ')');
      jQuery(this).hide(params.effect,params.option,params.delay);
    }
  })
  .bind("show", function() {
    params_string = jQuery(this).attr("params");
    params = eval('(' + params_string + ')');
    jQuery(this).show(params.effect,params.option,params.delay);
  });
  jQuery(".collapsible .frame-title",c).click( function () {
    jQuery(this).parents(".collapsible").trigger("switch");
  });
  //check to see if there is a cookie for the state of the roll outs
  //if so ajust the blocks
  // turned off cookie look up
  //if (state.getCookie() == null) {
  if (true) {
    jQuery(".collapsed.collapsible-header",c).trigger("collapse",[true]);
  }
  else {
    for (i = 0 ; i<state.state.length ;i ++) {
      jQuery("*[content_id='" + state.state[i] +"']",c).trigger("collapse",[true]);
    }
  }
};

/* Define State Object */
function RollerState() {
  this.state = Array();
  this.add = function(item) {
    if (!in_array(item, this.state)) {
      this.state.push(item);
      this.saveCookie();
    }
  }
  this.remove = function(item) {
    for ( i=0; i < this.state.length; i++ ) {
      if (this.state[i] == item) {this.state.splice(i,1);}  
    }
    this.saveCookie();
    
  }
  this.saveCookie = function() {
    createCookie("cf_org_state_collapsed", this.state.toString());
    
  }
  this.getCookie = function() {
  var stateString = readCookie("cf_org_state_collapsed");
  if (stateString != null) {
    this.state = stateString.split(",");
  }
  return stateString;
  
  }
  this.isClosed = function(item) {
    return in_array(item, this.state);
  }
}

function createCookie(name,value,days) {
	if (days) {
		var date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();
	}
	else var expires = "";
    var path =window.location.pathname;
	document.cookie = name+"="+value+expires+"; path="+path;
}

function readCookie(name) {
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++) {
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
}
function eraseCookie(name) {
	createCookie(name,"",-1);
}
function in_array(needle, haystack) {
  for ( i=0; i < haystack.length; i++ ) {
    if (haystack[i] == needle) { return true}  
  }
  return false;

}

