package com.apsay.event
{
	import flash.events.Event;

	public class PanEvent extends Event
	{
		public static const COMPLETE:String="complete";
		public var data:Array;

		public function PanEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:Array=null)
		{
			super(type, bubbles, cancelable);
			this.data=data;
		}

		// Every custom event class must override clone( )
		public override function clone():Event
		{
			return new PanEvent(type, bubbles, cancelable, data);
		}

		// Every custom event class must override toString( ).
		public override function toString():String
		{
			return formatToString("PanEvent", "type", "bubbles", "cancelable", "eventPhase", "data");
		}
	}
}
