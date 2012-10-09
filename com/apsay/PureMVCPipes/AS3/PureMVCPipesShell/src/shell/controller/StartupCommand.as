package shell.controller {
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	import shell.model.DataProxy;
	import shell.view.ModuleJunctionMediator;
	import shell.view.ShellAppJunctionMediator;
	import shell.view.ShellAppMediator;

	/**
	 * @author Panhezeng
	 */
	public class StartupCommand extends SimpleCommand {
		override public function execute(note : INotification) : void {
			// Create and Register the Shell VO Proxy and its Proxy.
			facade.registerProxy(new DataProxy());
			// Create and Register the Shell Junction and its Mediator.
			facade.registerMediator(new ShellAppJunctionMediator());
			// Create the Junction mediator used for module to module communication.
			facade.registerMediator(new ModuleJunctionMediator());
			// Create and Register the Application and its Mediator.
			var shellApp : ShellApp = note.getBody() as ShellApp;
			facade.registerMediator(new ShellAppMediator(shellApp));
		}
	}
}
