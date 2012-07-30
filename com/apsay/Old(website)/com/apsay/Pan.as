package com.apsay
{
	import com.greensock.TweenLite;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.ColorTransformPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.LoaderStatus;
	import com.greensock.loading.display.ProgressCircleMax;
	import com.greensock.loading.display.ProgressCircleLite;

	import com.apsay.PanEvent;

	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.display.DisplayObject;

	public class Pan
	{
		private var _swfLoader:SWFLoader;
		private var _progress:Sprite;
		private var _liteProgress:ProgressCircleLite;
		private var _maxProgress:ProgressCircleMax;
		private var _parent:Array = new Array();

		public const P_SIMPLE:String = "simple";
		public const P_LITE:String = "lite";
		public const P_MAX:String = "max";

		public function Pan():void
		{
			init();
		}
		private function init():void
		{
			TweenPlugin.activate([AutoAlphaPlugin, ColorTransformPlugin]);
		}
		public function loadSWF(o:Sprite, n:String, p:String=P_SIMPLE, x:int=0, y:int=0, c:uint=0xffffff):void
		{
			_parent[0] = o;
			_swfLoader = new SWFLoader(n+".swf",{name:n, onComplete:_completeHandler});

			switch (p)
			{
				case P_SIMPLE :
					_progress = _createProgress();
					_parent[0].addChild(_progress);
					_progress.x = x-(_progress.width/2);
					_progress.y = y-(_progress.height/2);
					TweenLite.from(_progress, .5, {autoAlpha:0});
					_swfLoader.addEventListener(LoaderEvent.PROGRESS, _progressHandler, false, 0, true);
					break;
				case P_LITE :
					_liteProgress = new ProgressCircleLite({color:c,textColor:c,radius:26,thickness:4,trackColor:0x000000,trackAlpha:0.85,trackThickness:4,autoTransition:false});
					_parent[0].addChild(_liteProgress);
					_liteProgress.mouseEnabled = false;
					_liteProgress.x = x;
					_liteProgress.y = y;
					_liteProgress.addLoader(_swfLoader);
					break;
				case P_MAX :
					_maxProgress = new ProgressCircleMax({color:c,textColor:c,bgColor:0x000000,radius:26,thickness:4,trackColor:0x000000,trackAlpha:0.85,trackThickness:4,autoTransition:false});
					_parent[0].addChild(_maxProgress);
					_maxProgress.addLoader(_swfLoader);
					break;
			}

			_swfLoader.load();

		}
		private function _progressHandler(e:LoaderEvent):void
		{
			Shape(_progress.getChildAt(1)).scaleX = e.target.progress;
			TextField(_progress.getChildAt(2)).text = int(e.target.progress * 100) + "%";
			if (_swfLoader.status != LoaderStatus.LOADING)
			{
				TweenLite.to(this, 0.5, {colorTransform:{brightness:0.5}});
			}
		}
		private function _completeHandler(e:LoaderEvent):void
		{
			_parent[0].dispatchEvent(new PanEvent(PanEvent.COMPLETE, true, false, e.target.rawContent, _swfLoader.name));
		}
		private function _createProgress():Sprite
		{
			var p:Sprite = new Sprite();
			var progress_bg:Shape = new Shape();

			progress_bg.graphics.beginFill(0x000000, 1);
			progress_bg.graphics.drawRect(0, 0, 100, 6);
			progress_bg.graphics.endFill();
			p.addChild(progress_bg);

			var progress_bar:Shape = new Shape();
			progress_bar.graphics.beginFill(0xEB5F02, 1);
			progress_bar.graphics.drawRect(0, 0, 100, 6);
			progress_bar.graphics.endFill();
			p.addChild(progress_bar);
			progress_bar.scaleX = 0;

			var progress_tf:TextField = createTextField(p,105,-7,32,16);
			progress_tf.text = "0%";

			return p;
		}
		public function createTextField(o:Sprite, x:Number, y:Number, w:Number, h:Number, format:TextFormat=null, glowAmount:int=2):TextField
		{
			var tf:TextField = new TextField();
			var fm:TextFormat;
			if (format==null)
			{
				fm = new TextFormat("Arial",12,0xEB5F02,null,null,null,null,null,TextFormatAlign.RIGHT);
			}
			else
			{
				fm = format;
			}
			tf.defaultTextFormat = fm;
			tf.x = x;
			tf.y = y;
			tf.width = w;
			tf.height = h;
			tf.selectable = false;
			if (glowAmount!=0)
			{
				tf.filters = [new GlowFilter(int(fm.color),1,glowAmount,glowAmount,1,2)];
			}
			o.addChild(tf);
			return tf;
		}
		public function addEvent(o:Object, func:Function, a:Boolean=false, r:Boolean=true):void
		{
			var max:uint = o.numChildren;
			var mc:MovieClip;
			var btn:SimpleButton;
			var txt:TextField;
			for (var i:uint = 0; i < max; i++)
			{
				if (o.getChildAt(i) is TextField)
				{
					txt = o.getChildAt(i) as TextField;
					if (a)
					{
						_mouseEventType(txt, func, true);
					}
				}
				if (o.getChildAt(i) is MovieClip)
				{
					mc = o.getChildAt(i) as MovieClip;
					if (a)
					{
						mc.buttonMode = true;
						mc.useHandCursor = true;
						mc.mouseChildren = false;
						_mouseEventType(mc, func, true);
					}
					if (r)
					{
						addEvent(mc, func);
					}
				}
				if (o.getChildAt(i) is SimpleButton)
				{
					btn = o.getChildAt(i) as SimpleButton;
					btn.addEventListener(MouseEvent.CLICK, func);
					_mouseEventType(btn, func);
				}
			}
		}
		private function _mouseEventType(o:DisplayObject, f:Function, a:Boolean = false)
		{
			o.addEventListener(MouseEvent.CLICK, f);
			if (a)
			{
				o.addEventListener(MouseEvent.ROLL_OVER, f);
				o.addEventListener(MouseEvent.ROLL_OUT, f);
			}
		}
		public function removeAllChild(o:Sprite):void
		{
			var max:uint = o.numChildren;
			for (var i:uint = 0; i < max; i++)
			{
				o.removeChildAt(0);
			}
		}
	}
}