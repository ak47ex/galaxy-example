package ui.event;

import pongo.ecs.group.SourceGroup;
import pongo.ecs.System;
import ui.event.component.ChangeStarsAmountEvent;
import ui.event.component.ChangeArmAmountEvent;
import pongo.ecs.Entity;
import component.Star;
import component.Arm;

class UiEventSystem extends System {

    private var starsEvents : SourceGroup;
    private var armsEvents : SourceGroup;
   
    public function new() {

    }

    override function onAdded() {
        starsEvents = this.pongo.manager.registerGroup([ChangeStarsAmountEvent]);
        armsEvents = this.pongo.manager.registerGroup([ChangeArmAmountEvent]);
        starsEvents.onAdded.connect(function (e) {
            if (!e.hasComponent(ChangeStarsAmountEvent)) return;
            processStarEvents();
        });

        armsEvents.onAdded.connect(function (e) {
            if (!e.hasComponent(ChangeArmAmountEvent)) return;
            processArmEvents();
        });
    }

    override public function update(dt :Float) : Void
    {

    }

    private function processStarEvents() {
        var total : Int = 0;
        var entity : Entity = starsEvents.first();
        while (starsEvents.length > 0) {
            var event = entity.getComponent(ChangeStarsAmountEvent);
            total += event.amount;
            entity.removeComponent(ChangeStarsAmountEvent);
            var tmp = entity.next;
            this.pongo.manager.removeEntity(entity);
            entity = tmp;
        }
        var shouldAdd = total > 0;
        for (i in 0...Std.int(Math.abs(total))) {
            if (shouldAdd) {
                var entity = StarFactory.instance.createRandomStar();
            } else {
                var stars : SourceGroup = this.pongo.manager.registerGroup([Star]);
                stars.first().parent.removeEntity(stars.first());
            }
        }
    }

    private function processArmEvents() {
        var total : Int = 0;
        var entity : Entity = armsEvents.first();
        while (armsEvents.length > 0) {
            var event = entity.getComponent(ChangeArmAmountEvent);
            total += event.amount;
            var tmp = entity.next;
            entity.removeComponent(ChangeArmAmountEvent);
            this.pongo.manager.removeEntity(entity);
            entity = tmp;
        }
        var shouldAdd = total > 0;
        for (i in 0...Std.int(Math.abs(total))) {
            if (shouldAdd) {
                ArmFactory.instance.createArm();
            } else {
                var arms : SourceGroup = this.pongo.manager.registerGroup([Arm]);
                arms.first().parent.removeEntity(arms.first());
            }
        }
    }
}