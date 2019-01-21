package system;

import com.elnabo.quadtree.Box;
import pongo.ecs.group.SourceGroup;
import pongo.ecs.System;
import component.PolarPosition;
import pongo.ecs.transform.Transform;
import pongo.ecs.Entity;
import Random;
import component.Star;
import component.Arm;
import com.elnabo.quadtree.Quadtree;
import StarQTElement;

using utility.CommonUtil;

class StarsInitSystem extends System {

    //each arm contains array of stars
    private var arms : Array<Array<Entity>>;
    private var starsRoot : Entity;
    private var galaxySettings : GalaxySettings;

    private var armEntities : SourceGroup;

    private var stars : SourceGroup;
    private var lastIndex = 0;

    private var galaxyWidth = 100000000;
    private var galaxyHeight = 100000000;

    private var poolOfNotFit : Array<Entity> = [];

    private var quadTree : Quadtree<Dynamic>;

    private var nonFitShift : Int;

    public function new(starsRoot : Entity, galaxySettings : GalaxySettings) {
        this.starsRoot = starsRoot;
        this.galaxySettings = galaxySettings;
    } 

    override public function onAdded() : Void
    {
        stars = this.pongo.manager.registerGroup([Star]);
        armEntities = this.pongo.manager.registerGroup([Arm]);
        // dispatchAllStars();
        initializeArms();
        updateStarsPosition();
        
        armEntities.onAdded.connect(function (e) {
            increaseArms();
        });
        armEntities.onRemoved.connect(function (e) {
            decreaseArms();
        });

        stars.onAdded.connect(allocateStarInArm);
    }

    override public function update(dt :Float) : Void
    {
        nonFitShift = 0;
        while (poolOfNotFit.length > 0) {
            allocateStarInArm(poolOfNotFit.pop());
            nonFitShift++;
        }
    }

    private function initializeArms() {

        var armsLength = armEntities.length;
        var starsInArm = Std.int(stars.length / armsLength);
        if (stars.length % armsLength > 0) starsInArm += stars.length % armsLength;
        arms = new Array<Array<Entity>>();
        var star : Entity = stars.first();
        
        for (i in 0...armsLength) {
            arms.push(new Array<Entity>());
            var index = 0;
            while (index < starsInArm && star != null) {
                arms[i].push(star);
                star = star.next;
                index++;
            }
        }
    }

    private function increaseArms() {
        var increment = armEntities.length - arms.length;
        for (i in 0...increment) {
            arms.push(new Array<Entity>());
        }
        rearrangeStars();
        updateStarsPosition();
    }
    
    private function rearrangeStars() {
        var starsInArm = Std.int(stars.length / arms.length);
        var undistributed : Array<Entity> = [];
        for (i in 0...arms.length) {
            if (arms[i].length > starsInArm) {
                var left = arms[i].length - starsInArm;
                while (left > 0) {
                    undistributed.push(arms[i].pop());
                    left--;
                }
            }
        }

        for (i in 0...arms.length) {
            var diff = starsInArm - arms[i].length;
            while (diff > 0 && undistributed.length > 0) {
                arms[i].push(undistributed.pop());
                diff--;
            }
        }

        var i = 0;
        while(undistributed.length > 0) {
            arms[i % arms.length].push(undistributed.pop());
            i++;
        }
    }

    private function decreaseArms() {
        //TODO: need implementation
    }

    private function allocateStarInArm(e : Entity) {
        var minVal = arms[0].length;
        var minIndex = 0;
        for (i in 0...arms.length) {
            if (arms[i].length < minVal) {
                minVal = arms[i].length;
                minIndex = i;
            }
        }

        var arm : Array<Entity> = arms[minIndex];
        var step = (2 * Math.PI) / arms.length + 1;

        var startAngle = minIndex * step;
        
        var pos = e.getComponent(PolarPosition);
        applyPosition(pos, arm.length + nonFitShift, startAngle);
        if (addOrPoolStar(e)) {
            arm.push(e);
            lastIndex++;
            if (lastIndex > arms.length) lastIndex = 1;
            if (nonFitShift > 0) nonFitShift -= 1;
        }

    }

    private function recreateQuadTree() {
        var boundary = new Box(-galaxyWidth/2, -galaxyHeight / 2, galaxyWidth, galaxyHeight);
        quadTree = new Quadtree<StarQTElement>(boundary, 10);
    }

    private function addOrPoolStar(star : Entity) : Bool {
        var qtEl = new StarQTElement(star);
        var collisions = quadTree.getCollision(qtEl.box());

        if (collisions.length > 0) {
            poolOfNotFit.push(star);
            return false;
        } else {
            quadTree.add(qtEl);
            return true;
        }
    }

    private function updateStarsPosition() {
        recreateQuadTree();

        var step = (2 * Math.PI) / arms.length;
        for (i in 0...arms.length) {
            var newArm = [];
            var arm = arms[i];
            var startAngle = i * step;
            trace('Arm ${i+1} length ${arm.length}');
            for (j in 0...arm.length) {
                var star = arm[j];
                var pos : PolarPosition = star.getComponent(PolarPosition);
                applyPosition(pos, j + 1, startAngle);
                if (addOrPoolStar(star)) {
                    newArm.push(star);
                }
            }
            arms[i] = newArm;
        }
    }

    private function dispatchAllStars() {
        recreateQuadTree();

        arms = new Array<Array<Entity>>();
        for (i in 0...armEntities.length) {
            arms.push(new Array<Entity>());
        }
        trace(arms);
        var star : Entity = stars.first();
        
        while(star != null) {
            allocateStarInArm(star);
            star = star.next;
        }

    }

    private function applyPosition(pos : PolarPosition, index : Int, startAngle : Float) {
        var curvatureStep = galaxySettings.spin;
        // pos.angle = index * curvatureStep;
        // pos.radius = Math.exp(pos.angle + startAngle);
        pos.angle = index * curvatureStep + startAngle;
        pos.radius = index * galaxySettings.starDistance + pos.angle;
    }
}