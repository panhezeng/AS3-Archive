package mvc.controller {
	import org.puremvc.as3.interfaces.ICommand;
	import mvc.view.AppMediator;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/**
	 * 理论上SimpleCommand可以做所有事，但从官方大量示例看，主要是registerProxy，registerMediator，sendNotification
	 * 可以直接通过facade.retrieveProxy获得Proxy实例，并调用Proxy方法
	 * 官方示例没见通过facade.retrieveMediator来获得Mediator的，都是通过sendNotification给Mediator，也是可以用的，既然提供了这个方法
	 * 注册主容器的Mediator
	 */
	public class ViewPrepCommand extends SimpleCommand implements ICommand{
		override public function execute(note : INotification) : void {
			facade.registerMediator(new AppMediator(note.getBody() as App));
		}
	}
}
