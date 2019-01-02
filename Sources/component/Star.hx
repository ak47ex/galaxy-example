package component;

import pongo.ecs.Component;

class Star implements Component {
	var type : StarType;
}

enum StarType {
	SUBDWARF;
	DWARF;
	SUBGIANT;
	GIANT;
	SUPERGIANT;
}