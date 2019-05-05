//
// Copyright 2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Communications;
using Toybox.WatchUi;
using Toybox.Application;

class WebRequestDelegate extends WatchUi.BehaviorDelegate {
    var notify;
    var start_station;
    var end_station;

    // Handle menu button press
    function onMenu() {
        makeRequest();
        return true;
    }

    function onSelect() {
        makeRequest();
        return true;
    }

    function makeRequest() {
      if ( Toybox.Application has :Storage ) {
    // use Application.Storage and Application.Properties methods

} else {
    // use Application.AppBase methods
    // Get an Object Store value
    start_station = Application.getApp().getProperty("start_station");
    end_station = Application.getApp().getProperty("end_station");
}


      if (start_station == "" || end_station == "") {

      }

        notify.invoke("Getting trips...", start_station, end_station);

        Communications.makeWebRequest(\

            "http://www3.septa.org/hackathon/NextToArrive/" + start_station + "/" + end_station,
            {
            },
            {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED
            },
            method(:onReceive)
        );
    }

    // Set up the callback to the view
    function initialize(handler) {
        WatchUi.BehaviorDelegate.initialize();
        notify = handler;
    }

    // Receive the data from the web request
    function onReceive(responseCode, data) {
        if (responseCode == 200) {
            notify.invoke("", start_station, end_station);
            notify.invoke(data, start_station, end_station);
        } else {
            notify.invoke("Couldn't get trips!", start_station, end_station);
        }
    }
}
