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
	import common.IModule;

	import shell.ShellAppFacade;
	import shell.view.ModuleMediator;
	import shell.view.ShellAppMediator;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	import flash.display.DisplayObject;

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
	public class AddModuleCommand extends SimpleCommand {
		override public function execute(note : INotification) : void {
			// 获得模块实例
			var module : IModule = note.getBody() as IModule;
			// The module is added to the display list.
			var shellMediator : ShellAppMediator = facade.retrieveMediator(ShellAppMediator.NAME) as ShellAppMediator;
			shellMediator.addModule(module as IModule);
			// new一个该模块实例的Mediator，Mediator的name就是模块名
			var moduleMediator : ModuleMediator = new ModuleMediator(module);
			// 注册模块Mediator
			facade.registerMediator(moduleMediator);
			// 安装模块，即添加此模块的Facade实例到Facade数组instanceMap中，如果在new实例就执行，那得到loader.content时就会自动执行
			moduleMediator.setup();
			(module as DisplayObject).name = moduleMediator.getName();

			sendNotification(ShellAppFacade.CONNECT_MODULE_TO_SHELL, moduleMediator.getName());

			/*
			 * Each <code>ModuleMediator</code> object handle this
			 * notification. So each loaded HelloModule will be connected
			 * through pipe to this new module.
			 */
			sendNotification(ShellAppFacade.CONNECT_MODULE_TO_MODULE, moduleMediator.getName());
		}
	}
}