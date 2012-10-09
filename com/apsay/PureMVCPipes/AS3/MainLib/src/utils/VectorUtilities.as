package utils {
	import flash.display.Sprite;

	/**
	 * @author Panhezeng
	 */
	public class VectorUtilities {
		public static function getFixedRegExp(data : Array) : Vector.<RegExp> {
			var v : Vector.<RegExp> = Vector.<RegExp>(data);
			v.fixed = true;
			return v;
		}

		public static function getFixedString(data : Array) : Vector.<String> {
			var v : Vector.<String> = Vector.<String>(data);
			v.fixed = true;
			return v;
		}

		public static function getFixedSprite(data : Array) : Vector.<Sprite> {
			var v : Vector.<Sprite> = Vector.<Sprite>(data);
			v.fixed = true;
			return v;
		}
	}
}
