package ui.fps;

import pongo.display.TextSprite;
import pongo.ecs.transform.Transform;
import pongo.ecs.Entity;
import pongo.ecs.group.SourceGroup;
import kha.Framebuffer;
import kha.Scheduler;
import pongo.ecs.System;
import ui.fps.component.Fps;

class FpsSystem extends System {

    public var previousRealTime:Float;
    public var realTime:Float;

    private var fps : Float;

    private var entities : SourceGroup;
    private var listener : Array<Framebuffer> -> Void;

    public function new() {
        previousRealTime = 0.0;
        realTime = 0.0;
    }

    override public function onAdded() {
        entities = this.pongo.manager.registerGroup([Fps]);
        listener = function (buf) {
            fps++;
        };
        kha.System.notifyOnFrames(listener);
    }

    override public function update(dt :Float) : Void {
        realTime = Scheduler.realTime();
        var time = realTime - previousRealTime;
        if (time >= 1) {
            var totalFps = Math.round(fps / time);
            entities.iterate(function (entity : Entity) {
                var comp = entity.getComponent(Transform);
                entity.getComponent(Fps).count = totalFps;
                cast(comp.sprite, TextSprite).text = '$totalFps';
            });
            fps = 0;
            previousRealTime = realTime;
        }
        
    }

    override public function onRemoved() {
        kha.System.removeFramesListener(listener);
    }

}