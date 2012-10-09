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
package common {
	import org.puremvc.as3.multicore.utilities.pipes.messages.Message;

	/**
	 * Pipe message used to transport "hello" messages.
	 */
	public class HelloMessage
	extends Message {
		/**
		 * Constructor.
		 * 
		 * @param fromModuleColor
		 * 		The module color from which the message is sent.
		 * 
		 * @param toModuleColor
		 * 		The color of the modules we want to accept the message.
		 * 
		 * @param senderID
		 * 		Sender module unique identifier for this message.
		 * 
		 * @param message
		 * 		Message body of the message.
		 */
		public function HelloMessage(fromModuleColor : String, toModuleColor : String, senderID : String, message : String) {
			var headers : Object = {senderID:senderID, fromModuleColor:fromModuleColor, toModuleColor:toModuleColor};

			super(Message.NORMAL, headers, message);
		}

		/**
		 * The module color from which the message is sent.
		 */
		public function get fromModuleColor() : String {
			return header.fromModuleColor as String;
		}

		/**
		 * The color of the modules we want to accept the message.
		 * 
		 * <P>
		 * The message will be sent to all HelloModules but remember that
		 * each HelloModule apply a filter on its input PIPE before accepting
		 * the received message.
		 * </P>
		 * 
		 */
		public function get toModuleColor() : String {
			return header.toModuleColor as String;
		}

		/**
		 * Sender module unique identifier for this message.
		 */
		public function get senderID() : String {
			return header.senderID as String;
		}

		/**
		 * Message body of the message.
		 */
		public function get message() : String {
			return body as String;
		}
	}
}