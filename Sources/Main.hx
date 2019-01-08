package;

import pongo.display.Font;
import pongo.display.ClearSprite;
import kha.Color;
import kha.math.Random;
import component.PolarPosition;
import pongo.display.CircleSprite;
import pongo.Pongo;
import pongo.platform.Pongo as PlatformPongo;
import pongo.ecs.transform.Transform;
import pongo.ecs.transform.TransformSystem;
import system.PositionSystem;
import system.StarsInitSystem;
import system.ViewMoveSystem;
import pongo.display.TextSprite;
import pongo.asset.AssetPack;
import pongo.asset.Manifest;
import ui.fps.FpsSystem;
import ui.fps.component.Fps;
import ui.ButtonFactory;
import ui.Align;

using pongo.ecs.transform.Transform.TransformUtil;

class Main {

	public static inline var WIDTH = 600;
	public static inline var HEIGHT = 400;

	private static var font:Font;


	public static function main() {
        PlatformPongo.create("Empty", WIDTH, HEIGHT, function(pongo) {
            pongo.loadManifest(Manifest.fromAssets("galaxy"), onStart.bind(pongo));
        });        
	}

	private static function onStart(pongo :Pongo, pack :AssetPack) : Void
    {
        Random.init(Std.int(Date.now().getTime()));
        font = pack.getFont("carbon");

        pongo
            .addSystem(new TransformSystem())
            #if fps
            .addSystem(new FpsSystem())
            #end
            .addSystem(new PositionSystem());
        
        initializeStars(pongo);
		initializeUi(pongo);
    }

    private static function initializeUi(pongo : Pongo) {
        var uiLayer = pongo.root.createChild();
    
        #if fps
        var fpsCounter = uiLayer.createChild();
        fpsCounter
            .addComponent(new Transform(new TextSprite(font, 43, Color.White, "")).setXY(0, 0))
            .addComponent(new Fps());
        #end

        ButtonFactory.createButton(uiLayer, "+1000", font, 40, Color.Magenta, WIDTH, HEIGHT - 60, Align.bottomRight);
        ButtonFactory.createButton(uiLayer, "+10000", font, 40, Color.Magenta, WIDTH, HEIGHT, Align.bottomRight);
    }

    private static function initializeStars(pongo : Pongo) {
        var galaxySettings = new GalaxySettings();

        var starSettings = new StarSettings();
        var starsRoot = pongo.root.createChild();
        starsRoot.addComponent(new Transform(new ClearSprite(0,0)));

        var starFactory = new StarFactory(starsRoot, starSettings, pongo.manager);
        
        for (i in 0...starSettings.starsCount) {
            starFactory.createRandomStar();
        }
        
    
        pongo.addSystem(new ViewMoveSystem(WIDTH, HEIGHT, starsRoot));
    
        var starsInitSystem = new StarsInitSystem(starsRoot, galaxySettings);
        pongo.addSystem(starsInitSystem);
        pongo.removeSystem(starsInitSystem);
        
        var bulge = starsRoot.createChild();
		bulge
			.addComponent(new PolarPosition(0, 0))
			.addComponent(new Transform(new CircleSprite(0x0fff0000, 50)));
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