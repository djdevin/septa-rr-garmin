//
// Copyright 2015-2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//


using Toybox.Application;
using Toybox.System;

class SeptaApp extends Application.AppBase {
    hidden var mView;

    function initialize() {
        Application.AppBase.initialize();

        //Initliaze fake settings.
        Application.getApp().setProperty("start_station", "Suburban%20Station");
        Application.getApp().setProperty("end_station", "Swarthmore");
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        mView = new SeptaView();
        return [mView, new SeptaDelegate(mView.method(:onReceive))];
    }
}
