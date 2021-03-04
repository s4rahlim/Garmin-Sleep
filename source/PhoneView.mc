//!
//! Copyright 2016 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

using Toybox.WatchUi;

class PhoneView extends WatchUi.View {

	var phone;

    //! Constructor
    function initialize() {
    	System.println("PhoneView::initialize");
        View.initialize();
        phone = new WatchUi.Bitmap({:rezId=>Rez.Drawables.phone_icon,:locX=>100,:locY=>180});
    }

    //! Load your resources here
    function onLayout(dc) {
    	System.println("PhoneView::onLayout");
        setLayout(Rez.Layouts.PhoneLayout(dc));
    }

    //! Update the view
    function onUpdate(dc) {
    	System.println("PhoneView::onUpdate");
        View.onUpdate(dc);
        phone.draw(dc);
    }
}
