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
	import fl.data.DataProvider;

	import module.model.HelloMessageProxy;
	import module.view.HelloModuleJunctionMediator;
	import module.view.HelloModuleMediator;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;



	/**
	 * Startup the HelloModule.
	 * 
	 * <P>
	 * Create and register a new <code>HelloMessageProxy</code> to manage the
	 * message list.
	 * 
	 * <P>
	 * Create and register new HelloModuleJunctionMediator which will mediate
	 * communications over the pipes of its junction HelloModuleMediator to
	 * manage the the feed.
	 */
	public class StartupCommand
	extends SimpleCommand {
		override public function execute(note : INotification) : void {
			var helloModuleMessages : DataProvider = new DataProvider([]);
			facade.registerProxy(new HelloMessageProxy(helloModuleMessages));

			/*
			 * Create and register the HelloModule and its Mediator for this
			 * module instance.
			 */
			var helloModule : HelloModule = note.getBody() as HelloModule;
			var helloModuleMediator : HelloModuleMediator = new HelloModuleMediator(helloModule);
			facade.registerMediator(helloModuleMediator);
			helloModuleMediator.setMessageList(helloModuleMessages);

			// Create and register the HelloModule Junction Mediator
			facade.registerMediator(new HelloModuleJunctionMediator());
		}
	}
}