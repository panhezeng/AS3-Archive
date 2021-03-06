package mvc {
	import org.puremvc.as3.interfaces.IFacade;
	import mvc.controller.VOCommand;
	import mvc.model.VOProxy;
	import mvc.controller.StartupCommand;

	import org.puremvc.as3.patterns.facade.Facade;

	/**
	 * 初始和所有Command,Mediator,Proxy的通知常量都写这，或者Proxy发给Mediator的通知常量写Proxy里。
	 * 注册所需Command
	 * 方法：startup(发出通知执行初始Command，并传入主容器)
	 */
	public class AppFacade extends Facade implements IFacade {
		// Notification name constants
		// command application
		public static const STARTUP : String = "startUp";
		// command model
		public static const VO_UPDATE : String = "voUpdate";
		public static const VO_GET : String = "voGet";
		public static const VO_READY : String = "voReady";
		// command view
		// view
		public static const COMP_SHOW : String = "compShow";
		public static const COMP_HIDE : String = "compHide";
		public static const COMP_UPDATE : String = "compUpdate";

		public static function getInstance() : AppFacade {
			if (instance == null) instance = new AppFacade();
			return instance as AppFacade;
		}

		override protected function initializeController() : void {
			super.initializeController();
			registerCommand(STARTUP, StartupCommand);
			registerCommand(VO_GET, VOCommand);
		}

		public function startup(app : App) : void {
			sendNotification(STARTUP, app);
		}
	}
}