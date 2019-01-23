package utility;
import pongo.display.TextSprite;
import kha.Color;
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

    public static function setTextIfPossible(transform :Transform, text : String, ?fontSize : Int, ?color : Color) {
        if (transform.sprite == null) return;
        if (!Std.is(transform.sprite, TextSprite)) return;

        var textSprite :TextSprite = cast(transform.sprite, TextSprite);
        textSprite.text = text;
        if (fontSize != null) {
            textSprite.fontSize = fontSize;
        }
        if (color != null) {
            textSprite.color = color;
        }
    }
}