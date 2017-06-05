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
        var timeWidth = dc.getTextWidthInPixels(timeDisp, Gfx.FONT_SYSTEM_NUMBER_THAI_HOT);
        var dateWidth = dc.getTextWidthInPixels(timeDate, Gfx.FONT_SYSTEM_XTINY);
        var dayWidth = dc.getTextWidthInPixels(timeDay, Gfx.FONT_SYSTEM_XTINY);
        var dayXvalue = ((((240 - timeWidth) / 2) - dayWidth) / 2);
        var dateXvalue = 240 - ((((240 - timeWidth) / 2 ) - dateWidth) / 2);
        viewDisp.setText(timeDisp);
        // Get and show HR
        var checkHR = ActivityMonitor.getHeartRateHistory(1,true);
        var dataHR = "--";
        if(checkHR != null && checkHR != 255) {
       		var showHR = checkHR.next();
        	if(showHR != null && showHR.heartRate != null && showHR != ActivityMonitor.INVALID_HR_SAMPLE && showHR != 255) {
        		dataHR = showHR.heartRate.toString();
        	}
        }
        var viewHR = View.findDrawableById("labelHR");
        viewHR.setText(dataHR);
        var hrWidth = dc.getTextWidthInPixels(dataHR, Gfx.FONT_SYSTEM_NUMBER_MEDIUM);
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
        //Get and show steps
        var countSteps = ActivityMonitor.getInfo().steps.toNumber();
        var viewSteps = View.findDrawableById("labelSteps");
        viewSteps.setText(countSteps.toString());
        //Get battery status
        var statusBattery = Sys.getSystemStats().battery.toNumber();
        var dataBattery = (statusBattery * 2) + 20;
        //Get Bluetooth status
        var iconBT = Ui.loadResource(Rez.Drawables.BluetoothIcon);
        var statusBT = Sys.getDeviceSettings().phoneConnected;
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        dc.setPenWidth(5);
        if (statusBattery < 10) {
        	dc.setColor(Gfx.COLOR_PINK, Gfx.COLOR_TRANSPARENT);
        	dc.drawLine(20, 70, dataBattery, 70);
        } else if (statusBattery < 25) {
        	dc.setColor(Gfx.COLOR_PINK, Gfx.COLOR_TRANSPARENT);
        	dc.drawLine(20, 70, 30, 70);
        	dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        	dc.drawLine(40, 70, dataBattery, 70);
        } else if (statusBattery < 45) {
        	dc.setColor(Gfx.COLOR_PINK, Gfx.COLOR_TRANSPARENT);
        	dc.drawLine(20, 70, 30, 70);
        	dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        	dc.drawLine(40, 70, 60, 70);
        	dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
        	dc.drawLine(70, 70, dataBattery, 70);
        } else if (statusBattery < 65) {
        	dc.setColor(Gfx.COLOR_PINK, Gfx.COLOR_TRANSPARENT);
        	dc.drawLine(20, 70, 30, 70);
        	dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        	dc.drawLine(40, 70, 60, 70);
        	dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
        	dc.drawLine(70, 70, 100, 70);
        	dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT);
        	dc.drawLine(110, 70, dataBattery, 70);
        } else if (statusBattery < 100) {
        	dc.setColor(Gfx.COLOR_PINK, Gfx.COLOR_TRANSPARENT);
        	dc.drawLine(20, 70, 30, 70);
        	dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        	dc.drawLine(40, 70, 60, 70);
        	dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
        	dc.drawLine(70, 70, 100, 70);
        	dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT);
        	dc.drawLine(110, 70, 140, 70);
        	dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
        	dc.drawLine(150, 70, dataBattery, 70);
        } else {
        	dc.setColor(Gfx.COLOR_PINK, Gfx.COLOR_TRANSPARENT);
        	dc.drawLine(20, 70, 30, 70);
        	dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        	dc.drawLine(40, 70, 60, 70);
        	dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
        	dc.drawLine(70, 70, 100, 70);
        	dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT);
        	dc.drawLine(110, 70, 140, 70);
        	dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
        	dc.drawLine(150, 70, 220, 70);
        }
        if (dataMove > 0) {
        	dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
        	dc.drawLine(60, 165, 95, 165);
        }  
        if (dataMove > 1) {
        	dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT);
        	dc.drawLine(105, 165, 120, 165);
        }  
        if (dataMove > 2) {
        	dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
        	dc.drawLine(130, 165, 145, 165);
        }  
        if (dataMove > 3) {
        	dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        	dc.drawLine(155, 165, 165, 165);
        }   
        if (dataMove > 4) {
        	dc.setColor(Gfx.COLOR_PINK, Gfx.COLOR_TRANSPARENT);
        	dc.drawLine(175, 165, 180, 165);
        } 
        if(statusDND == true) {
        	var DNDXvalue = ((((158 - hrWidth) / 2) - 15) / 2) + 41;
        	dc.drawBitmap(DNDXvalue, 30, iconDND);
        }
        if(statusBT == true) {
            var BTXvalue = 240 - (((((158 - hrWidth) / 2) + 15) / 2) + 41 - 2);
        	dc.drawBitmap(BTXvalue, 30, iconBT);
        }
        if(statusNotify > 0) {
        	dc.drawBitmap(30, 160, iconNotify);
        }
        if(statusAlarm > 0) {
        	dc.drawBitmap(195, 160, iconAlarm);
        }
        dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
        dc.drawText(dayXvalue, 107, Gfx.FONT_SYSTEM_XTINY, timeDay, Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(dateXvalue, 107, Gfx.FONT_SYSTEM_XTINY, timeDate, Gfx.TEXT_JUSTIFY_RIGHT);
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