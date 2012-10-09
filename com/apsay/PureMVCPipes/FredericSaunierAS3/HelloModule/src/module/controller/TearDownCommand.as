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
	import module.view.HelloModuleJunctionMediator;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.patterns.facade.Facade;


	/**
	 * Tear down the module PureMVC implementation and disconnect each
	 * pipe it used.
	 */
	public class TearDownCommand
	extends SimpleCommand {
		override public function execute(note : INotification) : void {
			var helloModuleJunctionMediator : HelloModuleJunctionMediator = facade.retrieveMediator(HelloModuleJunctionMediator.NAME) as HelloModuleJunctionMediator;

			helloModuleJunctionMediator.tearDown();

			// Definitively removes the PureMVC core used to manage this module.
			Facade.removeCore(multitonKey);
		}
	}
}