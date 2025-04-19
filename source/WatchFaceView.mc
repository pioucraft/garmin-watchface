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

        var TimeView = View.findDrawableById("TimeLabel") as Text;
        var timeString = Lang.format("$1$:$2$", [clockTime.hour.format("%02d"), clockTime.min.format("%02d")]);
        TimeView.setText(timeString);

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
        var fillPercentage = (steps.toFloat() / stepsGoal.toFloat());

        StepsView.setText(Lang.format("$1$ steps", [steps]));





        // dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
        // dc.fillCircle(50, 100, 75);

        // Define center point of the circle

        View.onUpdate(dc);


        // Clamp value between 0 and 1
        if (fillPercentage < 0) {
            fillPercentage = 0;
        } else if (fillPercentage > 1) {
            fillPercentage = 1;
        }

        // Define rectangle properties (adjust coordinates and size as needed)
        var rectWidth = dc.getWidth() * 0.6; // Increased width to 80% of screen width
        var rectHeight = 25;
        var rectX = (dc.getWidth() - rectWidth) / 2; // Centered horizontally
        // Position it vertically below other elements, adjust '150' as needed
        var rectY = 270;
        var cornerRadius = 4; // Define the radius for rounded corners

        // Calculate the width of the filled portion based on completion
        // fillPercentage currently represents the *unfilled* part (1.0 - steps/goal)
        // So, the filled part is (1.0 - fillPercentage)
        var filledRatio = fillPercentage;
        var filledWidth = (rectWidth * filledRatio).toNumber();

        // Draw the background/outline of the progress bar with rounded corners
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        // Draw a thicker border by drawing multiple rectangles with small offsets
        var borderThickness = 3; // Adjust for desired border width
        for (var i = 0; i < borderThickness; i += 1) {
            dc.drawRoundedRectangle(
                rectX - i * 0.5, 
                rectY - i * 0.5, 
                rectWidth + i, 
                rectHeight + i, 
                cornerRadius + i * 0.5
            );
        }

        // Draw the filled portion from left to right with rounded corners
        // Note: fillRoundedRectangle fills the entire shape. We need to clip or draw carefully.
        // A common approach is to fill the whole rounded rect first, then draw the unfilled part over it,
        // or calculate the clipping region. For simplicity here, we'll fill a potentially non-rounded
        // rectangle inside, which might not look perfectly rounded on the right edge when partially filled.
        // For a perfect rounded fill, more complex drawing logic (like clipping) is needed.
        if (filledWidth > 0) {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            // Fill a rectangle for the filled portion. For perfect rounded corners on the fill,
            // you might need to use clipping or draw two rounded rectangles (background and foreground).
            // This simple fillRectangle will have sharp corners on the right side when partially filled.
             if (filledWidth >= rectWidth - cornerRadius) { // If close to full, use fillRoundedRectangle
             dc.fillRoundedRectangle(rectX, rectY, filledWidth, rectHeight, cornerRadius);
             } else { // Otherwise, fill a standard rectangle (might look slightly off at the rounded end)
             dc.fillRectangle(rectX, rectY, filledWidth, rectHeight);
             }
        }
        

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

