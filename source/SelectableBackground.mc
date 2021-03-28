//
// Copyright 2017 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.Background;
using Toybox.System;
using Toybox.Application.Storage;

// The Service Delegate is the main entry point for background processes
// our onTemporalEvent() method will get run each time our periodic event
// is triggered by the system. This indicates a set timer has expired, and
// we should attempt to notify the user.
(:background)

	//from sensorview
    var string_HR;
    var string_ACCEL;
    var string_MOVING;
    var HR_graph;
    var timer1;
    var count1 = 0;
    //12 intervals of 5 seconds
    var minutearr = new [12];
    //5 intervals of 1 second
    var secondarr = new [5];
    var active;
    var string_ACTIVE_MIN;
    var string_ACTIVE_SEC;
    
    
class SelectableServiceDelegate extends System.ServiceDelegate {

    function initialize() {
        ServiceDelegate.initialize();
        Sensor.setEnabledSensors( [Sensor.SENSOR_HEARTRATE] );
        Sensor.enableSensorEvents( method(:onSnsr) );
        HR_graph = new LineGraph( 20, 10, Graphics.COLOR_RED );

        string_HR = "---bpm";
        string_ACCEL = "x: y: z:";
        string_MOVING = "Not Moving";
        string_ACTIVE_MIN = "s_s";
        string_ACTIVE_SEC = "Uninit";
        
    }

    // If our timer expires, it means the application timer ran out,
    // and the main application is not open. Prompt the user to let them
    // know the timer expired.
    function onTemporalEvent() {

        // Use background resources if they are available
        if (Application has :loadResource) {
            Background.requestApplicationWake(Application.loadResource(Rez.Strings.TimerExpired));
        } else {
            Background.requestApplicationWake("Your timer has expired!");
        }

        // Write to Storage, this will trigger onStorageChanged() method in foreground app
        Storage.setValue("1", 1);

        Background.exit(true);
    }
    
    function onLayout(dc) {
        timer1 = new Timer.Timer();
    	timer1.start(method(:callback1), 1000, true);
    }
    
    function callback1() {
        count1 += 1;
    }
        //from sensorview
    function onSnsr(sensor_info) {
    
        var HR = sensor_info.heartRate;
        var bucket;
        var moved;
//        if( sensor_info.heartRate != null )
//        {
//            string_HR = HR.toString() + "bpm";
//
//            //Add value to graph
//            HR_graph.addItem(HR);
//        }
        if(sensor_info has :accel && sensor_info.accel != null)
        {
        	var accel = sensor_info.accel;
        	var xAccel = accel[0];
        	var yAccel = accel[1];
        	var zAccel = accel[2];
        	var mag = xAccel*xAccel + yAccel*yAccel + zAccel*zAccel;
        	string_ACCEL = mag;
        	if(mag >= 1100000 || mag <= 900000) {
        		moved = true;
        		string_MOVING = "Moving";
        	} else {
        		moved = false;
        		string_MOVING = "Not Moving Anymore";
        	}
        	//string_ACCEL = "x: " + xAccel + ", y: " + yAccel + ", z: " + zAccel;
        } else {
        	string_HR = "---bpm";
        	string_ACCEL = "x: y: z:";
        	string_MOVING = "Not Moving Yet";
        	moved = false;
        }
        secondarr[count1%5] = moved;
        if(!moved) {
        	string_ACTIVE_SEC = "s_s";
        } else {
        	string_ACTIVE_SEC = "m_s";
        }
        
        if(count1==60) {
        	var minuteactivitycounter = 0;
        	for(var i=0; i<12; i++) {
        		if(minutearr[i]) {
        			minuteactivitycounter++;
        		}
        	}
        	var wasactiveminute = false;
        	string_ACTIVE_MIN = "s_min";
        	if(minuteactivitycounter >= 6) {
        		wasactiveminute = true;
        		string_ACTIVE_MIN = "m_min";
        	}
        	count1=0;
        	System.println("minute::" + wasactiveminute);
        }
        
        if(count1%5 == 0) {
        	var activitycounter = 0;
        	for(var i=0; i<5; i++) {
        		System.println("secondarr::" + secondarr[i]);
        		if(secondarr[i]) {
        			activitycounter++;
        		}
        	}
        	var wasactive = false;
        	if(activitycounter > 2) {
        		wasactive = true;
        	}
        	System.println("second::" + wasactive);
        	minutearr[count1/5] = wasactive;
        }

        WatchUi.requestUpdate();
    }
}
