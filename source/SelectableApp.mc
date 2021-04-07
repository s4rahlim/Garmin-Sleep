//!
//! Copyright 2016 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

using Toybox.Application;
using Toybox.Communications;

(:background)



class SelectableApp extends Application.AppBase {
	
	var watchView;
	var phoneMethod;
	var strings = ["","","","",""];
	var stringsSize = 5;
	var crashOnMessage = false;

    function initialize() {
    	System.println("SelectableApp::initialize");
        AppBase.initialize();
    	
    	phoneMethod = method(:onPhone);
    	if(Communications has :registerForPhoneAppMessages) {
            Communications.registerForPhoneAppMessages(phoneMethod);
        }
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
//		return [new CheckBoxView(), new CheckBoxDelegate()];
    }
    
    function onPhone(msg) {
        var i;

        if((crashOnMessage == true) && msg.data.equals("Hi")) {
            msg.length(); // Generates a symbol not found error in the VM
        }

        for(i = (stringsSize - 1); i > 0; i -= 1) {
            strings[i] = strings[i-1];
        }
        strings[0] = msg.data.toString();

        WatchUi.requestUpdate();
    }
    

}