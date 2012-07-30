package mvc.controller {
	import mvc.view.ModuleNameMediator;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 理论上SimpleCommand可以做所有事，但从官方大量示例看，主要是registerProxy，registerMediator，sendNotification
	 * 可以直接通过facade.retrieveProxy获得Proxy实例，并调用Proxy方法
	 * 没有见过通过facade.retrieveMediator来获得Mediator的，都是通过sendNotification给Mediator
	 * 注册主容器的Mediator
	 */
	public class ViewPrepCommand extends SimpleCommand {
		override public function execute(notification : INotification) : void {
			facade.registerMediator(new ModuleNameMediator(notification.getBody() as ModuleName));
		}
	}
}
