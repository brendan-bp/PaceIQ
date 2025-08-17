import Toybox.Activity;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;
import Toybox.Activity;
import Toybox.Math;

class PaceIQView extends WatchUi.SimpleDataField {

    function initialize() {
        SimpleDataField.initialize();
        label = "PaceIQ";
    }

    function compute(info as Activity.Info) as Numeric or Duration or String or Null {
        // See Activity.Info in the documentation for available information.
        // Temperature
        var T = Weather.getCurrentConditions().temperature;

        // Humidity
        var RH = Weather.getCurrentConditions().relativeHumidity;


        // Calculate Wet-Bulb Temperature, formula derived from
        // https://journals.ametsoc.org/view/journals/apme/50/11/jamc-d-11-0143.1.xml
        var wetBulbTemperature = 0;
        if ((-20 < T) && (T < 50)) { // Check temperature
            if ((5 < RH) && (RH < 99)) { // Check humidity
                wetBulbTemperature =
                T * Math.atan(0.151977 * Math.sqrt(RH + 8.313659))
                + 0.00391838 * (Math.pow(RH, 3/2)) * Math.atan(0.023101 * RH)
                - Math.atan(RH - 1.676331)
                + Math.atan(T + RH)
                - 4.686035;

            }
        }

        // Find pace in min/km from speed in m/s
        var pace;
        if (Activity.getActivityInfo().currentSpeed != null) {
            pace = ((1/Activity.getActivityInfo().currentSpeed)*(1000/60));
        }
        else {
            pace = 0;
        }


        // Wet Bulb Temperature (Temperature & Humidity) adjustment, derived from
        // https://journals.lww.com/acsm-msse/fulltext/2007/03000/impact_of_weather_on_marathon_running_performance.12.aspx
        // Only convert if within the experimental bounds of the study (which considered a Wet Bulb Temp of 5 as the baseline)
        // If above this, our conversion will not apply, but warnings will start to show to remind the athlete to reconsider
        // training in potentially dangerous conditions
        var adjustedPace;
        if ((wetBulbTemperature > 5) && (wetBulbTemperature <= 25)) {
            adjustedPace = ((((wetBulbTemperature - 5)/20)* // Calculate the scaling of the cubic based on Wet Bulb Temperature

            (2.0219*Math.pow(pace,3)-17.947*Math.pow(pace, 2)+56.825*pace-60.908) // Calculate the cubic based on the athlete's pace

            +100)/100) // Convert from percentage increase to conversion factor

            *pace; // Multiply pace by conversion factor
        }
        else {
            adjustedPace = pace;
        }

        // Output & formatting
        var output = "";
        if (pace != null) {
            // Format the pace into min:seconds
            output = Math.floor(adjustedPace).format("%.f") + ":" // Format the minutes
            + Math.round((adjustedPace-Math.floor(adjustedPace))*60).format("%02.f"); // Format the seconds
        } else {
            // Return error if there is an error (i.e pace is null)
            output =  "error";
        }


        // Add the warnings for dangerously high wet-bulb temperatures, based on:
        // https://www.princetonmedicine.com/blog/wet-bulb-temperature-and-exercise-safety-what-you-need-to-know
        // https://journals.physiology.org/doi/epdf/10.1152/japplphysiol.00738.2021
        // https://pmc.ncbi.nlm.nih.gov/articles/PMC10687011/

        // Algorithim prioritises reducing memory operations at the cost of more boolean operations
        if ((wetBulbTemperature > 25) && (wetBulbTemperature <= 27)) {
            output = output + "!";
        }
        else if ((wetBulbTemperature > 27) && (wetBulbTemperature <= 29)) {
            output = output + "!!";
        }
        else if (wetBulbTemperature > 29) {
            output = output + "!!!";
        }

        // Return our data to be displayed on the watch
        return output;
    }

}