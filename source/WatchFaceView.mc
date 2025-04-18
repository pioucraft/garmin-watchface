import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Time.Gregorian;


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


        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
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
    var heartrateIterator = Toybox.ActivityMonitor.getHeartRateHistory(1, true);
    return heartrateIterator.next().heartRate;
}

function getHeartRateString() as String {
    return getHeartRate().format("%d");
}

