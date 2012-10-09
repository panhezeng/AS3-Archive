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
	import common.PipeNames;
	import common.SetupInfoMessage;

	import module.view.HelloModuleJunctionMediator;
	import module.view.HelloModuleMediator;

	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;



	/**
	 * Send a <code>SetupInfoMessage</code> to the shell.
	 *
	 * <P>
	 * We only really use it here to ask the shell to remove an HelloModule.
	 * Before removing the module, the shell will call the teardown method of
	 * this HelloModule instance. We must be ready for the teardown.
	 * </P>
	 */
	public class SendRemoveSignalToShellCommand
	extends SimpleCommand
	implements ICommand {
		override public function execute(note : INotification) : void {
			var helloModuleMediator : HelloModuleMediator = facade.retrieveMediator(HelloModuleMediator.NAME) as HelloModuleMediator;
			var helloModuleJunctionMediator : HelloModuleJunctionMediator = facade.retrieveMediator(HelloModuleJunctionMediator.NAME) as HelloModuleJunctionMediator;

			var key : String = this.multitonKey;
			var signal : String = note.getBody() as String;
			var setupInfoMessage : SetupInfoMessage = new SetupInfoMessage(key, SetupInfoMessage.REMOVE);
			helloModuleJunctionMediator.sendMessage(PipeNames.ANY_MODULE_TO_SHELL, setupInfoMessage);
		}
	}
}