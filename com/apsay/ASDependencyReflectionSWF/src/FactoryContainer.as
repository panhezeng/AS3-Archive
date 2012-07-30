package {
	import flash.utils.getDefinitionByName;

	/**
	 * @author Panhezeng
	 */
	public class FactoryContainer {
		public static var Config : String = "Config";

		public static function MakeButton() : IButton {
			var ClassReference : Class = getDefinitionByName((getDefinitionByName(Config) as Class).BTN) as Class;
			var instance : IButton = new ClassReference();
			return instance;
		}
	}
}
