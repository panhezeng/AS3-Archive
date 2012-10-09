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
package module {
	import module.controller.SendMessageToHelloModuleCommand;
	import module.controller.SendMessageToShellCommand;
	import module.controller.SendRemoveSignalToShellCommand;
	import module.controller.StartupCommand;
	import module.controller.StoreMessageCommand;
	import module.controller.TearDownCommand;

	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeAware;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.JunctionMediator;


	/**
	 * Application Facade for Prattler Module.
	 */
	public class HelloModuleFacade
	extends Facade
	implements IPipeAware {
		/**
		 * Notification name constants
		 */
		public static const STARTUP : String = "startup";
		public static const TEARDOWN : String = "teardown";
		public static const SEND_REMOVE_SIGNAL_TO_SHELL : String = "sendRemoveSignalToShell";
		public static const STORE_MESSAGE : String = "storeMessage";
		public static const SEND_MESSAGE_TO_SHELL : String = "sendMessageToShell";
		public static const SEND_MESSAGE_TO_HELLO_MODULE : String = "sendMessageToHelloModule";

		public function HelloModuleFacade(key : String) {
			super(key);
		}

		/**
		 * ApplicationFacade Factory Method
		 */
		public static function getInstance(key : String) : HelloModuleFacade {
			if ( instanceMap[ key ] == null )
				instanceMap[ key ] = new HelloModuleFacade(key);

			return instanceMap[ key ] as HelloModuleFacade;
		}

		/**
		 * Register Commands with the Controller
		 */
		override protected function initializeController() : void {
			super.initializeController();

			registerCommand(STARTUP, StartupCommand);
			registerCommand(TEARDOWN, TearDownCommand);
			registerCommand(SEND_REMOVE_SIGNAL_TO_SHELL, SendRemoveSignalToShellCommand);
			registerCommand(STORE_MESSAGE, StoreMessageCommand);
			registerCommand(SEND_MESSAGE_TO_SHELL, SendMessageToShellCommand);
			registerCommand(SEND_MESSAGE_TO_HELLO_MODULE, SendMessageToHelloModuleCommand);
		}

		/**
		 * Application startup
		 *
		 * @param app a reference to the application component
		 */
		public function startup(app : HelloModule) : void {
			sendNotification(STARTUP, app);
		}

		/**
		 * Accept an input pipe.
		 * <P>
		 * Registers an input pipe with this module's Junction.
		 */
		public function acceptInputPipe(name : String, pipe : IPipeFitting) : void {
			sendNotification(JunctionMediator.ACCEPT_INPUT_PIPE, pipe, name);
		}

		/**
		 * Accept an output pipe.
		 * <P>
		 * Registers an input pipe with this module's Junction.
		 */
		public function acceptOutputPipe(name : String, pipe : IPipeFitting) : void {
			sendNotification(JunctionMediator.ACCEPT_OUTPUT_PIPE, pipe, name);
		}
	}
}