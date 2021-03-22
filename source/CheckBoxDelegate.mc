//!
//! Copyright 2016 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

using Toybox.WatchUi;

var keyToSelectable = false;
var last_key = null;
var last_behavior = null;

class CheckBoxDelegate extends WatchUi.BehaviorDelegate {

	enum {
        ON_NEXT_PAGE,
        ON_PREV_PAGE,
        ON_MENU,
        ON_BACK,
        ON_NEXT_MODE,
        ON_PREV_MODE,
        ON_SELECT
    }

    function initialize() {
    	System.println("CheckBoxDelegate::initialize");
        BehaviorDelegate.initialize();
    }
    
    function onPreviousPage() {
    	System.println("CheckBoxDelegate::onPreviousPage");
        last_behavior = ON_PREV_PAGE;
        setBehaviorString("PREVIOUS_PAGE");
        return false;
    }
    
    function onSelectable(event) {
    	System.println("CheckBoxDelegate::onSelectable");
        var instance = event.getInstance();
//        instance.identifier (check to see which box it is)
		System.println(instance.identifier);
		System.println((instance.getState() == :stateHighlighted));
        if(instance instanceof Checkbox) {
            currentView.checkBoxes.handleEvent(instance, event.getPreviousState());
        }
        return true;
    }

    function onMenu() {
    	System.println("CheckBoxDelegate::onMenu");
    	
    	last_behavior = ON_MENU;
        setBehaviorString("ON_MENU");
        
        keyToSelectable = !keyToSelectable;
        currentView.setKeyToSelectableInteraction(keyToSelectable);
        return true;
    }
    
    function onBack() {
    	// On vivoactive 4, a left-to-right (SWIPE_RIGHT) swipe also acts as a Back key press
        if (ON_BACK == last_behavior) { // dont necessarily 
        	System.println("CheckBoxDelegate::onBack - twice so app exiting, not a crash");
            System.exit();
        }
        last_behavior = ON_BACK;
        setBehaviorString("ON_BACK");
        System.println("CheckBoxDelegate::onBack - do not exit first time of onBack");
        
        return true;
    }
    
    function onNextMode() {
    	System.println("CheckBoxDelegate::onNextMode");
        last_behavior = ON_NEXT_MODE;
        setBehaviorString("ON_NEXT_MODE");
        return false;
    }
    
    function onPreviousMode() {
    	System.println("CheckBoxDelegate::onPreviousMode");
        last_behavior = ON_PREV_MODE;
        setBehaviorString("ON_PREVIOUS_MODE");
        return false;
    }
    
    function onSelect() {
    	System.println("CheckBoxDelegate::onSelect");
        last_behavior = ON_SELECT;
        setBehaviorString("ON_SELECT");
        return false;
    }
    
    function onTap(evt) {
    	System.println("CheckBoxDelegate::onTap");
        setActionString("CLICK_TYPE_TAP");
        return true;
    }
    
    function onHold(evt) {
    	System.println("CheckBoxDelegate::onHold");
        setActionString("CLICK_TYPE_HOLD");
        return true;
    }

    function onRelease(evt) {
    	System.println("CheckBoxDelegate::onRelease");
        setActionString("CLICK_TYPE_RELEASE");
        return true;
    }

    function onSwipe(evt) {
        var swipe = evt.getDirection();

        if (swipe == SWIPE_UP) {
        	System.println("CheckBoxDelegate::onSwipe - SWIPE_UP");
            setActionString("SWIPE_UP");
        } else if (swipe == SWIPE_RIGHT) {
//        	var sensView = new SensorView();
//        	var sensDelegate = new ButtonDelegate();
//        	WatchUi.pushView(sensView, sensDelegate, SLIDE_IMMEDIATE);
//        	System.println("CheckBoxDelegate::onSwipe - SWIPE_RIGHT");
//            setActionString("SWIPE_RIGHT");
        } else if (swipe == SWIPE_DOWN) {
        	System.println("CheckBoxDelegate::onSwipe - SWIPE_DOWN");
            setActionString("SWIPE_DOWN");
            var view = new PhoneView();
        	var delegate = new ButtonDelegate();
        	WatchUi.pushView(view, delegate, SLIDE_IMMEDIATE);
        } else if (swipe == SWIPE_LEFT) {
        	System.println("CheckBoxDelegate::onSwipe - SWIPE_LEFT");
            setActionString("SWIPE_LEFT");
           	var sensView = new WatchFaceView();
//           	SensorView();
	    	var sensDelegate = new ButtonDelegate();
	    	WatchUi.pushView(sensView, sensDelegate, SLIDE_IMMEDIATE);
	    	System.println("CheckBoxDelegate::onSwipe - SWIPE_RIGHT");
        }

        return true;
    }

    function onNextPage() {
    	System.println("CheckBoxDelegate::onNextPage");
    	last_behavior = ON_NEXT_PAGE;
        setBehaviorString("NEXT_PAGE");
        return pushMenu(WatchUi.SLIDE_IMMEDIATE);
    }

//now overriding menu function 
    function pushMenu(slideDir) {
    	System.println("CheckBoxDelegate::pushMenu");
    	
    	//var view = new ButtonView();
        var view = new PhoneView();
//        var view = new ClearView();
        var delegate = new ButtonDelegate();
        WatchUi.pushView(view, delegate, slideDir); //pushing phone view on top, checkbox is still under
        return true;
    }

	function onKeyPressed(evt) {
		System.println("CheckBoxDelegate::onKeyPressed");
        var keyString = getKeyString( evt.getKey() );
        if( keyString != null ) {
            setStatusString( keyString + " PRESSED" );
        }

        return true;
    }

    function onKeyReleased(evt) {
    	System.println("CheckBoxDelegate::onKeyReleased");
        var keyString = getKeyString( evt.getKey() );
        if( keyString != null ) {
            setStatusString( keyString + " RELEASED" );
        }

        return true;
    }

    function getKeyString(key) {
    	System.println("CheckBoxDelegate::getKeyString");
        if (key == KEY_POWER) {
            return "KEY_POWER";
        } else if (key == KEY_LIGHT) {
            return "KEY_LIGHT";
        } else if (key == KEY_ZIN) {
            return "KEY_ZIN";
        } else if (key == KEY_ZOUT) {
            return "KEY_ZOUT";
        } else if (key == KEY_ENTER) {
            return "KEY_ENTER";
        } else if (key == KEY_ESC) {
            return "KEY_ESC";
        } else if (key == KEY_FIND) {
            return "KEY_FIND";
        } else if (key == KEY_MENU) {
            return "KEY_MENU";
        } else if (key == KEY_DOWN) {
            return "KEY_DOWN";
        } else if (key == KEY_DOWN_LEFT) {
            return "KEY_DOWN_LEFT";
        } else if (key == KEY_DOWN_RIGHT) {
            return "KEY_DOWN_RIGHT";
        } else if (key == KEY_LEFT) {
            return "KEY_LEFT";
        } else if (key == KEY_RIGHT) {
            return "KEY_RIGHT";
        } else if (key == KEY_UP) {
            return "KEY_UP";
        } else if (key == KEY_UP_LEFT) {
            return "KEY_UP_LEFT";
        } else if (key == KEY_UP_RIGHT) {
            return "KEY_UP_RIGHT";
        } else if (key == KEY_PAGE) {
            return "KEY_PAGE";
        } else if (key == KEY_START) {
            return "KEY_START";
        } else if (key == KEY_LAP) {
            return "KEY_LAP";
        } else if (key == KEY_RESET) {
            return "KEY_RESET";
        } else if (key == KEY_SPORT) {
            return "KEY_SPORT";
        } else if (key == KEY_CLOCK) {
            return "KEY_CLOCK";
        } else if (key == KEY_MODE) {
            return "KEY_MODE";
        }

        return null;
    }

    function onKey(evt) {
    	System.println("CheckBoxDelegate::onKey");
    	
    	var key = evt.getKey();
        var keyString = getKeyString( key );

        if( keyString != null ) {
            setActionString( keyString );
        }

        if (key == KEY_ESC) {
            if (last_key == KEY_ESC) {
                System.exit();
            }
        }

        if (key == KEY_ENTER) {
            pushMenu(WatchUi.SLIDE_IMMEDIATE);
        }

		last_key = key;
        return false;
    }
}
