package {
	import common.IModule;

	import fl.controls.Button;

	import module.ModuleAppFacade;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author Panhezeng
	 */
	[SWF(backgroundColor="#FFFFFF", frameRate="31", width="860", height="690")]
	public class MenuModule extends Sprite implements IModule {
		public static const NAME : String = "MenuModule";
		public const TEARDOWN : String = "teardown";
		public const BTN_ADD : String = "btnAdd";
		public const BTN_SEND_ALL : String = "btnSendAll";
		private var _moduleName : String;
		private var _addModuleBTN : Button;
		private var _sendMessAgeAllBTN : Button;

		public function MenuModule() {
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
			_addModuleBTN = addChild(new Button()) as Button;
			_addModuleBTN.label = "Add Module";
			_addModuleBTN.name = BTN_ADD;
			_sendMessAgeAllBTN = addChild(new Button()) as Button;
			_sendMessAgeAllBTN.label = "Hi all";
			_sendMessAgeAllBTN.name = BTN_SEND_ALL;
		}

		/**
		 * Layout internal components when resized.
		 */
		private function _layout() : void {
			_addModuleBTN.x = Math.max(542, stage.stageWidth - 318);
			_addModuleBTN.y = 14;
			_addModuleBTN.width = 124;
			_addModuleBTN.height = 22;
			_sendMessAgeAllBTN.x = Math.max(678, stage.stageWidth - 182);
			_sendMessAgeAllBTN.y = 14;
			_sendMessAgeAllBTN.width = 124;
			_sendMessAgeAllBTN.height = 22;
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
	}
}
