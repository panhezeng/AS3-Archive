package mvc.controller {
	import mvc.AppFacade;
	import mvc.model.VOProxy;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 数据相关Command
	 */
	public class VOCommand extends SimpleCommand {
		override public function execute(notification : INotification) : void {
			var name : String = notification.getName();
			var body : Object = notification.getBody();

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