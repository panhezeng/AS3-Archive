package shell.view {
	import common.PipeNames;
	import flash.utils.Dictionary;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeAware;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.JunctionMediator;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Pipe;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeMerge;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeSplit;
	import shell.ShellAppFacade;




	/**
	 * @author Panhezeng
	 */
	public class ModuleJunctionMediator extends JunctionMediator {
		public static const NAME : String = "ModuleJunctionMediator";
		private var outMap : Dictionary;

		public function ModuleJunctionMediator() {
			super(NAME, new Junction());
			outMap = new Dictionary();
		}

		/**
		 * Called when the Mediator is registered.
		 * 
		 * <P>
		 * Registers a Merging Tee for HELLO_OUT_TO_HELLO, 
		 * and sets this as the Pipe Listener.
		 * </P>
		 */
		override public function onRegister() : void {
			// The STDIN pipe from the shell to all modules
			junction.registerPipe(PipeNames.STD_IN, Junction.OUTPUT, new TeeSplit());

			// The HELLO_OUT_TO_HELLO pipe to the shell from all modules
			junction.registerPipe(PipeNames.MODULE_TO_SIBLING, Junction.INPUT, new TeeMerge());
			junction.addPipeListener(PipeNames.MODULE_TO_SIBLING, this, handlePipeMessage);
		}

		/**
		 * ShellJunction related Notification list.
		 * <P>Adds subclass interests to JunctionMediator interests.</P>
		 */
		override public function listNotificationInterests() : Array {
			return [ShellAppFacade.CONNECT_MODULE_TO_MODULE, ShellAppFacade.DISCONNECT_MODULE_FROM_MODULE];
		}

		/**
		 * Handle HelloModuleJunction related Notifications.
		 */
		override public function handleNotification(note : INotification) : void {
			var moduleName : String = note.getBody() as String;
			var moduleFacade : IPipeAware = Facade.getInstance(moduleName) as IPipeAware;
			var junctionOut : TeeSplit;

			switch( note.getName() ) {
				case ShellAppFacade.CONNECT_MODULE_TO_MODULE:
					// Create the pipe
					var moduleToShellJunction : Pipe = new Pipe();
					moduleFacade.acceptOutputPipe(PipeNames.MODULE_TO_SIBLING, moduleToShellJunction);
					// Connect the pipe to the Shell MODULE_IN_TO_MODULE_OUT TeeMerge
					var junctionIn : TeeMerge = junction.retrievePipe(PipeNames.MODULE_TO_SIBLING) as TeeMerge;
					junctionIn.connectInput(moduleToShellJunction);
					// Create the pipe
					var shellToModuleJunction : Pipe = new Pipe();
					// Connect the pipe to our module facade.
					moduleFacade.acceptInputPipe(PipeNames.STD_IN, shellToModuleJunction);
					// Connect Shell MODULE_OUT_TO_OTHER TeeSplit to the pipe.
					junctionOut = junction.retrievePipe(PipeNames.STD_IN) as TeeSplit;
					junctionOut.connect(shellToModuleJunction);
					// Add the newly created junction to the map.
					outMap[moduleName] = shellToModuleJunction;
					break;
				case ShellAppFacade.DISCONNECT_MODULE_FROM_MODULE:
					/*
					 * We only need to disconnect the <code>shellToModule</code>
					 * pipe as the only reference to this pipe is owned by the
					 * module we remove, it will be garbaged with it.
					 */
					junctionOut = junction.retrievePipe(PipeNames.STD_IN) as TeeSplit;
					junctionOut.disconnectFitting(outMap[moduleName]);
					delete outMap[moduleName];
					break;
			}
		}

		/**
		 * The only important thing this Junction does is to redirect any
		 * message from an HelloModule out to all HelloModule in pipes.
		 */
		override public function handlePipeMessage(message : IPipeMessage) : void {
			// Sends the message on the output pipeline
			var junctionOut : TeeSplit = junction.retrievePipe(PipeNames.STD_IN) as TeeSplit;
			junctionOut.write(message);
		}
	}
}
