package mvc.view.components {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.System;

	/**
	 * @author Panhezeng
	 */
	public class ContentView extends Sprite {
		public static const LOAD_MODULE : String = "LoadModule";
		public static const BTN_LOAD : String = "loadSWF";
		public static const BTN_GC : String = "gc";
		public static const BTN_CLOSE : String = "close";
		public var module : Sprite;

		public function ContentView() {
		}

		public function main() : void {
			initializeView();
			initializeBehaviour();
		}

		private function initializeView() : void {
			addChild(new MainBTN());
			module = addChild(new Sprite()) as Sprite;
		}

		private function initializeBehaviour() : void {
			addEventListener(MouseEvent.CLICK, _mouseEvent);
		}

		private function _mouseEvent(event : Event) : void {
			switch(event.target.name) {
				case BTN_CLOSE:
					if (module.numChildren != 0) module.removeChildAt(module.numChildren - 1);
					break;
				case BTN_LOAD:
					dispatchEvent(new Event(ContentView.LOAD_MODULE));
					break;
				case BTN_GC:
					System.gc();
					break;
			}
		}

		public function addTreeModule(m : Sprite) : void {
			module.addChild(m);
		}
	}
}
