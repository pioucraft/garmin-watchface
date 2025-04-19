import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Activity;


class WatchFaceView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Get and show the current time
        var clockTime = System.getClockTime();

        var hoursString = Lang.format("$1$", [clockTime.hour.format("%02d")]);
        var view = View.findDrawableById("HoursLabel") as Text;
        view.setText(hoursString);

        var minutesString = Lang.format("$1$", [clockTime.min.format("%02d")]);
        var minutesView = View.findDrawableById("MinutesLabel") as Text;
        minutesView.setText(minutesString);

        var secondsString = Lang.format("$1$", [clockTime.sec.format("%02d")]);
        var secondsView = View.findDrawableById("SecondsLabel") as Text;
        secondsView.setText(secondsString);

        var dateView = View.findDrawableById("DateLabel") as Text;
        dateView.setText(getDate());

        var HeartRateView = View.findDrawableById("TestHeartRateLabel") as Text;
        HeartRateView.setText(getHeartRateString());

        var StepsView = View.findDrawableById("StepsLabel") as Text;
        var steps = Toybox.ActivityMonitor.getInfo().steps;
        
        var stepsGoal = Toybox.ActivityMonitor.getInfo().stepGoal;

        if (steps == null) {
            steps = 0;
        }
        var fillPercentage = 1.toFloat() - (steps.toFloat() / stepsGoal.toFloat());

        StepsView.setText(Lang.format("$1$ steps", [steps]));


        var FloorsView = View.findDrawableById("FloorsLabel") as Text;
        var floors = Toybox.ActivityMonitor.getInfo().floorsClimbed;
        if (floors == null) {
            floors = 0;
        }
        FloorsView.setText(Lang.format("$1$ floors", [floors]));




        // dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
        // dc.fillCircle(50, 100, 75);

        // Define center point of the circle

        View.onUpdate(dc);

        // Calculate the angle for the filled portion
        // Define center point of the circle
        var centerX = 290;
        var centerY = 145;

        // Radius of the circular arc
        var radius = 75;



        // Clamp value between 0 and 1
        if (fillPercentage < 0) {
            fillPercentage = 0;
        } else if (fillPercentage > 1) {
            fillPercentage = 1;
        }

        // Calculate the angle for the filled portion
        var filledAngle = 360 * fillPercentage;

        // Thicken the circle outline
        dc.setPenWidth(6);

    // Special cases
 
        // First, draw the black (unfilled) arc from filledAngle to 360
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.drawArc(centerX, centerY, radius, Graphics.ARC_CLOCKWISE, filledAngle, 360);

        // Then, draw the blue (filled) arc from 0 to filledAngle
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
        dc.drawArc(centerX, centerY, radius, Graphics.ARC_CLOCKWISE, 0, filledAngle);


        dc.drawText(centerX, centerY - 15, Graphics.FONT_XTINY, Lang.format("$1$ steps", [stepsGoal]), Graphics.TEXT_JUSTIFY_CENTER);        

    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}

function getDate() as String {
   var now = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
   var dateString = Lang.format("$1$ $2$ $3$",         [
            now.day_of_week,
            now.day,
            now.month,
        ]
    );
    return dateString;
}

function getHeartRate() as Number {
    var heartRate = Activity.getActivityInfo().currentHeartRate;
    if (heartRate == null) {
        heartRate = 0;
    }
    return heartRate;
}

function getHeartRateString() as String {
    return getHeartRate().format("%d");
}

