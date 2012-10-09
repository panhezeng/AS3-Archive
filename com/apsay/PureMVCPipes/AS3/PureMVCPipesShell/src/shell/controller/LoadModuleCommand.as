/*
 PureMVC AS3 MultiCore Pipes Demo – Flex Modules and Pipes Demo
 Copyright (c) 2009 Frederic Saunier <frederic.saunier@puremvc.org>

 Parts originally from:
 
 PureMVC AS3 MultiCore Demo – Flex PipeWorks
 Copyright (c) 2008 Cliff Hall <cliff.hall@puremvc.org>
 
 PureMVC AS3 Demo – AIR RSS Headlines 
 Copyright (c) 2007-08 Simon Bailey <simon.bailey@puremvc.org>

 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package shell.controller {
	import shell.view.ModuleLoaderMediator;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	import flash.display.Loader;

	/**
	 * Instruct the application to load a module identified by its URL.
	 *
	 * <P>
	 * A new <code>ModuleManager</code> is created and is associated to a
	 * dedicated <code>ModuleLoaderMediator</code>.
	 *
	 * <P>
	 * When the module is already in memory the
	 * <code>ShellFacade.MODULE_LOADED</code> notification will immediatly be
	 * dispatched by the <code>ModuleLoaderMediator</code>.
	 */
	public class LoadModuleCommand extends SimpleCommand {
		override public function execute(note : INotification) : void {
			var uri : String = note.getBody() as String;
			var moduleLoaderMediator : ModuleLoaderMediator = facade.retrieveMediator(uri) as ModuleLoaderMediator;
			/*
			 * If the corresponding ModuleLoaderMediator object is not yet
			 * created, we have to create it first.
			 */
			if (!moduleLoaderMediator) {
				var loader : Loader = new Loader();
				moduleLoaderMediator = new ModuleLoaderMediator(uri, loader);
				facade.registerMediator(moduleLoaderMediator);
			}
			moduleLoaderMediator.loaderModule();
		}
	}
}