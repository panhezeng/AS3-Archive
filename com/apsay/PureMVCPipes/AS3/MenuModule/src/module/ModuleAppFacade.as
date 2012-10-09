package module {
	import module.controller.SendMessageCommand;
	import module.controller.StartupCommand;
	import module.controller.TearDownCommand;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeAware;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.JunctionMediator;


	/**
	 * @author Panhezeng
	 */
	public class ModuleAppFacade extends Facade implements IPipeAware {
		public static const STARTUP : String = "startup";
		public static const TEARDOWN : String = "teardown";
		public static const SEND_MESSAGE : String = "sendMessage";

		public function ModuleAppFacade(key : String) {
			super(key);
		}

		/**
		 * ApplicationFacade Factory Method
		 */
		public static function getInstance(key : String) : ModuleAppFacade {
			if (instanceMap[key] == null) instanceMap[key] = new ModuleAppFacade(key);
			return instanceMap[key] as ModuleAppFacade;
		}

		/**
		 * Register Commands with the Controller
		 */
		override protected function initializeController() : void {
			super.initializeController();

			registerCommand(STARTUP, StartupCommand);
			registerCommand(TEARDOWN, TearDownCommand);
			registerCommand(SEND_MESSAGE, SendMessageCommand);
		}

		/**
		 * Application startup
		 *
		 * @param app a reference to the application component
		 */
		public function startup(app : MenuModule) : void {
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
