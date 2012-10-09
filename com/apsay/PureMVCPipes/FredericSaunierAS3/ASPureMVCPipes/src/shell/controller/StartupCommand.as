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
package shell.controller {
	import shell.model.VOProxy;
	import shell.view.AppShellJunctionMediator;
	import shell.view.AppShellMediator;
	import shell.view.HelloModuleJunctionMediator;

	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;

	/**
	 * Startup the Main Application/Shell.
	 *
	 * <P>
	 * Create and register ShellMediator which will own and
	 * manage the app and its visual components.
	 * <P>
	 *
	 * <P>
	 * Create and register ShellJunctionMediator which will own
	 * and manage the Junction for the Main App/Shell.
	 * </P>
	 *
	 * <P>
	 * Create and register the HelloModuleJunctionMediator which will own an
	 * unique pipe Junction responsible for connecting HelloModule among
	 * themselves.
	 * </P>
	 */
	public class StartupCommand
	extends SimpleCommand
	implements ICommand {
		override public function execute(note : INotification) : void {
			facade.registerProxy(new VOProxy());
			// Create and Register the Shell Junction and its Mediator.
			facade.registerMediator(new AppShellJunctionMediator());

			// Create the Junction mediator used for module to module communication.
			facade.registerMediator(new HelloModuleJunctionMediator());

			// Create and Register the Application and its Mediator.
			var appShell : AppShell = note.getBody() as AppShell;
			facade.registerMediator(new AppShellMediator(appShell));
		}
	}
}