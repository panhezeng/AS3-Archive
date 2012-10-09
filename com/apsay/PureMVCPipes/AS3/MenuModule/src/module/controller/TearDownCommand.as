package module.controller {
	import module.view.ModuleAppJunctionMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.patterns.facade.Facade;


	/**
	 * @author Panhezeng
	 */
	public class TearDownCommand extends SimpleCommand {
		override public function execute(note : INotification) : void {
			var moduleAppJunctionMediator : ModuleAppJunctionMediator = facade.retrieveMediator(ModuleAppJunctionMediator.NAME) as ModuleAppJunctionMediator;
			moduleAppJunctionMediator.tearDown();
			// Definitively removes the PureMVC core used to manage this module.
			Facade.removeCore(multitonKey);
		}
	}
}
