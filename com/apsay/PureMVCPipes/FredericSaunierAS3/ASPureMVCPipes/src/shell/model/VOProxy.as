package shell.model {
	import flash.system.ApplicationDomain;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import shell.model.vo.DataVO;





	/**
	 * The Module list of messages proxy.
	 * 
	 * <P>
	 * Maintains the list of <code>Message</code>. This class could
	 * be extended to write log  messages to a remote service as well.
	 * </P>
	 */
	public class VOProxy extends Proxy {
		public static const NAME : String = 'VOProxy';

		public function VOProxy() {
			super(NAME, new DataVO());
		}

		/**
		 * 添加swf的程序域和类名
		 */
		public function addModuleDomainsAndClassName(uri : String, domain : ApplicationDomain, className : String) : void {
			vo.moduleDomainsAndClassName[uri] = [domain, className];
		}

		/**
		 * 移除已经失效的域和类名
		 */
		public function removeModuleDomainsAndClassName(uri : String) : void {
			delete vo.moduleDomainsAndClassName[uri];
		}

		/**
		 * 获得swf的程序域和类名
		 */
		public function getModuleDomainsAndClassName(uri : String) : Array {
			return vo.moduleDomainsAndClassName[uri];
		}

		/**
		 * 获得VO
		 */
		public function get vo() : DataVO {
			return data as DataVO;
		}
	}
}