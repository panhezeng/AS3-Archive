package {
	import mvc.ApplicationFacade;
	import mvc.view.components.ModuleNameCompName;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * 主容器，对应有主Mediator
	 * 往主容器里添加子comp的方法写这里，可在主Mediator调用并传入comp
	 */
	public class ModuleName extends Sprite {
		public function ModuleName() {
			if (stage) _init();
			else addEventListener(Event.ADDED_TO_STAGE, _init);
		}

		private function _init(event : Event = null) : void {
			ApplicationFacade.getInstance().startup(this);
			_initComp();
		}

		private function _initComp() : void {
		}

		/**
		 * Set the moduleNameCompName display component.
		 */
		public function set moduleNameCompName(moduleNameCompName : ModuleNameCompName) : void {
			addChild(moduleNameCompName);
		}
	}
}