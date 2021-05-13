//Functions used by the QML Elements (not exposed through the module)

//Helper Function for DateInput
function setValidDate(dateString)
{
    var Months = {Jan: 0,Feb: 1,Mar: 2,Apr: 3,May: 4,Jun: 5,July: 6,Aug: 7,Sep: 8,Oct: 9,Nov: 10,Dec: 11};
    var day_month_year_positions = {
		"ddmmyy":
			{
				"day":{"start":0,"end":2},
				"month":{"start":3,"end":6},
				"year":{"start":7,"end":11}
			},
		"yymmdd":
			{
				"day":{"start":9,"end":11},
				"month":{"start":5,"end":8},
				"year":{"start":0,"end":4}
			},
		"yyddmm":
			{
				"day":{"start":5,"end":7},
				"month":{"start":8,"end":11},
				"year":{"start":0,"end":4}
			},
		"mmddyy":
			{
				"day":{"start":4,"end":6},
				"month":{"start":0,"end":3},
				"year":{"start":7,"end":11}
			}
		}

    //Extract the year, month and day based on date format from TextField
    var year_text = getText (day_month_year_positions[textFieldID.dateFormat]["year"]["start"], day_month_year_positions[textFieldID.dateFormat]["year"]["end"])
    var month_text = Months[getText(day_month_year_positions[textFieldID.dateFormat]["month"]["start"],day_month_year_positions[textFieldID.dateFormat]["month"]["end"])]
    var day_text = getText(day_month_year_positions[textFieldID.dateFormat]["day"]["start"],day_month_year_positions[textFieldID.dateFormat]["day"]["end"])
    var dateObject = new Date(year_text, month_text,day_text);
    //Check if the date inputted is a valid date
    if( dateObject.getFullYear() === parseInt(year_text) && dateObject.getMonth()===month_text && dateObject.getDate()===parseInt(day_text))
    {
        selectedDate = dateObject.toLocaleString(Qt.locale("en_US"),"yyyy-MM-dd");
    }
    else
	{
        selectedDate = ''
    }
}
