/**
 * App controller.
 */

using Toybox.Application;
using Toybox.System;

class SeptaApp extends Application.AppBase {
  hidden var mView;

  function initialize() {
    Application.AppBase.initialize();
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
    return [mView, new SeptaDelegate(mView.method( : onReceive))];
  }
}
