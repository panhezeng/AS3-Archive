package mvc.control.commands {
	import mvc.model.proxies.ModuleLoaderProxy;

	import org.robotlegs.mvcs.Command;

	/**
	 * 
	 * @author Peter Lorent peter.lorent@gmail.com
	 * 
	 */
	public class PrepModelCommand extends Command {
		// --------------------------------------------------------------------------
		//
		// Overridden API
		//
		// --------------------------------------------------------------------------
		/**
		 * Later on during the show we need these guys to fetch some stuff for us.
		 * Let's make sure we can ask for them whenever we need them. 
		 * 
		 */
		override public function execute() : void {
			injector.mapSingleton(ModuleLoaderProxy);
		}
	}
}