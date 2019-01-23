package ui.info;

import pongo.util.SignalConnection;
import pongo.ecs.transform.Transform;
import component.Arm;
import component.Star;
import pongo.ecs.group.SourceGroup;
import pongo.ecs.System;

import ui.info.component.ArmCounter;
import ui.info.component.StarCounter;

using utility.UiUtil;

class InfoSystem extends System {

    var stars : SourceGroup;
    var arms : SourceGroup;

    var armInfo : SourceGroup;
    var starInfo : SourceGroup;

    var starsConnectionAdd : SignalConnection;
    var starsConnectionRemove : SignalConnection;

    var armsConnectionAdd : SignalConnection;
    var armsConnectionRemove : SignalConnection;

    public function new() {

    }

    override function onAdded() {
        super.onAdded();
        stars = pongo.manager.registerGroup([Star]);
        arms = pongo.manager.registerGroup([Arm]);
        
        starInfo = pongo.manager.registerGroup([StarCounter]);
        armInfo = pongo.manager.registerGroup([ArmCounter]);

        armsConnectionAdd = arms.onAdded.connect(function (e) {updateArmCounter();});
        armsConnectionRemove = arms.onRemoved.connect(function (e) {updateArmCounter();});

        starsConnectionAdd = stars.onAdded.connect(function (e) {updateStarCounter();});
        starsConnectionRemove = stars.onRemoved.connect(function (e) {updateStarCounter();});

        updateStarCounter();
        updateArmCounter();
    }

    override function update(dt:Float) {
        super.update(dt);
        updateStarCounter();
        updateArmCounter();
    }

    override function onRemoved() {
        super.onRemoved();
        armsConnectionAdd.dispose();
        armsConnectionRemove.dispose();
        starsConnectionAdd.dispose();
        starsConnectionRemove.dispose();
    }

    function updateStarCounter() {
        var starsAmount = stars.length;
        starInfo.iterate(function (e) {
            e.getComponent(StarCounter).amount = starsAmount;
            if (e.hasComponent(Transform)) {
                var transform = e.getComponent(Transform);
                transform.setTextIfPossible('Stars: $starsAmount');
            }
        });
    }

    function updateArmCounter() {
        var armsAmount = arms.length;
        armInfo.iterate(function (e) {
            e.getComponent(ArmCounter).amount = armsAmount;
            if (e.hasComponent(Transform)) {
                var transform = e.getComponent(Transform);
                transform.setTextIfPossible('Arms: $armsAmount');
            }
        });
    }
}
