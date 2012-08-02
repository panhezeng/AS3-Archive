package mvc.controller {
	import org.puremvc.as3.interfaces.ICommand;

	import mvc.AppFacade;
	import mvc.model.VOProxy;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 数据相关Command
	 */
	public class VOCommand extends SimpleCommand  implements ICommand {
		override public function execute(note : INotification) : void {
			var name : String = note.getName();
			var body : Object = note.getBody();

			switch ( name ) {
				case AppFacade.VO_GET:
					proxy.moduleNameCompDataGet(body);
					break;
			}
		}

		private function get proxy() : VOProxy {
			return facade.retrieveProxy(VOProxy.NAME) as VOProxy;
		}
	}
}