using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Time;
using Toybox.Application.Storage;

const MINUTE = 60;
const MOVEMENT_THRESHOLD = 1100000;

class WatchFaceView extends WatchUi.View {
	var five = new Time.Duration(300);
	var mX = [0];
	var mY = [0];
	var mZ = [0]; 
	var xAvg=0;
	var yAvg=0;
	var zAvg=0;
    
  	// initialize accelerometer
	var options = {
	    :period => 1,               // 1 second sample time
	    :accelerometer => {
	        :enabled => true,       // Enable the accelerometer
	        :sampleRate => 25       // 25 samples
	    }
	};

    function initialize() {
        View.initialize();
        Storage.setValue("avgarray", []);
        Sensor.registerSensorDataListener(method(:accel_callback), options);
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Get and show the current time
        var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        var view = View.findDrawableById("TimeLabel");
        view.setText(timeString);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

	function setBackgroundEvent() {
		try {
            Background.registerForTemporalEvent(five);
        } catch (e instanceof Background.InvalidBackgroundTimeException) {
            //this might happen if this gets called 
        }
	}
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }
    
    	// Callback to receive accel data
	function accel_callback(sensorData) {
	    mX = sensorData.accelerometerData.x;
	    mY = sensorData.accelerometerData.y;
	    mZ = sensorData.accelerometerData.z;
	    System.println("yoooo");
	    onAccelData();
	}
    
    function onAccelData() {
    	if(mX.size() !=0) {
	    	for(var i=0; i<mX.size(); i++) {
	    		xAvg+=mX[i];
	    		yAvg+=mY[i];
	    		zAvg+=mZ[i];
	    	}
	    	xAvg/=mX.size();
	    	yAvg/=mY.size();
	    	zAvg/=mZ.size();
    	}
    	System.println("x: " + mX + ", y: " + mY + ", z: " + mZ);
    	System.println("xAvg: " + xAvg + ", yAvg: " + yAvg + ", zAvg: " + zAvg);
    	var averageArray = Storage.getValue("avgarray");
    	averageArray.add(xAvg*xAvg + yAvg*yAvg + zAvg*zAvg);
    	if(averageArray.size() > 0) {
    		System.println("Array: " + averageArray);
    	}
    	
    	
    	if(averageArray.size() == MINUTE) {
    		System.println("MINUTE, CHECKING ACTIVITY");
    		Storage.deleteValue("avgarray");
    		Storage.setValue("avgarray", []);
    		System.println("FULL ARRAY: " + averageArray); 
    		System.println("STORED ARRAY: " + Storage.getValue("avgarray")); 
    		Sensor.unregisterSensorDataListener();
    		processData(averageArray);
    	} else {
	    	Storage.setValue("avgarray", averageArray);
	    	
	    	WatchUi.requestUpdate();
    	}
    }
    
    function processData(movementData) {
    	if(movementData!=null && movementData.size() > 0) {
    		var activeCount = 0;
	    	for(var i=0; i<movementData.size(); i++) {
	    		if(movementData[i] >= MOVEMENT_THRESHOLD) {
	    			activeCount++;
	    		}
	    	}
	    	System.println("ACTIVE COUNT" + activeCount);
	    	if(activeCount > movementData.size()/2) {
	    		System.println("WAS MOVING, PUSHING NOTIFICATION");
	    		var view = new CheckBoxView();
	    		var delegate = new CheckBoxDelegate();
	    		WatchUi.pushView(view, delegate, WatchUi.SLIDE_IMMEDIATE); 
	    	}
    	}
    }
}
