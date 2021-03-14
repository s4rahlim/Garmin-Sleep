//!
//! Copyright 2015 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Time.Gregorian;
using Toybox.Sensor;
using Toybox.Application;
using Toybox.Position;

class SensorView extends WatchUi.View
{
    var string_HR;
    var string_ACCEL;
    var string_MOVING;
    var HR_graph;

    //! Constructor
    function initialize()
    {
        View.initialize();
        Sensor.setEnabledSensors( [Sensor.SENSOR_HEARTRATE] );
        Sensor.enableSensorEvents( method(:onSnsr) );
        HR_graph = new LineGraph( 20, 10, Graphics.COLOR_RED );

        string_HR = "---bpm";
        string_ACCEL = "x: y: z:";
        string_MOVING = "Not Moving";
    }

    //! Handle the update event
    function onUpdate(dc)
    {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT );

        dc.drawText(dc.getWidth() / 2, 75, Graphics.FONT_LARGE, string_HR, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(dc.getWidth() / 2, 115, Graphics.FONT_SMALL, string_ACCEL, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(dc.getWidth() / 2, 150, Graphics.FONT_SMALL, string_MOVING, Graphics.TEXT_JUSTIFY_CENTER);

        HR_graph.draw(dc, [0, 0], [dc.getWidth(), dc.getHeight()]);
    }

    function onSnsr(sensor_info)
    {
        var HR = sensor_info.heartRate;
        var bucket;
        if( sensor_info.heartRate != null )
        {
            string_HR = HR.toString() + "bpm";

            //Add value to graph
            HR_graph.addItem(HR);
        }
        if(sensor_info has :accel && sensor_info.accel != null)
        {
        	var accel = sensor_info.accel;
        	var xAccel = accel[0];
        	var yAccel = accel[1];
        	var zAccel = accel[2];
        	var mag = Math.sqrt(xAccel*xAccel + yAccel*yAccel + (zAccel+980)*(zAccel+980));
        	string_ACCEL = mag;
        	if(mag >= 400) {
        		string_MOVING = "Moving";
        	} else {
        		string_MOVING = "Not Moving Anymore";
        	}
        	//string_ACCEL = "x: " + xAccel + ", y: " + yAccel + ", z: " + zAccel;
        }
        else
        {
        	string_HR = "---bpm";
        	string_ACCEL = "x: y: z:";
        	string_MOVING = "Not Moving Yet";
        }

        WatchUi.requestUpdate();
    }
}

//! main is the primary start point for a Monkeybrains application
class SensorTest extends Application.AppBase
{
    function initialize() {
        AppBase.initialize();
    }

    function onStart(state)
    {
        return false;
    }

    function getInitialView()
    {
        return [new SensorView()];
    }

    function onStop(state)
    {
        return false;
    }
}
