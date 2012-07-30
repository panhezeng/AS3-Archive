package com.raytoon.cannonfodder.tools.utils {
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.raytoon.cannonfodder.puremvc.ApplicationFacade;
	import com.raytoon.cannonfodder.puremvc.model.vo.CannonFodderVO;
	import com.raytoon.cannonfodder.puremvc.view.ui.UIMain;
	import com.raytoon.cannonfodder.puremvc.view.ui.backgroundLayer.BackgroundLayer;
	import com.raytoon.cannonfodder.puremvc.view.ui.buffLayer.BuffLayer;
	import com.raytoon.cannonfodder.puremvc.view.ui.optionMainLayer.OptionMainLayer;
	import com.raytoon.cannonfodder.puremvc.view.ui.taskLayer.ActivityLayer;
	import com.raytoon.cannonfodder.puremvc.view.ui.taskLayer.DailyGiftLayer;
	import com.raytoon.cannonfodder.puremvc.view.ui.taskLayer.TaskLayer;
	import com.raytoon.cannonfodder.puremvc.view.ui.techTreeLayer.TechTreeLayer;
	import com.raytoon.cannonfodder.puremvc.view.ui.toolsLayer.element.ElementReportContainer;
	import com.raytoon.cannonfodder.puremvc.view.ui.toolsLayer.element.ElementTopContainer;
	import com.raytoon.cannonfodder.puremvc.view.ui.toolsLayer.element.LevelLayer;
	import com.raytoon.cannonfodder.tools.load.DynamicLoadOriginal;
	import com.raytoon.cannonfodder.tools.load.ShowLoadOriginal;

	import flash.system.ApplicationDomain;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;

	/**
	 * @author Administrator
	 */
	public class UICreate {
		public static function initUI() : void {
			Font.registerFont(UICommand.getClass(UIClass.FONT_ART));
			Font.registerFont(UICommand.getClass(UIClass.FONT_SHOW_CARD));
			UICommand.t.stage.addEventListener(Event.ACTIVATE, UICommand.t.swfGetFocus);
			UICommand.t.stage.addEventListener(Event.DEACTIVATE, UICommand.t.swfLosesFocus);
			/*需要加载UI功能模块名称*/
			var uiNmaes : Vector.<String> = new Vector.<String>(22, true);
			uiNmaes = Vector.<String>([UIClass.USER_INFO, UIClass.USER_SET, UIClass.MAP_NAME, UIClass.MAIN_NAV, UIClass.SECONDARY_NAV, UIClass.FRIEND, UIClass.SELECT_RIVAL, UIClass.SELECT_ATTACK_ROLE, UIClass.DEADLINE, UIClass.STOP_PLAY, UIClass.SELECT_MAP, UIClass.DEFENCE_OPERATION, UIClass.HERO, UIClass.DOSSIER, UIClass.TECH, UIClass.BAG, UIClass.SHOP, UIClass.HANDBOOK, UIClass.TAX, UIClass.TOP, UIClass.REPORT, UIClass.TASK]);

			/*获得UI功能模块并放到t.ui vector容器中*/
			_getUI(UICommand.t.ui, uiNmaes);

			/*添加用户初始信息*/
			_getUser();

			/*添加右上角设置按钮，并添加事件*/
			UICommand.t.addChild(UICommand.t.ui[UIName.UI_USER_SET]);
			UICommand.t.ui[UIName.UI_USER_SET].addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_USER_SET].addEventListener(MouseEvent.ROLL_OVER, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_USER_SET].addEventListener(MouseEvent.ROLL_OUT, UICommand.t.mouseEvent);

			/*添加开始界面*/
			UITransition.inStart(true);
			/*添加颜色CSS*/
			var xmlList : XMLList = UIXML.uiXML.csscolor.color;
			var len : uint = xmlList.length();
			UICommand.t.color = {};
			for (var i : uint = 0; i < len; i++) UICommand.t.color[String(xmlList[i].@type)] = [String(xmlList[i].@classname), "#" + String(xmlList[i].@value), String(xmlList[i].tag[0]), String(xmlList[i].tag[1])];
			/*有活动弹公告*/
			if (UICommand.t.userData[3][3] && UICommand.t.userData[3][3] > 6005 && UICommand.t.userData[1][12][0] == 1 && UICommand.t.userData[3][2] != null) UITransition.startToAnnouncement();
			//if (UICommand.t.userData[1][12] != null && UICommand.t.userData[1][12][0] == 1) UITransition.startToAnnouncement();
			/*大于5级连续登录奖励*/
			if (!(UICommand.t.userData[1][12][2] as Boolean) && UICommand.t.userData[1][2] > uint(UIXML.apiXML.jsFeed.parameter.(@id == 106).@level)) UICommand.t.addChild(new DailyGiftLayer());
			if (ExternalInterface.available) {
				ExternalInterface.addCallback(UIName.JS_SEND_TO_AS, UICommand.uiDataTransferJS);
				ExternalInterface.call(UIName.JS_LOAD_COMPLETE, 1);
				if (UICommand.t.userData[6]) ExternalInterface.call(UIName.JS_GAMERS, UICommand.getGamers(UICommand.t.userData[6][0]), UICommand.getGamers(UICommand.t.userData[6][1]));
			}
		}

		/*获得服务器时间*/
		public static function getServerTime(dataObj : Object) : void {
			setServerTime((dataObj as Array)[0]);
		}

		/*设置当前服务器时间*/
		public static function setServerTime(num : Number) : void {
			num -= 10;
			UICommand.t.serverTime = num;
		}

		/*获得UI功能模块*/
		private static function _getUI(container : Vector.<Sprite>, names : Vector.<String>) : void {
			var max : uint = names.length;
			var className : String;
			var ObjClass : Class;
			for (var i : uint = 0; i < max; i++) {
				className = names[i];
				if (className == UIClass.TASK) {
					container[i] = UIMain.getInstance(TaskLayer.NAME) as TaskLayer;
				} else {
					ObjClass = UICommand.getClass(className);
					container[i] = new ObjClass() as Sprite;
					if (className == UIClass.SELECT_MAP) {
						(container[i] as Object).wave.gotoAndStop(1);
						var p : Sprite = (container[i] as Object).position;
						createAdd(UIClass.MC_CLOSE, UIName.E_ADD + UIName.E_CLOSE, container[i], p.x, p.y);
					}
				}
			}
		}

		/*生成部件并添加*/
		public static function createAdd(className : String, name : String, par : Sprite, x : Number, y : Number, e : Boolean = false) : void {
			var ObjClass : Class = UICommand.getClass(className);
			var child : Sprite = new ObjClass();
			child.name = name;
			child.x = x;
			child.y = y;
			par.addChild(child);
			if (e) {
				if (!child.buttonMode) UICommand.convertButtonMode(child);
				child.addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			}
		}

		/*获得用户信息，初始设置，等级，当前经验值，钱，军令*/
		private static function _getUser() : void {
			setServerTime(UICommand.t.userData[1][11]);
			UICommand.changeSetSwitch(false);
			UICommand.t.addChild(UICommand.t.ui[UIName.UI_USER_INFO]);
			TweenLite.from(UICommand.t.ui[UIName.UI_USER_INFO], 0.4, {alpha:0});
			(UICommand.t.ui[UIName.UI_USER_INFO] as Object).level.txt.text = UICommand.t.userData[1][2];
			UICommand.changeExperience();
			UICommand.t.capNum = UICommand.t.userData[1][4];
			UICommand.t.realMoney = UICommand.t.userData[1][5];
			(UICommand.t.ui[UIName.UI_USER_INFO] as Object).money.submit.addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			UICommand.changeToken();
			var end : uint = UICommand.t.ui[UIName.UI_USER_INFO].numChildren - 1;
			var child : DisplayObject;
			for (var i : uint = 0; i < end; i++) {
				child = UICommand.t.ui[UIName.UI_USER_INFO].getChildAt(i);
				child.addEventListener(MouseEvent.ROLL_OVER, UICommand.t.mouseEvent);
				child.addEventListener(MouseEvent.ROLL_OUT, UICommand.t.mouseEvent);
				if ((child as Object).submit) {
					(child as Object).submit.addEventListener(MouseEvent.ROLL_OVER, UICommand.t.mouseEvent);
					(child as Object).submit.addEventListener(MouseEvent.ROLL_OUT, UICommand.t.mouseEvent);
				}
			}
			if (UICommand.t.userData[5] != null) initBuff();
		}

		/*获得FEED是否发送*/
		public static function getFeedResult(dataObj : Object) : void {
			if ((dataObj as Array)[0]) {
				switch (UICommand.t.apiData[1]) {
					case 100 :
						(UICommand.t.ui[UIName.UI_TASK] as TaskLayer).receiveRewards();
						break;
					case 101 :
						(UICommand.t.ui[UIName.UI_TASK] as TaskLayer).showFeedTask();
						break;
					case 106 :
						UICommand.uiDataTransfer([{m:UIDataFunList.GET_BUFF_START, a:[UICommand.t.userData[0], uint(UIXML.apiXML.jsFeed.parameter.(@id == 106).@prop)]}]);
						break;
					case 107 :
						var obj : Object;
						var hourNum : TextField;
						var hour : uint;
						var short : uint;
						var time : Array;
						for (var i : uint = 0; i < 4; i++) {
							obj = (UICommand.t.ui[UIName.UI_TAX] as Object).content.getChildAt(i);
							hourNum = obj.box.down1.hourNum;
							hour = Math.ceil(Number(hourNum.text) / 0.1);
							short = Math.ceil(Number(UIXML.levelXML.relate.taxShorteningTime[0]) / 0.1);
							time = String((hour - short) * 0.1).split(".");
							hourNum.text = obj.dataTaxTime = time[0] + "." + String(time[1]).substr(0, 1);
						}
						UICommand.t.ui[UIName.UI_TAX].getChildByName(UIName.JS_FEED).visible = false;
						break;
				}
			}
		}

		/*获得buff开始数据*/
		public static function getBuffStart(dataObj : Object) : void {
			var surplus : uint = 0;
			var startTime : Number = 0;
			if (UICommand.t.stateFirst == UIState.BAG) {
				if (UICommand.t.selectedItems[7] == 0) {
					setServerTime((dataObj as Array)[0]);
					startTime = UICommand.t.serverTime;
				} else {
					surplus = (dataObj as Array)[0];
				}
				UICommand.getBuffContent(UICommand.t.selectedItems[6], surplus, startTime);
			} else {
				surplus = (dataObj as Array)[0];
				UICommand.getBuffContent(uint(UIXML.apiXML.jsFeed.parameter.(@id == 106).@prop), surplus, startTime);
			}
		}

		/*获得Buff*/
		public static function getBuff(dataObj : Object) : void {
			if (dataObj) {
				UICommand.t.userData[5] = dataObj as Array;
				var len : uint = UICommand.t.userData[5].length;
				var id : uint = uint(UIXML.apiXML.jsFeed.parameter.(@id == 106).@prop);
				var feedPaper : Object;
				for (var i : uint = 0; i < len; i++) {
					if (UICommand.t.userData[5][i].id == id) {
						feedPaper = UICommand.getInstance(UIClass.FEED_PAPER);
						UICommand.convertButtonMode(feedPaper as Sprite, false);
						feedPaper.name = UIClass.FEED_PAPER;
						feedPaper.dataSum = UICommand.t.userData[5][i].surplus;
						feedPaper.txt.text = "X" + UICommand.t.userData[5][i].surplus;
						(UICommand.t.ui[UIName.UI_SELECT_ATTACK_ROLE] as Object).expendables.addChild(feedPaper);
						feedPaper.addEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
						feedPaper.addEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
						UICommand.setPaperNum(uint(UIXML.mapXML.maps.(@id == UICommand.t.mapData.mapId).paper[0]) * uint(UIXML.apiXML.jsFeed.parameter.(@id == 106).@change), 1, false, true);
					}
				}
			}
		}

		/*初始化buff*/
		public static function initBuff() : void {
			var bf : BuffLayer = UIMain.getInstance(BuffLayer.NAME) as BuffLayer;
			bf.showBuff();
			var p : DisplayObject = UICommand.t.ui[UIName.UI_USER_INFO].getChildAt(UICommand.t.ui[UIName.UI_USER_INFO].numChildren - 1);
			bf.x = p.x;
			bf.y = p.y;
			UICommand.t.ui[UIName.UI_USER_INFO].addChild(bf);
		}

		/*获得支付URL*/
		public static function getPay(dataObj : Object) : void {
			UICommand.t.apiData = [UIName.JS_PAY];
			if (ExternalInterface.available) ExternalInterface.call(UIName.JS_PAY, (dataObj as Array)[0]);
		}

		/*获得用户真实货币数*/
		public static function getMoney(dataObj : Object) : void {
			var add : uint;
			if ((dataObj as Array)[0] > UICommand.t.userData[1][5]) add = uint((dataObj as Array)[0]) - UICommand.t.userData[1][5];
			UICommand.t.userData[1][5] = (dataObj as Array)[0];
			UICommand.t.realMoney = UICommand.t.userData[1][5];
			if (UICommand.t.stateFirst == UIState.PAY_RECHARGE && add) {
				(UICommand.t.stage.getChildByName(UIClass.PAY_RECHARGE) as Object).t2.text = String(UICommand.t.userData[1][5]);
				UITransition.promptTextTween(50, "+" + add, UIName.FONT_SHOW_CARD);
			}
		}

		/*获得军令牌*/
		public static function getToken(dataObj : Object) : void {
			UICommand.t.userData[2][0] = (dataObj as Array)[0];
			UICommand.t.userData[2][1] = (dataObj as Array)[1];
			UICommand.t.userData[2][2] = (dataObj as Array)[2];
			UICommand.changeToken();
		}

		/*获得图鉴*/
		public static function getHandbook(dataObj : Object) : void {
			(UICommand.t.ui[UIName.UI_HANDBOOK] as Object).data = dataObj;
			(UICommand.t.ui[UIName.UI_HANDBOOK] as Object).state = UIName.XML_SOLDIER;
			initHandbook(dataObj[0], UIName.XML_SOLDIER);
			if (dataObj[1] != null) (UICommand.t.ui[UIName.UI_HANDBOOK] as Object).tower.comp.enabled = true;
		}

		/*初始图鉴*/
		public static function initHandbook(data : Array, type : String) : void {
			getPages(UICommand.t.ui[UIName.UI_HANDBOOK], data, type, 12, 3, 10, 6, 70, 85, 1.5, -4);
			var box : Sprite = UICommand.t.ui[UIName.UI_HANDBOOK].getChildAt(UICommand.t.ui[UIName.UI_HANDBOOK].numChildren - 2) as Sprite;
			UICommand.changeCardSelected((box.getChildAt(box.numChildren - 1) as Sprite).getChildAt(0), (UICommand.t.ui[UIName.UI_HANDBOOK] as Object).selected);
			getHandbookContent(UICommand.t.ui[UIName.UI_HANDBOOK] as Object, data[0], type);
		}

		/*获得图鉴内容*/
		public static function getHandbookContent(par : Object, data : Array, type : String) : void {
			var className : String;
			var langName : String;
			var langLevel : String;
			var langInfo : String;
			var langSkill : String = String(UIXML.uiXML.phrase.nothing[0]);
			var skillID : uint;
			var gridHP : Number;
			var currentHP : Number;
			var gridAttack : Number;
			var currentAttack : Number;
			var gridDefence : Number;
			var currentDefence : Number;
			var gridArmor : Number;
			var currentArmor : Number;
			var gridHZ : Number;
			var currentHZ : Number;
			var gridRange : Number;
			var currentRange : Number;
			var gridPriority : Number;
			var currentPriority : Number;
			var gridSpeed : Number;
			var currentSpeed : Number;
			var xmlListInfo : XMLList;
			var xmlListSkill : XMLList;
			var xmlListRelate : XMLList;
			var xmlListLevel : XMLList;
			switch (type) {
				case UIName.XML_SOLDIER:
					xmlListInfo = UIXML.soldierXML.soldier.(@id == data[0]);
					xmlListSkill = UIXML.soldierSkillXML.skills;
					xmlListRelate = UIXML.soldierXML.soldierRelate;
					xmlListLevel = UIXML.soldierLevelXML.soldierLevel.(@id == data[0]).level.(@grade == data[1]);
					langLevel = data[1];
					/*移动速度*/
					par.langSpeed.visible = true;
					par.barSpeed.visible = true;
					par.barBG.visible = true;
					gridSpeed = Number(xmlListRelate.speedGrid[0]);
					currentSpeed = uint(xmlListInfo.speed[0]);
					par.langSpeed.text = String(UIXML.uiXML.phrase.move[0]) + String(UIXML.uiXML.phrase.speed[0]);
					UICommand.handbookGrid(par.barSpeed, Math.ceil(currentSpeed / gridSpeed));
					break;
				case UIName.XML_TOWER:
					xmlListInfo = UIXML.towerXML.towerType.(@type == data[0]).tower.(@id == data[1]);
					xmlListSkill = UIXML.towerSkillXML.towerSkills;
					xmlListRelate = UIXML.towerXML.towerRelate;
					xmlListLevel = UIXML.towerLevelXML.towerType.(@type == data[0]).towerLevel.(@id == data[1]).level.(@grade == data[2]);
					langLevel = data[2];
					/*移动速度*/
					par.langSpeed.visible = false;
					par.barSpeed.visible = false;
					par.barBG.visible = false;
					break;
			}
			className = xmlListInfo.name[0];
			langName = xmlListInfo.langName[0];
			langInfo = xmlListInfo.info[0];
			skillID = uint(xmlListInfo.skills[0]);
			if (skillID) langSkill = xmlListSkill.(@id == skillID).info[0];
			gridHP = Number(xmlListRelate.lifeHPGrid[0]);
			currentHP = Number(xmlListLevel.lifeHP[0]);
			gridAttack = Number(xmlListRelate.attackGrid[0]);
			currentAttack = Number(xmlListLevel.attack[0]);
			gridDefence = Number(xmlListRelate.defenceGrid[0]);
			currentDefence = Number(xmlListLevel.defence[0]);
			gridArmor = Number(xmlListRelate.armorGrid[0]);
			currentArmor = Number(xmlListLevel.armor[0]);
			gridHZ = Number(xmlListRelate.attackHZGrid[0]);
			currentHZ = Number(xmlListInfo.attackHZ[0]);
			gridRange = Number(xmlListRelate.attackRangeGrid[0]);
			currentRange = Number(xmlListInfo.maxAttackRange[0]);
			gridPriority = Number(xmlListRelate.priorityGrid[0]);
			currentPriority = Number(xmlListInfo.priority[0]);

			if (par.card.numChildren == 1) par.card.removeChildAt(0);
			par.card.addChild(new ShowLoadOriginal(className));
			par.langName.text = langName;
			par.langLevelTitle.text = String(UIXML.uiXML.phrase.level[0]);
			par.langLevel.text = langLevel;
			par.langInfo.text = langInfo;
			par.langSkillTitle.text = String(UIXML.uiXML.phrase.skill[0]);
			par.langSkill.text = langSkill;
			/*生命*/
			par.langHP.text = String(UIXML.uiXML.phrase.hp[0]);
			UICommand.handbookGrid(par.barHP, Math.ceil(currentHP / gridHP));
			/*攻击*/
			par.langAttack.text = String(UIXML.uiXML.phrase.attack[0]);
			UICommand.handbookGrid(par.barAttack, Math.ceil(currentAttack / gridAttack));
			/*防御*/
			par.langDefence.text = String(UIXML.uiXML.phrase.defence[0]);
			UICommand.handbookGrid(par.barDefence, Math.ceil(currentDefence / gridDefence));
			/*护甲*/
			par.langArmor.text = String(UIXML.uiXML.phrase.armor[0]);
			UICommand.handbookGrid(par.barArmor, Math.ceil(currentArmor / gridArmor));
			/*攻击频率*/
			par.langHZ.text = String(UIXML.uiXML.phrase.attack[0]) + String(UIXML.uiXML.phrase.HZ[0]);
			UICommand.handbookGrid(par.barHZ, Math.ceil(currentHZ / gridHZ));
			/*攻击范围*/
			par.langRange.text = String(UIXML.uiXML.phrase.attack[0]) + String(UIXML.uiXML.phrase.range[0]);
			UICommand.handbookGrid(par.barRange, Math.ceil(currentRange / gridRange));
			/*欠揍指数*/
			par.langPriority.text = String(UIXML.uiXML.phrase.priority[0]);
			UICommand.handbookGrid(par.barPriority, Math.ceil(currentPriority / gridPriority));
		}

		/*获得好友*/
		public static function getFriend(dataObj : Object = null) : void {
			if (dataObj) (UICommand.t.ui[UIName.UI_FRIEND] as Object).data = dataObj as Array;
			var data : Array = (UICommand.t.ui[UIName.UI_FRIEND] as Object).data;
			var len : uint = data.length;
			var max : uint = len + (8 - (len % 8));
			var indexX : uint;
			var indexY : uint;
			(UICommand.t.ui[UIName.UI_FRIEND] as Object).dataCurrent = 1;
			var box : Sprite = new Sprite();
			var contentMask : Sprite = (UICommand.t.ui[UIName.UI_FRIEND] as Object).contentMask;
			box.x = contentMask.x;
			box.y = contentMask.y;
			box.mask = contentMask;
			(UICommand.t.ui[UIName.UI_FRIEND] as Object).addChild(box);
			var ObjClass : Class;
			var container : Object;
			var f : Boolean;
			UICommand.t.loaders[UICommand.t.loaders.length] = [];
			for (var i : uint = 0; i < max; i++) {
				if (i < len) {
					f = true;
				} else {
					f = false;
				}
				ObjClass = UICommand.getClass(UIClass.FRIEND_CONTAINER);
				container = new ObjClass();
				box.addChild(container as Sprite);
				indexX = i % 8;
				indexY = uint(i / 8);
				container.x = (uint((container as Sprite).width) * indexX) + (1 * indexX);
				container.y = (uint((container as Sprite).height) * indexY);

				if (f) {
					container.dataID = data[i][0];
					container.dataLevel = data[i][1];
					container.langLevel.text = data[i][1];
					if (data[i][2]) {
						loadImg(data[i][2], container.icon);
						container.dataUrl = data[i][2];
					}
					container.langName.text = container.dataLangName = data[i][3];
					// UICommand.convertButtonMode(container as Sprite);
					container.user.visible = false;
				} else {
					if (i == len) (UICommand.t.ui[UIName.UI_FRIEND] as Object).dataMax = indexY + 1;
					(container as Sprite).name = UIName.E_ADD + i;
					container.langLevel.visible = false;
					container.langLevelBG.visible = false;
					container.langName.text = String(UIXML.uiXML.phrase.invite[0]);
				}
			}
			if (box.height > contentMask.height) (UICommand.t.ui[UIName.UI_FRIEND] as Object).down.comp.enabled = true;
		}

		/*加载图片*/
		public static function loadImg(url : String, par : Sprite) : void {
			var lc : LoaderContext = new LoaderContext(true, ApplicationDomain.currentDomain);
			var loader : Loader = new Loader();
			var request : URLRequest = new URLRequest(url);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, UICommand.t.ioErrorHandler);
			loader.contentLoaderInfo.addEventListener(Event.INIT, UICommand.t.initHandler);
			loader.load(request, lc);
			loader.x = loader.y = 1;
			par.addChild(loader);
			var sp : Sprite = new Sprite();
			sp.graphics.beginFill(0x000000);
			sp.graphics.drawRoundRect(0, 0, 50, 50, 5);
			sp.graphics.endFill();
			par.addChild(sp);
			sp.x = sp.y = 1;
			loader.mask = sp;
		}

		/*获得名片*/
		public static function getDossier(dataObj : Object) : void {
			var data : Array = dataObj as Array;
			UICommand.t.loaders[UICommand.t.loaders.length] = [];
			UICreate.loadImg(data[9], (UICommand.t.ui[UIName.UI_DOSSIER] as Object).icon);
			(UICommand.t.ui[UIName.UI_DOSSIER] as Object).langAllScoreTitle.text = String(UIXML.uiXML.phrase.points[0]);
			(UICommand.t.ui[UIName.UI_DOSSIER] as Object).langAllScore.text = data[7] + data[8];
			(UICommand.t.ui[UIName.UI_DOSSIER] as Object).langAScore.text = data[7];
			(UICommand.t.ui[UIName.UI_DOSSIER] as Object).langDScore.text = data[8];
			(UICommand.t.ui[UIName.UI_DOSSIER] as Object).langAWin.text = data[0];
			(UICommand.t.ui[UIName.UI_DOSSIER] as Object).langAProbability.text = data[1];
			(UICommand.t.ui[UIName.UI_DOSSIER] as Object).langDWin.text = data[2];
			(UICommand.t.ui[UIName.UI_DOSSIER] as Object).langDProbability.text = data[3];
			var vectors : Vector.<Sprite>;
			var len : uint = 0;
			var hero : Sprite = new Sprite();
			hero.addEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			hero.addEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_DOSSIER].addChild(hero);
			var alpha : Number = 1;
			if (data[4] != null) {
				len = data[4].length;
				vectors = new Vector.<Sprite>(len, true);
				_getAllRole(data[4], UIName.XML_HERO, vectors, 0, true);
				var box : Sprite = (UICommand.t.ui[UIName.UI_DOSSIER] as Object).box;
				hero.x = box.x;
				hero.y = box.y;
				_arrangeAllRole(vectors, hero, 5, 3, 0, false);
				len = 0;
			}
			if (data[5] != null) {
				len = data[5].length;
				vectors = new Vector.<Sprite>();
				_getAllRole(data[5], UIName.XML_SOLDIER, vectors, 0, true);
				alpha = 0.2;
			}
			if (data[6] != null) {
				if (len == 0) vectors = new Vector.<Sprite>();
				_getAllRole(data[6], UIName.XML_TOWER, vectors, len, true);
			}
			if (vectors == null) vectors = new Vector.<Sprite>();
			getPages(UICommand.t.ui[UIName.UI_DOSSIER], vectors, UIState.DOSSIER, 10, 5, 2, 4, 70, 85, 2.0, -4, 18, alpha);
			var cards : Sprite = (UICommand.t.ui[UIName.UI_DOSSIER].getChildAt(UICommand.t.ui[UIName.UI_DOSSIER].numChildren - 2) as Sprite).getChildAt(1) as Sprite;
			cards.addEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			cards.addEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
		}

		/*获得商店*/
		public static function getShop(dataObj : Object) : void {
			UICommand.t.shopData = dataObj as Array;
			var obj : Object = UICommand.t.getChildByName(UIClass.SMALL_BAG);
			if (obj) {
				var nav : Object = (UICommand.t.ui[UIName.UI_SHOP] as Object).nav;
				switch (obj.data[1]) {
					case 3:
						/*神灯*/
						UICommand.navSelected(nav.Gem);
						addGoods(UICommand.t.shopData[2]);
						break;
					case 4:
						/*装备*/
						UICommand.navSelected(nav.Equip);
						addGoods(UICommand.t.shopData[3]);
						break;
				}
			} else {
				var newAry : Array = getSpecialGoods(UICommand.t.shopData);
				addGoods(newAry);
			}
		}

		/*获得所有特别商品*/
		public static function getSpecialGoods(data : Array, index : uint = 1) : Array {
			var newAry : Array = [];
			var max : uint = data.length;
			for (var i : uint = 0; i < max; i++) {
				if (UICommand.t.shopData[i] != null) {
					var jMax : uint = data[i].length;
					for (var j : uint = 0; j < jMax; j++) {
						if (i == 3) index++;
						if (UICommand.t.shopData[i][j][index]) newAry.push(UICommand.t.shopData[i][j]);
					}
				}
			}
			return newAry;
		}

		/*添加商品obj.data(当前物品数组)obj.dataType(当前物品类型)*/
		public static function addGoods(data : Array) : void {
			var box : Sprite = new Sprite();
			var max : uint = data.length;
			var ObjClass : Class;
			var obj : Object;
			var sp : Sprite;
			var icon : Object;
			var i : uint;
			var indexX : uint;
			var indexY : uint;
			var boolean : Boolean;
			var className : String;
			var money : uint;
			var cap : uint;
			var xmlList : XMLList;
			var num : uint;
			for (i = 0; i < max; i++) {
				ObjClass = UICommand.getClass(UIClass.SHOP_CONTAINER);
				obj = new ObjClass();
				sp = obj as Sprite;
				box.addChild(sp);
				indexX = i % 2;
				indexY = uint(i / 2);
				sp.x = (uint(sp.width) * indexX) + (8 * indexX);
				sp.y = (uint(sp.height) * indexY) + (6 * indexY);
				obj.data = data[i];
				num = uint(String(data[i][0]).substr(0, 2));
				switch (num) {
					case 16 :
						xmlList = UIXML.propXML.prop.(@id == data[i][0]);
						obj.dataType = 1;
						break;
					case 17 :
						xmlList = UIXML.materialXML.material.(@id == data[i][0]);
						obj.dataType = 2;
						break;
					default	:
						if (num < 16) {
							xmlList = UIXML.equipmentXML.equipCategory.equip.(@id == data[i][0]);
							obj.dataType = 4;
						} else {
							xmlList = UIXML.gemXML.gem.(@id == data[i][0]);
							obj.dataType = 3;
						}
						break;
				}
				obj.dataClassName = className = String(xmlList.name[0]);
				money = uint(xmlList.money[0]);
				cap = uint(xmlList.cap[0]);

				boolean = data[i][1];
				obj.hot.visible = false;
				if (boolean) obj.hot.visible = true;
				ObjClass = UICommand.getClass(className);
				icon = new ObjClass();
				icon.x = icon.y = 1;
				icon.dataInfo = String(xmlList.info[0]);
				obj.langName.text = obj.dataLangName = icon.dataLangName = String(xmlList.langName[0]);
				UICommand.convertButtonMode(icon as Sprite, false);
				obj.grid.addChild(icon as DisplayObject);
				// obj.grid.addEventListener(MouseEvent.ROLL_OVER, UICommand.t.mouseEvent);
				// obj.grid.addEventListener(MouseEvent.ROLL_OUT, UICommand.t.mouseEvent);
				obj.cap.visible = false;
				if (cap) {
					obj.cap.visible = true;
					obj.cap.money.text = cap;
					obj.dataCap = cap;
				}
				obj.money.visible = false;
				if (money) {
					obj.money.visible = true;
					obj.money.money.text = money;
					obj.dataMoney = money;
				}
				if (cap && !money) {
					obj.cap.x += (obj.cap.width >> 1);
				} else if (money && !cap) {
					obj.money.x -= (obj.money.width >> 1);
				}
			}
			var position : Sprite = (UICommand.t.ui[UIName.UI_SHOP] as Object).position;
			var point : Point = new Point(position.x, position.y);
			initScroll(UIClass.SHOP_SCROLL, box, point, UICommand.t.ui[UIName.UI_SHOP], 6);
		}

		/*获得背包*/
		public static function getBag(dataObj : Object) : void {
			UICommand.t.bagData = dataObj as Array;
			if (UICommand.t.stateFirst != UIState.TECH) {
				var small : Array;
				var obj : Object = UICommand.t.getChildByName(UIClass.SMALL_BAG);
				if (obj != null) {
					switch (obj.data[1]) {
						case 3:
							small = UICommand.t.bagData[2];
							break;
						case 4:
							if (obj.data[2] != null) {
								var b : Boolean = true;
								if (UICommand.t.bagData[3] != null) {
									var len : uint = UICommand.t.bagData[3].length;
									for (var i : uint = 0; i < len; i++) {
										if (UICommand.t.bagData[3][i][0] == obj.data[2]) {
											b = false;
											break;
										}
									}
								}
								if (b) {
									if (UICommand.t.bagData[3] == null) UICommand.t.bagData[3] = [];
									UICommand.t.bagData[3].push([obj.data[2], 0]);
								}
							}
							small = UICommand.t.bagData[3];
							break;
					}
					addSmallBagCard(obj, small);
				} else {
					addBagCard(UICommand.t.ui[UIName.UI_BAG], UICommand.t.bagData, 45, 9, 11, 10, true, true);
					(UICommand.t.ui[UIName.UI_BAG] as Object).dataType = UIName.E_ALL;
				}
			}
		}

		/*填小背包*/
		public static function addSmallBagCard(par : Object, data : Array) : void {
			var box : Sprite = new Sprite();
			var len : uint = 20;
			if (data != null) {
				len = data.length;
				_getScrollBGGrid(len, 20, UIClass.BAG_GRID, box, 5, 2, 1);
				_getBagGrid(box, data, 0, par);
			} else {
				_getScrollBGGrid(len, 20, UIClass.BAG_GRID, box, 5, 2, 1);
			}
			var position : Sprite = par.position;
			var point : Point = new Point(position.x, position.y);
			initScroll(UIClass.SMALL_BAG_SCROLL, box, point, par, 8);
		}

		/*填背包*/
		public static function addBagCard(o : Object, data : Array, groupNum : uint, br : uint, colGap : uint, rowGap : uint, pages : Boolean = true, all : Boolean = false) : void {
			var show : Boolean = true;
			var max : uint;
			var allNum : uint;
			var num : uint;
			var sp : Sprite = new Sprite();
			sp.name = UIName.PRESENT_BAG;
			sp.x = o.contentMask.x;
			sp.y = o.contentMask.y;
			sp.mask = o.contentMask;
			o.addChild(sp);
			// sp.addEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			// sp.addEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
			TweenLite.from(sp, 0.4, {alpha:0.4});
			if (all) {
				max = data.length;
				for (var j : uint = 0; j < max; j++) {
					if (data[j] != null) {
						allNum += data[j].length;
					}
				}
				if (allNum == 0) {
					_getBGGrid(groupNum, groupNum, o.contentMask.width, sp, br, colGap, rowGap);
				} else {
					_getBGGrid(allNum, groupNum, o.contentMask.width, sp, br, colGap, rowGap);
					for (var i : uint = 0; i < max; i++) {
						if (data[i] != null) {
							if (i && data[i - 1] != null) num += data[i - 1].length;
							_getBagGrid(sp, data[i], num);
						}
					}
				}
			} else {
				if (data != null) {
					_getBGGrid(data.length, groupNum, o.contentMask.width, sp, br, colGap, rowGap);
					_getBagGrid(sp, data);
				} else {
					_getBGGrid(groupNum, groupNum, o.contentMask.width, sp, br, colGap, rowGap);
					show = false;
				}
			}
			if (pages) pagesNav(o.dataPages, o, o.prev.y, o.prev, o.next, 18, show);
		}

		/*获得背景格子,横向滚动效果*/
		private static function _getBGGrid(num : uint, groupNum : uint, w : Number, box : Sprite, br : uint, colGap : uint, rowGap : uint) : void {
			var indexX : uint = 0;
			var indexY : uint = 0;
			var groupsNum : uint = Math.ceil(num / groupNum);
			(box.parent as Object).dataPages = groupsNum;
			var newX : Number;
			var ObjClass : Class;
			var grid : Object;
			for (var j : uint = 0; j < groupsNum; j++) {
				newX = w * j;
				for (var i : uint = 0; i < groupNum; i++) {
					ObjClass = UICommand.getClass(UIClass.BAG_GRID);
					grid = new ObjClass();
					box.addChild(grid as Sprite);
					indexX = i % br;
					indexY = uint(i / br);
					grid.x = newX + (uint((grid as Sprite).width) * indexX) + (colGap * indexX);
					grid.y = (uint((grid as Sprite).height) * indexY) + (rowGap * indexY);
				}
			}
		}

		/*获得背包物品*/
		private static function _getBagGrid(box : Sprite, data : Array, origin : uint = 0, container : Object = null) : void {
			var num : uint = data.length;
			var xmlList : XMLList;
			var className : String;
			var type : uint;
			var ObjClass : Class;
			var grid : Object;
			var content : String;
			var numTxt : TextField;
			for (var i : uint = 0; i < num; i++) {
				switch (data) {
					case UICommand.t.bagData[0]:
						xmlList = UIXML.propXML.prop.(@id == data[i][0]);
						type = 0;
						break;
					case UICommand.t.bagData[1] :
						xmlList = UIXML.materialXML.material.(@id == data[i][0]);
						type = 1;
						break;
					case UICommand.t.bagData[2] :
						xmlList = UIXML.gemXML.gem.(@id == data[i][0]);
						type = 2;
						break;
					case UICommand.t.bagData[3] :
						xmlList = UIXML.equipmentXML.equipCategory.equip.(@id == data[i][0]);
						type = 3;
						break;
				}
				className = String(xmlList.name[0]);
				ObjClass = UICommand.getClass(className);
				grid = new ObjClass();
				grid.name = className;
				grid.dataSale = uint(xmlList.sell[0]);
				grid.dataLangName = String(xmlList.langName[0]);
				grid.dataInfo = String(xmlList.info[0]);
				grid.dataBuffSum = uint(xmlList.buffEnableSum[0]);
				grid.dataType = type;
				grid.dataIndex = i;
				grid.x = grid.y = 1;
				UICommand.convertButtonMode((grid as Sprite));
				(box.getChildAt(i + origin) as Sprite).addChild(grid as Sprite);
				content = "X" + String(data[i][1]);
				numTxt = UICommand.createTF(TextFormatAlign.RIGHT, 0xffffff, 12, content, UIName.FONT_SHOW_CARD);
				numTxt.x = grid.width - numTxt.width;
				numTxt.y = grid.height - 18;
				grid.addChild(numTxt);
				if (data[i][1] == 0) numTxt.visible = false;
				if (container) {
					var level : uint = container.data[0].dataObj.data[5];
					var useLevel : uint = uint(xmlList.level[0]);
					if (type == 2 && container.data[0].dataAddLevel) level += container.data[0].dataAddLevel;
					if (level < useLevel) {
						grid.dataUseLevel = useLevel;
						grid.filters = [new ColorMatrixFilter([0.31, 0.61, 0.08, 0, 0, 0.31, 0.61, 0.08, 0, 0, 0.31, 0.61, 0.08, 0, 0, 0, 0, 0, 1, 0])];
					}
					if (data[i][0] == container.data[2]) UICommand.bagSelected(grid as Sprite, false);
				}
			}
		}

		/*获得税收四个区块*/
		public static function getTaxContainer() : void {
			var obj : Object;
			var taxIncome : uint = uint(UIXML.levelXML.level.(@grade == UICommand.t.userData[1][2]).taxIncome);
			var changeCapNum : uint;
			var getCapNum : uint;
			var up : Object;
			var down1 : Object;
			var down2 : Object;
			var money : uint;
			for (var i : uint = 0; i < 4; i++) {
				obj = (UICommand.t.ui[UIName.UI_TAX] as Object).content.getChildAt(i);
				obj.dataID = uint(UIXML.levelXML.tax[i].@id);
				up = obj.box.up;
				down1 = obj.box.down1;
				down2 = obj.box.down2;
				up.langTitle.text = String(UIXML.uiXML.tax.info[0]);
				up.num.text = getCapNum = uint(taxIncome * Number(UIXML.levelXML.tax[i].taxIncomeDouble[0]));
				down1.langTitle.text = String(UIXML.uiXML.phrase.consume[0]) + String(UIXML.uiXML.mark.colon[0]);
				down1.change.text = changeCapNum = uint(taxIncome * Number(UIXML.levelXML.tax[i].taxOutPercent[0]));
				down1.langHour.text = String(UIXML.uiXML.phrase.hour[0]);
				down1.visible = true;
				down2.visible = false;
				obj.filters = [];
				obj.mouseChildren = true;
				if (UICommand.t.userData[4] != null) {
					obj.dataTaxTime = null;
					if (UICommand.t.userData[4][0] == obj.dataID) {
						if (UICommand.t.userData[4][2] == null) {
							money = uint(UIXML.levelXML.tax.(@id == UICommand.t.userData[4][0]).money[0]);
							if (UICommand.t.userData[4][1]) {
								down2.receive.comp.enabled = true;
								UICommand.t.userData[4][2] = [getCapNum, (int((UICommand.t.userData[4][1][1] - UICommand.t.serverTime) / 3600000) + 1) * money, money];
							} else {
								UICommand.t.userData[4][2] = [getCapNum, -1, money];
							}
						}
						down1.visible = false;
						down2.visible = true;
						down2.countdown.text = UIName.CHAR_ELLIPSIS;
						if (UICommand.t.userData[4][1] != null) {
							UICommand.addTaxTimer();
							down2.receive.y = down2.remove.y - down2.remove.height - 4;
							down2.receive.txt.text = String(UIXML.uiXML.tax.info[5]);
							down2.remove.visible = true;
						} else {
							up.langTitle.text = String(UIXML.uiXML.tax.info[4]);
							down2.countdown.text = "00:00:00";
							down2.receive.y = down2.remove.y;
							down2.receive.txt.text = String(UIXML.uiXML.tax.info[6]);
							down2.remove.visible = false;
						}
					} else {
						obj.filters = [new ColorMatrixFilter([0.31, 0.61, 0.08, 0, 0, 0.31, 0.61, 0.08, 0, 0, 0.31, 0.61, 0.08, 0, 0, 0, 0, 0, 1, 0])];
						obj.mouseChildren = false;
					}
				} else {
					if (UICommand.t.capNum < changeCapNum) {
						UICommand.addEasyHit(down1.submit);
					} else {
						UICommand.remvoeEasyHit([down1.submit]);
					}
				}
				down1.hourNum.text = obj.dataTaxTime ? obj.dataTaxTime : String(UIXML.levelXML.tax[i].taxTime[0]);
				down1.submit.dataPrompt = String(UIXML.uiXML.phrase.consume[0]) + down1.change.text + String(UIXML.uiXML.phrase.cap[0]) + String(UIXML.uiXML.phrase.and[0]) + "{_TIME_}" + String(UIXML.uiXML.phrase.hour[0]) + String(UIXML.uiXML.mark.comma[0]) + UIName.CHAR_BREAK + String(UIXML.uiXML.tax.info[0]) + up.num.text + (UIXML.uiXML.phrase.cap[0]);
			}
		}

		/*获得税收时间*/
		public static function getTaxStartTime(dataObj : Object) : void {
			UICommand.t.userData[4][1] = (dataObj as Array);
			setServerTime((dataObj as Array)[0]);
			getTaxContainer();
		}

		/*获得税收领取按钮*/
		public static function getTaxReceive() : void {
			var revenue : DisplayObject = UICommand.t.ui[UIName.UI_MAIN_NAV].getChildByName(UIName.E_TAX_START);
			if (!revenue) {
				var ObjClass : Class = UICommand.getClass(UIClass.MC_RECEIVE);
				var obj : Object = new ObjClass();
				var sp : Sprite = obj as Sprite;
				sp.name = UIName.E_TAX_START;
				var taxStart : Sprite = (UICommand.t.ui[UIName.UI_MAIN_NAV] as Object).nav.taxStart;
				sp.x = taxStart.x + (taxStart.width >> 1) - (sp.width >> 1);
				sp.y = taxStart.y - sp.height;
				UICommand.t.ui[UIName.UI_MAIN_NAV].addChild(sp);
				sp.addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			}
		}

		/*获得任务*/
		public static function getTask(dataObj : Object) : void {
			var data : Array = dataObj as Array;
			UICommand.t.userData[3][0] = data[0];
			UICommand.t.userData[3][1] = data[1];
			UICommand.t.userData[3][4] = data[2];
			var task : TaskLayer = UICommand.t.ui[UIName.UI_TASK] as TaskLayer;
			if (UICommand.t.stateFirst == UIState.TASK) {
				if (task.stateFirst == UIState.START && task.taskReceiveFlag) UICommand.taskStateJudge();
				task.showTask();
			} else {
				UICommand.taskStateJudge();
			}
		}

		/*获得活动任务*/
		public static function getEventTasks(dataObj : Object) : void {
			var data : Array = dataObj as Array;
			UICommand.t.userData[3][2] = data;
			if (UICommand.t.stateFirst == UIState.ACTIVTITY) {
				new ActivityLayer(UICommand.t.getChildByName(UIClass.ACTIVTITY));
			} else {
				UICommand.taskStateJudge();
			}
		}

		/*获得活动礼包*/
		public static function getGift(dataObj : Object) : void {
			var data : Array = dataObj as Array;
			if (UICommand.t.selectedItems[0] == UIName.E_GIFT_HERO) {
				if (data[0][2]) {
					popupGiftSelect(data);
				} else {
					popupPrompt(String(UIXML.uiXML.prompt.reward.hero.info[0]));
				}
			} else {
				popupPrompt(UICommand.rewardResult(data, true));
				UICommand.removeGoods(1, UIDataFunList.SAVE_GIFT);
			}
		}

		/*获得公告*/
		public static function getAnnouncement(dataObj : Object) : void {
			var sp : Object = UICommand.t.getChildByName(UIClass.ANNOUNCEMENT);
			if (dataObj) getAnnContent(sp.txt2, dataObj as Array);
		}

		/*获得公告内容*/
		public static function getAnnContent(txt : TextField, data : Array) : void {
			var len : uint = data.length;
			for (var i : uint = 0; i < len; i++) {
				txt.htmlText += "<a href='" + data[i][1] + "' target='_blank'>" + data[i][0] + "</a><br>";
			}
		}

		/*获得排行榜*/
		public static function getTop(dataObj : Object = null) : void {
			if (dataObj) (UICommand.t.ui[UIName.UI_TOP] as Object).data = dataObj as Array;
			getTopGlobal(false);
			var close : Sprite = (UICommand.t.ui[UIName.UI_TOP] as Object).close;
			var scroll : DisplayObject = UICommand.t.ui[UIName.UI_TOP].getChildAt(UICommand.t.ui[UIName.UI_TOP].numChildren - 1);
			if (close.visible) {
				scroll.visible = true;
			} else {
				scroll.visible = false;
			}
		}

		/*获得好友地图排行榜*/
		public static function getTopFriend(remove : Boolean = true) : void {
			if (remove) UICommand.destroyScroll();
			(UICommand.t.ui[UIName.UI_TOP] as Object).openFriend.comp.enabled = false;
			(UICommand.t.ui[UIName.UI_TOP] as Object).bg.visible = false;
			(UICommand.t.ui[UIName.UI_TOP] as Object).all.comp.enabled = true;
			var sp : ElementTopContainer = new ElementTopContainer();
			sp.showTopContainer((UICommand.t.ui[UIName.UI_TOP] as Object).data[0]);
			_getTopScroll(sp);
		}

		/*获得全服排行榜*/
		public static function getTopGlobal(remove : Boolean = true) : void {
			if (remove) {
				(UICommand.t.ui[UIName.UI_TOP].getChildByName(UIClass.TOP_SCROLL) as Object).scrollContent.getChildAt(1).clear();
				UICommand.destroyScroll();
			}
			(UICommand.t.ui[UIName.UI_TOP] as Object).all.comp.enabled = false;
			(UICommand.t.ui[UIName.UI_TOP] as Object).openFriend.comp.enabled = true;
			(UICommand.t.ui[UIName.UI_TOP] as Object).bg.visible = true;
			var sp : Sprite = new Sprite();
			var data : Array = (UICommand.t.ui[UIName.UI_TOP] as Object).data[1];
			var len : uint = data.length;
			var ObjClass : Class;
			var obj : Object;
			for (var i : uint = 0; i < len; i++) {
				ObjClass = UICommand.getClass(UIClass.GLOBAL_TOP_CONTAINER);
				obj = new ObjClass();
				obj.data = data[i];
				obj.langTopNum.text = data[i][0];
				obj.langName.text = data[i][2];
				obj.langLevelTitle.text = String(UIXML.uiXML.phrase.level[0]);
				obj.langLevel.text = data[i][3];
				obj.langAllScoreTitle.text = String(UIXML.uiXML.phrase.experience[0]);
				obj.langAllScore.text = data[i][4];
				sp.addChild(obj as Sprite);
				if (i % 2 == 1) obj.bg.visible = false;
				if (i) obj.y = (obj.height + 5) * i;
				if (data[i][5]) {
					obj.langTopNum.textColor = 0x508C00;
					obj.langName.textColor = 0x508C00;
					obj.langLevelTitle.textColor = 0x508C00;
					obj.langLevel.textColor = 0x508C00;
					obj.langAllScoreTitle.textColor = 0x508C00;
					obj.langAllScore.textColor = 0x508C00;
					// obj.bg.visible = true;
					// obj.transform.colorTransform = new ColorTransform(0, 2, 0, 1, 0, 0, 0, 0);
				}
			}
			var position : Sprite = (UICommand.t.ui[UIName.UI_TOP] as Object).positionG;
			var point : Point = new Point(position.x, position.y);
			initScroll(UIClass.GLOBAL_TOP_SCROLL, sp, point, UICommand.t.ui[UIName.UI_TOP]);
		}

		/*获得排行滚动条及内容*/
		public static function _getTopScroll(sp : Sprite) : void {
			var position : Sprite = (UICommand.t.ui[UIName.UI_TOP] as Object).position;
			var point : Point = new Point(position.x, position.y);
			initScroll(UIClass.TOP_SCROLL, sp, point, UICommand.t.ui[UIName.UI_TOP]);
		}

		/*获得战报*/
		public static function getReport(dataObj : Object) : void {
			var sp : ElementReportContainer = new ElementReportContainer();
			sp.showReportContainer(dataObj as Array);
			var position : Sprite = (UICommand.t.ui[UIName.UI_REPORT] as Object).position;
			var point : Point = new Point(position.x, position.y);
			initScroll(UIClass.REPORT_SCROLL, sp, point, UICommand.t.ui[UIName.UI_REPORT], 8);
		}

		/*获得战斗录像回放*/
		public static function getPlayback(dataObj : Object) : void {
			var obj : Object = dataObj.mapInfo;
			for (var data:Object in obj) {
				UICommand.t.mapData[data] = obj[data];
			}
			UICommand.t.mapData.playbackInfo = dataObj.playbackInfo;
			getDefence(UICommand.t.mapData);
			// (UICommand.t.ui[UIName.UI_STOP_PLAY] as Object).playWar.dataPlayback = dataObj.playbackInfo;
		}

		/*获得科技开始时间*/
		public static function getTechStartTime(dataObj : Object = null) : void {
			if (UICommand.t.stateFirst == UIState.TECH) {
				if (dataObj != null) setServerTime((dataObj as Array)[0]);
				TechTreeLayer.SERVER_NOW_TIME = UICommand.t.serverTime;
				var list : Object = (UICommand.t.ui[UIName.UI_TECH] as Object).list;
				var info : Object = (UICommand.t.ui[UIName.UI_TECH] as Object).info;
				var sp : TechTreeLayer = UIMain.getInstance(TechTreeLayer.NAME) as TechTreeLayer;
				sp.updateTechTree(list.dataType, info.dataID);
			}
		}

		/*获得科技*/
		public static function getTech(dataObj : Object) : void {
			CannonFodderVO.techTreeInfo = dataObj;
			var sp : TechTreeLayer = UIMain.getInstance(TechTreeLayer.NAME) as TechTreeLayer;
			TechTreeLayer.SERVER_NOW_TIME = UICommand.t.serverTime;
			sp.showTechTree(TechTreeLayer.SOLDIER_TECH_TREE);
			sp.techTitle = String(UIXML.uiXML.tech.title1[0]);
			var list : Object = (UICommand.t.ui[UIName.UI_TECH] as Object).list;
			list.dataType = TechTreeLayer.SOLDIER_TECH_TREE;
			var point : Point = new Point(list.position.x, list.position.y);
			initScroll(UIClass.TECH_SCROLL, sp, point, list);
			sp.showTechRunTime();
			if (UICommand.t.userData[3][3] != null && UICommand.t.userData[3][3] < 6005 && UICommand.t.gameGuideData[0] == 1) {
				if (list.dataTC) {
					UICommand.t.getChildAt(UICommand.t.numChildren - 1).visible = false;
					UICommand.t.getChildAt(UICommand.t.numChildren - 2).visible = false;
				} else {
					UICommand.t.getChildAt(UICommand.t.numChildren - 1).visible = true;
					UICommand.t.getChildAt(UICommand.t.numChildren - 2).visible = true;
				}
			}
		}

		/*获得科技内容介绍*/
		public static function getTechInfo(type : String, data : Object) : void {
			var id : uint = data.id;
			var flag : int = data.flag;
			var level : uint = data.level;
			var ObjClass : Class;
			var obj : Object;
			var className : String;
			var levelMax : Boolean = false;
			var btn : Object;
			var infoID : uint;
			var materials : Array = [];
			var num : uint;
			var y : Number;
			var materialID : uint;
			var nextLevel : uint = level + 1;
			var techTreeXMLList : XMLList;
			var infoXMLList : XMLList;
			var levelXMLList : XMLList;
			var levelGradeXMLList : XMLList;
			var levelGradeNextXMLList : XMLList;
			var userLevel : uint;
			if (type == TechTreeLayer.SOLDIER_TECH_TREE) {
				techTreeXMLList = UIXML.soldierTechTreeXML.tech.techTree.(@id == id);
				infoID = uint(techTreeXMLList.enableTech);
				className = String(techTreeXMLList.iconName);
				infoXMLList = UIXML.soldierXML.soldier.(@id == infoID);
				levelXMLList = UIXML.soldierLevelXML.soldierLevel.(@id == infoID).level;
				userLevel = uint(techTreeXMLList.userLevel);
			} else if (type == TechTreeLayer.TOWER_TECH_TREE) {
				techTreeXMLList = UIXML.towerTechTreeXML.tech.techTree.(@id == id);
				infoID = uint(techTreeXMLList.enableTech);
				className = String(techTreeXMLList.iconName);
				infoXMLList = UIXML.towerXML.towerType.tower.(@id == infoID);
				levelXMLList = UIXML.towerLevelXML.towerType.towerLevel.(@id == infoID).level;
				userLevel = uint(techTreeXMLList.userLevel);
			}
			levelGradeXMLList = levelXMLList.(@grade == level);
			levelGradeNextXMLList = levelXMLList.(@grade == nextLevel);
			if (flag == -1) className = UIClass.ICON_TECH_QUESTION;
			ObjClass = UICommand.getClass(className);
			obj = new ObjClass();
			var info : Object = (UICommand.t.ui[UIName.UI_TECH] as Object).info;
			info.dataID = id;
			if (info.icon.numChildren == 1) info.icon.removeChildAt(0);
			info.icon.addChild(obj as Sprite);
			info.langName.visible = true;
			info.langName.text = String(infoXMLList.langName[0]);
			info.langLevelTitle.visible = false;
			info.langLevel.visible = false;
			info.upgradeMax.visible = false;
			info.upgradeInfo.visible = false;
			info.upgrading.visible = false;
			info.langInfo.visible = false;
			info.bg.visible = true;
			var condition : Object = info.condition;
			UICommand.remvoeEasyHit([condition.up, condition.submit]);
			if (flag == -1) {
				if (data.type == "main") {
					info.langInfo.text = String(UIXML.uiXML.phrase.level[0]) + String(userLevel) + String(UIXML.uiXML.disable.info[1]);
				} else {
					info.langInfo.text = String(UIXML.uiXML.phrase.level[0]) + String(userLevel) + String(UIXML.uiXML.disable.info[1]) + String(UIXML.uiXML.tech.info7[0]);
				}
				info.langInfo.visible = true;
				info.langName.visible = false;
				info.bg.visible = false;
				condition.visible = false;
			} else if (flag < 2) {
				/*开启*/
				info.langInfo.text = String(techTreeXMLList.info[0]);
				info.langInfo.visible = true;
				condition.submit.visible = true;
				condition.up.visible = false;
				btn = condition.submit;
			} else {
				/*升级*/
				if (level) {
					info.langLevelTitle.visible = true;
					info.langLevel.visible = true;
					info.langLevelTitle.text = String(UIXML.uiXML.phrase.level[0]);
					info.langLevel.text = level;
					if (levelXMLList.length() == level) {
						levelMax = true;
						info.upgradeMax.visible = true;
						// info.bg.visible = false;
						info.upgradeMax.langMax.textColor = 0xF9F17D;
						info.upgradeMax.langMax.text = String(UIXML.uiXML.mark.bracket1[0]) + String(UIXML.uiXML.phrase.levelMax[0]) + String(UIXML.uiXML.mark.bracket2[0]);
					} else {
						with(info.upgradeInfo) {
							visible = true;
							langLevelTitleA.text = String(UIXML.uiXML.phrase.level[0]);
							langLevelTitleA.width = langLevelTitleA.textWidth + 4;
							langLevelA.text = level;
							langLevelA.width = langLevelA.textWidth + 4;
							langLevelA.x = arrow.x - langLevelA.width - 4;
							langLevelTitleA.x = langLevelA.x - langLevelTitleA.width;
							langLevelTitleB.text = String(UIXML.uiXML.phrase.level[0]);
							langLevelTitleB.width = langLevelTitleB.textWidth + 4;
							langLevelB.text = nextLevel;
							upInfoA1.text = String(UIXML.uiXML.phrase.hp[0]);
							upInfoA2.text = String(levelGradeXMLList.lifeHP[0]);
							upInfoA3.text = String(levelGradeNextXMLList.lifeHP[0]);
							upInfoB1.text = String(UIXML.uiXML.phrase.attack[0]);
							upInfoB2.text = String(levelGradeXMLList.attack[0]);
							upInfoB3.text = String(levelGradeNextXMLList.attack[0]);
							upInfoC1.text = String(UIXML.uiXML.phrase.defence2[0]);
							upInfoC2.text = String(levelGradeXMLList.defence[0]);
							upInfoC3.text = String(levelGradeNextXMLList.defence[0]);
							upInfoD1.text = String(UIXML.uiXML.phrase.armor[0]);
							upInfoD2.text = String(levelGradeXMLList.armor[0]);
							upInfoD3.text = String(levelGradeNextXMLList.armor[0]);
						}
						condition.submit.visible = false;
						condition.up.visible = true;
					}
					btn = condition.up;
				}
			}
			if (flag != -1) {
				if (levelMax) {
					condition.visible = false;
				} else {
					if (flag == 2) {
						info.upgrading.visible = true;
						condition.visible = false;
					} else {
						condition.visible = true;
						condition.langTitle.text = String(UIXML.uiXML.tech.info1[0]);
						if (condition.getChildByName(UIClass.TECH_MATERIAL)) condition.removeChild(condition.getChildByName(UIClass.TECH_MATERIAL));
						materialID = uint(levelGradeNextXMLList.materialsA);
						if (materialID) {
							num = uint(levelGradeNextXMLList.materialsumA);
							materials[0] = [];
							materials[0][0] = materialID;
							materials[0][1] = num;
						}
						materialID = uint(levelGradeNextXMLList.materialsB);
						if (materialID) {
							num = uint(levelGradeNextXMLList.materialsumB);
							materials[1] = [];
							materials[1][0] = materialID;
							materials[1][1] = num;
						}
						if (materials.length) {
							y = condition.langTitle.y + condition.langTitle.height + 10;
							_getTechMaterial(condition, btn, materials, y);
							btn.dataMaterials = materials;
							materials = [];
						} else {
							btn.dataMaterials = null;
						}
						btn.dataClassName = className;
						btn.dataNextLevel = nextLevel;
						btn.dataPar = condition;
						condition.cap.text = btn.dataCap = String(levelGradeNextXMLList.cap);
						if ((UICommand.t.capNum < uint(btn.dataCap)) && btn.comp.enabled) UICommand.addEasyHit(btn as Sprite, String(UIXML.uiXML.tech.info5[0]));
						condition.money.text = btn.dataMoney = String(levelGradeNextXMLList.money);
						if ((UICommand.t.realMoney < uint(btn.dataMoney)) && btn.comp.enabled) UICommand.addEasyHit(btn as Sprite, String(UIXML.uiXML.tech.info5[0]));
						if ((UIMain.getInstance(TechTreeLayer.NAME) as TechTreeLayer).searchFlagTwo() && btn.comp.enabled) UICommand.addEasyHit(btn as Sprite, String(UIXML.uiXML.tech.info6[0]));
					}
				}
			}
		}

		/*获得科技升级需要材料[i][0]ID，[i][1]消耗数量[i][2]t.bagData索引位置*/
		private static function _getTechMaterial(par : Object, btn : Object, materials : Array, y : Number) : void {
			var ObjClass : Class;
			var obj : Object;
			var child : Object;
			var xmlList : XMLList;
			var className : String;
			var num : uint;
			var hadNum : uint;
			var maxB : uint;
			var max : uint = materials.length;
			var box : Sprite = new Sprite();
			box.name = UIClass.TECH_MATERIAL;
			// box.addEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			// box.addEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
			for (var i : uint = 0; i < max; i++) {
				ObjClass = UICommand.getClass(UIClass.TECH_MATERIAL);
				obj = new ObjClass();
				obj.x = (i * obj.width) + (i * 10);
				box.addChild(obj as DisplayObject);
				UICommand.convertButtonMode(obj as Sprite, false);
				xmlList = UIXML.materialXML.material.(@id == materials[i][0]);
				className = String(xmlList.name[0]);
				ObjClass = UICommand.getClass(className);
				child = new ObjClass();
				child.x = child.y = 1;
				obj.dataLangName = String(xmlList.langName[0]);
				obj.dataInfo = String(xmlList.info[0]);
				obj.icon.addChild(child);
				num = materials[i][1];
				if (UICommand.t.bagData[1] != null) {
					maxB = UICommand.t.bagData[1].length;
					for (var j : uint = 0; j < maxB; j++) {
						if (UICommand.t.bagData[1][j][0] == materials[i][0]) {
							materials[i].push(j);
							hadNum = UICommand.t.bagData[1][j][1];
						}
					}
				}
				if (hadNum > num) hadNum = num;
				obj.num.text = hadNum + UIName.CHAR_SlASH + num;
				if ((hadNum < num) && btn.comp.enabled) UICommand.addEasyHit(btn as Sprite, String(UIXML.uiXML.tech.info5[0]));
				hadNum = 0;
			}
			box.x = (par.width >> 1) - (box.width >> 1);
			box.y = y;
			par.addChild(box);
			// var two : DisplayObject = par.getChildAt(par.numChildren - 2);
			// if (two.name == UIName.E_REPLACE_DISABLE_HIT) par.addChild(two);
		}

		/*获得英雄*/
		public static function getHero(dataObj : Object) : void {
			var data : Array = dataObj as Array;
			/*刷新出可购买的英雄*/
			var maxA : uint = data.length;
			var refreshSP : Sprite = new Sprite();
			refreshSP.name = UIName.PRESENT_HERO_REFRESH;
			(UICommand.t.ui[UIName.UI_HERO] as Object).box.addChild(refreshSP);
			var ObjClass : Class;
			var obj : Object;
			for (var i : uint = 0; i < maxA; i++) {
				ObjClass = UICommand.getClass(UIClass.HERO_CONTAINER);
				obj = new ObjClass();
				initHeroContent(data[i], obj);
				(obj as Sprite).x = (obj as Sprite).width * i + 4 * i;
				refreshSP.addChild(obj as Sprite);
			}
			/*刷新时间*/
			(UICommand.t.ui[UIName.UI_HERO] as Object).timeTitle.text = String(UIXML.uiXML.refreshHero.countdown[0]);
			UICommand.heroRefresh();
		}

		/*获得已有英雄*/
		public static function getHadHero(dataObj : Object) : void {
			var data : Array = dataObj as Array;
			/*格子*/
			if (data[0] != null) {
				UICommand.t.openLockNum = data[0];
				UICommand.openLock();
			}
			/*已雇佣英雄*/
			var hadHeroBox : Sprite = new Sprite();
			hadHeroBox.name = UIName.PRESENT_HAD_HERO;
			hadHeroBox.x = (UICommand.t.ui[UIName.UI_HERO] as Object).cardBox.x;
			hadHeroBox.y = (UICommand.t.ui[UIName.UI_HERO] as Object).cardBox.y;
			UICommand.t.ui[UIName.UI_HERO].addChild(hadHeroBox);
			var hadHeroSP : Sprite = new Sprite();
			hadHeroBox.addChild(hadHeroSP);
			var hadHeroBTN : Sprite = new Sprite();
			hadHeroBox.addChild(hadHeroBTN);
			if (data[1] != null) {
				var maxB : uint = data[1].length;
				for (var i : uint = 0; i < maxB; i++) {
					_getHeroCard(data[1][i], hadHeroSP, i);
				}
				_addHadHeroAttrBTN(hadHeroBTN, hadHeroSP);
			}
		}

		/*初始化英雄内容，主要是属性界面*/
		public static function initHeroContent(data : Array, par : Object, attr : Boolean = false) : void {
			var end : uint;
			var current : uint;
			var next : uint;
			var max : int;
			var num : int;
			var i : uint;
			var xmlList : XMLList;
			var className : String;
			var ObjClass : Class;
			var obj : Object;
			par.langName.text = String(UIXML.heroNameRaceXML.name.heroNamePrefix.(@id == data[2][2])) + String(UIXML.heroNameRaceXML.name.heroName.(@id == data[2][1]));
			if (data[3] == 2) par.langName.textColor = 0xFF0000;
			max = par.score.numChildren;
			num = max - (5 - data[11]);
			for (i = num; i < max; i++) {
				par.score.getChildAt(i).visible = false;
			}
			if (attr) {
				var upSum : uint = data[5] - 1;
				/*仅属性界面*/
				className = String(UIXML.heroXML.hero.(@id == data[1]).name[0]);
				obj = new ShowLoadOriginal(className);
				par.card.addChild(obj);
				obj.data = data;
				xmlList = UIXML.heroLevelXML.heroLevel.level;
				/*体力*/
				par.langAppraise.text = String(UIXML.uiXML.phrase.appraise[0]);
				par.langAttribute.text = String(UIXML.uiXML.phrase.attribute[0]);
				par.langAttribute1.text = String(UIXML.uiXML.heroAttribute.info[0]);
				par.langAttribute2.text = String(UIXML.uiXML.heroAttribute.info[1]);
				par.langAttribute3.text = String(UIXML.uiXML.heroAttribute.info[2]);
				UICommand.changeHeroPower(par, data[4], uint(xmlList[upSum].power[0]));

				/*等级*/
				par.langLevelTitle.text = String(UIXML.uiXML.phrase.level[0]);
				par.langLevel.text = String(data[5]);
				num = 0;
				max = 0;
				if (data[5] < 10) {
					for (i = 0; i < data[5]; i++) {
						if (i != end) current += uint(xmlList[i - 1].upHonor[0]);
						next += uint(xmlList[i].upHonor[0]);
					}
					par.barLevel.width = par.barLevel.width * ((data[6] - current) / next);
				}

				/*魅力.生命*/
				par.langHP.text = String(UIXML.heroXML.heroRelate.lifeHPName[0]);
				var maxHP : int = int(UIXML.heroXML.heroRelate.lifeHPMax[0]);
				par.barCurrentHP.width = par.barCurrentHP.width * ((data[7][0] + (upSum * data[7][1])) / maxHP);
				par.barNextHP.width = par.barNextHP.width * (data[7][1] / maxHP);
				par.barNextHP.x = par.barCurrentHP.x + par.barCurrentHP.width;
				/*人气.护甲*/
				par.langArmor.text = String(UIXML.heroXML.heroRelate.armorName[0]);
				var maxArmor : int = int(UIXML.heroXML.heroRelate.armorMax[0]);
				par.barCurrentArmor.width = par.barCurrentArmor.width * ((data[8][0] + (upSum * data[8][1])) / maxArmor);
				par.barNextArmor.width = par.barNextArmor.width * (data[8][1] / maxArmor);
				par.barNextArmor.x = par.barCurrentArmor.x + par.barCurrentArmor.width;
				/*统帅.防御*/
				par.langDefence.text = String(UIXML.heroXML.heroRelate.defenceName[0]);
				var maxDefence : int = int(UIXML.heroXML.heroRelate.defenceMax[0]);
				par.barCurrentDefence.width = par.barCurrentDefence.width * ((data[9][0] + (upSum * data[9][1])) / maxDefence);
				par.barNextDefence.width = par.barNextDefence.width * (data[9][1] / maxDefence);
				par.barNextDefence.x = par.barCurrentDefence.x + par.barCurrentDefence.width;
				/*体格.攻击*/
				par.langAttack.text = String(UIXML.heroXML.heroRelate.attackName[0]);
				var maxAttack : int = int(UIXML.heroXML.heroRelate.attackMax[0]);
				par.barCurrentAttack.width = par.barCurrentAttack.width * ((data[10][0] + (upSum * data[10][1])) / maxAttack);
				par.barNextAttack.width = par.barNextAttack.width * (data[10][1] / maxAttack);
				par.barNextAttack.x = par.barCurrentAttack.x + par.barCurrentAttack.width;
				/*装备*/
				par.langEquip.text = String(UIXML.uiXML.phrase.equipment[0]);
				getHeroAttrEquip(par);
				/*神灯*/
				par.langGem.text = String(UIXML.uiXML.phrase.gem[0]);
				getHeroAttrGem(par);
				par.langRace.text = String(UIXML.uiXML.phrase.race[0]);
				par.langRaceInfo.text = String(UIXML.heroNameRaceXML.race.(@id == data[2][0]).info[0]);
				/*技能*/
				par.langSkill.text = String(UIXML.uiXML.phrase.skill[0]);
				className = String(UIXML.heroSkillXML.heroSkills.(@id == data[12]).name[0]);
				ObjClass = UICommand.getClass(className);
				obj = new ObjClass();
				obj.name = className;
				obj.x = obj.y = 1;
				par.gridSkill.addChild(obj);
				par.langSkillInfo.text = String(UIXML.heroSkillXML.heroSkills.(@id == data[12]).info[0]);
			} else {
				par.money.text = String(UIXML.heroXML.heroRelate.buy.price[data[11] - 1]);
				_getHeroCard(data, par.card);
			}
		}

		/*获得英雄属性界面装备*/
		public static function getHeroAttrEquip(content : Object) : void {
			if (content.gridEquip.numChildren == 2) content.gridEquip.removeChildAt(1);
			content.barEquipHP.visible = false;
			content.barEquipArmor.visible = false;
			content.barEquipDefence.visible = false;
			content.barEquipAttack.visible = false;
			var index : uint = content.parent.dataObj.data[13];
			var addLevel : uint = 0;
			content.parent.dataAddLevel = addLevel;
			if (index) {
				var xmlList : XMLList = UIXML.equipmentXML.equipCategory.equip.(@id == index);
				content.parent.dataAddLevel = addLevel = uint(xmlList.addLevel[0]);
				var className : String = String(xmlList.name[0]);
				var ObjClass : Class = UICommand.getClass(className);
				var obj : Object = new ObjClass();
				obj.x = obj.y = 1;
				content.gridEquip.addChild(obj);
				var maxHP : int = int(UIXML.heroXML.heroRelate.lifeHPMax[0]);
				var maxArmor : int = int(UIXML.heroXML.heroRelate.armorMax[0]);
				var maxDefence : int = int(UIXML.heroXML.heroRelate.defenceMax[0]);
				var maxAttack : int = int(UIXML.heroXML.heroRelate.attackMax[0]);
				var num : int;
				/*魅力.生命*/
				num = int(xmlList.addHP[0]);
				if (num) {
					content.barEquipHP.visible = true;
					content.barEquipHP.width = content.barEquipHP.width * (num / maxHP);
					content.barEquipHP.x = content.barNextHP.x + content.barNextHP.width;
				}
				/*人气.护甲*/
				num = int(xmlList.addArmor[0]);
				if (num) {
					content.barEquipArmor.visible = true;
					content.barEquipArmor.width = content.barEquipArmor.width * (num / maxArmor);
					content.barEquipArmor.x = content.barNextArmor.x + content.barNextArmor.width;
				}
				/*统帅.防御*/
				num = int(xmlList.addDefence[0]);
				if (num) {
					content.barEquipDefence.visible = true;
					content.barEquipDefence.width = content.barEquipDefence.width * (num / maxDefence);
					content.barEquipDefence.x = content.barNextDefence.x + content.barNextDefence.width;
				}
				/*体格.攻击*/
				num = int(xmlList.addAttack[0]);
				if (num) {
					content.barEquipAttack.visible = true;
					content.barEquipAttack.width = content.barEquipAttack.width * (num / maxAttack);
					content.barEquipAttack.x = content.barNextAttack.x + content.barNextAttack.width;
				}
			}
			if ((content.parent.dataObj.data[5] + addLevel) < uint(UIXML.gemXML.gem.(@id == content.parent.dataObj.data[14]).level[0])) {
				content.parent.dataObj.data[14] = null;
				if (content.gridGem.numChildren == 2) content.gridGem.removeChildAt(1);
			}
		}

		/*获得英雄属性界面神灯*/
		public static function getHeroAttrGem(content : Object) : void {
			if (content.gridGem.numChildren == 2) content.gridGem.removeChildAt(1);
			var index : uint = content.parent.dataObj.data[14];
			if (index) {
				var className : String = String(UIXML.gemXML.gem.(@id == index).name[0]);
				var ObjClass : Class = UICommand.getClass(className);
				var obj : Object = new ObjClass();
				obj.x = obj.y = 1;
				content.gridGem.addChild(obj);
			}
		}

		/*获得英雄技能卡片*/
		public static function getHeroSkillCard() : void {
			var obj : DisplayObject = (UICommand.t.getChildByName(UIName.PRESENT_EXPENDABLE) as Sprite).getChildAt(0);
			if (obj.name.indexOf(UIName.XML_HERO + UIName.CHAR_UNDERLINE) != -1) {
				var ObjClass : Class;
				var spA : Sprite = new Sprite();
				spA.x = obj.x + 35;
				spA.y = obj.y;
				obj.parent.addChild(spA);
				obj.x = -35;
				obj.y = 0;
				spA.addChild(obj);
				ObjClass = UICommand.getClass(UIClass.CARD_HERO_SKILL);
				var skill : Sprite = new ObjClass();
				UICommand.convertButtonMode(skill);
				skill.name = UIClass.CARD_HERO_SKILL;
				var spB : Sprite = new Sprite();
				skill.x = -35;
				skill.y = 0;
				spB.addChild(skill);
				spB.x = spA.x;
				spB.y = spA.y;
				spA.parent.addChild(spB);
				spB.visible = false;
				(skill as Object).dataSkillID = (obj as Object).dataSkillID;
				ObjClass = UICommand.getClass(String(UIXML.heroSkillXML.heroSkills.(@id == skill.dataSkillID).name[0]));
				var icon : Sprite = new ObjClass();
				icon.x = (skill as Object).position.x;
				icon.y = (skill as Object).position.y;
				skill.addChild(icon);
				TweenLite.to(spB, 0, {transformMatrix:{skewY:90}});
				TweenLite.to(spA, 0.2, {transformMatrix:{skewY:-90}, onComplete:UITransition.restoreOrDestroyTC, onCompleteParams:[skill, {remove:false, visible:true}]});
				TweenLite.to(spB, 0.2, {transformMatrix:{skewY:0}, delay:0.2, onComplete:UITransition.heroSkillCardTC, onCompleteParams:[spB, skill, spA]});
				(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).makeHero(obj);
			}
		}

		/*获得英雄界面卡片*/
		private static function _getHeroCard(data : Array, par : Sprite, index : int = -1) : void {
			var className : String = String(UIXML.heroXML.hero.(@id == data[1]).name[0]);
			var ObjClass : Class = UICommand.getClass(UIClass.CARD_HERO_PREFIX + className);
			var obj : Object = new ObjClass();
			obj.removeChild(obj.common);
			if (index > -1) obj.x = index * obj.width + index * 4;
			obj.data = data;
			par.addChild(obj as Sprite);
		}

		/*给已经有的英雄添加查看属性按钮*/
		private static function _addHadHeroAttrBTN(par : Sprite, sp : Sprite) : void {
			var max : uint = sp.numChildren;
			for (var i : uint = 0; i < max; i++) {
				addSmallBTN(par, UIClass.CARD_GEAR, sp.getChildAt(i).x + 36, sp.getChildAt(i).y + 70);
			}
		}

		/*获得匹配对手界面对手头像，等级，名称，地图名称等级，开战费用*/
		public static function getRival(dataObj : Object) : void {
			var mapLevel : uint = (dataObj as Array)[2];
			var scale : Boolean = true;
			if (UICommand.t.rivalData[0] == null) {
				UICommand.t.rivalData[0] = [[mapLevel, mapLevel - 1, 1]];
				scale = false;
			}
			UICommand.t.loaders[UICommand.t.rivalData[0][0][1]] = [];
			var rivalAndMapData : Array = [];
			rivalAndMapData[0] = (dataObj as Array)[0];
			rivalAndMapData[1] = [];
			var mapXmlList : XMLList = UIXML.mapXML.maps.(@id == (UICommand.t.rivalData[0][0][0] + 100));
			rivalAndMapData[1][0] = String(mapXmlList.mapName[0]);
			var xmlList : XMLList = mapXmlList.goods.war.good;
			var goodsSum : uint = xmlList.length();
			rivalAndMapData[1][1] = [];
			for (var k : uint = 0; k < goodsSum; k++) {
				rivalAndMapData[1][1][rivalAndMapData[1][1].length] = [xmlList[k], 0];
			}
			rivalAndMapData[1][2] = uint(mapXmlList.inToken[0]);
			rivalAndMapData[1][3] = uint(mapXmlList.inCap[0]);
			UICommand.t.rivalData[UICommand.t.rivalData[0][0][0]] = rivalAndMapData;
			var content : Object = (UICommand.t.ui[UIName.UI_SELECT_RIVAL] as Object).content;
			content.langGoods.text = String(UIXML.uiXML.selectRival.specialty[0]);
			content.term.text = String(UIXML.uiXML.phrase.challenge[0]) + String(UIXML.uiXML.phrase.term[0]);
			var navBTN : Object;
			for (var i : uint = 1; i < 16; i++) {
				navBTN = (UICommand.t.ui[UIName.UI_SELECT_RIVAL] as Object).nav.getChildAt(i);
				navBTN.dataIndex = i;
				navBTN.bg.visible = false;
				if (i > mapLevel) {
					navBTN.comp.enabled = false;
					navBTN.num.visible = false;
				} else {
					if (i == mapLevel && !scale) {
						navBTN.comp.enabled = false;
					} else {
						navBTN.comp.enabled = true;
					}
				}
			}
			getRivalContent(scale);
			if (UICommand.t.rivalData[0][1] == null) {
				setServerTime((dataObj as Array)[1][1]);
				var refreshTime : uint = uint(UIXML.levelXML.relate.rivalRefreshTime[0]);
				var countdown : int = refreshTime - ((UICommand.t.serverTime - (dataObj as Array)[1][0]) / 1000);
				if (countdown > 0) {
					(UICommand.t.ui[UIName.UI_SELECT_RIVAL] as Object).refresh.comp.enabled = false;
					(UICommand.t.ui[UIName.UI_SELECT_RIVAL] as Object).time.visible = true;
					(UICommand.t.ui[UIName.UI_SELECT_RIVAL] as Object).time.text = String(countdown);
					var myTimer : Timer = new Timer(1000);
					myTimer.addEventListener(TimerEvent.TIMER, UICommand.t.rivalTimerHandler);
					myTimer.start();
					UICommand.t.rivalData[0][1] = myTimer;
				}
			}
		}

		/*获得匹配对手界面对手具体内容并执行动画*/
		public static function getRivalContent(scale : Boolean = true) : void {
			var content : Object = (UICommand.t.ui[UIName.UI_SELECT_RIVAL] as Object).content;
			var nav : Object = (UICommand.t.ui[UIName.UI_SELECT_RIVAL] as Object).nav;
			var box : Sprite = (UICommand.t.ui[UIName.UI_SELECT_RIVAL] as Object).box;
			box.visible = true;
			var rivalAndMapData : Array = UICommand.t.rivalData[UICommand.t.rivalData[0][0][0]];
			content.mapName.text = rivalAndMapData[1][0];
			UICreate.getGoods(rivalAndMapData[1][1], content.goodsBox);
			content.token.text = rivalAndMapData[1][2];
			content.cap.text = rivalAndMapData[1][3];
			var container : Object;
			for (var i : uint = 0; i < 4; i++) {
				container = box.getChildAt(i);
				container.dataIndex = i;
				loadImg(rivalAndMapData[0][i][2], container.icon);
				UICommand.convertButtonMode(container.icon);
				container.langName.text = rivalAndMapData[0][i][3];
			}
			if (scale) {
				TweenLite.to(box, 0.4, {scaleX:0.4, scaleY:0.4});
				var navBTNP : Object = nav.getChildAt(UICommand.t.rivalData[0][0][2]);
				navBTNP.bg.visible = false;
				navBTNP.comp.enabled = true;
				navBTNP.scaleX = navBTNP.scaleY = 1;
			} else {
				box.scaleX = box.scaleY = 0.4;
			}
			var rDe : int = -(UICommand.t.rivalData[0][0][1] * 24);
			TweenLite.to(nav, 0.4, {rotation:rDe});
			TweenLite.to(content, 0.4, {alpha:0});
			TweenLite.to(content, 0.4, {delay:0.4, alpha:1});
			TweenLite.to(box, 0.6, {delay:0.4, scaleX:1, scaleY:1, ease:Back.easeOut});
			var navBTN : Object = nav.getChildAt(UICommand.t.rivalData[0][0][0]);
			navBTN.bg.visible = true;
			navBTN.comp.enabled = false;
			TweenLite.to(navBTN, 0.2, {delay:0.4, scaleX:1.2, scaleY:1.2, ease:Back.easeOut});
		}

		/*获得对手的布防数据*/
		public static function getRivalDefenceTower(data : Array) : void {
			(UICommand.t.ui[UIName.UI_SELECT_ATTACK_ROLE] as Object).dataTower = data;
			var tower : Object = (UICommand.t.ui[UIName.UI_SELECT_ATTACK_ROLE] as Object).tower;
			var contentMask : Object = tower.contentMask;
			var towerNum : uint = data.length;
			var box : Sprite = new Sprite();
			tower.dataBox = box;
			tower.addChild(box);
			var content : Vector.<DynamicLoadOriginal> = new Vector.<DynamicLoadOriginal>(towerNum, true);
			var towerName : String;
			for (var i : uint = 0; i < towerNum; i++) {
				towerName = String(UIXML.towerXML.towerType.(@type == data[i][0]).tower.(@id == data[i][1]).name[0]);
				content[i] = new DynamicLoadOriginal(towerName, false);
				box.addChild(content[i] as DisplayObject);
				content[i].x = 25 + (50 * i);
			}
			tower.addChild(box);
			box.mask = contentMask as DisplayObject;
			box.y = 120;
			TweenLite.from(box, 0.4, {alpha:0});
			if (contentMask.width >= towerNum * GlobalVariable.RECT_WIDTH) {
				box.x = contentMask.width / 2 - towerNum * GlobalVariable.RECT_WIDTH / 2 + GlobalVariable.RECT_WIDTH / 2;
				tower.left.visible = false;
				tower.right.visible = false;
			} else {
				box.x = contentMask.x + GlobalVariable.RECT_WIDTH / 2;
				tower.left.visible = false;
				tower.right.visible = true;
				tower.dataMoveSum = towerNum - int(contentMask.width / GlobalVariable.RECT_WIDTH);
				tower.dataMoveNum = 0;
			}
		}

		/*获得派兵界面上次出兵框内容*/
		public static function getPrevExpendable(data : Array, p : Sprite) : void {
			var cardNum : uint = data.length;
			var from : Object;
			var fromCopy : Object;
			var stagePoint : Point;
			var box : Sprite = (UICommand.t.ui[UIName.UI_SELECT_ATTACK_ROLE] as Object).expendables.box;
			for (var i : uint = 0; i < cardNum; i++) {
				from = data[i];
				/*标记卡片已经使用，并禁用*/
				from.common.disable.visible = true;
				from.useHandCursor = false;
				stagePoint = from.localToGlobal(new Point(0, 0));
				fromCopy = UICommand.cloneInstance(from as Sprite);
				fromCopy.x = stagePoint.x;
				fromCopy.y = stagePoint.y;
				fromCopy.common.disable.visible = false;
				UICommand.copyObjData(from, fromCopy);
				UICommand.t.addChild(fromCopy as DisplayObject);
				iconLevel(fromCopy.getChildAt(1) as Sprite, fromCopy.dataLevel);
				stagePoint = box.getChildAt(i + 1).localToGlobal(new Point(0, 0));
				TweenLite.to(fromCopy, 0.2, {x:stagePoint.x - 2, y:stagePoint.y - 2, onComplete:UITransition.roleScrollToExpendableTC, onCompleteParams:[fromCopy]});
			}
			if (cardNum == UICommand.t.openLockNum) UICommand.changeAttackRoleCard(p, true);
			if (UICommand.t.userData[3][3] != null && UICommand.t.userData[3][3] == 6003 && UICommand.t.gameGuideData[0] == 3) {
				UICommand.removeGuideHighlight();
				UICommand.t.gameGuideData[0] = 4;
				UICreate.addGuideHighlight(p.getChildAt(cardNum) as Sprite, String(UIXML.gameGuideXML.guide.(@id == 6003).tip.content[4]));
			}
		}

		/*获得派兵界面的需要通过数，拥有的角色，添加出兵框*/
		public static function getAttackRole(dataObj : Object) : void {
			var data : Array = dataObj as Array;
			(UICommand.t.ui[UIName.UI_SELECT_ATTACK_ROLE] as Object).dataAttackRole = dataObj;
			var attackRole : Object = (UICommand.t.ui[UIName.UI_SELECT_ATTACK_ROLE] as Object).attackRole;
			var through : Object = (UICommand.t.ui[UIName.UI_SELECT_ATTACK_ROLE] as Object).expendables.through;
			through.num.text = String(UIXML.mapXML.maps.(@id == UICommand.t.mapData.mapId).winPeople[0]);
			through.visible = false;
			if (data[0]) _upDownPagesAllRole(UIName.PRESENT_ATTACK_HERO, attackRole, data[0], UIName.XML_HERO, 5);
			var cards : Sprite = new Sprite();
			cards.name = UIName.PRESENT_ATTACK_SOLDIER;
			_getAttackCard(data[1], UIName.XML_SOLDIER, cards);
			/*滚动条初始化*/
			var point : Point = new Point(attackRole.position.x, attackRole.position.y);
			initScroll(UIClass.ROLE_SCROLL, cards, point, attackRole, 0);
			/*添加出兵框和事件*/
			var presentExpendable : Sprite = new Sprite();
			presentExpendable.name = UIName.PRESENT_EXPENDABLE;
			UICommand.t.addChild(presentExpendable);
			presentExpendable.addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			presentExpendable.addEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			presentExpendable.addEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);

			/*出兵框格子*/
			UICommand.t.openLockNum = data[2];
			UICommand.openLock();
			/*选兵框按钮事件*/
			if (data[3] == null) {
				attackRole.prev.comp.enabled = false;
			} else {
				attackRole.prev.comp.enabled = true;
				attackRole.dataPrev = data[3];
			}
			/*添加英雄属性按钮容器*/
			var heroAttributeBTN : Sprite = new Sprite();
			heroAttributeBTN.name = UIName.PRESENT_HERO_ATTRIBUTE;
			UICommand.t.addChild(heroAttributeBTN);
			UICommand.t.mapData.dailyWarSum = data[4];
			heroAttributeBTN.addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
		}

		/*获得派兵界面选兵框卡片*/
		private static function _getAttackCard(data : Array, type : String, par : Sprite) : void {
			var cardGrid : Sprite = new Sprite();
			var card : Sprite = new Sprite();
			var cardNum : uint = data.length;
			var vectors : Vector.<Sprite> = new Vector.<Sprite>(cardNum, true);
			_getAllRole(data, type, vectors);
			_getScrollBGGrid(cardNum, 16, UIClass.CARD_GRID, cardGrid, 8, 6, 8, 3);
			_arrangeAllRole(vectors, card, 8, 2, 2);
			par.addChild(cardGrid);
			par.addChild(card);
		}

		/*获得滚动条背景格子*/
		private static function _getScrollBGGrid(num : uint, groupNum : uint, className : String, box : Sprite, br : uint, colGap : uint, rowGap : uint, offset : uint = 0) : void {
			var indexX : uint;
			var indexY : uint;
			var bgGridNum : uint = num;
			if (num % br) bgGridNum = num + (br - (num % br));
			if (bgGridNum < groupNum) bgGridNum = groupNum;
			var ObjClass : Class;
			var bgGrid : Sprite;
			for (var i : uint = 0; i < bgGridNum; i++) {
				ObjClass = UICommand.getClass(className);
				bgGrid = new ObjClass();
				box.addChild(bgGrid);
				indexX = i % br;
				indexY = uint(i / br);
				bgGrid.x = offset + (uint(bgGrid.width) * indexX) + (colGap * indexX);
				bgGrid.y = offset + (uint(bgGrid.height) * indexY) + (rowGap * indexY);
			}
		}

		/*获得进攻或防守角色*/
		private static function _getAllRole(data : Array, type : String, box : Vector.<Sprite>, origin : uint = 0, dossier : Boolean = false) : void {
			UICommand.orderCard(data, type, dossier);
			var className : String;
			var roleNum : uint = data.length;
			var tempClass : Class;
			var id : uint;
			var xmlList : XMLList;
			for (var i : uint = 0; i < roleNum; i++) {
				switch(type) {
					case UIName.XML_HERO :
						id = data[i][1];
						if (dossier) id = data[i][0];
						className = String(UIXML.heroXML.hero.(@id == id).name[0]);
						tempClass = UICommand.getClass(UIClass.CARD_HERO_PREFIX + className);
						box[i + origin] = new tempClass() as Sprite;
						if (dossier) {
							box[i + origin].name = UIName.XML_HERO + UIName.CHAR_UNDERLINE + className;
							(box[i + origin] as Object).dataLangName = String(UIXML.heroNameRaceXML.name.heroNamePrefix.(@id == data[i][1])) + String(UIXML.heroNameRaceXML.name.heroName.(@id == data[i][2]));
							(box[i + origin] as Object).dataLevel = data[i][3];
							(box[i + origin] as Object).dataSkillID = data[i][4];
							(box[i + origin] as Object).dataGemID = data[i][5];
							box[i + origin].removeChild((box[i + origin] as Object).common);
						} else {
							UICommand.addHeroProperty(box[i + origin], data, className, i);
						}
						break;
					case UIName.XML_SOLDIER :
						id = data[i][0];
						xmlList = UIXML.soldierXML.soldier.(@id == id);
						className = String(xmlList.name[0]);
						tempClass = UICommand.getClass(UIClass.CARD_SOLDIER_PREFIX + className);
						box[i + origin] = new tempClass() as Sprite;
						if (dossier) {
							box[i + origin].name = UIName.XML_SOLDIER + UIName.CHAR_UNDERLINE + className;
							(box[i + origin] as Object).dataLevel = data[i][1];
							(box[i + origin] as Object).dataLangName = String(xmlList.langName[0]);
							box[i + origin].removeChild((box[i + origin] as Object).common);
							var tf : TextField = UICommand.createTF(TextFormatAlign.CENTER, 0xffffff, 14, data[i][1], UIName.FONT_SHOW_CARD);
							tf.width = 70;
							tf.y = 56;
							box[i + origin].addChild(tf);
						} else {
							UICommand.addSoldierProperty(box[i + origin], data, className, i);
						}
						break;
					case UIName.XML_TOWER:
						xmlList = UIXML.towerXML.towerType.(@type == data[i][0]).tower.(@id == data[i][1]);
						className = String(xmlList.name[0]);
						tempClass = UICommand.getClass(UIClass.CARD_TOWER_PREFIX + className);
						box[i + origin] = new tempClass() as Sprite;
						if (dossier) {
							box[i + origin].name = UIName.XML_TOWER + UIName.CHAR_UNDERLINE + className;
							(box[i + origin] as Object).dataLangName = String(xmlList.langName[0]);
							(box[i + origin] as Object).dataLevel = data[i][2];
							box[i + origin].removeChild((box[i + origin] as Object).common);
						} else {
							UICommand.addTowerProperty(box[i + origin], data, className, i);
						}
						break;
				}
				if (!dossier) iconLevel(box[i + origin].getChildAt(1) as Sprite, (box[i + origin] as Object).dataLevel);
			}
		}

		public static function iconLevel(par : Sprite, level : uint) : void {
			var icon : Sprite = UICommand.getInstance(UIClass.CARD_ICON_LEVEL);
			par.addChild(icon);
			var num : NumberFont = new NumberFont(String(level));
			icon.addChild(num);
			num.x = (icon.width - num.width) / 2 - 2;
			num.y = (icon.height - num.height) / 2 - 2;
		}

		/*排列进攻或防守角色*/
		private static function _arrangeAllRole(content : Vector.<Sprite>, box : Sprite, br : uint, colGap : uint, rowGap : uint, btn : Boolean = true) : void {
			var indexX : uint = 0;
			var indexY : uint = 0;
			var contentNum : uint = content.length;
			for (var i : uint = 0; i < contentNum; i++) {
				box.addChild(content[i]);
				indexX = i % br;
				indexY = uint(i / br);
				content[i].x = (70 * indexX) + (colGap * indexX);
				content[i].y = (85 * indexY) + (rowGap * indexY);
				UICommand.convertButtonMode(content[i], btn);
			}
		}

		/*获得选择地图界面*/
		public static function getMap(dataObj : Object) : void {
			var data : Array = dataObj as Array;
			UICommand.changeSelectMap(data);
			if (UICommand.t.userData[3][3] != null && UICommand.t.userData[3][3] == 6003) {
				if (UICommand.t.gameGuideData[0] == 1) {
					addGuideHighlight((UICommand.t.ui[UIName.UI_SELECT_MAP] as Object).defence.getChildAt(0), String(UIXML.gameGuideXML.guide.(@id == 6003).tip.content[1]));
				} else if (UICommand.t.gameGuideData[0] == 6) {
					UICreate.addGuideHighlight((UICommand.t.ui[UIName.UI_SELECT_MAP] as Object).close, String(UIXML.gameGuideXML.guide.(@id == 6003).tip.content[6]));
				}
			}
		}

		/*获得能摆的塔,摆塔布防界面，或派兵界面对手的防御数据，地图名字，使用塔种类*/
		public static function getTower(dataObj : Object) : void {
			if (UICommand.t.stateFirst == UIState.DEFENCE) {
				_upDownPagesAllRole(UIName.PRESENT_DEFENCE_TOWER, UICommand.t.ui[UIName.UI_DEFENCE_OPERATION], dataObj as Array, UIName.XML_TOWER, 5);
				(UICommand.t.ui[UIName.UI_DEFENCE_OPERATION] as Object).dataTower = dataObj;
			} else {
				getRivalDefenceTower(dataObj as Array);
			}
		}

		/*上下翻页进攻或防守角色*/
		private static function _upDownPagesAllRole(name : String, par : Object, data : Array, type : String, colGap : uint) : void {
			par.dataCurrent = 1;
			var box : Sprite = new Sprite();
			box.name = name;
			var contentMask : Sprite = par.contentMask;
			box.x = contentMask.x;
			box.y = contentMask.y;
			box.mask = contentMask;
			par.addChild(box);
			var len : uint = data.length;
			var _allRole : Vector.<Sprite> = new Vector.<Sprite>(len, true);
			_getAllRole(data, type, _allRole);
			_arrangeAllRole(_allRole, box, 8, colGap, 0);
			par.dataMax = uint(len / 8) + 1;
			if (box.height > contentMask.height) par.down.comp.enabled = true;
		}

		/*获得摆塔布防界面的数据，或者战斗界面摆塔布防数据*/
		public static function getDefence(dataObj : Object) : void {
			if (dataObj.mapInfo == null) {
				if (UICommand.t.stateFirst == UIState.DEFENCE) {
					(UIMain.getInstance(BackgroundLayer.NAME) as BackgroundLayer).addDefenceMap(UICommand.t.mapData.mapId);
					(UICommand.t.ui[UIName.UI_DEFENCE_OPERATION] as Object).dataPaper = 0;
					UICommand.setPaperNum(uint(UIXML.mapXML.maps.(@id == UICommand.t.mapData.mapId).mapPaper[0]), 2);
				}
			} else {
				if (dataObj.mapId != null) UICommand.t.mapData.mapId = dataObj.mapId;
				UICommand.t.mapData.materialId = dataObj.materialId;
				UICommand.t.mapData.mapInfo = dataObj.mapInfo;
				UICommand.t.mapData.towerTech = dataObj.towerTech;
				if (UICommand.t.stateFirst == UIState.WAR_PROGRESS) {
					ApplicationFacade.getInstance().sendNotification(NotificationNameList.SHOW_CHAPTER_INFO, UICommand.t.mapData);
				} else if (UICommand.t.stateFirst == UIState.DEFENCE) {
					if (dataObj.mapPaper == null) dataObj.mapPaper = 1000;
					(UICommand.t.ui[UIName.UI_DEFENCE_OPERATION] as Object).dataPaper = 0;
					UICommand.setPaperNum(dataObj.mapPaper, 2);
					(UIMain.getInstance(BackgroundLayer.NAME) as BackgroundLayer).optionNowDefenceMap(UICommand.t.mapData);
				}
			}
		}

		/*获得分页内容*/
		public static function getPages(par : Object, data : Object, type : String, groupNum : uint, br : uint, colGap : uint, rowGap : uint, w : Number, h : Number, yBy : Number, offsetY : int = 0, numSize : uint = 18, alpha : Number = 1) : void {
			var box : Sprite = new Sprite();
			box.x = par.contentMask.x;
			box.y = par.contentMask.y;
			box.mask = par.contentMask;
			box.name = UIName.E_PAGE + par.numChildren;
			par.addChild(box);
			var num : uint = data.length;
			var ObjClass : Class;
			var obj : Object;
			var indexX : uint = 0;
			var indexY : uint = 0;
			var groupsNum : uint = 1;
			if (num) groupsNum = Math.ceil(num / groupNum);
			var newX : Number;
			var grids : Sprite = new Sprite();
			grids.x = 2;
			grids.y = 2;
			box.addChild(grids);
			var cards : Sprite = new Sprite();
			box.addChild(cards);
			var className : String;
			var instanceName : String;
			var index : uint;
			var level : uint;

			for (var j : uint = 0; j < groupsNum; j++) {
				newX = par.contentMask.width * j;
				if (type == UIState.DOSSIER) {
					for (var i : uint = 0; i < groupNum; i++) {
						ObjClass = UICommand.getClass(UIClass.CARD_GRID);
						obj = new ObjClass();
						obj.alpha = alpha;
						grids.addChild(obj as Sprite);
						indexX = i % br;
						indexY = uint(i / br);
						obj.x = newX + (66 * indexX) + (colGap * 3 * indexX);
						obj.y = (80 * indexY) + (rowGap * yBy * indexY);
					}
				}
				for (var k : uint = 0; k < groupNum; k++) {
					index = k + (j * groupNum);
					if (index < num) {
						if (type == UIName.XML_SOLDIER || type == UIName.XML_TOWER) {
							switch (type) {
								case UIName.XML_SOLDIER:
									className = String(UIXML.soldierXML.soldier.(@id == data[index][0]).name[0]);
									ObjClass = UICommand.getClass(UIClass.CARD_SOLDIER_PREFIX + className);
									instanceName = UIName.XML_SOLDIER + UIName.CHAR_UNDERLINE + className;
									level = data[index][1];
									break;
								case UIName.XML_TOWER:
									className = String(UIXML.towerXML.towerType.(@type == data[index][0]).tower.(@id == data[index][1]).name[0]);
									ObjClass = UICommand.getClass(UIClass.CARD_TOWER_PREFIX + className);
									instanceName = UIName.XML_TOWER + UIName.CHAR_UNDERLINE + className;
									level = data[index][2];
									break;
							}
							obj = new ObjClass();
							iconLevel(obj.getChildAt(1) as Sprite, level);
							obj.removeChild(obj.common);
							obj.dataIndex = index;
							UICommand.convertButtonMode((obj as Sprite));
							obj.name = instanceName;
						} else {
							obj = data[index];
							if (type == UIState.DOSSIER) UICommand.convertButtonMode((obj as Sprite), false);
						}
						indexX = k % br;
						indexY = uint(k / br);
						obj.x = newX + (w * indexX) + (colGap * indexX);
						obj.y = (h * indexY) + (rowGap * indexY);
						cards.addChild(obj as Sprite);
					} else {
						break;
					}
				}
			}
			var y : int = par.prev.y + offsetY;
			pagesNav(groupsNum, par, y, par.prev, par.next, numSize);
		}

		/*分页导航*/
		public static function pagesNav(num : uint, par : Object, y : Number, prev : Sprite, next : Sprite, size : uint, show : Boolean = true) : void {
			var pagesBox : Sprite = new Sprite();
			var numTxt : TextField ;
			var hit : Shape;
			var offset : uint;
			var one : Boolean = true;
			for (var i : uint = 1; i <= num; i++) {
				var btn : Sprite = new Sprite();
				btn.name = UIClass.NUM_PREFIX + i;
				numTxt = UICommand.createTF(TextFormatAlign.LEFT, 0xffffff, size, String(i), UIName.FONT_SHOW_CARD, 0x3B2314);
				btn.addChild(numTxt);
				if (i == 1) {
					numTxt.textColor = 0xF6921E;
					par.dataCurrent = i;
				} else {
					numTxt.textColor = 0x603813;
					btn.x = pagesBox.getChildAt(pagesBox.numChildren - 1).x + 16;
					UICommand.convertButtonMode(btn);
				}
				pagesBox.addChild(btn);
				hit = new Shape();
				hit.graphics.beginFill(0xFFFFFF, 0);
				hit.graphics.drawRect(0, 0, btn.width, btn.height);
				hit.graphics.endFill();
				btn.addChildAt(hit, 0);
			}
			pagesBox.x = (prev as Object).dataX - (pagesBox.width >> 1);
			pagesBox.y = y;
			par.addChild(pagesBox);
			offset = pagesBox.width / num;
			prev.x = pagesBox.x - prev.width - offset;
			next.x = pagesBox.x + pagesBox.width + offset;
			if (num == 1) {
				par.next.comp.enabled = false;
				one = false;
			} else {
				par.next.comp.enabled = true;
			}
			pagesBox.visible = show;
			par.prev.visible = show;
			par.next.visible = show;
		}

		/*初始化滚动条，必须在数据填充完成后*/
		public static function initScroll(className : String, content : Sprite, point : Point, par : Object, shift : uint = 12) : void {
			var ObjClass : Class = UICommand.getClass(className);
			var scroll : Object = new ObjClass();
			scroll.name = className;
			scroll.scrollContent.addChild(content);
			scroll.x = point.x;
			scroll.y = point.y;
			par.addChild(scroll as DisplayObject);
			TweenLite.from(scroll, 0.4, {alpha:0.4});
			scroll.scrollContent.contentArea.height = content.height;
			var baseH : Number = 4 * scroll.scrollMask.height;
			scroll.scrollThumb.addEventListener(MouseEvent.MOUSE_DOWN, UICommand.t.mouseEvent);
			if (content.height > scroll.scrollMask.height && content.height < baseH) scroll.scrollThumb.bg1.height = scroll.scrollThumb.bg2.height = scroll.scrollTrack.height * (baseH - content.height) / baseH;
			UICommand.t.scrollBar = new ScrollBar(UICommand.t.stage, scroll.scrollContent, scroll.scrollMask, scroll.scrollThumb, scroll.scrollTrack);
			UICommand.t.scrollBar.tween = 5;
			UICommand.t.scrollBar.elastic = false;
			UICommand.t.scrollBar.lineAbleClick = true;
			/*不出现滚动条的情况*/
			if (!scroll.scrollThumb.visible) {
				scroll.scrollThumb.shift = shift;
				scroll.x += shift;
			}
		}

		/*添加socket数据加载进度条*/
		public static function addLoading(LoadingSocket : String) : void {
			var ObjClass : Class = UICommand.getClass(LoadingSocket);
			var obj : Object = new ObjClass();
			obj.name = LoadingSocket;
			UICommand.t.stage.addChild(obj as DisplayObject);
			MouseStyleNow.getInstace().changeMouseFlow(obj as Sprite);
		}

		/*创建通用提示框*/
		public static function createTooltips(title : String, info : String, obj : DisplayObject, offsetX : int = 0) : void {
			var ObjClass : Class = UICommand.getClass(UIClass.TIP_COMMON);
			var tip : Object = new ObjClass();
			tip.content.headline.text = title + UIName.CHAR_RETURN_WRAP;
			tip.content.headline.height = 36;
			var offsetY : int = 0;
			if (info) {
				UICommand.addCSSAndContent(tip.content.txt, UICommand.replaceHTML(info) + UIName.CHAR_RETURN_WRAP);
				offsetY += 10;
			} else {
				tip.content.removeChild(tip.content.txt);
				offsetY += 10;
			}
			tip.content.txt.height = tip.content.txt.textHeight;
			tip.tipbg.height = tip.content.height + offsetY;
			_tooltips(obj, tip, UICommand.t.stage, offsetX);
		}

		/*创建军令提示框*/
		public static function createTokenTooltips(target : DisplayObject) : void {
			var string : String = String(UIXML.uiXML.userInfo.tokenInfo.info[0]) + UIName.CHAR_BREAK + String(UIXML.uiXML.userInfo.tokenInfo.info[1]) + UICommand.t.userData[2][6] + String(UIXML.uiXML.phrase.money[0]);
			if (UICommand.t.userData[2][2] != null) {
				UICommand.getTokenRefreshTime();
				var myTimer : Timer = new Timer(1000);
				myTimer.addEventListener(TimerEvent.TIMER, UICommand.t.tokenTimerHandler);
				myTimer.start();
				UICommand.t.userData[2][5] = myTimer;
				string += UIName.CHAR_BREAK + String(UIXML.uiXML.userInfo.tokenInfo.info[2]) + UIName.CHAR_BREAK + String(UIXML.uiXML.phrase.countdown[0]) + UICommand.countdownRefresh(UICommand.t.userData[2][3], UICommand.t.userData[2][4]);
			}
			createTooltips(String(UIXML.uiXML.phrase.token[0]), string, target);
		}

		/*创建派兵界面提示框*/
		public static function createHSTooltips(target : Object) : void {
			var ObjClass : Class;
			var tip : Object;
			var good : Sprite;
			var xmlList : XMLList;
			if (target.name.indexOf(UIName.XML_HERO + UIName.CHAR_UNDERLINE) != -1) {
				if (target.dataPower != 0) {
					ObjClass = UICommand.getClass(UIClass.TIP_HERO);
					tip = new ObjClass();
					tip.content.headline.text = target.dataLangName + UIName.CHAR_RETURN_WRAP;
					tip.content.headline.height = 36;
					tip.content.level.text = String(UIXML.uiXML.phrase.level[0]) + String(UIXML.uiXML.mark.colon[0]) + target.dataLevel;
					tip.content.titleSkill.text = String(UIXML.uiXML.phrase.skill[0]) + String(UIXML.uiXML.mark.colon[0]);
					xmlList = UIXML.heroSkillXML.heroSkills.(@id == target.dataSkillID);
					good = UICommand.getInstance(String(xmlList.name[0]));

					good.width = good.height = 22;
					tip.content.skill.addChild(good);
					tip.content.skill.txt.text = String(xmlList.skillsName[0]);
					tip.content.titleGem.text = String(UIXML.uiXML.phrase.gem[0]) + String(UIXML.uiXML.mark.colon[0]);
					if (target.dataGemID == null) {
						tip.content.gem.txt.text = String(UIXML.uiXML.phrase.nothing[0]);
						tip.content.gem.txt.x = tip.content.gem.txt.y = 0;
					} else {
						xmlList = UIXML.gemXML.gem.(@id == target.dataGemID);
						good = UICommand.getInstance(String(xmlList.name[0]));
						good.width = good.height = 22;
						tip.content.gem.addChild(good);
						tip.content.gem.txt.text = String(xmlList.langName[0]);
					}
					tip.tipbg.height = tip.content.height + 16;
					_tooltips(target as DisplayObject, tip, UICommand.t.stage);
				} else {
					createTooltips(String(UIXML.uiXML.heroPower.info[0]), "", target as DisplayObject);
				}
			} else if (target.name.indexOf(UIName.XML_SOLDIER + UIName.CHAR_UNDERLINE) != -1) {
				createTooltips(target.dataLangName, target.dataInfo, target as DisplayObject);
			}
		}

		/*提示框*/
		private static function _tooltips(obj : DisplayObject, tip : Object, par : DisplayObjectContainer, offsetX : int = 0) : void {
			tip.tipArrow.x = tip.tipArrow.y = 0;
			var stageHitPoint : Point = obj.localToGlobal(new Point(0, 0));
			stageHitPoint.x += offsetX;
			var w : Number = obj.width;
			if (obj.name == UIClass.CARD_HERO_SKILL || (obj as Sprite).getChildByName(UIClass.CARD_CD_ANIMATION)) w = 70;
			tip.tipArrow.y = tip.tipbg.y + tip.tipbg.height - 1;
			if (tip.width > w) {
				tip.x = stageHitPoint.x - ((tip.width - w) >> 1);
			} else {
				tip.x = stageHitPoint.x + ((w - tip.width) >> 1);
			}
			if (tip.x < 0) {
				tip.x = 0;
			} else if ((tip.x + tip.width) > GlobalVariable.STAGE_WIDTH) {
				tip.x = tip.x - ((tip.x + tip.width) - GlobalVariable.STAGE_WIDTH);
			}
			tip.y = stageHitPoint.y - tip.height;
			if (tip.y < 0) {
				tip.tipArrow.scaleY = -1;
				tip.tipArrow.y = tip.tipbg.y + 1;
				tip.y = stageHitPoint.y + obj.height + tip.tipArrow.height - 2;
			} else if ((tip.y + tip.height) > GlobalVariable.STAGE_HEIGHT) {
				tip.y = GlobalVariable.STAGE_HEIGHT - tip.height;
			}
			var tipArrowPoint : Point = tip.globalToLocal(new Point(stageHitPoint.x + (w >> 1) - (tip.tipArrow.width >> 1), 0));
			tip.tipArrow.x = tipArrowPoint.x;
			par.addChild(tip as DisplayObject);
			TweenLite.from(tip, 0.4, {alpha:0});
		}

		/*创建弹出框*/
		private static function _createPopup(className : String, state : String = "", dataObj : Object = null) : Object {
			if (state == UIState.SOCKET) {
				addShield({par:UICommand.t.stage});
			} else {
				addShield();
			}
			var ObjClass : Class = UICommand.getClass(className);
			var obj : Object = new ObjClass();
			obj.name = className + state + UICommand.t.numChildren;
			if (state) obj.state = state;
			if (dataObj != null) obj.dataObj = dataObj;
			return obj;
		}

		/*弹出框添加内容后执行*/
		private static function _addPopup(obj : Object, par : DisplayObjectContainer = null) : void {
			var offsetX : Number = obj.width >> 1;
			var offsetY : Number = (obj.height >> 1);
			UICommand.centered(obj as DisplayObject, GlobalVariable.STAGE_WIDTH, GlobalVariable.STAGE_HEIGHT, offsetX, offsetY);
			if (par == null) par = UICommand.t;
			par.addChild(obj as DisplayObject);
			TweenLite.from(obj, 0.6, {y:"600", ease:Back.easeInOut, onComplete:_addPopupTC, onCompleteParams:[obj]});
			obj.addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			obj.addEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			obj.addEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
		}

		/*弹出框添加内容后动画*/
		private static function _addPopupTC(obj : Object) : void {
			switch (obj.state) {
				case UIState.RESULTS:
					var data : Object = obj.dataObj[1];
					var content : Object = obj.content1;
					setAttackAppraise(content, [[data.dataWarTime, data.dataWarScoreTime], [data.dataWarScorePercent, data.dataWarScorePaper], [data.dataResults, data.dataResultScore], data.dataWarScore]);
					var className : String = UIClass.POPUP_PREFIX + UIName.E_APPRAISE + data.dataWarLevel;
					var appraise : MovieClip = UICommand.getInstance(className) as MovieClip;
					appraise.gotoAndStop(1);
					content.position.addChild(appraise);
					var time : Number;
					switch (data.dataWarLevel) {
						case "S":
							time = 3 * 0.6;
							break;
						case "A":
							time = 2 * 0.6;
							break;
						case "B":
							time = 0.6;
							break;
						case "C":
							time = 0.2;
							break;
					}
					UITransition.resultsTween(appraise, time, obj.content2);
					break;
			}
		}

		/*通用弹出框*/
		public static function popupPrompt(txt : String, state : String = "", submit : Boolean = false, dataObj : Object = null) : void {
			var obj : Object = _createPopup(UIClass.POPUP_PROMPT, state, dataObj);
			var content : Object = obj.content;
			UICommand.addCSSAndContent(content.txt, UICommand.replaceHTML(txt) + UIName.CHAR_RETURN_WRAP);
			content.txt.height = content.txt.textHeight;
			var bg : Object = obj.bg;
			if (submit) {
				var btn : Sprite = content.submit;
				if (state == UIState.RECHARGE) {
					content.submit.txt.text = String(UIXML.uiXML.phrase.recharge[0]);
				} else if (state == UIState.SAVE_MAP) {
					content.submit.txt.text = String(UIXML.uiXML.phrase.tease[0]);
				}
				btn.y = content.txt.y + content.txt.height + 20;
				bg.height = btn.y + btn.height + 80;
			} else {
				content.removeChild(content.submit);
				bg.height = content.txt.y + content.txt.height + 80;
			}
			obj.close.y = obj.bg.height - obj.close.height - 16;
			var par : DisplayObjectContainer = UICommand.t;
			if (state == UIState.SOCKET) {
				obj.close.txt.text = String(UIXML.uiXML.phrase.reconnect[0]);
				par = UICommand.t.stage;
			}
			_addPopup(obj, par);
		}

		/*用户设置弹出框*/
		public static function popupSet() : void {
			var obj : Object = _createPopup(UIClass.POPUP_SET, UIState.SET);
			var content : Object = obj.content;
			content.music.selected.visible = UICommand.t.userData[1][7];
			content.music.txt.text = String(UIXML.uiXML.phrase.music[0]);
			content.music.txt.width = content.music.txt.textWidth + 4;
			content.music.txt.height = content.music.txt.textHeight + 4;
			UICommand.convertButtonMode(content.music);
			content.soundEffect.selected.visible = UICommand.t.userData[1][8];
			content.soundEffect.txt.text = String(UIXML.uiXML.phrase.soundEffect[0]);
			content.soundEffect.txt.width = content.soundEffect.txt.textWidth + 4;
			content.soundEffect.txt.height = content.soundEffect.txt.textHeight + 4;
			UICommand.convertButtonMode(content.soundEffect);
			content.grid.selected.visible = UICommand.t.userData[1][9];
			content.grid.txt.text = String(UIXML.uiXML.phrase.grid[0]);
			content.grid.txt.width = content.grid.txt.textWidth + 4;
			content.grid.txt.height = content.grid.txt.textHeight + 4;
			UICommand.convertButtonMode(content.grid);
			content.HP.selected.visible = UICommand.t.userData[1][10];
			content.HP.txt.text = String(UIXML.uiXML.phrase.HP[0]);
			content.HP.txt.width = content.HP.txt.textWidth + 4;
			content.HP.txt.height = content.HP.txt.textHeight + 4;
			UICommand.convertButtonMode(content.HP);
			var xmlList : XMLList = UIXML.uiXML.phrase;
			if (UICommand.t.stateFirst == UIState.WAR_PROGRESS) {
				content.submit.txt.text = String(xmlList.exit[0]) + String(xmlList.fight[0]);
				(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).pauseGame();
				if (UICommand.t.warTimer) {
					UICommand.heroSkillCDPlayOPause(false);
					UITransition.animationGreenSock(UICommand.t.timelineLites, 0);
				}
				// UICommand.pauseProgress();
			} else {
				content.HP.visible = false;
				if (UICommand.t.stateFirst == UIState.DEFENCE) {
					content.submit.txt.text = String(xmlList.exit[0]) + String(xmlList.defence[0]);
				} else {
					content.grid.visible = false;
					content.submit.visible = false;
				}
			}
			_addPopup(obj);
		}

		/*升级弹出框*/
		public static function popupLevel() : void {
			var sp : LevelLayer = new LevelLayer();
			sp.showLevel(UIClass.POPUP_LEVEL, UICommand.t.userData[1][2]);
			var i : uint = UICommand.t.stage.numChildren;
			if (UICommand.t.stage.getChildByName(UIClass.LOADING_SOCKET)) i = UICommand.t.stage.numChildren - 1;
			addShield({par:UICommand.t.stage, index:i});
			UICommand.t.stage.addChildAt(sp as Sprite, i + 1);
			TweenLite.from(sp, 0.6, {y:"600", ease:Back.easeInOut});
			sp.addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			sp.addEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			sp.addEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
		}

		/*战斗结果弹出框*/
		public static function popupResults(lose : Boolean = false, surrender : Boolean = false) : void {
			var option : OptionMainLayer = UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer;
			option.pauseGame();
			UITransition.animationGreenSock(UICommand.t.timelineLites, 0);
			var dataUserGive : Object = option.getWarScoreAttack(!lose, [UICommand.t.userData[1][2], UICommand.t.selectedRivalData[2]], surrender);
			var data : Array;
			var f : Boolean = false;
			if (UICommand.t.stateSecond == UIState.FRIEND) f = true;
			var dataRivalGive : Object = option.getWarScoreDefence(lose, [UICommand.t.userData[1][2], UICommand.t.selectedRivalData[2]], !surrender);
			var dataPlayback : Object = option.getAttackData();
			var dataRival : Array = [UICommand.t.selectedRivalData[0], dataRivalGive, dataPlayback];
			data = [f, dataUserGive, dataRival, lose];
			var obj : Object = _createPopup(UIClass.POPUP_RESULTS, UIState.RESULTS, data);
			var bg : Sprite;
			if (lose) {
				obj.win.visible = false;
				obj.winNumBG.visible = false;
				obj.winBG.visible = false;
				bg = obj.loseBG;
				obj.lose.txt.text = String(UIXML.uiXML.warResults.lose1[0]) + UICommand.t.selectedRivalData[1] + String(UIXML.uiXML.warResults.lose2[0]);
			} else {
				obj.lose.visible = false;
				obj.loseNumBG.visible = false;
				obj.loseBG.visible = false;
				bg = obj.winBG;
				obj.win.txt.text = String(UIXML.uiXML.warResults.win1[0]) + UICommand.t.selectedRivalData[1] + String(UIXML.uiXML.warResults.win2[0]);
			}
			if (UICommand.t.stateSecond == UIState.TEST_MAP) {
				// || UICommand.t.stateSecond == UIState.PVE
				obj.lose.txt.visible = false;
				obj.win.txt.visible = false;
			}
			var content : Object = obj.content2;
			var close : Object = obj.close;
			if (UICommand.t.stateSecond == UIState.TEST_MAP || UICommand.t.stateSecond == UIState.FRIEND) {
				content.visible = false;
				bg.height -= 66;
				close.y -= 66;
			} else if (UICommand.t.stateSecond == "" && dataUserGive.dataItemSum != 0) {
				close.txt.text = String(UIXML.uiXML.phrase.lottery[0]);
			}
			var again : Sprite = obj.again;
			again.visible = false;
			again.y = bg.y + bg.height - again.height;
			setAttackAppraise(obj.content1);
			if (content.visible) {
				content.langRewardTitle.text = String(UIXML.uiXML.phrase.reward[0]);
				content.langExperience.txt.text = "0";
				content.langCap.text = "0";
			}
			close.comp.enabled = false;
			_addPopup(obj);
			if (UICommand.t.warTimer != null) {
				UICommand.t.warTimer.stop();
				UICommand.t.warTimer.removeEventListener(TimerEvent.TIMER, UICommand.t.warTimerHandler);
				UICommand.t.warTimer = null;
			}
		}

		/*进攻评价内容*/
		public static function setAttackAppraise(content : Object, data : Array = null) : void {
			var xmlList : XMLList = UIXML.uiXML.warResults.appraise;
			var tips : Array = [content.time, content.spoilage, content.outcome];
			var i : uint = 0;
			var childData : Array;
			if (data == null) {
				content.langAppraiseTitle.text = String(UIXML.uiXML.phrase.appraise[0]);
				for (i = 0; i < 3; i++) {
					tips[i].mouseChildren = false;
					tips[i].dataInfo = String(xmlList.info[i]);
					tips[i].langTitle.text = String(xmlList.title[i]);
					tips[i].langContent.text = "";
					tips[i].langScore.text = "";
				}
				content.langScoreTitle.text = String(UIXML.uiXML.phrase.total[0]);
				content.langScore.text = "";
			} else {
				for (i = 0; i < 3; i++) {
					childData = data[i];
					if (i) {
						tips[i].langContent.text = childData[0];
					} else {
						tips[i].langContent.text = UICommand.formatTime(null, childData[0] % 60, uint(childData[0] / 60));
					}
					tips[i].langScore.text = childData[1];
				}
				content.langScore.text = data[3];
			}
		}

		/*布防评价内容*/
		public static function setDefenceAppraise(content : Object, data : Array = null) : void {
			if (data == null) {
				content.langAppraiseTitle.text = String(UIXML.uiXML.phrase.appraise[0]);
				content.langScoreTitle.text = String(UIXML.uiXML.phrase.score[0]);
				content.langTimeTitle.text = String(UIXML.uiXML.phrase.time[0]);
				content.langConsumeTitle.text = String(UIXML.uiXML.phrase.consume[0]);
				content.langHardTitle.text = String(UIXML.uiXML.phrase.hardExtent[0]);
				content.langScore.text = "0";
				content.langTime.text = "0";
				content.langConsume.text = "0";
				content.langHard.text = "";
			} else {
				content.langAppraise.text = data[0];
				content.langScore.text = data[1];
				content.langTime.text = data[2];
				content.langConsume.text = data[3];
				var s : String;
				if (data[4]) {
					s = String(UIXML.uiXML.phrase.hard[0]);
				} else {
					s = String(UIXML.uiXML.phrase.easy[0]);
				}
				content.langHard.text = s;
			}
		}

		/*详细评价弹出框*/
		public static function popupAppraise(reportID : String) : void {
			var obj : Object = _createPopup(UIClass.POPUP_APPRAISE);
			setDefenceAppraise(obj);
			_addPopup(obj);
			UICommand.uiDataTransfer([{m:UIDataFunList.GET_APPRAISE, a:[UICommand.t.userData[0], reportID]}]);
		}

		/*获得评价*/
		public static function getAppraise(dataObj : Object) : void {
			var data : Array = dataObj as Array;
			var obj : Object = UICommand.t.getChildAt(UICommand.t.numChildren - 1);
			setDefenceAppraise(obj, data);
		}

		/*领取奖励弹出框*/
		public static function popupReward(report : Object) : void {
			var obj : Object = _createPopup(UIClass.POPUP_REWARD, UIState.REWARD, report);
			obj.content.otherLine.visible = false;
			obj.content.goodsLine.visible = false;
			_addPopup(obj);
			UICommand.uiDataTransfer([{m:UIDataFunList.GET_REWARD, a:[UICommand.t.userData[0], report.dataID]}]);
		}

		/*获得奖励*/
		public static function getReward(dataObj : Object) : void {
			var data : Array = dataObj as Array;
			var len : uint = data.length;
			var ohterData : Array = [];
			for (var i : int = len - 1; i > -1; i--) {
				if (data[i][0] < 1000) {
					ohterData[ohterData.length] = data[i];
					data.splice(i, 1);
				}
			}
			var obj : Object = UICommand.t.getChildAt(UICommand.t.numChildren - 1);
			var content : Object = obj.content;
			var otherLine : Object = obj.content.otherLine;
			var goodsLine : Object = obj.content.goodsLine;
			otherLine.visible = true;
			goodsLine.visible = true;
			if (ohterData.length == 0) {
				goodsLine.y = otherLine.y;
				content.removeChildAt(2);
			} else {
				getGoods(ohterData, otherLine.box, 0, true);
				otherLine.box.x = (otherLine.width >> 1) - (otherLine.box.width >> 1);
			}
			if (data.length == 0) {
				content.submit.y = goodsLine.y;
				content.removeChildAt(1);
			} else {
				getGoods(data, goodsLine.box, 0, true);
				goodsLine.box.x = (goodsLine.width >> 1) - (goodsLine.box.width >> 1);
				var isFalse : Function = function(element : *, index : int, arr : Array) : Boolean {
					return (element[2] == false);
				};
				var tips : Array = data.filter(isFalse);
				if (tips.length) UICommand.addEasyHit(content.submit, UICommand.rewardResult(tips, true));
			}
			obj.bg.height = content.submit.y + content.submit.height + 80;
			obj.close.y = obj.bg.height - obj.close.height - 16;
		}

		/*活动大礼包弹出框*/
		public static function popupGiftSelect(data : Array) : void {
			var obj : Object = _createPopup(UIClass.POPUP_LOTTERY, UIState.GIFT);
			obj.langTitle1.visible = false;
			obj.num.visible = false;
			obj.langTitle2.visible = false;
			obj.lottery.visible = false;
			obj.submit.comp.enabled = false;
			var len : uint = data.length;
			var className : String;
			var hero : Sprite;
			var child : Object;
			for (var i : uint = 0; i < 9; i++) {
				if (i < len) {
					className = UIClass.ICON_PREFIX + String(UIXML.heroXML.hero.(@id == data[i][0][1]).name[0]);
					hero = UICommand.getInstance(className);
					child = obj.box.getChildAt(i);
					child.dataGift = data[i][0][0];
					child.icon.addChild(hero);
					UICommand.convertButtonMode(child as Sprite);
				} else {
					obj.box.removeChildAt(len);
					obj.bg.removeChildAt(len);
				}
			}
			obj.submit.y = obj.bg.y + obj.bg.height + 24;
			obj.bg0.height = obj.submit.y + obj.submit.height + 14;
			_addPopup(obj);
		}

		/*抽奖弹出框*/
		public static function popupLottery(dataObj : Object) : void {
			var obj : Object = _createPopup(UIClass.POPUP_LOTTERY, UIState.LOTTERY, dataObj);
			obj.langTitle1.text = String(UIXML.uiXML.lottery.info1[0]);
			var num : uint = dataObj.dataItemSum;
			obj.num.txt.text = num;
			obj.langTitle2.text = String(UIXML.uiXML.lottery.info2[0]);
			var child : Object;
			for (var i : uint = 0; i < 9; i++) {
				child = obj.lottery.getChildAt(i);
				UICommand.convertButtonMode(child as Sprite);
			}
			obj.submit.comp.enabled = false;
			UICommand.addEasyHit(obj.submit, "", true);
			var buffSum : uint = dataObj.dataBuffItemSum;
			if (buffSum) {
				obj.num.txt.textColor = 0xFF0000;
				UICommand.addEasyHit(obj.num, String(UIXML.uiXML.warResults.buff.info[1]).replace(UIName.VAR_A, dataObj.dataBuffItemSumName).replace(UIName.VAR_B, buffSum), true);
			}
			_addPopup(obj);
			UICommand.uiDataTransfer([{m:UIDataFunList.GET_LOTTERY, a:[UICommand.t.userData[0], UICommand.t.mapData.mapId]}]);
		}

		/*抽奖弹出框内容*/
		public static function getLottery(dataObj : Object) : void {
			var data : Array = dataObj as Array;
			var obj : Object = UICommand.t.getChildAt(UICommand.t.numChildren - 1);
			var save : Array = [data[0], [], null];
			obj.dataObj.dataSave = save;
			if (data[1]) obj.dataGoods = getGoods(data[1] as Array, obj.box, obj.dataObj.dataItemSum);
			var warLevel : String = obj.dataObj.dataWarLevel;
			if (warLevel == "S") {
				UICommand.t.apiData = [UIName.JS_FEED, 104];
				if (ExternalInterface.available) ExternalInterface.call(UIName.JS_FEED, UICommand.getAPI().replace(UIName.API_RIVAL, UICommand.t.selectedRivalData[1]).replace(UIName.API_APPRAISE, warLevel), UICommand.getAPIRedirect());
			}
		}

		/*获得奖励物品和地图掉落物品*/
		public static function getGoods(data : Array, obj : Sprite, sum : uint = 0, remove : Boolean = false) : Array {
			var parlen : uint = obj.numChildren;
			var index : uint;
			var num : int;
			var xmlList : XMLList;
			var className : String;
			var langName : String;
			var info : String = "";
			var ObjClass : Class;
			var sp : Sprite;
			var par : Object;
			var numTxt : TextField;
			var dataLen : uint = data.length;
			var goods : Array = [];
			var goodsid : uint;
			for (var i : int = parlen - 1; i > -1; i--) {
				par = obj.getChildAt(i);
				if (i < dataLen) {
					goodsid = data[i][0];
					if (goodsid > 1000) {
						num = uint(String(data[i][0]).substr(0, 2));
						switch (num) {
							case 16 :
								xmlList = UIXML.propXML.prop.(@id == data[i][0]);
								break;
							case 17 :
								xmlList = UIXML.materialXML.material.(@id == data[i][0]);
								break;
							default	:
								if (num < 16) {
									xmlList = UIXML.equipmentXML.equipCategory.equip.(@id == data[i][0]);
								} else {
									xmlList = UIXML.gemXML.gem.(@id == data[i][0]);
								}
								break;
						}
						className = String(xmlList.name[0]);
						langName = String(xmlList.langName[0]);
						info = String(xmlList.info[0]);
					} else {
						switch (goodsid) {
							case 97 :
								langName = data[i][1] + String(UIXML.uiXML.phrase.money[0]);
								className = UIClass.ICON_RING;
								index = 0;
								break;
							case 98 :
								langName = data[i][1] + String(UIXML.uiXML.phrase.cap[0]);
								className = UIClass.ICON_CAP;
								index = 1;
								break;
							case 99 :
								langName = data[i][1] + String(UIXML.uiXML.phrase.experience[0]);
								className = UIClass.ICON_EXPERIENCE;
								index = 2;
								break;
						}
					}
					if (sum == 0 && parlen == 3) {
						for (var j : uint = 0; j < 3; j++) {
							if (j == index) {
								par.getChildAt(j).visible = true;
							} else {
								par.getChildAt(j).visible = false;
							}
						}
						par.getChildAt(3).text = data[i][1];
					} else {
						sp = UICommand.getInstance(className);
						par.data = data[i];
						par.dataLangName = langName;
						par.dataInfo = info;
						sp.x = sp.y = 1;
						if (par.icon) {
							numTxt = UICommand.createTF(TextFormatAlign.RIGHT, 0xffffff, 12, "X" + data[i][1], UIName.FONT_SHOW_CARD);
							numTxt.x = sp.width - numTxt.width;
							numTxt.y = sp.height - 16;
							sp.addChild(numTxt);
							par.icon.addChild(sp);
						} else {
							if (par.numChildren == 2) par.removeChildAt(1);
							par.addChild(sp);
						}
						par.mouseChildren = false;
						if (sum) {
							par.visible = false;
							TweenLite.to(par, 0, {transformMatrix:{skewY:90}});
							if (i < sum) goods[goods.length] = par;
						} else if (par.txt) {
							par.txt.text = langName;
						}
					}
				} else {
					if (remove) {
						obj.removeChildAt(i);
					} else if (par.numChildren == 2) {
						par.removeChildAt(1);
					}
				}
			}
			return goods;
		}

		/*军令牌弹出框*/
		public static function popupToken(add : String = "") : void {
			var obj : Object = _createPopup(UIClass.POPUP_TOKEN, UIState.TOKEN);
			var content : Object = obj.content;
			content.txt1.text = String(UIXML.uiXML.userInfo.tokenInfo.info[1]);
			content.txt2.text = String(UICommand.t.userData[2][6]);
			content.txt.text = add;
			_addPopup(obj);
		}

		/*输入数字弹出框*/
		public static function popupNum(state : String, dataObj : Object = null) : void {
			var obj : Object = _createPopup(UIClass.POPUP_NUM, state, dataObj);
			var content : Object = obj.content;
			var v : Object = content.validation;
			v.dataWidth = v.txt.width;
			v.visible = false;
			var className : String = dataObj == null ? UICommand.t.selectedItems[0] : dataObj.dataClassName;
			var ObjClass : Class = UICommand.getClass(className);
			var sp : Sprite = new ObjClass();
			sp.x = sp.y = 1;
			content.icon.addChild(sp);
			content.txt1.text = dataObj == null ? UICommand.t.selectedItems[5] : dataObj.dataLangName;
			content.txt2.text = String(UIXML.uiXML.phrase.amount);
			var num : Object = content.num;
			num.text = String(1);
			_addPopup(obj);
			// num.addEventListener(TextEvent.TEXT_INPUT, UICommand.t.inputNumHandler);
			num.addEventListener(FocusEvent.FOCUS_IN, UICommand.t.inputNumfocusInHandler);
			num.addEventListener(FocusEvent.FOCUS_OUT, UICommand.t.inputNumfocusOutHandler);
			num.addEventListener(Event.CHANGE, UICommand.t.changeNumHandler);
			switch (state) {
				case UIState.SHOP_CAP:
					content.txt3.text = String(UIXML.uiXML.phrase.need);
					content.cap.visible = true;
					content.money.visible = false;
					content.num1.text = String(dataObj.dataCap);
					// num.addEventListener(Event.CHANGE, UICommand.t.changeNumShopCap);
					break;
				case UIState.SHOP_MONEY:
					content.txt3.text = String(UIXML.uiXML.phrase.need);
					content.cap.visible = false;
					content.money.visible = true;
					content.num1.text = String(dataObj.dataMoney);
					// num.addEventListener(Event.CHANGE, UICommand.t.changeNumShopRing);
					break;
				case UIState.SALE_GOODS:
					content.txt3.text = String(UIXML.uiXML.phrase.revenue);
					content.cap.visible = true;
					content.money.visible = false;
					content.num1.text = String(UICommand.t.selectedItems[3]);
					break;
			}
		}

		/*添加物品图标*/
		public static function addGoodsIcon(par : Object, data : Array) : void {
			var ObjClass : Object = UICommand.getClass(data[0]);
			var grid : Object = new ObjClass();
			grid.x = grid.y = 1;
			par.addChild(grid as DisplayObject);
			grid.dataLangName = data[1];
			grid.dataInfo = data[2];
		}

		/*添加小按钮*/
		public static function addSmallBTN(par : Sprite, className : String, x : Number, y : Number, index : int = -1) : void {
			var i : uint;
			var ObjClass : Class = UICommand.getClass(className);
			var btn : Sprite = new ObjClass();
			// if (par.parent.name != UIName.PRESENT_HAD_HERO) if (btn.width > 25) btn.width = btn.height = 25;
			if (index == -1) {
				i = par.numChildren;
				btn.x = x - (btn.width >> 1);
				btn.y = y - (btn.height >> 1);
			} else {
				i = index;
				btn.x = x;
				btn.y = y;
			}
			UICommand.convertButtonMode(btn);
			par.addChildAt(btn, i);
			TweenLite.from(btn, 0.2, {alpha:0});
		}

		/*添加背景遮罩*/
		public static function addSubstrate(index : uint = 0, alpha : Number = 1) : void {
			var ObjClass : Class = UICommand.getClass(UIClass.SUBSTRATE);
			var obj : Sprite = new ObjClass();
			obj.width = GlobalVariable.STAGE_WIDTH;
			obj.height = GlobalVariable.STAGE_HEIGHT;
			UICommand.t.addChildAt(obj, index);
			obj.alpha = alpha;
			TweenLite.from(obj, 0.4, {alpha:0.4});
		}

		/*添加引导高亮*/
		public static function addGuideHighlight(focus : Sprite, data : String, click : Boolean = true) : void {
			addShield({alpha:0.3});
			UICommand.t.gameGuideData[1] = [focus.x, focus.y, focus.parent, focus.parent.getChildIndex(focus), UICommand.t.getChildAt(UICommand.t.numChildren - 1)];
			var point : Point = focus.localToGlobal(new Point(0, 0));
			// if (two) focus.getChildAt(0).visible = false;
			if ((focus as Object).dataX != null) {
				focus.x = (focus as Object).dataX;
			} else {
				focus.x = point.x;
			}
			if ((focus as Object).dataY != null) {
				focus.y = (focus as Object).dataY;
			} else {
				focus.y = point.y;
			}
			var sp : Sprite = new Sprite();
			sp.name = UIName.E_GUIDE + focus.name;
			sp.addChild(focus);
			UICommand.t.addChild(sp);
			UICommand.t.gameGuideData[1].push(focus);
			// UICommand.convertButtonMode(sp);
			if (click) {
				sp.addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent, true);
			} else {
				sp.addEventListener(MouseEvent.MOUSE_UP, UICommand.t.mouseEvent, true);
			}
			sp.addEventListener(MouseEvent.ROLL_OVER, UICommand.t.mouseEvent);
			sp.addEventListener(MouseEvent.ROLL_OUT, UICommand.t.mouseEvent);
			addNPCTip(focus, data, UICommand.t);
			UICommand.t.gameGuideData[1].push(UICommand.t.getChildAt(UICommand.t.numChildren - 1));
		}

		/*添加弹出框遮罩*/
		public static function addShield(vars : Object = null) : void {
			var ObjClass : Class = UICommand.getClass(UIClass.SHIELD);
			var obj : Sprite = new ObjClass();
			if (!vars) vars = {};
			var alpha : Number = vars.alpha == null ? 0.5 : vars.alpha;
			var duration : Number = vars.duration == null ? 0.4 : vars.duration;
			var par : DisplayObjectContainer = vars.par == null ? UICommand.t : vars.par;
			if (vars.index == null) {
				par.addChild(obj as DisplayObject);
			} else {
				par.addChildAt(obj as DisplayObject, vars.index);
			}
			obj.alpha = alpha;
			TweenLite.from(obj as DisplayObject, duration, {alpha:0});
		}

		/*添加NPC剧情*/
		public static function addNPCPrompt(data : XMLList, className : String = "") : void {
			var b : Boolean;
			if (className == "") {
				className = UIClass.NPC_PROMPT;
				b = true;
			}
			var ObjClass : Class = UICommand.getClass(className);
			var obj : Object = new ObjClass();
			obj.name = className;
			obj.txt.text = String(data[0]);
			if (b) {
				obj.dataIndex = 0;
				obj.dataList = data;
				var len : uint = data.length();
				if (len == 1) obj.next.visible = false;
				addShield({alpha:0.2});
				obj.addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
				obj.addEventListener(MouseEvent.ROLL_OVER, UICommand.t.mouseEvent);
				obj.addEventListener(MouseEvent.ROLL_OUT, UICommand.t.mouseEvent);
				TweenLite.from(obj, 0.4, {y:"220"});
			}
			UICommand.t.addChild(obj as Sprite);
		}

		/*添加NPCTIP*/
		public static function addNPCTip(content : DisplayObject, data : String, tipBox : DisplayObjectContainer, name : String = "") : void {
			var ObjClass : Class = UICommand.getClass(UIClass.NPC_TIP);
			var obj : Object = new ObjClass();
			var iName : String = name == "" ? content.name : name;
			obj.name = UIClass.NPC_TIP + iName;
			obj.dataWidth = obj.txt.width;
			obj.txt.text = data + UIName.CHAR_RETURN_WRAP;
			UICommand.changeNPCTipBG(obj);
			_tooltips(content, obj, tipBox);
		}
	}
}
