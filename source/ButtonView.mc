//!
//! Copyright 2016 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

using Toybox.WatchUi;

class ButtonView extends WatchUi.View {

    //! Constructor
    function initialize() {
    	System.println("ButtonView::initialize");
        View.initialize();
    }

    //! Load your resources here
    function onLayout(dc) {
    	System.println("ButtonView::onLayout");
        setLayout(Rez.Layouts.ButtonLayout(dc));
    }

    //! Update the view
    function onUpdate(dc) {
    	System.println("ButtonView::onUpdate");
        View.onUpdate(dc);
    }
}
