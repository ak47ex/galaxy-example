package ui;

import pongo.display.FillSprite;
import kha.Color;
import pongo.display.Font;
import pongo.ecs.Entity;
import pongo.ecs.transform.Transform;
import pongo.display.TextSprite;

using pongo.ecs.transform.Transform.TransformUtil;
using utility.UiUtil;

class ButtonFactory {

    var buttonLayer : Entity;

    public static function createButton(uiLayer : Entity, text : String, font : Font, fontSize : Int, fontColor : Color, x : Float, y : Float, align : Align) : Entity {
        var button = uiLayer.createChild();
        
        var textOffsetX = 10;
        var textOffsetY = 5;
        var borderColor = 0xff9f9f9f;
        var bodyColor = 0xffffffff;

        var textSprite = new TextSprite(font, fontSize, fontColor, text);

        var buttonWidth = textSprite.getNaturalWidth() + 2 * textOffsetX;
        var buttonHeight = textSprite.getNaturalHeight() + 2 * textOffsetY;

        button.addComponent(new Transform(new FillSprite(borderColor, buttonWidth, buttonHeight)).setXY(x, y, align));
        button.createChild().addComponent(new Transform(new FillSprite(bodyColor, 0.9 * buttonWidth, 0.82 * buttonHeight)).setXY(0.05 * buttonWidth, 0.09 * buttonHeight));

        var transform = new Transform(textSprite).setXY(buttonWidth / 2, buttonHeight / 2).centerAnchor();
        button.createChild().addComponent(transform);
        


        return button;
    }
}