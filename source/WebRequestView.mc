//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi;
using Toybox.Graphics;

class WebRequestView extends WatchUi.View {
    hidden var mMessage = "";
    hidden var mModel;

    function initialize() {
        WatchUi.View.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        mMessage = "Press menu or\nselect button";
    }

    // Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_MEDIUM, mMessage, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    // Called when this View is removed from the screen. Save the
    // state of your app here.
    function onHide() {
    }

// args is the json from thing
    function onReceive(data, start_station, end_station) {
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
        }
        else {

          mMessage += Lang.format("$1$\n$2$\n", [start_station, end_station]);

          // the outer element is an array, iterate over the elements.
          for (var i = 0; i < data.size(); ++i) {
              var entry = data[i];

              // each entry in the array is a dictionary. lookup fields by name.
              var depart = entry.get("orig_departure_time");
              var delayed = entry.get("orig_delay");
              //var load = entry["TrainingLoad"]; // ...
              //var type = entry["TypeId"];       // ...
              mMessage += Lang.format("$1$ ($2$)", [depart, delayed]) + "\n";
          }
        }


        WatchUi.requestUpdate();
    }
}
