package {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/*
	 * 利用脚本语言的特性，实现类似策略模式的思想
	 * 用到if…else或switch…case结构处都可尝试用这个实现
	 * 如用MVC框架，可用Command实现，用条件参数（按需加类别标识）做事件常量，注册处理Command后发通知
	 */
	public class ScriptStrategyDescribeTypeImplement extends Sprite {
		private var  _description : XML;
		// 方法名前缀
		private static const METHOD : String = "method_";
		private var _count : int;

		public function ScriptStrategyDescribeTypeImplement() {
			// 只有该类的public的方法才会写入describeType返回该Class的描述XML中
			_description = describeType(getDefinitionByName(getQualifiedClassName(this)) as Class);
			// 使用演示
			_count = 0;
			stage.addEventListener(MouseEvent.CLICK, clickHandler);
		}

		private function clickHandler(event : MouseEvent) : void {
			_count++;
			_strategyExecute(METHOD + String(_count), String(_count));
		}

		public function method_1(value : Object = null) : void {
			trace(value);
		}

		public function method_2(value : Object = null) : void {
			trace(value);
		}

		// 传入方法名，执行对应的方法
		private function _strategyExecute(mName : String, value : Object = null) : void {
			var method : XMLList = _description.factory.method as XMLList;
			var max : int = method.length() - 1;
			var methodNode : XML;
			for (var i : int = max; i > -1; i--) {
				methodNode = method[i] as XML;
				if (methodNode.@name == mName) this[mName](value);
			}
		}
	}
}
