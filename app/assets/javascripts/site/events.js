var Event = Backbone.Model.extend({
	

});
console.log(new Event());

var EventsList = Backbone.Marionette.CollectionVew.extend({

});

var Calendar = Backbone.View.extend({

});

$('.filter-box').click(function() {
	var filters = [];
	$(this).parent().find('.checkbox').each(function(index) {
		if(index.prop('checked')) {
			filters.push(index.text());
		}
	});
});

$('.month-block').click(function(){
	day = $(this).find('.day-num').text();
	month = $(this).find('.month-num').text();
	year = $(this).find('.year-num').text();
	$(this).parent().find('.month-block').removeClass('selected-day');
	$(this).addClass('selected-day');
	$.ajax({
		url: '/events/change_day',
		type: 'get',
		data: {day: day, month: month, year: year}
	});
});