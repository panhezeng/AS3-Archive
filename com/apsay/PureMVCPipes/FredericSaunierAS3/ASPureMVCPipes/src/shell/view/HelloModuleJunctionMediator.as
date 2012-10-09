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
package shell.view
{
	import flash.utils.Dictionary;
	
	import common.PipeNames;
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
	
	/**
	 * An HelloModuleJunctionMediator instance will own an unique pipe Junction
	 * responsible for connecting HelloModule among themselves.
	 * 
	 * <P>
	 * Reason for that is if we want to let <code>HelloModule</code>s
	 * communicate among themselves the only other solution is to register
	 * each newly created HelloModule input and output pipes with all existing
	 * <code>HelloModule</code>s. It simplify the process and preserve some
	 * memory. Consider it as something not standard regarding PureMVC pipes.
	 * </P>
	 */
	public class HelloModuleJunctionMediator
		extends JunctionMediator
	{
		public static const NAME:String = 'HelloModuleJunctionMediator';
		private var outMap:Dictionary = new Dictionary(true);

		public function HelloModuleJunctionMediator( )
		{
			super( NAME, new Junction() );
		}

		/**
		 * Called when the Mediator is registered.
		 * 
		 * <P>
		 * Registers a Merging Tee for HELLO_OUT_TO_HELLO, 
		 * and sets this as the Pipe Listener.
		 * </P>
		 */
		override public function onRegister():void
		{			
			// The STDIN pipe from the shell to all modules 
			junction.registerPipe( PipeNames.STDIN,  Junction.OUTPUT, new TeeSplit() );
			
			// The HELLO_OUT_TO_HELLO pipe to the shell from all modules 
			junction.registerPipe( PipeNames.HELLO_OUT_TO_HELLO,  Junction.INPUT, new TeeMerge() );
			junction.addPipeListener( PipeNames.HELLO_OUT_TO_HELLO, this, handlePipeMessage );
		}
		
		/**
		 * ShellJunction related Notification list.
		 * <P>Adds subclass interests to JunctionMediator interests.</P>
		 */
		override public function listNotificationInterests():Array
		{
			return [
				AppShellFacade.CONNECT_HELLO_MODULE_TO_HELLO_MODULE,
				AppShellFacade.DISCONNECT_HELLO_MODULE_FROM_HELLO_MODULE
			];
		}

		/**
		 * Handle HelloModuleJunction related Notifications.
		 */
		override public function handleNotification( note:INotification ):void
		{
			var moduleID:String = note.getBody() as String;;
			var moduleFacade:IPipeAware = Facade.getInstance( moduleID ) as IPipeAware;
			var junctionOut:TeeSplit;

			switch( note.getName() )
			{
				case AppShellFacade.CONNECT_HELLO_MODULE_TO_HELLO_MODULE:

					// Create the pipe
					var moduleToShellJunction:Pipe = new Pipe();
					moduleFacade.acceptOutputPipe(PipeNames.HELLO_OUT_TO_HELLO, moduleToShellJunction);
					
					// Connect the pipe to the Shell HELLO_IN_TO_HELLO_OUT TeeMerge
					var junctionIn:TeeMerge = junction.retrievePipe( PipeNames.HELLO_OUT_TO_HELLO ) as TeeMerge;
					junctionIn.connectInput( moduleToShellJunction );
					
					// Create the pipe
					var shellToModuleJunction:Pipe = new Pipe();
					
					
					// Connect the pipe to our module facade.
					moduleFacade.acceptInputPipe( PipeNames.STDIN, shellToModuleJunction );
					
					// Connect Shell HELLO_OUT_TO_HELLO_IN TeeSplit to the pipe.
					junctionOut = junction.retrievePipe( PipeNames.STDIN ) as TeeSplit;
					junctionOut.connect( shellToModuleJunction );
					
					//Add the newly created junction to the map. 
					outMap[moduleID] = shellToModuleJunction;

				break;
				
				case AppShellFacade.DISCONNECT_HELLO_MODULE_FROM_HELLO_MODULE:
					
					/*
					* We only need to disconnect the <code>shellToModule</code>
					* pipe as the only reference to this pipe is owned by the
					* module we remove, it will be garbaged with it.
					*/
					junctionOut = junction.retrievePipe( PipeNames.STDIN ) as TeeSplit;
					junctionOut.disconnectFitting( outMap[moduleID] );
					delete outMap[moduleID];

				break;
			}
		}
		
		/**
		 * The only important thing this Junction does is to redirect any
		 * message from an HelloModule out to all HelloModule in pipes.
		 */
		override public function handlePipeMessage( message:IPipeMessage ):void
		{
			// Sends the message on the output pipeline
			var junctionOut:TeeSplit = junction.retrievePipe( PipeNames.STDIN ) as TeeSplit;
			junctionOut.write( message );
		}
	}
}