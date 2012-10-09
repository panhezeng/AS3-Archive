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
	 * Send a message to another HelloModule.
	 *
	 * <P>
	 * Each HelloModule apply a filter on its input PIPE before accepting the
	 * message.
	 * </P>
	 *
	 * <P>
	 * This command is triggered when an HelloModuleMessage has to be sent to
	 * some other HelloModule. The HelloModuleMediator would have listen for
	 * the notification and send the message by itself but a command helps
	 * to understand the whole process.
	 * </P>
	 */
	public class SendMessageToHelloModuleCommand
	extends SimpleCommand
	implements ICommand {
		override public function execute(note : INotification) : void {
			var helloModuleMediator : HelloModuleMediator = facade.retrieveMediator(HelloModuleMediator.NAME) as HelloModuleMediator;
			var helloModuleJunctionMediator : HelloModuleJunctionMediator = facade.retrieveMediator(HelloModuleJunctionMediator.NAME) as HelloModuleJunctionMediator;

			var fromModuleColor : String = "#ff0000";
			var toModuleColor : String = note.getType();
			var senderID : String = this.multitonKey;
			var body : String = note.getBody() as String;
			var helloModuleMessage : HelloMessage = new HelloMessage(fromModuleColor, toModuleColor, senderID, body);

			helloModuleJunctionMediator.sendMessage(PipeNames.HELLO_OUT_TO_HELLO, helloModuleMessage);
		}
	}
}