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