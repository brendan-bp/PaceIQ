import Toybox.Activity;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;
import Toybox.Activity;
import Toybox.Math;

class PaceIQView extends WatchUi.SimpleDataField {

    // Set the label of the data field here.
    function initialize() {
        SimpleDataField.initialize();
        label = "PaceIQ";
    }

    function compute(info as Activity.Info) as Numeric or Duration or String or Null {
        // See Activity.Info in the documentation for available information.
        // Temperature
        var T = Weather.getCurrentConditions().temperature;
        // var T = 30;

        // Humidity
        var RH = Weather.getCurrentConditions().relativeHumidity;
        // var RH = 30;

        // Wind Speed
        // var windSpeed = Weather.getCurrentConditions().windSpeed;

        // Altitude
        // var Altitude = Position.getInfo().altitude;

        // Calculate Wet-Bulb Temperature
        var wetBulbTemperature = 0;
        if ((-20 < T) && (T < 50)) { // Check temperature
            if ((5 < RH) && (RH < 99)) { // Check humidity
                wetBulbTemperature =
                T * Math.atan(0.151977 * Math.sqrt(RH + 8.313659))
                + 0.00391838 * (RH ^ 2/3) * Math.atan(0.023101 * RH)
                - Math.atan(RH - 1.676331)
                + Math.atan(T + RH)
                - 4.686035;
            }
        }

        // We will get the pace of the athlete via their current speed in m/s
        // return Activity.getActivityInfo().currentSpeed;

        // Find pace in min/km
        // var pace = ((1/Activity.getActivityInfo().currentSpeed)*(1000/60));

        return wetBulbTemperature;
        // if (pace != null) {
        //     return pace;
        // } else {
        //     return wetBulbTemperature;
        // }


    }

}