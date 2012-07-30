package com.raytoon.cannonfodder.tools.net
{
	import flash.events.Event;
	
	/**
	 * @author Administrator
	 */
	public class ClientSocketEvent extends Event
	{
		
		public static const CONNECTED:String = "connected";
		public static const DISCONNECTED:String = "disconnected";
		public static const XML_DATA_OK:String = "xmlDataOk";
		public static const JSON_DATA_OK:String = "jsonDataOk";
		private var _data:Object;
		
		public function ClientSocketEvent(type:String, data:Object = null)
		{
			super(type, true);
			this._data = data;
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		override public function toString():String
		{
			return formatToString("ClientSocketEvent", "type", "bubbles", "cancelable", "data");
		}
		
		override public function clone():Event
		{
			return new ClientSocketEvent(type, data);
		}
	}
	
}
