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
package module.view {
	import common.HelloMessage;
	import common.PipeNames;

	import module.HelloModuleFacade;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.JunctionMediator;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.PipeListener;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeMerge;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeSplit;

	/**
	 * <code>JunctionMediator</code> object used to connect the module through pipes
	 * to the shell and other <code>HelloModule</code>.
	 */
	public class HelloModuleJunctionMediator
	extends JunctionMediator {
		public static const NAME : String = 'HelloModuleJunctionMediator';

		/**
		 * Constructor.
		 *
		 * <P>
		 * Creates and registers its own STDIN pipe and adds this instance as
		 * a listener, because any other instance to which it's connected uses
		 * a TeeMerge and new inputs are added to it rather than as separate
		 * pipes registered with the Junction.
		 * </P>
		 *
		 * <P>
		 * Also adds a filter to accept only null <code>toModuleColor</code>
		 * messages or messages with <code>toModuleColor</code> is the same
		 * as the color of the module.
		 * </P>
		 */
		public function HelloModuleJunctionMediator() {
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
		 *
		 * <P>
		 * The filter is used to filter messages by color to process only the
		 * messages which the module is recipient (based on toModuleColor).
		 * </P>
		 */
		override public function onRegister() : void {
			// We need the color of the current module to setup the color filter.
			var helloModuleMediator : HelloModuleMediator = facade.retrieveMediator(HelloModuleMediator.NAME) as HelloModuleMediator;
			var color : String = "#ff0000";

//			/*
//			 * Setup for the input pipe tee merge. All input pipes registered
//			 * with as PipeConstants.STDIN will be merged on it.
//			 */
//			var filter : Filter = new Filter(HelloModuleColorFilterMessage.COLOR_FILTER_NAME);
//			filter.setFilter(HelloModuleColorFilterMessage.filterMessageByColor as Function);
//			filter.setParams({color:color});
//			filter.connect(new PipeListener(this, handlePipeMessage));

			var teeMerge : TeeMerge = new TeeMerge();
			teeMerge.connect(new PipeListener(this, handlePipeMessage));
			junction.registerPipe(PipeNames.STDIN, Junction.INPUT, teeMerge);

			var teeSplit : TeeSplit = new TeeSplit();
			junction.registerPipe(PipeNames.HELLO_OUT_TO_HELLO, Junction.OUTPUT, teeSplit);
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
					if (type == PipeNames.STDIN) {
						pipe = note.getBody() as IPipeFitting;
						var teeMerge : TeeMerge = junction.retrievePipe(PipeNames.STDIN) as TeeMerge;
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
					if (type == PipeNames.HELLO_OUT_TO_HELLO) {
						pipe = note.getBody() as IPipeFitting;
						var teeSplit : TeeSplit = junction.retrievePipe(PipeNames.HELLO_OUT_TO_HELLO) as TeeSplit;
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
			if ( message is HelloMessage && HelloMessage(message).senderID != this.multitonKey )
				sendNotification(HelloModuleFacade.STORE_MESSAGE, message);
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
		 * Disconnect all the pipes used by the JunctionMediator.
		 */
		public function tearDown() : void {
			var teeSplit : TeeSplit = junction.retrievePipe(PipeNames.HELLO_OUT_TO_HELLO) as TeeSplit;
			while ( teeSplit.disconnect() ) {
				junction.removePipe(PipeNames.HELLO_OUT_TO_HELLO);
			}

			var teeMerge : TeeMerge = junction.retrievePipe(PipeNames.STDIN) as TeeMerge;
			while ( teeMerge.disconnect() ) {
				junction.removePipe(PipeNames.STDIN);
			}
		}
	}
}