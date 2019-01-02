package;

import pongo.util.Signal2;
import kha.Color;
import kha.math.Random;
import component.Star;
import component.PolarPosition;
import pongo.display.CircleSprite;
import pongo.Pongo;
import pongo.ecs.transform.Transform;
import pongo.ecs.transform.TransformSystem;
import pongo.ecs.Component;
import pongo.ecs.System;
import pongo.ecs.Entity;
import pongo.ecs.group.SourceGroup;
import pongo.display.FillSprite;
import system.PositionSystem;
import system.StarsInitSystem;

class Main {

	public static inline var WIDTH = 400;
	public static inline var HEIGHT = 400;

	public static function main() {
        
        pongo.platform.Pongo.create("Empty", WIDTH, HEIGHT, onStart);
	}

	private static function onStart(pongo :Pongo) : Void
    {
        Random.init(Std.int(Date.now().getTime()));

        pongo.window.onResize.connect(onResize);


        var galaxySettings = new GalaxySettings();

        var starSettings = new StarSettings();
        var starsRoot = pongo.root.createChild();
        var starFactory = new StarFactory(starsRoot, starSettings);

        pongo
            .addSystem(new TransformSystem())
            .addSystem(new PositionSystem());

        for (i in 0...starSettings.starsCount) {
            starFactory.createRandomStar();
            trace("star created");
        }
        var starsInitSystem = new StarsInitSystem(starsRoot, galaxySettings);
        pongo.addSystem(starsInitSystem);
        pongo.removeSystem(starsInitSystem);
            
		var entity = pongo.root.createChild();
    
		entity
			.addComponent(new PolarPosition(0, 0))
			.addComponent(new Transform(new CircleSprite(0x0fff0000, 50)));

		
    }

    private static function onResize(a: Int, b: Int) { 
            trace("Huy");
            trace("$a $b");
    }
}


// class Hero implements Component
// {
//     var speed :Float;
// }

// class HeroSystem extends System
// {
//     public var heroes :SourceGroup;

//     public function new() : Void
//     {
//     }

//     override public function onAdded() : Void
//     {
//         this.heroes = this.pongo.manager.registerGroup([Position, Hero, Transform]);   
//     }

//     override public function update(dt :Float) : Void
//     {
//         heroes.iterate(function(entity) {
//             var hero :Hero = entity.getComponent(Hero);
//             var pos :Position = entity.getComponent(Position);
//             var transform :Transform = entity.getComponent(Transform);
//             var sprite :FillSprite = cast transform.sprite;

//             pos.x = (hero.speed*dt) * Math.cos(pos.angle) + pos.x;
//             pos.y = (hero.speed*dt) * Math.sin(pos.angle) + pos.y;

//             if(pos.y <= 0) {
//                 pos.angle = (-pos.angle);
//                 pos.y = 1;
//                 sprite.color = 0xff00ff00;
//             }
//             else if(pos.y >= pongo.window.height) {
//                 pos.angle = (-pos.angle);
//                 pos.y = pongo.window.height - 1;
//                 sprite.color = 0xff0000ff;
//             }
//             if(pos.x >= pongo.window.width) {
//                 pos.angle = (pos.angle+180) % 360;
//                 pos.x = pongo.window.width -1;
//                 sprite.color = 0xffffff00;
//             }
//             else if(pos.x <= 0) {
//                 pos.angle = (pos.angle+180) % 360;
//                 pos.x = 1;
//                 sprite.color = 0xffff00ff;
//             }

//             transform.y = pos.y;
//             transform.x = pos.x;
//         });
//     }
// }