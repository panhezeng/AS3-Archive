package 
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.RemoveTintPlugin;

	import com.apsay.Pan;
	import com.apsay.PanEvent;

	import flash.system.System;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;

	import flash.events.Event;
	import flash.events.MouseEvent;

	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.media.SoundMixer;
	import flash.display.FrameLabel;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.net.URLLoader;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	public class Client extends Sprite
	{
		private var _pan:Pan = new Pan();
		private var _content:Object = new Object();
		private var _timeline:TimelineLite = new TimelineLite({paused:true});
		private var _timeline1:TimelineLite = new TimelineLite({paused:true});
		private var _shiQi:TextField;
		private var _forward:Boolean = true;
		private var _Link:XML;
		private var _LinkLoader:URLLoader;
		private var _pName:String;
		public function Client():void
		{
			if (stage == null)
			{
				addEventListener(Event.ADDED_TO_STAGE,_init);
			}
			else
			{
				_init();

			}
		}
		private function _init(e:Event=null):void
		{

			if (hasEventListener(Event.ADDED_TO_STAGE))
			{
				//trace(e);
				removeEventListener(Event.ADDED_TO_STAGE,_init);
			}
			TweenPlugin.activate([AutoAlphaPlugin,TintPlugin,RemoveTintPlugin]);
			_loadOrUse("Content");
			var XML_URL:String = "Link.xml";
			var myXMLURL:URLRequest = new URLRequest(XML_URL);
			_LinkLoader = new URLLoader(myXMLURL);
			_LinkLoader.addEventListener(Event.COMPLETE,_xmlLoaded);
		}
		private function _xmlLoaded(e:Event):void
		{
			//trace(_Link==null);
			_Link = XML(_LinkLoader.data);
			//trace(_Link);
		}
		private function _loadOrUse(n:String,p:String=_pan.P_LITE,o:Sprite=null):void
		{
			var obj:Sprite = (o!=null) ? o : this;
			if (_content[n] == null)
			{
				obj.addEventListener(PanEvent.COMPLETE,_complete);
				_pan.loadSWF(obj,n,p,(stage.stageWidth / 2),(stage.stageHeight / 2),0xEB5F02);
			}
			else
			{
				if (_content[n] != _content["Content"].container.getChildAt(1))
				{
					_use(n);
				}
			}
		}
		private function _use(n:String,content:Object=null):void
		{
			if (content != null)
			{
				_content[n] = content;
			}
			var labels:Array = _content[n].currentLabels;
			var frame:uint;
			var label:String;
			if (labels.length != 0)
			{
				frame = labels[0].frame;
				label = labels[0].name;
			}
			if (label == "interaction" && frame == 1)
			{
				_content[n].gotoAndStop(1);
			}
			if (n == "Content")
			{
				_pan.removeAllChild(this);
				addChild(_content[n]);
				_animation();
			}
			else
			{
				//trace(_content["Content"].container.numChildren);
				if (content != null)
				{
					var o:Sprite = (this.parent is Stage) ? this : this.parent as Sprite;
					o.removeChildAt(o.numChildren - 1);
				}
				if (_content["Content"].container.numChildren == 3)
				{
					_content["Content"].container.removeChildAt(1);
				}
				_content["Content"].container.addChildAt(_content[n],1);
				_content[n].x = -418;
				_content[n].y = -320;
				TweenLite.from(_content[n],0.5,{autoAlpha:0});
				_pan.addEvent(_content[n],_mouseEventDo,true,false);
			}
		}
		private function _complete(e:PanEvent):void
		{
			e.target.removeEventListener(PanEvent.COMPLETE,_complete);
			_use(e.text,e.obj as MovieClip);
		}
		private function _animation():void
		{
			_content["Content"].container.visible = false;
			_content["Content"].cdh.visible = false;
			_content["Content"].cdh.gotoAndStop(1);
			_shiQi = _pan.createTextField(_content["Content"].shi,82,-12,36,31,new TextFormat("Arial",18,0xea0f0f));
			var birthday:Date = new Date(2011,6,1);
			var now:Date = new Date  ;
			var distance:uint = (birthday.getTime() - now.getTime()) / 86400000;
			_shiQi.text = String(distance);
			if (distance == 0)
			{
				_content["Content"].shi.visible = false;
			}
			_timeline.append(TweenLite.from(_content["Content"].d3,0.2,{autoAlpha:0,y:"500"}));
			_timeline.append(TweenLite.from(_content["Content"].d1,0.5,{autoAlpha:0,y:"500"}));
			_timeline.append(TweenLite.from(_content["Content"].d2,0.5,{autoAlpha:0,y:"500"}));
			//_timeline.append(TweenLite.from(_content["Content"].navbg,0.2,{autoAlpha:0}));

			_timeline.appendMultiple([TweenLite.from(_content["Content"].nav,0.5,{autoAlpha:0,onComplete:_onFinishTween}),TweenLite.from(_content["Content"].zd1,0.5,{autoAlpha:0}),TweenLite.from(_content["Content"].zd2,0.2,{autoAlpha:0,scaleX:10,scaleY:10,delay:0.2}),TweenLite.from(_content["Content"].zd3,0.5,{autoAlpha:0}),TweenLite.from(_content["Content"].zd4,0.2,{autoAlpha:0,scaleX:10,scaleY:10,delay:0.2})]);
			_timeline.appendMultiple([TweenLite.from(_content["Content"].zd5,0.2,{autoAlpha:0,y:"400"}),TweenLite.from(_content["Content"].zd6,0.2,{autoAlpha:0,scaleX:0.1,scaleY:0.1,delay:0.2}),TweenLite.from(_content["Content"].zd7,0.5,{autoAlpha:0})]);
			_timeline.play();
		}

		private function _onFinishTween():void
		{
			_pan.addEvent(_content["Content"].nav,_mouseEventDo,true,false);
		}
		private function _animation1():void
		{
			_content["Content"].zd1.visible = false;
			_content["Content"].zd2.visible = false;
			_content["Content"].zd3.visible = false;
			_content["Content"].zd4.visible = false;
			_content["Content"].zd5.visible = false;
			_content["Content"].zd6.visible = false;
			_content["Content"].zd7.visible = false;
			_content["Content"].cdh.visible = true;
			_content["Content"].cdh.play();
			_content["Content"].cdh.addEventListener(Event.ENTER_FRAME,_go);
			_content["Content"].container.scaleY = 1;
			_content["Content"].container.visible = true;
			_content["Content"].container.alpha = 1;
			TweenLite.from(_content["Content"].container,0.2,{autoAlpha:0,scaleY:0.1,delay:0.2});
			TweenLite.to(_content["Content"].step,0.2,{y:"32"});
			TweenLite.to(_content["Content"].navbg,0.2,{y:"35"});
			TweenLite.to(_content["Content"].nav,0.2,{y:"35"});
		}
		private function _animation2():void
		{
			TweenLite.to(_content["Content"].container,0.2,{autoAlpha:0,scaleY:0.1,delay:0.2});
			TweenLite.to(_content["Content"].step,0.2,{y:"-32"});
			TweenLite.to(_content["Content"].navbg,0.2,{y:"-35"});
			TweenLite.to(_content["Content"].nav,0.2,{y:"-35"});
			_forward = false;
			_content["Content"].cdh.addEventListener(Event.ENTER_FRAME,_go);
		}
		private function _go(e:Event):void
		{
			var mc:MovieClip = e.target as MovieClip;
			if (_forward)
			{
				if (mc.currentFrame == mc.totalFrames)
				{
					mc.removeEventListener(Event.ENTER_FRAME,_go);
					mc.stop();
				}
			}
			else
			{
				mc.prevFrame();
				if (mc.currentFrame == 1)
				{
					mc.removeEventListener(Event.ENTER_FRAME,_go);
					mc.stop();
					_forward = true;
					_content["Content"].zd1.visible = true;
					_content["Content"].zd2.visible = true;
					_content["Content"].zd3.visible = true;
					_content["Content"].zd4.visible = true;
					_content["Content"].zd5.visible = true;
					_content["Content"].zd6.visible = true;
					_content["Content"].zd7.visible = true;
					_content["Content"].cdh.visible = false;
				}
			}
		}
		private function _mouseEventDo(e:MouseEvent):void
		{
			var targetName:String = e.target.name;
			var parentName:String = e.target.parent.name;
			var pattern:RegExp = /[a-zA-Z]+(\d+)/;
			var tNum:uint = parseInt(targetName.replace(pattern,"$1"));
			var pNum:uint;
			if (_pName!=null)
			{
				pNum = parseInt(_pName.replace(pattern,"$1"));
			}
			switch (e.type)
			{
				case MouseEvent.ROLL_OVER :
					if (parentName == "nav")
					{
						TweenLite.to(e.target,0.5,{scaleX:1.08,scaleY:1.08,tint:0xff0000});
					}
					if (e.target is TextField)
					{
						TextField(e.target).textColor = 0xff0000;
						Mouse.cursor = MouseCursor.BUTTON;
					}
					break;
				case MouseEvent.ROLL_OUT :
					if (parentName == "nav")
					{
						TweenLite.to(e.target,0.5,{scaleX:1,scaleY:1,removeTint:true});
					}
					if (e.target is TextField)
					{
						TextField(e.target).textColor = 0x000000;
						Mouse.cursor = MouseCursor.ARROW;
					}
					break;
				case MouseEvent.CLICK :
					if (targetName.indexOf("link") == -1)
					{
						if (targetName == "N0")
						{
							if (_content["Content"].cdh.currentFrame == _content["Content"].cdh.totalFrames)
							{
								_animation2();
							}
						}
						else
						{
							_pName = targetName;
							if (_content["Content"].cdh.currentFrame == 1)
							{
								_animation1();
							}
							var o:Sprite = (this.parent is Stage) ? this : this.parent as Sprite;
							_loadOrUse(targetName,_pan.P_MAX, o);
						}
					}
					else
					{
						if (_Link!=null)
						{
							trace(_Link.Row[pNum-1].Href[tNum]);
							navigateToURL(new URLRequest(_Link.Row[pNum-1].Href[tNum]),"_blank");
						}
						//trace(pNum);
						//trace(tNum);
					}
					break;
			}
		}
	}
}