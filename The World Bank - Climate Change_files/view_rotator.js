/**
 * 
 */
Drupal.behaviors.view_rotator = 
function (c) {

  //$(".rotator-nav",c).jcarousel({
  //  itemLastInCallback: navIsLastItem,
  //  wrap:"both",
  //});
  // click function for nav items stops rotation and change items
  $(".rotator-nav li",c).click(function () {
    var item_id = $(this).attr("related-item");
    var content = $("#" + item_id).parents(".rotator-content");
    if ( $(this).is(".rotator-nav-right")) {
      view_rotate_start(content.attr("id"));
    }
    else {
      view_rotate_stop(content.attr("id"));
    }
    view_rotate_to(item_id);
  });
  $(".rotator-nav-previous",c).click(function () {
    view_rotate_previous($(this).attr('content-id'));
  });
  $(".rotator-nav-next",c).click(function () {
    view_rotate_next($(this).attr('content-id'));
  });
  $(".rotator-content",c).each( function() {
    var id = $(this).attr("id");
    view_rotate_init(id);
  });
  
};
var carousel;
function navIsLastItem(c,item) {
  $(item).parent().children("li").removeClass("last-visable");
  $(item).addClass("last-visable");
  carousel = c;
}
/**
 * this function rotates to a rotator-item also ajusting the related nav item
 * @param id: the id of the rotator-item to which to rotate
 * @return none
 */

function view_rotate_to(id,isAuto) {
  var activate = $("#" + id);
  var content    = activate.parents(".rotator-content");
  var nav        = $("#" + content.attr("id") + "-nav");
  var active     = content.find(".active_rotator");
  var active_nav = nav.find(".rotator-nav-item[related-item=" +  active.attr("id") + "]");
  var activate_nav = nav.find(".rotator-nav-item[related-item=" +  activate.attr("id") + "]");
  var right_nav  = nav.find(".rotator-nav-right");
  $(".current-count",nav).html(activate.attr('count'));

  
  right_nav.attr("related-item",activate.attr("next_id"));
  active.hide();
  active.removeClass("active_rotator");
  activate.show();
  activate.addClass("active_rotator");
  //activate.pngFix({blankgif:'sites/default/themes/phase2/blank.gif'});
  if (active_nav.hasClass("last-visable")  && isAuto ) {
    carousel.next();
  }
  active_nav.removeClass("active-rotator-nav");
  activate_nav.addClass("active-rotator-nav");
}

/**
 * this function init the rotator position the item absolutely and starting rotation
 * @param id: the id of the rotator-content to init
 * @return none
 */
function view_rotate_init(content_id) {
  $("#" + content_id +" .rotator-item").css("position","absolute")
    .not(".active_rotator").css("display","none");
  view_rotate_start(content_id);
}
/**
 * this function rotates to the next item if rotation is on
 * it also then sets a timeout for a new rotation 
 * @param id: the id of rotator-content whose item is to be rotated
 * @return none
 */
function view_rotate_next(content_id) {
  var content = $("#" + content_id);
  if (content.attr("rotating") == "true") {
    var activate = $("#" + content.find(".active_rotator").attr("next_id")) ;
    view_rotate_to(activate.attr("id"),true);
    var delay = content.attr("delay") * 1000;
    clearTimeout(view_rotate_action);
    view_rotate_action = setTimeout("view_rotate_next('"+content_id+"')",delay);
  }
}
function view_rotate_previous(content_id) {
  var content = $("#" + content_id);
  if (content.attr("rotating") == "true") {
    var activate = $("#" + content.find(".active_rotator").attr("previous_id")) ;
    view_rotate_to(activate.attr("id"),true);
    var delay = content.attr("delay") * 1000;
    clearTimeout(view_rotate_action);
    view_rotate_action = setTimeout("view_rotate_previous('"+content_id+"')",delay);
  }
}
/**
 * this function starts rotation
 * @param id: the id of the rotator-content to be started
 * @return none
 */
function view_rotate_start(content_id) {
  var content = $("#" + content_id);
  if (content.attr("rotating") != "true") {
    var delay = content.attr("delay") * 1000;
    content.attr("rotating", "true");
    view_rotate_action = setTimeout("view_rotate_next('"+content_id+"')",delay);
  }
  
}
/**
 * this function stops rotation
 * @param id: the id of rotator-content to be stopped
 * @return none
 */
function view_rotate_stop(content_id) {
  var content = $("#" + content_id);
  $("#" + content_id).removeAttr("rotating");
}
