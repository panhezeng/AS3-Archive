package com.raytoon.cannonfodder.tools.effects
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;

	public class BlitPlayer
	{
		private var _frames:Array;
		private var _index:uint;
		private var _data:BitmapData;
		private var _frame:int;
		private var _rects:Array;
		private var _timer:Timer;
		private var _loop:Boolean;
		private var _canvas:Bitmap;

		/** 
		 * @param width 宽度; 
		 * @param height 高度; 
		 */
		public function BlitPlayer(width:uint, height:uint)
		{
			if(width > 0 && height > 0)
			{
				_canvas = new Bitmap();
				_canvas.bitmapData = new BitmapData(width, height);
				_frame = -1;
				_timer = new Timer(80);
				_rects = new Array();
			}
			else
			{
				throw Error("width和height值无效! ");
			}
		}

		/** 
		 * 总数; 
		 */
		public function get total():uint
		{
			return _rects.length;
		}

		/** 
		 * 当前帧数; 
		 */
		public function get frame():uint
		{
			return _frame;
		}

		/** 
		 * 跳转帧 
		 * @param value 帧 
		 */
		public function set frame(value:uint):void
		{
			if(_rects == null || _rects.length == 0) return;
			stop();
			goto(value);
		}

		/** 
		 * 设置位图块 
		 * @param value 位图; 
		 */
		public function set data(value:BitmapData):void
		{
			if(value == null || value.width < 1 || value.height < 1)
			{
				return;
			}
			clear();
			_data = value;
			var mw:uint = Math.ceil(_data.width / _canvas.bitmapData.width);
			var mh:uint = Math.ceil(_data.height / _canvas.bitmapData.height);
			for(var j:uint = 0;j < mh;j++)
			{
				for(var i:uint = 0;i < mw;i++)
				{
					_rects.push(new Rectangle(i * _canvas.bitmapData.width, j * _canvas.bitmapData.height, _canvas.bitmapData.width, _canvas.bitmapData.height));
				}
			}
		}

		/** 
		 * 播放 
		 * @param loop 循环 
		 * @param frames 播放帧组 
		 * @param delay 间隔时间 
		 */
		public function play(loop:Boolean = false, frames:Array = null, delay:int = 80):void
		{
			if(_data == null) return;
			_loop = loop;
			_frames = frames;
			if(_frames == null || _frames.length == 0)
			{
				_frames = [];
				for(var i:uint = 0;i < _rects.length;i++)
				{
					_frames.push(i);
				}
			}
			_index = 0;
			goto(_frames[_index]);
			_timer.delay = delay;
			if(_frames.length > 1)
			{
				_timer.addEventListener(TimerEvent.TIMER, timerHandler);
				_timer.start();
			}
			else
			{
				loop = false;
			}
		}

		/** 
		 * 位置 
		 * @param x 
		 * @param y 
		 */
		public function move(x:int, y:int):void
		{
			_canvas.x = x;
			_canvas.y = y;
		}

		/** 
		 * 关闭 
		 */
		public function dispose():void
		{
			clear();
			_canvas.bitmapData.dispose();
		}

		private function clear():void
		{
			_rects = [];
			_frames = [];
			_frame = -1;
			stop();
			_canvas.bitmapData = new BitmapData(_canvas.bitmapData.width, _canvas.bitmapData.height, _canvas.bitmapData.transparent);
		}

		private function stop():void
		{
			if(_timer.running)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, timerHandler);
				_timer = null;
			}
		}

		private function goto(frame:uint):void
		{
			if(frame > _rects.length - 1)
			{
				return;
			}
			if(_frame == frame)
			{
				return;
			}
			_frame = frame;
			_canvas.bitmapData.copyPixels(_data, _rects[_frame], new Point(), null, null, false);
		}
		public static const EFFECT_MOVIE_COMPLETE:String = "effectMovieComplete";//特效播放完毕
		private function timerHandler(event:TimerEvent):void
		{
			if(_index < _frames.length - 1)
			{
				_index++;
			}
			else
			{
				_index = 0;
				if(!_loop)
				{
					stop();
					_canvas.dispatchEvent(new Event(EFFECT_MOVIE_COMPLETE));
					return;
				}
			}
			goto(_frames[_index]);
		}

		public function get canvas():Bitmap
		{
			return _canvas;
		}
	}
}  