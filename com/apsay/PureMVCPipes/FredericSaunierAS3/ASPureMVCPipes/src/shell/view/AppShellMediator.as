/*
 *实例名千万不要和包名一样
 */
package shell.view {
	import common.HelloMessage;
	import common.IModule;

	import shell.AppShellFacade;
	import shell.model.VOProxy;
	import shell.view.utils.ViewUtilities;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	public class AppShellMediator
	extends Mediator {
		public static const NAME : String = 'AppShellMediator';
		private var helloModuleLoaded : Boolean;
		private var addHelloModuleCalls : int;
		private var loaderCount : int;
		private var _voProxy : VOProxy;

		public function AppShellMediator(viewComponent : AppShell) {
			super(NAME, viewComponent);
		}

		/**
		 * Register event listeners with the app and its fixed controls.
		 */
		override public function onRegister() : void {
			_voProxy = facade.retrieveProxy(VOProxy.NAME) as VOProxy;
			appShell.addHelloModuleButton.addEventListener(MouseEvent.CLICK, addHelloModuleHandler);
			appShell.helloAllButton.addEventListener(MouseEvent.CLICK, helloAllHandler);
		}

		/**
		 * Application related Notification list.
		 */
		override public function listNotificationInterests() : Array {
			return [AppShellFacade.MODULE_LOADED, AppShellFacade.MODULE_UNLOADED, AppShellFacade.ADD_HELLO_MESSAGE];
		}

		/**
		 * Handle MainApp / Shell related notifications.
		 * 
		 * <P>
		 * Handle the notification used to display each newly received message
		 * from an <code>HelloModule</code>s.
		 * </P>
		 */
		override public function handleNotification(note : INotification) : void {
			switch( note.getName() ) {
				case AppShellFacade.ADD_HELLO_MESSAGE:
					var helloModuleMessage : HelloMessage = note.getBody() as HelloMessage;
					appShell.messageList.dataProvider.addItem(helloModuleMessage);
					break;
			}
		}

		/**
		 * Add a new instance of an HelloModule to the view for display.
		 *
		 * @param helloModule
		 * 		The instance of the HelloModule to add.
		 */
		public function addHelloModule(helloModule : IModule) : void {
			appShell.addModule(helloModule as DisplayObject);
		}

		/**
		 * Remove an instance of an HelloModule from the display.
		 *
		 * @param helloModuleID
		 * 		The ID instance of the HelloModule to remove.
		 */
		public function removeHelloModule(helloModuleID : String) : void {
			var max : int = appShell.numChildren - 1;
			var child : DisplayObject;
			for (var i : int = max; i > -1;i--) {
				child = appShell.getChildAt(i);
				if (child is IModule && (child as IModule).getID() == helloModuleID) appShell.removeModule(child);
			}
		}

		/**
		 * The application component.
		 */
		private function get appShell() : AppShell {
			return viewComponent as AppShell;
		}

		/**
		 * The shell requests a new instance of the HelloModule to be added.
		 *
		 * <P>
		 * If the module need to be loaded first a <code>MODULE_LOADED</code>
		 * notification will be dispatched at the end of the loading process.
		 * </P>
		 */
		private function addHelloModuleHandler(event : MouseEvent) : void {
			getAndAddModule(AppShellFacade.HELLO_MODULE_URI);
		}

		/**
		 *
		 */
		public function getAndAddModule(uri : String) : void {
			var data : Array = _voProxy.getModuleDomainsAndClassName(uri);
			if (data) {
				sendNotification(AppShellFacade.ADD_HELLO_MODULE, ViewUtilities.getInstance(data[1], data[0]));
			} else {
				sendNotification(AppShellFacade.LOAD_MODULE, uri);
			}
		}

		/**
		 * Handle clicks on the "Hello All" button.
		 */
		private function helloAllHandler(event : MouseEvent) : void {
			sendNotification(AppShellFacade.SEND_MESSAGE_TO_ALL_HELLO_MODULES);
		}
	}
}