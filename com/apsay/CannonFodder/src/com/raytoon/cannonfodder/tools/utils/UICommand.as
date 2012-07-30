package com.raytoon.cannonfodder.tools.utils {
	import avmplus.getQualifiedClassName;

	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Sine;
	import com.raytoon.cannonfodder.puremvc.model.vo.CannonFodderVO;
	import com.raytoon.cannonfodder.puremvc.view.ui.UIMain;
	import com.raytoon.cannonfodder.puremvc.view.ui.backgroundLayer.BackgroundLayer;
	import com.raytoon.cannonfodder.puremvc.view.ui.birdLayer.BirdLayer;
	import com.raytoon.cannonfodder.puremvc.view.ui.buffLayer.BuffLayer;
	import com.raytoon.cannonfodder.puremvc.view.ui.optionMainLayer.OptionMainLayer;
	import com.raytoon.cannonfodder.puremvc.view.ui.sheepLayer.SheepLayer;
	import com.raytoon.cannonfodder.puremvc.view.ui.soundLayer.SoundLayer;
	import com.raytoon.cannonfodder.puremvc.view.ui.taskLayer.TaskLayer;
	import com.raytoon.cannonfodder.puremvc.view.ui.toolsLayer.ToolsLayer;
	import com.raytoon.cannonfodder.puremvc.view.ui.toolsLayer.element.ElementReportContainer;
	import com.raytoon.cannonfodder.tools.EventBindingData;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import flash.text.Font;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;

	public class UICommand {
		private static var _t : ToolsLayer;

		/*改变音乐，音效，血条,网格开关*/
		public static function changeSetSwitch(save : Boolean = true) : void {
			var s : SoundLayer = UIMain.getInstance(SoundLayer.NAME) as SoundLayer;
			s.musicOnAndOff = t.userData[1][7];
			s.soundOnAndOff = t.userData[1][8];
			var o : OptionMainLayer = UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer;
			o.viewRect(t.userData[1][9]);
			o.viewArticleBlood = t.userData[1][10];
			if (save) uiDataTransfer([{m:UIDataFunList.SAVE_SET_SWITCH, a:[t.userData[0], [t.userData[1][7], t.userData[1][8], t.userData[1][9], t.userData[1][10]]]}], EventNameList.UI_SAVE_DATA);
		}

		/*改变开始界面UI显示*/
		public static function changeStartVisible(show : Boolean = true) : void {
			if (show) {
				(UIMain.getInstance(BackgroundLayer.NAME) as BackgroundLayer).addBackground();
				(UIMain.getInstance(BirdLayer.NAME) as BirdLayer).showBirds();
				(UIMain.getInstance(SheepLayer.NAME) as SheepLayer).showSheeps();
				t.ui[UIName.UI_MAIN_NAV].visible = show;
				t.ui[UIName.UI_SECONDARY_NAV].visible = show;
				t.ui[UIName.UI_FRIEND].visible = show;
			} else {
				(UIMain.getInstance(BackgroundLayer.NAME) as BackgroundLayer).removeBackground();
				(UIMain.getInstance(BirdLayer.NAME) as BirdLayer).removeAll();
				(UIMain.getInstance(SheepLayer.NAME) as SheepLayer).clear();
				t.ui[UIName.UI_MAIN_NAV].visible = show;
				t.ui[UIName.UI_SECONDARY_NAV].visible = show;
				t.ui[UIName.UI_FRIEND].visible = show;
			}
		}

		/*开始界面改变中间导航按钮状态*/
		public static function changeMainNav() : void {
			var nav : Object = (t.ui[UIName.UI_MAIN_NAV] as Object).nav;
			var disable : Object = (t.ui[UIName.UI_MAIN_NAV] as Object).disable;
			var max : uint = nav.numChildren;
			var xmlList : XMLList = UIXML.uiXML.mainNav;
			var navChild : Object;
			var disableChild : Object;
			var showDisable : Boolean;
			var eventDisable : Boolean;
			for (var i : uint = 0; i < max; i++) {
				navChild = nav.getChildAt(i);
				disableChild = disable.getChildAt(i);
				if (navChild.name == UIName.E_OPEN_TOP) {
					if (!t.userData[1][15] && (t.userData[1][14] < uint(xmlList[navChild.name].open))) {
						showDisable = true;
						disableChild.addEventListener(MouseEvent.CLICK, t.mouseEvent);
					}
				} else {
					if (t.userData[1][2] < uint(xmlList[navChild.name].open)) showDisable = true;
				}
				if (showDisable) {
					eventDisable = true;
					navChild.visible = false;
					disableChild.visible = true;
				} else {
					navChild.visible = true;
					disableChild.visible = false;
					if (navChild.name == UIName.E_TAX_START) {
						if (t.userData[4] != null && t.userData[4][1] == null && !t.ui[UIName.UI_MAIN_NAV].getChildByName(UIName.E_TAX_START)) UICreate.getTaxReceive();
					}
				}
				showDisable = false;
			}
			if (eventDisable) {
				disable.addEventListener(MouseEvent.MOUSE_OVER, t.mouseEvent);
				disable.addEventListener(MouseEvent.MOUSE_OUT, t.mouseEvent);
			}
		}

		/*开始界面改变左边和下部导航按钮状态*/
		public static function changeSecondaryNav() : void {
			taskStateJudge();
			var down : Sprite = (t.ui[UIName.UI_SECONDARY_NAV] as Object).down;
			if (t.userData[1][2] > uint(UIXML.uiXML.mainNav.openReport.open[0]) && t.userData[1][13] && !Boolean(down.getChildByName(UIClass.RECEIVE_A))) {
				var reportReceive : Sprite = getInstance(UIClass.RECEIVE_A);
				reportReceive.name = UIClass.RECEIVE_A;
				reportReceive.x = (down as Object).position.x;
				reportReceive.y = (down as Object).position.y;
				down.addChild(reportReceive);
			}
		}

		/*判断是否有任务完成并执行相应动作*/
		public static function taskStateJudge() : void {
			var openTask : Sprite = (t.ui[UIName.UI_SECONDARY_NAV] as Object).openTask;
			var openTaskA : DisplayObject = openTask.getChildAt(0);
			var openTaskB : DisplayObject = openTask.getChildAt(1);
			var receive : Boolean = false;
			var eventReceive : Boolean = false;
			var sum : uint;
			var index : uint = 0;
			var i : uint;
			var j : uint;
			var data : Array;
			var len : uint;
			for (j = 0; j < 4; j++) {
				index = j;
				if (index == 3) index = 4;
				data = t.userData[3][index];
				if (data != null) {
					len = data.length;
					for ( i = 0; i < len; i++) {
						if (data[i][1] != null && index != 1) {
							sum = uint(UIXML.mainTaskXML.childTask.(@id == data[i][0]).sum[0]);
							if (data[i][1] == sum) {
								if (index == 2) {
									eventReceive = true;
								} else {
									receive = true;
								}
								break;
							}
						} else if (data[i][1] == null && index == 1) {
							receive = true;
							break;
						}
					}
				}
			}
			// if (t.userData[3][1] != null) {
			// if (t.userData[3][1][0] != null && t.userData[3][1][1] == null) receive = true;
			// }
			if (receive) {
				openTaskA.visible = false;
				openTaskB.visible = true;
				if (t.userData[3][3] != null && t.userData[3][3] > 6005 && t.stateFirst != UIState.TASK) UITransition.inTask();
			} else {
				openTaskA.visible = true;
				openTaskB.visible = false;
			}
			var openActivity : DisplayObject = t.ui[UIName.UI_SECONDARY_NAV].getChildByName(UIName.E_OPEN_ACTIVTITY);
			if (t.userData[3][2] != null) {
				if (openActivity == null) {
					openActivity = getInstance(UIClass.OPEN_ACTIVTITY);
					openActivity.name = UIName.E_OPEN_ACTIVTITY;
					t.ui[UIName.UI_SECONDARY_NAV].addChild(openActivity);
					openActivity.x = openTask.x;
					openActivity.y = openTask.y + openTask.height + 10;
				}
				var openActivityA : DisplayObject = (openActivity as Sprite).getChildAt(0);
				var openActivityB : DisplayObject = (openActivity as Sprite).getChildAt(1);
				if (eventReceive) {
					openActivityA.visible = false;
					openActivityB.visible = true;
				} else {
					openActivityA.visible = true;
					openActivityB.visible = false;
				}
			} else {
				if (openActivity) t.ui[UIName.UI_SECONDARY_NAV].removeChild(openActivity);
			}
			var openGiftBag : Sprite = (t.ui[UIName.UI_SECONDARY_NAV] as Object).openGiftBag;
			var openGiftBagA : DisplayObject = openGiftBag.getChildAt(0);
			var openGiftBagB : DisplayObject = openGiftBag.getChildAt(1);
			var useLevel : uint;
			if (t.userData[1][16] != null) {
				openGiftBag.visible = true;
				useLevel = uint(UIXML.giftBagXML.gift.(@id == t.userData[1][16]).@useLevel);
				if (t.userData[1][2] < useLevel) {
					openGiftBagA.visible = true;
					openGiftBagB.visible = false;
				} else {
					openGiftBagA.visible = false;
					openGiftBagB.visible = true;
				}
				if (t.userData[3][2] != null && openActivity) {
					openGiftBag.x = openActivity.x;
					openGiftBag.y = openActivity.y + openActivity.height + 10;
				}
			} else {
				openGiftBag.visible = false;
			}
			taskGuide();
		}

		/*改变选择地图界面UI显示*/
		public static function changeSelectMap(data : Array) : void {
			var mapsXmlList : XMLList = UIXML.mapXML.maps;
			var defence : Sprite = (t.ui[UIName.UI_SELECT_MAP] as Object).defence as Sprite;
			var defenceMax : uint = defence.numChildren;
			var defenceLen : uint = data.length;
			var defenceChild : Object;
			var defenceId : uint;
			var defenceMaxId : uint = uint(mapsXmlList[mapsXmlList.length() - 1].@id);
			var string : String;
			var i : uint;
			for (i = 0; i < defenceMax; i++) {
				defenceChild = defence.getChildAt(i);
				if (i < defenceLen) {
					defenceId = data[i][0];
					defenceChild.dataMapID = defenceId;
					/*(评分数C-0,B-1,A-2,S-3,[]打第一关length=0,打过是该关卡的评分数,当length==关卡数则完成)*/
					defenceChild.dataPVE = data[i][1];
					defenceChild.dataMapName = String(mapsXmlList.(@id == defenceId).mapName[0]);
					defenceChild.comp.enabled = true;
				} else {
					defenceId++;
					_addDefenceMapEasyHit();
				}
			}

			/*添加选择地图界面布防按钮热区*/
			function _addDefenceMapEasyHit() : void {
				if (defenceId > defenceMaxId) {
					string = String(UIXML.uiXML.disable.info[0]);
				} else {
					string = String(mapsXmlList.(@id == defenceId).mapName[0]) + String(UIXML.uiXML.mark.bracket1[0]) + String(UIXML.uiXML.disable.info[2]) + String(UIXML.uiXML.mark.bracket2[0]);
				}
				addEasyHit(defenceChild as Sprite, string);
			}
		}

		/*移除选择地图界面热区*/
		public static function removeSelectMapEasyHit() : void {
			var defence : Sprite = (t.ui[UIName.UI_SELECT_MAP] as Object).defence as Sprite;
			remvoeEasyHit(defence);
		}

		/*选择地图TIP*/
		public static function selectMapTip(data : String) : void {
			var obj : Object = (t.ui[UIName.UI_SELECT_MAP] as Object).mapName;
			obj.visible = true;
			obj.alpha = 1;
			obj.scaleX = 1;
			TweenLite.from(obj, 0.1, {alpha:0, scaleX:0});
			obj.txt.text = data;
		}

		/*领取物品结果提示*/
		public static function rewardResult(data : Array, noGive : Boolean = false) : String {
			var max : uint = data.length;
			var num : uint;
			var xmlList : XMLList;
			var yes : String;
			var no : String;
			var txt : String = "";
			var goodsid : uint;
			var other : Array = [];
			var goods : Array = [];
			var index : uint;
			var langName : String;
			for (var i : uint = 0; i < max; i++) {
				langName = String(UIXML.uiXML.mark.bracket1[0]) + UIName.HTML_RED_A + "{_NAME_}" + UIName.HTML_RED_B + String(UIXML.uiXML.mark.bracket2[0]) + " X " + t.color.red[2] + "{_SUM_}" + t.color.red[3] + String(UIXML.uiXML.mark.comma[0]);
				goodsid = data[i][0];
				langName = langName.replace("{_SUM_}", data[i][1]);
				if (goodsid > 1000) {
					num = uint(String(data[i][0]).substr(0, 2));
					switch (num) {
						case 16 :
							xmlList = UIXML.propXML.prop.(@id == data[i][0]);
							index = 0;
							break;
						case 17 :
							xmlList = UIXML.materialXML.material.(@id == data[i][0]);
							index = 1;
							break;
						default	:
							if (num < 16) {
								xmlList = UIXML.equipmentXML.equipCategory.equip.(@id == data[i][0]);
								index = 3;
							} else {
								xmlList = UIXML.gemXML.gem.(@id == data[i][0]);
								index = 2;
							}
							break;
					}
					langName = langName.replace("{_NAME_}", String(xmlList.langName[0]));
					goods[goods.length] = [index, data[i][0], data[i][1]];
				} else {
					switch (goodsid) {
						case 97 :
							langName = langName.replace("{_NAME_}", String(UIXML.uiXML.phrase.money[0]));
							break;
						case 98 :
							langName = langName.replace("{_NAME_}", String(UIXML.uiXML.phrase.cap[0]));
							break;
						case 99 :
							langName = langName.replace("{_NAME_}", String(UIXML.uiXML.phrase.experience[0]));
							break;
					}
					other[other.length] = data[i];
				}
				if (data[i][2]) {
					if (!yes) yes = String(UIXML.uiXML.prompt.reward.info2[0]) + String(UIXML.uiXML.mark.colon[0]);
					yes += langName;
				} else {
					if (!no) no = String(UIXML.uiXML.prompt.reward.info1[0]) + String(UIXML.uiXML.mark.colon[0]);
					no += langName;
				}
			}
			if (yes) {
				yes = yes.substr(0, yes.length - 1);
				txt += yes + String(UIXML.uiXML.mark.period[0]) + UIName.CHAR_BREAK;
			}
			if (no) {
				if (noGive) txt = "" ;
				var end : String = String(UIXML.uiXML.prompt.reward.info3[0]) + String(UIXML.uiXML.prompt.reward.info4[0]);
				if (t.stateFirst == UIState.WAR_PROGRESS) {
					end += String(UIXML.uiXML.prompt.reward.report[0]);
				} else {
					end += String(UIXML.uiXML.prompt.reward.info5[0]);
				}
				no = no.substr(0, no.length - 1);
				txt += no + String(UIXML.uiXML.mark.period[0]) + UIName.CHAR_BREAK + end;
			}

			if (!(no && noGive)) {
				var olen : uint = other.length;
				for (var j : uint = 0; j < olen; j++) {
					switch (other[j][0]) {
						case 97 :
							t.realMoney += uint(other[j][1]);
							break;
						case 98 :
							t.capNum += uint(other[j][1]);
							break;
						case 99 :
							changeExperience(other[j][1]);
							break;
					}
				}
				saveGoods(goods);
			}
			return txt;
		}

		/*验证结果提示*/
		public static function validation(obj : Object, info : String) : void {
			obj.alpha = 1;
			obj.visible = true;
			var txt : TextField = obj.txt as TextField;
			txt.width = obj.dataWidth;
			txt.text = info;
			txt.width = txt.textWidth + 6;
			obj.bg.width = txt.textWidth + 20;
			txt.height = txt.textHeight;
			obj.bg.height = txt.height - 4;
			TweenLite.to(obj, 0.2, {autoAlpha:0, delay:4});
		}

		/*居中对象*/
		public static function centered(o : DisplayObject, w : Number, h : Number, offsetX : Number = 0, offsetY : Number = 0) : void {
			o.x = (w >> 1) - offsetX;
			o.y = (h >> 1) - offsetY;
		}

		/*鼠标事件声音*/
		public static function mouseEventSound(e : MouseEvent) : void {
			if (e.target is Sprite) {
				if (e.type == MouseEvent.CLICK) {
					if (e.target.name == UIClass.CARD_HERO_SKILL || e.target.name.indexOf(UIName.XML_SOLDIER + UIName.CHAR_UNDERLINE) != -1 || e.target.name.indexOf(UIName.XML_TOWER + UIName.CHAR_UNDERLINE) != -1 || e.target.name.indexOf(UIName.XML_HERO + UIName.CHAR_UNDERLINE) != -1) {
						(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.BUTTON_CARD_SOUND);
					} else if (e.target.name == UIName.E_GO_WAR) {
						(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.SOUND_HORN);
					} else if (e.target.name.indexOf(UIName.E_INSTANCE) == -1) {
						(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.BUTTON_SOUND);
					}
				} else if (e.type == MouseEvent.MOUSE_OVER || e.type == MouseEvent.ROLL_OVER) {
					// if (e.target.name.indexOf(UIName.E_INSTANCE) == -1 && e.target.buttonMode) (UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.ROLL_OVER_BUTTON_SOUND);
				}
			}
		}

		/*弹出框的事件行为*/
		public static function popupEvent(currentTarget : Object, target : Object, targetName : String) : void {
			var num : int;
			var i : int;
			var sp : Sprite;
			var ObjClass : Class;
			var obj : Object;
			var objA : Object;
			var objB : Object;
			var stagePoint : Point;
			var data : Object;
			var boolean : Boolean;
			if (targetName == UIName.E_MUSIC || targetName == UIName.E_SOUND_EFFECT || targetName == UIName.E_HP || targetName == UIName.E_GRID) {
				/*用户设置弹出框的开关按钮*/
				target.selected.visible = !target.selected.visible;
				switch (targetName) {
					/*音乐开关*/
					case UIName.E_MUSIC:
						t.userData[1][7] = target.selected.visible;
						break;
					/*音效开关*/	
					case UIName.E_SOUND_EFFECT:
						t.userData[1][8] = target.selected.visible;
						break;
					/*网格开关*/	
					case UIName.E_GRID:
						t.userData[1][9] = target.selected.visible;
						break;
					/*血条开关*/	
					case UIName.E_HP:
						t.userData[1][10] = target.selected.visible;
						break;
				}
				changeSetSwitch();
			} else if ((currentTarget.name.indexOf(UIClass.POPUP_LOTTERY + UIState.LOTTERY) != -1) && target.parent.name == UIName.E_LOTTERY) {
				/*抽奖点击格子*/
				if (currentTarget.dataGoods) UITransition.lotteryTM(target, currentTarget);
			} else if ((currentTarget.name.indexOf(UIClass.POPUP_LOTTERY + UIState.GIFT) != -1) && target.parent.name == UIName.E_BOX) {
				/*选择礼包物品*/
				giftSelected(currentTarget, target);
			} else if (targetName == UIName.E_SUBMIT || targetName == UIName.E_CLOSE || targetName == UIName.E_RECHARGE) {
				switch (currentTarget.state) {
					case UIState.RECHARGE:
						if (targetName == UIName.E_SUBMIT) {
							/*充值*/
							UITransition.inPayRecharge();
						}
						break;
					case UIState.SET:
						/*用户设置*/
						if (t.stateFirst == UIState.WAR_PROGRESS) {
							/*战斗时继续和退出游戏*/
							if (targetName == UIName.E_SUBMIT) {
								if (t.stateSecond == UIState.PLAYBACK) {
									UITransition.progressToReportPlayback();
								} else {
									UICreate.popupResults(true, true);
								}
							} else if (targetName == UIName.E_CLOSE) {
								(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).startGame();
								if (t.warTimer) {
									heroSkillCDPlayOPause();
									UITransition.animationGreenSock(t.timelineLites, 1);
								}
							}
						} else if (t.stateFirst == UIState.DEFENCE) {
							/*摆塔布防界面返回选择地图界面*/
							if (targetName == UIName.E_SUBMIT) UICreate.popupPrompt(String(UIXML.uiXML.defence.close[0]), UIState.CLOSE_MAP, true);
						}
						break;
					case UIState.TOKEN:
						/*购买军令牌*/
						if (targetName == UIName.E_SUBMIT) {
							changeToken(1, 2);
						}
						break;
					case UIState.OPEN_TOP:
						/*开启排行榜*/
						if (targetName == UIName.E_SUBMIT) {
							uiDataTransfer([{m:UIDataFunList.SAVE_OPEN_TOP_LIST, a:[t.userData[0]]}], EventNameList.UI_SAVE_DATA);
							changeMoney(-uint(currentTarget.dataObj));
							t.userData[1][15] = true;
							changeMainNav();
						}
						break;
					case UIState.REMOVE_HERO:
						/*解雇英雄*/
						if (targetName == UIName.E_SUBMIT) UITransition.outHeroAttribute(currentTarget.dataObj, true);
						break;
					case UIState.PVE:
						/*PVE*/
						if (targetName == UIName.E_SUBMIT) {
							t.stateSecond = UIState.PVE;
							data = currentTarget.dataObj;
							changeToken(-data[0]);
							t.capNum -= data[1];
							t.mapData.submapId = data[2];
							if (t.userData[3][3] != null && t.userData[3][3] == 6003 && t.gameGuideData[0] == 2) {
								removeGuideHighlight();
								t.gameGuideData[0] = 3;
								t.gameGuideData[3] = [{m:UIDataFunList.SAVE_WAR_START, a:[t.userData[0], [0, data[0], data[1], 0, t.selectedRivalData[0], t.mapData.mapId, t.mapData.submapId]]}];
							} else {
								uiDataTransfer([{m:UIDataFunList.SAVE_WAR_START, a:[t.userData[0], [0, data[0], data[1], 0, t.selectedRivalData[0], t.mapData.mapId, t.mapData.submapId]]}], EventNameList.UI_SAVE_DATA);
							}
							UITransition.outHurdle(data[3]);
							UITransition.selectMapToSelectAttackRole();
						}
						break;
					case UIState.CLOSE_SELECT_ATTACT_ROLE:
						/*退出派兵界面*/
						if (targetName == UIName.E_SUBMIT) {
							UITransition.outSelectAttackRoleToOther();
						}
						break;
					case UIState.OPEN_LOCK:
						/*打开格子*/
						if (targetName == UIName.E_SUBMIT) {
							t.openLockNum++;
							openLock(false);
							if (t.stateFirst == UIState.SELECT_ATTACT_ROLE) {
								obj = (t.ui[UIName.UI_SELECT_ATTACK_ROLE] as Object).attackRole.getChildByName(UIClass.ROLE_SCROLL).scrollContent.getChildAt(1).getChildAt(1);
								if (t.expendableData && t.expendableData[1] && t.expendableData[1].length == (t.openLockNum - 1)) changeAttackRoleCard(obj as Sprite);
								boolean = true;
							} else if (t.stateFirst == UIState.HERO) {
								boolean = false;
							}
							num = currentTarget.dataObj;
							t.realMoney -= num;
							uiDataTransfer([{m:UIDataFunList.SAVE_ADD_GRID, a:[t.userData[0], [boolean, num]]}], EventNameList.UI_SAVE_DATA);
						}
						break;
					case UIState.PLAYBACK:
						/*战斗回放*/
						UITransition.progressToReportPlayback();
						break;
					case UIState.MONEY_WAR:
						/*花钱拉环打仗*/
						if (targetName == UIName.E_SUBMIT) {
							data = currentTarget.dataObj;
							UICommand.t.selectedRivalData = [data[0], data[1], data[2]];
							UICommand.t.mapData.mapId = data[3];
							UICommand.changeToken(-data[4]);
							t.capNum -= data[5];
							t.realMoney -= data[6];
							uiDataTransfer([{m:UIDataFunList.SAVE_WAR_START, a:[t.userData[0], [2, data[4], data[5], data[6], t.selectedRivalData[0], t.mapData.mapId, 0]]}], EventNameList.UI_SAVE_DATA);
							UITransition.reportToSelectAttackRole();
						}
						break;
					case UIState.AGAIN:
						/*再来一次*/
						if (targetName == UIName.E_SUBMIT) {
							num = t.getChildIndex(currentTarget as DisplayObject) - 2;
							removeShield(num - 1);
							obj = t.getChildAt(num);
							obj.removeEventListener(MouseEvent.CLICK, t.mouseEvent);
							if (obj.state != null) obj.state = null;
							if (obj.dataObj != null) obj.dataObj = null;
							destroy(obj as DisplayObject);
							UITransition.progressToSelectAttackRole();
							changeMoney(-uint(UIXML.levelXML.relate.againPrice[0]));
						}
						break;
					case UIState.RESULTS:
						/*战斗结果*/
						if (targetName == UIName.E_SUBMIT) {
							if (t.realMoney < uint(UIXML.levelXML.relate.againPrice[0])) {
								UICreate.popupPrompt(String(UIXML.uiXML.notEnough.money[0]) + String(UIXML.uiXML.mark.comma[0]) + String(UIXML.uiXML.phrase.need[0]) + String(UIXML.levelXML.relate.againPrice[0]) + String(UIXML.uiXML.phrase.money[0]), UIState.RECHARGE, true);
							} else {
								UICreate.popupPrompt(String(UIXML.uiXML.phrase.need[0]) + String(UIXML.levelXML.relate.againPrice[0]) + String(UIXML.uiXML.phrase.money[0]), UIState.AGAIN, true);
							}
							// 不执行后面移除的动作
							return;
						} else {
							data = currentTarget.dataObj;
							if (t.stateSecond != UIState.TEST_MAP) {
								data.pop();
								if (t.stateSecond != UIState.FRIEND) {
									changeExperience(data[1].dataExp);
									t.capNum += data[1].dataCap;
								}
								if (t.userData[3][3] != null && t.userData[3][3] == 6003 && t.gameGuideData[0] == 6) {
									t.gameGuideData[3].push({m:UIDataFunList.SAVE_WAR_RESULTS, a:[t.userData[0], data]});
								} else {
									uiDataTransfer([{m:UIDataFunList.SAVE_WAR_RESULTS, a:[t.userData[0], data]}], EventNameList.UI_SAVE_DATA);
								}
								uiDataTransfer([{m:UIDataFunList.GET_BUFF, a:[t.userData[0]]}]);
							}
							if (t.stateSecond == "" && data[1].dataItemSum != 0) {
								UICreate.popupLottery(data[1]);
							} else {
								_outWarProgressTo();
							}
						}
						break;
					case UIState.LOTTERY:
						/*抽奖*/
						if (targetName == UIName.E_SUBMIT) {
							uiDataTransfer([{m:UIDataFunList.SAVE_LOTTERY, a:[t.userData[0], currentTarget.dataObj.dataSave]}], EventNameList.UI_SAVE_DATA);
							UICreate.popupPrompt(rewardResult(currentTarget.dataObj.dataSave[1]), UIState.REWARD_PROMPT);
						}
						break;
					case UIState.GIFT:
						/*活动礼包*/
						if (targetName == UIName.E_SUBMIT) {
							removeGoods(1, UIDataFunList.SAVE_GIFT, currentTarget.dataGift);
						}
						break;
					case UIState.REWARD:
						/*领取奖励*/
						if (targetName == UIName.E_SUBMIT) {
							obj = currentTarget.dataObj;
							(obj.parent as ElementReportContainer).changeGetReward(obj.dataID);
							uiDataTransfer([{m:UIDataFunList.SAVE_REWARD, a:[t.userData[0], obj.dataID]}], EventNameList.UI_SAVE_DATA);
						}
						break;
					case UIState.UPGRADE:
						/*升级提示*/
						break;
					case UIState.REWARD_PROMPT:
						/*领取提示*/
						if (t.stateFirst == UIState.WAR_PROGRESS) _outWarProgressTo();
						break;
					case UIState.TASK:
						/*任务提示弹出框*/
						UICommand.uiDataTransfer([{m:UIDataFunList.GET_TASK, a:[UICommand.t.userData[0]]}]);
						break;
					case UIState.CLOSE_MAP:
						/*关闭地图*/
						if (targetName == UIName.E_SUBMIT) UITransition.defenceToSelectMap();
						break;
					case UIState.TEST_MAP:
						/*测试地图*/
						if (targetName == UIName.E_SUBMIT) {
							t.selectedRivalData = [t.userData[1][0], String(UIXML.uiXML.phrase.yourself[0]), t.userData[1][2]];
							UITransition.defenceToSelectAttackRole();
						}
						break;
					case UIState.REFRESH_MAP:
						/*刷新地图*/
						if (targetName == UIName.E_SUBMIT) {
							changeCap(-uint(UIXML.levelXML.relate.refreshMapPrice[0]));
							(t.ui[UIName.UI_DEFENCE_OPERATION] as Object).dataPaper = 0;
							setPaperNum(uint(UIXML.mapXML.maps.(@id == t.mapData.mapId).mapPaper[0]), 2);
							(UIMain.getInstance(BackgroundLayer.NAME) as BackgroundLayer).showNewMapTower();
						}
						break;
					case UIState.SAVE_MAP:
						/*保存地图*/
						if (targetName == UIName.E_SUBMIT) {
							t.apiData = [UIName.JS_FEED, 105];
							if (ExternalInterface.available) ExternalInterface.call(UIName.JS_FEED, getAPI().replace(UIName.API_MAP_NAME, String(UIXML.mapXML.maps.(@id == t.mapData.mapId).mapName[0])), getAPIRedirect());
							// 不执行后面移除的动作
							return;
						}
						break;
					case UIState.REMOVE_OBSTACLE:
						/*清除障碍*/
						if (targetName == UIName.E_SUBMIT) {
							(UIMain.getInstance(BackgroundLayer.NAME) as BackgroundLayer).removeNowObTower();
						} else if (targetName == UIName.E_CLOSE) {
							(UIMain.getInstance(BackgroundLayer.NAME) as BackgroundLayer).removeNowObTower(false);
						}
						break;
					case UIState.HERO_POWER:
						/*英雄体力恢复*/
						if (targetName == UIName.E_SUBMIT) {
							if (t.stateFirst == UIState.HERO_ATTRIBUTE) {
								obj = currentTarget.dataObj;
								data = obj.dataObj;
							} else {
								data = currentTarget.dataObj;
								data.common.disable.alpha = 0.2;
							}
							num = uint(UIXML.heroXML.heroRelate.powerMoney[0]);
							uiDataTransfer([{m:UIDataFunList.SAVE_HERO_POWER, a:[t.userData[0], [data.data[0], num]]}], EventNameList.UI_SAVE_DATA);
							t.realMoney -= num;
							num = uint(UIXML.heroLevelXML.heroLevel.level[data.data[5] - 1].power[0]);
							data.data[4] = num;
							if (data.dataPower != null) data.dataPower = num;
							if (obj) changeHeroPower(obj.content, num, num);
							if (t.expendableData[0] == null) {
								data.common.disable.visible = false;
								data.useHandCursor = true;
							} else {
								data.common.disable.visible = true;
								data.useHandCursor = false;
							}
						}
						break;
					case UIState.REFRESH_HERO:
						/*刷新英雄*/
						if (targetName == UIName.E_SUBMIT) {
							destroy((t.ui[UIName.UI_HERO] as Object).box.getChildByName(UIName.PRESENT_HERO_REFRESH));
							num = uint(UIXML.heroXML.heroRelate.refreshMoney[0]);
							uiDataTransfer([{m:UIDataFunList.GET_SERVER_TIME, a:[t.userData[0]]}, {m:UIDataFunList.GET_HERO, a:[t.userData[0], num]}]);
							t.capNum -= num;
						}
						break;
					case UIState.HIRE_HERO:
						/*雇佣购买英雄*/
						if (targetName == UIName.E_SUBMIT) {
							obj = currentTarget.dataObj;
							changeCap(-int(obj.money.text));
							/*获得雇佣英雄卡片飞往已有英雄框*/
							objA = obj.card.getChildAt(0);
							stagePoint = objA.localToGlobal(new Point(0, 0));
							objA.x = stagePoint.x;
							objA.y = stagePoint.y;
							t.addChild(objA as DisplayObject);
							destroy(obj as DisplayObject);
							sp = (t.ui[UIName.UI_HERO].getChildByName(UIName.PRESENT_HAD_HERO) as Sprite).getChildAt(0) as Sprite;
							if (sp.numChildren == 0) {
								stagePoint = sp.localToGlobal(new Point(0, 0));
								num = 0;
							} else {
								objB = sp.getChildAt(sp.numChildren - 1);
								stagePoint = objB.localToGlobal(new Point(0, 0));
								num = objB.width + 4;
							}
							TweenLite.to(objA, 0.4, {x:stagePoint.x + num, y:stagePoint.y, onComplete:UITransition.hireHeroToHadTC, onCompleteParams:[sp.parent, objA]});
							uiDataTransfer([{m:UIDataFunList.SAVE_HERO, a:[t.userData[0], [true, objA.data[0]]]}], EventNameList.UI_SAVE_DATA);
						}
						break;
					case UIState.TECH_START:
						/*科技开始*/
						if (targetName == UIName.E_SUBMIT) {
							obj = (t.ui[UIName.UI_TECH] as Object).list;
							data = [];
							data[0] = obj.dataType;
							objA = currentTarget.dataObj;
							data[2] = uint(objA.dataCap);
							t.capNum -= data[2];
							data[4] = uint(objA.dataMoney);
							t.realMoney -= data[4];
							if (objA.dataMaterials != null) {
								data[3] = objA.dataMaterials.slice();
								num = data[3].length;
								for (i = 0; i < num; i++) {
									t.bagData[1][data[3][i][2]][1] -= data[3][i][1];
									objA.dataPar.getChildByName(UIClass.TECH_MATERIAL).getChildAt(i).num.text = data[3][i][1] + UIName.CHAR_SlASH + t.bagData[1][data[3][i][2]][1];
									data[3][i].pop();
								}
								objA.dataMaterials = null;
							}
							objA.dataMoney = null;
							objA.dataCap = null;
							objA.dataPar = null;
							obj = (t.ui[UIName.UI_TECH] as Object).info;
							data[1] = obj.dataID;
							obj.condition.visible = false;
							obj.upgrading.visible = true;
							if (t.userData[3][3] != null && t.userData[3][3] < 6005 && t.gameGuideData[0] == 2) {
								removeGuideHighlight();
								t.gameGuideData[0] = 3;
								var string : String = String(UIXML.gameGuideXML.guide.(@id == t.userData[3][3]).tip.content[3]);
								UICreate.addGuideHighlight((t.ui[UIName.UI_TECH] as Object).close, string);
								t.gameGuideData[2] = [{m:UIDataFunList.GET_TECH_START_TIME, a:[t.userData[0], data]}];
								UICreate.getTechStartTime();
							} else {
								uiDataTransfer([{m:UIDataFunList.GET_TECH_START_TIME, a:[t.userData[0], data]}]);
							}
							if (objA.name == UIName.E_SUBMIT) {
								t.apiData = [UIName.JS_FEED, 102];
								if (ExternalInterface.available) ExternalInterface.call(UIName.JS_FEED, getAPI().replace(UIName.API_TECH_NAME, String(obj.langName.text)).replace(UIName.API_TECH_ICON, objA.dataClassName), getAPIRedirect());
							} else if (objA.name == UIName.E_UP) {
								t.apiData = [UIName.JS_FEED, 103];
								if (ExternalInterface.available) ExternalInterface.call(UIName.JS_FEED, getAPI().replace(UIName.API_TECH_NAME, String(obj.langName.text)).replace(UIName.API_TECH_LEVEL, objA.dataNextLevel).replace(UIName.API_TECH_ICON, objA.dataClassName), getAPIRedirect());
							}
						}
						break;
					case UIState.REMOVE_BUFF:
						/*移除道具BUFF*/
						if (targetName == UIName.E_SUBMIT) {
							changeBuff(currentTarget.dataObj, 0);
						}
						break;
					case UIState.USE_BUFF:
						/*背包使用道具BUFF*/
						if (targetName == UIName.E_SUBMIT) {
							removeGoods(1, UIDataFunList.GET_BUFF_START);
							// uiDataTransfer([{m:UIDataFunList.GET_BUFF_START, a:[t.userData[0], t.bagData[t.selectedItems[1]][t.selectedItems[2]][0]]}]);
						}
						break;
					case UIState.SALE_GOODS:
						/*背包卖出物品*/
						if (targetName == UIName.E_SUBMIT) {
							removeGoods(uint(target.parent.num.text), UIDataFunList.SAVE_SALE_GOODS);
						}
						break;
					case UIState.SHOP_CAP:
						/*商店使用瓶盖购买*/
						if (targetName == UIName.E_SUBMIT) {
							_saveShop(currentTarget.dataObj, uint(target.parent.num.text), false);
						}
						break;
					case UIState.SHOP_MONEY:
						/*商店使用真钱购买*/
						if (targetName == UIName.E_SUBMIT) {
							_saveShop(currentTarget.dataObj, uint(target.parent.num.text), true);
						}
						break;
					case UIState.TAX_START:
						/*税收开始*/
						if (targetName == UIName.E_SUBMIT) {
							t.userData[1][17]++;
							objA = UICommand.t.ui[UIName.UI_TAX].getChildByName(UIName.JS_FEED);
							if (objA.visible) objA.visible = false;
							obj = currentTarget.dataObj;
							obj.box.down2.receive.comp.enabled = false;
							t.capNum -= int(obj.box.down1.change.text);
							// changeGameMoney(-int(obj.box.down1.change.text));
							t.userData[4] = [];
							t.userData[4][0] = obj.dataID;
							uiDataTransfer([{m:UIDataFunList.GET_TAX_START_TIME, a:[t.userData[0], t.userData[4][0]]}]);
						}
						break;
					case UIState.TAX_END:
						/*税收结束*/
						if (targetName == UIName.E_SUBMIT) {
							taxReceiveOrEnd();
						}
						break;
				}
				currentTarget.removeEventListener(MouseEvent.CLICK, t.mouseEvent);
				currentTarget.removeEventListener(MouseEvent.MOUSE_OVER, t.mouseEvent);
				currentTarget.removeEventListener(MouseEvent.MOUSE_OUT, t.mouseEvent);
				/*同时要移除弹出框的操作*/
				removeShield((currentTarget as DisplayObject).parent.getChildIndex(currentTarget as DisplayObject) - 1, (currentTarget as DisplayObject).parent);
				/*移除遮罩，销毁弹出框*/
				if (currentTarget.state != null) currentTarget.state = null;
				if (currentTarget.dataObj != null) currentTarget.dataObj = null;
				TweenLite.to(currentTarget, 0.4, {y:"600", ease:Back.easeIn, onComplete:UITransition.restoreOrDestroyTC, onCompleteParams:[currentTarget]});
			}
		}

		/*好友栏*/
		public static function friendEvent(target : Object) : void {
			var targetName : String = target.name;
			var obj : Object;
			if (targetName == UIName.E_OPEN_FRIEND) {
				UITransition.inOrOutFriend();
			} else if (targetName == UIName.E_CLOSE) {
				UITransition.inOrOutFriend(false);
			} else if (targetName == UIName.E_SUBMIT || targetName.indexOf(UIName.E_ADD) != -1) {
				t.apiData = [UIName.JS_INVITE, 100];
				if (ExternalInterface.available) ExternalInterface.call(UIName.JS_INVITE, getAPI());
			} else if (targetName == UIName.E_UP || targetName == UIName.E_DOWN) {
				pagesNumEvent(t.ui[UIName.UI_FRIEND], (t.ui[UIName.UI_FRIEND] as Object).dataMax, t.ui[UIName.UI_FRIEND].getChildAt(t.ui[UIName.UI_FRIEND].numChildren - 1), targetName);
			} else if (target.parent.parent == t.ui[UIName.UI_FRIEND]) {
				t.selectedRivalData = [target.dataID, target.dataLangName, target.dataLevel, target.dataUrl];
				if (t.stateFirst == UIState.START) {
					UITransition.friendToSelectMap();
				} else {
					var friendName : Object = (t.ui[UIName.UI_SELECT_MAP] as Object).friendName;
					var txt : TextField = friendName.txt;
					txt.width = 200;
					var bg : Sprite = friendName.bg;
					txt.text = t.selectedRivalData[1] + String(UIXML.uiXML.phrase.home[0]);
					txt.width = txt.textWidth + 4;
					bg.width = (txt.x * 2) + txt.textWidth;
					var shield : Sprite = getInstance(UIClass.SHIELD);
					t.addChild(shield);
					TweenLite.to(shield, 0.2, {alpha:0, onComplete:UITransition.restoreOrDestroyTC, onCompleteParams:[shield]});
					UICommand.removeSelectMapEasyHit();
					UICommand.uiDataTransfer([{m:UIDataFunList.GET_MAP, a:[UICommand.t.userData[0], t.selectedRivalData[0]]}]);
				}
			}
		}

		/*花钱开格子弹出框*/
		public static function lockPopupEvent(price : XMLList, isHero : Boolean = true) : void {
			var num : uint = uint(price[t.openLockNum]);
			var numA : uint = t.openLockNum + 1;
			if (t.realMoney < num) {
				UICreate.popupPrompt(String(UIXML.uiXML.notEnough.money[0]) + String(UIXML.uiXML.mark.comma[0]) + String(UIXML.uiXML.phrase.need[0]) + num + String(UIXML.uiXML.phrase.money[0]), UIState.RECHARGE, true);
			} else {
				UICreate.popupPrompt(String(UIXML.uiXML.lock.info[0]).replace(UIName.VAR_A, String(UICommand.getOpenLockLevel(numA, isHero))).replace(UIName.VAR_B, String(numA)) + String(UIXML.uiXML.lock.info[1]).replace(UIName.VAR_A, String(num)), UIState.OPEN_LOCK, true, num);
			}
		}

		/*获得下个格子自动开启的等级*/
		public static function getOpenLockLevel(num : uint, isHero : Boolean = true) : uint {
			var xmlList : XMLList = UIXML.levelXML.level;
			var len : uint = xmlList.length();
			var sum : uint;
			var level : uint;
			var max : Boolean = true;
			for (var i : uint = t.userData[1][2]; i < len; i++) {
				if (isHero) {
					sum = xmlList[i].heroSum;
				} else {
					sum = xmlList[i].soldierSum;
				}
				if (num == sum) {
					level = i + 1;
					max = false;
					break;
				}
			}
			if (max) level = len + 1;
			return level;
		}

		/*使用buff或活动礼包弹出框*/
		public static function useGoodsPopupEvent() : void {
			var propXMLList : XMLList = UIXML.propXML.prop;
			var xmlList : XMLList = propXMLList.(@id == t.selectedItems[6]);
			var useLevel : uint = uint(xmlList.useLevel[0]);
			if (useLevel && t.userData[1][2] < useLevel) {
				UICreate.popupPrompt(String(UIXML.uiXML.bag.info[3]).replace(UIName.VAR_A, useLevel));
			} else {
				if (String(t.selectedItems[0]).indexOf(UIName.E_GIFT) != -1) {
					uiDataTransfer([{m:UIDataFunList.GET_GIFT, a:[t.userData[0], t.selectedItems[6]]}]);
				} else {
					var b : Boolean = false;
					if (t.userData[5] != null) {
						var max : uint = t.userData[5].length;
						var buffTypeA : String;
						var buffTypeB : String = String(xmlList.buffType[0]);
						for (var i : uint = 0; i < max; i++) {
							buffTypeA = String(propXMLList.(@id == t.userData[5][i].id).buffType[0]);
							if (buffTypeA == buffTypeB) {
								b = true;
								break;
							}
						}
					}
					if (t.userData[5] == null || !b) {
						UICreate.popupPrompt(String(UIXML.uiXML.bag.info[0]) + t.selectedItems[5] + String(UIXML.uiXML.mark.question[0]), UIState.USE_BUFF, true);
					} else if (b) {
						UICreate.popupPrompt(String(UIXML.uiXML.bag.info[1]));
					}
				}
			}
		}

		/*获得buff内容*/
		public static function getBuffContent(id : uint, surplus : uint, startTime : Number) : void {
			var data : Object = {"id":id, "surplus":surplus, "startTime":startTime};
			if (t.userData[5] == null) {
				t.userData[5] = [data];
				UICreate.initBuff();
			} else {
				t.userData[5].push(data);
				changeBuff();
			}
		}

		/*改变buff, num为0则删除此ID BUFF。计数的每使用一次调一次这个方法，计时的到时了才调 */
		public static function changeBuff(id : uint = 0, num : uint = 1) : void {
			var bf : BuffLayer = UIMain.getInstance(BuffLayer.NAME) as BuffLayer;
			if (id == 0) {
				CannonFodderVO.buffInfo.buff = t.userData[5];
				bf.showBuff();
			} else {
				if (num == 0) bf.removeBuff(id);
				var max : uint = t.userData[5].length;
				for (var i : int = max - 1; i > -1; i--) {
					if (id == t.userData[5][i].id) {
						if (num == 0) {
							t.userData[5].splice(i, 1);
							if (t.userData[5].length == 0) t.userData[5] = null;
						} else {
							t.userData[5][i].surplus--;
						}
						break;
					}
				}
				CannonFodderVO.buffInfo.buff = t.userData[5];
				uiDataTransfer([{m:UIDataFunList.SAVE_CHANGE_BUFF, a:[t.userData[0], [id, num]]}], EventNameList.UI_SAVE_DATA);
			}
		}

		/*背包界面改变数据后刷新*/
		public static function changeBag() : void {
			/*先销毁分页再销毁背包容器*/
			for (var i : uint = 0; i < 2; i++) t.ui[UIName.UI_BAG].removeChildAt(t.ui[UIName.UI_BAG].numChildren - 1);
			(t.ui[UIName.UI_BAG] as Object).submit.visible = false;
			(t.ui[UIName.UI_BAG] as Object).sale.visible = false;
			var type : String = (t.ui[UIName.UI_BAG] as Object).dataType;
			switch (type) {
				case UIName.E_ALL:
					UICreate.addBagCard(t.ui[UIName.UI_BAG], t.bagData, 45, 9, 11, 10, true, true);
					// (t.ui[UIName.UI_BAG] as Object).dataType = UIName.E_ALL;
					break;
				case UIName.E_PROP:
					UICreate.addBagCard(t.ui[UIName.UI_BAG], t.bagData[0], 45, 9, 11, 10);
					// (t.ui[UIName.UI_BAG] as Object).dataType = UIName.E_PROP;
					break;
				case UIName.E_MATERIAL:
					UICreate.addBagCard(t.ui[UIName.UI_BAG], t.bagData[1], 45, 9, 11, 10);
					// (t.ui[UIName.UI_BAG] as Object).dataType = UIName.E_MATERIAL;
					break;
				case UIName.E_GEM:
					UICreate.addBagCard(t.ui[UIName.UI_BAG], t.bagData[2], 45, 9, 11, 10);
					// (t.ui[UIName.UI_BAG] as Object).dataType = UIName.E_GEM;
					break;
				case UIName.E_EQUIPMENT:
					UICreate.addBagCard(t.ui[UIName.UI_BAG], t.bagData[3], 45, 9, 11, 10);
					// (t.ui[UIName.UI_BAG] as Object).dataType = UIName.E_EQUIPMENT;
					break;
			}
		}

		/*背包界面保存踢出数据,other:礼包-选择的物品数组*/
		public static function removeGoods(num : uint, type : String, other : Array = null) : void {
			/*data[0]类型，data[1]减数，data[2]减的总价，data[3]物品id*/
			var data : Array = [];
			data[0] = t.selectedItems[1] + 1;
			data[1] = num;
			var bag : Array = t.bagData[t.selectedItems[1]][t.selectedItems[2]];
			bag[1] -= num;
			if (type == UIDataFunList.SAVE_SALE_GOODS || type == UIDataFunList.SAVE_GIFT) {
				data[2] = num * t.selectedItems[3];
				t.capNum += data[2];
			}
			data[3] = t.selectedItems[6];
			if (bag[1] == 0) {
				t.bagData[t.selectedItems[1]].splice(t.selectedItems[2], 1);
				changeBag();
			} else {
				if (type == UIDataFunList.SAVE_SALE_GOODS || type == UIDataFunList.GET_BUFF_START) {
					t.selectedItems[4].text = "X" + String(bag[1]);
					t.selectedItems[4].height = t.selectedItems[4].textHeight + 2;
				} else if (type == UIDataFunList.SAVE_GIFT && other == null) {
					changeBag();
				}
			}
			if (type == UIDataFunList.SAVE_SALE_GOODS) {
				uiDataTransfer([{m:UIDataFunList.SAVE_SALE_GOODS, a:[t.userData[0], data]}], EventNameList.UI_SAVE_DATA);
			} else if (type == UIDataFunList.SAVE_GIFT) {
				uiDataTransfer([{m:UIDataFunList.SAVE_GIFT, a:[t.userData[0], t.selectedItems[6], other]}], EventNameList.UI_SAVE_DATA);
				if (other) UITransition.promptTextTween(40, String(UIXML.uiXML.prompt.reward.info6[0]), UIName.FONT_ART);
			} else if (type == UIDataFunList.GET_BUFF_START) {
				uiDataTransfer([{m:UIDataFunList.GET_BUFF_START, a:[t.userData[0], t.selectedItems[6]]}]);
			}
		}

		/*添加背包数据*/
		public static function saveGoods(data : Array) : void {
			var jlen : uint = data.length;
			var ilen : uint;
			var index : uint;
			var id : uint;
			var num : uint;
			for (var j : uint = 0; j < jlen; j++) {
				index = data[j][0];
				id = data[j][1];
				num = data[j][2];
				var b : Boolean = true;
				if (t.bagData[index] != null) {
					ilen = t.bagData[index].length;
					for (var i : uint = 0; i < ilen; i++) {
						if (t.bagData[index][i][0] == id) {
							t.bagData[index][i][1] += num;
							b = false;
							break;
						}
					}
				}
				if (b) {
					if (t.bagData[index] == null) t.bagData[index] = [];
					t.bagData[index][t.bagData[index].length] = [id, num];
				}
			}
		}

		/*商店界面保存购买数据*/
		private static function _saveShop(obj : Object, num : uint, money : Boolean) : void {
			var data : Array = [];
			var sum : uint;
			data[0] = obj.dataType;
			data[1] = num;
			if (money) {
				sum = obj.dataMoney * data[1];
				t.realMoney -= sum;
			} else {
				sum = obj.dataCap * data[1];
				t.capNum -= sum;
			}
			data[2] = [sum, money];
			data[3] = obj.data[0];
			var small : Object = t.getChildByName(UIClass.SMALL_BAG);
			if (small) saveGoods([[data[0] - 1, data[3], num]]);
			uiDataTransfer([{m:UIDataFunList.SAVE_SHOP, a:[t.userData[0], data]}], EventNameList.UI_SAVE_DATA);
			UITransition.promptTextTween(40, String(UIXML.uiXML.shop.info[1]), UIName.FONT_ART);
		}

		/*离开战斗界面去其他界面*/
		private static function _outWarProgressTo() : void {
			if (t.stateSecond == UIState.FRIEND || t.stateSecond == UIState.PVE) {
				if ((t.ui[UIName.UI_TOP] as Object).dataState == UIState.FRIEND) {
					(t.ui[UIName.UI_TOP] as Object).dataState = null;
					UITransition.progressToTop();
				} else {
					if (t.stateSecond == UIState.PVE) t.stateSecond = "";
					var myTimer : Timer = new Timer(400, 1);
					myTimer.start();
					myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, t.progressToSelectMapTimerComplete);
				}
			} else if (t.stateSecond == UIState.TEST_MAP) {
				UITransition.progressToDefence();
			} else {
				if ((t.ui[UIName.UI_REPORT] as Object).dataState == UIState.MONEY_WAR) {
					(t.ui[UIName.UI_REPORT] as Object).dataState = null;
					UITransition.progressToReportRevenge();
				} else {
					UITransition.progressToSelectRival();
				}
			}
		}

		/*战斗界面开始*/
		public static function initStartProgress() : void {
			t.warTimer = new Timer(1000);
			t.warTimer.addEventListener(TimerEvent.TIMER, t.warTimerHandler);
			t.warTimer.start();
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playMusic(SoundName.SOUND_ATTACK_BACKGROUND);
			UICreate.getHeroSkillCard();
			(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).startGame();
			(t.ui[UIName.UI_STOP_PLAY] as Object).stopWar.visible = true;
		}

		/*战斗界面继续*/
		public static function startProgress() : void {
			var stopWar : Object = (t.ui[UIName.UI_STOP_PLAY] as Object).stopWar;
			var playWar : Object = (t.ui[UIName.UI_STOP_PLAY] as Object).playWar;
			var option : OptionMainLayer = UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer;
			playWar.visible = false;
			if (t.mapData.playbackInfo == null) {
				stopWar.visible = true;
				removeShield(t.numChildren - 2);
				heroSkillCDPlayOPause();
				UITransition.animationGreenSock(t.timelineLites, 1);
				option.startGame();
			} else {
				stopWar.visible = false;
				(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playMusic(SoundName.SOUND_ATTACK_BACKGROUND);
				option.playbackWar(t.mapData.playbackInfo);
				t.mapData.playbackInfo = null;
			}
			// if (t.timer != null) {
			// _heroSkillCDPlayOPause();
			// UITransition.animationGreenSock(t.timelineLites, 1);
			// }
		}

		/*战斗界面暂停*/
		public static function pauseProgress() : void {
			var stopWar : Object = (t.ui[UIName.UI_STOP_PLAY] as Object).stopWar;
			var playWar : Object = (t.ui[UIName.UI_STOP_PLAY] as Object).playWar;
			if (stopWar.visible) {
				stopWar.visible = false;
				(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).pauseGame();
				playWar.visible = true;
				UICreate.addShield();
				heroSkillCDPlayOPause(false);
				UITransition.animationGreenSock(t.timelineLites, 0);
				t.setChildIndex(t.ui[UIName.UI_STOP_PLAY], t.numChildren - 1);
			}
		}

		/*战斗界面战斗时间动作*/
		public static function warProgressTime() : void {
			var throughTxt : String = (t.ui[UIName.UI_SELECT_ATTACK_ROLE] as Object).expendables.through.num.text;
			var results : Array = throughTxt.split("/");
			if (uint(results[0]) == uint(results[1])) {
				UICreate.popupResults();
			} else if (t.attackTime == 0) {
				UICreate.popupResults(true);
			} else {
				t.attackTime--;
				formatTime((t.ui[UIName.UI_DEADLINE] as Object).txt, t.attackTime % 60, uint(t.attackTime / 60));
				t.ui[UIName.UI_DEADLINE].getChildAt(0).scaleX = Number(t.attackTime / (uint(UIXML.mapXML.maps.(@id == t.mapData.mapId).attackTime[0]) + t.increaseTime));
				if (t.attackTime == 60) {
					(t.ui[UIName.UI_DEADLINE] as Object).remind.visible = true;
					(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).flashingSkillsButton();
				}
			}
		}

		/*军令刷新时间*/
		public static function getTokenRefreshTime() : void {
			/*需要小时数*/
			t.userData[2][3] = Number(UIXML.levelXML.relate.tokenRefreshTime[0]);
			/*刷新时间*/
			t.userData[2][4] = t.userData[2][2] + (t.userData[2][3] * 3600000);
		}

		/*倒计时，税收和军令牌*/
		public static function countdownRefresh(hour : Number, end : Number) : String {
			var apart : Number = Number(end - t.serverTime);
			var h : Number;
			var min : Number;
			var sec : Number;
			if (apart < 1) {
				h = 0;
			} else {
				h = int(apart / 3600000);
			}
			if (apart < 1 || (apart / 3600000) > hour) {
				min = 0;
				sec = 0;
			} else {
				min = int(apart / 60000 % 60);
				sec = int(apart / 1000 % 60);
			}
			return formatTime(null, sec, min, h);
		}

		/*英雄刷新时间*/
		public static function heroRefresh() : void {
			var now : Date = new Date();
			now.setTime(t.serverTime);
			var refreshHour : uint = uint(UIXML.heroXML.heroRelate.refreshHour[0]);
			var h : Number = refreshHour - (now.getHours() % refreshHour) - 1;
			var min : Number = 59 - now.getMinutes();
			var sec : Number = 59 - now.getSeconds();
			formatTime((t.ui[UIName.UI_HERO] as Object).time, sec, min, h);
			if (h == 0 && min == 0 && sec == 0) {
				trace("refresh");
				destroy((t.ui[UIName.UI_HERO] as Object).box.getChildByName(UIName.PRESENT_HERO_REFRESH));
				uiDataTransfer([{m:UIDataFunList.GET_SERVER_TIME, a:[t.userData[0]]}, {m:UIDataFunList.GET_HERO, a:[t.userData[0]]}]);
			}
		}

		/*添加同步服务器时间事件*/
		public static function addSyncServerTimeTimer() : void {
			t.serverTimeTimer = new Timer(1000);
			t.serverTimeTimer.addEventListener(TimerEvent.TIMER, t.syncServerTimeTimerHandler);
			t.serverTimeTimer.start();
		}

		/*移除同步服务器时间Timer*/
		public static function removeSyncServerTimeTimer() : void {
			t.serverTimeTimer.stop();
			t.serverTimeTimer.removeEventListener(TimerEvent.TIMER, t.syncServerTimeTimerHandler);
			t.serverTimeTimer = null;
		}

		/*添加税收时间Timer*/
		public static function addTaxTimer() : void {
			if (t.userData[4][3] == null) {
				var myTimer : Timer = new Timer(1000);
				myTimer.addEventListener(TimerEvent.TIMER, t.taxTimerHandler);
				myTimer.start();
				t.userData[4][3] = myTimer;
			}
		}

		/*移除税收时间Timer*/
		public static function removeTaxTimer() : void {
			if (t.userData[4] != null && t.userData[4][3] != null) {
				t.userData[4][3].stop();
				t.userData[4][3].removeEventListener(TimerEvent.TIMER, t.taxTimerHandler);
				t.userData[4][3] = null;
			}
		}

		/*移除军令时间Timer*/
		public static function removeTokenTimer() : void {
			if (t.userData[2][5] != null) {
				t.userData[2][5].stop();
				t.userData[2][5].addEventListener(TimerEvent.TIMER, t.tokenTimerHandler);
				t.userData[2][5] = null;
			}
		}

		/*带数字分页*/
		public static function pagesNumEvent(par : Object, pagesNum : Object, pageContent : DisplayObject, targetName : String) : void {
			var num : uint;
			var offset : int;
			var string : String;
			var max : uint;
			var b : Boolean = false;
			if (pagesNum is Sprite) b = true;
			if (b) {
				max = pagesNum.numChildren;
			} else {
				max = uint(pagesNum);
			}
			if (targetName.indexOf(UIClass.NUM_PREFIX) != -1) {
				num = uint(targetName.replace(UIClass.NUM_PREFIX, ""));
				if (par.dataCurrent > num) {
					if (b) {
						string = UIName.E_PREV;
					} else {
						string = UIName.E_UP;
					}
				} else {
					if (b) {
						string = UIName.E_NEXT;
					} else {
						string = UIName.E_DOWN;
					}
				}
				par.dataCurrent = num;
				if (b) {
					pagesCurrent(pagesNum as Sprite, num - 1);
					offset = (par.dataCurrent - num) * par.contentMask.width;
					TweenLite.to(pageContent, 0.1, {x:String(offset), onComplete:UITransition.pagesTC, onCompleteParams:[string, par.prev, par.next, num, max]});
				} else {
					offset = (par.dataCurrent - num) * par.contentMask.height;
					TweenLite.to(pageContent, 0.1, {y:String(offset), onComplete:UITransition.pagesTC, onCompleteParams:[string, par.up, par.down, num, max]});
				}
			} else {
				if (targetName == UIName.E_PREV || targetName == UIName.E_UP) {
					par.dataCurrent--;
				} else if (targetName == UIName.E_NEXT || targetName == UIName.E_DOWN) {
					par.dataCurrent++;
				}
				num = par.dataCurrent;
				if (b) pagesCurrent(pagesNum as Sprite, num - 1);
				pagesEvent(par, pageContent, targetName, num, max);
			}
		}

		/*分页向左向右向上向下事件通用方法*/
		public static function pagesEvent(par : Object, content : DisplayObject, targetName : String, num : uint = 0, max : uint = 0) : void {
			var mask : Sprite = par.contentMask;
			if (targetName == UIName.E_PREV) {
				if (!par.next.comp.enabled) par.next.comp.enabled = true;
				TweenLite.to(content, 0.1, {x:String(mask.width), onComplete:UITransition.pagesTC, onCompleteParams:[UIName.E_PREV, par.prev, par.next, num, max]});
			} else if (targetName == UIName.E_NEXT) {
				if (!par.prev.comp.enabled) par.prev.comp.enabled = true;

				TweenLite.to(content, 0.1, {x:String(-mask.width), onComplete:UITransition.pagesTC, onCompleteParams:[UIName.E_NEXT, par.prev, par.next, num, max]});
			} else if (targetName == UIName.E_UP) {
				if (!par.down.comp.enabled) par.down.comp.enabled = true;

				TweenLite.to(content, 0.1, {y:String(mask.height), onComplete:UITransition.pagesTC, onCompleteParams:[UIName.E_UP, par.up, par.down, num, max]});
			} else if (targetName == UIName.E_DOWN) {
				if (!par.up.comp.enabled) par.up.comp.enabled = true;
				TweenLite.to(content, 0.1, {y:String(-mask.height), onComplete:UITransition.pagesTC, onCompleteParams:[UIName.E_DOWN, par.up, par.down, num, max]});
			}
		}

		/*批量添加各种事件*/
		public static function batchAddEvent(par : Sprite, func : Function, bottom : Boolean = false, sp : Boolean = true, tf : Boolean = false, click : Boolean = true, roll : Boolean = false, ud : Boolean = false, call : Vector.<String>=null) : void {
			var max : uint = par.numChildren;
			var childSp : Sprite;
			var btn : SimpleButton;
			var txt : TextField;
			for (var i : uint = 0; i < max; i++) {
				if (par.getChildAt(i) is TextField) {
					txt = par.getChildAt(i) as TextField;
					if (tf) {
						addEvent(txt, func, click, roll, ud);
					}
				}
				if (par.getChildAt(i) is Sprite) {
					childSp = par.getChildAt(i) as Sprite;
					if (bottom && childSp.numChildren > 0) {
						batchAddEvent(childSp, func, true, true);
					} else {
						if (sp) {
							if (call == null) {
								if (click && roll) {
									convertButtonMode(childSp);
								}
								addEvent(childSp, func, click, roll, ud);
							} else {
								var jmax : uint = call.length;
								for (var j : uint = 0; j < jmax; j++) {
									if (childSp.name == call[j]) {
										if (click && roll) {
											convertButtonMode(childSp);
										}
										addEvent(childSp, func, click, roll, ud);
									}
								}
							}
						}
					}
				}
				if (par.getChildAt(i) is SimpleButton) {
					btn = par.getChildAt(i) as SimpleButton;
					btn.addEventListener(MouseEvent.CLICK, func);
					addEvent(btn, func);
				}
			}
		}

		/*添加各种事件*/
		public static function addEvent(o : DisplayObject, fun : Function, click : Boolean = true, roll : Boolean = false, ud : Boolean = false) : void {
			if (click) {
				o.addEventListener(MouseEvent.CLICK, fun);
			}
			if (roll) {
				o.addEventListener(MouseEvent.ROLL_OVER, fun);
				o.addEventListener(MouseEvent.ROLL_OUT, fun);
			}
			if (ud) {
				o.addEventListener(MouseEvent.MOUSE_UP, fun);
				o.addEventListener(MouseEvent.MOUSE_DOWN, fun);
			}
		}

		/*添加显示对象并添加事件*/
		public static function addChildAndEvent(parent : Sprite, child : Sprite, fun : Function, x : Number = 0, y : Number = 0, name : String = "", call : Vector.<String> = null, convert : Boolean = false) : void {
			var index : uint = convert ? parent.numChildren : 0;
			parent.addChildAt(child, index);
			child.x = x;
			child.y = y;
			if (name) child.name = name;
			if (call) {
				batchAddEvent(child, fun, false, true, false, true, convert, false, call);
			} else {
				if (convert) convertButtonMode(child);
				addEvent(child, fun);
			}
		}

		/*销毁对象使其符合垃圾回收，把传入的对象及其子对象，先从事件监听列表上移除，再从显示列表移除，最后赋值NULL。或者只移除事件*/
		public static function destroy(o : DisplayObject, mouseEventFunction : Function = null, frameEventFuntion : Function = null, rec : Boolean = false, remove : Boolean = true) : void {
			if (mouseEventFunction != null) {
				if (o.hasEventListener(MouseEvent.CLICK)) o.removeEventListener(MouseEvent.CLICK, mouseEventFunction);
				if (o.hasEventListener(MouseEvent.MOUSE_OVER)) o.removeEventListener(MouseEvent.MOUSE_OVER, mouseEventFunction);
				if (o.hasEventListener(MouseEvent.MOUSE_OUT)) o.removeEventListener(MouseEvent.MOUSE_OUT, mouseEventFunction);
				if (o.hasEventListener(MouseEvent.ROLL_OVER)) o.removeEventListener(MouseEvent.ROLL_OVER, mouseEventFunction);
				if (o.hasEventListener(MouseEvent.ROLL_OUT)) o.removeEventListener(MouseEvent.ROLL_OUT, mouseEventFunction);
				if (o.hasEventListener(MouseEvent.MOUSE_UP)) o.removeEventListener(MouseEvent.MOUSE_UP, mouseEventFunction);
				if (o.hasEventListener(MouseEvent.MOUSE_DOWN)) o.removeEventListener(MouseEvent.MOUSE_DOWN, mouseEventFunction);
				if (o.hasEventListener(MouseEvent.MOUSE_MOVE)) o.removeEventListener(MouseEvent.MOUSE_MOVE, mouseEventFunction);
				if (o.hasEventListener(MouseEvent.MOUSE_WHEEL)) o.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseEventFunction);
			}
			if (frameEventFuntion != null) {
				if (o.hasEventListener(Event.ENTER_FRAME)) o.removeEventListener(Event.ENTER_FRAME, frameEventFuntion);
			}
			if (!(o is Loader) && (o is DisplayObjectContainer) && rec) {
				var max : uint = DisplayObjectContainer(o).numChildren;
				var child : DisplayObject;
				for (var i : uint = 0; i < max; i++) {
					if (DisplayObjectContainer(o).getChildAt(0) is DisplayObject) {
						child = DisplayObjectContainer(o).getChildAt(0) as DisplayObject;
						destroy(child, mouseEventFunction, frameEventFuntion, rec, remove);
					}
				}
			}
			if (remove) {
				if (o.parent) {
					o.parent.removeChild(o);
				}
			}
		}

		/*移除所有子对象*/
		public static function removeAllChild(o : Sprite, index : int = -1) : void {
			var max : int = o.numChildren - 1;
			for (var i : int = max; i > index; i--) {
				o.removeChildAt(i);
			}
		}

		/*销毁加载内容*/
		public static function destroyLoaders() : void {
			var content : Array = t.loaders[t.loaders.length - 1];
			if (content) {
				var max : int = content.length - 1;
				for (var i : int = max; i > -1; i--) {
					try {
						if (content[i].content != null) {
							if (content[i].content is Bitmap) (content[i].content as Bitmap).bitmapData.dispose();
						}
					} catch (error : Error) {
						trace(error.toString());
					}
					content[i].unloadAndStop();
					content[i] = null;
					content.splice(i, 1);
				}
			}
			t.loaders.pop();
		}

		/*移除背景遮罩*/
		public static function removeSubstrate(index : uint = 0) : void {
			removeFadeOut(t, index, 0.2);
		}

		/*移除弹出框遮罩*/
		public static function removeShield(index : int, par : DisplayObjectContainer = null) : void {
			if (par == null) par = t;
			removeFadeOut(par, index);
		}

		/*淡出移除*/
		public static function removeFadeOut(par : DisplayObjectContainer, index : int, delayTime : Number = 0, duration : Number = 0.2) : void {
			var sp : Sprite = par.getChildAt(index) as Sprite;
			TweenLite.to(sp, duration, {alpha:0, delay:delayTime, onComplete:UITransition.restoreOrDestroyTC, onCompleteParams:[sp]});
		}

		/*移除socket数据加载进度条*/
		public static function removeLoading() : void {
			trace('removeLoading');
			destroy(t.stage.getChildByName(UIClass.LOADING_SOCKET));
			MouseStyleNow.getInstace().changeMouseFlow();
		}

		/*销毁滚动条*/
		public static function destroyScroll() : void {
			t.scrollBar.destroy();
			t.scrollBar = null;
		}

		/*添加按钮效果*/
		public static function convertButtonMode(o : Sprite, btn : Boolean = true) : void {
			o.useHandCursor = btn;
			o.buttonMode = btn;
			o.mouseChildren = false;
		}

		/*移除按钮效果*/
		public static function removeButtonMode(o : Sprite) : void {
			o.buttonMode = false;
			o.useHandCursor = false;
			o.mouseChildren = true;
		}

		/*任务引导*/
		public static function taskGuide() : void {
			if (t.userData[3][3] != null) {
				var b : Boolean;
				if (t.userData[3][3] < 6006) {
					if (t.gameGuideData[0] == -1) b = true;
				} else {
					if (t.userData[3][1] != null) {
						var len : uint = t.userData[3][1].length;
						var data : Array;
						var i : uint;
						var j : uint;
						var guide : uint;
						var xmlList : XMLList;
						var name : String;
						var type : uint;
						var conditionLen : uint;
						// addTaskGuideTip(len);
						for (i = 0; i < len; i++) {
							data = t.userData[3][1][i];
							if (uint(UIXML.mainTaskXML.task.(@id == data[0]).guide) == t.userData[3][3]) b = true;
							if (data[1] != null) {
								/*添加非强制任务引导的特殊TIP*/
								conditionLen = data[1].length;
								for (j = 0; i < conditionLen; i++) {
									xmlList = UIXML.mainTaskXML.childTask.(@id == data[1][j][0]);
									if (data[1][j][1] != uint(xmlList.sum)) {
										guide = uint(xmlList.guide);
										if (guide == t.userData[3][3]) {
											xmlList = UIXML.gameGuideXML.guide.(@id == t.userData[3][3]).tip;
											name = String(xmlList.name);
											type = uint(xmlList.type);
											switch (type) {
												case 1:
													if (t.ui[UIName.UI_MAIN_NAV].getChildByName(UIClass.NPC_TIP + name) == null) UICreate.addNPCTip((t.ui[UIName.UI_MAIN_NAV] as Object).nav[name], String(xmlList.content), t.ui[UIName.UI_MAIN_NAV]);
													break;
												case 2:
													if (t.ui[UIName.UI_SECONDARY_NAV].getChildByName(UIClass.NPC_TIP + name) == null) UICreate.addNPCTip((t.ui[UIName.UI_SECONDARY_NAV] as Object).down[name], String(xmlList.content), t.ui[UIName.UI_SECONDARY_NAV]);
													break;
												case 3:
													if (t.ui[UIName.UI_SELECT_MAP].getChildByName(UIClass.NPC_TIP + name) == null) UICreate.addNPCTip((t.ui[UIName.UI_SELECT_MAP] as Object).defence.getChildAt(0), String(xmlList.content), t.ui[UIName.UI_SELECT_MAP], "0");
													break;
											}
										}
									}
								}
							}
						}
					}
				}
				if ((t.stateFirst == UIState.START || t.stateFirst == UIState.TASK) && t.getChildByName(UIClass.NPC_PROMPT) == null && b) UICreate.addNPCPrompt(UIXML.gameGuideXML.guide.(@id == t.userData[3][3]).story.content);
			}
		}

		/*移除非强制任务引导的特殊TIP*/
		public static function removeTaskGuideTip(targetName : String) : void {
			var obj : Object;
			obj = t.ui[UIName.UI_MAIN_NAV].getChildByName(UIClass.NPC_TIP + targetName);
			if (obj != null ) nextGuide(obj as Sprite);
			obj = t.ui[UIName.UI_SECONDARY_NAV].getChildByName(UIClass.NPC_TIP + targetName);
			if (obj != null ) nextGuide(obj as Sprite);
			obj = t.ui[UIName.UI_SELECT_MAP].getChildByName(UIClass.NPC_TIP + targetName);
			if (obj != null ) nextGuide(obj as Sprite);
		}

		/*移除引导并进入下个引导*/
		public static function nextGuide(remove : Sprite = null, id : int = -1, task : Boolean = false) : void {
			if (t.userData[3][3] != null) {
				if (remove) {
					remove.parent.removeChild(remove);
				} else {
					if (t.gameGuideData[1] != null) removeGuideHighlight();
				}
				if (t.gameGuideData[2] != null) {
					uiDataTransfer(t.gameGuideData[2]);
					t.gameGuideData[2] = null;
				}
				if (t.gameGuideData[3] != null) {
					uiDataTransfer(t.gameGuideData[3], EventNameList.UI_SAVE_DATA);
					t.gameGuideData[3] = null;
				}
				uiDataTransfer([{m:UIDataFunList.SAVE_GAME_GUIDE_END, a:[t.userData[0], t.userData[3][3]]}], EventNameList.UI_SAVE_DATA);
				t.userData[3][3] = uint(UIXML.gameGuideXML.guide.(@id == t.userData[3][3]).next[0]);
				t.gameGuideData[0] = id;
				if (task) taskGuide();
			}
		}

		/*移除引导高亮*/
		public static function removeGuideHighlight() : void {
			t.removeChild(t.gameGuideData[1][6]);
			t.removeChild(t.gameGuideData[1][5].parent);
			if (t.gameGuideData[1][5].dataOffsetX != null) t.gameGuideData[1][5].dataOffsetX = null;
			if (t.gameGuideData[1][5].dataOffsetY != null) t.gameGuideData[1][5].dataOffsetY = null;
			t.gameGuideData[1][5].x = t.gameGuideData[1][0];
			t.gameGuideData[1][5].y = t.gameGuideData[1][1];
			t.gameGuideData[1][2].addChildAt(t.gameGuideData[1][5], t.gameGuideData[1][3]);
			t.removeChild(t.gameGuideData[1][4]);
			t.gameGuideData[1] = null;
		}

		/*恢复匹配对手容器初始内容*/
		public static function restoreRivalMatch() : void {
			var container : Object;
			for (var i : uint = 0; i < 4; i++) {
				UICommand.destroyLoaders();
				container = (t.ui[UIName.UI_SELECT_RIVAL] as Object).box.getChildAt(i);
				if (container.icon.numChildren == 2) container.icon.removeChildAt(1);
			}
		}

		/*代替禁用EasyBTN的热区*/
		public static function addEasyHit(btn : Object, data : String = "", roll : Boolean = false) : void {
			var par : Sprite = btn.parent;
			var hitBox : DisplayObject = par.getChildByName(UIName.E_REPLACE_DISABLE_HIT);
			if (hitBox) {
				btn.dataHitIndex = (hitBox as Sprite).numChildren;
			} else {
				hitBox = new Sprite();
				hitBox.name = UIName.E_REPLACE_DISABLE_HIT;
				btn.dataHitIndex = 0;
				par.addChild(hitBox);
			}
			try {
				if (btn.comp) btn.comp.enabled = false;
			} catch (error : Error) {
				trace(error.toString());
			}
			var hit : MovieClip = new MovieClip();
			(hit as Object).dataInfo = data;
			hit.name = UIName.E_REPLACE_DISABLE_HIT + btn.dataHitIndex;
			var w : Number;
			if (btn.numChildren == 1 && btn.getChildAt(0) is TextField) {
				w = (btn.getChildAt(0) as TextField).textWidth;
			} else {
				w = btn.width;
			}
			hit.graphics.beginFill(0x000000, 0);
			hit.graphics.drawRect(0, 0, w, btn.height);
			hit.graphics.endFill();
			hit.x = btn.x;
			hit.y = btn.y;
			(hitBox as Sprite).addChild(hit);
			if (roll) {
				hit.addEventListener(MouseEvent.MOUSE_OVER, t.mouseEvent);
				hit.addEventListener(MouseEvent.MOUSE_OUT, t.mouseEvent);
			}
		}

		/*移除代替禁用EasyBTN的热区*/
		public static function remvoeEasyHit(remvoe : Object) : void {
			var par : Sprite;
			var data : Array = [];
			var len : uint;
			var max : uint;
			if (remvoe is Array) {
				data = remvoe as Array;
				par = data[0].parent as Sprite;
			} else {
				var child : Object;
				par = remvoe as Sprite;
				max = par.numChildren - 1;
				for (var k : int = max; k > -1; k-- ) {
					child = par.getChildAt(k);
					try {
						if (child.dataHitIndex != null) data[data.length] = child;
					} catch (error : Error) {
						trace(error.toString());
					}
				}
			}
			var hitBox : DisplayObject = par.getChildByName(UIName.E_REPLACE_DISABLE_HIT);
			// if (hitBox) par.addChild(hitBox);
			// if (b) {
			if (hitBox) {
				max = (hitBox as Sprite).numChildren - 1;
				var hit : Sprite;
				len = data.length - 1;
				for (var i : int = max; i > -1; i--) {
					hit = (hitBox as Sprite).getChildAt(i) as Sprite;
					for (var j : int = len; j > -1; j-- ) {
						if (hit.name == UIName.E_REPLACE_DISABLE_HIT + data[j].dataHitIndex) {
							(hitBox as Sprite).removeChild(hit);
							if (data[j].comp) data[j].comp.enabled = true;
							data[j].dataHitIndex = null;
							break;
						}
					}
				}
				if ((hitBox as Sprite).numChildren == 0 || remvoe is Sprite) {
					par.removeChild(hitBox);
				}
			}
			// } else {
			// if (hitBox)
			// {
			// par.removeChild(hitBox);
			// }
			// }
		}

		/*开启格子*/
		public static function openLock(init : Boolean = true) : void {
			var lock : Object;
			var max : uint;
			if (t.stateFirst == UIState.SELECT_ATTACT_ROLE) {
				lock = (t.ui[UIName.UI_SELECT_ATTACK_ROLE] as Object).expendables.lock;
				max = 8;
			} else if (t.stateFirst == UIState.HERO) {
				lock = (t.ui[UIName.UI_HERO] as Object).lock;
				max = 5;
			}
			if (t.openLockNum == max) {
				lock.visible = false;
				lock.comp.enabled = false;
			}
			var btn : Sprite = lock.btn as Sprite;
			if (init) {
				if (max == 8 && lock.comp.enabled) {
					lock.addEventListener(MouseEvent.CLICK, t.mouseEvent);
					lock.addEventListener(MouseEvent.MOUSE_OVER, t.mouseEvent);
					lock.addEventListener(MouseEvent.MOUSE_OUT, t.mouseEvent);
				}
				for (var i : uint = 0; i < t.openLockNum; i++) {
					btn.getChildAt(i).visible = false;
				}
			} else {
				btn.getChildAt(t.openLockNum - 1).visible = false;
			}
		}

		/*恢复格子*/
		public static function restoreLock(lock : Object) : void {
			var comp : Object = lock.comp;
			if (!comp.enabled) comp.enabled = true;
			if (!lock.visible) {
				lock.visible = true;
				var btn : Sprite = lock.btn as Sprite;
				var len : uint = btn.numChildren;
				for (var i : uint = 0; i < len; i++) {
					btn.getChildAt(i).visible = true;
				}
			}
		}

		/*英雄属性界面改变体力*/
		public static function changeHeroPower(par : Object, current : uint, max : uint) : void {
			var powerHeart : Object = par.powerHeart;
			powerHeart.x += ((12 - max) * 4);
			var up : Sprite = powerHeart.up;
			var down : Sprite = powerHeart.down;
			var childUp : Sprite;
			var childDown : Sprite;
			for (var i : uint = 0; i < 12; i++) {
				childUp = up.getChildAt(i) as Sprite;
				childDown = down.getChildAt(i) as Sprite;
				if (i < current) {
					childUp.visible = true;
				} else {
					childUp.visible = false;
				}
				if (i < max) {
					childDown.visible = true;
				} else {
					childDown.visible = false;
				}
			}
			var submit : Object = par.btn.submit;
			if (current == max) {
				submit.visible = false;
			} else {
				submit.visible = true;
			}
		}

		/*导航按钮当前效果*/
		public static function navSelected(selected : DisplayObject) : void {
			var par : Object = selected.parent;
			var max : uint = par.numChildren;
			var obj : Object;
			for (var i : uint = 0; i < max; i++) {
				obj = par.getChildAt(i);
				if (obj == selected) {
					obj.comp.enabled = false;
					(t.ui[UIName.UI_BAG] as Object).dataType = selected.name;
				} else {
					obj.comp.enabled = true;
				}
			}
		}

		/*分页当前所在页*/
		public static function pagesCurrent(par : Sprite, index : uint) : void {
			var max : uint = par.numChildren;
			var child : Sprite;
			var numTxt : TextField;
			for (var i : uint = 0; i < max; i++) {
				child = par.getChildAt(i) as Sprite;
				numTxt = child.getChildAt(1) as TextField;
				if (i == index) {
					numTxt.textColor = 0xF6921E;
					removeButtonMode(child);
				} else {
					numTxt.textColor = 0x603813;
					convertButtonMode(child);
				}
			}
		}

		/*图鉴显示格子*/
		public static function handbookGrid(par : Sprite, num : uint) : void {
			var max : uint = par.numChildren;
			var child : Sprite;
			for (var i : uint = 0; i < max; i++) {
				child = par.getChildAt(i) as Sprite;
				if (i < num) {
					child.visible = true;
				} else {
					child.visible = false;
				}
			}
		}

		/*活动物品选中状态*/
		public static function giftSelected(obj : Object, selected : Object) : void {
			var box : Object = obj.box;
			var len : uint = box.numChildren;
			var hero : Sprite;
			var child : Object;
			for (var i : uint = 0; i < len; i++) {
				child = box.getChildAt(i);
				hero = child.icon.getChildAt(1);
				if (child == selected) {
					hero.filters = [new GlowFilter(0xFFFF00, 1, 6, 6, 5)];
					if (obj.dataGift == null) obj.dataGift = [];
					obj.dataGift[obj.dataGift.length] = selected.dataGift;
				} else {
					hero.filters = [];
				}
			}
			obj.submit.comp.enabled = true;
		}

		/*背包物品选中状态*/
		public static function bagSelected(selected : Sprite, remove : Boolean = true) : void {
			var obj : Object = t.getChildByName(UIClass.SMALL_BAG);
			if (remove) {
				var par : Sprite = selected.parent.parent as Sprite;
				var max : uint = par.numChildren;
				var child : Sprite;
				var sub : Object;
				var txt : TextField;
				for (var i : uint = 0; i < max; i++) {
					child = par.getChildAt(i) as Sprite;
					if (child.numChildren == 2) {
						sub = child.getChildAt(1);
						if (sub != selected && sub.filters.length != 0 && !sub.dataUseLevel) {
							sub.filters = [];
							if (obj && obj.data[1] == 4) {
								txt = sub.getChildAt(sub.numChildren - 1) as TextField;
								changeIconNum(txt, 1, obj);
							}
						}
					}
				}
			}
			var sTxt : TextField = selected.getChildAt(selected.numChildren - 1) as TextField;
			if (sTxt.visible) {
				selected.filters = [new GlowFilter(0xFFFF00, 1, 6, 6, 5)];
			} else {
				selected.filters = [new ColorMatrixFilter([0.31, 0.61, 0.08, 0, 0, 0.31, 0.61, 0.08, 0, 0, 0.31, 0.61, 0.08, 0, 0, 0, 0, 0, 1, 0])];
			}
			t.selectedItems = [selected.name, (selected as Object).dataType, (selected as Object).dataIndex, (selected as Object).dataSale, selected.getChildAt(selected.numChildren - 1), (selected as Object).dataLangName, t.bagData[(selected as Object).dataType][(selected as Object).dataIndex][0], (selected as Object).dataBuffSum];
			if (obj) {
				if (sTxt.visible && obj.data[1] == 4) {
					changeIconNum(sTxt, -1, obj);
				}
				if (remove) {
					var comp : Object = obj.remove.comp;
					if (!comp.enabled) comp.enabled = true;
					var icon : Object = obj.icon;
					if (icon.numChildren == 2) icon.removeChildAt(1);
					UICreate.addGoodsIcon(icon, [selected.name, (selected as Object).dataLangName, (selected as Object).dataInfo]);
					obj.data[3] = t.selectedItems[6];
				}
				obj.data[4] = selected;
			} else {
				var sale : Object = (t.ui[UIName.UI_BAG] as Object).sale;
				var submit : Object = (t.ui[UIName.UI_BAG] as Object).submit;
				sale.visible = Boolean((selected as Object).dataSale);
				submit.visible = false;
				if (t.selectedItems[1] == 0 && UIXML.propXML.prop.(@id == t.selectedItems[6]).buffType != UIName.E_TASK) {
					submit.visible = true;
					if ((selected as Object).dataSale) {
						submit.x = submit.dataX;
					} else {
						submit.x = sale.x;
					}
				}
			}
		}

		/*改变卡片图标上的数字*/
		public static function changeIconNum(tf : TextField, change : int, smallBag : Object = null) : void {
			var icon : Object = tf.parent;
			var num : int = int(tf.text.replace("X", "")) + change;
			if (num == 0) {
				tf.visible = false;
				icon.filters = [new ColorMatrixFilter([0.31, 0.61, 0.08, 0, 0, 0.31, 0.61, 0.08, 0, 0, 0.31, 0.61, 0.08, 0, 0, 0, 0, 0, 1, 0])];
			} else {
				if (!tf.visible) tf.visible = true;
			}
			tf.text = "X" + num;
			tf.width = tf.textWidth + 4;
			tf.height = tf.textHeight + 2;
			tf.x = icon.width - tf.width;
			if (smallBag) t.bagData[smallBag.data[1] - 1][icon.dataIndex][1] += change;
		}

		/*卡片选中状态*/
		public static function changeCardSelected(selected : DisplayObject, selectedAnimation : DisplayObject) : void {
			selectedAnimation.visible = true;
			var par : Sprite = selectedAnimation.parent as Sprite;
			par.setChildIndex(selectedAnimation, par.numChildren - 1);
			var stagePoint : Point = selected.localToGlobal(new Point(0, 0));
			selectedAnimation.x = stagePoint.x + 35;
			selectedAnimation.y = stagePoint.y + 43;
			(par as Object).dataSelectedPage = (par as Object).dataCurrent;
		}

		/*改变塔卡片禁用状态*/
		public static function changeTowerCardDisable() : void {
			var sp : Sprite = t.ui[UIName.UI_DEFENCE_OPERATION].getChildByName(UIName.PRESENT_DEFENCE_TOWER) as Sprite;
			var num : uint = getPaperNum(2);
			var max : uint = sp.numChildren;
			var child : Object;
			for (var i : uint = 0; i < max; i++) {
				child = sp.getChildAt(i);
				if (int(child.common.money.text) > num) {
					child.common.disable.visible = true;
					child.useHandCursor = false;
					child.filters = [];
				} else {
					child.common.disable.visible = false;
					child.useHandCursor = true;
				}
			}
		}

		/*获得已经选择兵的手纸数是否小于或等于地图手纸数*/
		public static function expendablePaperIsMin(data : Array) : Boolean {
			var paper : uint = getPaperNum();
			var xmlList : XMLList = UIXML.soldierXML.soldier;
			var isMin : Function = function(element : *, index : int, arr : Array) : Boolean {
				return (uint(xmlList.(@id == element).paper[0]) <= paper);
			};
			return data.some(isMin);
		}

		/*改变卡片顺序*/
		public static function orderCard(data : Array, type : String, dossier : Boolean) : void {
			switch(type) {
				case UIName.XML_SOLDIER :
					if (dossier) {
						data.sort(sortOnSoldierUint);
					} else {
						data.sort(sortOnSoldierAry);
					}
					break;
				case UIName.XML_TOWER:
					data.sort(sortOnTowerAry);
					break;
			}

			function sortOnSoldierUint(a : uint, b : uint) : Number {
				var xmlList : XMLList = UIXML.soldierXML.soldier;
				var aOrder : uint = uint(xmlList.(@id == a).order[0]);
				var bOrder : uint = uint(xmlList.(@id == b).order[0]);
				if (aOrder > bOrder) {
					return 1;
				} else if (aOrder < bOrder) {
					return -1;
				} else {
					return 0;
				}
			}

			function sortOnSoldierAry(a : Array, b : Array) : Number {
				var xmlList : XMLList = UIXML.soldierXML.soldier;
				var aOrder : uint = uint(xmlList.(@id == a[0]).order[0]);
				var bOrder : uint = uint(xmlList.(@id == b[0]).order[0]);
				if (aOrder > bOrder) {
					return 1;
				} else if (aOrder < bOrder) {
					return -1;
				} else {
					return 0;
				}
			}

			function sortOnTowerAry(a : Array, b : Array) : Number {
				var xmlList : XMLList = UIXML.towerXML.towerType.tower;
				var aOrder : uint = uint(xmlList.(@id == a[1]).order[0]);
				var bOrder : uint = uint(xmlList.(@id == b[1]).order[0]);
				if (aOrder > bOrder) {
					return 1;
				} else if (aOrder < bOrder) {
					return -1;
				} else {
					return 0;
				}
			}
		}

		/*验证选择的兵是否出现问题*/
		public static function verifyExpendable() : void {
			var len : uint = t.expendableData[1].length;
			if (len > t.openLockNum) {
				t.expendableData[1].splice(t.openLockNum);
				var sp : Sprite = t.getChildByName(UIName.PRESENT_EXPENDABLE) as Sprite;
				for (var i : int = len - 1; i >= t.openLockNum; i--) sp.removeChildAt(i);
			}
		}

		/*去除上次选兵数据里的等级，只要ID*/
		public static function handlePrevExpendable(data : Array, p : Sprite) : Array {
			var len : uint = data.length;
			var temp : Array = [[], []];
			var i : int;
			var j : int;
			var id : uint;
			for (i = len - 1; i > -1; i--) {
				if (data[i]) {
					id = data[i][0];
					temp[0].unshift(id);
					temp[1].unshift(p.getChildByName(UIName.XML_SOLDIER + UIName.CHAR_UNDERLINE + String(UIXML.soldierXML.soldier.(@id == id).name[0])));
					for (j = i - 1; j > -1; j--) {
						if (data[j] && id == data[j][0]) data[j] = null;
					}
				}
			}
			return temp;
		}

		// /*当出兵框满了禁用选兵框卡片*/
		// public static function disableAttackRoleCard(p : Sprite) : void {
		// var max : uint = p.numChildren;
		// var obj : Object;
		// var b : Boolean = false;
		// var sLen : int = -1;
		// if (t.expendableData && t.expendableData[1]) sLen = t.expendableData[1].length - 1;
		// var i : int;
		// var j : int;
		// for ( i = max - 1; i > -1; i--) {
		// obj = p.getChildAt(i);
		// if (obj.dataPower) {
		// b = true;
		// } else if (obj.dataPower == null) {
		// for (j = sLen; j > -1; j--) {
		// if (obj.dataID == t.expendableData[1][j]) {
		// b = true;
		// break;
		// }
		// }
		// }
		// if (b) {
		// obj.common.disable.visible = true;
		// obj.useHandCursor = false;
		// }
		// b = false;
		// }
		// }
		/*当出兵框满了禁用选兵框卡片*/
		public static function changeAttackRoleCard(p : Sprite, disable : Boolean = false, reset : Boolean = false) : void {
			var max : uint = p.numChildren;
			var obj : Object;
			var b : Boolean = false;
			var sLen : int = -1;
			if (t.expendableData && t.expendableData[1]) sLen = t.expendableData[1].length - 1;
			var i : int;
			var j : int;
			var count : int = -1;
			for ( i = max - 1; i > -1; i--) {
				obj = p.getChildAt(i);
				if (reset) {
					b = true;
				} else {
					if (obj.dataPower) {
						b = true;
					} else if (obj.dataPower == null) {
						for (j = sLen; j > -1; j--) {
							if (obj.dataID != t.expendableData[1][j]) count++;
						}
						if (count != -1 && count == sLen) b = true;
					}
				}
				if (b) {
					obj.common.disable.visible = disable;
					obj.useHandCursor = !disable;
				}
				count = -1;
				b = false;
			}
		}

		/*改变卡片禁用状态*/
		public static function changeCardDisable(num : int) : void {
			var sp : Sprite = t.getChildByName(UIName.PRESENT_EXPENDABLE) as Sprite;
			var max : uint = sp.numChildren;
			var have : uint;
			var childObj : Object;
			for (var i : uint = 0; i < max; i++) {
				childObj = sp.getChildAt(i);
				try {
					if (childObj.common) {
						have = UITransition.animationGreenSock(t.timelineLites, 2, childObj);
						if (uint(childObj.common.money.text) > num || childObj.name.indexOf(UIName.XML_HERO + UIName.CHAR_UNDERLINE) != -1) {
							childObj.common.disable.visible = true;
							childObj.useHandCursor = false;
						} else if (have == 0) {
							childObj.addEventListener(MouseEvent.CLICK, t.mouseEvent);
							childObj.common.disable.visible = false;
							childObj.useHandCursor = true;
						}
					}
				} catch (error : Error) {
					trace(error.toString());
				}
			}
		}

		/*改变英雄技能卡片状态*/
		public static function changeHeroSkillCard(card : Object, disable : Boolean = true) : void {
			var animation : MovieClip = card.animation;
			var cd : MovieClip = card.cd;
			var d : Sprite = card.disable;
			if (disable) {
				card.removeEventListener(MouseEvent.CLICK, t.mouseEvent);
				card.useHandCursor = false;
				d.visible = true;
				animation.visible = false;
				animation.gotoAndStop(1);
				var cdTime : uint = uint(UIXML.heroSkillXML.heroSkills.(@id == card.dataSkillID).cdTime[0]);
				cd.visible = true;
				cd.gotoAndStop(1);
				card.tweenLite = TweenLite.to(cd, cdTime, {frameLabel:UIName.F_END, ease:Sine.easeIn, onComplete:UITransition.heroSkillCDTC, onCompleteParams:[card]});
			} else {
				card.tweenLite = null;
				card.useHandCursor = true;
				d.visible = false;
				animation.visible = true;
				animation.play();
				cd.visible = false;
				cd.gotoAndStop(1);
				card.addEventListener(MouseEvent.CLICK, t.mouseEvent);
			}
		}

		/*改变英雄技能卡片CD动画播放或暂停*/
		public static function heroSkillCDPlayOPause(play : Boolean = true) : void {
			var obj : Object = (t.getChildByName(UIName.PRESENT_EXPENDABLE) as Sprite).getChildAt(0);
			if (obj.name == UIClass.CARD_HERO_SKILL && obj.tweenLite != null) {
				if (play) {
					obj.tweenLite.play();
				} else {
					obj.tweenLite.pause();
				}
			}
		}

		/*改变NPCTIP九切片背景宽高*/
		public static function changeNPCTipBG(obj : Object, offset : uint = 0) : void {
			obj.txt.width = obj.dataWidth;
			obj.txt.width = obj.txt.textWidth + 4;
			obj.tipbg.width = obj.txt.textWidth + 90 - offset;
			obj.txt.height = obj.txt.textHeight;
			obj.tipbg.height = obj.txt.textHeight + 15;
			if (obj.tipbg.height < 80) obj.tipbg.height = 80;
		}

		/*改变NPC剧情*/
		public static function changeNPCPrompt(obj : Object, name : String) : void {
			obj.dataIndex++;
			var len : uint = obj.dataList.length();
			if (obj.dataIndex == (len - 1)) obj.next.visible = false;
			if (name == UIName.E_SUBMIT || obj.dataIndex == len) {
				removeShield(t.numChildren - 2);
				obj.removeEventListener(MouseEvent.CLICK, t.mouseEvent);
				obj.removeEventListener(MouseEvent.ROLL_OVER, t.mouseEvent);
				obj.removeEventListener(MouseEvent.ROLL_OUT, t.mouseEvent);
				TweenLite.to(obj, 0.2, {y:"220", onComplete:UITransition.restoreOrDestroyTC, onCompleteParams:[obj]});
				var string : String;
				if (t.userData[3][3] != null) {
					if (t.userData[3][3] < 6006) {
						if (t.gameGuideData[0] == -1) {
							t.gameGuideData[0] = 0;
							string = String(UIXML.gameGuideXML.guide.(@id == t.userData[3][3]).tip.content[0]);
							if (t.userData[3][3] == 6002 || t.userData[3][3] == 6004) {
								UICreate.addGuideHighlight((t.ui[UIName.UI_MAIN_NAV] as Object).nav.techStart, string);
								(t.ui[UIName.UI_MAIN_NAV].getChildAt(t.ui[UIName.UI_MAIN_NAV].numChildren - 1) as Object).tech.visible = false;
							} else if (t.userData[3][3] == 6003) {
								UICreate.addGuideHighlight((t.ui[UIName.UI_MAIN_NAV] as Object).nav.defenceStart, string);
							} else if (t.userData[3][3] == 6005) {
								UICreate.addGuideHighlight((t.ui[UIName.UI_SECONDARY_NAV] as Object).openTask, string);
							}
						}
					} else {
						nextGuide(null, -1, true);
					}
				}
			} else {
				obj.txt.text = obj.dataList[obj.dataIndex];
			}
		}

		/*改变经验值*/
		public static function changeExperience(num : uint = 0) : void {
			if (num) t.userData[1][3] += num;
			var index : uint = t.userData[1][2] - 1;
			var last : uint = 0;
			var xmlList : XMLList = UIXML.levelXML.level;
			var denominator : uint = uint(xmlList[index].experience[0]);
			for (var i : uint = 0; i < index; i++) {
				last += uint(xmlList[i].experience[0]);
			}
			var numerator : uint = t.userData[1][3] - last;
			var level : Object = (t.ui[UIName.UI_USER_INFO] as Object).level;
			var between : int = denominator - numerator;
			level.dataBetween = between;
			var bar : Sprite = level.bar;
			bar.scaleX = 1;
			if (t.userData[1][2] < xmlList.length()) {
				bar.scaleX = numerator / denominator;
				if (between < 1) {
					t.userData[1][2]++;
					(t.ui[UIName.UI_USER_INFO] as Object).level.txt.text = t.userData[1][2];
					UICreate.popupLevel();
					changeToken(0, 3);
					changeExperience();
				}
			}
		}

		/*改变真钱，增加为正数，减少为负数。即拉环数*/
		public static function changeMoney(num : int) : void {
			if (num != 0) {
				t.realMoney += num;
				uiDataTransfer([{m:UIDataFunList.SAVE_CHANGE_MONEY, a:[t.userData[0], num]}], EventNameList.UI_SAVE_DATA);
			}
		}

		/*改变游戏币，增加为正数，减少为负数。即瓶盖数*/
		public static function changeCap(num : int) : void {
			if (num != 0) {
				t.capNum += num;
				// if (t.userData[3][3] != null && t.userData[3][3] == 6003 && t.gameGuideData[0] == 2) {
				// t.gameGuideData[3].push({m:UIDataFunList.SAVE_CHANGE_GAME_MONEY, a:[t.userData[0], num]});
				// } else {
				uiDataTransfer([{m:UIDataFunList.SAVE_CHANGE_GAME_MONEY, a:[t.userData[0], num]}], EventNameList.UI_SAVE_DATA);
				// }
			}
		}

		/*改变军令牌数*/
		public static function changeToken(num : int = 0, type : uint = 1) : void {
			if (t.userData[2][6] == null) t.userData[2][6] = Math.pow(uint(UIXML.levelXML.relate.tokenPriceBase[0]), t.userData[2][1]) * uint(UIXML.levelXML.relate.tokenPrice[0]);
			var tokenMax : uint = uint(UIXML.levelXML.level.(@grade == t.userData[1][2]).armyToken[0]);
			if (num != 0) {
				t.userData[2][0] += num;
				if (num > 0) {
					// if (t.userData[3][3] != null && t.userData[3][3] == 6003 && t.gameGuideData[0] == 2) {
					// t.gameGuideData[3] = [{m:UIDataFunList.SAVE_CHANGE_TOKEN, a:[t.userData[0], num]}];
					// } else {
					uiDataTransfer([{m:UIDataFunList.SAVE_CHANGE_TOKEN, a:[t.userData[0], num]}], EventNameList.UI_SAVE_DATA);
				}
			}
			if (type == 2) {
				t.userData[2][1]++;
				changeMoney(-uint(t.userData[2][6]));
				t.userData[2][6] = Math.pow(uint(UIXML.levelXML.relate.tokenPriceBase[0]), t.userData[2][1]) * uint(UIXML.levelXML.relate.tokenPrice[0]);
			} else if (type == 3) {
				if (t.userData[2][0] < tokenMax) t.userData[2][0] = tokenMax;
				t.userData[2][2] = null;
			}
			var current : TextField = (t.ui[UIName.UI_USER_INFO] as Object).token.txt1;
			current.text = t.userData[2][0];
			if (t.userData[2][0] > tokenMax) {
				current.textColor = 0xFF0000;
			} else {
				current.textColor = 0x3B2314;
			}
			(t.ui[UIName.UI_USER_INFO] as Object).token.txt2.text = UIName.CHAR_SlASH + String(tokenMax);
			if (num < 0 && t.userData[2][0] < tokenMax && t.userData[2][2] == null) t.userData[2][2] = t.serverTime;
			(t.ui[UIName.UI_USER_INFO] as Object).token.submit.addEventListener(MouseEvent.CLICK, t.mouseEvent);
		}

		/*改变弹出框数值*/
		public static function changeNum(txt : Object, data : Array, numA : uint, numB : uint, string : String) : void {
			var inputNum : uint = uint(txt.text);
			var max : uint = data[2];
			if (inputNum > max) {
				validation(txt.parent.validation, string);
				txt.text = String(max);
				txt.parent.num1.text = String(max * numA);
			} else if (numA * inputNum > numB) {
				validation(txt.parent.validation, string);
				txt.text = String(uint(numB / numA));
				txt.parent.num1.text = String(uint(numB / numA) * numA);
			} else {
				txt.parent.num1.text = String(uint(txt.text) * numA);
			}
		}

		/*改变当前通过数*/
		public static function setThrough(num : uint) : void {
			var through : TextField = (t.ui[UIName.UI_SELECT_ATTACK_ROLE] as Object).expendables.through.num;
			var throughTxt : String = through.text;
			var separate : int = throughTxt.indexOf(UIName.CHAR_SlASH);
			var txt : String;
			var endIndex : uint;
			var max : uint;
			if (separate == -1) {
				max = uint(throughTxt);
				txt = num + UIName.CHAR_SlASH;
			} else {
				max = uint(throughTxt.slice(separate + 1));
				endIndex = separate;
				txt = String(uint(throughTxt.substr(0, separate)) + num);
			}
			if (uint(txt) <= max) {
				through.replaceText(0, endIndex, txt);
			}
			if (num) {
				var remind : MovieClip = (t.ui[UIName.UI_SELECT_ATTACK_ROLE] as Object).expendables.through.remind;
				remind.visible = true;
				remind.gotoAndStop(1);
				TweenLite.to(remind, 1, {frameLabel:UIName.F_END, onComplete:UITransition.restoreOrDestroyTC, onCompleteParams:[remind, {remove:false, visible:false}]});
			}
		}

		/*获得手纸坐标,type为2是摆塔布防界面手纸，默认为1是战斗界面手纸*/
		public static function getPaperPoint(type : uint = 1) : Point {
			var paper : Sprite;
			if (type == 1) paper = (t.ui[UIName.UI_SELECT_ATTACK_ROLE] as Object).expendables.paper;
			if (type == 2) paper = (t.ui[UIName.UI_DEFENCE_OPERATION] as Object).paper;
			var stagePoint : Point = paper.localToGlobal(new Point(0, 0));
			return stagePoint;
		}

		/*改变当前手纸数,type为2是摆塔布防界面手纸数，默认为1是战斗界面手纸数*/
		public static function setPaperNum(num : int, type : uint = 1, change : Boolean = true, reset : Boolean = false) : void {
			if (type == 1) {
				var expendables : Object = (t.ui[UIName.UI_SELECT_ATTACK_ROLE] as Object).expendables;
				if (reset) {
					expendables.dataPaper = num;
				} else {
					expendables.dataPaper += num;
				}
				expendables.money.text = expendables.dataPaper;
				if (change) changeCardDisable(expendables.dataPaper);
			} else if (type == 2) {
				if (reset) {
					(t.ui[UIName.UI_DEFENCE_OPERATION] as Object).dataPaper = num;
				} else {
					(t.ui[UIName.UI_DEFENCE_OPERATION] as Object).dataPaper += num;
				}
				(t.ui[UIName.UI_DEFENCE_OPERATION] as Object).money.text = (t.ui[UIName.UI_DEFENCE_OPERATION] as Object).dataPaper;
				if (change) changeTowerCardDisable();
			}
		}

		/*获得当前手纸数,type为2是摆塔布防界面手纸数，默认为1是战斗界面手纸数*/
		public static function getPaperNum(type : uint = 1) : uint {
			var num : uint;
			if (type == 1) {
				num = (t.ui[UIName.UI_SELECT_ATTACK_ROLE] as Object).expendables.dataPaper;
			} else if (type == 2) {
				num = (t.ui[UIName.UI_DEFENCE_OPERATION] as Object).dataPaper;
			}
			return num;
		}

		/*税收完成，进入待领取状态*/
		public static function taxReceiveOrEnd(end : Boolean = true) : void {
			removeTaxTimer();
			var money : uint;
			var getCapNum : uint;
			if (t.userData[4][2] == null) {
				getCapNum = uint(uint(UIXML.levelXML.level.(@grade == userData[1][2]).taxIncome) * Number(UIXML.levelXML.tax.(@id == userData[4][0]).taxIncomeDouble[0]));
				money = uint(UIXML.levelXML.tax.(@id == userData[4][0]).money[0]);
				if (t.userData[4][1] == null) {
					t.userData[4][2] = [getCapNum, (int((t.userData[4][1][1] - t.serverTime) / 3600000) + 1) * money, money];
				} else {
					t.userData[4][2] = [getCapNum, 0, money];
				}
			}
			if (t.userData[4][2][1] != -1) t.realMoney -= uint(t.userData[4][2][1]);
			t.userData[4][1] = null;
			UICreate.getTaxReceive();
			if (end) {
				/*税收领取完成，重新进入未开启状态*/
				var revenue : DisplayObject = t.ui[UIName.UI_MAIN_NAV].getChildByName(UIName.E_TAX_START);
				revenue.removeEventListener(MouseEvent.CLICK, t.mouseEvent);
				t.ui[UIName.UI_MAIN_NAV].removeChild(revenue);
				if (t.userData[4][2][1] != -1) uiDataTransfer([{m:UIDataFunList.SAVE_TAX_END, a:[t.userData[0], t.userData[4][2][1]]}], EventNameList.UI_SAVE_DATA);
				if (t.userData[4][2][1] != null) {
					var animation : MovieClip = getInstance(UIClass.ANIMATION_TAX_CAP) as MovieClip;
					t.addChild(animation);
					animation.gotoAndStop(1);
					TweenLite.to(animation, 1, {frameLabel:UIName.F_END, onComplete:UITransition.restoreOrDestroyTC, onCompleteParams:[animation]});
					(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.SOUND_WIN_MAP);
					t.capNum += t.userData[4][2][0];
					uiDataTransfer([{m:UIDataFunList.GET_TAX_REVENUE, a:[t.userData[0]]}]);
				}
				t.userData[4] = null;
			}
			if (t.stateFirst == UIState.TAX) UICreate.getTaxContainer();
		}

		/*克隆实例*/
		public static function cloneInstance(instance : DisplayObject) : DisplayObject {
			var instanceClass : Class = getClass(getInstanceClassName(instance)) as Class;
			var instanceObj : DisplayObject = new instanceClass as DisplayObject;
			return instanceObj;
		}

		/*获得实例的类名*/
		public static function getInstanceClassName(instance : DisplayObject) : String {
			return getQualifiedClassName(instance).replace("::", ".");
		}

		/*获得实例*/
		public static function getInstance(className : String) : Sprite {
			var ObjClass : Class = getClass(className);
			return new ObjClass();
		}

		/*从应用程序域获得类*/
		public static function getClass(className : String, domain : ApplicationDomain = null) : Class {
			var classDomain : ApplicationDomain = domain == null ? ApplicationDomain.currentDomain : domain;
			try {
				return classDomain.getDefinition(className) as Class;
			} catch (e : Error) {
				throw new IllegalOperationError(className + " definition not found");
			}
			return null;
		}

		/*UI数据传输*/
		public static function uiDataTransfer(data : Array, type : String = EventNameList.UI_GET_DATA) : void {
			var max : uint = data.length;
			for (var i : uint = 0; i < max; i++) {
				t.dispatchEvent(new EventBindingData(type, data[i]));
			}
		}

		/*js回调as*/
		public static function uiDataTransferJS(value : String = "") : void {
			if (value == null) value = "";
			if (value == UIName.JS_INVITE) {
				t.apiData = [UIName.JS_INVITE, 100];
			} else if (value == UIName.JS_PAY && !t.stage.getChildByName(UIClass.PAY_RECHARGE) && t.stage.getChildAt(t.stage.numChildren - 1).name.indexOf(UIClass.POPUP_PROMPT + UIState.SOCKET) == -1) {
				UITransition.inPayRecharge();
			} else {
				if (t.apiData[0] == UIName.JS_FEED) {
					if (value == UIName.E_CLOSE) {
						switch (t.apiData[1]) {
							case 100 :
								(t.ui[UIName.UI_TASK] as TaskLayer).receiveRewards(false);
								break;
						}
					} else {
						uiDataTransfer([{m:UIDataFunList.SAVE_API_CALLBACK_FEED, a:[t.userData[0]]}], EventNameList.UI_SAVE_DATA);
						uiDataTransfer([{m:UIDataFunList.GET_FEED_RESULT, a:[t.userData[0], t.apiData[2]]}]);
					}
					if (t.apiData[1] == 105) {
						for (var i : uint = 0; i < 2; i++) t.removeChildAt(t.numChildren - 1);
					}
				} else if (t.apiData[0] == UIName.JS_INVITE) {
					if (value != UIName.E_CLOSE) uiDataTransfer([{m:UIDataFunList.SAVE_API_CALLBACK_INVITE, a:[t.userData[0], value.split(',')]}], EventNameList.UI_SAVE_DATA);
				} else if (t.apiData[0] == UIName.JS_PAY) {
					uiDataTransfer([{m:UIDataFunList.GET_MONEY, a:[t.userData[0]]}]);
				}
			}
		}

		/*复制源实例的数据到克隆实例*/
		public static function copyObjData(from : Object, to : Object) : void {
			if (from.data != null) to.data = from.data;
			if (from.name != null) to.name = from.name;
			if (from.dataServerID != null) to.dataServerID = from.dataServerID;
			if (from.dataID != null) to.dataID = from.dataID;
			if (from.dataRaceID != null) to.dataRaceID = from.dataRaceID;
			if (from.dataNameID != null) to.dataNameID = from.dataNameID;
			if (from.dataQuality != null) to.dataQuality = from.dataQuality;
			if (from.dataPower != null) to.dataPower = from.dataPower;
			if (from.dataLevel != null) to.dataLevel = from.dataLevel;
			if (from.dataHonor != null) to.dataHonor = from.dataHonor;
			if (from.dataLifeHP != null) to.dataLifeHP = from.dataLifeHP;
			if (from.dataLifeHPUp != null) to.dataLifeHPUp = from.dataLifeHPUp;
			if (from.dataArmor != null) to.dataArmor = from.dataArmor;
			if (from.dataArmorUp != null) to.dataArmorUp = from.dataArmorUp;
			if (from.dataDefence != null) to.dataDefence = from.dataDefence;
			if (from.dataDefenceUp != null) to.dataDefenceUp = from.dataDefenceUp;
			if (from.dataAttack != null) to.dataAttack = from.dataAttack;
			if (from.dataAttackUp != null) to.dataAttackUp = from.dataAttackUp;
			if (from.dataSkillID != null) to.dataSkillID = from.dataSkillID;
			if (from.dataEquipID != null) to.dataEquipID = from.dataEquipID;
			if (from.dataGemID != null) to.dataGemID = from.dataGemID;
			if (from.dataLangName != null) to.dataLangName = from.dataLangName;
			if (from.dataInfo != null) to.dataInfo = from.dataInfo;
			if (from.common.money.text) to.common.money.text = from.common.money.text;
		}

		/*给兵添加属性，携带所需数据*/
		public static function addSoldierProperty(o : Object, data : Array, className : String, index : uint) : void {
			o.name = UIName.XML_SOLDIER + UIName.CHAR_UNDERLINE + className;
			o.dataID = data[index][0];
			o.dataLevel = data[index][1];
			var xmlList : XMLList = UIXML.soldierXML.soldier.(@id == o.dataID);
			o.dataLangName = String(xmlList.langName[0]);
			o.dataInfo = String(xmlList.tipInfo[0]);
			var common : Object = o.common;
			common.disable.visible = false;
			common.money.text = String(xmlList.paper[0]);
		}

		/*给英雄添加属性，携带所需数据*/
		public static function addHeroProperty(o : Object, data : Array, className : String, index : uint) : void {
			o.name = UIName.XML_HERO + UIName.CHAR_UNDERLINE + className;
			o.dataIndex = index;
			o.data = data[index];
			o.dataServerID = data[index][0];
			o.dataID = data[index][1];
			o.dataRaceID = data[index][2][0];
			o.dataNameID = data[index][2][1];
			o.dataNamePrefixID = data[index][2][2];
			o.dataQuality = data[index][3];
			o.dataPower = data[index][4];
			o.dataLevel = data[index][5];
			o.dataHonor = data[index][6];
			o.dataLifeHP = data[index][7][0];
			o.dataLifeHPUp = data[index][7][1];
			o.dataArmor = data[index][8][0];
			o.dataArmorUp = data[index][8][1];
			o.dataDefence = data[index][9][0];
			o.dataDefenceUp = data[index][9][1];
			o.dataAttack = data[index][10][0];
			o.dataAttackUp = data[index][10][1];
			o.dataScore = data[index][11];
			o.dataSkillID = data[index][12];
			if (data[index][13]) o.dataEquipID = data[index][13];
			if (data[index][14]) o.dataGemID = data[index][14];
			o.dataLangName = String(UIXML.heroNameRaceXML.name.heroNamePrefix.(@id == o.dataNamePrefixID)) + String(UIXML.heroNameRaceXML.name.heroName.(@id == o.dataNameID));
			var common : Object = o.common;
			common.removeChild(common.type);
			common.removeChild(common.money);
			if (o.dataPower == 0) {
				common.disable.alpha = 0.6;
			} else {
				common.disable.visible = false;
			}
		}

		/*给塔添加属性，携带所需数据*/
		public static function addTowerProperty(o : Object, data : Array, className : String, index : uint) : void {
			o.dataType = data[index][0];
			o.dataID = data[index][1];
			o.name = UIName.XML_TOWER + UIName.CHAR_UNDERLINE + className;
			o.dataLevel = data[index][2];
			var xmlList : XMLList = UIXML.towerXML.towerType.(@type == o.dataType).tower.(@id == o.dataID);
			o.dataLangName = String(xmlList.langName[0]);
			o.dataInfo = String(xmlList.info[0]);
			o.common.disable.visible = false;
			o.common.money.text = String(xmlList.paper[0]);
		}

		/*返回用户现有数据，多少钱多少等级多少军令牌等*/
		public static function getUserDataString(type : uint = 1) : String {
			var content : String;
			switch (type) {
				case 1:
					content = String(UIXML.uiXML.userInfo.moneyCurrent[0]) + t.realMoney;
					break;
				case 2:
					content = String(UIXML.uiXML.userInfo.capCurrent[0]) + t.capNum;
					break;
				case 3:
					content = String(UIXML.uiXML.userInfo.levelCurrent[0]) + t.userData[1][2];
					break;
				case 4:
					content = String(UIXML.uiXML.userInfo.tokenCurrent[0]) + t.userData[2][0];
					break;
			}
			return content;
		}

		/*添加CSS*/
		public static function addCSSAndContent(text : TextField, content : String = "") : void {
			var style : StyleSheet = new StyleSheet();
			style.setStyle(UICommand.t.color.red[0], {color:UICommand.t.color.red[1]});
			text.styleSheet = style;
			text.htmlText = content;
		}

		/*替换HTML标签内容*/
		public static function replaceHTML(txt : String) : String {
			return txt.replace(UIName.REGEXP_BR, "<br>").replace(UIName.REGEXP_RED_A, t.color.red[2]).replace(UIName.REGEXP_RED_B, t.color.red[3]);
		}

		/*获得平台API需要显示的内容*/
		public static function getAPI() : String {
			var xmlList : XMLList = UIXML.apiXML[t.apiData[0]].parameter.(@id == t.apiData[1]).node;
			var parameter : String = "";
			var len : uint = xmlList.length();
			for (var i : uint = 0; i < len; i++) {
				if (i) parameter += UIName.CHAR_AND;
				parameter += String(xmlList[i]);
			}
			return parameter;
		}

		/*获得服务器需要的API回调参数session,服务器时间+apiid*/
		public static function getAPIRedirect() : String {
			t.apiData[2] = String(t.serverTime) + String(t.apiData[1]);
			uiDataTransfer([{m:UIDataFunList.SAVE_API, a:[t.userData[0], t.apiData[2]]}], EventNameList.UI_SAVE_DATA);
			return t.userData[0] + UIName.CHAR_AND + t.apiData[2];
		}

		/*获得gamers*/
		public static function getGamers(data : Array) : String {
			var content : String = "";
			if (data) {
				var len : uint = data.length;
				var end : uint = len - 1;
				var i : uint;

				for (i = 0; i < len; i++) {
					content += data[i].join(",");
					if (i != end) content += "|";
				}
			}
			return content;
		}

		/*格式化时间*/
		public static function formatTime(txt : TextField = null, sec : Number = NaN, min : Number = NaN, h : Number = NaN) : String {
			var htxt : String = "";
			var mintxt : String = "";
			var sectxt : String = "";
			if (h || h == 0) {
				htxt = h > 9 ? String(h) + " : " : "0" + h + " : ";
			}
			if (min || min == 0) {
				mintxt = min > 9 ? String(min) + " : " : "0" + min + " : ";
			}
			if (sec || sec == 0) {
				sectxt = sec > 9 ? String(sec) : "0" + sec;
			}
			var time : String = htxt + mintxt + sectxt;
			if (txt != null) txt.text = htxt + mintxt + sectxt;
			return time;
		}

		/*格式化文本内容*/
		public static function formatTextField(tf : TextField) : void {
			var fm : TextFormat = new TextFormat("Arial", 12, 0x999999, null, null, null, null, null, TextFormatAlign.LEFT);
			tf.defaultTextFormat = fm;
		}

		/*生成文本域，用指定字体类*/
		public static function createTF(align : String, color : uint, size : uint, content : String = "", fontName : String = "", gfColor : uint = 0x000001) : TextField {
			var tf : TextField = new TextField();
			var format : TextFormat = new TextFormat();
			if (fontName) {
				tf.embedFonts = true;
				format.font = fontName;
			}
			format.align = align;
			format.color = color;
			format.size = size;
			tf.defaultTextFormat = format;

			tf.text = content;
			tf.width = tf.textWidth + 4;
			tf.height = tf.textHeight;
			if (gfColor != 0) {
				var glowFilter : GlowFilter = new GlowFilter(gfColor, 1, 4, 4, 6);
				tf.filters = [glowFilter];
			}
			return tf;
		}

		static public function get t() : ToolsLayer {
			return _t;
		}

		static public function set t(t : ToolsLayer) : void {
			_t = t;
		}
	}
}