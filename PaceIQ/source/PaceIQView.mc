import Toybox.Activity;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;

class PaceIQView extends WatchUi.SimpleDataField {

    // Set the label of the data field here.
    function initialize() {
        SimpleDataField.initialize();
        label = "My Label";
    }

    function compute(info as Activity.Info) as Numeric or Duration or String or Null {
        // See Activity.Info in the documentation for available information.
        // Temperature
        // return Weather.getCurrentConditions().temperature;

        // Humidity
        // return Weather.getCurrentConditions().relativeHumidity;

        // Wind Speed
        // return Weather.getCurrentConditions().windSpeed;

        // Altitude
        // return Position.getInfo().altitude;
        return 0.0;
    }

}