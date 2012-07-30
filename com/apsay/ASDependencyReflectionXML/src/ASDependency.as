package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;

	/**
	 * @author Panhezeng
	 */
	public class ASDependency extends Sprite {
		public function ASDependency() {
			MacButton;
			WindowsButton;
			var loader : URLLoader = new URLLoader();
			loader.load(new URLRequest("Config.xml"));
			loader.addEventListener(Event.COMPLETE, _loaderCompleteHandler);
		}

		private function _loaderCompleteHandler(event : Event) : void {
			var loader:URLLoader = event.currentTarget as URLLoader;
			var config : XML = new XML(loader.data);
			var btn : IButton = FactoryContainer.MakeButton(config);
			var txt : TextField = new TextField();
			txt.text = btn.showInfo();
			addChild(txt);
		}
	}
}
