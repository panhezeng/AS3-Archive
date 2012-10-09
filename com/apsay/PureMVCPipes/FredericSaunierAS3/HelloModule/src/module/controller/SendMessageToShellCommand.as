/*
 PureMVC AS3 MultiCore Pipes Demo – Flash Modules and Pipes Demo
 Copyright (c) 2009 Frederic Saunier <frederic.saunier@puremvc.org>

 Parts originally from:
 
 PureMVC AS3 MultiCore Demo – Flex PipeWorks
 Copyright (c) 2008 Cliff Hall <cliff.hall@puremvc.org>
 
 PureMVC AS3 Demo – AIR RSS Headlines 
 Copyright (c) 2007-08 Simon Bailey <simon.bailey@puremvc.org>

 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package module.controller {
	import common.HelloMessage;
	import common.PipeNames;

	import module.view.HelloModuleJunctionMediator;
	import module.view.HelloModuleMediator;

	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;



	/**
	 * Send a message to the shell.
	 *
	 * <P>
	 * This command is triggered when an HelloModuleMessage has to be sent to
	 * the shell. The HelloModuleMediator would have listen for the notification
	 * and send the message by itself but a command helps to understand the
	 * whole process.
	 * </P>
	 */
	public class SendMessageToShellCommand
	extends SimpleCommand
	implements ICommand {
		override public function execute(note : INotification) : void {
			var helloModuleMediator : HelloModuleMediator = facade.retrieveMediator(HelloModuleMediator.NAME) as HelloModuleMediator;
			var helloModuleJunctionMediator : HelloModuleJunctionMediator = facade.retrieveMediator(HelloModuleJunctionMediator.NAME) as HelloModuleJunctionMediator;

			var fromModuleColor : String = "#ffff00";
			var senderID : String = this.multitonKey;
			var body : String = note.getBody() as String;

			/*
			 * The shell is not an HelloModule. It does not need any
			 * toModuleColor argument. We let it null.
			 */
			var helloModuleMessage : HelloMessage = new HelloMessage(fromModuleColor, null, senderID, body);

			helloModuleJunctionMediator.sendMessage(PipeNames.ANY_MODULE_TO_SHELL, helloModuleMessage);
		}
	}
}