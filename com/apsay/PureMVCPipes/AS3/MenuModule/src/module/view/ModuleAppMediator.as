package module.view {
	import common.ModuleMessage;
	import common.PipeNames;

	import fl.controls.Button;

	import module.ModuleAppFacade;

	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author Panhezeng
	 */
	public class ModuleAppMediator extends Mediator {
		public static const NAME : String = "ModuleAppMediator";
		private const HI_MODULE_URI : String = "HiModule.swf";

		public function ModuleAppMediator(viewComponent : MenuModule) {
			super(NAME, viewComponent);
		}

		override public function onRegister() : void {
			moduleApp.addEventListener(MouseEvent.CLICK, _compMouseEvent);
			moduleApp.addEventListener(moduleApp.TEARDOWN, tearDownHandler);
		}

		private function _compMouseEvent(event : MouseEvent) : void {
			var action : Array = [ModuleMessage.MESSAGE, "Say HI"];
			if (event.target is Button) {
				switch(event.target.name) {
					case moduleApp.BTN_ADD:
						action = [ModuleMessage.ADD_MODULE, HI_MODULE_URI];
						break;
					case moduleApp.BTN_SEND_ALL:
						sendNotification(ModuleAppFacade.SEND_MESSAGE, {type:PipeNames.MODULE_TO_SIBLING, action:action, target:event.target});
						break;
				}
				sendNotification(ModuleAppFacade.SEND_MESSAGE, {type:PipeNames.MODULE_TO_SHELL, action:action, target:event.target});
			}
		}

		private function tearDownHandler(event : Event) : void {
			sendNotification(ModuleAppFacade.TEARDOWN);
		}

		public function get moduleApp() : MenuModule {
			return viewComponent as MenuModule;
		}
	}
}
