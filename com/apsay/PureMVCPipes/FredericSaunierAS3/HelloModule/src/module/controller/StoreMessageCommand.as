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

	import module.model.HelloMessageProxy;

	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;



	/**
	 * Add a received message to the module list of message.
	 *
	 * <P>
	 * This command is triggered when an HelloModuleMessage comes in, and adds
	 * it to the MessageProxy. The HelloMessageProxy uses an ArrayCollection
	 * for its list, so any UI controls listening to it will be updated
	 * automatically.
	 * </P>
	 */
	public class StoreMessageCommand
	extends SimpleCommand
	implements ICommand {
		override public function execute(note : INotification) : void {
			var proxy : HelloMessageProxy = facade.retrieveProxy(HelloMessageProxy.NAME) as HelloMessageProxy;
			proxy.addMessage(note.getBody() as HelloMessage);
		}
	}
}