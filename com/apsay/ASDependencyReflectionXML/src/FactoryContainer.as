package {
	import flash.utils.getDefinitionByName;

	/**
	 * @author Panhezeng
	 */
	public class FactoryContainer {
		public static function MakeButton(config : XML) : IButton {
			var node : String = String(config.factory.button[0]);
			var ClassReference : Class = getDefinitionByName(node) as Class;
			var instance : IButton = new ClassReference();
			return instance;
		}
	}
}
