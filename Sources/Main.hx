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
import pongo.ecs.Entity;
import ui.event.UiEventSystem;
import ui.event.component.ChangeStarsAmountEvent;
import ui.event.component.ChangeArmAmountEvent;
import ui.ClickListener;

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
            #if fps
            .addSystem(new FpsSystem())
            #end
            .addSystem(new PositionSystem())
            .addSystem(new UiEventSystem());
        
        initializeStars(pongo, pack);
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


        var buttonArm : Entity = ButtonFactory.createButton(uiLayer, "+1 arm", font, 40, Color.Magenta, WIDTH, HEIGHT - 120, Align.bottomRight);
        var clickListener : ClickListener = new ClickListener(pongo, buttonArm.getComponent(Transform));
        clickListener.clicked.connect(function (x : Int, y : Int) {
            uiLayer.addComponent(new ChangeArmAmountEvent(1));
            trace("+1 arm");
        });

        var button1k : Entity = ButtonFactory.createButton(uiLayer, "+1k stars", font, 40, Color.Magenta, WIDTH, HEIGHT - 60, Align.bottomRight);
        var clickListener : ClickListener = new ClickListener(pongo, button1k.getComponent(Transform));
        clickListener.clicked.connect(function (x : Int, y : Int) {
            uiLayer.addComponent(new ChangeStarsAmountEvent(1000));
            trace("+1k");
        });

        var button10k: Entity = ButtonFactory.createButton(uiLayer, "+10k stars", font, 40, Color.Magenta, WIDTH, HEIGHT, Align.bottomRight);
        var clickListener : ClickListener = new ClickListener(pongo, button10k.getComponent(Transform));
        clickListener.clicked.connect(function (x : Int, y : Int) {
            uiLayer.addComponent(new ChangeStarsAmountEvent(10000));
            trace("+10k");
        });
    }

    private static function initializeStars(pongo : Pongo, pack : AssetPack) {
        var galaxySettings = new GalaxySettings();

        var starSettings = new StarSettings();
        var starsRoot = pongo.root.createChild();
        starsRoot.addComponent(new Transform(new ClearSprite(0,0)));

        StarFactory.init(starsRoot, starSettings, pongo.manager, pack);
        ArmFactory.init(starsRoot, pongo.manager);

        for (i in 0...galaxySettings.armsAmount) {
            ArmFactory.instance.createArm();
        }
        for (i in 0...starSettings.starsCount) {
            StarFactory.instance.createRandomStar();
        }
    
        pongo.addSystem(new ViewMoveSystem(WIDTH, HEIGHT, starsRoot));
    
        var starsInitSystem = new StarsInitSystem(starsRoot, galaxySettings);
        pongo.addSystem(starsInitSystem);
        
        var bulge = starsRoot.createChild();
		bulge
			.addComponent(new PolarPosition(0, 0))
			.addComponent(new Transform(new CircleSprite(0x0fff0000, 100)));
    }
}