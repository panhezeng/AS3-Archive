package 
{
	//loader类,1.8KB
	import flash.system.System;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.net.URLRequest;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	public class ClientLoader extends Sprite
	{
		private var _swfLoader:Loader;
		private var _progress:Sprite;
		public function ClientLoader():void
		{
			if (stage == null)
			{
				addEventListener(Event.ADDED_TO_STAGE, _init);
			}
			else
			{
				_init();

			}
		}
		private function _init(e:Event = null):void
		{
			if (hasEventListener(Event.ADDED_TO_STAGE))
			{
				removeEventListener(Event.ADDED_TO_STAGE, _init);
			}
			System.useCodePage = true;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP;
			_swfLoader = new Loader  ;
			_swfLoader.load(new URLRequest("Client.swf"));
			_swfLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, _progressHandler);
			_swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, _completeHandler);
			_progress = createProgress();
			addChild(_progress);
			_progress.x = stage.stageWidth / 2 - (_progress.width/2);
			_progress.y = stage.stageHeight / 2 - (_progress.height/2);
		}
		private function _progressHandler(e:ProgressEvent):void
		{
			var loaded:Number = e.bytesLoaded / e.bytesTotal;
			Shape(_progress.getChildAt(1)).scaleX = loaded;
			TextField(_progress.getChildAt(2)).text = int(loaded * 100) + "%";
		}
		private function _completeHandler(e:Event):void
		{
			_swfLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, _progressHandler);
			_swfLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, _completeHandler);
			removeChild(_progress);
			addChild(_swfLoader.content);
		}
		private function createProgress():Sprite
		{
			var p:Sprite = new Sprite();
			var progress_bg:Shape = new Shape();

			progress_bg.graphics.lineStyle(1, 0xcccccc);
			progress_bg.graphics.drawRect(0, 0, 101, 7);
			p.addChild(progress_bg);

			var progress_bar:Shape = new Shape();
			progress_bar.graphics.beginFill(0x999999, 1);
			progress_bar.graphics.drawRect(1, 1, 100, 6);
			progress_bar.graphics.endFill();
			p.addChild(progress_bar);
			progress_bar.scaleX = 0;

			var progress_tf:TextField = createTextField(p,105,-6,32,16);
			progress_tf.text = "0%";

			return p;
		}
		public function createTextField(o:Object, x:Number, y:Number, w:Number, h:Number, format:TextFormat=null, glowAmount:int=2):TextField
		{
			var tf:TextField = new TextField();
			var fm:TextFormat = (format != null) ? format : new TextFormat("Arial",12,0x999999,null,null,null,null,null,TextFormatAlign.RIGHT);
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
	}
}