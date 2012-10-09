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
	import shell.ShellAppFacade;
	import shell.model.DataProxy;

	import utils.ViewUtilities;

	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	/**
	 * Generic module loader mediator.
	 */
	public class ModuleLoaderMediator extends Mediator {
		private var _dataProxy : DataProxy;

		/**
		 * Constructor
		 * @param name We will use the URI of the module as unique name for the mediator, it will later facilitate its use.
		 * @param viewComponent The instance of <code>Loader</code> object used to load the module.
		 */
		public function ModuleLoaderMediator(name : String, viewComponent : Loader) {
			super(name, viewComponent);
		}

		/**
		 * @inheritDoc
		 */
		override public function onRegister() : void {
			_dataProxy = facade.retrieveProxy(DataProxy.NAME) as DataProxy;
		}

		public function loaderModule(index : int = 1) : void {
			// 如子swf是加载到父SWF所处的应用程序域的子域下的例子。这种方式也是默认的加载行为。
			// 子swf除了common包名可以一样，module包名绝对不能改成shell即父swf的shell包名。
			var context : LoaderContext = new LoaderContext();
			context.applicationDomain = _dataProxy.getDomain(index);
			var request : URLRequest = new URLRequest(getMediatorName());
			loader.load(request, context);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, _progressHandler);
			// loader.contentLoaderInfo.addEventListener(Event.INIT, _loaderInitHandler);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _loaderCompleteHandler);
			// 延迟100ms显示loading条，这样当第二次加载swf，而此swf已经在系统缓存里了，就不会出现loading条闪现的情况
			// TweenLite.from(loading, 0.1, {alpha:0});
		}

		private function _progressHandler(event : ProgressEvent) : void {
			trace("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);
		}

		// private function _loaderInitHandler(event : Event) : void {
		// var loader : Loader = (event.currentTarget as LoaderInfo).loader as Loader;
		// loader.removeEventListener(Event.INIT, _loaderCompleteHandler);
		//			//  var uri : String = getMediatorName();
		// var moduleClassName : String = ViewUtilities.getInstanceClassName(loader.content);
		// var domain : ApplicationDomain = loader.contentLoaderInfo.applicationDomain;
		//			//  _dataProxy.addModuleLoader(uri, loader);
		//			//  直接用loader.content的实例，没法给name赋值了。所以用得到的类定义，new一个新实例.
		//			//  var shellMediator : ShellAppMediator = facade.retrieveMediator(ShellAppMediator.NAME) as ShellAppMediator;
		//			//  shellMediator.getAddModule(uri);
		// sendNotification(ShellAppFacade.ADD_MODULE, ViewUtilities.getInstance(moduleClassName,domain));
		// }
		/**
		 * Handles the module Event.COMPLETE ready event.
		 */
		private function _loaderCompleteHandler(event : Event) : void {
			var loader : Loader = (event.currentTarget as LoaderInfo).loader as Loader;
			loader.removeEventListener(Event.COMPLETE, _loaderCompleteHandler);
			var moduleClassName : String = ViewUtilities.getInstanceClassName(loader.content);
			var domain : ApplicationDomain = loader.contentLoaderInfo.applicationDomain;
			// 直接用loader.content的实例，没法给name赋值了。所以用得到的类定义，new一个新实例.
			sendNotification(ShellAppFacade.ADD_MODULE, ViewUtilities.getInstance(moduleClassName, domain));
			var uri : String = getMediatorName();
			loader.unload();
			facade.removeMediator(uri);
		}

		/**
		 * <code>Loader</code> object used to manage each Module SWF file loading.
		 */
		private function get loader() : Loader {
			return viewComponent as Loader;
		}
	}
}