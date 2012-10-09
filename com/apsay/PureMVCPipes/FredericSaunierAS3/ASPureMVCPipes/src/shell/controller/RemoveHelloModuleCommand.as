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
package shell.controller {
	import shell.AppShellFacade;
	import shell.view.AppShellMediator;
	import shell.view.ModuleMediator;

	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * The new module is unreferrenced from its PureMVC core and removed
	 * from the display list.
	 * 
	 * <P>
	 * When no more instance of the module are displayed in the shell the
	 * module file is unloaded from memory.
	 * </P>
	 */
    public class RemoveHelloModuleCommand
    	extends SimpleCommand
    	implements ICommand
    {
        override public function execute(note:INotification):void
        {
			var helloModuleID:String = note.getBody() as String;
			
			/*
			* Each *HelloModuleJunctionMediator* object handle this
			* notification. So each loaded HelloModule will disconnect input
			* and output pipes from the module actually removed.
			*/
			sendNotification( AppShellFacade.DISCONNECT_HELLO_MODULE_FROM_HELLO_MODULE, helloModuleID );
			
			/*
			* Disconnect input and output pipes between the shell and the module.
			*/
			sendNotification( AppShellFacade.DISCONNECT_MODULE_FROM_SHELL, helloModuleID );

			var moduleMediator:ModuleMediator = facade.retrieveMediator( helloModuleID ) as ModuleMediator;
			moduleMediator.tearDown();
			facade.removeMediator( helloModuleID );
			
			   
			//Remove the HelloModule view instance from the shell display list.
			var shellMediator:AppShellMediator = facade.retrieveMediator( AppShellMediator.NAME ) as AppShellMediator;
			shellMediator.removeHelloModule( helloModuleID );
			
		}
    }
}