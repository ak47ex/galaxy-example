package system;

import pongo.ecs.System;
import component.PolarPosition;
import pongo.ecs.transform.Transform;
import pongo.ecs.Entity;
import Random;

class StarsInitSystem extends System {

    private var starsRoot : Entity;
    private var galaxySettings : GalaxySettings;

    public function new(starsRoot : Entity, galaxySettings : GalaxySettings) {
        this.starsRoot = starsRoot;
        this.galaxySettings = galaxySettings;
    } 

    override public function onAdded() : Void
    {
        var distance : Float = 50;
    
        var curvature : Float = 1;
        var curvatureStep = 0.035;
        var star : Entity = starsRoot.firstChild;
        var startAngle = Math.PI / 2;

        var dispersion = curvatureStep * 2.5;
        
        while (star != null) {
            var pos = star.getComponent(PolarPosition);
            pos.angle = (curvature + Random.float(-dispersion, dispersion)) * Math.PI / 2;
            pos.radius = distance + pos.angle;
        
            distance += Random.float(15, 40);
            curvature += curvatureStep;
            star.notifyChange();
            star = star.next;
        }
    }
}