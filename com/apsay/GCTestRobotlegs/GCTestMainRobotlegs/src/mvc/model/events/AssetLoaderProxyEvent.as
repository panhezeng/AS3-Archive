package mvc.model.events {
	import flash.events.Event;

	/**
	 * No comments here. Basic stuff.
	 * 
	 * @author Peter Lorent peter.lorent@gmail.com
	 * 
	 */
	public class AssetLoaderProxyEvent extends Event {
		// --------------------------------------------------------------------------
		//
		// Class Properties
		//
		// --------------------------------------------------------------------------
		public static const XML_CONTENT_LOADED : String = 'xmlContentLoaded';
		// --------------------------------------------------------------------------
		//
		// Instance Properties
		//
		// --------------------------------------------------------------------------
		private var _xml : XML;

		// --------------------------------------------------------------------------
		//
		// Initialization
		//
		// --------------------------------------------------------------------------
		public function AssetLoaderProxyEvent(type : String, xml : XML = null) {
			super(type);

			_xml = xml;
		}

		// --------------------------------------------------------------------------
		//
		// API
		//
		// --------------------------------------------------------------------------
		public function get xml() : XML {
			return _xml;
		}

		// --------------------------------------------------------------------------
		//
		// Overridden API
		//
		// --------------------------------------------------------------------------
		override public function clone() : Event {
			return new AssetLoaderProxyEvent(type, xml);
		}
	}
}