package component;

import kha.Image;
import pongo.ecs.Component;

class Sprite implements Component {
	var image : Image;
	var width : Float;
	var height : Float;
	var angle : Float;
}