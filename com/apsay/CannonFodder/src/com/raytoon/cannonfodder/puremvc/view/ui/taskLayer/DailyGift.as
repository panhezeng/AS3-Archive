package com.raytoon.cannonfodder.puremvc.view.ui.taskLayer 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.system.ApplicationDomain;
	/**
	 * ...
	 * @author ...
	 */
	public class DailyGift extends Sprite
	{
		private var _giftPanel:Object;
		public function DailyGift(giftName:String, suminfo:String,info:String, isCheck:Boolean = false) 
		{
			this.mouseChildren = false;
			this.mouseEnabled = false;
			
			var _mclass:Class = ApplicationDomain.currentDomain.getDefinition("DailyGiftElement") as Class;
			_giftPanel = new _mclass();
			addChild(_giftPanel as DisplayObject);
			_mclass = ApplicationDomain.currentDomain.getDefinition(giftName) as Class;
			var obj:Object = new _mclass();
			obj.width = 72;
			obj.height = 73;
			_giftPanel["panel"]["panel"].addChild(obj as DisplayObject);
			_giftPanel["txtPanel"]["txt"].text = info;
			_giftPanel["panel"]["txtSum"].text = "x" + suminfo;
			_giftPanel["panel"]["txtSum"].filters = [new GlowFilter(0x000000)];
			_giftPanel["txtPanel"]["checkIcon"].visible = isCheck;
			_giftPanel["txtPanel"]["checkOut"].visible = !isCheck;
			_giftPanel["txtPanel"]["check"].visible = isCheck;
			_giftPanel["panel"]["checkOut"].visible = !isCheck;
			_giftPanel["panel"]["check"].visible = isCheck;
			_giftPanel["txtPanel"]["checkIcon"].x -= _giftPanel["panel"].width/2;
			_giftPanel["txtPanel"]["checkIcon"].y += 25;
			if (isCheck) addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private var _siteFlag:Boolean = true;
		private function enterFrameHandler(event:Event):void {
			
			if (!_giftPanel) return;
			if (_siteFlag) {
				
				if (_giftPanel.y < 3)_giftPanel.y += 0.25;
				else _siteFlag = false;
			}else {
				
				if (_giftPanel.y > -3)_giftPanel.y -= 0.25;
				else _siteFlag = true;
			}
		}
		
		public function clear():void {
			
			if (hasEventListener(Event.ENTER_FRAME)) {
				removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
		}
	}

}