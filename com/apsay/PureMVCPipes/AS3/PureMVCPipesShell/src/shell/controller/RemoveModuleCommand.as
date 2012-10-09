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
	import common.IModule;

	import shell.ShellAppFacade;
	import shell.model.DataProxy;
	import shell.view.ModuleMediator;
	import shell.view.ShellAppMediator;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	import flash.display.DisplayObject;
	import flash.display.Loader;

	/**
	 * The new module is unreferrenced from its PureMVC core and removed
	 * from the display list.
	 * 
	 * <P>
	 * When no more instance of the module are displayed in the shell the
	 * module file is unloaded from memory.
	 * </P>
	 */
	public class RemoveModuleCommand extends SimpleCommand {
		override public function execute(note : INotification) : void {
			var module : IModule = note.getBody() as IModule;
			var moduleName : String = module.getName();

			/*
			 * Each *HelloModuleJunctionMediator* object handle this
			 * notification. So each loaded HelloModule will disconnect input
			 * and output pipes from the module actually removed.
			 */
			sendNotification(ShellAppFacade.DISCONNECT_MODULE_FROM_MODULE, moduleName);

			/*
			 * Disconnect input and output pipes between the shell and the module.
			 */
			sendNotification(ShellAppFacade.DISCONNECT_MODULE_FROM_SHELL, moduleName);
			var moduleMediator : ModuleMediator = facade.retrieveMediator(moduleName) as ModuleMediator;
			moduleMediator.tearDown();
			facade.removeMediator(moduleName);
			if ((module as DisplayObject).parent && !((module as DisplayObject).parent is Loader)) {
				// Remove the HelloModule view instance from the shell display list.
				var shellMediator : ShellAppMediator = facade.retrieveMediator(ShellAppMediator.NAME) as ShellAppMediator;
				shellMediator.removeModule(module);
			}
		}
	}
}