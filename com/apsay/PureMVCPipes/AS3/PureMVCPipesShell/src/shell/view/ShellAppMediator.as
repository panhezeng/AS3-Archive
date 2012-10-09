package shell.view {
	import flash.display.Loader;
	import flash.utils.Dictionary;
	import flash.system.System;

	import common.IModule;
	import common.ModuleMessage;
	import common.PipeNames;

	import fl.controls.Button;

	import shell.ShellAppFacade;
	import shell.model.DataProxy;

	import utils.ViewUtilities;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	/**
	 * @author Panhezeng
	 */
	public class ShellAppMediator extends Mediator {
		public static const NAME : String = "ShellAppMediator";
		private var _dataProxy : DataProxy;

		public function ShellAppMediator(viewComponent : ShellApp) {
			super(NAME, viewComponent);
		}

		/**
		 * Register event listeners with the app and its fixed controls.
		 */
		override public function onRegister() : void {
			_dataProxy = facade.retrieveProxy(DataProxy.NAME) as DataProxy;
			sendNotification(ShellAppFacade.LOAD_MODULE, ShellAppFacade.MENU_MODULE_URI);
			shellApp.addEventListener(MouseEvent.CLICK, _compMouseEvent);
		}

		private function _compMouseEvent(event : MouseEvent) : void {
			var action : Array = [ModuleMessage.MESSAGE, "Say HI"];
			if (event.target is Button) {
				switch(event.target.name) {
					case shellApp.BTN_GC:
						System.gc();
						break;
					case shellApp.BTN_SEND_ALL:
						sendNotification(ShellAppFacade.SEND_MESSAGE, {type:PipeNames.STD_OUT, action:action, target:event.target});
						break;
				}
			}
		}

		/**
		 * Application related Notification list.
		 */
		override public function listNotificationInterests() : Array {
			return [ShellAppFacade.MODULE_MESSAGE];
		}

		/**
		 * Handle MainApp / Shell related notifications.
		 * 
		 * <P>
		 * Handle the notification used to display each newly received message
		 * from an <code>Module</code>s.
		 * </P>
		 */
		override public function handleNotification(note : INotification) : void {
			var moduleMessage : ModuleMessage;
			switch(note.getName()) {
				case ShellAppFacade.MODULE_MESSAGE:
					moduleMessage = note.getBody() as ModuleMessage;
					shellApp.messageList.dataProvider.addItem({senderID:moduleMessage.getHeader(), message:moduleMessage.getBody().action[1] + " from " + moduleMessage.getBody().target.name});
					_action(moduleMessage.getBody().action);
					break;
			}
		}

		/**
		 * The shell requests a new instance of the Module to be added.
		 *
		 * <P>
		 * If the module need to be loaded first a <code>MODULE_LOADED</code>
		 * notification will be dispatched at the end of the loading process.
		 * </P>
		 */
		private function _action(action : Array) : void {
			switch(action[0]) {
				case ModuleMessage.ADD_MODULE:
					sendNotification(ShellAppFacade.LOAD_MODULE, action[1]);
					break;
				case ModuleMessage.REMOVE_MODULE:
					sendNotification(ShellAppFacade.REMOVE_MODULE, shellApp.getChildByName(action[1]));
					break;
			}
		}

		// public function getAddModule(uri : String) : void {
		// var loader : Loader = _dataProxy.getModuleLoader(uri) as Loader;
		// var module : Object;
		//			//  否则说明此程序域已经没有此类定义，即被回收了，需要先移域重新加载此swf，
		// if (loader) module = ViewUtilities.getInstance(ViewUtilities.getInstanceClassName(loader.content), loader.contentLoaderInfo.applicationDomain);
		// if (module) {
		// sendNotification(ShellAppFacade.ADD_MODULE, module);
		// } else {
		// if (loader) _dataProxy.removeModuleLoader(uri);
		// sendNotification(ShellAppFacade.LOAD_MODULE, uri);
		// }
		// }
		/**
		 * Add a new instance of an Module to the view for display.
		 *
		 * @param Module
		 * 		The instance of the Module to add.
		 */
		public function addModule(module : IModule) : void {
			shellApp.addModule(module as DisplayObject);
		}

		/**
		 * Remove an instance of an Module from the display.
		 *
		 * @param Module
		 * 		The ID instance of the Module to remove.
		 */
		public function removeModule(module : IModule) : void {
			shellApp.removeModule(module as DisplayObject);
		}

		/**
		 * The application component.
		 */
		private function get shellApp() : ShellApp {
			return viewComponent as ShellApp;
		}
	}
}
