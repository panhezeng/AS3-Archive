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
package module.model {
	import common.HelloMessage;

	import fl.data.DataProvider;

	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	/**
	 * The HelloModule list of messages proxy.
	 * 
	 * <P>
	 * Maintains the list of <code>HelloMessage</code>. This class could
	 * be extended to write log  messages to a remote service as well.
	 * </P>
	 * 
	 * <P>
	 * An <code>ArrayCollection</code> is used to hold the messages because it
	 * will be used as a data provider for UI controls, which will
	 * automatically be refreshed when the contents of the ArrayCollection
	 * changes.
	 * </P>
	 */
	public class HelloMessageProxy
	extends Proxy {
		public static const NAME : String = 'HelloMessageProxy';

		public function HelloMessageProxy(data : DataProvider) {
			super(NAME, data);
		}

		/**
		 * Add a new message to the list.
		 */
		public function addMessage(message : HelloMessage) : void {
			messages.addItem(message);
		}

		/**
		 * The list of messages controlled by the <code>Proxy</code> object.
		 */
		public function get messages() : DataProvider {
			return data as DataProvider;
		}
	}
}