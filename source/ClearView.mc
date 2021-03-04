//!
//! Copyright 2016 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

using Toybox.WatchUi;

class ClearView extends WatchUi.View {

	var phone;

    //! Constructor
    function initialize() {
    	System.println("ClearView::initialize");
        View.initialize();
//        clear = new WatchUi.Bitmap({:rezId=>Rez.Drawables.clear_icon,:locX=>100,:locY=>180});
    }

    //! Load your resources here
    function onLayout(dc) {
    	System.println("ClearView::onLayout");
        setLayout(Rez.Layouts.ClearLayout(dc));
    }

    //! Update the view
    function onUpdate(dc) {
    	System.println("ClearView::onUpdate");
        View.onUpdate(dc);
//        Clear.draw(dc);
    }
}
