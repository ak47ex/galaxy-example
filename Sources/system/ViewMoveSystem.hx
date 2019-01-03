package system;

import kha.graphics2.Graphics;
import kha.input.KeyCode;
import pongo.input.KeyCode;
import pongo.input.Keyboard;
import pongo.ecs.System;
import pongo.ecs.transform.Transform;

class ViewMoveSystem extends System {

    private var gameWidth : Float;
    private var gameHeight : Float;

    private var cameraSpeed = 1000;
    private var zoomSpeed = 1;

    private var down : Bool;
    private var up : Bool;
    private var right : Bool;
    private var left : Bool;

    private var zoomIn : Bool;
    private var zoomOut : Bool;

    private var defaultX : Float;
    private var defaultY : Float;
    private var defaultScaleX : Float;
    private var defaultScaleY : Float;

    private var isTouch : Bool;

    public function new(gameWidth : Float, gameHeight : Float) { 
        this.gameWidth = gameWidth;
        this.gameHeight = gameHeight;
    }

    override public function onAdded() {
        this.pongo.keyboard.down.connect(buttonDown);
        this.pongo.keyboard.up.connect(buttonUp);
        this.pongo.mouse.down.connect(touchDown);
        this.pongo.mouse.move.connect(touchMove);

        var camera = this.pongo.root.getComponent(Transform);
        defaultX = camera.x;
        defaultY = camera.y;
        defaultScaleX = camera.scaleX;
        defaultScaleY = camera.scaleY;
    }

    override public function update(delta : Float) {
        var camera = this.pongo.root.getComponent(Transform);

        if (down) {
            camera.y -= delta * cameraSpeed;
        }
        if (up) {
            camera.y += delta * cameraSpeed;
        }
        if (left) {
            camera.x += delta * cameraSpeed;
        }
        if (right) {
            camera.x -= delta * cameraSpeed;
        }
        
        if (zoomIn) {
            camera.scaleX += delta * zoomSpeed;
            camera.scaleY += delta * zoomSpeed;
            camera.x -= delta * gameWidth / 2 * zoomSpeed;
            camera.y -= delta * gameHeight / 2 * zoomSpeed;
        }

        if (zoomOut) {
            camera.scaleX -= delta * zoomSpeed;
            camera.scaleY -= delta * zoomSpeed;
            camera.x += delta * gameWidth / 2 * zoomSpeed;
            camera.y += delta * gameHeight / 2 * zoomSpeed;

            if (camera.scaleX < 0) camera.scaleX = 0;
            if (camera.scaleY < 0) camera.scaleY = 0;
        }
    }

    private function buttonDown(key : KeyCode) {
        if (key == KeyCode.Down) {
            down = true;
        }

        if (key == KeyCode.Up) {
            up = true;
        }

        if (key == KeyCode.Right) {
            right = true;
        }

        if (key == KeyCode.Left) {
            left = true;
        }

        if (key == KeyCode.Add) {
            zoomIn = true;
        }

        if (key == KeyCode.Subtract) {
            zoomOut = true;
        }

        if (key == KeyCode.Escape) {
            resetView();
        }
    }

    private function buttonUp(key : KeyCode) {
        if (key == KeyCode.Down) {
            down = false;
        }

        if (key == KeyCode.Up) {
            up = false;
        }

        if (key == KeyCode.Right) {
            right = false;
        }

        if (key == KeyCode.Left) {
            left = false;
        }

        if (key == KeyCode.Add) {
            zoomIn = false;
        }

        if (key == KeyCode.Subtract) {
            zoomOut = false;
        }
    }

    private function touchDown(button : Int, x : Int, y : Int) {
        if (button == 0) {
            isTouch = !isTouch;
        }
    }

    private function touchMove(x : Int, y : Int, deltaX : Int, deltaY : Int) {
        if (!isTouch) return;

        var window = this.pongo.window;
        var inWindow = x >= window.x && x <= window.x + window.width && y >= window.y && y <= window.y + window.height;
        if (!inWindow) return;

        
        var camera = this.pongo.root.getComponent(Transform);
        camera.x += gameWidth / window.width * deltaX;
        camera.y += gameHeight / window.height * deltaY;
    }

    private function resetView() {
        var camera = this.pongo.root.getComponent(Transform);
        camera.x = defaultX;
        camera.y = defaultY;
        camera.scaleX = defaultScaleX;
        camera.scaleY = defaultScaleY;
    }

}