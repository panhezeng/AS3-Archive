package common {
	/**
	 * 每个模块都必须实现的接口，当模块在shell中被加载并实例化后使用
	 */
	public interface IModule {
		/**
		 * 获得模块后，安装模块及初始化
		 * 添加此模块的Facade实例到Facade数组instanceMap中，并且初始化舞台显示相关方法
		 */
		function setup() : void;

		/**
		 * 模块移除时调用，拆卸该模块的管道pipes，并移除此模块的Facade实例
		 */
		function teardown() : void;

		/**
		 * 返回模块实例的唯一名字
		 * Returns the unique Name of the module in this application.
		 */
		function getName() : String;
	}
}