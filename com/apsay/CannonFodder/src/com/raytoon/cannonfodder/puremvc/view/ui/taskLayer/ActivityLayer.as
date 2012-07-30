package com.raytoon.cannonfodder.puremvc.view.ui.taskLayer 
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Strong;
	import com.raytoon.cannonfodder.tools.utils.EventNameList;
	import com.raytoon.cannonfodder.tools.utils.UIClass;
	import com.raytoon.cannonfodder.tools.utils.UICommand;
	import com.raytoon.cannonfodder.tools.utils.UICreate;
	import com.raytoon.cannonfodder.tools.utils.UIDataFunList;
	import com.raytoon.cannonfodder.tools.utils.UIName;
	import com.raytoon.cannonfodder.tools.xml.XMLSource;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;


	/**
	 * ...
	 * @author ...
	 */
	public class ActivityLayer
	{
		private var _activity:String = "activity";
		private var _submit : String = "submit";
		private var _colse : String = "close";
		private var _task : String = "task";
		private var _experience : String = "experience";
		private var _cap : String = "cap";
		private var _taskArr : Array = [];
		private var _taskType : String = "activity";
		private var _taskID:int = 0;
		private var _dataArr:Array = [];
		private var _activityPanel:Object;
		
		private var _infoPanel:Object;
		
		private var _submitBtn:Object;
		
		private var _closeBtn:Object;
		public function ActivityLayer(activityPanel:DisplayObject) 
		{
			_dataArr = UICommand.t.userData[3][2];
			
			
			_activityPanel = activityPanel;
//			_activityPanel["activityTime"].text = "";
			var _mClass:Class = UICommand.getClass("com.paohui.ui.task.TaskContent");
			_infoPanel = new _mClass();
			_activityPanel["content"]["contentP"].addChild(_infoPanel as DisplayObject);
			_infoPanel.removeChild(_infoPanel["feedReward"]);
			_infoPanel.removeChild(_infoPanel["taskbg"]);
			_infoPanel.removeChild(_infoPanel["listNum"]);
			_infoPanel.removeChild(_infoPanel["list"]);
			
			_infoPanel["title"].text = "任务描述";
			_infoPanel["langTitleA"].text = "任务目标";
			_infoPanel["langTitleB"].text = "任务奖励";
			_infoPanel[_experience].x = _expAX;
			_infoPanel[_experience].y = _expAY;
			_infoPanel[_cap].x = _capAX;
			_infoPanel[_cap].y = _capAY;
			_mClass = null;
			
			_mClass = UICommand.getClass("com.paohui.ui.task.Receive");
			_submitBtn = new _mClass();
			_activityPanel.addChild(_submitBtn as DisplayObject);
			_submitBtn.typeName = _submit;
			_submitBtn.x = _activityPanel["content"]["submitP"].x;
			_submitBtn.y = _activityPanel["content"]["submitP"].y;
			_submitBtn.addEventListener(MouseEvent.CLICK, taskMouseEvent);
			_mClass = null;
			
			showActivityTask();
		}
		private var _taskButtonName : String;
		private function taskMouseEvent(event:MouseEvent):void {
			
			_taskButtonName = event.currentTarget.typeName;
			
			switch(_taskButtonName) {
				
				case _task:
					var _info : String = "";
					var _infoNum : String = "";
					if (event.currentTarget.dataState == 1) {
						_submitBtn.visible = true;
					} else {
						_submitBtn.visible = false;
					}
					if (event.currentTarget.dataState == 2) {
						_infoPanel["complete"].visible = true;
					} else {
						_infoPanel["complete"].visible = false;
					}
					event.currentTarget.comp.enabled = false;
					for each (var obj:* in _taskArr) {
						if (obj == event.currentTarget) continue;
						obj.comp.enabled = true;
					}
					_taskID = event.currentTarget.dataID;
					var _eventTaskXml : XML = XMLSource.getXMLSource("Event.xml");
					
					if (_taskType == _activity) {
						_info = String(_eventTaskXml.activityTask.(@id == event.currentTarget.dataID).info);
						_infoNum = String(event.currentTarget.dataSum) + "/" + String(_eventTaskXml.activityTask.(@id == event.currentTarget.dataID).sum);

						showTaskInfo(_eventTaskXml.activityTask.(@id == event.currentTarget.dataID), _info, _infoNum);
					}
					
					break;
					
				case _submit:
					taskSubmit();
					break;
			}
		}
		
		private function showActivityTask() : void {
			
			_submitBtn.visible = false;
			_taskType = _activity;
			if (!_activityPanel ||! _dataArr) return;
			removeTask();
			
			var _numY : int = 0;
			var _eventTaskXmlList : XMLList = XMLSource.getXMLSource("Event.xml").activityTask;
			for each (var _childArr:Array in _dataArr) {
				_taskID = _childArr[0] as int;
				var _taskState : int = 0;
				var _taskSum : int = int(_eventTaskXmlList.(@id == _taskID).sum);
				if (_childArr[1] == null) {
					_taskState = 2;
				} else if (_childArr[1] >= _taskSum) {
					_taskState = 1;
				}

				var _mClass : Class = UICommand.getClass("com.paohui.ui.activity.ActivityNav");
				var obj : Object = new _mClass();
				_activityPanel["content"]["navP"].addChild(obj as DisplayObject);
				obj.y = _numY;
				_numY += obj.height + 5;
				obj.dataSum = _childArr[1] != null ? _childArr[1] : _taskSum;
				obj.dataID = _taskID;
				obj.dataState = _taskState;
				obj.addEventListener(MouseEvent.CLICK, taskMouseEvent);
				obj.typeName = _task;
				if (_taskState == 0) {
					obj["taskComplete"].visible = false;
					obj["check"].visible = false;
					obj["exclamationA"].visible = false;
				} else if (_taskState == 1) {
					obj["taskComplete"].visible = false;
					obj["check"].visible = false;
					obj["exclamation"].visible = false;
					_submitBtn.visible = true;
				} else {
					obj["taskComplete"].visible = true;
					obj["check"].visible = true;
					obj["exclamation"].visible = false;
					obj["exclamationA"].visible = false;
				}
				obj["txt"].text = String(_eventTaskXmlList.(@id == _taskID).taskName);
				_taskArr.push(obj);
				_mClass = null;
				obj = null;
			}

			_taskArr[0].comp.enabled = false;

			showTaskInfo(_eventTaskXmlList.(@id == _taskArr[0].dataID), String(_eventTaskXmlList.(@id == _taskArr[0].dataID).info), String(_taskArr[0].dataSum) + "/" + String(_eventTaskXmlList.(@id == _taskArr[0].dataID).sum));

			_taskID = int(_taskArr[0].dataID);
			if (_taskArr[0].dataState != 1) {
				_submitBtn.visible = false;
			}
			if (_taskArr[0].dataState == 2) {
				_infoPanel["complete"].visible = true;
			} else {
				_infoPanel["complete"].visible = false;
			}
			
			var flag:Boolean = false;
			for each (var aObj:Object in _taskArr) {
				
				if (aObj.dataState != 2) flag = false;
			}
			
			if (flag) {
				UICommand.t.userData[3][2] = null;
			}
		}
		/**
		 * 领取按钮
		 */
		public function taskSubmit() : void {
			if (_taskType == _activity) {
				receiveRewards(false);
			}
		}
		/**
		 * 领取奖励
		 */
		public function receiveRewards(feedFlag : Boolean = true) : void {
			if (_taskType == _activity) {
				
				var _tArr : Array;
				for each (var arr:Array in _dataArr) {
					if (arr[0] == _taskID) _tArr = arr;
				}

				if (_tArr) showTipBox(_tArr[2], XMLSource.getXMLSource("Event.xml").activityTask.(@id == _taskID), _taskID);
			}
		}
		
		/**
		 * 点击领取后 弹出获得奖励提示框
		 * @param	itemsIDArr       背包已满无法在放入的物品
		 * @param	taskXmlList      当前点击的任务的信息
		 * @param	taskID           当前任务ＩＤ
		 */
		private function showTipBox(itemsIDArr : Array, taskXmlList : XMLList = null, taskID : int = 0) : void {
			var _popInfo : String = "";
			var _taskFlag : uint = 3;
			if (_taskType == _activity) {
				_taskFlag = 3;
			} 
			if (itemsIDArr == null) {
				UICommand.t.capNum += int(taskXmlList.cap);
				UICommand.changeExperience(int(taskXmlList.experience));

				
				UICommand.uiDataTransfer([{m:UIDataFunList.SAVE_TASK_END, a:[UICommand.t.userData[0], [taskID, _taskFlag, null]]}], EventNameList.UI_SAVE_DATA);
				
				if (_taskType == _activity) {
					for (var i : int = 0; i < _dataArr.length; i++ ) {
						if (_dataArr[i][0] == _taskID) _dataArr[i][1] = null;
					}
					UICommand.t.userData[3][2] = _dataArr;
					showCompleteMotion();
					showActivityTask();
				}
				_popInfo += String(taskXmlList.cap);
				_popInfo += "瓶盖、";
				_popInfo += String(taskXmlList.experience);
				_popInfo += "经验、";

				var _gID : int = 0;
				var _gIDStr:String;
				var _gIDArr:Array = [];
				var _gIDSumArr:Array = [];
				var _gIDNum:int = 0;
				_gIDStr = String(taskXmlList.rewardpropID);
				if (_gIDStr) {
					
					_gIDArr = _gIDStr.split(",");
					_gIDSumArr = String(taskXmlList.rewardpropSum).split(",");
					for each(var objp:Object in _gIDArr) {
						_gID = int(objp);
						if (_gID > 0) {
							_popInfo += String(_gIDSumArr[_gIDNum]);
							_popInfo += "个";
							_popInfo += String(XMLSource.getXMLSource("Props.xml").prop.(@id == _gID).langName);
							_popInfo += "、";
							_gID = 0;
						}
						_gIDNum ++;
					}
					
				}
				_gIDStr = null;
				_gIDArr = [];
				_gID = 0;
				_gIDNum = 0;
				_gIDSumArr = [];
				
				//_gIDStr = String(taskXmlList.equipID);
				//if (_gIDStr) {
					//
					//_gIDArr = _gIDStr.split(",");
					//_gIDSumArr = String(taskXmlList.equipSum).split(",");
					//for each(var obje:Object in _gIDArr) {
						//_gID = int(obje);
						//if (_gID > 0) {
							//_popInfo += String(_gIDSumArr[_gIDNum]);
							//_popInfo += "个";
							//_popInfo += String(XMLSource.getXMLSource("Equipment.xml").equipCategory.equip.(@id == _gID).langName);
							//_popInfo += "、";
							//_gID = 0;
						//}
						//_gIDNum ++;
					//}
					//
				//}
				//_gIDStr = null;
				//_gIDArr = [];
				//_gID = 0;
				//_gIDNum = 0;
				//_gIDSumArr = [];
				//
				//_gIDStr = String(taskXmlList.materialID);
				//if (_gIDStr) {
					//
					//_gIDArr = _gIDStr.split(",");
					//_gIDSumArr = String(taskXmlList.materialSum).split(",");
					//for each(var objm:Object in _gIDArr) {
						//_gID = int(objm);
						//if (_gID > 0) {
							//_popInfo += String(_gIDSumArr[_gIDNum]);
							//_popInfo += "个";
							//_popInfo += String(XMLSource.getXMLSource("Materials.xml").material.(@id == _gID).langName);
							//_popInfo += "、";
							//_gID = 0;
						//}
						//_gIDNum ++;
					//}
					//
				//}
				//_gIDStr = null;
				//_gIDArr = [];
				//_gID = 0;
				//_gIDNum = 0;
				//_gIDSumArr = [];
				_popInfo += String(XMLSource.getXMLSource("UISite.xml").task.info2);

			} else {
				for each (var itemsID:int in itemsIDArr) {
					var itemsType : int = int(String(itemsID).substr(0, 2));
					if (itemsType == 12 || itemsType == 13 || itemsType == 14 || itemsType == 15) {
						_popInfo += String(XMLSource.getXMLSource("Equipment.xml").equipCategory.equip.(@id == itemsID).langName);
						_popInfo += "、";
					} else if (itemsType == 16) {
						_popInfo += String(XMLSource.getXMLSource("Props.xml").prop.(@id == itemsID).langName);
						_popInfo += "、";
					} else {
						_popInfo += String(XMLSource.getXMLSource("Materials.xml").material.(@id == itemsID).langName);
					}
				}
				_popInfo += String(XMLSource.getXMLSource("UISite.xml").task.info1);
			}

			_popInfo += "。";
			_feedFlag = false;
			UICreate.popupPrompt(_popInfo);
		}
		
		
		private var _completeX : Number = 0;
		private var _completeY : Number = 0;

		/**
		 * 显示完成图标动画
		 */
		private function showCompleteMotion() : void {
			_infoPanel["complete"].visible = true;

			_completeX = _infoPanel["complete"].x;
			_completeY = _infoPanel["complete"].y;

			_infoPanel["complete"].scaleX = 5;
			_infoPanel["complete"].scaleY = 5;
			_infoPanel["complete"].x = -210;
			_infoPanel["complete"].y = 50;
			
			TweenLite.to(_infoPanel["complete"], 0.5, {x:_completeX, y:_completeY, scaleX:1, scaleY:1, ease:Back.easeIn});
		}


		
		private var _gAx : int = 30;
		private var _gBx : int = 70;
		private var _gCx : int = 105;
		private var _gDx : int = 145;
		private var _gEx : int = 180;
		private var _gy : int = 305;
		private var _gArr : Array = [];
		private var _gTxtArr : Array = [];
		private var _expAX : int = 35;
		private var _expAY : int = 260;
		private var _capAX : int = 140;
		private var _capAY : int = 260;
		private var _expBX : int = 33;
		private var _expBY : int = 257;
		private var _capBX : int = 34;
		private var _capBY : int = 280;
		private var _gAy : int = 305;
		private var _gBy : int = 305;
		private var _gAAx : int = 22;
		private var _gABx : int = 51;
		private var _gACx : int = 80;
		private var _gBAx : int = 152;
		private var _gBBx : int = 181;
		private var _gBCx : int = 210;
		private var _feedFlag : Boolean = false;

		/**
		 * 显示任务信息
		 * @param	taskXmlList
		 * @param	info
		 */
		private function showTaskInfo(taskXmlList : XMLList, info : String, infoSum : String = null, state : int = 0, feedPanel : Boolean = false) : void {
			_infoPanel["title"].text = String(taskXmlList.taskName);
			_infoPanel["info"].text = String(taskXmlList.describe);
			
			showListInfo(info, infoSum);
			_infoPanel[_experience]["num"].text = String(taskXmlList.experience);
			_infoPanel[_cap]["num"].text = String(taskXmlList.cap);

			removeGrid();
			var _gNameArr : Array = [];
			var _gSumArr : Array = [];
			
			var _gSum : int = 0;
			
			var _gID : int = 0;
			var _gIDStr:String;
			var _gIDArr:Array = [];
			var _gIDSumArr:Array = [];
			var _gIDNum:int = 0;
			_gIDStr = String(taskXmlList.rewardpropID);
			if (_gIDStr) {
				
				_gIDArr = _gIDStr.split(",");
				_gIDSumArr = String(taskXmlList.rewardpropSum).split(",");
				for each(var objp:Object in _gIDArr) {
					_gID = int(objp);
					if (_gID > 0) {
						_gNameArr.push(String(XMLSource.getXMLSource("Props.xml").prop.(@id == _gID).name));
						_gSumArr.push(int(_gIDSumArr[_gIDNum]));
						_gID = 0;
					}
					_gIDNum ++;
				}
				
			}
			_gIDStr = null;
			_gIDArr = [];
			_gID = 0;
			_gIDNum = 0;
			_gIDSumArr = [];
			//_gIDStr = String(taskXmlList.equipID);
			//if (_gIDStr) {
				//
				//_gIDArr = _gIDStr.split(",");
				//_gIDSumArr = String(taskXmlList.equipSum).split(",");
				//for each(var obje:Object in _gIDArr) {
					//_gID = int(obje);
					//if (_gID > 0) {
						//_gNameArr.push(String(XMLSource.getXMLSource("Equipment.xml").equipCategory.equip.(@id == _gID).name));
						//_gSumArr.push(int(_gIDSumArr[_gIDNum]));
						//_gID = 0;
					//}
					//_gIDNum ++;
				//}
				//
			//}
			//_gIDStr = null;
			//_gIDArr = [];
			//_gID = 0;
			//_gIDNum = 0;
			//_gIDSumArr = [];
			//_gIDStr = String(taskXmlList.materialID);
			//if (_gIDStr) {
				//
				//_gIDArr = _gIDStr.split(",");
				//_gIDSumArr = String(taskXmlList.materialSum).split(",");
				//for each(var objm:Object in _gIDArr) {
					//_gID = int(objm);
					//if (_gID > 0) {
						//_gNameArr.push(String(XMLSource.getXMLSource("Materials.xml").material.(@id == _gID).name));
						//_gSumArr.push(int(_gIDSumArr[_gIDNum]));
						//_gID = 0;
					//}
					//_gIDNum ++;
				//}
				//
			//}
			//_gIDStr = null;
			//_gIDArr = [];
			//_gID = 0;
			//_gIDNum = 0;
			//_gIDSumArr = [];
			if (_gNameArr.length == 1) {
				
				showGrid(String(_gNameArr[0]), int(_gSumArr[0]), _gCx, _gy);
				
			} else if (_gNameArr.length == 2) {
				
				showGrid(String(_gNameArr[0]), int(_gSumArr[0]), _gBx, _gy);
				showGrid(String(_gNameArr[1]), int(_gSumArr[1]), _gDx, _gy);
				
			} else if (_gNameArr.length == 3) {
				showGrid(String(_gNameArr[0]), int(_gSumArr[0]), _gAx, _gy);
				showGrid(String(_gNameArr[1]), int(_gSumArr[1]), _gCx, _gy);
				showGrid(String(_gNameArr[2]), int(_gSumArr[2]), _gEx, _gy);
			}
			_gNameArr = [];
			_gSumArr = [];
		}
		
		private var _listInfoArr:Array = [];
		private function showListInfo(info:String, infoSum:String):void {
			
			removeListInfo();
			if (!info) return;
			var _infoArr:Array = info.split(UIName.CHAR_RETURN_WRAP);
			var _infoNumArr:Array = infoSum.split(UIName.CHAR_RETURN_WRAP);
			var _infoY:int = 0;
			
			for (var i:int = 0; i < _infoArr.length; i ++ ) {
				
				var _mClass:Class = UICommand.getClass("com.paohui.ui.task.ListInfo");
				var obj:Object = new _mClass();
				_infoPanel["listPanel"].addChild(obj);
				obj.y = _infoY;
				obj["list"].htmlText = marker(String(_infoArr[i]));
				obj["listNum"].text = String(_infoNumArr[i]);
				
				obj["listNum"].width = obj["listNum"].textWidth + 5;
				obj["listNum"].x = obj["bg"].width - obj["listNum"].width;
				
				obj["list"].width = obj["listNum"].x - 5;
				obj["list"].height = obj["list"].textHeight + 5;
				_infoY += obj.height;
				_listInfoArr.push(obj);
				_mClass = null;
				obj = null;
			}
			
		}
		
		/**
		 * 自动给【】中的文字加颜色
		 */
		private function marker(_str:String):String
		{
			var pattern:RegExp;

			pattern = /【/g;
			_str = _str.replace(pattern,'<FONT COLOR="#D04000"><b>【');  
			pattern = /】/g;
			_str = _str.replace(pattern,"】</b></FONT>");  

			return _str;
		}
		
		private function removeListInfo():void {
			
			for each (var obj:Object in _listInfoArr) {
				
				_infoPanel["listPanel"].removeChild(obj);
			}
			_listInfoArr = [];
		}

		
		/**
		 * 显示奖励物品
		 * @param	gName 物品类名
		 * @param	gSum  物品数量
		 * @param	gx    物品位置x
		 * @param	gy    物品位置y
		 */
		private function showGrid(gName : String, gSum : int, gx : int, gy : int) : void {
			var _mClass : Class;
			var _obj : Object;
			var numTxt : TextField;

			_mClass = UICommand.getClass(gName);
			_obj = new _mClass();
			_infoPanel.addChild(_obj as DisplayObject);
			_obj.x = gx;
			_obj.y = gy;

			numTxt = UICommand.createTF(TextFormatAlign.RIGHT, 0xffffff, 12, "X" + String(gSum), UIName.FONT_SHOW_CARD);
			numTxt.x = _obj.width - numTxt.width;
			numTxt.y = _obj.height - 16;
			_obj.addChild(numTxt);
			_gTxtArr.push(numTxt);
			_gArr.push(_obj);
			_mClass = null;
			_obj = null;
			numTxt = null;
		}
		/**
		 * 移除奖励图标
		 */
		private function removeGrid() : void {
			_gTxtArr = [];
			for each (var obj:Object in _gArr) {
				_infoPanel.removeChild(obj);
				obj = null;
			}
			_gArr = [];
		}

		/**
		 * 移除任务
		 */
		private function removeTask() : void {
			for each (var obj:Object in _taskArr) {
				obj.removeEventListener(MouseEvent.CLICK, taskMouseEvent);
				_activityPanel["content"]["navP"].removeChild(obj);
				obj = null;
			}
			_taskArr = [];
		}
		
	}

}