package mvc.model.proxies {
	import flash.display.BitmapData;

	import mvc.events.SystemEvent;

	import org.robotlegs.mvcs.Actor;

	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.net.LocalConnection;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.System;
	import flash.utils.getQualifiedClassName;

	/**
	 * 
	 */
	public class ModuleLoaderProxy extends Actor {
		// --------------------------------------------------------------------------
		//
		// Instance Properties
		//
		// --------------------------------------------------------------------------
		[Inject]
		public var event : SystemEvent;
		private var _loader : Loader;

		// --------------------------------------------------------------------------
		//
		// Initialization
		//
		// --------------------------------------------------------------------------
		/**
		 * Nah, no comment. 
		 * 
		 */
		public function ModuleLoaderProxy() {
		}

		// --------------------------------------------------------------------------
		//
		// API
		//
		// --------------------------------------------------------------------------
		public function loaderModule(url : String) : void {
			_loader = new Loader();
			// var request : URLRequest = new URLRequest("GCTestModule.swf");
			var request : URLRequest = new URLRequest(url);
			_loader.load(request);
			_loader.contentLoaderInfo.addEventListener(Event.INIT, _initHandler);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _completeHandler);
		}

		/**
		 * 获得实例的类名
		 * @param instance 需要得到其类名的实例
		 */
		public function getInstanceClassName(instance : DisplayObject) : String {
			return getQualifiedClassName(instance).replace("::", ".");
		}

		/**
		 * 获得实例
		 * @param className 实例的类名
		 * @param domain 类定义所在的域
		 * @return 如得到类，则返回类实例，否则返回null
		 */
		public function getInstance(className : String, domain : ApplicationDomain = null) : Sprite {
			var ObjClass : Class = getClass(className, domain);
			if (ObjClass) return new ObjClass();
			return null;
		}

		/*从应用程序域获得类*/
		public function getClass(className : String, domain : ApplicationDomain = null) : Class {
			var classDomain : ApplicationDomain = domain == null ? ApplicationDomain.currentDomain : domain;
			try {
				return classDomain.getDefinition(className) as Class;
			} catch (e : Error) {
				throw new IllegalOperationError(className + " definition not found");
			}
			return null;
		}

		// --------------------------------------------------------------------------
		//
		// Eventhandling
		//
		// --------------------------------------------------------------------------
		private function _initHandler(event : Event) : void {
			_loader.contentLoaderInfo.removeEventListener(Event.INIT, _completeHandler);
			// var module : Sprite = getInstance(getInstanceClassName(_loader.content), _loader.contentLoaderInfo.applicationDomain);
			// dispatch(new SystemEvent(SystemEvent.LOADED_MODULE, module));
			dispatch(new SystemEvent(SystemEvent.LOADED_MODULE, _loader.content));
		}

		private function _completeHandler(event : Event) : void {
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, _completeHandler);
			_loader.unload();
			// var content : DisplayObject = _loader.content;
			// if (content is BitmapData) (content as BitmapData).dispose();
			// content = null;
			// _loader.unloadAndStop();
			_loader = null;
		}
	}
}