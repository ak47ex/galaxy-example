import component.Star.StarType;

class StarSettings {
    public var distribution(default, null) : Map<StarType, Float>;

    public var starsCount(default, null) : Int;

    public function new() {
        starsCount = 100;
        distribution = [
            StarType.SUBDWARF => 0.4,
            StarType.DWARF => 1,
            StarType.SUBGIANT => 0.2,
            StarType.GIANT => 0.05,
            StarType.SUPERGIANT => 0.01
        ];
    }
}