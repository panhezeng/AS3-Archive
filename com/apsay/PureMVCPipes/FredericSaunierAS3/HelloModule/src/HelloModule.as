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
package {
	import common.IModule;

	import fl.controls.Button;
	import fl.controls.DataGrid;
	import fl.controls.Label;
	import fl.controls.dataGridClasses.DataGridColumn;
	import fl.data.DataProvider;

	import module.HelloModuleFacade;

	import org.puremvc.as3.multicore.interfaces.IFacade;

	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * Document class for the HelloModule.
	 */
	public class HelloModule
	extends Sprite
	implements IModule {
		public static const NAME : String = "HelloModule";
		public static const REMOVE_MODULE : String = "removeModule";
		public static const TEARDOWN : String = "teardown";
		public static const HELLO_SHELL : String = "helloShell";
		public static const HELLO_ALL : String = "helloAll";
		protected var facade : IFacade;
		private static var serial : Number = 0;
		private var moduleID : String = HelloModule.getNextID();
		// The name of this module.
		public var moduleName : String;
		// The message list.
		public var messages : DataProvider;
		/*
		 * Components
		 */
		public var messageList : DataGrid;
		public var title : Label;
		public var btClose : SimpleButton;
		public var btShell : Button;
		public var btAllModule : Button;

		/**
		 * Constructor
		 */
		public function HelloModule() {
			creationCompleteHandler();
		}

		/**
		 * @inheritDoc
		 */
		public function setup() : void {
			facade = HelloModuleFacade.getInstance(moduleID);
			HelloModuleFacade(facade).startup(this);
		}

		/**
		 * @inheritDoc
		 */
		public function teardown() : void {
			sendEvent(TEARDOWN);
		}

		/**
		 * Get the next unique id.
		 * 
		 * <P>
		 * This module can be instantiated multiple times, so each instance
		 * needs to have it's own unique id for use as a multiton key.
		 * <P>
		 */
		private static function getNextID() : String {
			return NAME + '/' + serial++;
		}

		/**
		 * Module instance setup.
		 */
		private function creationCompleteHandler() : void {
			layoutComponents();

			var senderIDColumn : DataGridColumn = new DataGridColumn("senderID");
			senderIDColumn.headerText = "Sender";

			var messageColumn : DataGridColumn = new DataGridColumn("message");
			messageColumn.headerText = "Message";

			messageList.addColumn(senderIDColumn);
			messageList.addColumn(messageColumn);

			addListeners();

			btClose.useHandCursor = false;

			title.htmlText = '<B>' + moduleID + '</B>';
		}

		/**
		 * @inheritDoc.
		 */
		public function getID() : String {
			return moduleID;
		}

		/**
		 * Helper method needed to dispatch HelloModule events to its
		 * listeners.
		 */
		private function sendEvent(name : String) : void {
			dispatchEvent(new Event(name));
		}

		/**
		 * Add listeners to the Flash components.
		 */
		private function addListeners() : void {
			btClose.addEventListener(MouseEvent.CLICK, function(e : MouseEvent) : void {
				sendEvent(REMOVE_MODULE);
			}) ;
			btShell.addEventListener(MouseEvent.CLICK, function(e : MouseEvent) : void {
				sendEvent(HELLO_SHELL);
			}) ;
			btAllModule.addEventListener(MouseEvent.CLICK, function(e : MouseEvent) : void {
				sendEvent(HELLO_ALL);
			}) ;
		}

		/**
		 * We need to call this method instead of arranging manually the components in Flash
		 * to be able to build the project from Flex Builder.
		 */
		private function layoutComponents() : void {
			messageList = addChild(new DataGrid()) as DataGrid;
			messageList.move(13, 35);
			messageList.setSize(182, 100);

			title = addChild(new Label()) as Label;
			title.move(10, 5);
			title.setSize(170, 19);

			btClose = addChild(new CloseButton()) as CloseButton;
			btClose.x = 187;
			btClose.y = 7;

			btShell = addChild(new Button()) as Button;
			btShell.move(16, 144);
			btShell.setSize(74, 22);
			btShell.label = "SHELL";

			btAllModule = addChild(new Button()) as Button;
			btAllModule.move(93, 144);
			btAllModule.setSize(100, 22);
			btAllModule.label = "ALL MODULES";

			var xIndex : int = serial % 2;
			var yIndex : int = serial / 2;
			this.x = 320 + xIndex * this.width + xIndex * 10;
			this.y = 80 + yIndex * this.height ;
		}
	}
}