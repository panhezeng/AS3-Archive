package mvc.model {
	import mvc.AppFacade;
	import mvc.model.vo.DataVO;

	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	/**
	 * 声明Proxy的通知常量，主要是Mediator和Command用到
	 * 获得数据和修改VO的方法，所有数据操作都由这里的方法完成，按需sendNotification给相关Mediator
	 * 只有Proxy直接操作VO，Mediator和command可以调用Proxy方法来修改VO数据
	 * Proxy不监听通知，自然不处理通知，只有通过Mediator和Command来调用其方法
	 * 为兼容robotlegs，对外数据操作可建Service接口方法操作，把对外和对内操作分离。
	 */
	public class VOProxy extends Proxy implements IProxy {
		public static const NAME : String = "VOProxy";

		public function VOProxy() {
			super(NAME);
			// super(NAME, new DataVO());
		}

		public function moduleNameCompDataGet(data : Object = null) : void {
			// 请求所需数据
		}

		private function moduleNameCompDataGetComplete(data : Array) : void {
			vo.data = data;
			sendNotification(AppFacade.VO_READY);
		}

		public function get vo() : DataVO {
			return data as DataVO;
		}
	}
}