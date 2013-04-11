$("document").ready(function(){
	
	$('a.download').on('click', function(event) {
		target = $(this).attr("rel");
		url = $(this).attr("href");
		if(target != "" && target != undefined) ga('send', 'event', 'download', target, url);
	});
	
	$('a.view').on('click', function(event) {
		target = $(this).attr("rel");
		url = $(this).attr("href");
		if(target != "" && target != undefined) ga('send', 'event', 'view', target, url);
	});
});
