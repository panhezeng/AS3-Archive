package mvc.control.commands {
	import mvc.events.SystemEvent;

	import org.robotlegs.mvcs.Command;

	/**
	 * Map Commands.
	 */
	public class PrepControllerCommand extends Command {
		// --------------------------------------------------------------------------
		//
		// Overridden API
		//
		// --------------------------------------------------------------------------
		override public function execute() : void {
			commandMap.mapEvent(SystemEvent.LOAD_MODULE, LoadModuleCommand, SystemEvent);
		}
	}
}