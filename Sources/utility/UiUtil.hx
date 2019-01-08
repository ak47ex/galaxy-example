package utility;
import ui.Align;
import pongo.ecs.transform.Transform;

class UiUtil {

    public static function setXY(transform :Transform, x :Float, y :Float, alignment = 10) :Transform
    {
        if ((alignment & right) != 0)
			x -= transform.sprite.getNaturalWidth();
		else if ((alignment & left) == 0) //
			x -= transform.sprite.getNaturalWidth() / 2;

		if ((alignment & bottom) != 0)
			y -= transform.sprite.getNaturalHeight();
		else if ((alignment & top) == 0) //
			y -= transform.sprite.getNaturalHeight() / 2;

        transform.x = x;
        transform.y = y;
        return transform;
    }
}