package {
	import common.IModule;

	import fl.controls.dataGridClasses.DataGridColumn;

	import module.ModuleAppFacade;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author Panhezeng
	 */
	[SWF(backgroundColor="#FFFFFF", frameRate="31", width="860", height="690")]
	public class HiModule extends Sprite implements IModule {
		public static const NAME : String = "HiModule";
		public const TEARDOWN : String = "teardown";
		public const BTN_CLOSE : String = "btnClose";
		public const BTN_SHELL : String = "btnShell";
		public const BTN_OTHER_MODULE : String = "btnOtherModule";
		private var _moduleName : String;
		private var _hiComp : HiComp;

		public function HiModule() {
			// 模块实例名和facade的key一样
			_moduleName = _getNextName();
		}

		private function _stageInit(event : Event = null) : void {
			if (event) removeEventListener(Event.ADDED_TO_STAGE, _stageInit);
			_createComponents();
			_layout();
			stage.addEventListener(Event.RESIZE, _stageResizeHandler);
		}

		private function _createComponents() : void {
			_hiComp = addChild(new HiComp()) as HiComp;

			var senderIDColumn : DataGridColumn = new DataGridColumn("senderID");
			senderIDColumn.headerText = "Sender";

			var messageColumn : DataGridColumn = new DataGridColumn("message");
			messageColumn.headerText = "Message";

			_hiComp.messageList.addColumn(senderIDColumn);
			_hiComp.messageList.addColumn(messageColumn);

			_hiComp.title.htmlText = '<B>' + _moduleName + '</B>';
		}

		/**
		 * Layout internal components when resized.
		 */
		private function _layout() : void {
			_hiComp.x = 320;
			_hiComp.y = 80;
		}

		/**
		 * Handle the event published when the stage of the whole application is
		 * resized to layout internal components.
		 */
		private function _stageResizeHandler(event : Event) : void {
			_layout();
		}

		private function sendEvent(name : String) : void {
			dispatchEvent(new Event(name));
		}

		/*
		 * 因为直接用loader.content的实例，没法给name赋值了，所以用得到的类名，new一个新实例;
		 * 所以实际上第一个moduleName的_serial从0开始，而不是-1(-1是loader.content);
		 * 就算之前new的这个类的实例都删除，_serial也不会变回-1，请注意。
		 * 当有类似如此需求，已经new了10个实例，删除了实例2，希望new的新实例的名字以及facade的key不是11而是补上2
		 * 则需要写个类静态方法和静态数组，静态方法操作这个数组，静态数组记录删掉的实例的serial数
		 * 新new实例时优先用静态数组的serial数，用一个删一个，当这个数组为空时，再回归正常
		 */
		private function _getNextName() : String {
			return NAME + '_' + name;
		}

		/**
		 * @inheritDoc
		 */
		public function setup() : void {
			// 初始化MVC
			ModuleAppFacade.getInstance(_moduleName).startup(this);
			if (stage) _stageInit();
			else addEventListener(Event.ADDED_TO_STAGE, _stageInit);
		}

		/**
		 * @inheritDoc
		 */
		public function teardown() : void {
			sendEvent(TEARDOWN);
		}

		/**
		 * @inheritDoc
		 */
		public function getName() : String {
			return _moduleName;
		}

		public function get hiComp() : HiComp {
			return _hiComp;
		}
	}
}
