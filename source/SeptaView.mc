// View controller.

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;

class SeptaView extends WatchUi.View {
  hidden var mMessage = "";
  hidden var mStart = "";
  hidden var mEnd = "";
  hidden var mModel;

  function initialize() {
    WatchUi.View.initialize();
  }

  function onLayout(dc) {
    WatchUi.BehaviorDelegate.initialize();
  }

  // Restore the state.
  function onShow() {
    var cache = Application.getApp().getProperty("last_trips");
    var start_station = Application.getApp().getProperty("start_station");
    var end_station = Application.getApp().getProperty("end_station");
    if (cache instanceof Toybox.Lang.Array) {
      if (cache.size() != 0) {
        System.println(cache);
        onReceive(cache, start_station, end_station);
      }
    }


  }

  // Update the widget view.
  function onUpdate(dc) {
    // Load a pretty icon and draw it.
    var image = WatchUi.loadResource( Rez.Drawables.septa_logo_32 );
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
    dc.clear();
    dc.drawBitmap(35, 5, image);

    // Show start and end station indicator.
    var stationText = Lang.format("$1$\n$2$\n", [mStart, mEnd]);
    dc.drawText(75, 1, Graphics.FONT_XTINY,  stationText, Graphics.TEXT_JUSTIFY_LEFT);

    // Draw the rest of the message (trips and times).
    dc.drawText(dc.getWidth()/2, 50, Graphics.FONT_MEDIUM, mMessage, Graphics.TEXT_JUSTIFY_CENTER);
  }

  // Supposed to save the state here.
  function onHide() {
  }

  // Called on a view update. Data received from invoke().
  function onReceive(data, start_station, end_station) {
    mStart = start_station;
    mEnd = end_station;
    if (data instanceof Lang.String) {
      if (data == "") {
        mMessage = "";
        WatchUi.requestUpdate();
        return;
      }
      // Handle a string.
      mMessage = data;
      WatchUi.requestUpdate();
      return;
    } else {
      mMessage = "";


      // the outer element is an array, iterate over the elements.
      for (var i = 0; i < data.size(); ++i) {
        var entry = data[i];

        // each entry in the array is a dictionary. lookup fields by name.
        var depart = entry.get("orig_departure_time");
        var delayed = entry.get("orig_delay");
        mMessage += Lang.format("$1$ ($2$)", [depart, delayed]) + "\n";
      }

      if (data.size() == 0) {
        mMessage = "No trips found.";
      }
    }


    WatchUi.requestUpdate();
  }
}
