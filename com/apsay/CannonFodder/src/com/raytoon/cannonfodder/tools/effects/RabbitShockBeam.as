package com.raytoon.cannonfodder.tools.effects
{
	import flash.filters.GlowFilter;
	import flash.display.BlendMode;
	import flash.events.Event;
	import flash.display.Sprite;

	import  com.raytoon.cannonfodder.tools.effects.RabbitLightning;

	/**
	 * @author Administrator
	 */
	public class RabbitShockBeam extends Sprite
	{
		public var l:RabbitLightning;
		private var _startX:Number;
		private var _startY:Number;
		private var _endX:Number;
		private var _endY:Number;
		private var _vars:Object;
		public function RabbitShockBeam(startX:Number, startY:Number, endX:Number, endY:Number, vars:Object = null)
		{
			if(stage)
			{
				_init();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, _init);
			}
			_set(startX, startY, endX, endY, vars);
		}
		private function _set(startX:Number, startY:Number, endX:Number, endY:Number, vars:Object):void
		{
			_startX = startX ? startX : 10;
			_startY = startY ? startY : stage.stageHeight / 2;
			_endX = endX ? endX : 90;
			_endY = endY ? endY : stage.stageHeight / 2;
			_vars = vars ? vars : new Object();
		}
		private function _init(e:Event = null):void
		{
			if(hasEventListener(Event.ADDED_TO_STAGE))
			{
				removeEventListener(Event.ADDED_TO_STAGE, _init);
			}
			l = new RabbitLightning();
			addChild(l);
			// l.x = 10;
			// l.y = 10;

			l.filters = [new GlowFilter(0xFFFFFF, 0.9, 4, 4,1)];
			l.blendMode = BlendMode.OVERLAY;
			l.init();
			l.child_create().child_create();
			l.child_create().child_create();
			l.child_create();
			l.child_create();
			l.child_create();
			l.child_create();

			l._startX = _startX;
			l._startY = _startY;
			l._endX = _endX;
			l._endY = _endY;
			l._thickness = 0;
			l._speed1 = 0.06;
			l._speed2 = 0.08;
			l._amplitude1 = 0.4;
			l._amplitude2 = 1.1;  

			l.child_create().child_create();
			l.child_create().child_create();
			l.child_create().child_create();
			l.child_create().child_create();
			this.addEventListener(Event.ENTER_FRAME, efHandler);
		}

		private function efHandler(e:Event):void
		{
			// l._startX -= Math.random();
			// l._startY -= Math.random();
			// l._endX = mouseX;
			// l._endY = mouseY;
			l.update();
		}
	}
}
