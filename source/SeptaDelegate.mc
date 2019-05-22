// Behavior delegate.

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


  // Handle menu button press (long "up" press on 235).
  function onMenu() {
    // @todo: geolocate closest start or end
    // Switch the start/end stations.
    var tmp = start_station;
    start_station = end_station;
    end_station = tmp;

    // Make a new request and update the UI.
    makeRequest();

    return true;
  }


  // Handle select button press,
  function onSelect() {
    makeRequest();
    return true;
  }



  // Make a web request to the SEPTA API and request a view update.
  function makeRequest() {

    if (start_station == "" || end_station == "") {
      // Do something about the app not being configured, but this shouldn't happen.
    }

    var progressBar = new WatchUi.ProgressBar( "Getting trips...", null );
    WatchUi.pushView( progressBar, new ProgressDelegate(), WatchUi.SLIDE_IMMEDIATE );

    var url = "http://www3.septa.org/hackathon/NextToArrive/?req1=" + start_station + "&req2=" + end_station + "&req3=" + num_trips;
    url = SeptaUtil.stringReplace(url, " ", "+");

    // URL for testing a 5 second delay.
    //url = "http://httpbin.org/delay/5";

    // Make a web request and callback to onReceive().
    Communications.makeWebRequest(url, {}, {"Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED}, method(:onReceive));
  }

  // Initialize behavior. Make a web request if the cache is not present.
  function initialize(handler) {
    WatchUi.BehaviorDelegate.initialize();
    notify = handler;

    if ( Toybox.Application has :Storage ) {
      // @todo for CIQ >= 2.4
      // use Application.Storage and Application.Properties methods

    } else {
      // use Application.AppBase methods
      // Get an Object Store value
      start_station = Application.getApp().getProperty("start_station");
      end_station = Application.getApp().getProperty("end_station");
      num_trips = Application.getApp().getProperty("num_trips");
    }
    var cache = Application.getApp().getProperty("last_trips");
    if (cache instanceof Toybox.Lang.Array) {
      // Do nothing
    } else {

      makeRequest();
    }
  }

  // Receive the data from the web request
  // `data` is an array of trip objects
  function onReceive(responseCode, data) {
    // Remove the progress bar.
    WatchUi.popView( WatchUi.SLIDE_IMMEDIATE );
    if (responseCode == 200) {
      // Populate cache.
      Application.getApp().setProperty("start_station", start_station);
      Application.getApp().setProperty("end_station", end_station);
      Application.getApp().setProperty("last_trips", data);

      // Invoke the display.
      notify.invoke(data, start_station, end_station);
    } else {
      notify.invoke("Couldn't get trips!");
    }
  }
}

class ProgressDelegate extends WatchUi.BehaviorDelegate {
  function initialize() {
    BehaviorDelegate.initialize();
  }

  function onBack() {
    return true;
  }
}
