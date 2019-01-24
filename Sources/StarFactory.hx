
import pongo.display.FillSprite;
import kha.Color;
import Random;
import pongo.ecs.transform.Transform;
import component.PolarPosition;
import component.Star;
import pongo.Pongo;
import pongo.ecs.Entity;
import utility.MapHelper;
import pongo.asset.AssetPack;
import graphics.StarSprite;

import utility.CommonUtil.getValueFromInterval in randVal;


class StarFactory { 

    private static var STAR_IMAGE_SIZE = 1024;

    public static var instance(default, null) : StarFactory;

    private var pack: AssetPack;
    private var starRoot: Entity;
    private var settings: StarSettings;
    private var types : Array<StarType> = StarType.createAll();
    private var pongo : Pongo;

    public static function init(starRoot: Entity, starSettings: StarSettings, pongo : Pongo, pack : AssetPack) {
        if (instance != null) return;
    
        instance = new StarFactory(starRoot, starSettings, pongo, pack);
    }

    private function new(starRoot: Entity, starSettings: StarSettings, pongo : Pongo, pack : AssetPack) {
        this.starRoot = starRoot;
        this.settings = starSettings;
        this.pack = pack;
        this.pongo = pongo;
        pongo.manager.registerGroup([Star]);
    }

    public function createRandomStar() : Entity {
        var entity = starRoot.createChild();

        var type : StarType = MapHelper.getRandomKeyForProbability(settings.distribution);

        var size : Float = randVal(settings.getSizeInterval(type));
        
        entity
            .addComponent(new PolarPosition(0, 0))
            .addComponent(new Star(type, size))
            .addComponent(new Transform(new StarSprite(pongo, settings.glow.get(type),  2 * size, 2 * size)));
            // .addComponent(new Transform(new FillSprite(Color.fromValue(Random.int(0, 32000000)).value, 2 * size, 2 * size)));
    
        
        return entity;
    }
    
}