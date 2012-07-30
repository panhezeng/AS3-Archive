package {
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;

	/**
	 * @author Panhezeng
	 */
	public class ASDependency extends Sprite {
		private var _txt : TextField;

		public function ASDependency() {
			_txt = new TextField();
			addChild(_txt);
			var loader : Loader = new Loader();
			loader.load(new URLRequest("Config.swf"), new LoaderContext(false, ApplicationDomain.currentDomain));
			loader.contentLoaderInfo.addEventListener(Event.INIT, _initHandler);
		}

		private function _initHandler(event : Event) : void {
			(event.currentTarget as LoaderInfo).loader.unload();
			stage.addEventListener(MouseEvent.CLICK, _clickHandler);
		}

		private function _clickHandler(event : MouseEvent) : void {
			var btn : IButton = FactoryContainer.MakeButton();
			_txt.text = btn.showInfo();
		}
	}
}
