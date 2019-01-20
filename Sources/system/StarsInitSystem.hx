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
    private var armsLength : Int;

    private var armEntities : SourceGroup;

    private var stars : SourceGroup;
    private var starsLength : Int;
    private var lastIndex = 0;

    private var galaxyWidth = 100000000;
    private var galaxyHeight = 100000000;

    private var poolOfNotFit : Array<Entity> = [];

    private var quadTree : Quadtree<Dynamic>;

    private var nonFitShift : Int;

    public function new(starsRoot : Entity, galaxySettings : GalaxySettings) {
        this.starsRoot = starsRoot;
        this.galaxySettings = galaxySettings;
        armsLength = galaxySettings.armsAmount;
    } 

    override public function onAdded() : Void
    {
        stars = this.pongo.manager.registerGroup([Star]);
        armEntities = this.pongo.manager.registerGroup([Arm]);
        initializeArms();
        updateStarsPosition();
        starsLength = stars.length;
        
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
        if (arms.length != armsLength) {
            if (armsLength > arms.length) {
                increaseArms();   
            } else {
                decreaseArms();
            }
        }
        if (stars.length != starsLength) {
            starsLength = stars.length;
        }

        nonFitShift = 0;
        while (poolOfNotFit.length > 0) {
            trace(poolOfNotFit.length);
            allocateStarInArm(poolOfNotFit.pop());
            nonFitShift++;
        }
    }

    private function initializeArms() {
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
        var increment = armsLength - arms.length;
        var wasStarsPerArm : Float = stars.length / arms.length;
        for (i in 0...increment) {
            arms.push(new Array<Entity>());
        }

        var becameStarsPerArm : Float = stars.length / arms.length;
        var diff : Int = Std.int(wasStarsPerArm - becameStarsPerArm);

        var reallocateStars : Array<Entity> = new Array<Entity>();
        for (i in 0...(arms.length - increment)) {
            for (j in 0...diff) {
                var star = arms[i].pop();
                if (star != null) reallocateStars.push(star);
            }
        }

        updateStarsPosition();
    }

    private function decreaseArms() {
        //TODO: need implementation
    }

    private function allocateStarInArm(e : Entity) {
        var arm : Array<Entity> = arms[lastIndex % arms.length];
    
        var curvatureStep = galaxySettings.spin;
        var step = (2 * Math.PI) / arms.length + 1;

        var startAngle = lastIndex % arms.length * step;
        
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
            var arm = arms[i];
            var startAngle = i * step;
            for (j in 0...arm.length) {
                var star = arm[j];
                var pos : PolarPosition = star.getComponent(PolarPosition);
                applyPosition(pos, j + 1, startAngle);
                addOrPoolStar(star);
            }
        } 
    }

    private function applyPosition(pos : PolarPosition, index : Int, startAngle : Float) {
        var curvatureStep = galaxySettings.spin;
        pos.angle = index * curvatureStep + startAngle;
        pos.radius = index * galaxySettings.starDistance + pos.angle;
    }
}