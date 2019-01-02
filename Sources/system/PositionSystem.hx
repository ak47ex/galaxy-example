package system;

import pongo.ecs.Entity;
import component.PolarPosition;
import pongo.ecs.System;
import pongo.ecs.group.SourceGroup;
import pongo.ecs.transform.Transform;


class PositionSystem extends System {

    public var entities :SourceGroup;

    public function new() {

    } 

    override public function onAdded() : Void
    {
        this.entities = this.pongo.manager.registerGroup([PolarPosition, Transform]); 

        entities.onAdded.connect(updatePosition);
        entities.onUpdated.connect(updatePosition);
    }

    private function updatePosition(entity : Entity) {
            var pos : PolarPosition = entity.getComponent(PolarPosition);
            var transform :Transform = entity.getComponent(Transform);
            var centerX = this.pongo.window.width / 2;
            var centerY = this.pongo.window.height / 2;
            
            transform.y = centerY + pos.radius * Math.cos(pos.angle);
            transform.x = centerX + pos.radius * Math.sin(pos.angle);
    }
}