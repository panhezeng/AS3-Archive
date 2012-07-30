package {
	/**
	 * @author Panhezeng
	 */
	public class WindowsButton implements IButton {
		private var description : String;

		public function WindowsButton() {
			description = "Windows风格按钮";
		}

		public function showInfo() : String {
			return description;
		}
	}
}
