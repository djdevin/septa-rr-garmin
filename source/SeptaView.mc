//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.

//

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

    // Load your resources here
    /**
    Toybox::Graphics::Dc
    */
    function onLayout(dc) {
        WatchUi.BehaviorDelegate.initialize();
    }

    // Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
     var image = WatchUi.loadResource( Rez.Drawables.septa_logo_50 );
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawBitmap(30, 5, image);

        var stationText = Lang.format("$1$\n$2$\n", [mStart, mEnd]);


        dc.drawText(85, 1, Graphics.FONT_XTINY,  stationText, Graphics.TEXT_JUSTIFY_LEFT);


      dc.drawText(dc.getWidth()/2, 50, Graphics.FONT_MEDIUM, mMessage, Graphics.TEXT_JUSTIFY_CENTER);
    }

    // Called when this View is removed from the screen. Save the
    // state of your app here.
    function onHide() {
    }

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
        }
        else {


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
          
          if (data.size() == 0) {
          mMessage = "No trips found.";
          }
        }


        WatchUi.requestUpdate();
    }
}
