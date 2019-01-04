
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


    private var starRoot: Entity;
    private var settings: StarSettings;
    private var types : Array<StarType> = StarType.createAll();

    public function new(starRoot: Entity, starSettings: StarSettings) {
        this.starRoot = starRoot;
        this.settings = starSettings;
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

        entity.addComponent(new PolarPosition(0, 0));
        entity.addComponent(new Star(type));
        entity.addComponent(new Transform(new CircleSprite(Color.fromValue(Random.int(0, 32000000)).value, size)));


        return entity;
    }
}