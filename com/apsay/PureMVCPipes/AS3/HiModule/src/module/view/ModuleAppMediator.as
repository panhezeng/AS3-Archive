package module.view {
	import fl.controls.Button;

	import common.ModuleMessage;
	import common.PipeNames;

	import module.ModuleAppFacade;

	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author Panhezeng
	 */
	public class ModuleAppMediator extends Mediator {
		public static const NAME : String = "ModuleAppMediator";

		public function ModuleAppMediator(viewComponent : HiModule) {
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
					case moduleApp.BTN_CLOSE:
						action = [ModuleMessage.REMOVE_MODULE, moduleApp.getName()];
						break;
					case moduleApp.BTN_SHELL:
						break;
					case moduleApp.BTN_OTHER_MODULE:
						sendNotification(ModuleAppFacade.SEND_MESSAGE, {type:PipeNames.MODULE_TO_SIBLING, action:action, target:event.target});
						break;
				}
				sendNotification(ModuleAppFacade.SEND_MESSAGE, {type:PipeNames.MODULE_TO_SHELL, action:action, target:event.target});
			}
		}

		private function tearDownHandler(event : Event) : void {
			sendNotification(ModuleAppFacade.TEARDOWN);
		}

		public function get moduleApp() : HiModule {
			return viewComponent as HiModule;
		}
	}
}
