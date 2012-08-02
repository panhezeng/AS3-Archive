package mvc.controller {
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.patterns.command.MacroCommand;

	/**
	 * MacroCommand只能添加SimpleCommand
	 * 添加Model和View的初始Command
	 */
	public class StartupCommand extends MacroCommand implements ICommand{
		override protected function initializeMacroCommand() : void {
			addSubCommand(ModelPrepCommand);
			addSubCommand(ViewPrepCommand);
		}
	}
}