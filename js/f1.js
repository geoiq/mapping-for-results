var table_templates = {
    tr : '<tr><%= row %></tr>',
    th : '<th><%= header %></th>',
    td : '<td><%= cell %></td>',
    project: '<tr class="<%= even %>" project-id="<%= id %>"><td><%= id %></td><td><%= project_name %></td><td><%= boardapprovaldate %></td><td><%= totalamt %></td><td><%= mjsector1 %></td></tr>'
};

var UserHeader = Class.create({
 initialize: function() {
     this.logged_in = $('user_header').hasClassName('logged_in');
 },
 show_login_for: function(username) {
     $('user_header').removeClassName('logged_out');
     $('user_header').addClassName('logged_in');
     $$('#user_header .current_user_login_name')[0].innerHTML = username;
     Effect.Fade('logged_out_notice');
     Effect.Appear('logged_in_notice', {queue: 'end'});
     this.logged_in = true;
 },
 show_logout: function() {
     Effect.Fade('logged_in_notice');
     Effect.Appear('logged_out_notice', {queue: 'end'});
     this.logged_in = false;
 },
 signup_link: function() {
     return $$('#user_header .show_signup')[0]
 },
 login_link: function() {
     return $$('#user_header .show_login')[0]
 }
});


// Share link
var ShareLink = Class.create({
 initialize: function() {
     $$('a.share').each(function(element){
         Event.observe(element, 'click', this.share.bindAsEventListener(this));
     }.bind(this))
     $$('a.unshare').each(function(element){
         Event.observe(element, 'click', this.unshare.bindAsEventListener(this));
     }.bind(this))
 },
 share: function(ev){
     Event.stop(ev);
     el = ev.element()
     id = el.href.replace(/(.*\/)([0-9]+)(\/.*)/,"$2")
     new Ajax.Request(el.href, { 
             onSuccess: this.share_on.bind(this),
             onFailure: function() {alert("Something went wrong. Please refresh the page and try that again.")}
     })
 },
 unshare: function(ev){
     Event.stop(ev);
     el = ev.element()
     id = el.href.replace(/(.*\/)([0-9]+)(\/.*)/,"$2")
     new Ajax.Request(el.href, { 
             method: 'delete',
             onSuccess: this.share_off.bind(this),
             onFailure: function() {alert("Something went wrong. Please refresh the page and try that again.")}
     })
 },
 share_on: function(transport) {
     $('share_'+ transport.responseText).hide()
     $('unshare_'+ transport.responseText).show()
     LayerAddButtons.add_reason($$('overlay_'+transport.responseText+' b_map').first(),'not_shared')
 },
 share_off: function(transport) {
     $('unshare_'+ transport.responseText).hide()
     $('share_'+ transport.responseText).show()
     LayerAddButtons.remove_reason($$('overlay_'+transport.responseText+' b_map').first(),'not_shared')
 }
})

LayerAddButtons = {
  add_reason: function(el,reason) {
    if(reason == 'too_big') {
      el.addClassName('reason_too_big')
    } else if(reason == 'not_shared') {
      el.addClassName('reason_not_shared')
    }
    LayerAddButtons.update_state(el)
  },
  remove_reason: function(el,reason) {
    if(reason == 'too_big') {
      el.removeClassName('reason_too_big')
    }
    if(reason == 'not_shared') {
      el.removeClassName('reason_not_shared')
    }
    LayerAddButtons.update_state(el)
  },
  update_state: function(el) {
    if(el.hasClassName('reason_too_big')) {
      el.title = "This layer is too big to add to your map."
      el.addClassName('disabled')
    } else if(el.hasClassName('reason_not_shared')) {
      el.title = "Please share this layer before mapping."
      el.addClassName('disabled')
    } else {
      el.title = ''
      el.removeClassName('disabled')
    }
  }
}


// Tag Adder
// OverlayEdit's click-to-add-a-tag-to-the-list thing
var TagAdder = Class.create({
 initialize: function(options) {
     this.delimiter = ' '
     this.target_field = options["target_field"]
     this.tags = []
     options["source_elements"].each(function(element){
         this.tags.push(element.innerHTML) //cache source tags
         Event.observe(element, 'click', this.add_tag.bindAsEventListener(this)) //add tags when clicked
     }.bind(this))
     //Event.observe(this.target_field, 'change', this.check_tags.bindAsEventListener(this))
 },
 add_tag: function(ev) {
     if(!Object.isElement(ev)) {
         this.ev = ev
         Event.stop(ev)
         var el = ev.element()
     } else {
         var el = ev
     }
     var tag = el.innerHTML
     this.reload_selected_tags() // grabs tags from the target field
     if (!this.selected_tags.include(tag)) {
         this.selected_tags.push(tag)
         el.addClassName('added')
     } else {
         this.selected_tags = this.selected_tags.findAll(function(t) { return t != tag; }.bind(this))
         el.removeClassName('added')
     }
     this.target_field.value = this.special_join(this.selected_tags, ' ')
 },
 check_tags: function(ev) {
     this.reload_selected_tags()
         new Ajax.Request('/tags', { 
             method: 'get',
             onSuccess: this.check_tags_success.bind(this),
             parameters: Object.toQueryString({q:this.special_join(this.selected_tags,'|'),delimiter:this.delimiter}),
             onFailure: function() {alert("Something went wrong. Please refresh the page and try that again.")}
         })
 },
 check_tags_success: function(transport) {
     var known_tags = transport.responseText.split(this.delimiter)
     this.reload_selected_tags()
     unknown = this.selected_tags.select(function(value) {return !known_tags.include(value)})
     this.display_tags_unknown(unknown)
 },
 display_tags_unknown: function(tags) {
     if (tags.length == 0) { 
         if( $('overlay_tag_list_tip').visible() ){ new Effect.BlindUp('overlay_tag_list_tip', {duration: 0.2})}
         return
     }
     if (tags.length > 1) {
         $('overlay_tag_list_tip').innerHTML = "The following tags are new to Finder: " + this.link_tags(tags) + ". Are they spelled correctly?"
     } else {
         $('overlay_tag_list_tip').innerHTML = "The following tag is new to Finder: " + this.link_tags(tags) + ". Is it spelled correctly?"
     }
     if (!$('overlay_tag_list_tip').visible()) { 
         new Effect.BlindDown('overlay_tag_list_tip', {duration: 0.2})
     }
 },
 reload_selected_tags: function() {
     this.selected_tags = this.special_split(this.target_field.value)
 },
 special_split: function(s) { // turn 'foo "tag with space" bar' into an array
     var a = s.split(' ');
     var tags = [];
     var collect = "";
     var join = false;
     a.each(function(x){
         var xs = x.strip()
         if (xs == '') {throw $break}
         if(xs.match(/^\"/)) {join = true;}
         if(join) {collect += x.strip() + ' '} else {tags.push(xs);}
         if(xs.match(/\"$/)) {
              join = false; 
              tags.push(collect.replace(/"/g,'').strip());
              collect="";
         }
     })
     return tags;
 },
 special_join: function(a, delim) { // turn ['foo', 'tag with space', 'bar'] into a string
     var s = '';
     a.each(function(x){ if (x.match(/ /)) {s += '"' + x + '"' + delim} else {s += x + delim} })
     return s
 },
 link_tags: function(tags) {
     var l =  tags.map(function(t){return "<a href='#' class='tag' onclick='tag_adder.add_tag(this)'>" + t +"</a>"})
     if(l.length > 1) {
         return l.slice(0,-1).join(', ') + ' and ' + l.last()
     } else {
         return l[0]
     }
 }
})

//Tag Browser: Home page (or anywhere else #tag_browser with a ul>li elements exist), click a tag, get a menu
var TagBrowser = Class.create({
 initialize: function(options) {
     this.last_menu = ''
     options["source_elements"].each(function(element){
         Event.observe(element, 'click', this.item_click.bindAsEventListener(this)) //show menu when clicked
     }.bind(this))
 },
 item_click: function(ev) {
     Event.stop(ev)
     el = ev.element()
     p =  el.parentNode
     this.menu = $$('#' + p.id + " .tag_menu")[0]
     Event.observe(this.menu, 'mouseover', this.show_menu.bindAsEventListener(this))
     Event.observe(this.menu, 'mouseout', this.hide_menu.bindAsEventListener(this))
     this.menu.clonePosition(p, {setWidth: true, setHeight: false, offsetTop: -2, offsetLeft: -10})
     this.show_menu()
     this.hide_last_menu()
     this.last_menu = this.menu
 },
 show_menu: function() { this.menu.show() },
 hide_menu: function() { this.menu.hide() },
 hide_last_menu: function() { if (this.last_menu != '' && this.last_menu != this.menu) {this.last_menu.hide()} }
})

Object.extend(Event, {
     observe_if_present: function(element,eventName,handler) {
         Object.isElement(element) ? Event.observe(element,eventName,handler) : false
     }
})


var OverlayDownload = {
  initialize: function() {
    var myMenuItems = [
      {
        name: 'KML (Google Earth)',
        className: 'm_kml', 
        callback: function(e) {
          window.location=e.target.href + '.kml'
        }
      },{
        name: 'CSV (Spreadsheet)',
        className: 'm_csv', 
        callback: function(e) {
          window.location=e.target.href + '.csv'
        }
      },{
        name: 'Shapefile',
        className: 'm_shapefile', 
        callback: function(e) {
          window.location=e.target.href + '.zip'
        }
      }
    ]
    new Proto.Menu({
      selector: '#results .b_download', // context menu will be shown when element with id of "contextArea" is clicked
      className: 'menu f1', // this is a class which will be attached to menu container (used for css styling)
      menuItems: myMenuItems // array of menu items
    })
    //     $$('#results .result').each(function(element){
    //  Event.observe(element, 'click', this.clicked.bindAsEventListener(this));
    // }.bind(this))
  },
  clicked: function() {
    alert('click!')
  }
}

// Simple toggle header used originally on finder's overlays/edit. See overlays/_form.html.erb
// To use, just add the classes 'flippy flippy_some_element' where some_element is the one you
// wish to unfold. If you want a different scriptaculous effect: 'flippy flippy_some_element effect_appear'.
// To initialize call Flippy.initialize()
var Flippy = {
  initialize: function() {
    $$('.flippy').invoke('observe','click', function(ev){
      ev.stop(); var el = ev.element();
         while(!el.hasClassName('flippy')) {el = $(el.parentNode)}
         var target = id_from_class_pair(el, 'flippy')
         var effect = id_from_class_pair(el, 'effect')
         if (effect == el.className) {effect = 'blind'}
         Effect.toggle(target, effect, {duration:0.5});
         el.select('a')[0].toggleClassName('on')
    })
  }
}

function id_from_class_pair(el, action) {
  var r = new RegExp(".*"+action+"_([^ ]+).*")
  return el.className.replace(r,'$1')
}

Textify = {
 this_many_words: function(s,count) {  
    if (s == null || !s.length) return ''
    if (s.split(' ').length <= count) return s 
    return s.split(' ').slice(0,count).join(' ') + '...'
  },
  
  short_enough: function(s,count) {
    if (count) {s = Textify.this_many_words(s,count)}
    s = s.replace(/[^ ]{40,}/,'[edited]')
    return s
  },
  
  /**
   * Truncate and add elipses if string exceeds a certain character length
   */
  elide_after: function(s, count, symbol) {
     symbol = (symbol == null ? "&hellip;" : symbol);
    if (s.length > count) {
      return s.substr(0, count-1) + symbol;
    } else {
      return s;
    }
  },

 elide_during: function(s, max, symbol) {
     symbol = (symbol == null ? "&hellip;" : symbol);
    if (s.length > max) {
         var diff = s.length - max;
         var start_gap = parseInt((s.length / 2) - (diff / 2));
         var end_gap = start_gap + diff;
      return s.substr(0, start_gap) + symbol + s.substr(end_gap, s.length-1);
    } else {
      return s;
    }
 },
 
 elide_during_long_stuff: function(s, max, symbol) {
   var matches = s.match(/[^ ]{10,}/g)
   jq.each(matches||[], function(){
     s = s.replace(new RegExp(this), Textify.elide_during(this, max, symbol||'...'))
   })
   return s
 }

}

var Numify
;(function(){
  Numify = function(num) {  //constructor
    this.num = num;
    this.to_s = "";
    return this
  }
  Numify.prototype = {
    humanize: function() {
       n = parseInt(this.num,10)
       var l = (n+'').length
       if      (l<=6)  {  this.to_s = this.num.toFixed(2)+'' } 
       else if (l<=7)  {  this.to_s = (n/1e6 ).toFixed(1) + "mil" }
       else if (l<=8)  {  this.to_s = (n/1e6 ).toFixed(1) + "mil" }
       else if (l<=9)  {  this.to_s = (n/1e6 ).toFixed(1) + "mil" }
       else if (l<=10) {  this.to_s = (n/1e9 ).toFixed(1) + "bil" }
       else if (l<=11) {  this.to_s = (n/1e9 ).toFixed(1) + "bil" }
       else if (l<=12) {  this.to_s = (n/1e9 ).toFixed(1) + "bil" }
       else if (l<=13) {  this.to_s = (n/1e13).toFixed(1) + "tr"  }
       else if (l<=14) {  this.to_s = (n/1e13).toFixed(1) + "tr"  }
       else if (l<=15) {  this.to_s = (n/1e13).toFixed(1) + "tr"  }
       else {             this.to_s = (n / Math.pow(10,l-1)).toFixed(2) + ("e"+(l-1)) }
       return this
     },

     commify: function() {
       if (this.to_s == "") this.to_s = (this.num+'')
     var x = this.to_s.split('.'),
         x1 = x[0],
         x2 = x.length > 1 ? '.' + x[1] : '',
         rgx = /(\d+)(\d{3})/
     while (rgx.test(x1)) {
         x1 = x1.replace(rgx, '$1' + ',' + '$2');
     }
     this.to_s = x1 + x2;
     return this
     },
     
     // keep "5.23mil" but turn "5.00mil" into simply "5mil".
     flatten: function() {
       if (this.to_s == "") this.to_s = (this.num+'')
       this.to_s = this.to_s.replace(/(\.[0]+)\d?/g,'')
       return this
     }
     
  }
})()


// Expandy: Simple Jquery thingy that expands the div reffered to by
// any .expandy element's rel attribute. Example: 
//  <a href="#" class="expandy" rel="#jackpot"/>
//  <div id="jackpot" style="display:none">Expandable!</div>
Expandy = {
  initialize: function() {
    jq('.expandy').click(function() {
      jq(jq(this).attr('rel')).toggle('blind')
      return false
    })
  }
}
jQuery(document).ready(function(){
  if (jq('.expandy').length) Expandy.initialize()
});


// Applies to all form inputs system-wide. Necessary because
// IE sucks and doesn't wire the form submit to enter key
// unless the brower's ugly submit button is visible on page
// load.
// If for some reason you don't want this behavior, just add
// a .no_enter_submit class to an input or one of its parents.
EnterToSubmitBecauseIEisEvil = {
  init: function() {
    jq('input:not(".no_enter_submit, .no_enter_submit input")').keydown(function(e){
        if (e.keyCode == 13) {
            jq(this).parents('form').submit();
            return false;
        }
    });
  }
}
jq(EnterToSubmitBecauseIEisEvil.init)


// Positions raging clues if needed
RagingClue = {
  
  init: function() {
    jq.each(jq('.raging_clue'), function(){
      var el = jq(this)
      var options = el.data('options')
      if (options) {
        if (options.position) { RagingClue.position(el) }
        RagingClue.dismisser(el)
      }
    })
  },
  
  dismisser: function(el) {
    el = jq(el)
    if (el.data('options').dismiss_after) {
      setTimeout(function(){el.fadeOut()}, el.data('options').dismiss_after)
    }
  },
  
  position: function(el) {
    el = jq(el)
    var options = el.data('options')
    var target = jq(options.target)
    
    var left          = target.offset().left
    var top           = target.offset().top
    var arrow_height  = el.find('.arrow').outerHeight() 
    var arrow_width   = el.find('.arrow').outerWidth() 
    var el_height     = el.height()
    var el_width      = el.width()
    var target_height = (target.outerHeight())
    var target_width  = (target.outerWidth())
    
    // the 5's and 7's account for the arrow's drop shadow
    if (options.position === 'above') { top   -= (el_height     + (arrow_height - 7)) }
    if (options.position === 'below') { top   += (target_height + (arrow_height - 5)) }
    if (options.position === 'left')  { left  -= (el_width      + (arrow_width - 7))  }
    if (options.position === 'right') { left  += (target_width  + (arrow_width - 7))  }
    
    if (options.offset_x) left += options.offset_x
    if (options.offset_y) top  += options.offset_y
    
    var op = el.data('options')
    el
      .css({ 
          position:'absolute', 
          'z-index': 10000,
          left: left,
          top: top
      })
      .remove()
      .prependTo('body')
      .data('options',op) // remove when on 1.4 and use detatch instead
  }
  
}
jq(RagingClue.init)

Object.isEmpty = function(object) { for(var i in object) { return false; } return true; }

// Simple JavaScript Templating
// John Resig - http://ejohn.org/ - MIT Licensed
;(function() {
    var cache = {};
    this.tmpl = function tmpl(str, data) {
      // Figure out if we're getting a template, or if we need to
      // load the template - and be sure to cache the result.
      var fn = !/\W/.test(str) ?
      cache[str] = cache[str] ||
      tmpl(document.getElementById(str).innerHTML) :

      // Generate a reusable function that will serve as a template
      // generator (and which will be cached).
      new Function("obj",
        "var p=[],print=function(){p.push.apply(p,arguments);};" +

        // Introduce the data as local variables using with(){}
        "with(obj){p.push('" +

        // Convert the template into pure JavaScript
        str.replace(/[\r\t\n]/g, " ")
         .replace(/'(?=[^%]*%>)/g,"\t")
         .split("'").join("\\'")
         .split("\t").join("'")
         .replace(/<%=(.+?)%>/g, "',$1,'")
         .split("<%").join("');")
         .split("%>").join("p.push('")
         + "');}return p.join('');");

        // Provide some basic currying to the user
        return data ? fn(data) : fn;
    };
})();
