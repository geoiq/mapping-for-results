Drupal.behaviors.search_box = function(c) {
  
  jQuery('#search-box label',c).each(function () {
    jQuery(this).addClass('over-input');
    jQuery(this).html(jQuery('#search-box label',c).html().replace(':',''));
  });
  jQuery('#search-box .form-text',c).keyup(function() { 
    if(jQuery(this).val() == '') {
      jQuery(this).parent().removeClass("text-entered");
    }
    else {
      jQuery(this).parent().addClass("text-entered");
    }
  });

};
