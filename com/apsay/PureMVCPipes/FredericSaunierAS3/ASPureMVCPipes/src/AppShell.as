/*
 PureMVC AS3 MultiCore Pipes Demo – Flash Modules and Pipes Demo
 Copyright (c) 2009 Frederic Saunier <frederic.saunier@puremvc.org>

 Parts originally from:
 
 PureMVC AS3 MultiCore Demo – Flex PipeWorks
 Copyright (c) 2008 Cliff Hall <cliff.hall@puremvc.org>
 
 PureMVC AS3 Demo – AIR RSS Headlines 
 Copyright (c) 2007-08 Simon Bailey <simon.bailey@puremvc.org>

 Your reuse is governed by the Creative Commons Attribution 3.0 License
 潘何增在此基础上在改成纯AS3项目
 */
package {
	import fl.controls.Button;
	import fl.controls.DataGrid;
	import fl.controls.dataGridClasses.DataGridColumn;
	import fl.events.DataChangeEvent;

	import shell.AppShellFacade;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;

	/**
	 * Main view component of the Shell application.
	 */
	[SWF(backgroundColor="#FFFFFF", frameRate="31", width="860", height="690")]
	public class AppShell extends Sprite {
		public static const NAME : String = 'AppShell';
		public var shellBackground : MovieClip;
		public var controlBarBackground : MovieClip;
		public var addHelloModuleButton : Button;
		public var helloAllButton : Button;
		public var messageList : DataGrid;
		public var controlBarTitle : ControlBarTitle;

		/**
		 * Constructor
		 */
		public function AppShell() {
			if (stage) _init();
			else addEventListener(Event.ADDED_TO_STAGE, _init);
		}

		private function _init(event : Event = null) : void {
			createComponents();
			layout();
			stage.addEventListener(Event.RESIZE, stageResizeHandler);
			AppShellFacade.getInstance(NAME).startup(this);
		}

		private function createComponents() : void {
			shellBackground = addChild(new ShellBackground()) as ShellBackground;
			controlBarBackground = addChild(new ControlBarBackground()) as ControlBarBackground;
			controlBarTitle = addChild(new ControlBarTitle()) as ControlBarTitle;
			controlBarBackground.filters = [new DropShadowFilter(4, 90, 0, 1, 5, 5, 0.25, 1)];

			addHelloModuleButton = addChild(new Button()) as Button;
			addHelloModuleButton.label = "Add HelloModule";
			helloAllButton = addChild(new Button()) as Button;
			helloAllButton.label = "hello all!";

			messageList = addChild(new DataGrid()) as DataGrid;
			var senderIDColumn : DataGridColumn = new DataGridColumn("senderID");
			senderIDColumn.headerText = "Sender";
			var messageColumn : DataGridColumn = new DataGridColumn("message");
			messageColumn.headerText = "Message";
			messageList.addColumn(senderIDColumn);
			messageList.addColumn(messageColumn);
			/*
			 * We need to add an eventListener to be sure that the message list
			 * will automatically scroll to the last received message.
			 */
			messageList.dataProvider.addEventListener(DataChangeEvent.DATA_CHANGE, function() : void {
				messageList.scrollToIndex(messageList.dataProvider.length);
			});
		}

		/**
		 * Handle the event published when the stage of the whole application is
		 * resized to layout internal components.
		 */
		private function stageResizeHandler(event : Event) : void {
			layout();
		}

		/**
		 * Layout internal components when resized.
		 */
		private function layout() : void {
			messageList.x = 10;
			messageList.y = 60;
			messageList.width = 288;
			messageList.height = stage.stageHeight - messageList.y - 10;

			controlBarBackground.x = 0;
			controlBarBackground.y = 0;
			controlBarBackground.width = stage.stageWidth;

			controlBarTitle.x = 12;
			controlBarTitle.y = 9;

			addHelloModuleButton.x = Math.max(542, stage.stageWidth - 318);
			addHelloModuleButton.y = 14;
			addHelloModuleButton.width = 124;
			addHelloModuleButton.height = 22;

			helloAllButton.x = Math.max(678, stage.stageWidth - 182);
			helloAllButton.y = 14;
			helloAllButton.width = 124;
			helloAllButton.height = 22;

			shellBackground.x = 0;
			shellBackground.y = 0;
			shellBackground.width = stage.stageWidth;
			shellBackground.height = stage.stageHeight;
		}

		/**
		 * Add a new instance of an HelloModule to the view for display.
		 */
		public function addModule(module : DisplayObject, x : Number = 0, y : Number = 0, w : Number = 0, h : Number = 0) : void {
			addChild(module);
			// trace('module: ' + (module));
			// trace('module.name: ' + (module.name));
			// trace('module.parent: ' + (module.parent));
			if (x) module.x = x;
			if (y) module.x = y;
			if (w) module.width = w;
			if (h) module.height = h;
		}

		/**
		 * Remove an instance of an Module from the display.
		 */
		public function removeModule(module : DisplayObject) : void {
			module.parent.removeChild(module);
		}
	}
}