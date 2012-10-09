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
	import flash.display.DisplayObject;

	import common.IModule;

	import shell.AppShellFacade;
	import shell.view.ModuleMediator;
	import shell.view.ModuleLoaderMediator;
	import shell.view.AppShellMediator;

	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * The new module is instantiated, and connected via pipes to the 
	 * logger and the shell. Finally a Mediator is registered for it.
	 */
	public class AddHelloModuleCommand
	extends SimpleCommand
	implements ICommand {
		/**
		 * @inheritDoc
		 */
		override public function execute(note : INotification) : void {
			/*
			 * Retrieve the newly loaded HelloModule instance from its
			 * ModuleLoaderMediator.
			 */
			var helloModule : IModule = note.getBody() as IModule;

			// We register a mediator for each newly created module.
			var moduleMediator : ModuleMediator = new ModuleMediator(helloModule)
			facade.registerMediator(moduleMediator);

			/*
			 * This will setup the module PureMVC implementation.
			 *
			 * Be careful at this time, the Flex module application has not yet
			 * fired its CreationComplete event. Only its PureMVC setup and
			 * pipes are ready to use.
			 */
			moduleMediator.setup();
			trace(moduleMediator.getID());

			// The module is added to the display list.
			var shellMediator : AppShellMediator = facade.retrieveMediator(AppShellMediator.NAME) as AppShellMediator;
			shellMediator.addHelloModule(helloModule);
			//trace((helloModule as DisplayObject).name);

			sendNotification(AppShellFacade.CONNECT_MODULE_TO_SHELL, moduleMediator.getID());

			/*
			 * Each <code>ModuleMediator</code> object handle this
			 * notification. So each loaded HelloModule will be connected
			 * through pipe to this new module.
			 */
			sendNotification(AppShellFacade.CONNECT_HELLO_MODULE_TO_HELLO_MODULE, moduleMediator.getID());
		}
	}
}