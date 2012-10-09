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
	 * Pipe message object used to transport module setup info messages.
	 * 
	 * <P>
	 * Can be used by any module type loaded by a Flex application not
	 * specifically an HelloModule.
	 * </P>
	 */
	public class SetupInfoMessage
	extends Message {
		/**
		 * The remove signal type used to indicate this message asks the shell
		 * to remove the sender module from the display list.
		 */
		public static const REMOVE : String = "remove";

		/**
		 * Constructor.
		 * 
		 * @param key
		 * 		Sender module unique identifier for this message.
		 * 
		 * @param signal
		 * 		SetupInfo signal type for this message.
		 */
		public function SetupInfoMessage(key : String, signal : String = null) {
			super(Message.NORMAL, key, signal);
		}

		/**
		 * Sender module unique identifier for this message.
		 */
		public function get key() : String {
			return header as String;
		}

		/**
		 * SetupInfo signal type for this message.
		 */
		public function get signal() : String {
			return body as String;
		}
	}
}