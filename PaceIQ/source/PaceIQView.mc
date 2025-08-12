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
        // Wind Speed
        // var windSpeed = Weather.getCurrentConditions().windSpeed;

        // Altitude
        // var Altitude = Position.getInfo().altitude;

        // Temperature
        var T = Weather.getCurrentConditions().temperature;

        // Humidity
        var RH = Weather.getCurrentConditions().relativeHumidity;

        // Calculate Wet-Bulb Temperature
        var wetBulbTemperature = 0;
        if ((-20 < T) && (T < 50)) { // Check temperature
            if ((5 < RH) && (RH < 99)) { // Check humidity
                wetBulbTemperature =
                T * Math.atan(0.151977 * Math.sqrt(RH + 8.313659))
                + 0.00391838 * (RH ^ 3/2) * Math.atan(0.023101 * RH)
                - Math.atan(RH - 1.676331)
                + Math.atan(T + RH)
                - 4.686035;
            }
        }

        // Find pace in min/km from speed in m/s
        var pace = ((1/Activity.getActivityInfo().currentSpeed)*(1000/60));

        // Pace adjustment, derived from
        // https://journals.lww.com/acsm-msse/fulltext/2007/03000/impact_of_weather_on_marathon_running_performance.12.aspx
        var adjustedPace = -1;
        if (wetBulbTemperature < 10) {
            adjustedPace = pace*1.03;
        }
        else if (wetBulbTemperature < 15) {
            adjustedPace = pace*1.06;
        }
        else if (wetBulbTemperature < 20) {
            adjustedPace = pace*1.09;
        }
        else if (wetBulbTemperature < 25) {
            adjustedPace = pace*1.12;
        }

        var output = "";
        if (pace != null) {
            // Format the pace into min:seconds
            // return Math.floor(adjustedPace).format("%.f") + ":"
            // + Math.round((adjustedPace-Math.floor(adjustedPac    e))*60).format("%02.f");
            output = Math.floor(adjustedPace).format("%.f") + ":"
            + Math.round((adjustedPace-Math.floor(adjustedPace))*60).format("%02.f");
        } else {
            // Speed cannot be negative so returning -1 ensures we can tell that there is an error
            output =  -1;
        }

        if (wetBulbTemperature > 25) {
            output = output + "!";
            if (wetBulbTemperature > 27) {
                output = output + "!";
                if (wetBulbTemperature > 29) {
                    output = output + "!";
                }
            }
        }
        System.println("hi");
        return output;
        // return wetBulbTemperature;


    }

}