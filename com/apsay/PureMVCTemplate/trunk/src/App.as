package {
	import mvc.AppFacade;
	import mvc.view.components.Comp;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * Application主容器，对应有Application主Mediator
	 * 往主容器里添加子comp的方法写这里，可在主Mediator调用并传入comp
	 */
	public class App extends Sprite {
		public function App() {
			if (stage) _init();
			else addEventListener(Event.ADDED_TO_STAGE, _init);
		}

		private function _init(event : Event = null) : void {
			if (event) removeEventListener(Event.ADDED_TO_STAGE, _init);
			AppFacade.getInstance().startup(this);
			_initComp();
		}

		private function _initComp() : void {
		}

		/**
		 * Set the moduleNameCompName display component.
		 */
		public function set comp(comp : Comp) : void {
			addChild(comp);
		}
	}
}