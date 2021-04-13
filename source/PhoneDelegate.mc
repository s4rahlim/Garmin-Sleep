//!
//! Copyright 2016 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

using Toybox.WatchUi;
using Toybox.Attention;

class PhoneDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
    	System.println("ButtonDelegate::initialize");
        BehaviorDelegate.initialize();
    }

    function onBack() {
    	System.println("ButtonDelegate::onBack");
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

    function onPreviousPage() {
    	System.println("ButtonDelegate::onPreviousPage");
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        return true;
    }

    function onMenu() {
    	System.println("PhoneDelegate::onMenu");
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE); //pop view
        return true;
    }
    
        function onSwipe(evt) {
        var swipe = evt.getDirection();

        if (swipe == SWIPE_UP) {
        	System.println("CheckBoxDelegate::onSwipe - SWIPE_UP");
        	WatchUi.popView(WatchUi.SLIDE_IMMEDIATE); //pop view
            setActionString("SWIPE_UP");
        } else if (swipe == SWIPE_RIGHT) {
        	WatchUi.popView(WatchUi.SLIDE_IMMEDIATE); //pop view
            setActionString("SWIPE_RIGHT");
        } else if (swipe == SWIPE_DOWN) {
        	System.println("CheckBoxDelegate::onSwipe - SWIPE_DOWN");
        	WatchUi.popView(WatchUi.SLIDE_IMMEDIATE); //pop view
            setActionString("SWIPE_DOWN");
        } else if (swipe == SWIPE_LEFT) {
        	System.println("CheckBoxDelegate::onSwipe - SWIPE_LEFT");
        	WatchUi.popView(WatchUi.SLIDE_IMMEDIATE); //pop view
            setActionString("SWIPE_LEFT");
        }
        return true;
    }
}
