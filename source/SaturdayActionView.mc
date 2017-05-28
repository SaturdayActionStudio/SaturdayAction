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
        
        // Get and show the current time, day, date
        var now = Time.now();
        var clockDay = Gregorian.info(now,Time.FORMAT_MEDIUM);
        var clockTime = Gregorian.info(now,Time.FORMAT_SHORT);
        if(clockTime.hour == 0) {
        	clockTime.hour = 12;
        } else if (clockTime.hour > 12) {
        	clockTime.hour = clockTime.hour - 12;
        }
        var timeDisp = Lang.format("$1$ $2$", [clockTime.hour, clockTime.min.format("%02d")]);
        var timeDay = Lang.format("$1$", [clockDay.day_of_week]);
        var timeDate = Lang.format("$1$.$2$", [clockTime.month, clockTime.day]);
        var viewDisp = View.findDrawableById("labelTime");
        var viewDay = View.findDrawableById("labelDay");
        var viewDate = View.findDrawableById("labelDate");
        viewDay.setText(timeDay);
        viewDate.setText(timeDate);
        viewDisp.setText(timeDisp);
        
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
        
        //Get do not disturb status
        var iconDND = Ui.loadResource(Rez.Drawables.DoNotDisturbIcon);
        var statusDND = Sys.getDeviceSettings().doNotDisturb;
                
        //Get notification status
        var iconNotify = Ui.loadResource(Rez.Drawables.NotifyIcon);
        var statusNotify = Sys.getDeviceSettings().notificationCount.toNumber();
        
        //Get alarm status
        var iconAlarm = Ui.loadResource(Rez.Drawables.AlarmIcon);
        var statusAlarm = Sys.getDeviceSettings().alarmCount.toNumber();
        
        //Get move bar status
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
        
        //Get battery status
        var statusBattery = Sys.getSystemStats().battery.toNumber();
        var dataBattery = (screenWidth-20)*statusBattery/100;
        
        //Get Bluetooth status
        var iconBT = Ui.loadResource(Rez.Drawables.BluetoothIcon);
        var statusBT = Sys.getDeviceSettings().phoneConnected;
                                
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
        if(statusDND == true) {
        	dc.drawBitmap(50, 30, iconDND);
        }
        if(statusBT == true) {
        	dc.drawBitmap(175, 30, iconBT);
        }
        if(statusNotify > 0) {
        	dc.drawBitmap(25, 160, iconNotify);
        }
        if(statusAlarm > 0) {
        	dc.drawBitmap(200, 160, iconAlarm);
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

}
