//Functions used by the QML Elements (not exposed through the Qml module)

function DateInput_onFocusChanged()
{
    if (focus === true)
    {
        inputMask = textFieldID.maskFormat[textFieldID.dateFormat];
    }
    else
    {
        z=0;
        if (text === "\/\/")
        {
            inputMask = "" ; 
        }
        if (textFieldID_cal_box.visible === true)
        { 
            textFieldID_cal_box.visible = false
        }
    }
}

function DateInput_setValidDate(dateString)
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

function TimeInput_24hour_onFocusChanged()
{
    if (focus === true)
    {
        inputMask = "xx:xx;-";
    }
    else
    {
        z = 0;
        if (text === ":")
        {
            inputMask = ""
        }
        if (time_ID_timeBox.visible === true)
        {
            time_ID_timeBox.visible=false
        }
    }
}

function TimeInput_24hour_onTextChanged()
{
    time_ID_hours.currentIndex = parseInt(getText(0,2))
    time_ID_min.currentIndex = parseInt(getText(3,5))
    if(getText(0,2) === '--' || getText(3,5) === '--')
    {
        time_ID.selectedTime = '';
    }
    else
    {
        time_ID.selectedTime = time_ID.text
    }
}

function TimeInput_24hour_onClicked()
{
    time_ID.forceActiveFocus();
    time_ID_timeBox.visible = !time_ID_timeBox.visible;
    time_ID.z = time_ID_timeBox.visible?1:0;
    time_ID_hours.currentIndex = parseInt(time_ID.getText(0,2));
    time_ID_min.currentIndex = parseInt(time_ID.getText(3,5));
}

function TimeInput_12hour_onFocusChanged()
{
    if (focus === true) 
    {
        inputMask = "xx:xx >xx;-"; 
    }
    else
    {
        z=0;
        if (text === ": " ) 
        { 
            inputMask = "" 
        }
        if (time_ID_timeBox.visible === true)
        {
            time_ID_timeBox.visible = false
        }
    }
}

function TimeInput_12hour_onTextChanged()
{
    time_ID_hours.currentIndex = parseInt(getText(0,2))-1;
    time_ID_min.currentIndex = parseInt(getText(3,5));
    var tt_index = 3;
    var hh = getText(0,2);
    switch (getText(6,8))
    { 
        case 'PM':
            tt_index = 1; 
            if (parseInt(getText(0,2)) !== 12)
            {
                hh = parseInt(getText(0,2)) + 12;
            } 
            break;
        case 'AM':
            tt_index = 0; 
            if (parseInt(getText(0,2)) === 12)
            {
                hh = parseInt(getText(0,2))-12;
            } 
            break;
    }
    time_ID_tt.currentIndex = tt_index;
    if (getText(0,2) === '--' || getText(3,5) === '--' || getText(6,8) === '--')
    {
        time_ID.selectedTime = '';
    } 
    else
    {
        time_ID.selectedTime = (hh === 0 ? '00' : hh) + ':' + getText(3,5);
    }
}

function TimeInput_12hour_onClicked()
{
    time_ID.forceActiveFocus();
    time_ID_timeBox.visible = !time_ID_timeBox.visible;
    time_ID.z = time_ID_timeBox.visible?1:0;
    time_ID_hours.currentIndex = parseInt(time_ID.getText(0,2))-1;
    time_ID_min.currentIndex = parseInt(time_ID.getText(3,5));
    var tt_index = 3;
    switch (time_ID.getText(6,8))
    { 
        case 'PM':
            tt_index = 1; 
            break;
        case 'AM':
            tt_index = 0; 
            break;
    }
    time_ID_tt.currentIndex = tt_index;
}
