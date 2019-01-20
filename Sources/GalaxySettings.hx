class GalaxySettings {
    public var spin(default, null) : Float;
    public var armsAmount(default, null) : Int;
    
    public var starDistance(default, null) : Float;

    public function new() {
        spin = 0.197;
        armsAmount = 2;
        starDistance = 10000;
    }
}