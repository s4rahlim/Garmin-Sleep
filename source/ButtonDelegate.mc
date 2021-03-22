//!
//! Copyright 2016 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

using Toybox.WatchUi;
using Toybox.Attention;

class ButtonDelegate extends WatchUi.BehaviorDelegate {

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
    	System.println("ButtonDelegate::onMenu");
        if( Attention has :vibrate) {
            var vibrateData = [ new Attention.VibeProfile(  25, 100 ),
                    new Attention.VibeProfile(  50, 100 ),
                    new Attention.VibeProfile(  75, 100 ),
                    new Attention.VibeProfile( 100, 100 ),
                    new Attention.VibeProfile(  75, 100 ),
                    new Attention.VibeProfile(  50, 100 ),
                    new Attention.VibeProfile(  25, 100 ) ];

            Attention.vibrate( vibrateData );
        }
        return true;
    }
}
