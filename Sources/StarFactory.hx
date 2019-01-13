
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

class StarFactory { 

    public static var instance(default, null) : StarFactory;

    private var starRoot: Entity;
    private var settings: StarSettings;
    private var types : Array<StarType> = StarType.createAll();

    public static function init(starRoot: Entity, starSettings: StarSettings, pongoManager : Manager) {
        if (instance != null) return;

        instance = new StarFactory(starRoot, starSettings, pongoManager);
    }

    private function new(starRoot: Entity, starSettings: StarSettings, pongoManager : Manager) {
        this.starRoot = starRoot;
        this.settings = starSettings;
        pongoManager.registerGroup([Star]);
    }

    public function createRandomStar() : Entity {
        var entity = starRoot.createChild();

        var type : StarType = MapHelper.getRandomKeyForProbability(settings.distribution);

        var size : Float;
        switch(type) {
            case SUBDWARF: size = Random.float(0.01, 1);
            case DWARF: size = Random.float(1, 10);
            case SUBGIANT: size = Random.float(10, 50);
            case GIANT: size = Random.float(100, 500);
            case SUPERGIANT: size = Random.float(1000, 2000);
        }

        entity
            .addComponent(new PolarPosition(0, 0))
            .addComponent(new Star(type))
            .addComponent(new Transform(new CircleSprite(Color.fromValue(Random.int(0, 32000000)).value, size)));
    
        
        return entity;
    }
    
}