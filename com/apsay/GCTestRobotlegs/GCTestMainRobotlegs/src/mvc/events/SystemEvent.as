package mvc.events {
	import flash.events.Event;

	/**
	 * No comments here. Basic stuff.
	 *  
	 * @author Peter Lorent peter.lorent@gmail.com
	 * 
	 */
	public class SystemEvent extends Event {
		// --------------------------------------------------------------------------
		//
		// Class Properties
		//
		// --------------------------------------------------------------------------
		public static const LOAD_MODULE : String = "loadModule";
		public static const LOADED_MODULE : String = "loadedModule";
		// --------------------------------------------------------------------------
		//
		// Instance Properties
		//
		// --------------------------------------------------------------------------
		private var _body : *;

		// --------------------------------------------------------------------------
		//
		// Initialization
		//
		// --------------------------------------------------------------------------
		public function SystemEvent(type : String, body : * = null) {
			super(type);

			_body = body;
		}

		// --------------------------------------------------------------------------
		//
		// Getters and setters
		//
		// --------------------------------------------------------------------------
		public function get body() : * {
			return _body;
		}

		// --------------------------------------------------------------------------
		//
		// Overridden API
		//
		// --------------------------------------------------------------------------
		override public function clone() : Event {
			return new SystemEvent(type, body);
		}
	}
}