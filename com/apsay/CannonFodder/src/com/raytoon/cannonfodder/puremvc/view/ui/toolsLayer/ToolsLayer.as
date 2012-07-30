package com.raytoon.cannonfodder.puremvc.view.ui.toolsLayer {
	import com.raytoon.cannonfodder.puremvc.view.ui.newUserLayer.NewUserGiftLayer;

	import avmplus.getQualifiedClassName;

	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.FrameLabelPlugin;
	import com.greensock.plugins.FramePlugin;
	import com.greensock.plugins.RemoveTintPlugin;
	import com.greensock.plugins.TintPlugin;
	import com.greensock.plugins.TransformMatrixPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.raytoon.cannonfodder.puremvc.ApplicationFacade;
	import com.raytoon.cannonfodder.puremvc.view.ui.UIMain;
	import com.raytoon.cannonfodder.puremvc.view.ui.backgroundLayer.BackgroundLayer;
	import com.raytoon.cannonfodder.puremvc.view.ui.optionMainLayer.OptionMainLayer;
	import com.raytoon.cannonfodder.puremvc.view.ui.taskLayer.TaskLayer;
	import com.raytoon.cannonfodder.puremvc.view.ui.techTreeLayer.TechTreeLayer;
	import com.raytoon.cannonfodder.tools.net.ClientSocket;
	import com.raytoon.cannonfodder.tools.net.ConstPath;
	import com.raytoon.cannonfodder.tools.utils.EventNameList;
	import com.raytoon.cannonfodder.tools.utils.GlobalVariable;
	import com.raytoon.cannonfodder.tools.utils.NotificationNameList;
	import com.raytoon.cannonfodder.tools.utils.ScrollBar;
	import com.raytoon.cannonfodder.tools.utils.UIClass;
	import com.raytoon.cannonfodder.tools.utils.UICommand;
	import com.raytoon.cannonfodder.tools.utils.UICreate;
	import com.raytoon.cannonfodder.tools.utils.UIDataFunList;
	import com.raytoon.cannonfodder.tools.utils.UIName;
	import com.raytoon.cannonfodder.tools.utils.UIState;
	import com.raytoon.cannonfodder.tools.utils.UITransition;
	import com.raytoon.cannonfodder.tools.utils.UIXML;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.utils.Timer;

	public class ToolsLayer extends Sprite {
		public static const NAME : String = "ToolsLayer";
		/*UI容器*/
		private var _ui : Vector.<Sprite> = new Vector.<Sprite>(22, true);
		/*进攻角色容器*/
		private var _allAttackRole : Vector.<Sprite>;
		/*防御角色容器*/
		private var _allDefenceRole : Vector.<Sprite>;
		/*动画实例*/
		private var _timelineLites : Vector.<TimelineLite> = new Vector.<TimelineLite>();
		/*loader实例数组*/
		private var _loaders : Array = [];
		/*滚动框*/
		private var _scrollBar : ScrollBar;
		/*第一状态机，当前所处界面*/
		private var _stateFirst : String = "";
		/*第二状态机，当前界面进入特殊状态，比如好友状态或者测试布防状态的派兵战斗界面*/
		private var _stateSecond : String = "";
		/*服务器时间*/
		private var _serverTime : Number;
		/*心跳包计数,最后一次请求服务器时间*/
		private var _lastRequest : Array;
		/*服务器同步timer*/
		private var _serverTimeTimer : Timer;
		/*战斗timer*/
		private var _warTimer : Timer;
		/*socket数据加载进度条事件timer*/
		private var _loadingTimer : Timer;
		/*进攻时间*/
		private var _attackTime : uint;
		/*增加战斗时间*/
		private var _increaseTime : uint;
		/*用户数据*/
		private var _userData : Array;
		/*瓶盖数，游戏币*/
		private var _capNum : int;
		/*真实货币*/
		private var _realMoney : int;
		/*对手数据*/
		private var _rivalData : Array = [];
		/*已选择的对手数据*/
		private var _selectedRivalData : Array = [];
		/*地图数据容器*/
		private var _mapData : Object = {};
		/*记录选兵框操作时鼠标值*/
		private var _oldMouseY : Number;
		private var _mouseDownY : Number;
		/*打开格子数*/
		private var _openLockNum : uint;
		/*记录已选择出征角色数据*/
		private var _expendableData : Array = [];
		/*商店数据*/
		private var _shopData : Array = [];
		/*背包数据*/
		private var _bagData : Array = [];
		/*背包选中物品类名*/
		private var _selectedItems : Array = [];
		/*游戏引导数据*/
		private var _gameGuideData : Array = [-1];
		/*API数据*/
		private var _apiData : Array;
		/*按下对象*/
		private var _mouseDownObj : Object;
		/*csscolor*/
		private var _color : Object;

		public function ToolsLayer() {
			UIMain.setInstance(ToolsLayer.NAME, this);
			TweenPlugin.activate([AutoAlphaPlugin, TintPlugin, RemoveTintPlugin, FrameLabelPlugin, FramePlugin, TransformMatrixPlugin]);
			UICommand.t = this;
		}

		/*所有鼠标事件的监听函数*/
		public function mouseEvent(e : MouseEvent) : void {
			/*移除提示框*/
			var stageTop : DisplayObject = stage.getChildAt(this.stage.numChildren - 1);
			if (getQualifiedClassName(stageTop).indexOf(UIClass.TIP_PREFIX) != -1) UICommand.destroy(stageTop);
			// if (e.target is Sprite && e.target.buttonMode) UIMain.mouseCursor = UIMain.NEW_COMMON;

			/*判断socket连接是否断开*/
			if (!ClientSocket.getInstance().connected) {
				ClientSocket.getInstance().connect(ConstPath.DATA_SERVER_URL, ConstPath.DATA_SERVER_PORT);
				trace("Reconnecting...");
				return;
			}
			/*获得事件监听者及其名称*/
			var currentTarget : DisplayObject = e.currentTarget as DisplayObject;
			var currentTargetName : String = currentTarget.name;
			/*获得事件触发者及其名称*/
			var target : DisplayObject = e.target as DisplayObject;
			var targetName : String = target.name;

			/*如果事件触发者的祖先存在，获得祖先及其名称*/
			var targetParent : Sprite = new Sprite();
			var targetParentParent : Sprite = new Sprite();
			var targetParentParentParent : Sprite = new Sprite();
			if (e.target.parent != null && e.target.parent is Sprite) {
				targetParent = e.target.parent as Sprite;
				if (targetParent.parent != null && targetParent.parent is Sprite) {
					targetParentParent = targetParent.parent as Sprite;
					if (targetParentParent.parent != null && targetParentParent.parent is Sprite) {
						targetParentParentParent = targetParentParent.parent as Sprite;
					}
				}
			}

			/*用到的一些变量，正则，正则处理后的信息，临时sprite，numChildren数等*/
			// var pattern:RegExp = /(\D+)(\d+)/;
			// var patternNum : RegExp = new RegExp("\\D", "g");
			var num : int;
			var numA : int;
			var numB : int;
			var sp : Sprite;
			var spA : Sprite;
			var ObjClass : Class;
			var obj : Object;
			var objA : Object;
			var objB : Object;
			var stagePoint : Point;
			var data : Object;
			var boolean : Boolean;
			var string : String = "";
			var xmlList : XMLList;

			/*先判断事件类型，再判断触发者，不同的触发者执行不同的方法*/
			UICommand.mouseEventSound(e);
			switch (e.type) {
				case MouseEvent.CLICK :
					/*确定触发者不是未命名实例，即不是编译器随机命名实例targetName.indexOf(UIName.E_INSTANCE) == -1*/
					// if (targetName.indexOf(UIName.E_INSTANCE) == -1) UICommand.uiDataTransfer([{m:UIDataFunList.SAVE_USER_ACTION, a:[userData[0], MouseEvent.CLICK + ":" + currentTargetName + "-|-" + targetName]}], EventNameList.UI_SAVE_DATA);
					if (currentTargetName == UIClass.NPC_PROMPT) {
						UICommand.changeNPCPrompt(e.currentTarget, targetName);
					} else if (target == ui[UIName.UI_USER_SET]) {
						/*用户设置*/
						UICreate.popupSet();
					} else if (targetParentParent == ui[UIName.UI_USER_INFO]) {
						/*用户信息顶栏*/
						if (targetParent.name == UIName.E_MONEY) {
							// UICommand.changeMoney(10000);
							/*充值*/
							UITransition.inPayRecharge();
							// if (ExternalInterface.available) ExternalInterface.call(UIName.JS_PAY);
						} else if (targetParent.name == UIName.E_TOKEN) {
							if (realMoney < userData[2][6]) {
								UICreate.popupPrompt(String(UIXML.uiXML.notEnough.money[0]) + String(UIXML.uiXML.mark.comma[0]) + String(UIXML.uiXML.phrase.need[0]) + userData[2][6] + String(UIXML.uiXML.phrase.money[0]), UIState.RECHARGE, true);
							} else {
								UICreate.popupToken();
							}
						}
					} else if (currentTargetName == UIClass.SMALL_BAG) {
						/*使用小背包*/
						if (targetName == UIName.E_REMOVE || targetParent.name == UIName.E_ICON) {
							e.currentTarget.icon.removeChildAt(1);
							data = e.currentTarget.data;
							if (data[4] != null) {
								data[4].filters = [];
								if (e.currentTarget.data[1] == 4) UICommand.changeIconNum(data[4].getChildAt(data[4].numChildren - 1) as TextField, 1, e.currentTarget);
							}
							data[3] = null;
							data[4] = null;
							e.currentTarget.remove.comp.enabled = false;
						} else if (targetName == UIName.E_CLOSE) {
							UITransition.outSmallBag(e.currentTarget);
						} else if (targetName == UIName.E_OPEN_SHOP) {
							UITransition.smallBagToShop(currentTarget  as Sprite);
						} else if (e.target.dataLangName != null && e.target.filters.length == 0) {
							UICommand.bagSelected(target as Sprite);
						}
					} else if (targetParentParent.name == UIName.PRESENT_BAG && e.target.buttonMode) {
						/*背包选中物品状态，只有当格子里有东西是才显示选中效果*/
						UICommand.bagSelected(target as Sprite);
					} else if (currentTargetName.indexOf(UIName.E_POPUP) != -1) {
						/*弹出框*/
						UICommand.popupEvent(currentTarget, target, targetName);
					} else {
						switch (stateFirst) {
							case UIState.START :
								/*开始界面*/
								UICommand.removeTaskGuideTip(targetName);
								if (targetParent.name == UIName.E_OPEN_TASK || currentTargetName == (UIName.E_GUIDE + UIName.E_OPEN_TASK)) {
									if (currentTargetName == (UIName.E_GUIDE + UIName.E_OPEN_TASK)) UICommand.nextGuide();
									UITransition.inTask(true);
								} else if (targetParent.name == UIName.E_OPEN_ACTIVTITY) {
									UITransition.startToActivity();
								} else if (targetParent.name == UIName.E_OPEN_GIFT_BAG) {
									addChild(new NewUserGiftLayer());
								} else {
									switch (targetName) {
										/*开始界面中间导航ui[UIName.UI_MAIN_NAV]*/
										case UIName.E_WAR_START :
											UITransition.startToSelectRival();
											break;
										case UIName.E_DEFENCE_START:
											UITransition.startToSelectMap();
											break;
										case UIName.E_HERO_START:
											UITransition.startToHero();
											break;
										case UIName.E_TECH_START:
											UITransition.startToTech();
											break;
										case UIName.E_TAX_START:
											UITransition.startToTax();
											break;
										case UIName.E_OPEN_TOP:
											if (targetParent.name == UIName.E_DISABLE) {
												numA = uint(UIXML.uiXML.mainNav.openTop.open[0]) - userData[1][14];
												num = numA * uint(UIXML.levelXML.relate.friendPrice[0]);
												if (realMoney < num) {
													UICreate.popupPrompt(String(UIXML.uiXML.notEnough.money[0]) + String(UIXML.uiXML.mark.comma[0]) + String(UIXML.uiXML.phrase.need[0]) + num + String(UIXML.uiXML.phrase.money[0]), UIState.RECHARGE, true);
												} else {
													UICreate.popupPrompt(String(UIXML.uiXML.disable.friend.info[0]) + numA + String(UIXML.uiXML.disable.friend.info[1]) + String(UIXML.uiXML.disable.info[3]) + String(UIXML.uiXML.mark.comma[0]) + String(UIXML.uiXML.phrase.need[0]) + num + String(UIXML.uiXML.phrase.money[0]), UIState.OPEN_TOP, true, num);
												}
											} else {
												UITransition.startToTop();
											}
											break;
										/*开始界面左下栏次级导航ui[UIName.UI_SECONDARY_NAV]*/
										case UIName.E_OPEN_DOSSIER:
											UITransition.inDossier(userData[1][0], userData[1][1]);
											break;
										case UIName.E_OPEN_ANNOUNCEMENT:
											UITransition.startToAnnouncement();
											break;
										case UIName.E_OPEN_REPORT:
											if (userData[1][13]) {
												targetParent.removeChildAt(targetParent.numChildren - 1);
												userData[1][13] = false;
											}
											UITransition.startToReport();
											break;
										case UIName.E_OPEN_SHOP:
											UITransition.startToShop();
											break;
										case UIName.E_OPEN_BAG:
											UITransition.toBag();
											break;
										case UIName.E_OPEN_HANDBOOK:
											UITransition.startToHandbook();
											break;
										default:
											/*好友栏界面*/
											UICommand.friendEvent(e.target);
											break;
									}
								}
								break;
							case UIState.PAY_RECHARGE :
								/*充值界面*/
								if (targetName == UIName.E_CLOSE) {
									UITransition.outPayRecharge(targetParent);
								} else if (targetName.indexOf(UIName.E_SUBMIT) != -1) {
									UICommand.uiDataTransfer([{m:UIDataFunList.GET_PAY, a:[userData[0], 99 + uint(targetName.replace(/\D/g, ""))]}]);
								}
								break;
							case UIState.ANNOUNCEMENT :
								/*公告界面*/
								if (targetName == UIName.E_CLOSE) {
									UITransition.announcementToStart(targetParent);
								} else if (targetName == UIName.E_SUBMIT) {
									navigateToURL(new URLRequest(String(UIXML.annXML.help[0])), "_blank");
								} else if (targetName == UIName.E_PLAYBACK) {
									(UIMain.getInstance(UIMain.NAME) as UIMain).showIntroMovie();
								} else if (targetName == UIClass.ACTIVTITY_ANN) {
									navigateToURL(new URLRequest(String(UIXML.eventXML.link[0])), "_blank");
								}
								break;
							case UIState.DOSSIER :
								/*名片界面*/
								if (targetName == UIName.E_CLOSE) {
									UITransition.outDossier();
								} else if (targetName == UIName.E_PREV || targetName == UIName.E_NEXT || targetName.indexOf(UIClass.NUM_PREFIX) != -1) {
									obj = ui[UIName.UI_DOSSIER].getChildAt(ui[UIName.UI_DOSSIER].numChildren - 1);
									objA = ui[UIName.UI_DOSSIER].getChildAt(ui[UIName.UI_DOSSIER].numChildren - 2);
									UICommand.pagesNumEvent(ui[UIName.UI_DOSSIER], obj as Sprite, objA as DisplayObject, targetName);
								}
								break;
							case UIState.TASK :
								/*任务界面*/
								if (targetName == UIName.E_SUBMIT) {
									(ui[UIName.UI_TASK] as TaskLayer).taskSubmit();
								} else if (targetName == UIName.E_CLOSE) {
									UITransition.outTask();
								}
								break;
							case UIState.ACTIVTITY :
								/*活动界面*/
								if (targetName == UIName.E_CLOSE) UITransition.activityToStart(currentTarget);
								break;
							case UIState.HERO :
								/*英雄界面*/
								if (targetParentParent.name == UIName.PRESENT_HAD_HERO) {
									UITransition.inHeroAttribute(((targetParentParent as Sprite).getChildAt(0) as Sprite).getChildAt((targetParent as Sprite).getChildIndex(target)));
								} else {
									switch (targetName) {
										case UIName.E_CLOSE:
											if ((ui[UIName.UI_HERO] as Object).dataFrom == UIState.BAG) {
												UITransition.toBag();
											} else {
												UITransition.heroToStart();
											}
											break;
										case UIName.E_REFRESH:
											num = uint(UIXML.heroXML.heroRelate.refreshMoney[0]);
											if (capNum < num) {
												UICreate.popupPrompt(String(UIXML.uiXML.notEnough.cap[0]) + String(UIXML.uiXML.mark.comma[0]) + String(UIXML.uiXML.phrase.need[0]) + String(num) + String(UIXML.uiXML.phrase.cap[0]));
											} else {
												UICreate.popupPrompt(String(UIXML.uiXML.refreshHero.need[0]) + String(num) + String(UIXML.uiXML.phrase.cap[0]), UIState.REFRESH_HERO, true);
											}
											break;
										case UIName.E_SUBMIT:
											num = int(e.target.parent.money.text);
											numA = ((ui[UIName.UI_HERO].getChildByName(UIName.PRESENT_HAD_HERO) as Sprite).getChildAt(0) as Sprite).numChildren;
											if (capNum < num) {
												UICreate.popupPrompt(String(UIXML.uiXML.notEnough.cap[0]) + String(UIXML.uiXML.mark.comma[0]) + String(UIXML.uiXML.phrase.need[0]) + num + String(UIXML.uiXML.phrase.cap[0]));
											} else if (openLockNum == numA) {
												UICreate.popupPrompt(String(UIXML.uiXML.notEnough.grid[0]));
											} else {
												UICreate.popupPrompt(String(UIXML.uiXML.hireHero.prompt1[0]) + e.target.parent.langName.text + String(UIXML.uiXML.hireHero.prompt2[0]) + num + String(UIXML.uiXML.phrase.cap[0]), UIState.HIRE_HERO, true, e.target.parent);
											}
											break;
										case UIName.E_ATTRIBUTE:
											UITransition.inHeroAttribute(e.target.parent.card.getChildAt(0), true);
											break;
										case UIName.E_LOCK:
											UICommand.lockPopupEvent(UIXML.levelXML.relate.gridPrice.hero.price);
											break;
									}
								}
								break;
							case UIState.HERO_ATTRIBUTE :
								/*英雄属性界面*/
								switch (targetName) {
									case UIName.E_CLOSE:
										UITransition.outHeroAttribute(targetParentParentParent);
										break;
									case UIName.E_SUBMIT:
										if (realMoney < uint(UIXML.heroXML.heroRelate.powerMoney[0])) {
											UICreate.popupPrompt(String(UIXML.uiXML.notEnough.money[0]) + String(UIXML.uiXML.mark.comma[0]) + String(UIXML.uiXML.phrase.need[0]) + String(UIXML.heroXML.heroRelate.powerMoney[0]) + String(UIXML.uiXML.phrase.money[0]), UIState.RECHARGE, true);
										} else {
											UICreate.popupPrompt(String(UIXML.uiXML.heroPower.info[1]) + String(UIXML.heroXML.heroRelate.powerMoney[0]) + String(UIXML.uiXML.phrase.money[0]), UIState.HERO_POWER, true, targetParentParentParent);
										}
										break;
									case UIName.E_REMOVE:
										UICreate.popupPrompt(String(UIXML.uiXML.hireHero.prompt3[0]), UIState.REMOVE_HERO, true, targetParentParentParent);
										break;
									default:
										if (targetName.indexOf(UIName.E_ADD) != -1) {
											if (targetName.indexOf(UIName.E_GEM) != -1) {
												UITransition.inSmallBag(3, targetParentParentParent);
											} else if (targetName.indexOf(UIName.E_EQUIPMENT) != -1) {
												UITransition.inSmallBag(4, targetParentParentParent);
											}
										}
										break;
								}
								break;
							case UIState.TOP :
								/*排行榜界面*/
								switch (targetName) {
									case UIName.E_CLOSE:
										UITransition.topToStart();
										break;
									case UIName.E_OPEN_DOSSIER:
										UITransition.inDossier(e.target.parent.data[1], e.target.parent.data[2]);
										break;
									case UIName.E_OPEN_FRIEND:
										UICreate.getTopFriend();
										break;
									case UIName.E_ALL:
										UICreate.getTopGlobal();
										break;
									case UIName.E_SUBMIT:
										selectedRivalData = e.target.parent.dataRival;
										mapData.mapId = e.target.parent.dataMapID;
										UITransition.topToSelectAttackRole();
										break;
								}
								break;
							case UIState.REPORT :
								/*战报界面*/
								switch (targetName) {
									case UIName.E_RECEIVE:
										UICreate.popupReward(e.target.parent);
										break;
									case UIName.E_PLAYBACK:
										UITransition.reportToWarProgressPlayback(e.target.parent.data[0]);
										break;
									case UIName.E_ALL:
										UICreate.popupAppraise(e.target.parent.data[0]);
										break;
									case UIName.E_OPEN_DOSSIER:
										UITransition.inDossier(e.target.parent.data[3], e.target.parent.data[4]);
										break;
									case UIName.E_MONEY:
										data = e.target.parent.data;
										xmlList = UIXML.mapXML.maps.(@id == data[10]);
										num = uint(xmlList.inToken[0]);
										numA = uint(xmlList.inCap[0]);
										numB = uint(UIXML.levelXML.relate.warPrice[0]);
										if (userData[2][0] < num) {
											if (realMoney < userData[2][6]) {
												UICreate.popupPrompt(String(UIXML.uiXML.notEnough.token[0]) + String(UIXML.uiXML.mark.comma[0]) + String(UIXML.uiXML.notEnough.money[0]) + String(UIXML.uiXML.notEnough.complement.buyToken[0]) + String(UIXML.uiXML.mark.comma[0]) + String(UIXML.uiXML.phrase.need[0]) + userData[2][6] + String(UIXML.uiXML.phrase.money[0]), UIState.RECHARGE, true);
											} else {
												UICreate.popupToken(String(UIXML.uiXML.notEnough.token[0]) + String(UIXML.uiXML.mark.comma[0]));
											}
										} else if (capNum < numA) {
											UICreate.popupPrompt(String(UIXML.uiXML.notEnough.cap[0]) + String(UIXML.uiXML.mark.comma[0]) + String(UIXML.uiXML.phrase.need[0]) + numA + String(UIXML.uiXML.phrase.cap[0]));
										} else if (realMoney < numB) {
											UICreate.popupPrompt(String(UIXML.uiXML.notEnough.money[0]) + String(UIXML.uiXML.mark.comma[0]) + String(UIXML.uiXML.phrase.need[0]) + num + String(UIXML.uiXML.phrase.money[0]), UIState.RECHARGE, true);
										} else {
											string = String(UIXML.uiXML.phrase.need[0]) + num + String(UIXML.uiXML.phrase.token[0]) + String(UIXML.uiXML.mark.comma[0]) + numA + String(UIXML.uiXML.phrase.cap[0]) + String(UIXML.uiXML.mark.comma[0]) + numB + String(UIXML.uiXML.phrase.money[0]) + String(UIXML.uiXML.mark.comma[0]) + String(UIXML.uiXML.report.revenge[0]);
											UICreate.popupPrompt(string, UIState.MONEY_WAR, true, [data[3], data[4], data[5], data[10], num, numA, numB]);
										}
										break;
									case UIName.E_CLOSE:
										UITransition.reportToStart();
										break;
								}
								break;
							case UIState.TECH :
								/*科技界面*/
								obj = (ui[UIName.UI_TECH] as Object).list;
								objA = obj.getChildByName(UIClass.TECH_SCROLL).scrollContent.getChildAt(1).getChildAt(0);
								if (targetParentParent == objA || targetName == (UIName.E_GUIDE + UIName.XML_SOLDIER)) {
									if (targetName == (UIName.E_GUIDE + UIName.XML_SOLDIER)) {
										UICommand.removeGuideHighlight();
										gameGuideData[0] = 2;
									} else {
										if ((ui[UIName.UI_TECH] as Object).info.dataTC || obj.dataTC) return;
										(UIMain.getInstance(TechTreeLayer.NAME) as TechTreeLayer).changeSelected(e.target);
									}
									UITransition.techInfoSwitch();
									UICreate.getTechInfo(objA.name, e.target);
								} else {
									switch (targetName) {
										case UIName.E_SOLDIER:
											UITransition.techListSwitch(TechTreeLayer.SOLDIER_TECH_TREE);
											break;
										case UIName.E_TOWER:
											UITransition.techListSwitch(TechTreeLayer.TOWER_TECH_TREE);
											break;
										case UIName.E_OPEN_SHOP:
											UITransition.techToShop();
											break;
										case UIName.E_OPEN_HANDBOOK:
											UITransition.techToHandbook();
											break;
										case UIName.E_CLOSE:
											if ((ui[UIName.UI_BAG] as Object).state != null) {
												UITransition.toBag();
											} else {
												if (currentTargetName.indexOf(UIName.E_GUIDE) != -1) {
													stateFirst = "";
													UICommand.nextGuide();
												}
												UITransition.techToStart();
											}
											break;
										default:
											if (targetName == UIName.E_SUBMIT || targetName == UIName.E_UP) {
												try {
													if (e.target.dataMaterials) {
														data = e.target.dataMaterials;
														num = data.length;
														if (num > 0) {
															string += (String(data[0][1]) + String(UIXML.materialXML.material.(@id == data[0][0]).langName[0]));
														} else if (num > 1) {
															if (string) string += String(UIXML.uiXML.mark.comma[0]);
															string += (String(data[1][1]) + String(UIXML.materialXML.material.(@id == data[1][0]).langName[0]));
														}
													}
												} catch (error : Error) {
													trace(error.toString());
												}
												if (string) string += String(UIXML.uiXML.mark.comma[0]);
												string += (e.target.dataCap + String(UIXML.uiXML.phrase.cap[0]));
												UICreate.popupPrompt(String(UIXML.uiXML.tech.info1[0]) + String(UIXML.uiXML.tech.info2[0]) + string, UIState.TECH_START, true, e.target);
											}
											break;
									}
								}
								break;
							case UIState.TAX :
								/*税收界面*/
								if (targetName == UIName.E_SUBMIT) {
									UICreate.popupPrompt(e.target.dataPrompt.replace("{_TIME_}", e.target.parent.hourNum.text), UIState.TAX_START, true, targetParentParentParent);
								} else if (targetName == UIName.E_REMOVE) {
									userData[4][2][1] = null;
									UICreate.popupPrompt(String(UIXML.uiXML.prompt.cancel[0]), UIState.TAX_END, true);
								} else if (targetName == UIName.E_RECEIVE) {
									if (userData[4][1] == null) {
										/*税收领取完成，重新进入未开启状态*/
										if (userData[4][2] != null) userData[4][2][1] = 0;
										UICommand.taxReceiveOrEnd();
									} else {
										userData[4][2][1] = (int((userData[4][1][1] - serverTime) / 3600000) + 1) * userData[4][2][2];
										if (realMoney < userData[4][2][1]) {
											UICreate.popupPrompt(String(UIXML.uiXML.notEnough.money[0]) + String(UIXML.uiXML.mark.comma[0]) + String(UIXML.uiXML.phrase.need[0]) + userData[4][2][1] + String(UIXML.uiXML.phrase.money[0]), UIState.RECHARGE, true);
										} else {
											UICreate.popupPrompt(String(UIXML.uiXML.tax.info[1]) + userData[4][2][1] + String(UIXML.uiXML.phrase.money[0]), UIState.TAX_END, true);
										}
									}
								} else if (targetName == UIName.JS_FEED) {
									apiData = [UIName.JS_FEED, 107];
									if (ExternalInterface.available) ExternalInterface.call(UIName.JS_FEED, UICommand.getAPI(), UICommand.getAPIRedirect());
								} else if (targetName == UIName.E_CLOSE) {
									UITransition.taxToStart();
								}
								break;
							case UIState.BAG :
								/*背包界面*/
								if (targetName == UIName.E_HERO_START) {
									UITransition.bagToHero();
								} else if (targetName == UIName.E_TECH_START) {
									UITransition.bagToTech();
								} else if (targetName == UIName.E_OPEN_SHOP) {
									UITransition.bagToShop();
								} else if (targetName == UIName.E_CLOSE) {
									UITransition.bagToStart();
								} else if (targetName == UIName.E_SUBMIT) {
									UICommand.useGoodsPopupEvent();
								} else if (targetName == UIName.E_SALE) {
									UICreate.popupNum(UIState.SALE_GOODS);
								} else if (targetName == UIName.E_PREV || targetName == UIName.E_NEXT || targetName.indexOf(UIClass.NUM_PREFIX) != -1) {
									obj = ui[UIName.UI_BAG].getChildAt(ui[UIName.UI_BAG].numChildren - 1);
									objA = ui[UIName.UI_BAG].getChildAt(ui[UIName.UI_BAG].numChildren - 2);
									UICommand.pagesNumEvent(ui[UIName.UI_BAG], obj as Sprite, objA as DisplayObject, targetName);
								} else if (targetParent.name == UIName.E_NAV) {
									UICommand.navSelected(target);
									UICommand.changeBag();
								}
								break;
							case UIState.SHOP :
								/*商店界面*/
								if (targetName == UIName.E_CLOSE) {
									obj = getChildByName(UIClass.SMALL_BAG);
									if (obj) {
										UITransition.shopToSmallBag();
									} else if ((ui[UIName.UI_SHOP] as Object).dataFrom == UIState.BAG) {
										UITransition.toBag();
									} else if ((ui[UIName.UI_SHOP] as Object).dataFrom == UIState.TECH) {
										UITransition.shopToTech();
									} else {
										UITransition.shopToStart();
									}
								} else if (targetName == UIName.E_SUBMIT) {
									obj = e.target.parent.parent;
									num = obj.data[2];
									if (num == 0) {
										UICreate.popupPrompt(String(UIXML.uiXML.shop.info[0]));
									} else if (e.target.parent.name == UIName.E_CAP) {
										if (capNum < obj.dataCap) {
											UICreate.popupPrompt(String(UIXML.uiXML.notEnough.cap[0]) + String(UIXML.uiXML.mark.comma[0]) + String(UIXML.uiXML.phrase.need[0]) + obj.dataCap + String(UIXML.uiXML.phrase.cap[0]));
										} else {
											UICreate.popupNum(UIState.SHOP_CAP, obj);
										}
									} else if (e.target.parent.name == UIName.E_MONEY) {
										if (realMoney < obj.dataMoney) {
											UICreate.popupPrompt(String(UIXML.uiXML.notEnough.money[0]) + String(UIXML.uiXML.mark.comma[0]) + String(UIXML.uiXML.phrase.need[0]) + obj.dataMoney + String(UIXML.uiXML.phrase.money[0]), UIState.RECHARGE, true);
										} else {
											UICreate.popupNum(UIState.SHOP_MONEY, obj);
										}
									}
								} else if (targetParent.name == UIName.E_NAV) {
									UICommand.destroyScroll();
									UICommand.navSelected(target);
									switch (targetName) {
										case UIName.E_ALL:
											var newAry : Array = UICreate.getSpecialGoods(shopData);
											UICreate.addGoods(newAry);
											break;
										case UIName.E_PROP:
											UICreate.addGoods(shopData[0]);
											break;
										case UIName.E_MATERIAL:
											UICreate.addGoods(shopData[1]);
											break;
										case UIName.E_GEM:
											UICreate.addGoods(shopData[2]);
											break;
										case UIName.E_EQUIPMENT:
											UICreate.addGoods(shopData[3]);
											break;
									}
								}
								break;
							case UIState.HANDBOOK :
								/*图鉴界面*/
								if (targetName == UIName.E_SOLDIER || targetName == UIName.E_TOWER) {
									/*先销毁分页再销毁背包容器*/
									UICommand.destroy(ui[UIName.UI_HANDBOOK].getChildAt(ui[UIName.UI_HANDBOOK].numChildren - 2));
									UICommand.destroy(ui[UIName.UI_HANDBOOK].getChildAt(ui[UIName.UI_HANDBOOK].numChildren - 2));
									(ui[UIName.UI_HANDBOOK] as Object).soldier.comp.enabled = !(ui[UIName.UI_HANDBOOK] as Object).soldier.comp.enabled;
									(ui[UIName.UI_HANDBOOK] as Object).tower.comp.enabled = !(ui[UIName.UI_HANDBOOK] as Object).tower.comp.enabled;
									if (targetName == UIName.E_SOLDIER) {
										(ui[UIName.UI_HANDBOOK] as Object).state = UIName.XML_SOLDIER;
										UICreate.initHandbook((ui[UIName.UI_HANDBOOK] as Object).data[0], UIName.XML_SOLDIER);
										(ui[UIName.UI_HANDBOOK] as Object).txt.text = String(UIXML.uiXML.handbook.title1[0]);
									} else if (targetName == UIName.E_TOWER) {
										(ui[UIName.UI_HANDBOOK] as Object).state = UIName.XML_TOWER;
										UICreate.initHandbook((ui[UIName.UI_HANDBOOK] as Object).data[1], UIName.XML_TOWER);
										(ui[UIName.UI_HANDBOOK] as Object).txt.text = String(UIXML.uiXML.handbook.title2[0]);
									}
								} else if (targetName == UIName.E_CLOSE) {
									if ((ui[UIName.UI_HANDBOOK] as Object).dataFrom == UIState.TECH) {
										UITransition.handbookToTech();
									} else {
										UITransition.handbookToStart();
									}
								} else if (targetName == UIName.E_PREV || targetName == UIName.E_NEXT || targetName.indexOf(UIClass.NUM_PREFIX) != -1) {
									obj = ui[UIName.UI_HANDBOOK].getChildAt(ui[UIName.UI_HANDBOOK].numChildren - 2);
									objA = ui[UIName.UI_HANDBOOK].getChildAt(ui[UIName.UI_HANDBOOK].numChildren - 3);
									UICommand.pagesNumEvent(ui[UIName.UI_HANDBOOK], obj as Sprite, objA as DisplayObject, targetName);
									if ((ui[UIName.UI_HANDBOOK] as Object).dataSelectedPage == (ui[UIName.UI_HANDBOOK] as Object).dataCurrent) {
										(ui[UIName.UI_HANDBOOK] as Object).selected.visible = true;
									} else {
										(ui[UIName.UI_HANDBOOK] as Object).selected.visible = false;
									}
								} else if ((e.target is Sprite) && e.target.dataIndex != null) {
									if ((ui[UIName.UI_HANDBOOK] as Object).state == UIName.XML_SOLDIER) {
										string = UIName.XML_SOLDIER;
										data = (ui[UIName.UI_HANDBOOK] as Object).data[0];
									} else if ((ui[UIName.UI_HANDBOOK] as Object).state == UIName.XML_TOWER) {
										string = UIName.XML_TOWER;
										data = (ui[UIName.UI_HANDBOOK] as Object).data[1];
									}
									UICommand.changeCardSelected(target, (ui[UIName.UI_HANDBOOK] as Object).selected);
									UICreate.getHandbookContent(ui[UIName.UI_HANDBOOK], data[e.target.dataIndex], string);
								}
								break;
							case UIState.SELECT_RIVAL :
								/*匹配对手界面*/
								if (targetParent.name == UIName.E_NAV) {
									num = targetParent.getChildIndex(target);
									if (num > 0) {
										rivalData[0][0][2] = rivalData[0][0][0];
										rivalData[0][0][0] = num;
										rivalData[0][0][1] = num - 1;
										if (rivalData[num] == null) {
											UICommand.uiDataTransfer([{m:UIDataFunList.GET_RIVAL, a:[UICommand.t.userData[0], false, num]}]);
										} else {
											UICreate.getRivalContent();
										}
									}
								} else if (targetName == UIName.E_SUBMIT || targetName == UIName.E_ICON) {
									/*0[用户ID[0],用户等级[1],用户头像(url)[2],用户名[3],地图ID[4],用户主页[5]],1[地图...]*/
									num = rivalData[rivalData[0][0][0]][1][2];
									numA = rivalData[rivalData[0][0][0]][1][3];
									data = rivalData[rivalData[0][0][0]][0][e.target.parent.dataIndex];
									if (targetName == UIName.E_SUBMIT) {
										if (userData[2][0] < num) {
											if (realMoney < userData[2][6]) {
												UICreate.popupPrompt(String(UIXML.uiXML.notEnough.token[0]) + String(UIXML.uiXML.mark.comma[0]) + String(UIXML.uiXML.notEnough.money[0]) + String(UIXML.uiXML.notEnough.complement.buyToken[0]) + String(UIXML.uiXML.mark.comma[0]) + String(UIXML.uiXML.phrase.need[0]) + userData[2][6] + String(UIXML.uiXML.phrase.money[0]), UIState.RECHARGE, true);
											} else {
												UICreate.popupToken(String(UIXML.uiXML.notEnough.token[0]) + String(UIXML.uiXML.mark.comma[0]));
											}
										} else if (capNum < numA) {
											UICreate.popupPrompt(String(UIXML.uiXML.notEnough.cap[0]) + String(UIXML.uiXML.mark.comma[0]) + String(UIXML.uiXML.phrase.need[0]) + numA + String(UIXML.uiXML.phrase.cap[0]));
										} else {
											selectedRivalData = [data[0], data[3], data[1]];
											mapData.mapId = data[4];
											UICommand.changeToken(-num);
											capNum -= numA;
											UICommand.uiDataTransfer([{m:UIDataFunList.SAVE_WAR_START, a:[userData[0], [1, num, numA, 0, selectedRivalData[0], mapData.mapId, 0]]}], EventNameList.UI_SAVE_DATA);
											UITransition.selectRivalToSelectAttackRole();
										}
									} else if (data[5]) {
										navigateToURL(new URLRequest(data[5]), "_blank");
									}
								} else if (targetName == UIName.E_REFRESH) {
									UICommand.destroyLoaders();
									UICommand.restoreRivalMatch();
									UICommand.uiDataTransfer([{m:UIDataFunList.GET_RIVAL, a:[UICommand.t.userData[0], true, rivalData[0][0][0]]}]);
								} else if (targetName == UIName.E_CLOSE) {
									UITransition.selectRivalToStart();
								}
								break;
							case UIState.SELECT_ATTACT_ROLE :
								/*派兵界面选兵框*/
								/*出征框踢出角色----在派兵界面的选兵框选择角色*/
								if (targetName == UIName.E_SUBMIT) {
									if (expendableData[1] != null && expendableData[1].length != 0 && UICommand.expendablePaperIsMin(expendableData[1])) {
										if (currentTargetName.indexOf(UIName.E_GUIDE) != -1) {
											UICommand.removeGuideHighlight();
											gameGuideData[0] = 6;
											gameGuideData[3].push({m:UIDataFunList.SAVE_EXPENDABLE, a:[userData[0], expendableData[1]]});
										} else if (stateSecond != UIState.TEST_MAP) {
											UICommand.verifyExpendable();
											UICommand.uiDataTransfer([{m:UIDataFunList.SAVE_EXPENDABLE, a:[userData[0], expendableData[1]]}], EventNameList.UI_SAVE_DATA);
										}
										openLockNum = 0;
										// expendableData = [];
										UITransition.selectAttackRoleToWarProgress();
									} else {
										UICreate.popupPrompt(String(UIXML.uiXML.selectAttackRole.noSelect[0]) + UICommand.getPaperNum() + String(UIXML.uiXML.phrase.soldier[0]));
									}
								} else if (targetName == UIName.E_CLOSE) {
									if (stateSecond == UIState.FRIEND || stateSecond == UIState.TEST_MAP) {
										UITransition.outSelectAttackRoleToOther();
									} else {
										UICreate.popupPrompt(String(UIXML.uiXML.prompt.cancel[0]), UIState.CLOSE_SELECT_ATTACT_ROLE, true);
									}
								} else if (targetName == UIName.E_PREV) {
									e.target.comp.enabled = false;
									objA = (ui[UIName.UI_SELECT_ATTACK_ROLE] as Object).attackRole;
									objB = objA.getChildByName(UIClass.ROLE_SCROLL).scrollContent.getChildAt(1).getChildAt(1);
									obj = getChildByName(UIName.PRESENT_EXPENDABLE);
									if (obj) {
										num = -1;
										if (expendableData && expendableData[0]) num = 0;
										UICommand.removeAllChild(obj as Sprite, num);
										UICommand.changeAttackRoleCard(objB as Sprite, false, true);
									}
									data = UICommand.handlePrevExpendable(objA.dataPrev.slice(), objB as Sprite);
									expendableData[1] = data[0];
									UICreate.getPrevExpendable(data[1], objB as Sprite);
								} else if (targetName == UIName.E_LEFT ) {
									obj = e.currentTarget.parent.tower;
									if (obj.dataMoveNum > 0) {
										obj.dataMoveNum -= 1;
										obj.dataBox.x += GlobalVariable.RECT_WIDTH;
										obj.right.visible = true;
										if (obj.dataMoveNum == 0) {
											obj.left.visible = false;
										}
									}
								} else if (targetName == UIName.E_RIGHT) {
									obj = e.currentTarget.parent.tower;
									if (obj.dataMoveNum < obj.dataMoveSum) {
										obj.dataMoveNum += 1;
										obj.dataBox.x -= GlobalVariable.RECT_WIDTH;
										obj.left.visible = true;
										if (obj.dataMoveNum == obj.dataMoveSum) {
											obj.right.visible = false;
										}
									}
								} else if (targetName == UIName.E_UP || targetName == UIName.E_DOWN) {
									objA = (ui[UIName.UI_SELECT_ATTACK_ROLE] as Object).attackRole;
									UICommand.pagesNumEvent(objA, objA.dataMax, objA.getChildByName(UIName.PRESENT_ATTACK_HERO), targetName);
								} else if (currentTargetName == UIName.PRESENT_HERO_ATTRIBUTE) {
									/*英雄卡片上的属性按钮*/
									num = (currentTarget as Sprite).getChildIndex(target);
									obj = (getChildByName(UIName.PRESENT_EXPENDABLE) as Sprite).getChildAt(num);
									UITransition.inHeroAttribute(obj);
								} else if (currentTargetName == UIName.E_LOCK) {
									UICommand.lockPopupEvent(UIXML.levelXML.relate.gridPrice.soldier.price, false);
								} else if ((ui[UIName.UI_SELECT_ATTACK_ROLE] as Object).dataTC == null && (targetName.indexOf(UIName.XML_HERO + UIName.CHAR_UNDERLINE) != -1 || targetName.indexOf(UIName.XML_SOLDIER + UIName.CHAR_UNDERLINE) != -1)) {
									objA = (ui[UIName.UI_SELECT_ATTACK_ROLE] as Object).attackRole;
									// 表示为英雄
									numA = 0;
									if (targetName.indexOf(UIName.XML_SOLDIER + UIName.CHAR_UNDERLINE) != -1) {
										// 表示为兵
										numA = 1;
										if (objA.dataPrev && !objA.prev.comp.enabled) objA.prev.comp.enabled = true;
									}
									if (targetParent.name == UIName.PRESENT_EXPENDABLE) {
										/*出兵框踢出角色*/
										boolean = false;
										if (numA == 0) {
											/*如果是英雄要移除使用神灯按钮*/
											spA = this.getChildByName(UIName.PRESENT_HERO_ATTRIBUTE) as Sprite;
											spA.removeChildAt(targetParent.getChildIndex(target));
											expendableData[0] = null;
											objB = objA.getChildByName(UIName.PRESENT_ATTACK_HERO);
											num = objB.getChildByName(targetName).dataIndex;
											obj = objB.getChildAt(num % 8);
											UICommand.pagesNumEvent(objA, objA.dataMax, objA.getChildByName(UIName.PRESENT_ATTACK_HERO), UIClass.NUM_PREFIX + uint((num / 8) + 1));
											boolean = true;
										} else {
											/*如果兵卡片至少还有两个以上并且不是最后一个，重新排序*/
											num = targetParent.getChildIndex(target);
											if (expendableData[1].length > 1 && targetParent.getChildIndex(target) != targetParent.numChildren - 1) {
												UITransition.expendableForward(target, targetParent);
											}
											if (expendableData[0]) num--;
											if ((8 - expendableData[1].length) == openLockNum) boolean = true;
											expendableData[1].splice(num, 1);
											if (expendableData[1].length == 0) expendableData[1] = null;
											obj = objA.getChildByName(UIClass.ROLE_SCROLL).scrollContent.getChildAt(1).getChildAt(1).getChildByName(targetName);
										}
										stagePoint = target.localToGlobal(new Point(0, 0));
										stagePoint = obj.localToGlobal(new Point(0, 0));
										TweenLite.to(target, 0.4, {x:stagePoint.x, y:stagePoint.y, onComplete:UITransition.expendableToRoleScrollTC, onCompleteParams:[target, obj]});
										obj.state = null;
										obj.dataGemID = e.target.dataGemID ? e.target.dataGemID : null;
										obj.dataEquipID = e.target.dataEquipID ? e.target.dataEquipID : null;
									} else {
										/*在派兵界面的选兵框选择角色*/
										if (targetName.indexOf(UIName.XML_HERO + UIName.CHAR_UNDERLINE) != -1 && e.target.dataPower == 0) {
											if (realMoney < uint(UIXML.heroXML.heroRelate.powerMoney[0])) {
												UICreate.popupPrompt(String(UIXML.uiXML.notEnough.money[0]) + String(UIXML.uiXML.mark.comma[0]) + String(UIXML.uiXML.phrase.need[0]) + String(UIXML.heroXML.heroRelate.powerMoney[0]) + String(UIXML.uiXML.phrase.money[0]), UIState.RECHARGE, true);
											} else {
												UICreate.popupPrompt(String(UIXML.uiXML.heroPower.info[1]) + String(UIXML.heroXML.heroRelate.powerMoney[0]) + String(UIXML.uiXML.phrase.money[0]), UIState.HERO_POWER, true, target);
											}
										} else if (!e.target.common.disable.visible) {
											/*卡片已经使用，禁用*/
											e.target.common.disable.visible = true;
											e.target.useHandCursor = false;
											if (currentTargetName.indexOf(UIName.E_GUIDE) != -1) {
												UICommand.removeGuideHighlight();
												gameGuideData[0] = 5;
												boolean = true;
											}
											if (numA == 0) {
												expendableData[0] = [e.target.dataServerID, e.target.dataGemID];
												numB = 0;
												/*禁用所有英雄卡片*/
												UICommand.changeAttackRoleCard(targetParent as Sprite, true);
											} else {
												if (expendableData[1] == null) expendableData[1] = [];
												numB = expendableData[1].length;
												expendableData[1][numB] = e.target.dataID;
												numB++;
												/*禁用所有兵卡片*/
												if (numB == openLockNum) UICommand.changeAttackRoleCard(targetParent as Sprite, true);
											}
											/*获得选兵框卡片舞台坐标，并复制卡片实例及数据，实现动画飞往出兵框*/
											stagePoint = target.localToGlobal(new Point(0, 0));
											obj = UICommand.cloneInstance(target);
											obj.x = stagePoint.x;
											obj.y = stagePoint.y;
											objB = (obj as Object).common;
											objB.disable.visible = false;
											if (numA == 0) {
												objB.removeChild(objB.type);
												objB.removeChild(objB.money);
											}
											UICommand.copyObjData(e.target, obj);
											UICreate.iconLevel(obj.getChildAt(1) as Sprite, obj.dataLevel);
											addChild(obj as DisplayObject);
											stagePoint = (ui[UIName.UI_SELECT_ATTACK_ROLE] as Object).expendables.box.getChildAt(numB).localToGlobal(new Point(0, 0));
											(ui[UIName.UI_SELECT_ATTACK_ROLE] as Object).dataTC == true;
											TweenLite.to(obj, 0.4, {x:stagePoint.x - 2, y:stagePoint.y - 2, onComplete:UITransition.roleScrollToExpendableTC, onCompleteParams:[obj]});
											if (boolean) UICreate.addGuideHighlight(objA.submit, String(UIXML.gameGuideXML.guide.(@id == 6003).tip.content[5]));
										}
									}
								}
								break;
							case UIState.WAR_PROGRESS:
								/*战斗界面*/
								if (targetParent.name == UIName.PRESENT_EXPENDABLE) {
									/*战斗界面的出兵框*/
									if (targetName == UIClass.CARD_HERO_SKILL) {
										(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).aeleaseHeroSkills(target);
									} else if (targetName.indexOf(UIName.XML_SOLDIER + UIName.CHAR_UNDERLINE) != -1) {
										if (warTimer == null) UICommand.initStartProgress();
										(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).makeSoldier(e.target.dataID, e.target.dataLevel);
										/*得到消耗后的手纸数，并禁用所有消耗大于剩余手纸数的卡片*/
										UICommand.setPaperNum(-uint(e.target.common.money.text));
										UITransition.expendableCD(target as DisplayObjectContainer);
									}
								} else if (targetParent == ui[UIName.UI_STOP_PLAY]) {
									/*战斗界面暂停和播放*/
									if (targetName == UIName.E_STOP_WAR) {
										UICommand.pauseProgress();
									} else {
										UICommand.startProgress();
									}
								}
								break;
							case UIState.SELECT_MAP :
								/*选择地图界面*/
								if ((targetParent == ui[UIName.UI_SELECT_MAP] && targetName.indexOf(UIName.E_CLOSE) != -1) || currentTargetName == (UIName.E_GUIDE + UIName.E_CLOSE)) {
									UITransition.selectMapToStart();
								} else if (targetName == UIName.E_OPEN_DOSSIER) {
									UITransition.inDossier(selectedRivalData[0], selectedRivalData[1]);
								} else if (targetParent.name == UIName.E_DEFENCE || targetName == UIName.E_DEFENCE_START || currentTargetName.indexOf(UIName.E_GUIDE) != -1) {
									mapData.mapId = e.target.dataMapID;
									mapData.submapId = 0;
									mapData.dataPVE = e.target.dataPVE;
									mapData.dataMapName = e.target.dataMapName;
									if (stateSecond == UIState.FRIEND) {
										UICommand.uiDataTransfer([{m:UIDataFunList.SAVE_WAR_START, a:[userData[0], [3, 0, 0, 0, selectedRivalData[0], mapData.mapId, 0]]}], EventNameList.UI_SAVE_DATA);
										UITransition.selectMapToSelectAttackRole();
									} else {
										if (userData[3][3] != null && userData[3][3] == 6003 && gameGuideData[0] == 1) {
											UICommand.removeGuideHighlight();
											gameGuideData[0] = 2;
										}
										UICommand.removeTaskGuideTip("0");
										UITransition.inHurdle();
									}
								} else {
									/*好友栏界面*/
									UICommand.friendEvent(e.target);
								}
								break;
							case UIState.HURDLE :
								/*关卡界面*/
								if (targetName == UIName.E_SUBMIT || targetName == UIName.E_CLOSE) {
									UITransition.outHurdle(currentTarget);
									if (targetName == UIName.E_SUBMIT) {
										UITransition.selectMapToDefence();
									}
								} else if ((targetParentParentParent.name.indexOf(UIName.E_PAGE) != -1 && targetName != UIName.E_DISABLE && !(target is TextField)) || currentTargetName.indexOf(UIName.E_GUIDE) != -1) {
									xmlList = UIXML.mapXML.pveNPC;
									selectedRivalData = [String(xmlList.id[0]), String(xmlList.name[0]), uint(xmlList.level[0])];
									num = e.target.parent.dataToken;
									numA = e.target.parent.dataCap;
									if (userData[2][0] < num) {
										if (realMoney < userData[2][6]) {
											UICreate.popupPrompt(String(UIXML.uiXML.notEnough.token[0]) + String(UIXML.uiXML.mark.comma[0]) + String(UIXML.uiXML.notEnough.money[0]) + String(UIXML.uiXML.notEnough.complement.buyToken[0]) + String(UIXML.uiXML.mark.comma[0]) + String(UIXML.uiXML.phrase.need[0]) + userData[2][6] + String(UIXML.uiXML.phrase.money[0]), UIState.RECHARGE, true);
										} else {
											UICreate.popupToken(String(UIXML.uiXML.notEnough.token[0]) + String(UIXML.uiXML.mark.comma[0]));
										}
									} else if (capNum < numA) {
										UICreate.popupPrompt(String(UIXML.uiXML.notEnough.cap[0]) + String(UIXML.uiXML.mark.comma[0]) + String(UIXML.uiXML.phrase.need[0]) + numA + String(UIXML.uiXML.phrase.cap[0]));
									} else {
										string = String(UIXML.uiXML.phrase.need[0]) + num + String(UIXML.uiXML.phrase.token[0]) + String(UIXML.uiXML.phrase.and[0]) + numA + String(UIXML.uiXML.phrase.cap[0]) + String(UIXML.uiXML.mark.comma[0]) + UIName.CHAR_BREAK + UICommand.getUserDataString(4) + String(UIXML.uiXML.mark.comma[0]) + UICommand.getUserDataString(2);
										obj = currentTarget;
										if (currentTargetName.indexOf(UIName.E_GUIDE) != -1) obj = getChildByName(UIClass.HURDLE);
										UICreate.popupPrompt(string, UIState.PVE, true, [num, numA, e.target.parent.dataSubMapID, obj]);
									}
								} else if (targetName == UIName.E_PREV || targetName == UIName.E_NEXT || targetName.indexOf(UIClass.NUM_PREFIX) != -1) {
									obj = e.currentTarget.getChildAt(e.currentTarget.numChildren - 1);
									objA = e.currentTarget.getChildAt(e.currentTarget.numChildren - 2);
									UICommand.pagesNumEvent(e.currentTarget, obj as Sprite, objA as DisplayObject, targetName);
								}
								break;
							case UIState.DEFENCE :
								/*摆塔布防界面*/
								/*确定触发者不是未命名实例，即为编译器随机命名实例targetName.indexOf(UIName.E_INSTANCE) == -1*/
								if (targetName == UIName.E_UP || targetName == UIName.E_DOWN) {
									UICommand.pagesNumEvent(ui[UIName.UI_DEFENCE_OPERATION], (ui[UIName.UI_DEFENCE_OPERATION] as Object).dataMax, ui[UIName.UI_DEFENCE_OPERATION].getChildByName(UIName.PRESENT_DEFENCE_TOWER), targetName);
								} else if (targetName == UIName.E_CLOSE) {
									UICreate.popupPrompt(String(UIXML.uiXML.defence.close[0]), UIState.CLOSE_MAP, true);
								} else if (targetName == UIName.E_SUBMIT || targetName == UIName.E_TEST) {
									data = (UIMain.getInstance(BackgroundLayer.NAME) as BackgroundLayer).createTowerInfo();
									if (data == null) {
										UICreate.popupPrompt(String(UIXML.uiXML.noData[0]));
									} else {
										for (obj in data) {
											mapData[obj] = data[obj];
										}
										UICommand.uiDataTransfer([{m:UIDataFunList.SAVE_DEFENCE, a:[userData[0], mapData]}], EventNameList.UI_SAVE_DATA);
										if (targetName == UIName.E_SUBMIT) {
											/*保存*/
											UICreate.popupPrompt(String(UIXML.uiXML.defence.save.info[0]), UIState.SAVE_MAP, true);
										} else {
											/*测试*/
											UICreate.popupPrompt(String(UIXML.uiXML.defence.test.info[0]), UIState.TEST_MAP, true);
										}
									}
								} else if (targetName == UIName.E_REFRESH) {
									/*刷新地图*/
									num = uint(UIXML.levelXML.relate.refreshMapPrice[0]);
									if (capNum < num) {
										UICreate.popupPrompt(String(UIXML.uiXML.notEnough.cap[0]) + String(UIXML.uiXML.mark.comma[0]) + String(UIXML.uiXML.phrase.need[0]) + num + String(UIXML.uiXML.phrase.cap[0]));
									} else {
										string = String(UIXML.uiXML.defence.refresh.info[0]) + num + String(UIXML.uiXML.phrase.cap[0]) + String(UIXML.uiXML.mark.comma[0]) + UIName.CHAR_BREAK + UICommand.getUserDataString(2);
										UICreate.popupPrompt(string, UIState.REFRESH_MAP, true);
									}
								} else if (targetName == UIName.E_REMOVE) {
									/*移除塔*/
									(UIMain.getInstance(BackgroundLayer.NAME) as BackgroundLayer).addScoop();
								} else if (targetParent.name == UIName.PRESENT_DEFENCE_TOWER && !e.target.common.disable.visible) {
									/*选择塔卡片*/
									UICommand.changeCardSelected(target, (ui[UIName.UI_DEFENCE_OPERATION] as Object).selected);
									(UIMain.getInstance(BackgroundLayer.NAME) as BackgroundLayer).addTowers(e.target.dataType, e.target.dataID, e.target.dataLevel);
								}
								break;
						}
					}
					break;
				case MouseEvent.ROLL_OVER :
					if (e.target is Sprite && e.target.buttonMode) UIMain.mouseCursor = UIMain.NEW_BUTTON;
					if (target != ui[UIName.UI_USER_SET]) {
						if (targetParent == ui[UIName.UI_USER_INFO]) {
							/*用户信息提示框*/
							switch (targetName) {
								case UIName.E_LEVEL:
									UICreate.createTooltips(String(UIXML.uiXML.phrase.level[0]), String(UIXML.uiXML.userInfo.levelCurrent[0]) + userData[1][2] + UIName.CHAR_BREAK + String(UIXML.uiXML.userInfo.levelNext[0]) + e.target.dataBetween + String(UIXML.uiXML.phrase.experience[0]), target);
									break;
								case UIName.E_CAP:
									UICreate.createTooltips(String(UIXML.uiXML.phrase.cap[0]), String(UIXML.uiXML.userInfo.capInfo[0]), target);
									break;
								case UIName.E_MONEY:
									UICreate.createTooltips(String(UIXML.uiXML.phrase.money[0]), String(UIXML.uiXML.userInfo.moneyInfo[0]), target);
									break;
								case UIName.E_TOKEN:
									UICreate.createTokenTooltips(target);
									break;
							}
						} else if (targetParent.name == UIName.E_TOKEN) {
							UICommand.removeTokenTimer();
						}
					}
					break;
				case MouseEvent.ROLL_OUT :
					// if (e.target is Sprite && e.target.buttonMode) UIMain.mouseCursor = UIMain.NEW_COMMON;
					UICommand.removeTokenTimer();
					if (stateFirst != UIState.TAX ) UICommand.removeTaxTimer();
					if (targetParentParent == ui[UIName.UI_USER_INFO]) {
						/*用户信息提示框*/
						switch (targetParent.name) {
							case UIName.E_MONEY:
								UICreate.createTooltips(String(UIXML.uiXML.phrase.money[0]), String(UIXML.uiXML.userInfo.moneyInfo[0]), targetParent);
								break;
							case UIName.E_TOKEN:
								UICreate.createTokenTooltips(targetParent);
								break;
						}
					} else if (targetParent == ui[UIName.UI_USER_INFO]) {
						/*用户信息提示框*/
						switch (targetName) {
							case UIName.E_TOKEN:
								// UICommand.removeTokenTimer();
								break;
						}
					}
					break;
				case MouseEvent.MOUSE_DOWN :
					if (targetName == UIName.E_SCROLL_THUMB) {
						_mouseDownObj = e.target;
						_mouseDownObj.bg1.visible = false;
						stage.addEventListener(MouseEvent.MOUSE_UP, mouseEvent);
						stage.addEventListener(Event.MOUSE_LEAVE, mouseLeaveSwf);
					}
					break;
				case MouseEvent.MOUSE_UP :
					// UICommand.mouseEventSound(e);
					/*确定触发者不是未命名实例，即为编译器随机命名实例targetName.indexOf(UIName.E_INSTANCE) == -1*/
					// if (targetName.indexOf(UIName.E_INSTANCE) == -1) UICommand.uiDataTransfer([{m:UIDataFunList.SAVE_USER_ACTION, a:[userData[0], MouseEvent.MOUSE_UP + ":" + currentTargetName + "-|-" + targetName]}], EventNameList.UI_SAVE_DATA);
					if (_mouseDownObj) {
						_mouseDownObj.bg1.visible = true;
						_mouseDownObj = null;
						stage.removeEventListener(MouseEvent.MOUSE_UP, mouseEvent);
					}
					break;
				case MouseEvent.MOUSE_OVER :
					/*派兵界面和战斗界面卡片提示框*/
					if (e.target is Sprite && e.target.buttonMode) UIMain.mouseCursor = UIMain.NEW_BUTTON;
					if (e.target is Sprite ) {
						if (targetName == UIName.E_SCROLL_THUMB && !_mouseDownObj) {
							e.target.bg1.visible = false;
						} else if (currentTargetName.indexOf(UIName.E_POPUP) != -1) {
							try {
								num = 0;
								if (targetParentParent.name.indexOf(UIClass.POPUP_LOTTERY) != -1) num = -(target.width >> 1);
								if (e.target.dataLangName) {
									UICreate.createTooltips(e.target.dataLangName, e.target.dataInfo, target, num);
								} else if (e.target.dataInfo) {
									UICreate.createTooltips(String(UIXML.uiXML.phrase.prompt[0]), e.target.dataInfo, target, num);
								} else if (e.currentTarget.state == UIState.LOTTERY) {
									UICreate.createTooltips(String(UIXML.uiXML.phrase.prompt[0]), String(UIXML.uiXML.lottery.info1[0]) + String(e.target.parent.parent.dataObj.dataItemSum) + String(UIXML.uiXML.lottery.info2[0]), target, num);
								}
							} catch (error : Error) {
								trace(error.toString());
							}
						} else if (targetName.indexOf(UIName.XML_HERO + UIName.CHAR_UNDERLINE) != -1 || targetName.indexOf(UIName.XML_SOLDIER + UIName.CHAR_UNDERLINE) != -1 || targetName.indexOf(UIName.XML_TOWER + UIName.CHAR_UNDERLINE) != -1) {
							if (stateFirst != UIState.HANDBOOK) {
								if (targetName.indexOf(UIName.XML_TOWER + UIName.CHAR_UNDERLINE) != -1) {
									UICreate.createTooltips(e.target.dataLangName, "", target);
								} else {
									UICreate.createHSTooltips(target);
								}
							}
						} else if (currentTargetName == UIClass.SMALL_BAG) {
							if (e.target.dataLangName != null && e.target.dataInfo != null) UICreate.createTooltips(e.target.dataLangName, e.target.dataInfo, target);
						} else {
							switch (stateFirst) {
								/*开始界面*/
								case UIState.START :
									if (e.target.buttonMode) {
										if (currentTarget.parent == ui[UIName.UI_MAIN_NAV] || currentTarget == ui[UIName.UI_SECONDARY_NAV]) {
											xmlList = UIXML.uiXML.mainNav;
											if (targetParent.name == UIName.E_OPEN_TASK || targetParent.name == UIName.E_OPEN_ACTIVTITY || targetParent.name == UIName.E_OPEN_GIFT_BAG) {
												string = String(xmlList[targetParent.name].title[0]);
											} else {
												string = String(xmlList[targetName].title[0]);
											}
											if (targetParent.name == UIName.E_DISABLE) {
												if (targetName == UIName.E_OPEN_TOP) {
													numA = uint(UIXML.uiXML.mainNav.openTop.open[0]) - userData[1][14];
													num = numA * uint(UIXML.levelXML.relate.friendPrice[0]);
													string += (String(UIXML.uiXML.disable.friend.info[0]) + numA + String(UIXML.uiXML.disable.friend.info[1]) + String(UIXML.uiXML.disable.info[3]) + String(UIXML.uiXML.mark.comma[0]) + String(UIXML.uiXML.phrase.need[0]) + num + String(UIXML.uiXML.phrase.money[0]));
												} else {
													string += (String(UIXML.uiXML.mark.comma[0]) + String(UIXML.uiXML.phrase.level[0]) + String(xmlList[targetName].open[0]) + String(UIXML.uiXML.disable.info[1]));
												}
												UICreate.createTooltips(String(UIXML.uiXML.disable.info[0]), string, target);
											} else {
												if (targetName == UIName.E_TAX_START) {
													if (userData[4] == null) {
														UICreate.createTooltips(string, String(xmlList.taxStart.info[0]), target);
													} else if (userData[4][1] == null) {
														UICreate.createTooltips(string, String(UIXML.uiXML.tax.info[2]), target);
													} else {
														if (userData[4][2] == null) {
															numA = uint(uint(UIXML.levelXML.level.(@grade == userData[1][2]).taxIncome) * Number(UIXML.levelXML.tax.(@id == userData[4][0]).taxIncomeDouble[0]));
															num = uint(UIXML.levelXML.tax.(@id == userData[4][0]).money[0]);
															userData[4][2] = [numA, (int((userData[4][1][1] - serverTime) / 3600000) + 1) * num, num];
														}
														UICreate.createTooltips(string, String(UIXML.uiXML.phrase.countdown[0]) + UICommand.countdownRefresh((userData[4][1][1] - userData[4][1][0]) / 3600000, userData[4][1][1]) + String(UIXML.uiXML.mark.comma[0]) + String(UIXML.uiXML.tax.info[1]) + userData[4][2][1] + String(UIXML.uiXML.phrase.money[0]), target);
														UICommand.addTaxTimer();
													}
												} else {
													if (targetParent.name == UIName.E_OPEN_TASK || targetParent.name == UIName.E_OPEN_ACTIVTITY || targetParent.name == UIName.E_OPEN_GIFT_BAG) {
														UICreate.createTooltips(string, String(xmlList[targetParent.name].info[0]), target);
													} else {
														UICreate.createTooltips(string, String(xmlList[targetName].info[0]), target);
													}
												}
											}
										}
									}
									break;
								/*科技界面提示框*/
								case UIState.TECH :
									if (targetName.indexOf(UIName.E_REPLACE_DISABLE_HIT) != -1) {
										if (targetParentParent == (ui[UIName.UI_TECH] as Object).list) {
											UICreate.createTooltips(String(UIXML.uiXML.tech.title2[0]), e.target.dataInfo, target);
										} else {
											UICreate.createTooltips(String(UIXML.uiXML.phrase.prompt[0]), e.target.dataInfo, target);
										}
									} else if (targetName == UIName.E_SOLDIER) {
										UICreate.createTooltips(String(UIXML.uiXML.tech.title1[0]), "", target);
									} else if (targetName == UIName.E_TOWER) {
										UICreate.createTooltips(String(UIXML.uiXML.tech.title2[0]), "", target);
									} else if (targetParent.name == UIClass.TECH_MATERIAL && e.target.dataLangName) {
										UICreate.createTooltips(e.target.dataLangName, e.target.dataInfo, target);
									}
									break;
								/*商店界面提示框*/
								case UIState.SHOP :
									if (e.target.dataLangName) UICreate.createTooltips(e.target.dataLangName, e.target.dataInfo, target);
									break;
								/*背包界面*/
								case UIState.BAG :
									if (e.target.dataLangName) UICreate.createTooltips(e.target.dataLangName, e.target.dataInfo, target);
									break;
								/*英雄界面*/
								case UIState.HERO :
									if (targetName == UIName.E_LOCK) {
										num = uint(UIXML.levelXML.relate.gridPrice.hero.price[openLockNum]);
										numA = openLockNum + 1;
										UICreate.createTooltips(String(UIXML.uiXML.phrase.prompt[0]), String(UIXML.uiXML.lock.info[0]).replace(UIName.VAR_A, String(UICommand.getOpenLockLevel(numA))).replace(UIName.VAR_B, String(numA)) + String(UIXML.uiXML.lock.info[1]).replace(UIName.VAR_A, String(num)), target, (openLockNum - 1) * 50);
									} else if (targetName == UIName.E_REFRESH) {
										UICreate.createTooltips(String(UIXML.uiXML.phrase.prompt[0]), String(UIXML.uiXML.refreshHero.need[0]) + String(UIXML.heroXML.heroRelate.refreshMoney[0]) + String(UIXML.uiXML.phrase.cap[0]), target);
									}
									break;
								/*税收界面提示框*/
								case UIState.TAX :
									if (targetName.indexOf(UIName.E_REPLACE_DISABLE_HIT) != -1) {
										UICreate.createTooltips(String(UIXML.uiXML.phrase.prompt[0]), String(UIXML.uiXML.notEnough.cap[0]), target);
									} else if (targetName == UIName.JS_FEED) {
										UICreate.createTooltips(String(UIXML.uiXML.phrase.prompt[0]), String(UIXML.uiXML.tax.info[3]).replace(UIName.VAR_A, String(UIXML.levelXML.relate.taxShorteningTime[0])), target);
									}
									break;
								/*战报界面*/	
								case UIState.REPORT :
									switch (targetName) {
										case UIName.E_RECEIVE:
											UICreate.createTooltips(String(UIXML.uiXML.phrase.reward[0]), "", target);
											break;
										case UIName.E_PLAYBACK:
											UICreate.createTooltips(String(UIXML.uiXML.phrase.playback[0]), "", target);
											break;
										case UIName.E_ALL:
											UICreate.createTooltips(String(UIXML.uiXML.phrase.appraise[0]), "", target);
											break;
										case UIName.E_OPEN_DOSSIER:
											UICreate.createTooltips(String(UIXML.uiXML.mainNav.openDossier.title[0]), "", target);
											break;
									}
									break;
								/*排行界面*/	
								case UIState.TOP :
									switch (targetName) {
										case UIName.E_OPEN_DOSSIER:
											UICreate.createTooltips(String(UIXML.uiXML.mainNav.openDossier.title[0]), "", target);
											break;
										case UIName.E_MONEY:
											UICreate.createTooltips(String(UIXML.uiXML.phrase.challenge[0]), "", target);
											break;
									}
									break;
								/*匹配对手界面提示框*/
								case UIState.SELECT_RIVAL :
									if (targetParent.name.indexOf(UIName.E_GOODS) != -1 && e.target.dataLangName) UICreate.createTooltips(e.target.dataLangName, e.target.dataInfo, target);
									break;
								/*派兵界面*/
								case UIState.SELECT_ATTACT_ROLE:
									if (targetName == UIName.E_LOCK) {
										num = uint(UIXML.levelXML.relate.gridPrice.soldier.price[openLockNum]);
										numA = openLockNum + 1;
										UICreate.createTooltips(String(UIXML.uiXML.phrase.prompt[0]), String(UIXML.uiXML.lock.info[0]).replace(UIName.VAR_A, String(UICommand.getOpenLockLevel(numA, false))).replace(UIName.VAR_B, String(numA)) + String(UIXML.uiXML.lock.info[1]).replace(UIName.VAR_A, String(num)), target, (openLockNum - 1) * 50);
									} else if (targetName == UIClass.FEED_PAPER) {
										UICreate.createTooltips(String(UIXML.uiXML.phrase.prompt[0]), String(UIXML.uiXML.selectAttackRole.feedPaper[0]) + e.target.dataSum, target);
									}
									break;
								/*选择地图界面*/	
								case UIState.SELECT_MAP :
									if (targetParentParent.name == UIName.E_DEFENCE) {
										UICommand.selectMapTip(e.target.dataInfo);
									} else if (e.target.buttonMode) {
										if (targetName == UIName.E_OPEN_DOSSIER ) {
											/*好友名片*/
											UICreate.createTooltips(String(UIXML.uiXML.friend.dossier.title[0]), "", target);
										} else if (targetName != UIName.E_ADD + UIName.E_CLOSE) {
											if (targetParent.name == UIName.E_DEFENCE) {
												UICommand.selectMapTip(e.target.dataMapName);
											} else if (targetName == UIName.E_CLOSE) UICommand.selectMapTip(String(UIXML.uiXML.phrase.my[0]) + String(UIXML.uiXML.phrase.home[0]));
										}
									} else if (targetName == UIName.E_BG) {
										(ui[UIName.UI_SELECT_MAP] as Object).mapName.visible = false;
									}
									break;
								/*关卡界面*/	
								case UIState.HURDLE :
									if ((targetParent.name.indexOf(UIName.E_GOODS) != -1 || targetParentParentParent.name.indexOf(UIName.E_PAGE) != -1 || targetName == UIName.E_SCORE) && e.target.dataInfo) UICreate.createTooltips(e.target.dataLangName, e.target.dataInfo, target);
									break;
								/*摆塔界面*/
								case UIState.DEFENCE :
									if (e.target.buttonMode) {
										if (targetName == UIName.E_SUBMIT ) {
											/*保存*/
											string = String(UIXML.uiXML.defence.save.title[0]);
										} else if (targetName == UIName.E_TEST) {
											/*测试*/
											string = String(UIXML.uiXML.defence.test.title[0]);
										} else if (targetName == UIName.E_REFRESH) {
											/*刷新*/
											string = String(UIXML.uiXML.defence.refresh.title[0]);
										} else if (targetName == UIName.E_REMOVE) {
											/*移除*/
											string = String(UIXML.uiXML.defence.remove.title[0]);
										} else if (targetParent.name == UIName.PRESENT_DEFENCE_TOWER) {
											string = e.target.dataLangName;
										}
										if (targetName != UIName.E_CLOSE) UICreate.createTooltips(string, "", target);
									}
									break;
								/*战斗界面*/
								case UIState.WAR_PROGRESS :
									if (targetName == UIClass.CARD_HERO_SKILL) {
										xmlList = UIXML.heroSkillXML.heroSkills.(@id == target.dataSkillID);
										UICreate.createTooltips(String(UIXML.uiXML.phrase.hero[0]) + String(UIXML.uiXML.phrase.skill[0]), String(xmlList.skillsName[0]) + String(UIXML.uiXML.mark.comma[0]) + String(xmlList.describe[0]), target);
									} else if (targetName.indexOf(UIName.E_REPLACE_DISABLE_HIT) != -1) {
										// UICreate.createTooltips(String(UIXML.uiXML.phrase.prompt[0]), e.target.data, target);
									}
									break;
							}
						}
					}
					break;
				case MouseEvent.MOUSE_OUT :
					if (e.target is Sprite) {
						if (e.target.buttonMode) {
							UIMain.mouseCursor = UIMain.NEW_COMMON;
							UICommand.removeTokenTimer();
							if (stateFirst != UIState.TAX ) UICommand.removeTaxTimer();
							if (targetName == UIName.E_SCROLL_THUMB && !_mouseDownObj) e.target.bg1.visible = true;
						}
					}
					break;
			}
		}

		/*加载错误*/
		public function ioErrorHandler(e : IOErrorEvent) : void {
			trace("ioErrorHandler: " + e);
		}

		/*加载初始完成，即加载完第一帧所有内容*/
		public function initHandler(e : Event) : void {
			var par : Array;
			var index : uint = _loaders.length - 1;
			if (rivalData.length != 0) index = rivalData[0][0][1];
			with(e.target as LoaderInfo) {
				try {
					if (loader.content != null) {
						if (loader.content is Bitmap) {
							(loader.content as Bitmap).width = 50;
							(loader.content as Bitmap).height = 50;
						}
					}
					par = _loaders[index];
					par[par.length] = loader;
				} catch (error : Error) {
					trace(error.toString());
				}
			}
		}

		/*加载初始完成，即加载完第一帧所有内容*/
		public function payInitHandler(e : Event) : void {
			try {
				var obj : Object = stage.getChildByName(UIClass.PAY_RECHARGE);
				obj.removeChildAt(obj.numChildren - 1);
				var className : String;
				var ObjClass : Class;
				var sp : Sprite;
				for (var i : uint = 1; i < 5; i++) {
					className = UIClass.PAY_RECHARGE_PREFIX + i;
					ObjClass = UICommand.getClass(className, (e.target as LoaderInfo).applicationDomain);
					sp = new ObjClass();
					sp.x = obj["p" + i].x;
					sp.y = obj["p" + i].y;
					obj.addChild(sp);
				}
				(e.target as LoaderInfo).loader.unloadAndStop();
			} catch (error : Error) {
				trace(error.toString());
			}
		}

		/*输入数字框获得焦点*/
		public function inputNumfocusInHandler(e : FocusEvent) : void {
			e.target.parent.numBGA.visible = false;
			e.target.parent.numBGB.visible = true;
		}

		/*输入数字框失去焦点*/
		public function inputNumfocusOutHandler(e : FocusEvent) : void {
			e.target.parent.numBGA.visible = true;
			e.target.parent.numBGB.visible = false;
			var obj : Object = e.target.parent.parent;
			if (e.target.text == "" || e.target.text.search(/\D/) != -1) {
				UICommand.validation(e.target.parent.validation, String(UIXML.uiXML.input.info0[0]) + UIName.CHAR_BREAK + String(UIXML.uiXML.input.info7[0]) + UIName.CHAR_RETURN_WRAP);
				e.target.text = String(1);
				switch (obj.state) {
					case UIState.SHOP_CAP:
						e.target.parent.num1.text = String(obj.dataObj.dataCap);
						break;
					case UIState.SHOP_MONEY:
						e.target.parent.num1.text = String(obj.dataObj.dataMoney);
						break;
					case UIState.SALE_GOODS:
						e.target.parent.num1.text = String(selectedItems[3]);
						break;
				}
				// e.preventDefault();
			}
		}

		/*改变数字事件，背包界面卖东西或者商店界面真钱和游戏币*/
		public function changeNumHandler(e : Event) : void {
			if (e.target.text != "" && e.target.text.search(/\D/) != -1) {
				UICommand.validation(e.target.parent.validation, String(UIXML.uiXML.input.info0[0]) + UIName.CHAR_BREAK + String(UIXML.uiXML.input.info7[0]) + UIName.CHAR_RETURN_WRAP);
				e.target.text = String(1);
				return;
			}
			var string : String = String(UIXML.uiXML.input.info1[0]) + String(UIXML.uiXML.input.info2[0]) + String(UIXML.uiXML.input.info5[0]) + String(UIXML.uiXML.input.info6[0]) + UIName.CHAR_RETURN_WRAP;
			var obj : Object = e.target.parent.parent;
			switch (obj.state) {
				case UIState.SHOP_CAP:
					UICommand.changeNum(e.target, obj.dataObj.data, obj.dataObj.dataCap, capNum, string);
					break;
				case UIState.SHOP_MONEY:
					UICommand.changeNum(e.target, obj.dataObj.data, obj.dataObj.dataMoney, realMoney, string);
					break;
				case UIState.SALE_GOODS:
					var txt : Object = e.target;
					var inputNum : uint = uint(txt.text);
					var data : Array = bagData[selectedItems[1]][selectedItems[2]];
					var max : uint = data[data.length - 1];
					if (inputNum > max) {
						UICommand.validation(txt.parent.validation, string);
						txt.text = String(max);
						txt.parent.num1.text = String(max * selectedItems[3]);
					} else {
						txt.parent.num1.text = String(uint(txt.text) * selectedItems[3]);
					}
					break;
			}
		}

		/*SWF获得焦点后*/
		public function swfGetFocus(e : Event) : void {
			trace("swfGetFocus");
			/*判断socket连接是否断开*/
			if (!ClientSocket.getInstance().connected) {
				ClientSocket.getInstance().connect(ConstPath.DATA_SERVER_URL, ConstPath.DATA_SERVER_PORT);
				trace("Reconnecting...");
			}
		}

		/*SWF失去焦点后*/
		public function swfLosesFocus(e : Event) : void {
			trace("swfLosesFocus");
			if (stateFirst == UIState.WAR_PROGRESS && stateSecond != UIState.PLAYBACK && warTimer && warTimer.running) UICommand.pauseProgress();
		}

		/*鼠标移出SWF*/
		public function mouseLeaveSwf(e : Event) : void {
			trace("mouseLeaveSwf");
			if (_mouseDownObj) {
				_mouseDownObj.bg1.visible = true;
				_mouseDownObj = null;
				stage.removeEventListener(MouseEvent.MOUSE_UP, mouseEvent);
				stage.removeEventListener(Event.MOUSE_LEAVE, mouseLeaveSwf);
			}
		}

		/*客户端同步服务器时间事件*/
		public function syncServerTimeTimerHandler(e : TimerEvent) : void {
			serverTime += 1000;
			if (ClientSocket.getInstance().connected) {
				if ((stateFirst == UIState.START || stateFirst == UIState.TAX) && userData[4] != null && userData[4][1] != null && userData[4][1][1] < serverTime) {
					if (userData[4][2] != null) userData[4][2][1] = 0;
					UICommand.taxReceiveOrEnd(false);
				} else if ((stateFirst == UIState.START || stateFirst == UIState.SELECT_RIVAL || stateFirst == UIState.SELECT_MAP) && userData[2][2] != null && userData[2][4] < serverTime) {
					UICommand.removeTokenTimer();
					UICommand.uiDataTransfer([{m:UIDataFunList.GET_TOKEN, a:[userData[0]], noLoading:true}]);
				} else if (stateFirst == UIState.HERO) {
					UICommand.heroRefresh();
				}
				if (!lastRequest) lastRequest = [0, serverTime];
				var interval : Number = (serverTime - lastRequest[1]) / 60000;
				if (lastRequest[0] > 30) {
					lastRequest = null;
					ClientSocket.getInstance().close();
					if (stage.getChildAt(stage.numChildren - 1).name.indexOf(UIClass.POPUP_PROMPT + UIState.SOCKET) == -1) UICreate.popupPrompt(String(UIXML.uiXML.socketDisconnect[0]), UIState.SOCKET);
				} else if (interval > 3) {
					lastRequest[0]++;
					UICommand.uiDataTransfer([{m:UIDataFunList.GET_SERVER_TIME, a:[userData[0]], noLoading:true}]);
				}
			}
		}

		/*匹配对手界面时间事件*/
		public function rivalTimerHandler(e : TimerEvent) : void {
			var time : Object = (ui[UIName.UI_SELECT_RIVAL] as Object).time;
			time.text = uint(time.text) - 1;
			if (uint(time.text) == 0) {
				(ui[UIName.UI_SELECT_RIVAL] as Object).refresh.comp.enabled = true;
				time.visible = false;
				(e.target as Timer).stop();
				(e.target as Timer).removeEventListener(TimerEvent.TIMER, rivalTimerHandler);
				rivalData[0][1] = null;
			}
		}

		/*战斗界面时间事件*/
		public function warTimerHandler(e : TimerEvent) : void {
			UICommand.warProgressTime();
		}

		/*军令时间刷新事件*/
		public function tokenTimerHandler(e : TimerEvent) : void {
			var stageTop : Object = stage.getChildAt(this.stage.numChildren - 1);
			if (getQualifiedClassName(stageTop).indexOf(UIClass.TIP_PREFIX) != -1) {
				stageTop.content.txt.text = String(UIXML.uiXML.userInfo.tokenInfo.info[0]) + UIName.CHAR_BREAK + String(UIXML.uiXML.userInfo.tokenInfo.info[1]) + userData[2][6] + String(UIXML.uiXML.phrase.money[0]) + UIName.CHAR_BREAK + String(UIXML.uiXML.userInfo.tokenInfo.info[2]) + UIName.CHAR_BREAK + String(UIXML.uiXML.phrase.countdown[0]) + UICommand.countdownRefresh(userData[2][3], userData[2][4]);
			}
		}

		/*税收时间刷新事件*/
		public function taxTimerHandler(e : TimerEvent) : void {
			var countdown : String = UICommand.countdownRefresh((userData[4][1][1] - userData[4][1][0]) / 3600000, userData[4][1][1]);
			if (stateFirst == UIState.START) {
				var stageTop : Object = stage.getChildAt(this.stage.numChildren - 1);
				if (getQualifiedClassName(stageTop).indexOf(UIClass.TIP_PREFIX) != -1) {
					userData[4][2][1] = (int((userData[4][1][1] - serverTime) / 3600000) + 1) * userData[4][2][2];
					stageTop.content.txt.text = String(UIXML.uiXML.phrase.countdown[0]) + countdown + String(UIXML.uiXML.mark.comma[0]) + String(UIXML.uiXML.tax.info[1]) + userData[4][2][1] + String(UIXML.uiXML.phrase.money[0]) + UIName.CHAR_RETURN_WRAP;
				}
			} else if (stateFirst == UIState.TAX) {
				(ui[UIName.UI_TAX] as Object).content.getChildAt(userData[4][0] - 101).box.down2.countdown.text = countdown;
			}
		}

		/*过场动画时间完成事件*/
		public function transitionTimerComplete(e : TimerEvent) : void {
			ApplicationFacade.getInstance().sendNotification(NotificationNameList.ANIMATION_COMPLETE);
			(e.target as Timer).stop();
			(e.target as Timer).removeEventListener(TimerEvent.TIMER_COMPLETE, transitionTimerComplete);
		}

		/*离开战斗去选择地图延时时间完成事件*/
		public function progressToSelectMapTimerComplete(e : TimerEvent) : void {
			UITransition.progressToSelectMap();
			(e.target as Timer).stop();
			(e.target as Timer).removeEventListener(TimerEvent.TIMER_COMPLETE, progressToSelectMapTimerComplete);
		}

		public function get ui() : Vector.<Sprite> {
			return _ui;
		}

		public function set ui(ui : Vector.<Sprite>) : void {
			_ui = ui;
		}

		public function get allAttackRole() : Vector.<Sprite> {
			return _allAttackRole;
		}

		public function set allAttackRole(allAttackRole : Vector.<Sprite>) : void {
			_allAttackRole = allAttackRole;
		}

		// public function get allDefenceRole() : Vector.<Sprite> {
		// return _allDefenceRole;
		// }
		//
		// public function set allDefenceRole(allDefenceRole : Vector.<Sprite>) : void {
		// _allDefenceRole = allDefenceRole;
		// }
		public function get timelineLites() : Vector.<TimelineLite> {
			return _timelineLites;
		}

		public function set timelineLites(timelineLites : Vector.<TimelineLite>) : void {
			_timelineLites = timelineLites;
		}

		public function get loaders() : Array {
			return _loaders;
		}

		public function set loaders(loaders : Array) : void {
			_loaders = loaders;
		}

		public function get scrollBar() : ScrollBar {
			return _scrollBar;
		}

		public function set scrollBar(scrollBar : ScrollBar) : void {
			_scrollBar = scrollBar;
		}

		public function get serverTime() : Number {
			return _serverTime;
		}

		public function set serverTime(serverTime : Number) : void {
			_serverTime = serverTime;
		}

		public function get serverTimeTimer() : Timer {
			return _serverTimeTimer;
		}

		public function set serverTimeTimer(serverTimeTimer : Timer) : void {
			_serverTimeTimer = serverTimeTimer;
		}

		public function get warTimer() : Timer {
			return _warTimer;
		}

		public function set warTimer(warTimer : Timer) : void {
			_warTimer = warTimer;
		}

		public function get loadingTimer() : Timer {
			return _loadingTimer;
		}

		public function set loadingTimer(loadingTimer : Timer) : void {
			_loadingTimer = loadingTimer;
		}

		public function get stateFirst() : String {
			return _stateFirst;
		}

		public function set stateFirst(stateFirst : String) : void {
			_stateFirst = stateFirst;
		}

		public function get stateSecond() : String {
			return _stateSecond;
		}

		public function set stateSecond(stateSecond : String) : void {
			_stateSecond = stateSecond;
		}

		/*用户数据*/
		public function set userData(userData : Array) : void {
			_userData = userData;
		}

		/* 0"游戏sessionid",
		 * 1[用户ID[1][0],用户名[1][1],等级[1][2],经验值[1][3],瓶盖[1][4],真钱[1][5],用户头像[1][6],音乐开关[1][7],音效开关[1][8],网格开关[1][9],血条开关[1][10],服务器时间[1][11],登录次数[1][12][0每天,1连续],战报里是否有奖励[1][13],好友数[1][14],排行榜是否开启[1][15],礼包ID[1][16],税收开启次数[1][17]<br>
		 *2[军令[0],已购买军令数[1],军令刷新计时开始时间(军令满则为None)[2],]<br>
		 * 3[
		 *****[ 
		 *******[日常任务ID,计数(初始为0,达到完成次数则即进入待领取状态,已成功领取彻底完成任务则为None),[1006, ...(查背包数据加上奖励物品数后是否超上限,没有则为None,有则写下物品ID,)]],
		 *******... (超过6条时，剔除最早已领取完成的数据，也就是全部不能超过6条数据)
		 *****](没有任务为None)[0],<br>
		 *****[
		 ******[
		 *******主线任务ID,
		 *******[[完成条件ID,条件计数(初始为0)], ...](所有条件计数都达到完成次数则为None即进入待领取状态),
		 *******[1006, ...](不能领取)
		 ******, ...]
		 *****](没有任务为None)[1],<br>
		 *****(活动同上)[2],(引导)[3],(神秘任务)[4],
		 ****],<br>
		 * 4[[4][0]ID,[4][1]([4][1][0]税收开始时间[4][1][1]税收截止时间,处于等待领取状态则[4][1]为None),[4][2][0获得瓶盖数,1提前收需要钱数,2钱基数],[4][4]计时器;(没有税收为None)]<br>
		 * 5[{"id":1601,"surplus":30,"startTime":0},...]"(没有BUFF为None),<br>
		 * 6[0男[主页URL,名字,头像URL] ... ,1女 ...]
		 */
		public function get userData() : Array {
			return _userData;
		}

		/*获得用户真实货币数*/
		public function get realMoney() : int {
			_realMoney = userData[1][5];
			return _realMoney;
		}

		/*赋值用户真实货币数*/
		public function set realMoney(num : int) : void {
			if (num < 0) num = 0;
			userData[1][5] = num;
			(ui[UIName.UI_USER_INFO] as Object).money.money.text = String(num);
			_realMoney = num;
		}

		/*获得用户瓶盖数*/
		public function get capNum() : int {
			_capNum = userData[1][4];
			return _capNum;
		}

		/*赋值用户瓶盖数*/
		public function set capNum(num : int) : void {
			userData[1][4] = num;
			(ui[UIName.UI_USER_INFO] as Object).cap.money.text = String(num);
			_capNum = num;
		}

		/*expendableData[0]英雄，[dataServerID,dataGemID]没有为null;expendableData[1]兵[dataID,...]没有为null;*/
		public function get expendableData() : Array {
			return _expendableData;
		}

		public function set expendableData(expendableData : Array) : void {
			_expendableData = expendableData;
		}

		public function get shopData() : Array {
			return _shopData;
		}

		public function set shopData(shopData : Array) : void {
			_shopData = shopData;
		}

		/*类型，0是全部，1是道具,2是材料，3是宝石,4是装备.默认是0,数组下标则是类型数减1*/
		public function get bagData() : Array {
			return _bagData;
		}

		public function set bagData(bagData : Array) : void {
			_bagData = bagData;
		}

		/*[0-name, 1-dataType, 2-dataIndex, 3-dataSale, 4-numText, 5-dataLangName, 6-goodsid, 7-dataBuffSum]*/
		public function get selectedItems() : Array {
			return _selectedItems;
		}

		public function set selectedItems(selectedItems : Array) : void {
			_selectedItems = selectedItems;
		}

		/*dataID, dataLangName,dataLevel,dataUrl*/
		public function get selectedRivalData() : Array {
			return _selectedRivalData;
		}

		public function set selectedRivalData(selectedRivalData : Array) : void {
			_selectedRivalData = selectedRivalData;
		}

		/*0[[0选择地图的等级,选择-1,上次],1刷新倒计时timer],1[[0[对手数据],1[地图名,[地图物品],军令,瓶盖]](后面为每个地图) ...]*/
		public function get rivalData() : Array {
			return _rivalData;
		}

		public function set rivalData(rivalData : Array) : void {
			_rivalData = rivalData;
		}

		/*mapId submapId  dataAddPaper dataPVE dataMapName*/
		public function get mapData() : Object {
			return _mapData;
		}

		public function set mapData(mapData : Object) : void {
			_mapData = mapData;
		}

		public function get attackTime() : uint {
			return _attackTime;
		}

		public function set attackTime(attackTime : uint) : void {
			_attackTime = attackTime;
		}

		public function get increaseTime() : uint {
			return _increaseTime;
		}

		public function set increaseTime(increaseTime : uint) : void {
			attackTime += increaseTime;
			_increaseTime = increaseTime;
		}

		public function get openLockNum() : uint {
			return _openLockNum;
		}

		public function set openLockNum(openLockNum : uint) : void {
			_openLockNum = openLockNum;
		}

		/*[0]引导状态,-1情节,其他数高亮TIP;[1]高亮数据;[2]UI_GET_DATA数据;[3]UI_SAVE_DATA数据*/
		public function get gameGuideData() : Array {
			return _gameGuideData;
		}

		public function set gameGuideData(gameGuideData : Array) : void {
			_gameGuideData = gameGuideData;
		}

		/*type, id,唯一ID(服务器时间+id)*/
		public function get apiData() : Array {
			return _apiData;
		}

		public function set apiData(apiData : Array) : void {
			_apiData = apiData;
		}

		/*color.red =[classsname,色值,标记前,标记后]*/
		public function get color() : Object {
			return _color;
		}

		public function set color(color : Object) : void {
			_color = color;
		}

		/*心跳包计数,最后一次请求服务器时间*/
		public function get lastRequest() : Array {
			return _lastRequest;
		}

		public function set lastRequest(lastRequest : Array) : void {
			_lastRequest = lastRequest;
		}
	}
}