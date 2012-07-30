package com.raytoon.cannonfodder.puremvc.view.ui.newUserLayer {
	import com.raytoon.cannonfodder.tools.utils.EventNameList;
	import com.raytoon.cannonfodder.tools.utils.GlobalVariable;
	import com.raytoon.cannonfodder.tools.utils.UIClass;
	import com.raytoon.cannonfodder.tools.utils.UICommand;
	import com.raytoon.cannonfodder.tools.utils.UICreate;
	import com.raytoon.cannonfodder.tools.utils.UIDataFunList;
	import com.raytoon.cannonfodder.tools.xml.XMLSource;
	import flash.filters.GlowFilter;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;

	/**
	 * ...
	 * @author ...
	 */
	public class NewUserGiftLayer extends Sprite {
		private var _newUserGiftPanel : Object;
		private var _giftArr : Array = [];

		public function NewUserGiftLayer() {
			UICreate.addShield({par:this,index:0});
			var _mclass : Class = ApplicationDomain.currentDomain.getDefinition("NewUserGiftPanel") as Class;
			_newUserGiftPanel = new _mclass();
			addChild(_newUserGiftPanel as DisplayObject);
			_mclass = null;
			
			_newUserGiftPanel["txt"].text = String(XMLSource.getXMLSource("UISite.xml").userLevelGift.title);
			_newUserGiftPanel["level5"].typeName = "level5";
			_newUserGiftPanel["level10"].typeName = "level10";
			_newUserGiftPanel["level15"].typeName = "level15";
			_newUserGiftPanel["level5"].level = "5";
			_newUserGiftPanel["level10"].level = "10";
			_newUserGiftPanel["level15"].level = "15";
			_giftArr.push(_newUserGiftPanel["level5"]);
			_giftArr.push(_newUserGiftPanel["level10"]);
			_giftArr.push(_newUserGiftPanel["level15"]);
			_newUserGiftPanel.x = (GlobalVariable.STAGE_WIDTH - _newUserGiftPanel.width) >> 1;
			_newUserGiftPanel.y = (GlobalVariable.STAGE_HEIGHT - _newUserGiftPanel.height) >> 1;
			_mclass = ApplicationDomain.currentDomain.getDefinition("com.paohui.ui.mc.Close") as Class;
			var _submit : Object = new _mclass();
			_newUserGiftPanel["btnPanel"].addChild(_submit);
			_mclass = null;
			_submit.typeName = "close";
			_submit.addEventListener(MouseEvent.CLICK, closePanel);
			showGift();
		}

		private function closePanel(event : MouseEvent) : void {
			parent.removeChild(this);
		}

		private var _num : int = 1;
		private var _level : int = 1;

		private function showGift() : void {
			_num = int(XMLSource.getXMLSource("GiftBag.xml").gift.(@id == int(UICommand.t.userData[1][16])).@useLevel);
			_level = UICommand.t.userData[1][2] as int;
			var _mclass:Class = ApplicationDomain.currentDomain.getDefinition("com.paohui.ui.icon.Ring") as Class;
			if (_newUserGiftPanel) {
				for each (var obj:Object in _giftArr) {
					obj.formID = int(XMLSource.getXMLSource("GiftBag.xml").gift.(@useLevel == obj.level).formList);
					obj.nextID = int(XMLSource.getXMLSource("GiftBag.xml").gift.(@useLevel == obj.level).@nextID);
					obj.ID = int(XMLSource.getXMLSource("GiftBag.xml").gift.(@useLevel == obj.level).@id)
					var ring:Object = new _mclass();
					obj["iconPanel"].addChild(ring);
					ring.width = ring.height = obj["iconPanel"].width;
					obj["numTxt"].text = "x" + String(XMLSource.getXMLSource("FormList.xml").formList.(@id == int(XMLSource.getXMLSource("GiftBag.xml").gift.(@useLevel == int(obj.level)).formList)).item.@count);
					obj["numTxt"].filters = [new GlowFilter(0x000000)];
					if (obj.level < _num) {
						obj["btn"].visible = false;
						obj["txt"].text = String(XMLSource.getXMLSource("UISite.xml").userLevelGift.info1);
					} else if (obj.level == _num) {
						if (_num > _level) {
							obj["btn"].visible = false;
							obj["txt"].text = String(XMLSource.getXMLSource("UISite.xml").userLevelGift.info2);
						} else {
							obj["txt"].visible = false;
							obj["btn"].addEventListener(MouseEvent.CLICK, mouseEventHandler);
						}
					} else {
						obj["btn"].visible = false;
						obj["txt"].text = String(XMLSource.getXMLSource("UISite.xml").userLevelGift.info2);
					}

					//obj.addEventListener(MouseEvent.MOUSE_OVER, mouseEventHandler);
					//obj.addEventListener(MouseEvent.MOUSE_OUT, mouseEventHandler);
				}
			}
			_mclass = null;
		}

		private function mouseEventHandler(event : MouseEvent) : void {
			var obj : Object;
			switch(event.type) {
				case MouseEvent.CLICK:
					obj = event.currentTarget.parent;
					UICommand.uiDataTransfer([ { m:UIDataFunList.SAVE_GIFT_BAG, a:[UICommand.t.userData[0]] } ], EventNameList.UI_SAVE_DATA);
					UICommand.t.userData[1][16] = obj.nextID == obj.ID ? null : obj.nextID;
					var _popInfo:String = "";
					var popXmlList : XMLList = XMLSource.getXMLSource("FormList.xml").formList
					var txmlList:XMLList = popXmlList.(@id == obj.formID);
					txmlList = popXmlList.(@id == obj.formID);
					var itemXmlList:XMLList = txmlList.item;
					_popInfo = String(XMLSource.getXMLSource("UISite.xml").phrase.reward);
					for (var j : int = 0; j < itemXmlList.length(); j++ ) {
						if (int(itemXmlList[j].@id) == 97) {
							_popInfo += (String(itemXmlList[j].@count) + String(XMLSource.getXMLSource("UISite.xml").phrase.money))
							UICommand.t.realMoney += int(itemXmlList[j].@count);
						}
					}
					_popInfo += String(XMLSource.getXMLSource("UISite.xml").task.info2);
					UICreate.popupPrompt(_popInfo);
					obj["btn"].removeEventListener(MouseEvent.CLICK, mouseEventHandler);
					obj["btn"].visible = false;
					obj["txt"].text = String(XMLSource.getXMLSource("UISite.xml").userLevelGift.info1);
					obj["txt"].visible = true;
					break;
				case MouseEvent.MOUSE_OVER:
					obj = event.currentTarget;
					var xmlList : XMLList = XMLSource.getXMLSource("FormList.xml").formList.(@id == int(XMLSource.getXMLSource("GiftBag.xml").gift.(@useLevel == int(obj.level)).formList)).item;
					var _info : String = String(XMLSource.getXMLSource("UISite.xml").phrase.reward);
					var _title : String = String(XMLSource.getXMLSource("UISite.xml").userLevelGift.info3);
					for (var i : int = 0; i < xmlList.length(); i++ ) {
						if (int(xmlList[i].@id) == 97) {
							_info += (String(xmlList[i].@count) + String(XMLSource.getXMLSource("UISite.xml").phrase.money))
						}
					}
					UICreate.createTooltips(_title, _info, obj as DisplayObject);
					break;
				case MouseEvent.MOUSE_OUT:
					var stageTop : DisplayObject = stage.getChildAt(this.stage.numChildren - 1);
					if (getQualifiedClassName(stageTop).indexOf(UIClass.TIP_PREFIX) != -1) UICommand.destroy(stageTop);
					break;
			}
		}
	}
}