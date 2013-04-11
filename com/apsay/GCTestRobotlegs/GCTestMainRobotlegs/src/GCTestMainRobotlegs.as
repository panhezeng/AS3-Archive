package {
	import mvc.GCTestMainRobotlegsContext;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	public class GCTestMainRobotlegs extends Sprite {
		// hold on to this
		private var _context : GCTestMainRobotlegsContext;

		public function GCTestMainRobotlegs() {
			super();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			// initialize the framework
			_context = new GCTestMainRobotlegsContext(this);
		}
	}
}