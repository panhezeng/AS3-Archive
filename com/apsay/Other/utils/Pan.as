package com.apsay.utils
{
	import flash.system.ApplicationDomain;
	import flash.errors.IllegalOperationError;
	import flash.display.Sprite;
	import flash.display.BitmapData;

	public class Pan
	{
		/*从应用程序域获得类*/
		public static function getClass(className : String, domain : ApplicationDomain = null) : Class {
			var classDomain : ApplicationDomain = domain == null ? ApplicationDomain.currentDomain : domain;
			try {
				return classDomain.getDefinition(className) as Class;
			} catch (e : Error) {
				throw new IllegalOperationError(className + " definition not found");
			}
			return null;
		}
		/*获得Sprite*/
		public static function getSprite(className : String) : Sprite {
			var ObjClass : Class = getClass(className);
			return new ObjClass();
		}
		/*获得BitmapData */
		public static function getBitmapData (className : String) : BitmapData  {
			var ObjClass : Class = getClass(className);
			return new ObjClass();
		}		
	}
}