package com.raytoon.cannonfodder.tools.load 
{
	import com.raytoon.cannonfodder.puremvc.view.ui.optionMainLayer.element.Element;
	import com.raytoon.cannonfodder.tools.net.ConstPath;
	import com.raytoon.cannonfodder.tools.xml.XMLSource;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	/**
	 * ...
	 * @author ...
	 */
	public class LoadMaterials 
	{
		
		private static var _instance:LoadMaterials;
		
		public static function getInstance():LoadMaterials {
			
			if (_instance) {
				return _instance;
			}else {
				
				_instance = new LoadMaterials();
				return _instance;
			}
		}
		
		public static function clearInstance():void {
			
			_instance = null;
		}
		public function LoadMaterials() 
		{
			_instance = this;
		}
		private var _completeFunction:Function;
		private var _loadType:String;
		private var _loadArr:Array;
		private var _loadUrlArr:Array = [];
		public function loadData(loadArr:Array,completeFunction:Function = null, loadType:String = Element.SOLDIER):void {
			
			_loadArr = loadArr;
			_loadType = loadType;
			_completeFunction = completeFunction;
			
			var _loadXml:XML;
			if (loadType == Element.SOLDIER) {
				
				_loadXml = XMLSource.getXMLSource("SoldierInfo.xml");
				
				for each (var id:int in loadArr) {
					
					_loadUrlArr.push(ConstPath.MATERIAL_PATH + ConstPath.SWF_PATH + String(_loadXml.soldier.(@id == id).name) + ConstPath.SWF_SUFFIX);
				}
			}
			_loadXml = null;
			if (_loadUrlArr.length > 0) {
				
				loadUrl(_loadUrlArr.pop());
			}else {
				
				if(_completeFunction != null)_completeFunction();
				_completeFunction = null;
			}
		}
		
		private var _loader:Loader;
		private function loadUrl(url:String):void {
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,loadIOErrorHandler);
			_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			
			var context:LoaderContext = new LoaderContext();
			context.applicationDomain = ApplicationDomain.currentDomain;
			
			_loader.load(new URLRequest(url), context);
		}
		
		private function loadComplete(event:Event):void {
			
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadComplete);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,loadIOErrorHandler);
			_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			
			if (_loadUrlArr.length > 0) {
				
				loadUrl(_loadUrlArr.pop());
			}else {
				
				if(_completeFunction != null)_completeFunction();
				_completeFunction = null;
			}
		}
		
		private function loadIOErrorHandler(event:IOErrorEvent):void {
			
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadComplete);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,loadIOErrorHandler);
			_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			
			if (_loadUrlArr.length > 0) {
				
				loadUrl(_loadUrlArr.pop());
			}else {
				
				if(_completeFunction != null)_completeFunction();
				_completeFunction = null;
			}
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadComplete);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,loadIOErrorHandler);
			_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			
			if (_loadUrlArr.length > 0) {
				
				loadUrl(_loadUrlArr.pop());
			}else {
				
				if(_completeFunction != null)_completeFunction();
				_completeFunction = null;
			}
		}
	}

}