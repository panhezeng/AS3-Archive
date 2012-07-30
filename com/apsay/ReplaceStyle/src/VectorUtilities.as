package {
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
	}
}
