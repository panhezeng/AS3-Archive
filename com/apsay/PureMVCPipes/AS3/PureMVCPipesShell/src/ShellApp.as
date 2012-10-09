/*
 *PureMVC AS3 MultiCore Pipes Demo，主要基于Frederic Saunier的flash Demo修改精简提炼
 *本Demo是纯AS项目，shell和modules都是独立项目，用FDT构建，兼容FB,FD,把src拷贝过去就行了
 *ui都用的flash自带组件
 *
 *构建原则：
 *shell定位为主容器和通信中心，负责所有模块的加载显示移除，负责给所有模块推送消息，模块间消息分发；
 *shell适用所有module，shell项目中不要有为了单个module而存在的代码，添加新module时，不需要同时对shell做修改；
 *把shell和modules的耦合降到最低，充分考虑多人开发时，方便分工，独立开发；
 *当有类文件在shell和modules都用到时，可以放到主类库项目中，modules外链到主类库并设置为使用共享代码，只在shell中合并入代码
 *
 *Parts originally from:
 *PureMVC AS3 MultiCore Pipes Demo – Flash Modules and Pipes Demo
 *Copyright (c) 2009 Frederic Saunier <frederic.saunier@puremvc.org>
 */
package {
	import fl.controls.Button;
	import fl.controls.DataGrid;
	import fl.controls.dataGridClasses.DataGridColumn;
	import fl.events.DataChangeEvent;

	import shell.ShellAppFacade;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * 建议所有modules都和shell用一样的swf参数设置
	 * @author Panhezeng
	 */
	[SWF(backgroundColor="#f5f5f5", frameRate="31", width="860", height="690")]
	public class ShellApp extends Sprite {
		public static const NAME : String = "ShellAPP";
		/**
		 * debug模式 执行垃圾回收按钮
		 */
		private var _gc : Button;
		public const BTN_GC : String = "btnGC";
		/**
		 * 给所有模块推送消息按钮 
		 */
		private var _sendMessage : Button;
		public const BTN_SEND_ALL : String = "btnSendAll";
		/**
		 * DEMO的消息日志列表容器，什么模块(senderID)发送了什么消息(message)
		 */
		public var messageList : DataGrid;

		public function ShellApp() {
			/*
			 * 如舞台为真，则直接执行舞台相关初始化
			 * 否则监听实例添加到舞台时发出的事件，发送事件后执行舞台相关初始化
			 */
			if (stage) _stageInit();
			else addEventListener(Event.ADDED_TO_STAGE, _stageInit);
			_initMVC();
		}

		/**
		 * 主类初始化，与stage舞台无关的初始赋值和方法
		 */
		private function _initMVC() : void {
			ShellAppFacade.getInstance(NAME).startup(this);
		}

		/**
		 * stage初始化，与stage舞台相关或者依赖舞台的方法
		 * @param event 默认为null，当执行构造函数后没有立即添加到舞台，则添加到舞台时才会执行此方法，此时event值为ADDED_TO_STAGE事件
		 */
		private function _stageInit(event : Event = null) : void {
			if (event) removeEventListener(Event.ADDED_TO_STAGE, _init);
			_createComponents();
			_layout();
			stage.addEventListener(Event.RESIZE, _stageResizeHandler);
		}

		/**
		 * 创建UI组件
		 */
		private function _createComponents() : void {
			_gc = addChild(new Button()) as Button;
			_gc.name = BTN_SEND_ALL;
			_gc.label = "gc";

			_sendMessage = addChild(new Button()) as Button;
			_sendMessage.x = _gc.width + 10;
			_sendMessage.name = BTN_SEND_ALL;
			_sendMessage.label = "shell say hi";

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
		 * 布局方法，可扩展为自适应布局，即组件X,Y,W,H,依赖stage宽高
		 */
		private function _layout() : void {
			messageList.x = 10;
			messageList.y = 60;
			messageList.width = 288;
			messageList.height = stage.stageHeight - messageList.y - 10;
		}

		/**
		 * Handle the event published when the stage of the whole application is
		 * resized to layout internal components.
		 */
		private function _stageResizeHandler(event : Event) : void {
			_layout();
		}

		/**
		 * Add a new instance of an Module to the view for display.
		 */
		public function addModule(module : DisplayObject) : void {
			addChild(module);
		}

		/**
		 * Remove an instance of an Module from the display.
		 */
		public function removeModule(module : DisplayObject) : void {
			module.parent.removeChild(module);
		}
	}
}
