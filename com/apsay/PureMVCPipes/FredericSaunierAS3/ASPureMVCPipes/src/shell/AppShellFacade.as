/*
 PureMVC AS3 MultiCore Pipes Demo – Flash Modules and Pipes Demo
 Copyright (c) 2009 Frederic Saunier <frederic.saunier@puremvc.org>

 Parts originally from:

 PureMVC AS3 MultiCore Demo – Flex PipeWorks
 Copyright (c) 2008 Cliff Hall <cliff.hall@puremvc.org>

 PureMVC AS3 Demo – AIR RSS Headlines
 Copyright (c) 2007-08 Simon Bailey <simon.bailey@puremvc.org>

 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package shell {
	import shell.controller.AddHelloModuleCommand;
	import shell.controller.LoadModuleCommand;
	import shell.controller.RemoveHelloModuleCommand;
	import shell.controller.StartupCommand;

	import org.puremvc.as3.multicore.patterns.facade.Facade;

	/**
	 * Concrete Facade for the Main App / Shell.
	 */
	public class AppShellFacade
	extends Facade {
		public static const STARTUP : String = 'startup';
		public static const CONNECT_MODULE_TO_SHELL : String = 'connectModuleToShell';
		public static const CONNECT_HELLO_MODULE_TO_HELLO_MODULE : String = 'connectHelloModuleToHelloModule';
		public static const DISCONNECT_HELLO_MODULE_FROM_HELLO_MODULE : String = 'disconnectHelloModuleFromHelloModule';
		public static const DISCONNECT_MODULE_FROM_SHELL : String = 'disconnectHelloModuleFromShell';
		public static const CONNECT_SHELL_TO_HELLO_MODULE : String = 'connectShellToHelloModule';
		public static const LOAD_MODULE : String = 'loadModule';
		public static const UNLOAD_MODULE : String = 'unloadModule';
		public static const MODULE_LOADED : String = 'moduleLoaded';
		public static const MODULE_UNLOADED : String = 'moduleUnLoaded';
		public static const ADD_HELLO_MODULE : String = 'addHelloModule';
		public static const REMOVE_HELLO_MODULE : String = 'removeHelloModule';
		public static const SEND_MESSAGE_TO_ALL_HELLO_MODULES : String = 'sendMessageToAllHelloModules';
		public static const ADD_HELLO_MESSAGE : String = 'addHelloMessage';
		/* The output folder of the module cannot be changed in the Flex
		 * configuration window, so it is quite long. It's a Flex Builder
		 * bug, please vote : https://bugs.adobe.com/jira/browse/FB-11823
		 */
		public static const HELLO_MODULE_URI : String = "HelloModule.swf";

		/**
		 * Constructor.
		 */
		public function AppShellFacade(key : String) {
			super(key);
		}

		/**
		 * ApplicationFacade Factory Method.
		 */
		public static function getInstance(key : String) : AppShellFacade {
			if ( instanceMap[ key ] == null ) instanceMap[ key ] = new AppShellFacade(key);
			return instanceMap[ key ] as AppShellFacade;
		}

		/**
		 * Register Commands with the Controller.
		 */
		override protected function initializeController() : void {
			super.initializeController();

			registerCommand(STARTUP, StartupCommand);
			registerCommand(LOAD_MODULE, LoadModuleCommand);
			registerCommand(ADD_HELLO_MODULE, AddHelloModuleCommand);
			registerCommand(REMOVE_HELLO_MODULE, RemoveHelloModuleCommand);
		}

		/**
		 * Application startup
		 *
		 * @param app
		 * 		A reference to the application component
		 */
		public function startup(app : AppShell) : void {
			sendNotification(STARTUP, app);
		}
	}
}