using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Time;
using Toybox.Application.Storage;
using Toybox.Attention;

const PERIOD = 30;
const INACTIVE_THRESHOLD = 0.9;
const MOVEMENT_THRESHOLD = 1200000;
const ACTIVE_CONDITION = 5;

class WatchFaceView extends WatchUi.View {
	var five = new Time.Duration(300);
	var mX = [0];
	var mY = [0];
	var mZ = [0]; 
	var xAvg=0;
	var yAvg=0;
	var zAvg=0;
    var startTime = null;
    var endTime = null;
    var notMoving = false; 
    var notMovingCtr = 0; 
    var secondCtr = 0;
    var notMovedBool = false;
    var sendNotification = false;
    var periodExpire = 0;
    var unconnectedToPhone = 0;
    
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
        Storage.setValue("periodarray", []);
        Storage.setValue("transmit", 0);
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
        var timeString = Lang.format("$1$:$2$:$3$", [clockTime.hour, clockTime.min.format("%02d"), clockTime.sec.format("%02d")]);
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
	    onAccelData();
	}
    
    function onAccelData() {
    	//Second Calculations
    	secondCtr++;
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
//    	System.println("x: " + mX + ", y: " + mY + ", z: " + mZ);
//    	System.println("xAvg: " + xAvg + ", yAvg: " + yAvg + ", zAvg: " + zAvg);
    	var sum = xAvg*xAvg + yAvg*yAvg + zAvg*zAvg;
    	System.println("SUM" + sum); 
    	if (sum < MOVEMENT_THRESHOLD){
    		notMovingCtr++;
    	} 
    	
    	//Minute Calculations
    	
    	//Period array holds 30 values. Each value represents a minute in the last 30 minutes of recorded data.
    	//True in period array means the user was NOT moving for that specific minute.
    	
    	if (secondCtr == 60){
    		notMovedBool = (notMovingCtr > 30);
    		secondCtr = 0;
	    	notMovingCtr = 0;
	    	
    		var periodArray = Storage.getValue("periodarray");
    		System.println("BEFORE" + periodArray);
    		periodArray.add(notMovedBool);
    		System.println("AFTER" + periodArray);
    		if(periodArray.size() > PERIOD) {
    			periodArray = periodArray.slice(1,null);
    			System.println("CALCING" + periodArray);
	    		var notMovingMinCtr = 0;
	    		var consecutiveMoving = true;
	    		for(var i=0; i<periodArray.size(); i++) {
	    			if(periodArray[i]!=null && periodArray[i]) { //if notMovedBool == true for that minute
	    				notMovingMinCtr++; //increment not moving counter
	    			}
		    	}
		    	if(notMovingMinCtr >= PERIOD*INACTIVE_THRESHOLD) { //if inactive for 30*.9, then period is inactive.
		    		sendNotification = true;
		    	}
		    	
		    	if(sendNotification) {
		    		periodExpire++;
		    	}
		    	
		    	for(var i=periodArray.size()-1; i>periodArray.size()-6; i--) { //check most recent 5 minutes, see if they're all active.  If not, set boolean to false and break.
	    			if(periodArray[i]!=null && periodArray[i]) { //if notMovedBool == true for that minute
	    				consecutiveMoving = false;
	    				break;
	    			}
		    	}
		    	
		    	if(sendNotification /*&& (consecutiveMoving||periodExpire==30)*/) {
		    		System.println("IN");
		    		sendNotification = false;
		    		periodExpire=0;
		    		periodArray = [];
			    	var view = new CheckBoxView();
		    		var delegate = new CheckBoxDelegate();
		    		WatchUi.pushView(view, delegate, WatchUi.SLIDE_IMMEDIATE);
    			}
    		}
    		var transmitted = Storage.getValue("transmit");
    		
    		//handle if phone isn't close enough to watch to connect
    		if(transmitted == 1) {
    			unconnectedToPhone++;
    			if(unconnectedToPhone == 30) {
    				unconnectedToPhone=0;
    				var view = new CheckBoxView();
		    		var delegate = new CheckBoxDelegate();
		    		WatchUi.pushView(view, delegate, WatchUi.SLIDE_IMMEDIATE);
    			}
    		} else {
    			unconnectedToPhone=0;
    		}
    		
    		//store array back into storage
    		Storage.setValue("periodarray", periodArray);
    	}
    	WatchUi.requestUpdate();
    }
}
