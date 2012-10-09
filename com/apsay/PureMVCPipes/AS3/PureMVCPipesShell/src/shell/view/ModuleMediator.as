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
	import common.IModule;

	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	/**
	 * Mediator for each loaded Module.
	 *
	 * <P>
	 * Instantiate and manage each loaded Module for the application.
	 */
	public class ModuleMediator extends Mediator {
		public function ModuleMediator(viewComponent : IModule) {
			super(viewComponent.getName(), viewComponent);
		}

		/**
		 * The module.handled by the <code>ModuleMediator</code> object.
		 */
		private function get module() : IModule {
			return viewComponent as IModule;
		}

		/**
		 * 获得模块后，安装模块及初始化
		 * 添加此模块的Facade实例到Facade数组instanceMap中，并且初始化舞台显示相关方法
		 */
		/**
		 * Ask the module to setup its PureMVC implementation and pipes.
		 */
		public function setup() : void {
			module.setup();
		}

		/**
		 * Ask the module to tear down its PureMVC implementation and pipes.
		 */
		public function tearDown() : void {
			module.teardown();
		}

		/**
		 * Returns the Module ID.
		 *
		 * <P>
		 * Note that here we use it to create the ModuleMediator name.
		 */
		public function getName() : String {
			return module.getName();
		}
	}
}