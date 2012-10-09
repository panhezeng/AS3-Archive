package shell {
	import shell.controller.AddModuleCommand;
	import shell.controller.LoadModuleCommand;
	import shell.controller.RemoveModuleCommand;
	import shell.controller.SendMessageCommand;
	import shell.controller.StartupCommand;

	import org.puremvc.as3.multicore.patterns.facade.Facade;

	/**
	 * @author Panhezeng
	 */
	public class ShellAppFacade extends Facade {
		public static const STARTUP : String = "startup";
		/**
		 * 通知ShellJunction创建管道Pipe，一个管道Pipe对应有一个TeeMerge和一个TeeSplit，ShellAppJunctionMediator使用的消息常量
		 */
		public static const CONNECT_MODULE_TO_SHELL : String = "connectModuleToShell";
		/**
		 * 通知ShellJunction销毁管道Pipe，ShellAppJunctionMediator使用的消息常量
		 */
		public static const DISCONNECT_MODULE_FROM_SHELL : String = "disconnectModuleFromShell";
		/**
		 * 通知ModuleJunction创建管道Pipe，ModuleJunctionMediator使用的消息常量
		 */
		public static const CONNECT_MODULE_TO_MODULE : String = "connectModuleToModule";
		/**
		 * 通知ModuleJunction销毁管道Pipe，ModuleJunctionMediator使用的消息常量
		 */
		public static const DISCONNECT_MODULE_FROM_MODULE : String = "disconnectModuleFromModule";
		/**
		 * 通知加载模块 触发controller包的Command的消息常量
		 */
		public static const LOAD_MODULE : String = "loadModule";
		/**
		 * 通知添加模块 触发controller包的Command的消息常量
		 */
		public static const ADD_MODULE : String = "addModule";
		/**
		 * 通知移除模块 触发controller包的Command的消息常量
		 */
		public static const REMOVE_MODULE : String = "removeModule";
		/**
		 * ShellAppJunctionMediator和ShellAppMediator使用的消息常量
		 * Junction得到模块发送过来的消息数据后通知shell的Mediator处理
		 */
		public static const MODULE_MESSAGE : String = "moduleMessage";
		/**
		 * shell给modules推送数据的消息常量
		 */
		public static const SEND_MESSAGE : String = "sendMessage";
		/**
		 * shell初始自动加载模块的相对路径，对于交互触发才加载的模块建议放到类似导航菜单模块里，例如：MenuModule
		 */
		public static const MENU_MODULE_URI : String = "MenuModule.swf";

		public function ShellAppFacade(key : String) {
			super(key);
		}

		/**
		 * ApplicationFacade Factory Method
		 * @param key 此facade实例名
		 */
		public static function getInstance(key : String) : ShellAppFacade {
			if (instanceMap[key] == null) instanceMap[key] = new ShellAppFacade(key);
			return instanceMap[key] as ShellAppFacade;
		}

		/**
		 * Register Commands with the Controller
		 */
		override protected function initializeController() : void {
			super.initializeController();

			registerCommand(STARTUP, StartupCommand);
			registerCommand(LOAD_MODULE, LoadModuleCommand);
			registerCommand(ADD_MODULE, AddModuleCommand);
			registerCommand(REMOVE_MODULE, RemoveModuleCommand);
			registerCommand(SEND_MESSAGE, SendMessageCommand);
		}

		/**
		 * Application startup
		 * @param app a reference to the application component
		 */
		public function startup(app : ShellApp) : void {
			sendNotification(STARTUP, app);
		}
	}
}
