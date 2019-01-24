import component.Star.StarType;

class StarSettings {
    
    private var size : Map<StarType, String>;

    public var distribution(default, null) : Map<StarType, Float>;

    public var starsCount(default, null) : Int;

    public var glow(default, null) : Map<StarType, Float>;

    public function new() {
        starsCount = 10;

        distribution = [
            StarType.SUBDWARF => 0.002,
            StarType.DWARF => 0.04,
            StarType.SUBGIANT => 1,
            StarType.GIANT => 0.0001,
            StarType.SUPERGIANT => 0.00001
        ];

        glow = [
            StarType.SUBDWARF => 1,
            StarType.DWARF => 2,
            StarType.SUBGIANT => 10,
            StarType.GIANT => 100,
            StarType.SUPERGIANT => 1000
        ];

        size = [
            StarType.SUBDWARF => "1-100",
            StarType.DWARF => "100-1000",
            StarType.SUBGIANT => "1000-5000",
            StarType.GIANT => "10000-50000",
            StarType.SUPERGIANT => "100000-200000"
        ];
    }

    public function getSizeInterval(type : StarType) : String {
        return size.get(type);
    }
}