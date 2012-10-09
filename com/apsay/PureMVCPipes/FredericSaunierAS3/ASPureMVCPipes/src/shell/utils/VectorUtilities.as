package shell.utils {
	import flash.display.Sprite;

	/**
	 * @author Panhezeng
	 */
	public class VectorUtilities {
		public static function getFixedRegExp(v : Vector.<RegExp>) : Vector.<RegExp> {
			v.fixed = true;
			return v;
		}

		public static function getFixedString(v : Vector.<String>) : Vector.<String> {
			v.fixed = true;
			return v;
		}

		public static function getFixedSprite(v : Vector.<Sprite>) : Vector.<Sprite> {
			v.fixed = true;
			return v;
		}
	}
}
