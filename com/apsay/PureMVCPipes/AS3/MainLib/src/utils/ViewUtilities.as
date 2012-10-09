package utils {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Panhezeng
	 */
	public class ViewUtilities {
		/**
		 * 克隆实例
		 * @param instance 要被克隆的实例
		 */
		public static function cloneInstance(instance : DisplayObject) : DisplayObject {
			var instanceClass : Class = getClass(getInstanceClassName(instance)) as Class;
			var instanceObj : DisplayObject = new instanceClass as DisplayObject;
			return instanceObj;
		}

		/**
		 * 获得实例的类名
		 * @param instance 需要得到其类名的实例
		 */
		public static function getInstanceClassName(instance : DisplayObject) : String {
			return getQualifiedClassName(instance).replace("::", ".");
		}

		/**
		 * 获得实例
		 * @param className 实例的类名
		 * @param domain 类定义所在的域
		 * @return 如得到类，则返回类实例，否则返回null
		 */
		public static function getInstance(className : String, domain : ApplicationDomain = null) : Sprite {
			var ObjClass : Class = getClass(className, domain);
			if (ObjClass) return new ObjClass();
			return null;
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

		/**
		 * 获得按钮模式的Sprite
		 * @param btn true为完全按钮效果，false只是禁用子对象响应鼠标事件
		 */
		public static function getSpriteBTN(btn : Boolean = true) : Sprite {
			var sp : Sprite = new Sprite();
			convertButtonMode(sp, btn);
			return sp;
		}

		/**
		 * 添加按钮效果
		 * @param o 需要变成按钮效果的实例
		 * @param btn @copy #getSpriteBTN
		 */
		public static function convertButtonMode(o : Sprite, btn : Boolean = true) : void {
			o.useHandCursor = btn;
			o.buttonMode = btn;
			o.mouseChildren = false;
		}

		/**
		 * 移除按钮效果
		 * @param o 需要移除按钮效果的实例
		 */
		public static function removeButtonMode(o : Sprite) : void {
			o.buttonMode = false;
			o.useHandCursor = false;
			o.mouseChildren = true;
		}
	}
}
