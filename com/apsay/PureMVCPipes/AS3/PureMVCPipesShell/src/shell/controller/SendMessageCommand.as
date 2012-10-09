package shell.controller {
	import common.ModuleMessage;

	import shell.view.ShellAppJunctionMediator;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * @author Panhezeng
	 * Send a message to the shell.
	 *
	 * <P>
	 * This command is triggered when an ModuleMessage has to be sent to
	 * the shell. The ModuleMediator would have listen for the notification
	 * and send the message by itself but a command helps to understand the
	 * whole process.
	 * </P>
	 */
	public class SendMessageCommand extends SimpleCommand {
		override public function execute(note : INotification) : void {
			var shellAppJunctionMediator : ShellAppJunctionMediator = facade.retrieveMediator(ShellAppJunctionMediator.NAME) as ShellAppJunctionMediator;
			var key : String = this.multitonKey;
			var data : Object = note.getBody();
			var moduleMessage : ModuleMessage = new ModuleMessage(key, data);
			shellAppJunctionMediator.sendMessage(data.type, moduleMessage);
		}
	}
}
