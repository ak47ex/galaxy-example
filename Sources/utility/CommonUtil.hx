package utility;

import component.PolarPosition;
import Random;

typedef Point = { x : Float, y : Float };
class CommonUtil {

    public static function getValueFromInterval(interval : String, delimiter : String = "-") : Float {
        var values = interval.split(delimiter);
        if (values.length == 0) {
            return 0;
        } else if (values.length == 1) {
            return Std.parseFloat(values[0]);
        }

        var min : Float = Std.parseFloat(values[0]);
        var max : Float = Std.parseFloat(values[1]);
        
        return Random.float(min, max);
    }

    public static function toXYCoords(polarPosition : PolarPosition) : Point {
        var centerX = Main.WIDTH / 2;
        var centerY = Main.HEIGHT / 2;
        
        var struct = {  
            x: centerX + polarPosition.radius * Math.sin(polarPosition.angle),
            y: centerY + polarPosition.radius * Math.cos(polarPosition.angle)
        };
        return struct; 
    }
}