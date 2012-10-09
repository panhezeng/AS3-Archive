package module.model {
	import common.ModuleMessage;

	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	/**
	 * The Module list of messages proxy.
	 * 
	 * <P>
	 * Maintains the list of <code>Message</code>. This class could
	 * be extended to write log  messages to a remote service as well.
	 * </P>
	 */
	public class ModuleMessageProxy extends Proxy {
		public static const NAME : String = "ModuleMessageProxy";

		public function ModuleMessageProxy(data : Array) {
			super(NAME, data);
		}

		/**
		 * Add a new message to the list.
		 */
		public function addMessage(message : ModuleMessage) : void {
			messages[messages.length] = message;
		}

		/**
		 * The list of messages controlled by the <code>Proxy</code> object.
		 */
		public function get messages() : Array {
			return data as Array;
		}
	}
}