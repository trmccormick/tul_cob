// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require 'blacklight_advanced_search'
//= require jquery_ujs
//= require popper
//= require twitter/typeahead

//= require bootstrap
//= require turbolinks//

//= require bootstrap-select
//= require bootstrap/alert
//= require bootstrap/tab

// Required by Blacklight
//= require blacklight/blacklight
//= require blacklight_alma/blacklight_alma

// For blacklight_range_limit built-in JS, if you don't want it you don't need
// this:
//= require 'blacklight_range_limit'

//= require_tree .

$(window).on('turbolinks:load', function() {

	if ($(window).width() < 768) {
		$('#nav-tools').insertAfter('#document');
		$('#bookmarks-tools').insertAfter('#documents');
		$('#bookmarks-tools').removeClass('row');
		$('.clear-bookmarks').insertAfter('#back_to_search');
		$('#facet-filter-icon').removeClass('hidden');
		$('#facet-panel-collapse').removeClass('show');
	}
	else {
		$('#nav-tools').insertAfter('#page-links');
		$('#bookmarks-tools').addClass('row');
		$('#facet-filter-icon').addClass('hidden');
		$('#facet-panel-collapse').addClass('show');
	}
});

$(window).on('resize', function() {
	if ($(window).width() < 768) {
		$('#nav-tools').insertAfter('#document');
		$('#bookmarks-tools').insertAfter('#documents');
		$('#bookmarks-tools').removeClass('row');
		$('.clear-bookmarks').insertAfter('#back_to_search');
		$('#facet-filter-icon').removeClass('hidden');
		$('#facet-panel-collapse').removeClass('show');
	}
	else {
		$('#nav-tools').insertAfter('#page-links');
		$('#bookmarks-tools').addClass('row');
		$('#facet-filter-icon').addClass('hidden');
		$('#facet-panel-collapse').addClass('show');
	}
});


$(document).on('turbolinks:load', function() {
   $(window).trigger('load.bs.select.data-api');
});

$(document).ready(function(){
	$(this).find(':input[id=renew_selected]').prop('disabled', true);
	$('input[type=checkbox]').click(function(){
		var x = document.getElementsByName("loan_ids[]");
		var y = document.getElementById("checkall");
		var checked = false;
		var i;
		$(x).each(function() {
			if( $(this).prop('checked')){
		      checked = true;
		    }
		});
		if (checked == true) {
	    	$(document).find(':input[id=renew_selected]').prop('disabled', false);
	    }
	    else $(document).find(':input[id=renew_selected]').prop('disabled', true);
	});
});


function selectallchecks() {
	var x = document.getElementsByName("loan_ids[]");
	var y = document.getElementById("checkall");
	var i;
	if (y.checked == true) {
		for (i = 0; i < x.length; i++) {
		    if (x[i].type == "checkbox") {
		        x[i].checked = true;
		    }
		}
	}
	else {
		for (i = 0; i < x.length; i++) {
		    if (x[i].type == "checkbox") {
		        x[i].checked = false;
		    }
		}
	}
}

function deselectallchecks() {
	var x = document.getElementsByName("loan_ids[]");
	var y = document.getElementById("checkall");
	y.checked = false;
	var i;
	for (i = 0; i < x.length; i++) {
	    if (x[i].type == "checkbox") {
	        x[i].checked = false;
	    }
	}
}

function loadArticleIframe(id) {
  var element = $(id)
  var url = element.attr("data-iframe-url")

  if (element.attr("processed") == undefined) {
    element.attr("processed", true);
    $("<iframe>", {
      src: url,
      "class": "bl_alma_iframe",
      id: 'iframe-' + id,
    }).appendTo(id);
  }
}

$(document).on('turbolinks:load', function() {
	if ($(".noresults").length >= 1) {
		$("#sortAndPerPage").remove();
		$("#documents").css("border", "none");
	}

 	if ($("div.navbar-form").length == 0) {
 		$("#search-navbar").css("padding-left", "15%");
 	}

	$('#facet-filter-icon').click( function(){
    $(this).find('span#facet-icons').toggleClass('open-facet-icon').toggleClass('remove-facet-icon');
	});
 });

 $(".header-links").on("click", function(){
	 $(this).siblings().removeClass('active');
	 $(this).addClass("active");
 });

 function toggle(x) {
	if (x == "secondary") {
	 document.getElementById("sub-toggler-icon").classList.toggle("change");
	}
	else if (x == "search") {
	 document.getElementById("search-toggler-icon").classList.toggle("change");
	}
	else {
		document.getElementById("main-toggler-icon").classList.toggle("change");
	}
}
