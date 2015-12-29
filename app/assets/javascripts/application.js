// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require_tree .
//= require jquery.validate
//= require jquery.validate.additional-methods
//= require s3_direct_upload
//= require masonry/jquery.masonry
//= require masonry/jquery.imagesloaded.min
//= require masonry/modernizr-transitions
$(function(){
	$(document).foundation();
	  window.fbAsyncInit = function() {
	    FB.init({
	      appId      : '111172898196',
	      xfbml      : true,
	      version    : 'v2.5'
	    });
	  };
});


jQuery(function() {
	jQuery.support.placeholder = false;
	test = document.createElement('input');
	if('placeholder' in test) jQuery.support.placeholder = true;
});
(function( $, undefined ) {
    $.notification = function(options) {
        var opts = $.extend({}, {type: 'notice', time: 4200}, options);
        var o    = opts;

        timeout          = setTimeout('$.notification.removebar()', o.time);
        var message_span = $('<span />').addClass('jbar-content').html(o.message);
        var wrap_bar     = $('<div />').addClass('jbar jbar-top').css("cursor", "pointer");
    	if (o.type == 'error') {
          wrap_bar.css({"color": "#D8000C"})
        };

        wrap_bar.bind("click", function(){
            $.notification.removebar()
        });
        $('#notice').empty();
		$('#notice').prepend(wrap_bar.append(message_span));

    };


    var timeout;
    $.notification.removebar    = function(txt) {
        if($('.jbar').length){
            clearTimeout(timeout);

            $('.jbar').fadeOut('fast',function(){
                $(this).remove();
            });
        }
    };


})(jQuery);


$(document).ready(function(){
    var showChar = 200; // How many characters are shown by default
    var ellipsestext = "...";
    var moretext = "Show more >";
    var lesstext = "Show less";


    $('.more').each(function() {
        var content = $(this).html();

        if(content.length > showChar) {

            var c = content.substr(0, showChar);
            var h = content.substr(showChar, content.length - showChar);

            var html = c + '<span class="moreellipses">' + ellipsestext+ '&nbsp;</span><span class="morecontent"><span>' + h + '</span>&nbsp;&nbsp;<a href="" class="morelink">' + moretext + '</a></span>';

            $(this).html(html);
        }

    });

    $(".morelink").click(function(){
        if($(this).hasClass("less")) {
            $(this).removeClass("less");
            $(this).html(moretext);
        } else {
            $(this).addClass("less");
            $(this).html(lesstext);
        }
        $(this).parent().prev().toggle();
        $(this).prev().toggle();
        return false;
    });
	$('.notifications-menu').hover(function() {
		$('#notifications-menu').toggle();
	});
	$('.posts-menu').hover(function() {
		$('#posts-menu').toggle();
	});
	$('.users-menu').hover(function() {
		$('#users-menu').toggle();
	});
	$('.stats-menu').hover(function() {
		$('#stats-menu').toggle();
	});
	$('.games-menu').hover(function() {
		$('#games-menu').toggle();
	});
	$('.personal-menu').hover(function() {
		$('#personal-menu').toggle();
	});
	$('.about-menu').hover(function() {
		$('#about-menu').toggle();
	});


	$(document).on('click', '.flag', function() {
		$(this).closest('.post').find('.flag-options').toggle();
	});
	$(document).on('click', '.close', function() {
		$(this).closest('.post').find('.flag-options').toggle();
	});

});

  (function(d, s, id){
     var js, fjs = d.getElementsByTagName(s)[0];
     if (d.getElementById(id)) {return;}
     js = d.createElement(s); js.id = id;
     js.src = "//connect.facebook.net/en_US/sdk.js";
     fjs.parentNode.insertBefore(js, fjs);
   }(document, 'script', 'facebook-jssdk'));
