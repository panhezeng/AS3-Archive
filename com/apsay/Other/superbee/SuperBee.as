package com.apsay.superbee
{
	import com.apsay.event.PanEvent;
	import com.greensock.TweenLite;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.TweenPlugin;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.Timer;

	public class SuperBee extends Sprite
	{
		Multitouch.inputMode=MultitouchInputMode.TOUCH_POINT;
		private static const STATE_START:uint=1;
		private static const STATE_GAMING:uint=2;
		private static const STATE_AGAIN:uint=3;
		private var _state:uint;
		private var _touchPointIDs:Vector.<int>;
		private var _aagun:AAGun;
		private var _aagunOffsetL:uint;
		private var _aagunOffsetR:uint;
		private var _shotsLeft:int;
		private var _shotsHit:int;
		private var _airplanes:Array;
		private var _bullets:Array;
		private var _nextPlane:Timer;
		private var _planeTime:uint;
		private var _planeSpeed:Number;
		private var _altitudeArea:uint;
		private var _stageW:Number;
		private var _stageH:Number;



		public function SuperBee()
		{
			if (stage)
				_init();
			else
				addEventListener(Event.ADDED_TO_STAGE, _init);
		}

		private function _init(e:Event=null):void
		{
			TweenPlugin.activate([AutoAlphaPlugin]);
			_state=STATE_START;
			gamingUI.visible=false;
			againUI.visible=false;
			var soundBG:SoundBG=new SoundBG();
			soundBG.play(0, 1000000);
			_stageW=stage.width;
			_stageH=stage.height;
			_touchPointIDs=new Vector.<int>();
			_aagun=new AAGun();
			_aagun.y=_stageH - _aagun.height;
			_aagunOffsetL=uint(_aagun.width);
			_aagunOffsetR=uint(_stageW - _aagun.width);
			_altitudeArea=uint(stage.height / 3);
			TweenLite.from(startUI, 1, {alpha: 0});
			addEventListener(PanEvent.COMPLETE, _complete);
			stage.addEventListener(TouchEvent.TOUCH_BEGIN, _onTouchBegin);
			stage.addEventListener(TouchEvent.TOUCH_MOVE, _onTouchMove);
			stage.addEventListener(TouchEvent.TOUCH_END, _onTouchEnd);
			stage.addEventListener(TouchEvent.TOUCH_TAP, _onTouchTap);
			if (e)
				removeEventListener(Event.ADDED_TO_STAGE, _init);
		}

		private function _startAirRaid():void
		{
			_state=STATE_GAMING;
			TweenLite.to(startUI, 0.6, {autoAlpha: 0});
			gamingUI.alpha=0;
			TweenLite.to(gamingUI, 0.6, {autoAlpha: 1});
			// init score
			_shotsLeft=20;
			_shotsHit=0;
			_showGameScore();

			// create gun
			_aagun.x=(_stageW >> 1) - _aagun.width;
			gamingUI.addChild(_aagun);

			// create object arrays
			_airplanes=new Array();
			_bullets=new Array();

			// look for collisions
			addEventListener(Event.ENTER_FRAME, _checkForHits);

			// start planes flying
			_setNextPlane(600);
		}

		private function _showGameScore():void
		{
			gamingUI.showScore.text=String("得分: " + _shotsHit);
			gamingUI.showShots.text=String("子弹: " + _shotsLeft);
		}

		private function _setNextPlane(delay:Number=0):void
		{
			_nextPlane=new Timer(delay + _planeTime + Math.random() * 1000, 1);
			_nextPlane.addEventListener(TimerEvent.TIMER_COMPLETE, _newPlane);
			_nextPlane.start();
		}

		private function _newPlane(event:TimerEvent):void
		{
			// random side, speed and altitude
			if (Math.random() > .5)
			{
				var side:String="left";
			}
			else
			{
				side="right";
			}
			var altitude:Number=Math.random() * _altitudeArea;
			var speed:Number=Math.random() * 150 + _planeSpeed;

			// create plane
			var p:Airplane=new Airplane(_stageW, side, speed, altitude);
			gamingUI.addChild(p);
			_airplanes.push(p);

			// set time for next plane
			_setNextPlane();
		}

		// take a plane from the array
		private function _removePlane(plane:Airplane):void
		{
			for (var i in _airplanes)
			{
				if (_airplanes[i] == plane)
				{
					_airplanes.splice(i, 1);
					break;
				}
			}
		}

		// new bullet created
		private function _fireBullet():void
		{
			if (_shotsLeft <= 0)
				return;
			var b:Bullet=new Bullet(_aagun.x, _aagun.y, -300);
			gamingUI.addChild(b);
			_bullets.push(b);
			_shotsLeft--;
			_showGameScore();
		}


		// take a bullet from the array
		private function _removeBullet(bullet:Bullet):void
		{
			for (var i in _bullets)
			{
				if (_bullets[i] == bullet)
				{
					_bullets.splice(i, 1);
					break;
				}
			}
		}

		// check for collisions
		private function _checkForHits(event:Event):void
		{
			for (var bulletNum:int=_bullets.length - 1; bulletNum >= 0; bulletNum--)
			{
				for (var airplaneNum:int=_airplanes.length - 1; airplaneNum >= 0; airplaneNum--)
				{
					if (_bullets[bulletNum].hitTestObject(_airplanes[airplaneNum]))
					{
						_airplanes[airplaneNum].planeHit();
						_bullets[bulletNum].deleteBullet();
						_shotsHit++;
						_showGameScore();
						break;
					}
				}
			}

			if ((_shotsLeft == 0) && (_bullets.length == 0))
			{
				_endGame();
			}
		}

		// game is over, clear movie clips
		private function _endGame():void
		{
			_state=STATE_AGAIN;
			TweenLite.to(gamingUI, 0.6, {autoAlpha: 0});
			againUI.alpha=0;
			TweenLite.to(againUI, 0.6, {autoAlpha: 1});
			// remove planes
			for (var i:int=_airplanes.length - 1; i >= 0; i--)
			{
				_airplanes[i].deletePlane();
			}
			_airplanes=null;
			gamingUI.removeChild(_aagun);
			removeEventListener(Event.ENTER_FRAME, _checkForHits);
			_nextPlane.stop();
			_nextPlane=null;
			if (_shotsHit == 20)
			{
				againUI.againInfo.text="您太厉害啦！得了满分，好崇拜您喔";
			}
			else
			{
				againUI.againInfo.text="您得了" + String(_shotsHit) + "分，还差" + String(20 - _shotsHit) + "分就得满分啦，加油！您是最棒的啦！";
			}

		}

		private function _complete(ePan:PanEvent):void
		{
			if (ePan.data[0] is Airplane)
			{
				_removePlane(ePan.data[0]);
			}
			else if (ePan.data[0] is Bullet)
			{
				_removeBullet(ePan.data[0]);
			}

		}

		private function _onTouchTap(eTap:TouchEvent):void
		{
			var name:String=eTap.target.name;
			if (name == "again")
			{
				TweenLite.to(againUI, 0.6, {autoAlpha: 0});
				startUI.alpha=0;
				TweenLite.to(startUI, 0.6, {autoAlpha: 1});
			}
			else if (name == "easy" || name == "normal" || name == "difficult")
			{
				switch (name)
				{
					case "easy":
						_planeTime=1500;
						_planeSpeed=100;
						break;
					case "normal":
						_planeTime=1000;
						_planeSpeed=150;
						break;
					case "difficult":
						_planeTime=500;
						_planeSpeed=200;
						break;
				}
				_startAirRaid();
			}

		}

		private function _onTouchBegin(eBegin:TouchEvent):void
		{
			if (_state == STATE_GAMING)
				_touchPointIDs[_touchPointIDs.length]=eBegin.touchPointID;

		}

		private function _onTouchMove(eMove:TouchEvent):void
		{
			var easing:Number=16;
			if (_touchPointIDs.length && _touchPointIDs.indexOf(eMove.touchPointID) == 0)
			{
				_aagun.x+=(eMove.stageX - _aagun.x) * 2 / easing;
				if (_aagun.x < _aagunOffsetL)
				{
					_aagun.x=_aagunOffsetL;
				}
				else if (_aagun.x > _aagunOffsetR)
				{
					_aagun.x=_aagunOffsetR;
				}
			}
		}

		private function _onTouchEnd(eEnd:TouchEvent):void
		{
			var index:int;
			if (_touchPointIDs.length)
			{
				index=_touchPointIDs.indexOf(eEnd.touchPointID);
				if (index == 1)
				{
					_fireBullet();
				}
				if (index != -1)
				{
					_touchPointIDs.splice(index, 1);
				}
			}

		}

	}
}
