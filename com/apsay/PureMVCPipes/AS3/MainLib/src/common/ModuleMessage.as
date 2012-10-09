package common {
	import org.puremvc.as3.multicore.utilities.pipes.messages.Message;

	/**
	 * Pipe message object used to transport module setup info messages.
	 * 
	 * <P>
	 * Can be used by any module type loaded by a Flex application 
	 * </P>
	 */
	public class ModuleMessage extends Message {
		/**
		 * 模块发出的数据类型
		 * @default message 消息文本类数据
		 */
		public static const MESSAGE : String = "message";
		/**
		 * 模块发出的数据类型
		 * @default addModule 通知shell添加模块
		 */
		public static const ADD_MODULE : String = "addModule";
		/**
		 * 模块发出的数据类型
		 * @default removeModule 通知shell移除模块
		 */
		public static const REMOVE_MODULE : String = "removeModule";

		/**
		 * Constructor. 构造方法
		 * 
		 * @param header
		 * 		Sender module unique identifier for this message.
		 * 
		 * @param body
		 * 		 body type for this message.
		 */
		public function ModuleMessage(header : Object, body : Object) {
			super(Message.NORMAL, header, body);
		}
	}
}