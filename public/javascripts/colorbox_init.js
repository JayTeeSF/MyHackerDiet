/*
	This file contains the necessary code to get Colorbox rockin'!
	(C) 2009 Nicholas Young, All Rights Reserved
	Based on the Colorbox Lightbox for jQuery 1.3 by Jack Moore (http://colorpowered.com/colorbox).
	Please don't use without attribution - that isn't cool... Open-source is about giving!
*/

jQuery(document).ready(function() {
	jQuery(".iframe").colorbox({width:"80%", height:"80%", iframe:true});
	jQuery(".colorbox").colorbox();
});
