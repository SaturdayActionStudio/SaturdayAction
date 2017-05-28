using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Time.Gregorian as Gregorian;
using Toybox.ActivityMonitor as ActivityMonitor;

class SaturdayActionView extends Ui.WatchFace {

    function initialize() {
        WatchFace.initialize();
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
        var screenWidth = dc.getWidth();
        // Get and show the current time
        var now = Time.now();
        var clockTime = Gregorian.info(now,Time.FORMAT_SHORT);
        if(clockTime.hour > 12) {
        	clockTime.hour = clockTime.hour - 12;
        }
        var timeDisp = Lang.format("$1$ $2$", [clockTime.hour, clockTime.min.format("%02d")]);
        var timeDate = Lang.format("$1$/$2$", [clockTime.month, clockTime.day]);
        var viewDisp = View.findDrawableById("labelTime");
        var viewDate = View.findDrawableById("labelDate");
        viewDisp.setText(timeDisp);
        viewDate.setText(timeDate);
        
        // Get and show HR
        var checkHR = ActivityMonitor.getHeartRateHistory(1,true);
        var dataHR = "--";
        if(checkHR != null) {
       	var showHR = checkHR.next();
        	if(showHR != null && showHR.heartRate != null && showHR != ActivityMonitor.INVALID_HR_SAMPLE) {
        		dataHR = showHR.heartRate.toString();
        		}
        	}
        var viewHR = View.findDrawableById("labelHR");
        viewHR.setText(dataHR);
        
        //Get and show notifications
        var dataNotify = Sys.getDeviceSettings().notificationCount.toNumber();
        var nullNotify = "--";
        var viewNotify = View.findDrawableById("labelNotify");
        if(dataNotify != null) {
        	viewNotify.setText(dataNotify.toString());
        } else {
        	viewNotify.setText(nullNotify);
        }
        
        //Get and show alarms
        var dataAlarm = Sys.getDeviceSettings().alarmCount.toNumber();
        var viewAlarm = View.findDrawableById("labelAlarm");
        viewAlarm.setText(dataAlarm.toString());
        
        //Get and show move bar
        var dataMove = ActivityMonitor.getInfo().moveBarLevel.toNumber();
        var statusMove = (dataMove*24)+60;
        
        //Get and show steps
        var countSteps = ActivityMonitor.getInfo().steps.toNumber();
        var goalSteps = ActivityMonitor.getInfo().stepGoal.toNumber();
        var dataSteps = (screenWidth-10)*countSteps/goalSteps;
        if(dataSteps > screenWidth) {
        	dataSteps = screenWidth-10;
        }
        var viewSteps = View.findDrawableById("labelSteps");
        viewSteps.setText(countSteps.toString());
        
        //Get and show battery
        var statusBattery = Sys.getSystemStats().battery.toNumber();
        var dataBattery = (screenWidth-20)*statusBattery/100;
                                 
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        dc.setPenWidth(5);
        if (statusBattery > 75) {
        	dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
        } else if (statusBattery > 50) {
        	dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT);
        } else if (statusBattery > 25) {
        	dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
        } else {
        	dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        }
        dc.drawLine(20, 70, dataBattery, 70);
        if (dataMove > 4) {
        	dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        } else if (dataMove > 3) {
        	dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
        } else if (dataMove > 2) {
        	dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT);
        } else {
        	dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
        }
        dc.drawLine(60, 165, statusMove, 165);
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

}
