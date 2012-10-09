package module.view {
	import common.ModuleMessage;
	import common.PipeNames;

	import module.ModuleAppFacade;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.JunctionMediator;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.PipeListener;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeMerge;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeSplit;

	/**
	 * @author Panhezeng
	 */
	public class ModuleAppJunctionMediator extends JunctionMediator {
		public static const NAME : String = "ModuleAppJunctionMediator";

		public function ModuleAppJunctionMediator() {
			super(NAME, new Junction());
		}

		/**
		 * Called when Mediator is registered.
		 *
		 * <P>
		 * Registers a short pipeline consisting of a Merging Tee connected to
		 * a Filter for STDIN, setting the HelloModuleJunctionMediator as the
		 * Pipe Listener.
		 * </P>
		 */
		override public function onRegister() : void {
			/*
			 * Setup for the input pipe tee merge. All input pipes registered
			 * with as PipeConstants.STDIN will be merged on it.
			 */

			var teeMerge : TeeMerge = new TeeMerge();
			teeMerge.connect(new PipeListener(this, handlePipeMessage));
			junction.registerPipe(PipeNames.STD_IN, Junction.INPUT, teeMerge);

			var teeSplit : TeeSplit = new TeeSplit();
			junction.registerPipe(PipeNames.MODULE_TO_SIBLING, Junction.OUTPUT, teeSplit);
		}

		/**
		 * Send a message on an OUTPUT pipe through the junction owned by this
		 * <code>JunctionMediator</code> object. We need it to expose the
		 * <code>Junction.sendMessage()</code> method to commands.
		 */
		public function sendMessage(outputPipeName : String, message : IPipeMessage) : Boolean {
			return junction.sendMessage(outputPipeName, message);
		}

		/**
		 * Handle Junction related Notifications for the HelloModule.
		 */
		override public function handleNotification(note : INotification) : void {
			var pipe : IPipeFitting;
			var type : String = type = note.getType();

			switch( note.getName() ) {
				/*
				 * When an ACCEPT_INPUT_PIPE notification is received by the
				 * module it checks that the pipe type need a merge and then
				 * create a tee merge between it and the existing module's
				 * pipe.
				 */
				case JunctionMediator.ACCEPT_INPUT_PIPE: {
					/*
					 * Create a tee merge between accepted pipe and the
					 * existing module's STDIN pipe.
					 */
					if (type == PipeNames.STD_IN) {
						pipe = note.getBody() as IPipeFitting;
						var teeMerge : TeeMerge = junction.retrievePipe(PipeNames.STD_IN) as TeeMerge;
						teeMerge.connectInput(pipe);

						// It does not need to be handled by super.
						return;
					}

					break;
				}
				/*
				 * Add an input pipe (special output handling for each new
				 * connected HelloModule).
				 */
				case JunctionMediator.ACCEPT_OUTPUT_PIPE: {
					/*
					 * Output splitting tee for HELLO_TO_HELLO pipes. We need
					 * to override super to handle this.
					 */
					if (type == PipeNames.MODULE_TO_SIBLING) {
						pipe = note.getBody() as IPipeFitting;
						var teeSplit : TeeSplit = junction.retrievePipe(PipeNames.MODULE_TO_SIBLING) as TeeSplit;
						teeSplit.connect(pipe);

						// It does not need to be handled by super.
						return;
					}

					break;
				}
			}

			/*
			 * Use super for any notifications that do not need special
			 * consideration.
			 */
			super.handleNotification(note);
		}

		/**
		 * Handle incoming pipe messages.
		 */
		override public function handlePipeMessage(message : IPipeMessage) : void {
			/*
			 * Only HelloModuleMessage object and messages not received from
			 * the module itself are added to module's list of messages.
			 */
			if ( message is ModuleMessage && ModuleMessage(message).getHeader() != this.multitonKey ) {
				sendNotification(ModuleAppFacade.STORE_MESSAGE, message);
			}
		}

		/**
		 * Disconnect all the pipes used by the JunctionMediator.
		 */
		public function tearDown() : void {
			var teeSplit : TeeSplit = junction.retrievePipe(PipeNames.MODULE_TO_SIBLING) as TeeSplit;
			while (teeSplit.disconnect()) {
				junction.removePipe(PipeNames.MODULE_TO_SIBLING);
			}

			var teeMerge : TeeMerge = junction.retrievePipe(PipeNames.STD_IN) as TeeMerge;
			while (teeMerge.disconnect()) {
				junction.removePipe(PipeNames.STD_IN);
			}
		}
	}
}
