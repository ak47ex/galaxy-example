
import pongo.platform.display.Graphics;
import pongo.ecs.transform.Transform;
import pongo.display.Texture;
import pongo.display.ImageSprite;

class MutableImageSprite extends ImageSprite {

    private var width : Float;
    private var height : Float;

    public function new(texture : Texture, ?width : Float, ?height : Float) {
        super(texture);
        this.width = width;
        this.height = height;
    }

    override public function getNaturalWidth() : Float
    {
        return width;
    }

    override public function getNaturalHeight() : Float
    {
        return height;
    }
    
}