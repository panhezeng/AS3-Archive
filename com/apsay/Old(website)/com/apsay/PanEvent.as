package com.apsay
{
	import flash.events.Event;
	public class PanEvent extends Event
	{
		public static const COMPLETE:String = "complete";
		public var obj:Object;
		public var text:String;

		public function PanEvent(type:String,
		                                 bubbles:Boolean = false,
		                                 cancelable:Boolean = false,
																		 obj:Object = null,
		                                 text:String = "")
		{
			super(type, bubbles, cancelable);
			this.obj = obj;
			this.text = text;
		}
		// Every custom event class must override clone( )
		public override function clone( ):Event
		{
			return new PanEvent(type, bubbles, cancelable, obj, text);
		}
		// Every custom event class must override toString( ).
		public override function toString( ):String
		{
			return formatToString("PanEvent", "type", "bubbles",
			                            "cancelable", "eventPhase", "obj", "text");
		}
	}
}