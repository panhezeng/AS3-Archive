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
package shell.view {
	import common.IModule;

	import shell.AppShellFacade;
	import shell.model.VOProxy;
	import shell.view.utils.ViewUtilities;

	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	/**
	 * Generic module loader mediator.
	 */
	public class ModuleLoaderMediator extends Mediator {
		private var _voProxy : VOProxy;
		private var _domainTypes : Vector.<ApplicationDomain>;

		/**
		 * Constructor
		 * 
		 * @param name
		 * 		We will use the URI of the module as unique name for the
		 * 		mediator, it will later facilitate its use.
		 * 
		 * @param viewComponent
		 * 		The instance of <code>Loader</code> object used to load the
		 * 		module.
		 * 
		 */
		public function ModuleLoaderMediator(name : String, viewComponent : Loader) {
			super(name, viewComponent);
		}

		/**
		 * @inheritDoc
		 */
		override public function onRegister() : void {
			_voProxy = facade.retrieveProxy(VOProxy.NAME) as VOProxy;
			_domainTypes = new Vector.<ApplicationDomain>(3, true);
			// 将定义放置到父SWF所在的应用程序域（当前应用程序域）
			var current : ApplicationDomain = ApplicationDomain.currentDomain;
			_domainTypes[0] = current;
			// 将定义放置到父SWF所在的应用程序域的的子域
			var currentChild : ApplicationDomain = new ApplicationDomain(current);
			_domainTypes[1] = currentChild;
			// 将定义放置到父SWF所在的应用程序域的系统域
			var systemChild : ApplicationDomain = new ApplicationDomain();
			_domainTypes[2] = systemChild;
		}

		public function loaderModule(index : int = 1) : void {
			// 如子swf是加载到父SWF所处的应用程序域的子域下的例子。这种方式也是默认的加载行为。
			// 子swf除了common包名可以一样，module包名绝对不能改成shell即父swf的shell包名。
			var context : LoaderContext = new LoaderContext();
			context.applicationDomain = _domainTypes[index];
			var request : URLRequest = new URLRequest(getMediatorName());
			loader.load(request, context);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _loaderCompleteHandler);
		}

		/**
		 * Handles the module Event.COMPLETE ready event.
		 */
		private function _loaderCompleteHandler(event : Event) : void {
			var loader : Loader = (event.currentTarget as LoaderInfo).loader as Loader;
			loader.removeEventListener(Event.COMPLETE, _loaderCompleteHandler);
			var uri : String = getMediatorName();
			var module : IModule = loader.content as IModule;
			_voProxy.addModuleDomainsAndClassName(uri, loader.contentLoaderInfo.applicationDomain, ViewUtilities.getInstanceClassName(module as DisplayObject));
			sendNotification(AppShellFacade.ADD_HELLO_MODULE, module);
			loader.unload();
			facade.removeMediator(uri);
		}

		/**
		 * <code>Loader</code> object used to manage each Module SWF file
		 * loading.
		 */
		private function get loader() : Loader {
			return viewComponent as Loader;
		}
	}
}