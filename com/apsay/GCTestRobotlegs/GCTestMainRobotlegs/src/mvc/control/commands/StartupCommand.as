package mvc.control.commands {
	import mvc.view.components.ContentView;

	import org.robotlegs.mvcs.Command;

	/**
	 * 
	 */
	public class StartupCommand extends Command {
		// --------------------------------------------------------------------------
		//
		// Overridden API
		//
		// --------------------------------------------------------------------------
		/**
		 * And here we go! Drop the view components on the stage. 
		 * 
		 */
		override public function execute() : void {
			contextView.addChild(new ContentView());
		}
	}
}