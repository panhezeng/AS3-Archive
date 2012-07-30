package {
	import flash.utils.Dictionary;
	import flash.events.MouseEvent;
	import flash.display.Sprite;

	/*
	 * 利用脚本语言的特性，实现类似策略模式的思想
	 * 用到if…else或switch…case结构处都可尝试用这个实现
	 * 如用MVC框架，可用Command实现，用条件参数（按需加类别标识）做事件常量，注册处理Command后发通知
	 */
	public class ScriptStrategyImplement extends Sprite {
		// 方法存储器
		private var _strategies : Dictionary;
		// 方法名
		private static const STRATEGY : String = "strategy_";
		private static const S_A : String = STRATEGY + "1";
		private static const S_B : String = STRATEGY + "2";
		private var _count : int;

		public function ScriptStrategyImplement() {
			_strategies = new Dictionary();
			// 存储方法，绑定方法名和方法
			_strategies[S_A] = _concreteStrategyA;
			_strategies[S_B] = _concreteStrategyB;

			// 使用演示
			_count = 0;
			stage.addEventListener(MouseEvent.CLICK, clickHandler);
		}

		private function clickHandler(event : MouseEvent) : void {
			_count++;
			_strategyExecute(STRATEGY + String(_count), String(_count));
		}

		private function _concreteStrategyA(value : Object = null) : void {
			trace(value);
		}

		private function _concreteStrategyB(value : Object = null) : void {
			trace(value);
		}

		// 传入方法名，执行对应的方法
		private function _strategyExecute(iName : String, value : Object = null) : void {
			try {
				_strategies[iName](value);
			} catch(error : Error) {
				trace("没有绑定处理方法" + error.message);
			}
			// for (var i:String in _strategies) {
			// if (i == iName) {
			// _strategies[iName](value);
			// break;
			// }
			// }
		}
	}
}
