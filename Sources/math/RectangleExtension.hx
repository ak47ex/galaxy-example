package math;

import pongo.math.Rectangle;

class RectangleExtension {

    public static function contains(rect : Rectangle, x : Float, y : Float) : Bool {
        return x >= rect.left() && x <= rect.right() && y <= rect.bottom() && y >= rect.top();
    }

}