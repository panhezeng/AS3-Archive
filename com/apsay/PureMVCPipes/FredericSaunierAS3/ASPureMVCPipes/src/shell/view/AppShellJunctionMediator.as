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
package shell.view {
	import common.HelloMessage;
	import common.PipeNames;
	import common.SetupInfoMessage;

	import shell.AppShellFacade;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeAware;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.JunctionMediator;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Pipe;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeMerge;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeSplit;

	public class AppShellJunctionMediator
	extends JunctionMediator {
		public static const NAME : String = 'ShellJunctionMediator';
		private var outMap : Object = {};

		public function AppShellJunctionMediator() {
			super(NAME, new Junction());
		}

		/**
		 * Called when the Mediator is registered.
		 * 
		 * <P>
		 * Registers a Merging Tee for STDIN, 
		 * and sets this as the Pipe Listener.
		 * </P>
		 * 
		 * <P>
		 * Registers a Pipe for STDLOG and 
		 * connects it to LoggerModule.
		 * </P>
		 */
		override public function onRegister() : void {
			// The STDOUT pipe from the shell to all modules
			junction.registerPipe(PipeNames.STDOUT, Junction.OUTPUT, new TeeSplit());

			// The STDIN pipe to the shell from all modules
			junction.registerPipe(PipeNames.STDIN, Junction.INPUT, new TeeMerge());

			junction.addPipeListener(PipeNames.STDIN, this, handlePipeMessage);
		}

		/**
		 * ShellJunction related Notification list.
		 * <P>
		 * Adds subclass interests to JunctionMediator interests.</P>
		 */
		override public function listNotificationInterests() : Array {
			var interests : Array = super.listNotificationInterests();
			interests.push(AppShellFacade.CONNECT_MODULE_TO_SHELL);
			interests.push(AppShellFacade.DISCONNECT_MODULE_FROM_SHELL);
			interests.push(AppShellFacade.SEND_MESSAGE_TO_ALL_HELLO_MODULES);

			return interests;
		}

		/**
		 * Handle ShellJunction related Notifications.
		 */
		override public function handleNotification(note : INotification) : void {
			var moduleID : String;
			var moduleFacade : IPipeAware;
			var shellOut : TeeSplit;

			switch( note.getName() ) {
				case AppShellFacade.SEND_MESSAGE_TO_ALL_HELLO_MODULES:
					/*
					 * The shell is not an HelloModule. We could not provide any
					 * valid fromModuleColor argument. We let it null.
					 *
					 * As the message is sent to all module we also do not provide
					 * any toModuleColor argument.
					 */
					var helloModuleMessage : HelloMessage = new HelloMessage(null, null, "shell", "hello all!");
					// Le type du HelloModuleMessage est laissé à nul pour que tous les type de HelloModule le reçoivent.
					junction.sendMessage(PipeNames.STDOUT, helloModuleMessage);
					break;
				case AppShellFacade.CONNECT_MODULE_TO_SHELL:
					// Connect a module's ANY_MODULE_TO_SHELL to the shell's STDIN
					moduleID = note.getBody() as String;
					moduleFacade = Facade.getInstance(moduleID) as IPipeAware;
					// Create the pipe
					var moduleToShell : Pipe = new Pipe();
					moduleFacade.acceptOutputPipe(PipeNames.ANY_MODULE_TO_SHELL, moduleToShell);
					// Connect the pipe to the Shell STDIN TeeMerge
					var shellIn : TeeMerge = junction.retrievePipe(PipeNames.STDIN) as TeeMerge;
					shellIn.connectInput(moduleToShell);
					// Create the pipe
					var shellToModule : Pipe = new Pipe();
					// Connect the pipe to our module facade.
					moduleFacade.acceptInputPipe(PipeNames.STDIN, shellToModule);
					// Connect Shell STDOUT TeeSplit to the pipe.
					shellOut = junction.retrievePipe(PipeNames.STDOUT) as TeeSplit;
					shellOut.connect(shellToModule);
					outMap[ moduleID ] = shellToModule;
					break;
				case AppShellFacade.DISCONNECT_MODULE_FROM_SHELL:
					moduleID = note.getBody() as String;
					moduleFacade = Facade.getInstance(moduleID) as IPipeAware;
					/*
					 * We only need to disconnect the <code>shellToModule</code>
					 * pipe as the only reference to this pipe is owned by the
					 * module we remove, it will be garbaged with it.
					 */
					shellOut = junction.retrievePipe(PipeNames.STDOUT) as TeeSplit;
					shellOut.disconnectFitting(outMap[ moduleID ]);
					delete outMap[ moduleID ];
					break;
				// And let super handle the rest (ACCEPT_OUTPUT_PIPE, ACCEPT_INPUT_PIPE, SEND_TO_LOG)								
				default:
					super.handleNotification(note);
			}
		}

		/**
		 * Handle incoming pipe messages for the ShellJunction.
		 * 
		 * <P>
		 * Note that we are handling PipeMessages with the same idiom
		 * as Notifications. Conceptually they are the same, and the
		 * Mediator role doesn't change much. It takes these messages
		 * and turns them into notifications to be handled by other 
		 * actors in the main app / shell.
		 * </P> 
		 * 
		 * <P>
		 * Also, it is logging its actions by sending INFO messages
		 * to the STDLOG output pipe.
		 * </P> 
		 */
		override public function handlePipeMessage(message : IPipeMessage) : void {
			if ( message is HelloMessage ) {
				sendNotification(AppShellFacade.ADD_HELLO_MESSAGE, message);
			} else if ( message is SetupInfoMessage ) {
				/*
				 * We abusively consider here that any SetupInfoMessage received
				 * came from an HelloModule and that it only asks to remove the
				 * module. If you have more than one module type in your
				 * implementation, be smart enough not to do that.
				 */
				sendNotification(AppShellFacade.REMOVE_HELLO_MODULE, SetupInfoMessage(message).key);
			}
		}
	}
}