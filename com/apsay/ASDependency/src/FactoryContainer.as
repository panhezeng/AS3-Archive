package {
	/**
	 * @author Panhezeng
	 */
	public class FactoryContainer {
		public static function getFactory(config : XML) : IFactory {
			var _factory : IFactory;
			var node : String = String(config.factory[0]);
			if ("Windows" == node) {
				_factory = new WindowsFactory();
			} else if ("Mac" == node) {
				_factory = new MacFactory();
			} else {
				throw new Error("Factory Init Error");
			}
			return _factory;
		}
	}
}
