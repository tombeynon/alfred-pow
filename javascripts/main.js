$("document").ready(function(){
	
	$('a.download').on('click', function(event) {
		target = $(this).attr("rel");
		if(target != "" && target != undefined) ga('send', 'event', 'download', target);
	});
	
	$('a.view').on('click', function(event) {
		target = $(this).attr("rel");
		if(target != "" && target != undefined) ga('send', 'event', 'view', target);
	});
});
