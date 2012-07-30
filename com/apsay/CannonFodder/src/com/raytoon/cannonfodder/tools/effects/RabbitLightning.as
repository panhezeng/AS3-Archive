package com.raytoon.cannonfodder.tools.effects
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;

	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 * @copyright Copyright Thomas John, all rights reserved 2009.
	 */
	public class RabbitLightning extends Sprite
	{
		public var bTest1:Bitmap;
		public var bTest2:Bitmap;
		public var bd1:BitmapData;
		public var bd2:BitmapData;
		public var seed1:int = 0;
		public var seed2:int = 0;
		public var aOffsetsBd1:Array;
		public var aOffsetsBd2:Array;
		public static var vStepsAll:Vector.<Point> = new Vector.<Point>();
		public var vSteps:Vector.<Point>;
		public var vChildren:Vector.<RabbitLightning> = new Vector.<RabbitLightning>();
		public var _startX:Number = 250.0;
		public var _startY:Number = 250.0;
		public var _endX:Number = 10.0;
		public var _endY:Number = 100.0;
		public var _speed1:Number = 0.02;
		public var _speed2:Number = 0.02;
		private var _steps:int = 0;
		public var _wavelength1:Number = 0.05;
		public var _wavelength2:Number = 0.4;
		public var _amplitude1:Number = 0.08;
		public var _amplitude2:Number = 0.6;
		public var _thickness:Number = 2.0;
		public var _color:Number = 0xFFFFFF;
		public var _alpha:Number = 1.0;
		public var angle:Number = 0.0;
		public var len:Number = 0.0;
		public var dx:Number = 0.0;
		public var dy:Number = 0.0;
		public var bIsChild:Boolean = false;
		public var parentLightning:RabbitLightning;
		public var _stepStart:int;
		public var _stepEnd:int;
		public var _graphics:Graphics;
		public var timer:Timer = new Timer(3000);
		public var bAllowUpdate:Boolean = true;

		public function RabbitLightning()
		{
			// _speed1 *= 0.25;
			// _speed2 *= 0.25;
			// *eManager.add(timer, TimerEvent.TIMER, timer_timerHandler, eventGroup);
			// eManager.add(eManager, Event.REMOVED, steps_removedHandler, eventGroup);
			timer.addEventListener(TimerEvent.TIMER, timer_timerHandler);
		}

		// private function steps_removedHandler(e:Event):void
		// {
		// timer_timerHandler(null);
		// }
		private function timer_timerHandler(e:Event):void
		{
			getNewStepsFromParent();

			var i:int = 0;
			var n:int = vChildren.length;

			for(i = 0; i < n; i++)
			{
				vChildren[i].getNewStepsFromParent();
			}

			timer.stop();
			timer.reset();
			timer.delay = 1000 + Math.random() * 4000;
			timer.start();
		}

		public function getNewStepsFromParent():void
		{
			_stepStart = Math.floor(Math.random() * (parentLightning.steps - 2));
			_stepEnd = _stepStart + Math.floor(Math.random() * (parentLightning.steps - _stepStart - 2)) + 2;

			// trace("getNewStepsFromParent", _stepStart, _stepEnd);

			if( _stepStart > _stepEnd || _stepStart < 0 || _stepEnd >= parentLightning.steps )
			{
				bAllowUpdate = false;
			}
			else
			{
				bAllowUpdate = true;
				steps = (_stepEnd - _stepStart) * 1;
			}
		}

		public function init():void
		{
			if( _steps <= 0 ) steps = 50;

			seed1 = Math.round(Math.random() * 100);
			seed2 = Math.round(Math.random() * 100);

			aOffsetsBd1 = [new Point(0, 0), new Point(0, 0)];
			aOffsetsBd2 = [new Point(0, 0), new Point(0, 0)];

			if( !_graphics ) _graphics = graphics;

			// if ( !bIsChild )
			// {
			// bTest1 = new Bitmap(bd1);
			// bTest1.smoothing = true;
			// bTest1.y = _endY + 100;
			// bTest1.width = 200;
			// bTest1.height = 200;
			// addChild(bTest1);
			//
			// bTest2 = new Bitmap(bd2);
			// bTest2.smoothing = true;
			// bTest2.y = _endY + 310;
			// bTest2.width = 200;
			// bTest2.height = 200;
			// addChild(bTest2);	
			// }
		}

		public function kill():void
		{
			// *eManager.removeAllFromGroup(eventGroup);
			// removeStepsFromVector();
			timer.removeEventListener(TimerEvent.TIMER, timer_timerHandler);
		}

		public function update():void
		{
			if( !bAllowUpdate ) return;

			// _speed1 += 0.0001;
			// _speed2 += 0.0001;
			// trace(_speed1, _speed2);

			if( bIsChild )
			{
				_startX = parentLightning.vSteps[_stepStart].x;
				_startY = parentLightning.vSteps[_stepStart].y;
				_endX = parentLightning.vSteps[_stepEnd].x;
				_endY = parentLightning.vSteps[_stepEnd].y;
				angle = parentLightning.angle;
			}
			else
			{
				angle = Math.atan2(_endY - _startY, _endX - _startX);
			}

			// trace(angle);

			dx = _endX - _startX;
			dy = _endY - _startY;
			len = Math.sqrt(dx * dx + dy * dy);

			aOffsetsBd1[0].x -= _steps * _speed1;
			aOffsetsBd1[0].y += _steps * _speed1;

			aOffsetsBd2[0].x -= _steps * _speed2;
			aOffsetsBd2[0].y += _steps * _speed2;

			bd1.perlinNoise(_steps * _wavelength1, 0, 2, seed1, false, true, 0, true, aOffsetsBd1);
			bd2.perlinNoise(_steps * _wavelength2, 0, 2, seed2, false, true, 0, true, aOffsetsBd2);

			render();

			var i:int = 0;
			var n:int = vChildren.length;

			for(i = 0; i < n; i++)
			{
				vChildren[i].update();
			}
		}

		public function render():void
		{
			if( !bIsChild )
			{
				_graphics.clear();
				_graphics.lineStyle(_thickness, _color, _alpha);
			}
			else
			{
				// _graphics.lineStyle(_thickness, _color, Math.random() * _alpha);
				_graphics.lineStyle(_thickness, _color, _alpha);
			}
			// _alpha = 0.25 + Math.random() * 0.75;
			// _thickness = 0.5 + Math.random() * 2.5;

			// _graphics.lineStyle(_thickness, _color, _alpha);

			_graphics.moveTo(_startX, _startY);

			var i:int = 0;
			var c:Number = 0.0;
			var cx:Number;
			var cy:Number;
			var c2:Number = 0.0;
			var cx2:Number;
			var cy2:Number;
			var m:Number = 1.0;
			var p:Point;

			for(i = 0; i < _steps; i++)
			{
				c = (bd1.getPixel(i, 0) - 0x808080) / 0xFFFFFF * len * _amplitude1;
				cx = Math.sin(angle) * c;
				cy = Math.cos(angle) * c;

				c2 = (bd2.getPixel(i, 0) - 0x808080) / 0xFFFFFF * len * _amplitude2;
				cx2 = Math.sin(angle) * c2;
				cy2 = Math.cos(angle) * c2;

				m = Math.sin((Math.PI * (i / (_steps - 1))));

				cx *= m;
				cy *= m;

				cx2 *= m;
				cy2 *= m;

				cx = _startX + dx / (_steps - 1) * i + cx + cx2;
				cy = _startY + dy / (_steps - 1) * i - cy - cy2;

				p = vSteps[i];
				p.x = cx;
				p.y = cy;

				// _graphics.lineStyle(_thickness, _color, m);

				_graphics.lineTo(cx, cy);
			}

			if( !bIsChild )
			{
				_graphics.endFill();
			}
		}

		public function child_create():RabbitLightning
		{
			var l:RabbitLightning = new RabbitLightning();
			l.setAsChild(this);
			vChildren.push(l);

			return l;
		}

		public function setAsChild(parent:RabbitLightning):void
		{
			bIsChild = true;
			parentLightning = parent;
			_graphics = parentLightning._graphics;
			if( parentLightning.parentLightning ) _thickness = parentLightning._thickness * 0.5;
			// _thickness = Math.random() * parentLightning._thickness;
			_color = parentLightning._color;
			// if( _thickness < 1 ) _alpha = parentLightning._alpha * 0.5;
			if( parentLightning.parentLightning ) _alpha = parentLightning._alpha * 0.5;
			// _alpha = parentLightning._alpha * Math.random();
			// _amplitude1 = parentLightning._amplitude1 * 0.5;
			// _amplitude2 = parentLightning._amplitude2 * (Math.random() * 2.0);
			// _speed1 = parentLightning._speed1 * -1.0;
			// _speed2 = parentLightning._speed2 * -1.0;
			// _wavelength1 = parentLightning._wavelength1 * 0.5;
			// _wavelength2 = parentLightning._wavelength2 * 0.5;
			getNewStepsFromParent();
			init();

			timer.start();
		}

		// public function removeStepsFromVector():void
		// {
		// if ( !vSteps ) return;
		//
		// var i:int = 0;
		// var n:int = vSteps.length;
		// var index:int;
		//
		// for (i = 0; i < n; i++)
		// {
		// index = vStepsAll.indexOf(vSteps[i]);
		// if ( index ) vStepsAll.splice(index, 1);
		// }
		//
		// eManager.dispatchEvent(new Event(Event.REMOVED));
		// }
		public function get steps():int
		{
			return _steps;
		}

		public function set steps(value:int):void
		{
			if( _steps == value ) return;

			// trace(_steps, value);
			// if ( vSteps ) vSteps.splice(0, vSteps.length);
			// removeStepsFromVector();
			vSteps = new Vector.<Point>(value, true);

			var i:int = 0;
			var n:int = value;
			var p:Point;

			for(i = 0; i < n; i++)
			{
				p = new Point();
				vSteps[i] = p;
				// vStepsAll.push(p);
			}

			bd1 = new BitmapData(value, 1, false);
			bd2 = new BitmapData(value, 1, false);

			_steps = value;
		}
	}
}