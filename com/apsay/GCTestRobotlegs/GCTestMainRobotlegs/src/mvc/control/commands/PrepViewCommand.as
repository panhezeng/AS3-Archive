package mvc.control.commands {
	import mvc.view.components.ContentView;
	import mvc.view.mediators.ContentViewMediator;

	import org.robotlegs.mvcs.Command;

	/**
	 *
	 * @author Peter Lorent peter.lorent@gmail.com
	 *
	 */
	public class PrepViewCommand extends Command {
		// --------------------------------------------------------------------------
		//
		// Overridden API
		//
		// --------------------------------------------------------------------------
		/**
		 * Tell RobotLegs which Mediator to create when we drop an instance or
		 * instances of our view components on the stage. RobotLegs will detect
		 * this and automatically create the Mediator. And if we remove the view
		 * component, it will also remove the Mediator for us. Again, just mapping
		 * the view components to mediators doesn't start any action on the stage.
		 * Only if you drop one of your view components on the stage, that is when
		 * RobotLegs does the magic!
		 *
		 */
		override public function execute() : void {
			mediatorMap.mapView(ContentView, ContentViewMediator);
		}
	}
}