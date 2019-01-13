package system;

import pongo.ecs.group.SourceGroup;
import pongo.ecs.System;
import component.PolarPosition;
import pongo.ecs.transform.Transform;
import pongo.ecs.Entity;
import Random;
import component.Star;

class StarsInitSystem extends System {

    private var starsRoot : Entity;
    private var galaxySettings : GalaxySettings;

    private var stars : SourceGroup;
    private var starsLength : Int;

    public function new(starsRoot : Entity, galaxySettings : GalaxySettings) {
        this.starsRoot = starsRoot;
        this.galaxySettings = galaxySettings;
    } 

    override public function onAdded() : Void
    {
        stars = this.pongo.manager.registerGroup([Star]);
        updateStarsPosition();
        starsLength = stars.length;
    }

    override public function update(dt :Float) : Void
    {
        if (stars.length != starsLength) {
            updateStarsPosition();
            starsLength = stars.length;
            trace('Total stars: $starsLength');
        }
    }


    //TODO: need actually update positions for new stars, not reinitiate positions.
    private function updateStarsPosition() {
        var starsInArm = Std.int(stars.length / galaxySettings.armsAmount);

        var star : Entity = starsRoot.firstChild;
        var step = (2 * Math.PI) / galaxySettings.armsAmount;
        
        for (i in 0...galaxySettings.armsAmount) {
            var distance : Float = 150;
            var minDistance = 10;
            var maxDistance = 250;

            var curvature : Float = 1;
            var curvatureStep = galaxySettings.spin;
            
            var startAngle = i * step;
    
            var dispersion = 0.05;
            
            var starIndex = 0;
            while (star != null && starIndex < starsInArm) {
                var pos = star.getComponent(PolarPosition);
                pos.angle = Random.float(0, 2 * curvatureStep) + curvature +  startAngle;
                pos.radius = distance + pos.angle;
            
                distance += Random.float(minDistance, maxDistance);
                curvature += curvatureStep;
                star = star.next;
                starIndex++;
            }
        }
    }
}