package shell.model.vo {
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	/**
	 * @author Panhezeng
	 */
	public class DataVO {
		/**
		 * 存储加载进shell的模块swf的所在域及主类名
		 * 键名是module的uri，键值数组[所在域,主类名]
		 * 弱引用表示可以垃圾回收，使用弱引用时，必须有当需要的东西已经被回收时的处理机制
		 * 使用弱引用字典时，必须先判断已经赋值的键是否有值，虽然没有手动delete，也可能被gc了
		 */
		public var moduleLoader : Dictionary;
	}
}