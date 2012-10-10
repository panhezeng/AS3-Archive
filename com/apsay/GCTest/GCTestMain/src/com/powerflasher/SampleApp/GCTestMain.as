package com.powerflasher.SampleApp {
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.System;
	import flash.utils.getQualifiedClassName;

	public class GCTestMain extends Sprite {
		public const BTN_LOAD : String = "loadSWF";
		public const BTN_GC : String = "gc";
		public const BTN_CLOSE : String = "close";
		public var loader : Loader;
		public var tree : Sprite;

		public function GCTestMain() {
			addChild(new MainBTN());
			addEventListener(MouseEvent.CLICK, _mouseEvent);
		}

		private function _mouseEvent(event : Event) : void {
			switch(event.target.name) {
				case BTN_CLOSE:
					removeChild(tree);
					tree = null;
					break;
				case BTN_LOAD:
					_LoaderExample();
					break;
				case BTN_GC:
					System.gc();
					break;
			}
		}

		private function _LoaderExample() : void {
			loader = new Loader();
			var request : URLRequest = new URLRequest("GCTestModule.swf");
			loader.load(request);
			loader.contentLoaderInfo.addEventListener(Event.INIT, _initHandler);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _completeHandler);
		}

		private function _initHandler(event : Event) : void {
			loader.contentLoaderInfo.removeEventListener(Event.INIT, _completeHandler);
			// tree = getInstance(getInstanceClassName(loader.content), loader.contentLoaderInfo.applicationDomain);
			tree = loader.content as Sprite;
			addChild(tree);
		}

		private function _completeHandler(event : Event) : void {
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, _completeHandler);
			loader.unload();
			loader = null;
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
	}
}
