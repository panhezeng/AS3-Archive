package {
	import com.raytoon.cannonfodder.puremvc.ApplicationFacade;
	import com.raytoon.cannonfodder.puremvc.view.ui.UIMain;
	import com.raytoon.cannonfodder.tools.net.ConstPath;
	import com.raytoon.cannonfodder.tools.utils.UIName;

	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.external.ExternalInterface;
	import flash.system.Security;

	// [SWF (backgroundColor = "0x8BBF40", width="756", height="600", frameRate="30")]
	[SWF (backgroundColor = "0xFFFFFF", width="756", height="600", frameRate="30")]
	public class CannonFodder extends Sprite {
		// private var appFacade : ApplicationFacade = ApplicationFacade.getInstance();
		// private var uiMain : UIMain = new UIMain();
		public static const NAME : String = "CannonFodder";

		public function CannonFodder() {
			try {
				var keyStr : String;
				var valueStr : String;
				var paramObj : Object = loaderInfo.parameters;
				for (keyStr in paramObj) {
					valueStr = String(paramObj[keyStr]);
					trace(keyStr);
					trace(valueStr);
				}
				if (valueStr) {
					var results : Array = valueStr.split(",");
					ConstPath.SESSION = String(results[0]);
					ConstPath.DATA_SERVER_URL = String(results[1]);
					ConstPath.DATA_SERVER_PORT = int(results[2]);
					ConstPath.MATERIAL_PATH = String(results[3]);
				}
			} catch (error : Error) {
				trace(error.toString());
			}
			loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, _uncaughtErrorHandler);
			UIMain.setInstance(NAME, this);
			// 优先加载服务器安全策略文件
			// var securityFileUrl : String = "http://test-paohui.raytoon.cn/crossdomain.xml";
			// Security.loadPolicyFile(securityFileUrl);
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			var uiMain : UIMain = new UIMain();
			addChild(uiMain);
			ApplicationFacade.getInstance().startup(uiMain);
		}

		private function _uncaughtErrorHandler(event : UncaughtErrorEvent) : void {
			var message : String;
			if (event.error is Error) {
				message = Error(event.error).message;
			} else if (event.error is ErrorEvent) {
				message = ErrorEvent(event.error).text;
			} else {
				message = event.error.toString();
			}
			trace(message);
			//if (ExternalInterface.available) ExternalInterface.call(UIName.JS_ERROR, 2);
			return;
		}
	}
}