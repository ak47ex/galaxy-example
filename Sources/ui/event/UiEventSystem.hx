package ui.event;

import pongo.ecs.group.SourceGroup;
import pongo.ecs.System;
import ui.event.component.ChangeStarsAmountEvent;
import pongo.ecs.Entity;
import component.Star;

class UiEventSystem extends System {

    private var starsEvents : SourceGroup;

    public function new() {

    }

    override function onAdded() {
        starsEvents = this.pongo.manager.registerGroup([ChangeStarsAmountEvent]);
    }

    override public function update(dt :Float) : Void
    {
        if (starsEvents.length > 0) {
            var total : Int = 0;
            var entity : Entity = starsEvents.first();
            while (starsEvents.length > 0) {
                var event = entity.getComponent(ChangeStarsAmountEvent);
                total += event.amount;
                var tmp = entity.next;
                this.pongo.manager.removeEntity(entity);
                entity = tmp;
            }
            var shouldAdd = total > 0;
            for (i in 0...Std.int(Math.abs(total))) {
                if (shouldAdd) {
                    StarFactory.instance.createRandomStar();
                } else {
                    var stars : SourceGroup = this.pongo.manager.registerGroup([Star]);
                    stars.first().parent.removeEntity(stars.first());
                }
            }
        }
    }

}