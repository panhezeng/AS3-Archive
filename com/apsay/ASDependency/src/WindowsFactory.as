package {
	/**
	 * @author Panhezeng
	 */
	public class WindowsFactory implements IFactory {
		public function makeButton() : IButton {
			return new WindowsButton();
		}
	}
}
