package com.raytoon.cannonfodder.puremvc.view.ui.taskLayer 
{
	import com.raytoon.cannonfodder.tools.utils.EventNameList;
	import com.raytoon.cannonfodder.tools.utils.GlobalVariable;
	import com.raytoon.cannonfodder.tools.utils.UICommand;
	import com.raytoon.cannonfodder.tools.utils.UICreate;
	import com.raytoon.cannonfodder.tools.utils.UIDataFunList;
	import com.raytoon.cannonfodder.tools.utils.UIName;
	import com.raytoon.cannonfodder.tools.xml.XMLSource;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.system.ApplicationDomain;
	/**
	 * ...
	 * @author ...
	 */
	public class DailyGiftLayer extends Sprite
	{
		
		private var _giftPanel:Object;
		private var _giftArr:Array = [];
		private var _num:int = 1;
		public function DailyGiftLayer() 
		{
			UICreate.addShield({par:this,index:0});
			_num = (UICommand.t.userData[1][12][1] as int) % 7 == 0? 7 :(UICommand.t.userData[1][12][1] as int) % 7;
			var _mclass:Class = ApplicationDomain.currentDomain.getDefinition("DailyGiftPanel") as Class;
			_giftPanel = new _mclass();
			_mclass = null;
			addChild(_giftPanel as DisplayObject);
			_giftPanel.x = (GlobalVariable.STAGE_WIDTH - _giftPanel.width) >> 1;
			_giftPanel.y = (GlobalVariable.STAGE_HEIGHT - _giftPanel.height) >> 1;
			
			_mclass = ApplicationDomain.currentDomain.getDefinition("com.paohui.ui.mc.Close") as Class;
			var _submit:Object = new _mclass();
			_giftPanel.addChild(_submit);
			_mclass = null;
			_submit["txt"].text = String(XMLSource.getXMLSource("UISite.xml").tax.info[6]);
			_submit.addEventListener(MouseEvent.CLICK, mouseEventHandler);
			_submit.x = _giftPanel["submit"].x;
			_submit.y = _giftPanel["submit"].y;
			_giftPanel["submit"].visible = false;
			_giftPanel["title1"].text = String(XMLSource.getXMLSource("UISite.xml").dailyGift.title1);
			//_giftPanel["title2"].text = String(XMLSource.getXMLSource("UISite.xml").dailyGift.title12);
			_giftPanel["title2"].visible = false;
			for (var i:int = 1; i <= 7; i ++ ) {
				
				var giftType:String = String(XMLSource.getXMLSource("DailyGift.xml").gift.(@day == i).giftType);
				var giftName:String = String(XMLSource.getXMLSource("DailyGift.xml").gift.(@day == i).giftName);
				var sumInfo:String = String(XMLSource.getXMLSource("DailyGift.xml").gift.(@day == i).giftSum);
				var info:String  = String(XMLSource.getXMLSource("DailyGift.xml").gift.(@day == i).info);
				switch(giftType) {
					
					case "cap":
						
						break;
						
					case "gem":
						
						break;
						
					case "prop":
						
						break;
						
					case "gift":
						
						break;
				}
				
				var _dailyGift:DailyGift = new DailyGift(giftName, sumInfo, info, i == _num ? true : false);
				_giftPanel["panel" + i.toString()].addChild(_dailyGift);
				_giftArr.push(_dailyGift);
				_dailyGift = null;
				
			}
		}
		
		private function mouseEventHandler(event:MouseEvent):void {
			
			switch (event.type) {
				
				case MouseEvent.CLICK:
					clear();
					parent.removeChild(this);
					UICreate.popupPrompt(String(XMLSource.getXMLSource("DailyGift.xml").gift.(@day == _num).giftInfo) + String(XMLSource.getXMLSource("UISite.xml").task.info2));
					UICommand.uiDataTransfer([{m:UIDataFunList.SAVE_LOGIN_REWARD, a:[UICommand.t.userData[0]]}], EventNameList.UI_SAVE_DATA);
					//UICommand.t.apiData = [UIName.JS_FEED, 106];
					//if (ExternalInterface.available) ExternalInterface.call(UIName.JS_FEED, UICommand.getAPI(), UICommand.getAPIRedirect());
					switch(String(XMLSource.getXMLSource("DailyGift.xml").gift.(@day == _num).giftType)) {
						
						case "cap":
							UICommand.t.capNum += int(XMLSource.getXMLSource("DailyGift.xml").gift.(@day ==_num).giftSum);
							break;
					}
					break;
			}
		}
		
		public function clear():void {
			
			for each(var obj:DailyGift in _giftArr) {
				obj.clear();
			}
			_giftArr = [];
		}
	}

}