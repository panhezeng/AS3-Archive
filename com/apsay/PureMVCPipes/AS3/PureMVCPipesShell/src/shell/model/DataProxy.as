package shell.model {
	import shell.model.vo.DataVO;

	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	import flash.system.ApplicationDomain;

	/**
	 * @author Panhezeng
	 */
	public class DataProxy extends Proxy {
		public static const NAME : String = "shell.model.DataProxy";

		public function DataProxy() {
			super(NAME, new DataVO());
			// vo.moduleLoader = new Dictionary();
		}

		// /**
		// * 添加swf的程序域和类名
		// */
		// public function addModuleLoader(uri : String, loader : Loader) : void {
		// vo.moduleLoader[uri] = loader;
		// }
		//
		// /**
		// * 移除已经失效的域和类名
		// */
		// public function removeModuleLoader(uri : String) : void {
		// delete vo.moduleLoader[uri];
		// }
		//
		// /**
		// * 获得swf的程序域和类名
		// * @return 数组[所在域,主类名]
		// */
		// public function getModuleLoader(uri : String) : Loader {
		// return vo.moduleLoader[uri];
		// }
		/**
		 * 获得LoaderContext常用的三种applicationDomain
		 * @param type 0 将类定义放置到父SWF所在的应用程序域（当前应用程序域）
		 * 				1 将类定义放置到父SWF所在的应用程序域的的子域
		 * 				2 将类定义放置到父SWF所在的应用程序域的系统域
		 */
		public function getDomain(type : int) : ApplicationDomain {
			// 将类定义放置到父SWF所在的应用程序域（当前应用程序域）
			var current : ApplicationDomain = ApplicationDomain.currentDomain;
			// 将类定义放置到父SWF所在的应用程序域的的子域
			var currentChild : ApplicationDomain = new ApplicationDomain(current);
			// 将类定义放置到父SWF所在的应用程序域的系统域
			var systemChild : ApplicationDomain = new ApplicationDomain();
			var domain : ApplicationDomain;
			switch(type) {
				case 0:
					domain = current;
					break;
				case 1:
					domain = currentChild;
					break;
				case 2:
					domain = systemChild;
					break;
			}

			return domain;
		}

		/**
		 * 获得VO
		 */
		public function get vo() : DataVO {
			return data as DataVO;
		}
	}
}