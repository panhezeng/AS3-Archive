package shell.view.utils {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Panhezeng
	 */
	public class ViewUtilities {
		/*克隆实例*/
		public static function cloneInstance(instance : DisplayObject) : DisplayObject {
			var instanceClass : Class = getClass(getInstanceClassName(instance)) as Class;
			var instanceObj : DisplayObject = new instanceClass as DisplayObject;
			return instanceObj;
		}

		/*获得实例的类名*/
		public static function getInstanceClassName(instance : DisplayObject) : String {
			return getQualifiedClassName(instance).replace("::", ".");
		}

		/*获得实例*/
		public static function getInstance(className : String, domain : ApplicationDomain = null) : Sprite {
			var ObjClass : Class = getClass(className, domain);
			return new ObjClass();
		}

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

		/*获得按钮模式的Sprite*/
		public static function getSpriteBTN(btn : Boolean = true) : Sprite {
			var sp : Sprite = new Sprite();
			convertButtonMode(sp, btn);
			return sp;
		}

		/*添加按钮效果*/
		public static function convertButtonMode(o : Sprite, btn : Boolean = true) : void {
			o.useHandCursor = btn;
			o.buttonMode = btn;
			o.mouseChildren = false;
		}

		/*移除按钮效果*/
		public static function removeButtonMode(o : Sprite) : void {
			o.buttonMode = false;
			o.useHandCursor = false;
			o.mouseChildren = true;
		}
	}
}
