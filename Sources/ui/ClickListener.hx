package ui;



import pongo.math.Rectangle;
import pongo.ecs.transform.Transform;
import pongo.Pongo;

import pongo.util.Signal2;

using math.RectangleExtension;

class ClickListener { 

    public var clicked (default, null) : Signal2<Int, Int> = new Signal2();

    private var button : Int = -1;
    private var downX : Int = -1;
    private var downY : Int = -1;

    var objRect : Rectangle;
    var transform : Transform;
    var pongo : Pongo;
    var width : Int;
    var heigth : Int;

    public function new(pongo : Pongo, transform : Transform) {
        this.transform = transform;
        objRect = new Rectangle(transform.x, transform.y, transform.sprite.getNaturalWidth(), transform.sprite.getNaturalHeight());

        this.pongo = pongo;
        width = pongo.window.width;
        heigth = pongo.window.height;
        pongo.mouse.down.connect(touchDown);
        
    }

    private function touchDown(button : Int, x : Int, y : Int) {
        if (!transform.visible) return;
        if (!objRect.contains(x, y)) return;
        
        if (button != this.button) {
            this.button = button;
            downX = x;
            downY = y;
            return;
        } 
        clicked.emit(x, y);
        reset();
    }

    private function reset() {
        button = -1;
        downX = -1;
        downY = -1;
    }
}