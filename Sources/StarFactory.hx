
import pongo.display.FillSprite;
import pongo.ecs.group.Manager;
import kha.Color;
import Random;
import pongo.ecs.transform.Transform;
import pongo.display.CircleSprite;
import component.PolarPosition;
import component.Star;
import pongo.Pongo;
import pongo.ecs.Entity;
import utility.MapHelper;
import pongo.display.ImageSprite;
import pongo.asset.AssetPack;

import utility.CommonUtil.getValueFromInterval in randVal;

using pongo.ecs.transform.Transform.TransformUtil;

class StarFactory { 

    private static var STAR_IMAGE_SIZE = 1024;

    public static var instance(default, null) : StarFactory;

    private var pack: AssetPack;
    private var starRoot: Entity;
    private var settings: StarSettings;
    private var types : Array<StarType> = StarType.createAll();

    public static function init(starRoot: Entity, starSettings: StarSettings, pongoManager : Manager, pack : AssetPack) {
        if (instance != null) return;

        instance = new StarFactory(starRoot, starSettings, pongoManager, pack);
    }

    private function new(starRoot: Entity, starSettings: StarSettings, pongoManager : Manager, pack : AssetPack) {
        this.starRoot = starRoot;
        this.settings = starSettings;
        this.pack = pack;
        pongoManager.registerGroup([Star]);
    }

    public function createRandomStar() : Entity {
        var entity = starRoot.createChild();

        var type : StarType = MapHelper.getRandomKeyForProbability(settings.distribution);

        var size : Float = randVal(settings.getSizeInterval(type));
    
        var sprites = ["star_1", "star_2", "star_3"];
        var spriteName = Random.fromArray(sprites);
        entity
            .addComponent(new PolarPosition(0, 0))
            .addComponent(new Star(type, size))
            //                                                                                          dirty hack to rescale image
            // .addComponent(new Transform(new MutableImageSprite(pack.getImage(spriteName), size, size)).setScale(size / STAR_IMAGE_SIZE));
            .addComponent(new Transform(new FillSprite(Color.fromValue(Random.int(0, 32000000)).value, 2 * size, 2 * size)));
    
        
        return entity;
    }
    
}