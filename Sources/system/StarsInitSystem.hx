package system;

import pongo.ecs.group.SourceGroup;
import pongo.ecs.System;
import component.PolarPosition;
import pongo.ecs.transform.Transform;
import pongo.ecs.Entity;
import Random;
import component.Star;
import component.Arm;

class StarsInitSystem extends System {

    //each arm contains array of stars
    private var arms : Array<Array<Entity>>;
    private var starsRoot : Entity;
    private var galaxySettings : GalaxySettings;
    private var armsLength : Int;

    private var armEntities : SourceGroup;

    private var stars : SourceGroup;
    private var starsLength : Int;
    private var lastIndex = 0;

    private var starDistance = 150;

    public function new(starsRoot : Entity, galaxySettings : GalaxySettings) {
        this.starsRoot = starsRoot;
        this.galaxySettings = galaxySettings;
        armsLength = galaxySettings.armsAmount;
    } 

    override public function onAdded() : Void
    {
        stars = this.pongo.manager.registerGroup([Star]);
        armEntities = this.pongo.manager.registerGroup([Arm]);
        initializeArms();
        updateStarsPosition();
        starsLength = stars.length;

        armEntities.onAdded.connect(function (e) {
            increaseArms();
        });
        armEntities.onRemoved.connect(function (e) {
            decreaseArms();
        });
        stars.onAdded.connect(function (e) {
            var arm : Array<Entity> = arms[lastIndex % arms.length];
            arm.push(e);

            var curvatureStep = galaxySettings.spin;
            var step = (2 * Math.PI) / arms.length;

            var startAngle = lastIndex % arms.length * step;
            
            var pos = e.getComponent(PolarPosition);
            pos.angle = (arm.length - 1) * curvatureStep + Random.float(0, 4 * curvatureStep) + startAngle;
            pos.radius = (arm.length - 1) * starDistance + Random.float(0, starDistance / 2) + pos.angle;

            lastIndex++;
            if (lastIndex > arms.length) lastIndex = 1;
        });
    }

    override public function update(dt :Float) : Void
    {
        if (arms.length != armsLength) {
            if (armsLength > arms.length) {
                increaseArms();   
            } else {
                decreaseArms();
            }
        }
        if (stars.length != starsLength) {
            starsLength = stars.length;
        }
    }

    private function initializeArms() {
        var starsInArm = Std.int(stars.length / armsLength);
        arms = new Array<Array<Entity>>();
        var star : Entity = stars.first();

        for (i in 0...armsLength) {
            arms.push(new Array<Entity>());
            var index = 0;
            while (index < starsInArm && star != null) {
                arms[i].push(star);
                star = star.next;
                index++;
            }
        }
    }

    private function increaseArms() {
        var increment = armsLength - arms.length;
        var wasStarsPerArm : Float = stars.length / arms.length;
        for (i in 0...increment) {
            arms.push(new Array<Entity>());
        }

        var becameStarsPerArm : Float = stars.length / arms.length;
        var diff : Int = Std.int(wasStarsPerArm - becameStarsPerArm);

        var reallocateStars : Array<Entity> = new Array<Entity>();
        for (i in 0...(arms.length - increment)) {
            for (j in 0...diff) {
                var star = arms[i].pop();
                if (star != null) reallocateStars.push(star);
            }
        }

        updateStarsPosition();
    }

    private function decreaseArms() {
        //TODO: need implementation
    }

    private function updateStarsPosition() {
        var step = (2 * Math.PI) / arms.length;
        for (i in 0...arms.length) {
            var arm = arms[i];
            var curvatureStep = galaxySettings.spin;
            
            var startAngle = i * step;
            for (j in 0...arm.length) {
                var star = arm[j];

                var pos = star.getComponent(PolarPosition);
                pos.angle = (j + 1) * curvatureStep + startAngle;
                pos.radius = (j + 1) * starDistance + pos.angle;
            }
        }
      
    }
}