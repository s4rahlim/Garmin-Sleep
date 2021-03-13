//!
//! Copyright 2016 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

using Toybox.WatchUi;
using Toybox.Graphics;

// Store reference to View in which the list lives
var currentView = null;

var action_string;
var status_string;
var behavior_string;
var action_hits;
var behavior_hits;

//image stuff 
var phone_icon;

function setStatusString(new_string) {
    status_string = new_string;
    WatchUi.requestUpdate();
}

function setActionString(new_string) {
    action_string = new_string;
    action_hits++;

    if (action_hits > behavior_hits) {
        behavior_string = "NO_BEHAVIOR";
        behavior_hits = action_hits;
    }

    WatchUi.requestUpdate();
}

function setBehaviorString(new_string) {
    behavior_string = new_string;
    behavior_hits++;
    WatchUi.requestUpdate();
}

//! Implementation of a CheckBox using Selectable, with the following rules:
//! 1. A CheckBox is "checked" if selected
//! 2. A CheckBox is only "unchecked" if selected again
//! 3. Only one CheckBox may be highlighted at a time
class Checkbox extends WatchUi.Selectable {
    //! Default state Drawable or color/number
    var stateHighlightedSelected;

    //! Constructor
    function initialize(options) {
    	System.println("Checkbox::initialize");
        Selectable.initialize(options);

        // Set each state value to a Drawable, color/number, or null
        stateHighlightedSelected = options.get(:stateHighlightedSelected);
    }

    //! Special case - handle unhighlighting of a CheckBox
    function unHighlight() {
        // If we were highlighted, returnt to default state
        if(getState() == :stateHighlighted) {
        	System.println("Checkbox::unHighlight - stateHighlighted");
            setState(:stateDefault);
        }
        // If were were highlighted/selected, move to selected state
        else if(getState() == :stateHighlightedSelected) {
        	System.println("Checkbox::unHighlight - stateHighlightedSelected");
            setState(:stateSelected);
        }
        else {
        	System.println("Checkbox::unHighlight - else");
        }
    }

    //! Handle onSelectable() returning stateDefault
    function reset(previousState) {
        // If we were highlighted/selected, or selected, move to selected state
        // We only return to the unchecked state if selected again
        if(previousState == :stateSelected) {
        	System.println("Checkbox::reset - stateSelected");
            setState(:stateSelected);
        }
        else if(previousState == :stateHighlightedSelected) {
        	System.println("Checkbox::reset - stateHighlightedSelected");
            setState(:stateSelected);
        }
        else {
        	System.println("Checkbox::reset - else");
        }
    }

    //! Handle onSelectable() returning stateHighlighted
    function highlight(previousState) {
        // If we were selected, move to highlighted/selected state,
        // otherwise stay in the highlighted state
        if(previousState == :stateSelected) {
        	System.println("Checkbox::highlight - stateSelected");
            setState(:stateHighlightedSelected);
        }
        else {
        	System.println("Checkbox::highlight - else");
        }
    }

    //! Handle onSelectable() returning stateSelected
    function select(previousState) {
        // If we were highlighted, move to highlighted/selected state ("checked")
        if(previousState == :stateHighlighted) {
        	System.println("Checkbox::select - stateHighlighted");
            setState(:stateHighlightedSelected);
        }
        // If were were highlighted/selected state, move to highlighted state
        else if(previousState == :stateHighlightedSelected) {
        	System.println("Checkbox::select - stateHighlightedSelected");
            setState(:stateHighlighted);
        }
        // If we were selected, move to default state ("unchecked")
        else if(previousState == :stateSelected) {
        	System.println("Checkbox::select - stateSelected");
            setState(:stateDefault);
        }
        else {
        	System.println("Checkbox::select - else");
        }
    }
}

class CheckBoxList {
    // Store references to our list of CheckBoxes
    hidden var list;

    // Store which CheckBox is actively highlighted
    hidden var currentHighlight;

    //! Constructor
    function initialize(dc) {
    	System.println("CheckBoxList::initialize");
        currentHighlight = null;

        // Define size of border between CheckBoxes
        var BORDER_PAD = 20;

        // Define our states for each CheckBox
        var checkBoxDefault = new WatchUi.Bitmap({:rezId=>Rez.Drawables.checkBoxDefault});
        var checkBoxRed = new WatchUi.Bitmap({:rezId=>Rez.Drawables.checkBoxRed});
        var checkBoxHighlighted = new WatchUi.Bitmap({:rezId=>Rez.Drawables.checkBoxHighlighted});
        var checkBoxSelected = new WatchUi.Bitmap({:rezId=>Rez.Drawables.checkBoxSelected});
        var checkBoxHighlightedSelected = new WatchUi.Bitmap({:rezId=>Rez.Drawables.checkBoxHighlightedSelected});
        var checkBoxDisabled = Graphics.COLOR_BLACK;
        
        // Create our array of Selectables
        var dims = checkBoxDefault.getDimensions();
        //changing from 2 to 3 because we only need two boxes
        list = new[2];

        var slideSymbol, spacing, offset, initX, initY;
        if (dc.getHeight() > dc.getWidth()) {
            slideSymbol = :locY;
            spacing = (dc.getHeight() / 4);
            offset = (dims[1] / 2);
            initY = spacing - offset - BORDER_PAD;
            initX = (dc.getWidth() / 2) - (dims[0] / 2);
        } else {
        	// vivoactive 4 will always hit this else case since round screen (so width == height)
            slideSymbol = :locY;
            spacing = (dc.getWidth() / 4);
            offset = (dims[0] / 2);
//            initX = spacing - offset - BORDER_PAD;
//            initY = 40;//(dc.getHeight() / 2) - (dims[1] / 2);
            initX = 0;
//            dc.getWidth() / 2 - offset;
//            initY = (dc.getHeight() / 2) - (dims[1] / 2);
			initY = 0;
//			dc.getHeight() / 6 - offset;
        }

        // Create the first check-box
        //set identifier here
        var options = {
            :stateDefault=>checkBoxDefault,
            :identifier=>0,
            :stateHighlighted=>checkBoxHighlighted,
            :stateSelected=>checkBoxSelected,
            :stateDisabled=>checkBoxDisabled,
            :stateHighlightedSelected=>checkBoxHighlightedSelected,
            :locX=>initX,
            :locY=>initY,
            :width=>260,
            :height=>100
            };
            //width and height were dims[0]. dims[1]
        list[0] = new Checkbox(options);
		
		var optionsRed = {
            :stateDefault=>checkBoxRed,
            :identifier=>1,
            :stateHighlighted=>checkBoxHighlighted,
            :stateSelected=>checkBoxSelected,
            :stateDisabled=>checkBoxDisabled,
            :stateHighlightedSelected=>checkBoxHighlightedSelected,
            :locX=>initX,
            :locY=>160,
            :width=>260,
            :height=>100
            };
        // Create the second check-box
//        options.put(slideSymbol, 160);
//        3 * dc.getHeight()/4
        list[1] = new Checkbox(optionsRed);
    }

    //! Return instance of current list of CheckBoxes
    function getList() {
    	System.println("CheckBoxList::getList");
        return list;
    }

    //! General handler for onSelectable() events
    function handleEvent(instance, previousState) {
        // Handle all cases except disabled (handled implicitly)
        if(instance.identifier == 0){
        	if(instance.getState() == :stateSelected){
        		var view = new PhoneView();
        		var delegate = new ButtonDelegate();
        		WatchUi.pushView(view, delegate, WatchUi.SLIDE_IMMEDIATE); 
        	}
        }
        else if(instance.identifier == 1){
        	
        }

//        if(instance.getState() == :stateHighlighted) {
//        	System.println("CheckBoxList::handleEvent - stateHighlighted");
//            // Only one CheckBox may be highlighted
//            if((null != currentHighlight) && !currentHighlight.equals(instance)) {
//                currentHighlight.unHighlight();
//            }
//
//            // Note which checkbox was highlighted
//            currentHighlight = instance;
//            instance.highlight(previousState);
//        }
//        else if(instance.getState() == :stateSelected) {
//        	System.println("CheckBoxList::handleEvent - stateSelected");
//            instance.select(previousState);
//        }
//        else if(instance.getState() == :stateDefault) {
//        	System.println("CheckBoxList::handleEvent - stateDefault");
//            instance.reset(previousState);
//        }
//        else {
//        	System.println("CheckBoxList::handleEvent - else");
//        }
    }
}

class CheckBoxView extends WatchUi.View {
    // Storage for our CheckBoxList
    var checkBoxes = null;

    //! Constructor
    function initialize() {
    	System.println("CheckBoxView::initialize");
        View.initialize();

		action_string = "NO_ACTION";
        behavior_string = "NO_BEHAVIOR";
        status_string = "NO_EVENT";
        action_hits = 0;
        behavior_hits = 0;
        // Initialize global reference
        currentView = self;
    }

    //! Load your resources here
    function onLayout(dc) {
    	System.println("CheckBoxView::onLayout");
        checkBoxes = new CheckBoxList(dc);
        setLayout(checkBoxes.getList());
    }

    //! Update the view
    function onUpdate(dc) {
    	System.println("CheckBoxView::onUpdate");
        View.onUpdate(dc);

		// Sarah's code would have worked if called here instead of prior to View.onUpdate(dc)
		dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
		var x = dc.getWidth() / 2;
        var y = 120;//hack for layout...(dc.getHeight() / 2) - (3 * dc.getFontHeight(Graphics.FONT_SMALL) / 2);

//        dc.drawText(x, y, Graphics.FONT_SMALL, action_string, Graphics.TEXT_JUSTIFY_CENTER);
//        dc.drawText(x, y + dc.getFontHeight(Graphics.FONT_SMALL), Graphics.FONT_SMALL, behavior_string, Graphics.TEXT_JUSTIFY_CENTER);
//        dc.drawText(x, y + 2 * dc.getFontHeight(Graphics.FONT_SMALL), Graphics.FONT_SMALL, status_string, Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
        dc.drawText(x, dc.getHeight()/2 - 20, Graphics.FONT_MEDIUM, "Respond to Survey", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(x, dc.getHeight()/2 - dc.getFontHeight(Graphics.FONT_SMALL) -25, Graphics.FONT_SMALL, "YES", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(x, dc.getHeight()/2 + dc.getFontHeight(Graphics.FONT_SMALL) -5, Graphics.FONT_SMALL, "NO", Graphics.TEXT_JUSTIFY_CENTER);
    }
}
