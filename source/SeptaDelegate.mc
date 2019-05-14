//
// Copyright 2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Communications;
using Toybox.WatchUi;
using Toybox.Application;
using Toybox.System;

class SeptaDelegate extends WatchUi.BehaviorDelegate {
    var notify;
    var start_station;
    var end_station;
    var num_trips;
    hidden var mView;
    hidden var delegate;

    // Handle menu button press
    function onMenu() {

        return true;
    }

    function onSelect() {
    // @todo: geolocate closest start or end
      var tmp = start_station;
      start_station = end_station;
      end_station = tmp;

   
        makeRequest();
        return true;
    }

    function makeRequest() {



      if (start_station == "" || end_station == "") {

      }

        notify.invoke("Getting trips...", start_station, end_station);
		var url = "http://www3.septa.org/hackathon/NextToArrive/?req1=" + start_station + "&req2=" + end_station + "&req3=" + num_trips;
		url = SeptaUtil.stringReplace(url, " ", "+");
        Communications.makeWebRequest(
            url,
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

        if ( Toybox.Application has :Storage ) {
      // use Application.Storage and Application.Properties methods

      } else {
      // use Application.AppBase methods
      // Get an Object Store value
      start_station = Application.getApp().getProperty("start_station");
      end_station = Application.getApp().getProperty("end_station");
		num_trips = Application.getApp().getProperty("num_trips");
      }

        makeRequest();
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
