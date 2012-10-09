package shell.view {
	import common.ModuleMessage;
	import common.PipeNames;

	import flash.utils.Dictionary;

	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeAware;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.JunctionMediator;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Pipe;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeMerge;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeSplit;

	import shell.ShellAppFacade;

	/**
	 * @author Panhezeng
	 */
	public class ShellAppJunctionMediator extends JunctionMediator {
		public static const NAME : String = "shell.view.ShellAppJunctionMediator";
		private var outMap : Dictionary;

		public function ShellAppJunctionMediator() {
			super(NAME, new Junction());
			outMap = new Dictionary();
		}

		/**
		 * Called when the Mediator is registered.
		 * 创建并注册分派和并入的管道，同时为并入管道建立监听事件，有数据输入时触发
		 */
		override public function onRegister() : void {
			/*
			 * 创建名字为STD_OUT(标准输出)，类型为TeeSplit(分派)的pipe(管道)，同时在shell的junction中注册绑定
			 * shell输出给modules的数据，分派管道
			 */
			junction.registerPipe(PipeNames.STD_OUT, Junction.OUTPUT, new TeeSplit());
			/*
			 * 创建名字为STD_IN(标准输入)，类型为TeeMerge(并入)的pipe(管道)，同时在shell的junction中注册绑定
			 * 来自modules的数据输入shell，并入管道 
			 */
			junction.registerPipe(PipeNames.STD_IN, Junction.INPUT, new TeeMerge());
			/*
			 * 在junction里监听来自modules的输入数据
			 * 在junctionMediator的handlePipeMessage方法里处理输入数据
			 */
			junction.addPipeListener(PipeNames.STD_IN, this, handlePipeMessage);
		}

		/**
		 * ShellAppJunctionMediator related Notification list.
		 * 添加ShellAppJunctionMediator关注的消息，并保留父类JunctionMediator默认关注的消息
		 */
		override public function listNotificationInterests() : Array {
			var interests : Array = super.listNotificationInterests();
			interests[interests.length] = ShellAppFacade.CONNECT_MODULE_TO_SHELL;
			interests[interests.length] = ShellAppFacade.DISCONNECT_MODULE_FROM_SHELL;
			return interests;
		}

		/**
		 * Handle ShellAppJunctionMediator related Notifications.
		 * 当得到一个module实例并添加到shell时，会发出CONNECT_MODULE_TO_SHELL消息，建立模块到壳的连接
		 * 当从shell移除即销毁一个module实例时，会发出DISCONNECT_MODULE_FROM_SHELL消息，断开壳与来自模块的连接
		 */
		override public function handleNotification(note : INotification) : void {
			var moduleName : String;
			var moduleFacade : IPipeAware;
			var shellOut : TeeSplit;
			switch(note.getName()) {
				case ShellAppFacade.CONNECT_MODULE_TO_SHELL:
					// 获得模块名
					moduleName = note.getBody() as String;
					// 获得此模块的Facade实例
					moduleFacade = Facade.getInstance(moduleName) as IPipeAware;
					// 创建模块到壳的管道
					var moduleToShell : Pipe = new Pipe();
					//
					moduleFacade.acceptOutputPipe(PipeNames.MODULE_TO_SHELL, moduleToShell);
					// Connect the pipe to the Shell STD_IN TeeMerge
					var shellIn : TeeMerge = junction.retrievePipe(PipeNames.STD_IN) as TeeMerge;
					shellIn.connectInput(moduleToShell);
					// Create the pipe
					var shellToModule : Pipe = new Pipe();
					// Connect the pipe to our module facade.
					moduleFacade.acceptInputPipe(PipeNames.STD_IN, shellToModule);
					// Connect Shell STDOUT TeeSplit to the pipe.
					shellOut = junction.retrievePipe(PipeNames.STD_OUT) as TeeSplit;
					shellOut.connect(shellToModule);
					outMap[moduleName] = shellToModule;
					break;
				case ShellAppFacade.DISCONNECT_MODULE_FROM_SHELL:
					moduleName = note.getBody() as String;
					moduleFacade = Facade.getInstance(moduleName) as IPipeAware;
					/*
					 * We only need to disconnect the <code>shellToModule</code>
					 * pipe as the only reference to this pipe is owned by the
					 * module we remove, it will be garbaged with it.
					 */
					shellOut = junction.retrievePipe(PipeNames.STD_OUT) as TeeSplit;
					shellOut.disconnectFitting(outMap[moduleName]);
					delete outMap[moduleName];
					break;
				// And let super handle the rest (ACCEPT_OUTPUT_PIPE, ACCEPT_INPUT_PIPE, SEND_TO_LOG)								
				default:
					super.handleNotification(note);
			}
		}

		/**
		 * Handle incoming pipe messages for the ShellJunction.
		 * 
		 * <P>
		 * Note that we are handling PipeMessages with the same idiom
		 * as Notifications. Conceptually they are the same, and the
		 * Mediator role doesn't change much. It takes these messages
		 * and turns them into notifications to be handled by other 
		 * actors in the main app / shell.
		 * </P> 
		 * 
		 * <P>
		 * Also, it is logging its actions by sending INFO messages
		 * to the STDLOG output pipe.
		 * </P> 
		 */
		override public function handlePipeMessage(message : IPipeMessage) : void {
			sendNotification(ShellAppFacade.MODULE_MESSAGE, ModuleMessage(message));
		}

		public function sendMessage(outputPipeName : String, message : IPipeMessage) : Boolean {
			return junction.sendMessage(outputPipeName, message);
		}
	}
}
