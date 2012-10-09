package module.controller {
	import module.model.ModuleMessageProxy;
	import module.view.ModuleAppJunctionMediator;
	import module.view.ModuleAppMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;


	/**
	 * @author Panhezeng
	 */
	public class StartupCommand extends SimpleCommand {
		override public function execute(note : INotification) : void {
			facade.registerProxy(new ModuleMessageProxy([]));
			var moduleApp : HiModule = note.getBody() as HiModule;
			var moduleAppMediator : ModuleAppMediator = new ModuleAppMediator(moduleApp);
			facade.registerMediator(moduleAppMediator);
			facade.registerMediator(new ModuleAppJunctionMediator());
		}
	}
}
