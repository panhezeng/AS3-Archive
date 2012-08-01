package mvc.view {
	import mvc.AppFacade;
	import mvc.model.VOProxy;
	import mvc.view.components.ModuleNameCompName;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	import flash.events.MouseEvent;

	/**
	 * comp的Mediator
	 * 和主Mediator一样
	 */
	public class ModuleNameCompNameMediator extends Mediator {
		// Cannonical name of the Mediator
		public static const NAME : String = "ModuleNameCompNameMediator";
		private var voProxy : VOProxy;

		public function ModuleNameCompNameMediator(viewComponent : ModuleNameCompName) {
			super(NAME, viewComponent);
		}

		override public function onRegister() : void {
			// 触发VOCommand (推荐方式，也可以直接用Proxy实例调用其API)
			sendNotification(AppFacade.VO_GET);
			// retrieve the proxies
			voProxy = facade.retrieveProxy(VOProxy.NAME) as VOProxy;
			// add comp event
			moduleNameCompName.addEventListener(MouseEvent.CLICK, _compMouseEvent);
		}

		override public function listNotificationInterests() : Array {
			return [AppFacade.VO_READY];
		}

		override public function handleNotification(note : INotification) : void {
			switch ( note.getName() ) {
				case AppFacade.VO_READY:
					moduleNameCompName.compShow();
					break;
			}
		}

		private function _compMouseEvent(event : MouseEvent) : void {
		}

		public function get moduleNameCompName() : ModuleNameCompName {
			return viewComponent as ModuleNameCompName;
		}
	}
}