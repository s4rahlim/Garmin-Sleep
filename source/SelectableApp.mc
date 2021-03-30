//!
//! Copyright 2016 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

using Toybox.Application;

(:background)



class SelectableApp extends Application.AppBase {
	
	var watchView;

    function initialize() {
    	System.println("SelectableApp::initialize");
        AppBase.initialize();
    	

    }

    // onStart() is called on application start up
    function onStart(state) {
    	System.println("SelectableApp::onStart");
    	
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    	System.println("SelectableApp::onStop");
    	if (watchView){
    		watchView.setBackgroundEvent();
    	}
    }

    // Return the initial view of your application here
    function getInitialView() {
    	System.println("SelectableApp::getInitialView");
    	watchView = new WatchFaceView();
        return [ watchView, new ButtonDelegate() ];
    }

}