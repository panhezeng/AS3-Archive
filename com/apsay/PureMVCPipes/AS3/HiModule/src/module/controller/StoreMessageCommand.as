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
	import common.ModuleMessage;

	import fl.controls.DataGrid;

	import module.model.ModuleMessageProxy;
	import module.view.ModuleAppMediator;

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
	public class StoreMessageCommand extends SimpleCommand {
		override public function execute(note : INotification) : void {
			var proxy : ModuleMessageProxy = facade.retrieveProxy(ModuleMessageProxy.NAME) as ModuleMessageProxy;
			var moduleMessage : ModuleMessage = note.getBody() as ModuleMessage;
			proxy.addMessage(moduleMessage);
			var messageList : DataGrid = (facade.retrieveMediator(ModuleAppMediator.NAME) as ModuleAppMediator).moduleApp.hiComp.messageList;
			messageList.dataProvider.addItem({senderID:moduleMessage.getHeader(), message:moduleMessage.getBody().action[1] + " from " + moduleMessage.getBody().target.name});
		}
	}
}