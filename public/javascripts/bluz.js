jQuery(document).ready(function() {
	bluz_portfade();							
	bluz_engage();
	bluz_minor();
});


function bluz_portfade(){
	jQuery('ul.gallery li a img').hover(function(){
		jQuery(this).stop().fadeTo(500, 0.4); //portfolio effect
	}, function() {
		jQuery(this).stop().fadeTo(300, 1);
	});
}

function bluz_engage(){
	jQuery('ul.sf-menu').superfish({ 
        delay:       250  // one second delay on mouseout 
	});
	jQuery('#login-holder a').fancybox();
	jQuery('.lightbox').fancybox({'titlePosition' : 'outside'});
	Cufon.replace('h1, h2, h3, h4, h5, h6, .dropcap', {hover: 'true'}); 
	Cufon.replace('.plan h4, .footer-colum h4, .widget .title h5',{textShadow: '#000 0px -1px'});
	Cufon.replace('.slide h2, #pagename h2',{textShadow: '#000 1px 1px'});
	Cufon.replace('.colum h3',{textShadow: '#fff 1px 1px'});
	jQuery(".pricing-table tr:even").addClass("even");
}

function bluz_minor(){
	jQuery('span.close').click(function() {
		jQuery(this).parent().slideUp(400,"easeInCubic");					   
	});
	jQuery('.footer-colum li:last-child').css("border-bottom", "none");
	jQuery('.footer-colum li:first-child').css("border-top", "none");
	jQuery('[rel=tipsy]').tipsy({fade: true, gravity: 's'});
}
