package component;

import pongo.ecs.Component;

class Star implements Component {
	var type : StarType;
	var radius : Float;
}

enum StarType {
	SUBDWARF;
	DWARF;
	SUBGIANT;
	GIANT;
	SUPERGIANT;
}