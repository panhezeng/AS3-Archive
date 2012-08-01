package mvc.view.components {
	import flash.display.Sprite;

	/**
	 * 初始化comp的显示
	 * 和Comp交互触发的事件在其内部处理，当影响到框架其他部分时，发自定义事件给自己的Mediator，由其转发框架通知。
	 * 或者Mediator接管所有Comp交互事件。我倾向Mediator掌握所有控制权，robotlegs也是这样。
	 * Comp提供API满足其Mediator所有需求。
	 */
	public class ModuleNameCompName extends Sprite {
		private var _comp : Sprite;

		public function ModuleNameCompName() {
			init();
		}

		public function init() : void {
			_comp = new Sprite();
			addChild(_comp);
		}

		public function compShow() : void {
			_comp.visible = true;
		}

		public function compHide() : void {
			_comp.visible = false;
		}

		public function compUpdate() : void {
		}
	}
}