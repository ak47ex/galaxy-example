package utility;

import Random;

class MapHelper {

     public static function getRandomKeyForProbability(map : Map<Dynamic, Float>): Dynamic {
          var sum : Float = 0;
          for (value in map) {
              sum += value;
          }
          var needle = Random.float(0, sum);
          var iter = map.keyValueIterator();
          var type : Dynamic = null; 
          while (iter.hasNext() && needle > 0) {
              var pair = iter.next();
              needle -= pair.value;
              type = pair.key;
          }
          return type;
     }

}