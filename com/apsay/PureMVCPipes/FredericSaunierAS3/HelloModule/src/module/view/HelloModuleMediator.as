/*
 PureMVC AS3 MultiCore Pipes Demo – Flash Modules and Pipes Demo
 Copyright (c) 2009 Frederic Saunier <frederic.saunier@puremvc.org>

 Parts originally from:
 
 PureMVC AS3 MultiCore Demo – Flex PipeWorks
 Copyright (c) 2008 Cliff Hall <cliff.hall@puremvc.org>
 
 PureMVC AS3 Demo – AIR RSS Headlines 
 Copyright (c) 2007-08 Simon Bailey <simon.bailey@puremvc.org>

 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package module.view {
	import common.ColorNames;

	import fl.data.DataProvider;
	import fl.events.DataChangeEvent;

	import module.HelloModuleFacade;
	import module.model.HelloMessageProxy;

	import org.puremvc.as3.multicore.patterns.mediator.Mediator;

	import flash.events.Event;

	public class HelloModuleMediator
	extends Mediator {
		public static const NAME : String = "HelloModuleMediator";

		/**
		 * Standard PureMVC application mediator.
		 */
		public function HelloModuleMediator(viewComponent : HelloModule) {
			super(NAME, viewComponent);
		}

		/**
		 * Register event listeners with the FeedWindow and its controls.
		 */
		override public function onRegister() : void {
			helloModule.moduleName = this.multitonKey;

			helloModule.addEventListener(HelloModule.HELLO_SHELL, shellButtonClickHandler);
			helloModule.addEventListener(HelloModule.HELLO_ALL, allModuleButtonClickHandler);

			helloModule.addEventListener(HelloModule.REMOVE_MODULE, removeModuleHandler);
			helloModule.addEventListener(HelloModule.TEARDOWN, tearDownHandler);

			// Bind the messageProxy list of messages with the view list of messages.
			var messageProxy : HelloMessageProxy = facade.retrieveProxy(HelloMessageProxy.NAME) as HelloMessageProxy;
			helloModule.messages = messageProxy.messages;
		}

		/**
		 * The viewComponent cast to type HelloModule.
		 */
		private function get helloModule() : HelloModule {
			return viewComponent as HelloModule;
		}

		/**
		 * Set the messageList *DataProvider* used by the module to display the
		 * message list.
		 */
		public function setMessageList(messages : DataProvider) : void {
			helloModule.messages = messages;
			helloModule.messageList.dataProvider = messages;

			/*
			 * We need to add an eventListener to be sure that the message list
			 * will automatically scroll to the last received message.
			 */
			helloModule.messageList.dataProvider.addEventListener(DataChangeEvent.DATA_CHANGE, function() : void {
				helloModule.messageList.scrollToIndex(helloModule.messageList.dataProvider.length)
			});
		}

		/**
		 * @private
		 */
		private function removeModuleHandler(event : Event) : void {
			sendNotification(HelloModuleFacade.SEND_REMOVE_SIGNAL_TO_SHELL);
		}

		private function shellButtonClickHandler(event : Event) : void {
			sendNotification(HelloModuleFacade.SEND_MESSAGE_TO_SHELL, "Hello");
		}

		private function allModuleButtonClickHandler(event : Event) : void {
			sendNotification(HelloModuleFacade.SEND_MESSAGE_TO_HELLO_MODULE, "Hello");
		}

		private function redModuleButtonClickHandler(event : Event) : void {
			sendNotification(HelloModuleFacade.SEND_MESSAGE_TO_HELLO_MODULE, "Hello", ColorNames.RED);
		}

		private function greenModuleButtonClickHandler(event : Event) : void {
			sendNotification(HelloModuleFacade.SEND_MESSAGE_TO_HELLO_MODULE, "Hello", ColorNames.GREEN);
		}

		private function blueModuleButtonClickHandler(event : Event) : void {
			sendNotification(HelloModuleFacade.SEND_MESSAGE_TO_HELLO_MODULE, "Hello", ColorNames.BLUE);
		}

		private function tearDownHandler(event : Event) : void {
			sendNotification(HelloModuleFacade.TEARDOWN);
		}
	}
}