package mvc.control.commands {
	import mvc.events.SystemEvent;
	import mvc.model.proxies.ModuleLoaderProxy;

	import org.robotlegs.mvcs.Command;

	/**
	 * Command to load the content.
	 */
	public class LoadModuleCommand extends Command {
		[Inject]
		public var proxy : ModuleLoaderProxy;
		[Inject]
		public var event : SystemEvent;

		// --------------------------------------------------------------------------
		//
		// Overridden API
		//
		// --------------------------------------------------------------------------
		override public function execute() : void {
			proxy.loaderModule(event.body);
		}
	}
}