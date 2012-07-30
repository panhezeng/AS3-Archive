package {
	import flash.text.TextField;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * @author Panhezeng
	 */
	public class ASDependency extends Sprite {
		public function ASDependency() {
			var request : URLRequest = new URLRequest("Config.xml");
			var loader : URLLoader = new URLLoader();
			try {
				loader.load(request);
			} catch (error : SecurityError) {
				trace("A SecurityError has occurred.");
			}
			loader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
		}

		private function loaderCompleteHandler(event : Event) : void {
			var config : XML;
			try {
				config = new XML(event.currentTarget.data);
				var btn : IButton = FactoryContainer.getFactory(config).makeButton();
				var txt : TextField = new TextField();
				txt.text = btn.showInfo();
				addChild(txt);
			} catch (e : TypeError) {
				trace("Could not parse the XML file.");
			}
		}

		private function errorHandler(event : IOErrorEvent) : void {
			trace("Had problem loading the XML File.");
		}
	}
}
