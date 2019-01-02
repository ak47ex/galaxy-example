
import kha.Color;
import kha.math.Random;
import pongo.ecs.transform.Transform;
import pongo.display.CircleSprite;
import component.PolarPosition;
import component.Star;
import pongo.Pongo;
import pongo.ecs.Entity;

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

        settings.distribution;

        

        var type = types[Random.getIn(0, types.length - 1)];

        entity.addComponent(new PolarPosition(0, 0));
        entity.addComponent(new Star(type));
        entity.addComponent(new Transform(new CircleSprite(Color.fromValue(Random.getUpTo(32000000)).value, Random.getFloatIn(0, 20))));


        return entity;
    }
}