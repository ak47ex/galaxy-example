import pongo.ecs.Entity;
import pongo.ecs.group.Manager;
import component.Arm;

class ArmFactory {
    public static var instance(default, null) : ArmFactory;

    private var galaxyRoot: Entity;

    public static function init(galaxyRoot: Entity, pongoManager : Manager) {
        if (instance != null) return;

        instance = new ArmFactory(galaxyRoot, pongoManager);
    }

    private function new(galaxyRoot: Entity, pongoManager : Manager) {
        this.galaxyRoot = galaxyRoot;
        pongoManager.registerGroup([Arm]);
    }

    public function createArm() {
        var entity = galaxyRoot.createChild();
        entity.addComponent(new Arm());
        return entity;
    }
}