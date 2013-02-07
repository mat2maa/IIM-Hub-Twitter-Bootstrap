// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
jQuery.noConflict();

jQuery.ajaxSetup({  
  'beforeSend': function (xhr) {xhr.setRequestHeader("Accept", "text/javascript")}  
});

function remove_fields(link) {
  $(link).previous("input[type=hidden]").value = "1";
  $(link).up(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).up().insert({
    before: content.replace(regexp, new_id)
  });
}

jQuery.fn.submitWithAjax = function() {
  this.unbind('submit', false);
  this.submit(function() {
    jQuery.post(this.action, jQuery(this).serialize(), null, "script");
    return false;
  })

  return this;
};

//This will "ajaxify" the links
function ajaxLinks(){
  jQuery('.ajaxForm').submitWithAjax();
}

jQuery(document).ready(function() {

	// All non-GET requests will add the authenticity token
	// if not already present in the data packet
	jQuery(document).ajaxSend(function(event, request, settings) {
	   if (typeof(window.AUTH_TOKEN) == "undefined") return;
     // <acronym title="Internet Explorer 6">IE6</acronym> fix for http://dev.jquery.com/ticket/3155
     if (settings.type == 'GET' || settings.type == 'get') return;
     settings.data = settings.data || "";
     settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(window.AUTH_TOKEN);
   });
  ajaxLinks();
});