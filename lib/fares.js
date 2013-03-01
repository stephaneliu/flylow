var page = require('webpage').create();
page.open('https://fly.hawaiianairlines.com/Calendar/Default.aspx?qrys=qres&Trip=RT&adult_no=1&departure=PDX&destination=HNL&out_day=06&out_month=05&stepNo=2&return_day=09&return_month=05&isEAward=0&isOBEAward=0&isRTEAward=1', function (status) {
    // page.render('hal.png');

    if (status !== "success") {
      console.log('Unable to access site');
      phantom.exit();
    } else {
      page.includeJs("http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js", function() {
        var fare =  page.evaluate(function() {
                      return $('.CalendarDayCheapest .Fare').first().text();
                    });
        console.log("cheap: " + fare);
        phantom.exit();
      });
    }
});
