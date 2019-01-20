
import component.PolarPosition;
import com.elnabo.quadtree.Box;
import com.elnabo.quadtree.QuadtreeElement;
import pongo.ecs.Entity;
import pongo.ecs.transform.Transform;
import component.Star;

using utility.CommonUtil;

class StarQTElement implements QuadtreeElement {

    private var starBox : Box;
    private var entity : Entity;

    public function new(star : Entity) {
        var radius = star.getComponent(Star).radius;
        var polarPos : PolarPosition = star.getComponent(PolarPosition);
        var cartesianPos : Point  = polarPos.toXYCoords();

        var x = cartesianPos.x;
        var y = cartesianPos.y;
        starBox = new Box(x, y, radius * 2, radius * 2);
        
        this.entity = star;
    }

    public function box() : Box {
        return starBox;
    }

    public function getEntity() : Entity {
        return entity;
    }

}