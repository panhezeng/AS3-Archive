package mvc {
	import mvc.control.commands.PrepControllerCommand;
	import mvc.control.commands.PrepModelCommand;
	import mvc.control.commands.PrepViewCommand;
	import mvc.control.commands.StartupCommand;

	import org.robotlegs.base.ContextEvent;
	import org.robotlegs.mvcs.Context;

	import flash.display.DisplayObjectContainer;

	public class GCTestMainRobotlegsContext extends Context {
		public function GCTestMainRobotlegsContext(contextView : DisplayObjectContainer, autoStartup : Boolean = true) {
			super(contextView, autoStartup);
		}

		override public function startup() : void {
			commandMap.mapEvent(ContextEvent.STARTUP, PrepModelCommand, ContextEvent, true);
			commandMap.mapEvent(ContextEvent.STARTUP, PrepViewCommand, ContextEvent, true);
			commandMap.mapEvent(ContextEvent.STARTUP, PrepControllerCommand, ContextEvent);
			commandMap.mapEvent(ContextEvent.STARTUP, StartupCommand, ContextEvent, true);
			// fire!
			dispatchEvent(new ContextEvent(ContextEvent.STARTUP));
		}
	}
}
