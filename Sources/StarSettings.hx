import component.Star.StarType;

class StarSettings {
    public var distribution(default, null) : Map<StarType, Float>;

    public var starsCount(default, null) : Int;

    public function new() {
        starsCount = 500;
        distribution = [
            StarType.SUBDWARF => 0.4,
            StarType.DWARF => 0.001,
            StarType.SUBGIANT => 2,
            StarType.GIANT => 0.005,
            StarType.SUPERGIANT => 0.00
        ];
    }
}