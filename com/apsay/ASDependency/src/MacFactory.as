package {
	/**
	 * @author Panhezeng
	 */
	public class MacFactory implements IFactory {
		public function makeButton() : IButton {
			return new MacButton();
		}
	}
}
