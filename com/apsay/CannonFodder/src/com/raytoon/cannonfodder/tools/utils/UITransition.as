package com.raytoon.cannonfodder.tools.utils {
	import com.greensock.TimelineLite;
	import com.greensock.TweenAlign;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Sine;
	import com.raytoon.cannonfodder.puremvc.ApplicationFacade;
	import com.raytoon.cannonfodder.puremvc.view.ui.UIMain;
	import com.raytoon.cannonfodder.puremvc.view.ui.backgroundLayer.BackgroundLayer;
	import com.raytoon.cannonfodder.puremvc.view.ui.birdLayer.BirdLayer;
	import com.raytoon.cannonfodder.puremvc.view.ui.optionMainLayer.OptionMainLayer;
	import com.raytoon.cannonfodder.puremvc.view.ui.sheepLayer.SheepLayer;
	import com.raytoon.cannonfodder.puremvc.view.ui.soundLayer.SoundLayer;
	import com.raytoon.cannonfodder.puremvc.view.ui.techTreeLayer.TechTreeLayer;
	import com.raytoon.cannonfodder.puremvc.view.ui.toolsLayer.element.CloudLayer;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;

	/**
	 * @author Administrator
	 */
	public class UITransition {
		/*进入开始界面*/
		public static function inStart(init : Boolean = false) : void {
			UICommand.t.stateFirst = UIState.START;
			if (init) {
				/*添加主音乐*/
				(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playMusic(SoundName.SOUND_BACKGROUND);

				/*添加中间按钮*/
				UICommand.t.addChildAt(UICommand.t.ui[UIName.UI_MAIN_NAV], 0);
				TweenLite.from(UICommand.t.ui[UIName.UI_MAIN_NAV], 0.4, {alpha:0, delay:0.2});

				/*添加鸟和羊*/
				UICommand.t.addChildAt(UIMain.getInstance(BirdLayer.NAME) as BirdLayer, 1);
				(UIMain.getInstance(BirdLayer.NAME) as BirdLayer).showBirds();
				(UIMain.getInstance(SheepLayer.NAME) as SheepLayer).showSheeps();

				/*添加好友栏UI，并添加事件*/
				UICommand.t.addChildAt(UICommand.t.ui[UIName.UI_FRIEND], 2);
				(UICommand.t.ui[UIName.UI_FRIEND] as Object).close.visible = false;
				TweenLite.from(UICommand.t.ui[UIName.UI_FRIEND], 0.4, {alpha:0, delay:0.2});

				/*添加开始界面下栏UI，并添加事件*/
				UICommand.t.addChildAt(UICommand.t.ui[UIName.UI_SECONDARY_NAV], 3);
				TweenLite.from(UICommand.t.ui[UIName.UI_SECONDARY_NAV], 0.4, {alpha:0, delay:0.2});

				/*添加开始界面地图*/
				(UIMain.getInstance(BackgroundLayer.NAME) as BackgroundLayer).addBackground();
			} else {
				var data : Array = [{m:UIDataFunList.GET_SERVER_TIME, a:[UICommand.t.userData[0]], noLoading:true}, {m:UIDataFunList.GET_TASK, a:[UICommand.t.userData[0]], noLoading:true}];
				if (UICommand.t.userData[3][2] != null) data[data.length] = {m:UIDataFunList.GET_EVENT_TASKS, a:[UICommand.t.userData[0]], noLoading:true};
				UICommand.uiDataTransfer(data);
			}
			if (UICommand.t.serverTimeTimer == null) UICommand.addSyncServerTimeTimer();
			(UIMain.getInstance(SheepLayer.NAME) as SheepLayer).sheepSoundOnAndOff(true);
			var nav : Object = (UICommand.t.ui[UIName.UI_MAIN_NAV] as Object).nav;
			nav.addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			nav.addEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			nav.addEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_FRIEND].addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_SECONDARY_NAV].addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_SECONDARY_NAV].addEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_SECONDARY_NAV].addEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
			/*添加开始界面中间按钮，并添加事件*/
			UICommand.changeMainNav();
			UICommand.changeSecondaryNav();
			// UICommand.taskGuide();
		}

		/*离开开始界面*/
		private static function _outStart() : void {
			var nav : Object = (UICommand.t.ui[UIName.UI_MAIN_NAV] as Object).nav;
			var disable : Object = (UICommand.t.ui[UIName.UI_MAIN_NAV] as Object).disable;
			nav.removeEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			nav.removeEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			nav.removeEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
			disable.openTop.removeEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			disable.removeEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			disable.removeEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_FRIEND].removeEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_SECONDARY_NAV].removeEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_SECONDARY_NAV].removeEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_SECONDARY_NAV].removeEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
			(UIMain.getInstance(SheepLayer.NAME) as SheepLayer).sheepSoundOnAndOff(false);
			if ((UICommand.t.ui[UIName.UI_FRIEND] as Object).close.visible) inOrOutFriend(false);
			// if (removeTimer) UICommand.removeSyncServerTimeTimer();
			if (UICommand.t.userData[3][3] != null && UICommand.t.gameGuideData[0] == 0) {
				if (UICommand.t.userData[3][3] < 6006) {
					UICommand.removeGuideHighlight();
					UICommand.t.gameGuideData[0] = 1;
					if (UICommand.t.userData[3][3] == 6002 || UICommand.t.userData[3][3] == 6004) {
						(UICommand.t.ui[UIName.UI_MAIN_NAV].getChildAt(UICommand.t.ui[UIName.UI_MAIN_NAV].numChildren - 1) as Object).tech.visible = true;
					}
				}
			}
			UICommand.t.stateFirst = "";
		}

		/*从活动界面到开始界面*/
		public static function activityToStart(o : Object) : void {
			_outActivity(o);
			UICommand.removeShield(4);
			inStart();
		}

		/*从公告界面到开始界面*/
		public static function announcementToStart(obj : Sprite) : void {
			_outAnnouncement(obj);
			UICommand.removeShield(4);
			inStart();
		}

		/*从图鉴界面到开始界面*/
		public static function handbookToStart() : void {
			_outHandbook();
			UICommand.removeShield(4);
			inStart();
		}

		/*从商店界面到开始界面*/
		public static function shopToStart() : void {
			_outShop();
			UICommand.removeShield(4);
			inStart();
		}

		/*从背包界面到开始界面*/
		public static function bagToStart() : void {
			_outBag();
			UICommand.removeShield(4);
			inStart();
		}

		/*从税收界面到开始界面*/
		public static function taxToStart() : void {
			_outTax();
			UICommand.removeTaxTimer();
			UICommand.removeShield(4);
			inStart();
		}

		/*从排行榜界面到开始界面*/
		public static function topToStart() : void {
			_outTop();
			UICommand.removeShield(4);
			inStart();
		}

		/*从战报界面到开始界面*/
		public static function reportToStart() : void {
			_outReport();
			UICommand.removeShield(4);
			inStart();
		}

		/*从科技界面到开始界面*/
		public static function techToStart() : void {
			_outTech();
			UICommand.removeShield(4);
			inStart();
		}

		/*从英雄界面到开始界面*/
		public static function heroToStart() : void {
			_outHero();
			UICommand.removeShield(4);
			inStart();
		}

		/*从匹配对手界面到开始界面*/
		public static function selectRivalToStart() : void {
			_outSelectRival();
			UICommand.removeShield(4);
			inStart();
		}

		/*从选择地图到开始界面*/
		public static function selectMapToStart() : void {
			_outSelectMap();
			UICommand.changeStartVisible();
			TweenLite.to(UICommand.t.ui[UIName.UI_USER_INFO], 0.4, {autoAlpha:1});
			UICommand.t.stateSecond = "";
			inStart();
		}

		/*进入或离开好友界面*/
		public static function inOrOutFriend(into : Boolean = true) : void {
			(UICommand.t.ui[UIName.UI_FRIEND] as Object).close.visible = into;
			(UICommand.t.ui[UIName.UI_FRIEND] as Object).openFriend.visible = !into;
			var offsetY : String;
			if (into) {
				if ((UICommand.t.ui[UIName.UI_FRIEND] as Object).data) {
					UICreate.getFriend();
				} else {
					UICommand.uiDataTransfer([{m:UIDataFunList.GET_FRIEND, a:[UICommand.t.userData[0]]}]);
				}
				offsetY = "-101";
			} else {
				UICommand.destroyLoaders();
				UICommand.t.ui[UIName.UI_FRIEND].removeChildAt(UICommand.t.ui[UIName.UI_FRIEND].numChildren - 1);
				offsetY = "101";
			}

			TweenLite.to(UICommand.t.ui[UIName.UI_FRIEND], 0.4, {y:offsetY, ease:Back.easeOut});
			TweenLite.to((UICommand.t.ui[UIName.UI_SECONDARY_NAV] as Object).down, 0.4, {y:offsetY, ease:Back.easeOut});
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.SLIDE_SOUND);
		}

		/*进入名片界面*/
		public static function inDossier(id : String, name : String) : void {
			(UICommand.t.ui[UIName.UI_DOSSIER] as Object).stateFirst = UICommand.t.stateFirst;
			UICommand.t.stateFirst = UIState.DOSSIER;
			UICreate.addShield();
			UICommand.t.addChild(UICommand.t.ui[UIName.UI_DOSSIER]);
			(UICommand.t.ui[UIName.UI_DOSSIER] as Object).langName.text = name;
			(UICommand.t.ui[UIName.UI_DOSSIER] as Object).title1.text = String(UIXML.uiXML.phrase.nowHave[0]) + String(UIXML.uiXML.phrase.hero[0]);
			(UICommand.t.ui[UIName.UI_DOSSIER] as Object).title2.text = String(UIXML.uiXML.phrase.nowHave[0]) + String(UIXML.uiXML.phrase.soldier[0]) + String(UIXML.uiXML.phrase.and[0]) + String(UIXML.uiXML.phrase.tower[0]) + String(UIXML.uiXML.dossier.title[4]);
			(UICommand.t.ui[UIName.UI_DOSSIER] as Object).langAWinTitle.text = String(UIXML.uiXML.dossier.title[0]);
			(UICommand.t.ui[UIName.UI_DOSSIER] as Object).langAProbabilityTitle.text = String(UIXML.uiXML.dossier.title[1]);
			(UICommand.t.ui[UIName.UI_DOSSIER] as Object).langDWinTitle.text = String(UIXML.uiXML.dossier.title[2]);
			(UICommand.t.ui[UIName.UI_DOSSIER] as Object).langDProbabilityTitle.text = String(UIXML.uiXML.dossier.title[3]);
			var prev : Object = (UICommand.t.ui[UIName.UI_DOSSIER] as Object).prev;
			if (prev.dataX == null) prev.dataX = prev.x;
			TweenLite.from(UICommand.t.ui[UIName.UI_DOSSIER], 0.4, {y:"-600", ease:Back.easeInOut});
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.SLIDE_SOUND);
			UICommand.uiDataTransfer([{m:UIDataFunList.GET_DOSSIER, a:[UICommand.t.userData[0], id]}]);
			UICommand.t.ui[UIName.UI_DOSSIER].addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
		}

		/*离开名片界面*/
		public static function outDossier() : void {
			UICommand.t.ui[UIName.UI_DOSSIER].removeEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			for (var i : uint = 0; i < 3; i++) UICommand.t.ui[UIName.UI_DOSSIER].removeChildAt(UICommand.t.ui[UIName.UI_DOSSIER].numChildren - 1);
			UICommand.destroyLoaders();
			UICommand.removeShield(UICommand.t.getChildIndex(UICommand.t.ui[UIName.UI_DOSSIER]) - 1);
			TweenLite.to(UICommand.t.ui[UIName.UI_DOSSIER], 0.4, {y:"-600", ease:Back.easeIn, onComplete:restoreOrDestroyTC, onCompleteParams:[UICommand.t.ui[UIName.UI_DOSSIER]]});
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.SLIDE_SOUND);
			UICommand.t.stateFirst = (UICommand.t.ui[UIName.UI_DOSSIER] as Object).stateFirst;
			(UICommand.t.ui[UIName.UI_DOSSIER] as Object).stateFirst = null;
		}

		/*提示文字动画*/
		public static function promptTextTween(size : uint, content : String, className : String) : void {
			var tf : TextField = UICommand.createTF(TextFormatAlign.CENTER, 0xFFFFFF, size, content, className);
			UICommand.centered(tf, GlobalVariable.STAGE_WIDTH, GlobalVariable.STAGE_HEIGHT, tf.width >> 1, tf.height >> 1);
			UICommand.t.stage.addChild(tf);
			TweenLite.to(tf, 0.4, {y:"-300", alpha:0, delay:0.4, onComplete:UITransition.restoreOrDestroyTC, onCompleteParams:[tf]});
		}

		/*进入充值*/
		public static function inPayRecharge() : void {
			var ObjClass : Class = UICommand.getClass(UIClass.PAY_RECHARGE);
			var sp : Object = new ObjClass();
			sp.t1.text = String(UIXML.uiXML.phrase.nowHave[0]);
			sp.t2.text = String(UICommand.t.userData[1][5]);
			var className : String;
			var child : Sprite;
			for (var j : uint = 1; j < 5; j++) {
				className = UIClass.PAY_RECHARGE_PREFIX + j;
				child = UICommand.getInstance(className);
				child.x = sp["p" + j].x;
				child.y = sp["p" + j].y;
				sp.addChild(child);
			}
			sp.name = UIClass.PAY_RECHARGE;
			sp.stateFirst = UICommand.t.stateFirst;
			UICommand.t.stateFirst = UIState.PAY_RECHARGE;
			var i : uint = UICommand.t.stage.numChildren;
			if (UICommand.t.stage.getChildByName(UIClass.LOADING_SOCKET)) i = UICommand.t.stage.numChildren - 1;
			UICreate.addShield({par:UICommand.t.stage, index:i});
			UICommand.t.stage.addChildAt(sp as Sprite, i + 1);
			TweenLite.from(sp, 0.4, {y:"-600", ease:Back.easeInOut});
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.SLIDE_SOUND);
			sp.addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			sp.addEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			sp.addEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
		}

		/*离开充值*/
		public static function outPayRecharge(obj : Object) : void {
			obj.removeEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			obj.removeEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			obj.removeEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
			UICommand.removeShield(UICommand.t.stage.getChildIndex(obj as DisplayObject) - 1, UICommand.t.stage);
			TweenLite.to(obj, 0.4, {y:"-600", ease:Back.easeIn, onComplete:restoreOrDestroyTC, onCompleteParams:[obj]});
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.SLIDE_SOUND);
			UICommand.t.stateFirst = obj.stateFirst;
		}

		/*进入公告界面*/
		private static function _inAnnouncement() : void {
			UICommand.t.stateFirst = UIState.ANNOUNCEMENT;
			// UICommand.uiDataTransfer([{m:UIDataFunList.GET_ANNOUNCEMENT, a:[UICommand.t.userData[0]]}]);
			var ObjClass : Class = UICommand.getClass(UIClass.ANNOUNCEMENT);
			var sp : Object = new ObjClass();
			sp.name = UIClass.ANNOUNCEMENT;
			sp.txt1.text = String(UIXML.uiXML.phrase.newestAnnouncement[0]);
			sp.txt3.text = String(UIXML.uiXML.phrase.more[0]);
			sp.txt3.visible = false;
			UICommand.t.addChildAt(sp as Sprite, 5);
			TweenLite.from(sp, 0.4, {y:"-600", ease:Back.easeInOut});
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.SLIDE_SOUND);
			sp.addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			sp.addEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			sp.addEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
			var data : Array = [];
			var xmlList : XMLList = UIXML.annXML.content;
			for each (var content:XML in xmlList) {
				data[data.length] = [content.title, content.link];
			}
			UICreate.getAnnContent(sp.txt2, data);
			if (UICommand.t.userData[3][2] != null) {
				var p : Sprite = sp.position;
				UICreate.createAdd(UIClass.ACTIVTITY_ANN, UIClass.ACTIVTITY_ANN, sp as Sprite, p.x, p.y, true);
			}
			// if (UICommand.t.userData[1][12] != null && UICommand.t.userData[1][12][0] == 1) {
			// var p : Sprite = sp.position;
			// UICreate.createAdd(UIClass.ACTIVTITY_ANN, UIClass.ACTIVTITY_ANN, sp as Sprite, p.x, p.y, true);
			// }
		}

		/*离开公告界面*/
		private static function _outAnnouncement(obj : Sprite) : void {
			obj.removeEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			obj.removeEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			obj.removeEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
			TweenLite.to(obj, 0.4, {y:"-600", ease:Back.easeIn, onComplete:restoreOrDestroyTC, onCompleteParams:[obj]});
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.SLIDE_SOUND);
			UICommand.t.stateFirst = "";
		}

		/*从开始界面到公告界面*/
		public static function startToAnnouncement() : void {
			_outStart();
			UICreate.addShield({index:4});
			_inAnnouncement();
		}

		/*进入任务界面*/
		public static function inTask(getData : Boolean = false) : void {
			(UICommand.t.ui[UIName.UI_TASK] as Object).stateFirst = UICommand.t.stateFirst;
			UICommand.t.stateFirst = UIState.TASK;
			if (getData) {
				UICommand.uiDataTransfer([{m:UIDataFunList.GET_TASK, a:[UICommand.t.userData[0]]}]);
			} else {
				(UICommand.t.ui[UIName.UI_TASK] as Object).showTask();
			}
			UICreate.addShield();
			UICommand.t.addChild(UICommand.t.ui[UIName.UI_TASK]);
			TweenLite.from(UICommand.t.ui[UIName.UI_TASK], 0.4, {alpha:0});
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.PAPER_SOUND);
			UICommand.t.ui[UIName.UI_TASK].addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
		}

		/*离开任务界面*/
		public static function outTask() : void {
			UICommand.t.ui[UIName.UI_TASK].removeEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			UICommand.t.stateFirst = (UICommand.t.ui[UIName.UI_TASK] as Object).stateFirst;
			UICommand.removeShield(UICommand.t.getChildIndex(UICommand.t.ui[UIName.UI_TASK]) - 1);
			TweenLite.to(UICommand.t.ui[UIName.UI_TASK], 0.4, {alpha:0, onComplete:restoreOrDestroyTC, onCompleteParams:[UICommand.t.ui[UIName.UI_TASK]]});
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.PAPER_SOUND);
		}

		/*进入活动界面*/
		private static function _inActivity() : void {
			UICommand.t.stateFirst = UIState.ACTIVTITY;
			var ObjClass : Class = UICommand.getClass(UIClass.ACTIVTITY);
			var obj : Object = new ObjClass();
			obj.name = UIClass.ACTIVTITY;
			var content : Object = obj.content;
			content.visible = false;
			var p : Sprite = content.closeP;
			UICreate.createAdd(UIClass.MC_CLOSE, UIName.E_CLOSE, content as Sprite, p.x, p.y);
			var animation : MovieClip = obj.animation;
			animation.gotoAndStop(1);
			TweenLite.to(animation, 0.3, {frameLabel:UIName.F_END});
			TweenLite.to(content, 0.1, {autoAlpha:1, delay:0.2});
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.PAPER_SOUND);
			UICommand.t.addChild(obj as Sprite);
			obj.addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			UICommand.uiDataTransfer([{m:UIDataFunList.GET_EVENT_TASKS, a:[UICommand.t.userData[0]]}]);
		}

		/*离开活动界面*/
		private static function _outActivity(o : Object) : void {
			o.removeEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			o.content.visible = false;
			TweenLite.to(o.animation, 0.2, {frameLabel:UIName.F_START});
			TweenLite.to(o, 0.1, {delay:0.1, alpha:0, onComplete:restoreOrDestroyTC, onCompleteParams:[o]});
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.PAPER_SOUND);
			UICommand.t.stateFirst = "";
		}

		/*从开始界面到活动界面*/
		public static function startToActivity() : void {
			_outStart();
			UICreate.addShield({index:4});
			_inActivity();
		}

		/*进入图鉴界面*/
		private static function _inHandbook() : void {
			UICommand.t.stateFirst = UIState.HANDBOOK;
			UICommand.uiDataTransfer([{m:UIDataFunList.GET_HANDBOOK, a:[UICommand.t.userData[0]]}]);
			UICommand.t.addChildAt(UICommand.t.ui[UIName.UI_HANDBOOK], 5);
			TweenLite.from(UICommand.t.ui[UIName.UI_HANDBOOK], 0.4, {alpha:0});
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.PAPER_SOUND);
			(UICommand.t.ui[UIName.UI_HANDBOOK] as Object).selected.visible = false;
			var prev : Object = (UICommand.t.ui[UIName.UI_HANDBOOK] as Object).prev;
			if (prev.dataX == null) prev.dataX = prev.x;
			(UICommand.t.ui[UIName.UI_HANDBOOK] as Object).txt.text = String(UIXML.uiXML.handbook.title1[0]);
			(UICommand.t.ui[UIName.UI_HANDBOOK] as Object).soldier.comp.enabled = false;
			(UICommand.t.ui[UIName.UI_HANDBOOK] as Object).tower.comp.enabled = false;
			UICommand.t.ui[UIName.UI_HANDBOOK].addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_HANDBOOK].addEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_HANDBOOK].addEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
		}

		/*离开图鉴界面*/
		private static function _outHandbook() : void {
			UICommand.t.ui[UIName.UI_HANDBOOK].removeEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_HANDBOOK].removeEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_HANDBOOK].removeEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
			for (var i : uint = 0; i < 2; i++) UICommand.t.ui[UIName.UI_HANDBOOK].removeChildAt(UICommand.t.ui[UIName.UI_HANDBOOK].numChildren - 2);
			TweenLite.to(UICommand.t.ui[UIName.UI_HANDBOOK], 0.4, {alpha:0, onComplete:restoreOrDestroyTC, onCompleteParams:[UICommand.t.ui[UIName.UI_HANDBOOK]]});
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.PAPER_SOUND);
			UICommand.t.stateFirst = "";
		}

		/*从开始界面到图鉴界面*/
		public static function startToHandbook() : void {
			_outStart();
			UICreate.addShield({index:4});
			_inHandbook();
		}

		/*从科技界面到图鉴界面*/
		public static function techToHandbook() : void {
			_outTech();
			(UICommand.t.ui[UIName.UI_HANDBOOK] as Object).dataFrom = UIState.TECH;
			_inHandbook();
		}

		/*进入商店界面*/
		private static function _inShop(index : uint = 5) : void {
			UICommand.t.stateFirst = UIState.SHOP;
			UICommand.uiDataTransfer([{m:UIDataFunList.GET_SHOP, a:[UICommand.t.userData[0]]}]);
			UICommand.navSelected((UICommand.t.ui[UIName.UI_SHOP] as Object).nav.all);
			UICommand.t.addChildAt(UICommand.t.ui[UIName.UI_SHOP], index);
			TweenLite.from(UICommand.t.ui[UIName.UI_SHOP], 0.4, {y:"600", ease:Back.easeInOut});
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.SLIDE_SOUND);
			UICommand.t.ui[UIName.UI_SHOP].addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_SHOP].addEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_SHOP].addEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
		}

		/*离开商店界面*/
		private static function _outShop() : void {
			UICommand.t.ui[UIName.UI_SHOP].removeEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_SHOP].removeEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_SHOP].removeEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
			UICommand.destroyScroll();
			TweenLite.to(UICommand.t.ui[UIName.UI_SHOP], 0.4, {y:"600", ease:Back.easeIn, onComplete:restoreOrDestroyTC, onCompleteParams:[UICommand.t.ui[UIName.UI_SHOP]]});
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.SLIDE_SOUND);
			UICommand.t.shopData = [];
			UICommand.t.stateFirst = "";
		}

		/*从开始界面到商店界面*/
		public static function startToShop() : void {
			_outStart();
			UICreate.addShield({index:4});
			_inShop();
		}

		/*从科技界面到商店界面*/
		public static function techToShop() : void {
			_outTech();
			(UICommand.t.ui[UIName.UI_SHOP] as Object).dataFrom = UIState.TECH;
			_inShop();
		}

		/*从背包界面到商店界面*/
		public static function bagToShop() : void {
			_outBag();
			(UICommand.t.ui[UIName.UI_SHOP] as Object).dataFrom = UIState.BAG;
			_inShop();
		}

		/*从小背包界面到商店界面*/
		public static function smallBagToShop(obj : Sprite) : void {
			var s : DisplayObject = obj.getChildAt(obj.numChildren - 1);
			TweenLite.to(s, 0.1, {alpha:1, onComplete:restoreOrDestroyTC, onCompleteParams:[s]});
			(obj as Object).stateFirst = UICommand.t.stateFirst;
			UICreate.addShield();
			_inShop(UICommand.t.numChildren);
			(UICommand.t.ui[UIName.UI_USER_INFO] as Object).dataIndex = UICommand.t.getChildIndex(UICommand.t.ui[UIName.UI_USER_INFO]);
			UICommand.t.addChild(UICommand.t.ui[UIName.UI_USER_INFO]);
		}

		/*从商店界面到小背包界面*/
		public static function shopToSmallBag() : void {
			UICommand.t.addChildAt(UICommand.t.ui[UIName.UI_USER_INFO], (UICommand.t.ui[UIName.UI_USER_INFO] as Object).dataIndex);
			UICommand.removeShield(UICommand.t.numChildren - 2);
			_outShop();
			var small : Array;
			var obj : Object = UICommand.t.getChildByName(UIClass.SMALL_BAG);
			switch (obj.data[1]) {
				case 3:
					/*神灯*/
					small = UICommand.t.bagData[2];
					break;
				case 4:
					/*装备*/
					small = UICommand.t.bagData[3];
					break;
			}
			UICreate.addSmallBagCard(obj, small);
			UICommand.t.stateFirst = obj.stateFirst;
		}

		/*进入英雄界面*/
		private static function _inHero() : void {
			UICommand.t.stateFirst = UIState.HERO;
			UICommand.restoreLock((UICommand.t.ui[UIName.UI_HERO] as Object).lock);
			UICommand.uiDataTransfer([{m:UIDataFunList.GET_SERVER_TIME, a:[UICommand.t.userData[0]]}, {m:UIDataFunList.GET_HERO, a:[UICommand.t.userData[0]]}, {m:UIDataFunList.GET_HAD_HERO, a:[UICommand.t.userData[0]]}]);
			UICommand.t.addChildAt(UICommand.t.ui[UIName.UI_HERO], 5);
			TweenLite.from(UICommand.t.ui[UIName.UI_HERO], 0.4, {y:"600", ease:Back.easeInOut});
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.SLIDE_SOUND);
			UICommand.t.ui[UIName.UI_HERO].addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_HERO].addEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_HERO].addEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
		}

		/*离开英雄界面*/
		private static function _outHero() : void {
			UICommand.t.ui[UIName.UI_HERO].removeEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_HERO].removeEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_HERO].removeEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
			UICommand.destroy((UICommand.t.ui[UIName.UI_HERO] as Object).box.getChildByName(UIName.PRESENT_HERO_REFRESH));
			UICommand.destroy((UICommand.t.ui[UIName.UI_HERO] as Object).getChildByName(UIName.PRESENT_HAD_HERO));
			TweenLite.to(UICommand.t.ui[UIName.UI_HERO], 0.4, {y:"600", ease:Back.easeIn, onComplete:restoreOrDestroyTC, onCompleteParams:[UICommand.t.ui[UIName.UI_HERO]]});
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.SLIDE_SOUND);
			UICommand.t.stateFirst = "";
		}

		/*从开始界面到英雄界面*/
		public static function startToHero() : void {
			_outStart();
			UICreate.addShield({index:4});
			_inHero();
		}

		/*从背包界面到英雄界面*/
		public static function bagToHero() : void {
			_outBag();
			(UICommand.t.ui[UIName.UI_HERO] as Object).dataFrom = UIState.BAG;
			_inHero();
		}

		/*进入英雄属性界面*/
		public static function inHeroAttribute(dataObj : Object, disable : Boolean = false) : void {
			UICreate.addShield();
			var ObjClass : Class = UICommand.getClass(UIClass.HERO_ATTRIBUTE);
			var obj : Object = new ObjClass();
			obj.name = UIClass.HERO_ATTRIBUTE;
			obj.state = UICommand.t.stateFirst;
			UICommand.t.stateFirst = UIState.HERO_ATTRIBUTE;
			/*数据源是英雄卡片，但补充体力，变更装备神灯时，改变数据源数据 _getHeroCard是源头*/
			obj.dataObj = dataObj;
			var content : Object = obj.content;
			content.visible = false;
			UICreate.initHeroContent(dataObj.data, content, true);
			if (disable) {
				var max : uint = content.btn.numChildren;
				for (var i : uint = 0; i < max; i++) {
					content.btn.getChildAt(i).visible = false;
				}
				content.btn.close.visible = true;
				content.frame.visible = false;
				content.langEquip.visible = false;
				content.gridEquip.visible = false;
				content.langGem.visible = false;
				content.gridGem.visible = false;
			}
			if (obj.state == UIState.SELECT_ATTACT_ROLE) content.btn.remove.visible = false;
			var animation : Object = obj.animation;
			animation.gotoAndStop(1);
			TweenLite.to(animation, 0.3, {frameLabel:UIName.F_END});
			TweenLite.to(content, 0.1, {autoAlpha:1, delay:0.2});
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.PAPER_SOUND);
			UICommand.t.addChild(obj as Sprite);
			content.btn.addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
		}

		/*离开英雄属性界面*/
		public static function outHeroAttribute(o : Object, remove : Boolean = false) : void {
			if (remove) {
				var hadHeroSP : Sprite = o.dataObj.parent as Sprite;
				var hadHeroBox : Sprite = hadHeroSP.parent as Sprite;
				var hadHeroBTN : Sprite = hadHeroBox.getChildAt(1) as Sprite;
				var num : uint = hadHeroSP.numChildren;
				var index : uint = hadHeroSP.getChildIndex(o.dataObj);
				var next : uint = index + 1;
				if (next < num) {
					var offset : int = o.dataObj.x - hadHeroSP.getChildAt(next).x;
					var offsetBTN : int = hadHeroBTN.getChildAt(index).x - hadHeroBTN.getChildAt(next).x;
					for (var i : uint = next; i < num; i++) {
						TweenLite.to(hadHeroSP.getChildAt(i), 0.4, {x:String(offset)});
						TweenLite.to(hadHeroBTN.getChildAt(i), 0.4, {x:String(offsetBTN)});
					}
				}
				UICommand.uiDataTransfer([{m:UIDataFunList.SAVE_HERO, a:[UICommand.t.userData[0], [false, o.dataObj.data[0]]]}], EventNameList.UI_SAVE_DATA);
				hadHeroBTN.removeChildAt(index);
				hadHeroSP.removeChildAt(index);
			}
			UICommand.removeShield(UICommand.t.getChildIndex(o as DisplayObject) - 1);
			o.content.visible = false;
			TweenLite.to(o.animation, 0.2, {frameLabel:UIName.F_START});
			TweenLite.to(o, 0.1, {delay:0.1, alpha:0, onComplete:restoreOrDestroyTC, onCompleteParams:[o]});
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.PAPER_SOUND);
			UICommand.t.stateFirst = o.state;
		}

		/*进入小背包界面，使用神灯或装备*/
		public static function inSmallBag(type : uint, par : Object) : void {
			UICommand.uiDataTransfer([{m:UIDataFunList.GET_BAG, a:[UICommand.t.userData[0], type]}]);
			UICreate.addShield();
			var ObjClass : Class = UICommand.getClass(UIClass.SMALL_BAG);
			var obj : Object = new ObjClass();
			obj.name = UIClass.SMALL_BAG;
			/*0顶级父容器,1类型,2已有神灯或装备,3现在选中,*/
			obj.data = [];
			obj.data[0] = par;
			obj.data[1] = type;
			var xmlList : XMLList;
			switch (type) {
				case 3:
					/*神灯*/
					obj.titelEquip.visible = false;
					obj.titelGem.visible = true;
					obj.title.text = String(UIXML.uiXML.phrase.current[0]) + String(UIXML.uiXML.phrase.gem[0]);
					xmlList = UIXML.gemXML.gem;
					obj.data[2] = par.dataObj.data[14];
					break;
				case 4:
					/*装备*/
					obj.titelEquip.visible = true;
					obj.titelGem.visible = false;
					obj.title.text = String(UIXML.uiXML.phrase.current[0]) + String(UIXML.uiXML.phrase.equipment[0]);
					xmlList = UIXML.equipmentXML.equipCategory.equip;
					obj.data[2] = par.dataObj.data[13];
					break;
			}
			obj.data[3] = obj.data[2];
			if (obj.data[3]) {
				xmlList = xmlList.(@id == obj.data[3]);
				UICreate.addGoodsIcon(obj.icon, [String(xmlList.name[0]), String(xmlList.langName[0]), String(xmlList.info[0])]);
			} else {
				obj.remove.comp.enabled = false;
			}
			UICommand.t.addChild(obj as Sprite);
			TweenLite.from(obj, 0.4, {y:"600", ease:Back.easeInOut});
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.SLIDE_SOUND);
			obj.addEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			obj.addEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
			obj.addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
		}

		/*离开小背包界面*/
		public static function outSmallBag(obj : Object) : void {
			obj.removeEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			obj.removeEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			obj.removeEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
			if (obj.data[2] != obj.data[3]) {
				/*把变更背包物品数据保存*/
				var b : Boolean;
				if (obj.data[0].state == UIState.SELECT_ATTACT_ROLE) b = true;
				var type : uint;
				switch (obj.data[1]) {
					case 3:
						/*神灯*/
						if (b) obj.data[0].dataObj.dataGemID = obj.data[3];
						obj.data[0].dataObj.data[14] = obj.data[3];
						UICreate.getHeroAttrGem(obj.data[0].content);
						type = 1;
						break;
					case 4:
						/*装备*/
						if (b) obj.data[0].dataObj.dataEquipID = obj.data[3];
						obj.data[0].dataObj.data[13] = obj.data[3];
						UICreate.getHeroAttrEquip(obj.data[0].content);
						type = 2;
						break;
				}
				UICommand.uiDataTransfer([{m:UIDataFunList.SAVE_HERO_CHANGE, a:[UICommand.t.userData[0], [obj.data[0].dataObj.data[0], type, obj.data[3]]]}], EventNameList.UI_SAVE_DATA);
			}
			UICommand.removeShield(UICommand.t.numChildren - 2);
			TweenLite.to(obj, 0.4, {y:"600", ease:Back.easeIn, onComplete:restoreOrDestroyTC, onCompleteParams:[obj]});
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.SLIDE_SOUND);
			/*清除数据*/
			obj.data = null;
			UICommand.t.bagData = [];
			UICommand.t.selectedItems = [];
		}

		/*进入背包界面*/
		private static function _inBag() : void {
			UICommand.t.stateFirst = UIState.BAG;
			UICommand.uiDataTransfer([{m:UIDataFunList.GET_BAG, a:[UICommand.t.userData[0]]}]);
			if (UICommand.t.userData[1][2] < uint(UIXML.uiXML.mainNav.heroStart.open)) {
				(UICommand.t.ui[UIName.UI_BAG] as Object).heroStart.visible = false;
			} else {
				(UICommand.t.ui[UIName.UI_BAG] as Object).heroStart.visible = true;
			}
			var prev : Object = (UICommand.t.ui[UIName.UI_BAG] as Object).prev;
			if (prev.dataX == null) prev.dataX = prev.x;
			var submit : Object = (UICommand.t.ui[UIName.UI_BAG] as Object).submit;
			if (submit.dataX == null) submit.dataX = submit.x;
			submit.visible = false;
			(UICommand.t.ui[UIName.UI_BAG] as Object).sale.visible = false;
			UICommand.navSelected((UICommand.t.ui[UIName.UI_BAG] as Object).nav.all);
			UICommand.t.addChildAt(UICommand.t.ui[UIName.UI_BAG], 5);
			TweenLite.from(UICommand.t.ui[UIName.UI_BAG], 0.4, {y:"-600", ease:Back.easeInOut});
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.PANEL_BOARD_SOUND);
			UICommand.t.ui[UIName.UI_BAG].addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_BAG].addEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_BAG].addEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
		}

		/*离开背包界面*/
		private static function _outBag() : void {
			UICommand.t.ui[UIName.UI_BAG].removeEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_BAG].removeEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_BAG].removeEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
			UICommand.destroy(UICommand.t.ui[UIName.UI_BAG].getChildByName(UIName.PRESENT_BAG));
			TweenLite.to(UICommand.t.ui[UIName.UI_BAG], 0.4, {y:"-600", ease:Back.easeIn, onComplete:restoreOrDestroyTC, onCompleteParams:[UICommand.t.ui[UIName.UI_BAG]]});
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.PANEL_BOARD_SOUND);
			UICommand.t.bagData = [];
			UICommand.t.stateFirst = "";
		}

		/*从开始,英雄,科技,商店界面到背包界面*/
		public static function toBag() : void {
			if (UICommand.t.stateFirst == UIState.START) {
				_outStart();
				UICreate.addShield({index:4});
			} else if (UICommand.t.stateFirst == UIState.HERO) {
				(UICommand.t.ui[UIName.UI_HERO] as Object).dataFrom = null;
				_outHero();
			} else if (UICommand.t.stateFirst == UIState.TECH) {
				(UICommand.t.ui[UIName.UI_TECH] as Object).dataFrom = null;
				_outTech();
			} else if (UICommand.t.stateFirst == UIState.SHOP) {
				(UICommand.t.ui[UIName.UI_SHOP] as Object).dataFrom = null;
				_outShop();
			}
			_inBag();
		}

		/*进入税收界面*/
		private static function _inTax() : void {
			UICommand.t.stateFirst = UIState.TAX;
			if (UICommand.t.userData[1][17]) UICommand.t.ui[UIName.UI_TAX].getChildByName(UIName.JS_FEED).visible = false;
			UICreate.getTaxContainer();
			UICommand.t.addChildAt(UICommand.t.ui[UIName.UI_TAX], 5);
			TweenLite.from(UICommand.t.ui[UIName.UI_TAX], 0.4, {y:"600", ease:Back.easeInOut});
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.SLIDE_SOUND);
			UICommand.t.ui[UIName.UI_TAX].addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_TAX].addEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_TAX].addEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
		}

		/*离开税收界面*/
		private static function _outTax() : void {
			UICommand.t.ui[UIName.UI_TAX].removeEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_TAX].removeEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_TAX].removeEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
			TweenLite.to(UICommand.t.ui[UIName.UI_TAX], 0.4, {y:"600", ease:Back.easeIn, onComplete:restoreOrDestroyTC, onCompleteParams:[UICommand.t.ui[UIName.UI_TAX]]});
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.SLIDE_SOUND);
			UICommand.t.stateFirst = "";
		}

		/*从开始界面到税收界面*/
		public static function startToTax() : void {
			_outStart();
			UICreate.addShield({index:4});
			_inTax();
		}

		/*进入排行榜界面*/
		private static function _inTop() : void {
			UICommand.t.stateFirst = UIState.TOP;
			var animation : Object = (UICommand.t.ui[UIName.UI_TOP] as Object).animation;
			animation.gotoAndStop(1);
			TweenLite.to(animation, 0.5, {frameLabel:UIName.F_END, onComplete:_topVisibleTC});
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.PAPER_SOUND);
			var close : Sprite = (UICommand.t.ui[UIName.UI_TOP] as Object).close;
			close.visible = false;
			TweenLite.to(close, 0.1, {autoAlpha:1, delay:0.4});
			var openFriend : Object = (UICommand.t.ui[UIName.UI_TOP] as Object).openFriend;
			openFriend.visible = false;
			openFriend.txt.text = String(UIXML.uiXML.phrase.friendTop[0]);
			TweenLite.to(openFriend, 0.1, {autoAlpha:1, delay:0.4});
			var all : Object = (UICommand.t.ui[UIName.UI_TOP] as Object).all;
			all.visible = false;
			all.txt.text = String(UIXML.uiXML.phrase.globalTop[0]);
			TweenLite.to(all, 0.1, {autoAlpha:1, delay:0.4});
			all.comp.enabled = false;
			UICommand.t.addChildAt(UICommand.t.ui[UIName.UI_TOP], 5);
			UICommand.t.ui[UIName.UI_TOP].addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_TOP].addEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_TOP].addEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
			if ((UICommand.t.ui[UIName.UI_TOP] as Object).data) {
				UICreate.getTop();
			} else {
				UICommand.uiDataTransfer([{m:UIDataFunList.GET_TOP, a:[UICommand.t.userData[0]]}]);
			}
		}

		private static function _topVisibleTC() : void {
			var obj : DisplayObject = UICommand.t.ui[UIName.UI_TOP].getChildByName(UIClass.GLOBAL_TOP_SCROLL);
			if (obj != null) obj.visible = true;
		}

		/*离开排行榜界面*/
		private static function _outTop() : void {
			UICommand.t.ui[UIName.UI_TOP].removeEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_TOP].removeEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_TOP].removeEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
			(UICommand.t.ui[UIName.UI_TOP] as Object).close.visible = false;
			(UICommand.t.ui[UIName.UI_TOP] as Object).bg.visible = false;
			(UICommand.t.ui[UIName.UI_TOP] as Object).openFriend.visible = false;
			var all : Object = (UICommand.t.ui[UIName.UI_TOP] as Object).all;
			all.visible = false;
			if (all.comp.enabled) {
				(UICommand.t.ui[UIName.UI_TOP].getChildByName(UIClass.TOP_SCROLL) as Object).scrollContent.getChildAt(1).clear();
			} else {
				all.comp.enabled = true;
			}
			UICommand.destroyScroll();
			TweenLite.to((UICommand.t.ui[UIName.UI_TOP] as Object).animation, 0.3, {frameLabel:UIName.F_START});
			TweenLite.to(UICommand.t.ui[UIName.UI_TOP], 0.1, {delay:0.2, alpha:0, onComplete:restoreOrDestroyTC, onCompleteParams:[UICommand.t.ui[UIName.UI_TOP]]});
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.PAPER_SOUND);
			UICommand.t.stateFirst = "";
		}

		/*从开始界面到排行榜界面*/
		public static function startToTop() : void {
			_outStart();
			UICreate.addShield({index:4});
			_inTop();
		}

		/*从派兵界面到排行榜界面*/
		public static function selectAttackRoleToTop() : void {
			_outSelectAttackRoleAddShield();
			_inTop();
		}

		/*从战斗界面到排行榜界面*/
		public static function progressToTop() : void {
			_outWarProgressAddShield();
			_inTop();
		}

		/*离开派兵界面到需要添加shield界面*/
		private static function _outSelectAttackRoleAddShield() : void {
			UICommand.changeStartVisible();
			TweenLite.to(UICommand.t.ui[UIName.UI_USER_INFO], 0.4, {autoAlpha:1});
			_outSelectAttackRole();
			UICreate.addShield({index:4});
			UICommand.t.stateSecond = "";
		}

		/*离开战斗到需要添加shield界面*/
		private static function _outWarProgressAddShield() : void {
			UICommand.changeStartVisible();
			TweenLite.to(UICommand.t.ui[UIName.UI_USER_INFO], 0.4, {autoAlpha:1});
			_outWarProgress();
			UICreate.addShield({index:4});
		}

		/*进入战报界面*/
		private static function _inReport() : void {
			UICommand.t.stateFirst = UIState.REPORT;
			if (UICommand.t.userData[1][2] > uint(UIXML.uiXML.mainNav.openReport.open[0])) UICommand.uiDataTransfer([{m:UIDataFunList.GET_REPORT, a:[UICommand.t.userData[0]]}]);
			UICommand.t.addChildAt(UICommand.t.ui[UIName.UI_REPORT], 5);
			TweenLite.from(UICommand.t.ui[UIName.UI_REPORT], 0.4, {y:"-600", ease:Back.easeInOut});
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.PANEL_BOARD_SOUND);
			UICommand.t.ui[UIName.UI_REPORT].addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_REPORT].addEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_REPORT].addEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
		}

		/*离开战报界面*/
		private static function _outReport() : void {
			UICommand.t.ui[UIName.UI_REPORT].removeEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_REPORT].removeEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_REPORT].removeEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
			if (UICommand.t.userData[1][2] > uint(UIXML.uiXML.mainNav.openReport.open[0])) UICommand.destroyScroll();
			TweenLite.to(UICommand.t.ui[UIName.UI_REPORT], 0.4, {y:"-600", ease:Back.easeIn, onComplete:restoreOrDestroyTC, onCompleteParams:[UICommand.t.ui[UIName.UI_REPORT]]});
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.PANEL_BOARD_SOUND);
			UICommand.t.stateFirst = "";
		}

		/*从开始界面到战报界面*/
		public static function startToReport() : void {
			_outStart();
			UICreate.addShield({index:4});
			_inReport();
		}

		/*从派兵界面到排行榜界面*/
		public static function selectAttackRoleToReportRevenge() : void {
			_outSelectAttackRoleAddShield();
			_inReport();
		}

		/*从战斗界面到战报界面，报仇*/
		public static function progressToReportRevenge() : void {
			_outWarProgressAddShield();
			_inReport();
		}

		/*从战斗界面到战报界面，录像*/
		public static function progressToReportPlayback() : void {
			_outWarProgressAddShield();
			UICommand.t.stateSecond = "";
			_inReport();
		}

		/*进入科技界面*/
		private static function _inTech() : void {
			UICommand.t.stateFirst = UIState.TECH;
			UICommand.uiDataTransfer([{m:UIDataFunList.GET_BAG, a:[UICommand.t.userData[0]]}, {m:UIDataFunList.GET_SERVER_TIME, a:[UICommand.t.userData[0]]}, {m:UIDataFunList.GET_TECH, a:[UICommand.t.userData[0]]}]);
			var info : Object = (UICommand.t.ui[UIName.UI_TECH] as Object).info;
			if (info.dataX == null) info.dataX = info.x;
			info.visible = false;
			var list : Object = (UICommand.t.ui[UIName.UI_TECH] as Object).list;
			if (list.dataX == null) list.dataX = list.x;
			list.soldier.comp.enabled = false;
			var openTechTower : uint = uint(UIXML.levelXML.relate.openTechTower[0]);
			if (UICommand.t.userData[1][2] < openTechTower && list.tower.dataLevel == null) {
				list.tower.dataLevel = openTechTower;
				UICommand.addEasyHit(list.tower, String(UIXML.uiXML.phrase.level[0]) + String(openTechTower) + String(UIXML.uiXML.disable.info[1]));
			} else if (UICommand.t.userData[1][2] >= openTechTower && list.tower.dataLevel) {
				list.tower.dataLevel = null;
				UICommand.remvoeEasyHit([list.tower]);
			}
			UICommand.t.addChildAt(UICommand.t.ui[UIName.UI_TECH], 5);
			var guide : Boolean;
			if (UICommand.t.userData[3][3] != null && UICommand.t.userData[3][3] < 6005 && UICommand.t.gameGuideData[0] == 1) {
				guide = true;
			}
			list.dataTC = true;
			TweenLite.from(list, 0.4, {x:String(-list.width), onComplete:_techSwitchTC, onCompleteParams:[list, false, guide]});
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.SLIDE_SOUND);
			UICommand.t.ui[UIName.UI_TECH].addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_TECH].addEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_TECH].addEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
		}

		/*离开科技界面*/
		private static function _outTech() : void {
			UICommand.t.ui[UIName.UI_TECH].removeEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_TECH].removeEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_TECH].removeEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
			TechTreeLayer.techRunTimeFlag = false;
			UICommand.destroyScroll();
			var list : Object = (UICommand.t.ui[UIName.UI_TECH] as Object).list;
			var info : Object = (UICommand.t.ui[UIName.UI_TECH] as Object).info;
			if (info.visible) TweenLite.to(info, 0.4, {x:String(info.width), onComplete:restoreOrDestroyTC, onCompleteParams:[info, {remove:false, x:info.dataX}]});
			TweenLite.to(list, 0.4, {x:String(-list.width), onComplete:restoreOrDestroyTC, onCompleteParams:[list, {remove:false, x:list.dataX}]});
			TweenLite.to(UICommand.t.ui[UIName.UI_TECH], 0.4, {alpha:0, onComplete:restoreOrDestroyTC, onCompleteParams:[UICommand.t.ui[UIName.UI_TECH]]});
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.SLIDE_SOUND);
			UICommand.t.bagData = [];
			UICommand.t.stateFirst = "";
		}

		/*从开始界面到科技界面*/
		public static function startToTech() : void {
			_outStart();
			UICreate.addShield({index:4});
			_inTech();
		}

		/*从商店界面到科技界面*/
		public static function shopToTech() : void {
			(UICommand.t.ui[UIName.UI_SHOP] as Object).dataFrom = null;
			_outShop();
			_inTech();
		}

		/*从图鉴界面到科技界面*/
		public static function handbookToTech() : void {
			(UICommand.t.ui[UIName.UI_HANDBOOK] as Object).dataFrom = null;
			_outHandbook();
			_inTech();
		}

		/*从背包界面到科技界面*/
		public static function bagToTech() : void {
			_outBag();
			(UICommand.t.ui[UIName.UI_TECH] as Object).dataFrom = UIState.BAG;
			_inTech();
		}

		/*科技界面的兵和塔科技列表切换*/
		public static function techListSwitch(type : String) : void {
			var list : Object = (UICommand.t.ui[UIName.UI_TECH] as Object).list;
			var tech : TechTreeLayer = (UIMain.getInstance(TechTreeLayer.NAME) as TechTreeLayer);
			var timelineLite : TimelineLite = new TimelineLite({onComplete:_techSwitchTC, onCompleteParams:[list, false, false]});
			timelineLite.appendMultiple([TweenLite.to(list, 0.2, {x:String(-list.width)}), TweenLite.to(list, 0.2, {x:String(list.width)})], 0, TweenAlign.SEQUENCE);
			list.dataType = type;
			if (type == TechTreeLayer.SOLDIER_TECH_TREE) {
				tech.techTitle = String(UIXML.uiXML.tech.title1[0]);
			} else if (type == TechTreeLayer.TOWER_TECH_TREE) {
				tech.techTitle = String(UIXML.uiXML.tech.title2[0]);
			}
			tech.showTechTree(type);
			list.soldier.comp.enabled = false;
			list.tower.comp.enabled = false;
		}

		/*科技界面的兵或塔科技介绍切换*/
		public static function techInfoSwitch() : void {
			var info : Object = (UICommand.t.ui[UIName.UI_TECH] as Object).info;
			info.dataTC = true;
			info.condition.up.visible = false;
			info.condition.submit.visible = false;
			if (info.visible) {
				var timelineLite : TimelineLite;
				var guide : Boolean;
				if (UICommand.t.userData[3][3] != null && UICommand.t.userData[3][3] < 6005 && UICommand.t.gameGuideData[0] == 2) {
					guide = true;
				}
				timelineLite = new TimelineLite({onComplete:_techSwitchTC, onCompleteParams:[info, true, guide]});
				timelineLite.appendMultiple([TweenLite.to(info, 0.2, {x:String(info.width)}), TweenLite.to(info, 0.2, {x:String(-info.width)})], 0, TweenAlign.SEQUENCE);
			} else {
				info.x += (UICommand.t.ui[UIName.UI_TECH] as Object).info.width;
				info.visible = true;
				TweenLite.to(info, 0.2, {x:String(-info.width), onComplete:_techSwitchTC, onCompleteParams:[info, true, false]});
			}
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.SLIDE_SOUND);
		}

		/*科技界面动画完成*/
		private static function _techSwitchTC(obj : Object, type : Boolean, guide : Boolean) : void {
			if (type) {
				if (guide) {
					var string : String = String(UIXML.gameGuideXML.guide.(@id == UICommand.t.userData[3][3]).tip.content[2]);
					if (UICommand.t.userData[3][3] == 6002) {
						UICreate.addGuideHighlight(obj.condition.submit, string);
					} else if (UICommand.t.userData[3][3] == 6004) {
						UICreate.addGuideHighlight(obj.condition.up, string);
					}
				}
			} else {
				if (guide) {
					if (obj.getChildByName(UIClass.TECH_SCROLL) != null) {
						UICommand.t.getChildAt(UICommand.t.numChildren - 1).visible = true;
						UICommand.t.getChildAt(UICommand.t.numChildren - 2).visible = true;
					}
				} else {
					if (obj.dataType == TechTreeLayer.SOLDIER_TECH_TREE && obj.tower.dataLevel == null) {
						obj.tower.comp.enabled = true;
					} else if (obj.dataType == TechTreeLayer.TOWER_TECH_TREE) {
						obj.soldier.comp.enabled = true;
					}
				}
			}
			obj.dataTC = false;
		}

		/*进入匹配对手界面*/
		private static function _inSelectRival(task : Boolean = true) : void {
			UICreate.addShield({index:4});
			UICommand.t.stateFirst = UIState.SELECT_RIVAL;
			(UICommand.t.ui[UIName.UI_SELECT_RIVAL] as Object).refresh.comp.enabled = true;
			(UICommand.t.ui[UIName.UI_SELECT_RIVAL] as Object).time.visible = false;
			(UICommand.t.ui[UIName.UI_SELECT_RIVAL] as Object).box.visible = false;
			(UICommand.t.ui[UIName.UI_SELECT_RIVAL] as Object).nav.rotation = 0;
			UICommand.t.addChildAt(UICommand.t.ui[UIName.UI_SELECT_RIVAL], 5);
			if (task) {
				UICommand.uiDataTransfer([{m:UIDataFunList.GET_TASK, a:[UICommand.t.userData[0]]}, {m:UIDataFunList.GET_RIVAL, a:[UICommand.t.userData[0], false]}]);
			} else {
				UICommand.uiDataTransfer([{m:UIDataFunList.GET_RIVAL, a:[UICommand.t.userData[0], false]}]);
			}
			var cX : Number = GlobalVariable.STAGE_WIDTH >> 1;
			var cY : Number = GlobalVariable.STAGE_HEIGHT >> 1;
			var newX : Number = -cX;
			var newY : Number = -cY;
			needChangeRegPointTween(UICommand.t.ui[UIName.UI_SELECT_RIVAL], cX, cY, newX, newY);
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.SLIDE_SOUND);
			UICommand.t.ui[UIName.UI_SELECT_RIVAL].addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_SELECT_RIVAL].addEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_SELECT_RIVAL].addEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
		}

		/*离开匹配对手界面*/
		private static function _outSelectRival() : void {
			UICommand.t.ui[UIName.UI_SELECT_RIVAL].removeEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_SELECT_RIVAL].removeEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_SELECT_RIVAL].removeEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
			UICommand.restoreRivalMatch();
			var cX : Number = GlobalVariable.STAGE_WIDTH >> 1;
			var cY : Number = GlobalVariable.STAGE_HEIGHT >> 1;
			var newX : Number = -cX;
			var newY : Number = -cY;
			needChangeRegPointTween(UICommand.t.ui[UIName.UI_SELECT_RIVAL], cX, cY, newX, newY, true);
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.SLIDE_SOUND);
			if (UICommand.t.rivalData[0][1]) {
				UICommand.t.rivalData[0][1].stop();
				UICommand.t.rivalData[0][1].removeEventListener(TimerEvent.TIMER, UICommand.t.rivalTimerHandler);
				UICommand.t.rivalData[0][1] = null;
			}
			UICommand.t.rivalData = [];
			UICommand.t.stateFirst = "";
		}

		/*从开始界面到匹配对手界面*/
		public static function startToSelectRival() : void {
			_outStart();
			_inSelectRival(false);
		}

		/*从派兵界面到匹配对手界面*/
		public static function selectAttackRoleToSelectRival() : void {
			UICommand.changeStartVisible();
			TweenLite.to(UICommand.t.ui[UIName.UI_USER_INFO], 0.4, {autoAlpha:1});
			_outSelectAttackRole();
			_inSelectRival();
		}

		/*从战斗界面到匹配对手界面*/
		public static function progressToSelectRival() : void {
			UICommand.changeStartVisible();
			TweenLite.to(UICommand.t.ui[UIName.UI_USER_INFO], 0.4, {autoAlpha:1});
			_outWarProgress();
			_inSelectRival();
		}

		/*进入派兵界面*/
		private static function _inSelectAttackRole(socket : Boolean = true) : void {
			UICommand.t.stateFirst = UIState.SELECT_ATTACT_ROLE;
			var expendables : Object = (UICommand.t.ui[UIName.UI_SELECT_ATTACK_ROLE] as Object).expendables;
			var attackRole : Object = (UICommand.t.ui[UIName.UI_SELECT_ATTACK_ROLE] as Object).attackRole;
			var tower : Object = (UICommand.t.ui[UIName.UI_SELECT_ATTACK_ROLE] as Object).tower;
			var prompt : Object = (UICommand.t.ui[UIName.UI_SELECT_ATTACK_ROLE] as Object).prompt;
			tower.visible = true;
			tower.left.visible = false;
			tower.right.visible = false;
			var mapXMLList : XMLList = UIXML.mapXML.maps.(@id == UICommand.t.mapData.mapId);
			if (UICommand.t.stateSecond == UIState.PVE) {
				prompt.visible = true;
				UICommand.addCSSAndContent(prompt.txt, UICommand.replaceHTML(String(mapXMLList.subMap.prompt[UICommand.t.mapData.submapId - 1])));
			} else {
				prompt.visible = false;
			}
			expendables.dataPaper = 0;
			expendables.through.visible = false;
			expendables.through.remind.visible = false;
			UICommand.setPaperNum(uint(mapXMLList.paper[0]), 1, false);
			expendables.y = 489;
			attackRole.y = 186;
			var lock : Object = expendables.lock;
			UICommand.restoreLock(lock);
			TweenLite.from(expendables, 0.6, {y:"100"});
			if (UICommand.t.userData[3][3] != null && UICommand.t.userData[3][3] == 6003 && UICommand.t.gameGuideData[0] == 3) {
				TweenLite.from(attackRole, 0.6, {y:"378", onComplete:_guideSelectAttackRoleTC, onCompleteParams:[attackRole.prev]});
			} else {
				TweenLite.from(attackRole, 0.6, {y:"378"});
			}
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.SLIDE_SOUND);
			UICommand.t.addChildAt(UICommand.t.ui[UIName.UI_SELECT_ATTACK_ROLE], 5);
			if (socket) {
				UICommand.uiDataTransfer([{m:UIDataFunList.GET_TOWER, a:[UICommand.t.userData[0], UICommand.t.selectedRivalData[0], UICommand.t.mapData.mapId, UICommand.t.mapData.submapId]}, {m:UIDataFunList.GET_ATTACK_ROLE, a:[UICommand.t.userData[0]]}]);
			} else {
				var dataTower : Array = (UICommand.t.ui[UIName.UI_SELECT_ATTACK_ROLE] as Object).dataTower;
				UICreate.getRivalDefenceTower(dataTower);
				var dataAttackRole : Object = (UICommand.t.ui[UIName.UI_SELECT_ATTACK_ROLE] as Object).dataAttackRole;
				UICreate.getAttackRole(dataAttackRole);
			}
			UICommand.t.ui[UIName.UI_SELECT_ATTACK_ROLE].addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_SELECT_ATTACK_ROLE].addEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_SELECT_ATTACK_ROLE].addEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
		}

		/*新手引导派兵界面动画完成*/
		private static function _guideSelectAttackRoleTC(focus : Sprite) : void {
			UICreate.addGuideHighlight(focus, String(UIXML.gameGuideXML.guide.(@id == 6003).tip.content[3]));
		}

		/*离开派兵界面*/
		private static function _outSelectAttackRole(back : Boolean = true) : void {
			UICommand.t.ui[UIName.UI_SELECT_ATTACK_ROLE].removeEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_SELECT_ATTACK_ROLE].removeEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_SELECT_ATTACK_ROLE].removeEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
			var attackRole : Object = (UICommand.t.ui[UIName.UI_SELECT_ATTACK_ROLE] as Object).attackRole;
			var expendables : Object = (UICommand.t.ui[UIName.UI_SELECT_ATTACK_ROLE] as Object).expendables;
			var tower : Object = (UICommand.t.ui[UIName.UI_SELECT_ATTACK_ROLE] as Object).tower;
			tower.visible = false;
			tower.removeChildAt(tower.numChildren - 1);
			if (UICommand.t.stateSecond == UIState.PVE) (UICommand.t.ui[UIName.UI_SELECT_ATTACK_ROLE] as Object).prompt.visible = false;
			var feedPaper : DisplayObject = expendables.getChildByName(UIClass.FEED_PAPER);
			if (feedPaper) expendables.removeChild(feedPaper);
			UICommand.removeSubstrate(4);
			var presentExpendable : DisplayObject = UICommand.t.getChildByName(UIName.PRESENT_EXPENDABLE);
			if (back) {
				UICommand.destroy(presentExpendable, UICommand.t.mouseEvent);
				TweenLite.to(expendables, 0.4, {y:"100"});
				TweenLite.to(attackRole, 0.4, {y:"378", onComplete:restoreOrDestroyTC, onCompleteParams:[UICommand.t.ui[UIName.UI_SELECT_ATTACK_ROLE]]});
			} else {
				TweenLite.to(expendables.through, 0.4, {autoAlpha:1});
				TweenLite.to(attackRole, 0.4, {y:"378", onComplete:restoreOrDestroyTC, onCompleteParams:[attackRole, {remove:false}]});
			}
			presentExpendable.removeEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.SLIDE_SOUND);
			var hero : DisplayObject = attackRole.getChildByName(UIName.PRESENT_ATTACK_HERO);
			if (hero) attackRole.removeChild(hero);
			UICommand.destroyScroll();
			UICommand.destroy(UICommand.t.getChildByName(UIName.PRESENT_HERO_ATTRIBUTE), UICommand.t.mouseEvent);
			UICommand.t.stateFirst = "";
		}

		/*离开派兵界面去其他界面*/
		public static function outSelectAttackRoleToOther() : void {
			UICommand.t.expendableData = [];
			if (UICommand.t.stateSecond == UIState.FRIEND || UICommand.t.stateSecond == UIState.PVE) {
				if ((UICommand.t.ui[UIName.UI_TOP] as Object).dataState == UIState.FRIEND) {
					(UICommand.t.ui[UIName.UI_TOP] as Object).dataState = null;
					UITransition.selectAttackRoleToTop();
				} else {
					if (UICommand.t.stateSecond == UIState.PVE) UICommand.t.stateSecond = "";
					UITransition.selectAttackRoleToSelectMap();
				}
			} else if (UICommand.t.stateSecond == UIState.TEST_MAP) {
				UITransition.selectAttackRoleToDefence();
			} else {
				if ((UICommand.t.ui[UIName.UI_REPORT] as Object).dataState == UIState.MONEY_WAR) {
					(UICommand.t.ui[UIName.UI_REPORT] as Object).dataState = null;
					UITransition.selectAttackRoleToReportRevenge();
				} else {
					UITransition.selectAttackRoleToSelectRival();
				}
			}
		}

		/*战斗界面到派兵界面过场动画*/
		public static function progressToSelectAttackRole() : void {
			_outWarProgress();
			var ObjClass : Class = UICommand.getClass(UIClass.ANIMATION_AGAIN_TRANSITION);
			var obj : Object = new ObjClass();
			UICommand.t.addChild(obj as DisplayObject);
			obj.gotoAndStop(1);
			TweenLite.to(obj, 1.8, {frameLabel:UIName.F_END});
			TweenLite.to(obj, 0.3, {alpha:0, delay:1.7, onComplete:restoreOrDestroyTC, onCompleteParams:[obj]});
			UICreate.addSubstrate(4);
			_inSelectAttackRole(false);
		}

		/*从摆塔布防界面到派兵界面*/
		public static function defenceToSelectAttackRole() : void {
			UICommand.t.stateSecond = UIState.TEST_MAP;
			_outDefence();
			UICreate.addSubstrate(4);
			_inSelectAttackRole();
		}

		/*从选择地图到派兵界面*/
		public static function selectMapToSelectAttackRole() : void {
			_outSelectMap();
			_removeShieldAddSubstrateRemoveUserInfo();
			_inSelectAttackRole();
		}

		/*从排行榜界面到派兵界面*/
		public static function topToSelectAttackRole() : void {
			_outTop();
			_removeShieldAddSubstrateRemoveUserInfo();
			UICommand.t.stateSecond = UIState.FRIEND;
			(UICommand.t.ui[UIName.UI_TOP] as Object).dataState = UIState.FRIEND;
			_inSelectAttackRole();
			UICommand.changeStartVisible(false);
		}

		/*从战报界面到派兵界面*/
		public static function reportToSelectAttackRole() : void {
			_outReport();
			_removeShieldAddSubstrateRemoveUserInfo();
			// UICommand.t.stateSecond = UIState.MONEY_WAR;
			(UICommand.t.ui[UIName.UI_REPORT] as Object).dataState = UIState.MONEY_WAR;
			_inSelectAttackRole();
			UICommand.changeStartVisible(false);
		}

		/*从匹配对手界面到派兵界面*/
		public static function selectRivalToSelectAttackRole() : void {
			_outSelectRival();
			_removeShieldAddSubstrateRemoveUserInfo();
			_inSelectAttackRole();
			UICommand.changeStartVisible(false);
		}

		/*进入战斗界面*/
		private static function _inWarProgress() : void {
			/*战斗界面初始化*/
			if (UICommand.t.stateSecond == UIState.PLAYBACK) {
				UICommand.startProgress();
				UICreate.addNPCPrompt(UIXML.uiXML.playback.info, UIClass.NPC_PROMPT_A);
			} else {
				var num : uint = UICommand.getPaperNum();
				UICommand.changeCardDisable(num);
				UICommand.setThrough(0);
				UICommand.t.attackTime = uint(UIXML.mapXML.maps.(@id == UICommand.t.mapData.mapId).attackTime[0]);
				UICommand.formatTime((UICommand.t.ui[UIName.UI_DEADLINE] as Object).txt, UICommand.t.attackTime % 60, uint(UICommand.t.attackTime / 60));
				var maskRce : DisplayObject = UICommand.cloneInstance((UICommand.t.ui[UIName.UI_DEADLINE] as Object).animation);
				(UICommand.t.ui[UIName.UI_DEADLINE] as Object).animation.mask = maskRce;
				maskRce.scaleX = 1;
				maskRce.x = (UICommand.t.ui[UIName.UI_DEADLINE] as Object).animation.x;
				maskRce.y = (UICommand.t.ui[UIName.UI_DEADLINE] as Object).animation.y;
				UICommand.t.ui[UIName.UI_DEADLINE].addChildAt(maskRce, 0);
				(UICommand.t.ui[UIName.UI_DEADLINE] as Object).remind.visible = false;
				UICommand.t.addChild(UICommand.t.ui[UIName.UI_DEADLINE]);
				(UICommand.t.ui[UIName.UI_STOP_PLAY] as Object).stopWar.visible = false;
				(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).pauseGame();
				(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).showSkillsButtonInfo();
			}
			(UICommand.t.ui[UIName.UI_STOP_PLAY] as Object).playWar.visible = false;
			// (UICommand.t.ui[UIName.UI_STOP_PLAY] as Object).goWar.visible = false;
			UICommand.t.addChild(UICommand.t.ui[UIName.UI_STOP_PLAY]);
			UICommand.batchAddEvent(UICommand.t.ui[UIName.UI_STOP_PLAY], UICommand.t.mouseEvent, false, true, false, true, true);
		}

		/*离开战斗界面*/
		private static function _outWarProgress() : void {
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playMusic(SoundName.SOUND_BACKGROUND);
			ApplicationFacade.getInstance().sendNotification(NotificationNameList.QUIT_WAR);
			if (UICommand.t.stateSecond == UIState.PLAYBACK) {
				UICommand.t.removeChild(UICommand.t.getChildByName(UIClass.NPC_PROMPT_A));
			} else {
				UICommand.destroy(UICommand.t.getChildByName(UIName.PRESENT_EXPENDABLE), UICommand.t.mouseEvent);
				UICommand.t.removeChild(UICommand.t.ui[UIName.UI_DEADLINE]);
				UICommand.t.removeChild(UICommand.t.ui[UIName.UI_SELECT_ATTACK_ROLE]);
			}
			UICommand.t.removeChild(UICommand.t.ui[UIName.UI_STOP_PLAY]);
			UICommand.t.timelineLites = new Vector.<TimelineLite>();
			UICommand.t.stateFirst = "";
		}

		/*到战斗界面过场动画*/
		public static function warTransition(into : Boolean = true) : void {
			var obj : Object;
			if (into) {
				UICommand.t.stateFirst = UIState.WAR_PROGRESS;
				/*显示防御角色和地图*/
				// if (UICommand.t.stateSecond == "" || UICommand.t.stateSecond == UIState.FRIEND || UICommand.t.stateSecond == UIState.PVE) {
				if (UICommand.t.stateSecond == UIState.TEST_MAP) {
					UICreate.getDefence(UICommand.t.mapData);
				} else if (UICommand.t.stateSecond != UIState.PLAYBACK) {
					UICommand.uiDataTransfer([{m:UIDataFunList.GET_DEFENCE, a:[UICommand.t.userData[0], UICommand.t.selectedRivalData[0], UICommand.t.mapData.mapId, UICommand.t.mapData.submapId]}]);
				}
				var ObjClass : Class = UICommand.getClass(UIClass.ANIMATION_WAR_TRANSITION);
				obj = new ObjClass();
				UICommand.t.addChild(obj as DisplayObject);
				obj.gotoAndStop(1);
				TweenLite.to(obj, 0.4, {frameLabel:UIName.F_START, onComplete:transitionTC});
			} else {
				obj = UICommand.t.getChildAt(UICommand.t.numChildren - 1);
				TweenLite.to(obj, 0.4, {frameLabel:UIName.F_END, onComplete:restoreOrDestroyTC, onCompleteParams:[obj]});
				_inWarProgress();
			}
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.DOOR_SOUND);
		}

		/*过场动画定格*/
		public static function transitionTC() : void {
			var myTimer : Timer = new Timer(500, 1);
			myTimer.start();
			myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, UICommand.t.transitionTimerComplete);
		}

		/*从战报界面到战斗界面*/
		public static function reportToWarProgressPlayback(reportID : String) : void {
			_outReport();
			UICommand.removeShield(4);
			TweenLite.to(UICommand.t.ui[UIName.UI_USER_INFO], 0.4, {alpha:0, onComplete:restoreOrDestroyTC, onCompleteParams:[UICommand.t.ui[UIName.UI_USER_INFO], {remove:false, visible:false}]});
			UICommand.t.stateSecond = UIState.PLAYBACK;
			warTransition();
			(UIMain.getInstance(OptionMainLayer.NAME) as OptionMainLayer).skillsButtonFlag = false;
			UICommand.changeStartVisible(false);
			UICommand.uiDataTransfer([{m:UIDataFunList.GET_PLAYBACK, a:[UICommand.t.userData[0], reportID]}]);
		}

		/*从派兵界面到战斗界面*/
		public static function selectAttackRoleToWarProgress() : void {
			_outSelectAttackRole(false);
			warTransition();
		}

		/*进入关卡和布防界面*/
		public static function inHurdle() : void {
			UICommand.t.stateFirst = UIState.HURDLE;
			UICreate.addShield();
			var ObjClass : Class = UICommand.getClass(UIClass.HURDLE);
			var obj : Object = new ObjClass();
			obj.name = UIClass.HURDLE;
			var xmlList : XMLList;
			xmlList = UIXML.uiXML.hurdle;
			obj.langGoods.text = String(xmlList.specialty[0]);
			obj.langHudle.text = String(xmlList.hurdleTitle[0]);
			var mapXmlList : XMLList = UIXML.mapXML.maps.(@id == UICommand.t.mapData.mapId);
			obj.langMapName.text = UICommand.t.mapData.dataMapName;
			obj.langMapInfo.text = String(mapXmlList.info[0]);
			// 掉落物品
			xmlList = mapXmlList.goods.defence.good;
			var goodsSum : uint = xmlList.length();
			var data : Array = [];
			for (var i : uint = 0; i < goodsSum; i++) data[data.length] = [xmlList[i], 0];
			UICreate.getGoods(data, obj.goodsBox);
			// 关卡
			xmlList = mapXmlList.subMap;
			var token : uint = uint(xmlList.inToken[0]);
			var cap : uint = uint(xmlList.inCap[0]);
			var langName : String;
			var level : uint;
			var sum : uint = uint(xmlList.sum[0]);
			var subMap : Vector.<Sprite> = new Vector.<Sprite>(sum, true);
			var pveData : Array = UICommand.t.mapData.dataPVE;
			var pveLen : uint = pveData.length;
			var stars : Sprite;
			var starsSum : int;
			if (pveLen == sum) {
				obj.langMapBTN.text = String(UIXML.uiXML.hurdle.defence.info[1]);
			} else {
				obj.submit.comp.enabled = false;
				obj.langMapBTN.text = String(UIXML.uiXML.hurdle.defence.info[0]);
			}
			var denominator : uint = sum * 3;
			var numerator : uint;
			var btn : Object;
			var btn1 : Object;
			for (var j : uint = 0; j < sum; j++) {
				subMap[j] = UICommand.getInstance(UIClass.HURDLE_CONTAINER);
				btn = (subMap[j] as Object).btn;
				btn1 = (subMap[j] as Object).btn1;
				btn1.visible = false;
				(subMap[j] as Object).langName.text = btn.dataLangName = btn1.dataLangName = (subMap[j] as Object).disable.dataLangName = langName = String(xmlList.title[j]);
				(subMap[j] as Object).disable.mouseChildren = false;
				level = uint(xmlList.level[j]);
				if (j > pveLen || UICommand.t.userData[1][2] < level) {
					btn.visible = false;
					if (j) {
						(subMap[j] as Object).disable.dataInfo = String(UIXML.uiXML.disable.map[0]) + String(UIXML.uiXML.phrase.level[0]) + level + String(UIXML.uiXML.disable.info[1]);
					} else {
						(subMap[j] as Object).disable.dataInfo = String(UIXML.uiXML.phrase.level[0]) + level + String(UIXML.uiXML.disable.info[1]);
					}
				} else {
					(subMap[j] as Object).disable.visible = false;
					(subMap[j] as Object).dataToken = token;
					(subMap[j] as Object).dataCap = cap;
					if (xmlList.tipPrompt[j]) btn.dataInfo = btn1.dataInfo = String(xmlList.tipPrompt[j]);
					btn.num.text = btn1.num.text = (subMap[j] as Object).dataSubMapID = uint(j + 1);
					stars = (subMap[j] as Object).btn.stars;
					if (j == pveLen) {
						stars.visible = false;
					} else {
						starsSum = -1;
						numerator += pveData[j];
						if (pveData[j]) {
							starsSum = pveData[j] - 1;
							if (starsSum == 2) btn1.visible = true;
						}
						for (var k : int = 2; k > starsSum; k--) stars.getChildAt(k).filters = [new ColorMatrixFilter([0.31, 0.61, 0.08, 0, 0, 0.31, 0.61, 0.08, 0, 0, 0.31, 0.61, 0.08, 0, 0, 0, 0, 0, 1, 0])];
					}
				}
			}
			obj.prev.dataX = obj.prev.x;
			UICreate.getPages(obj, subMap, UIState.HURDLE, 9, 3, 15, 13, 64, 88, 0, -5);
			var score : Object = obj.score;
			score.mouseChildren = false;
			score.num.text = numerator + UIName.CHAR_SlASH + denominator;
			score.contentMask.width *= numerator / denominator;
			var oneWidth : Number = score.bg.width / denominator;
			var grade : int = xmlList.score.grade.length();
			var line : Sprite;
			var current : uint = 0;
			var gradeNum : uint;
			for (var h : uint = 0; h < grade; h++) {
				gradeNum = uint(xmlList.score.grade[h].num[0]);
				if (gradeNum != denominator) {
					line = UICommand.getInstance(UIClass.HURDLE_LINE);
					line.y = score.bg.y;
					line.x = score.bg.x + uint(gradeNum * oneWidth) - 1;
					score.addChildAt(line, 2);
				}
				if (numerator >= gradeNum) current = h + 1;
			}
			score.dataLangName = String(UIXML.uiXML.phrase.prompt[0]);
			var xml : XML;
			if (current == grade) {
				score.dataInfo = String(UIXML.uiXML.hurdle.paper.info[2]);
			} else {
				xml = xmlList.score.grade[current];
				score.dataInfo = String(UIXML.uiXML.hurdle.paper.info[0]).replace(UIName.VAR_A, String(xml.num[0])).replace(UIName.VAR_B, String(xml.paper[0]));
			}
			if (current) {
				UICommand.t.mapData.dataAddPaper = uint(xmlList.score.grade[current - 1].paper[0]);
				score.dataInfo += (String(UIXML.uiXML.hurdle.paper.info[1]).replace(UIName.VAR_A, UICommand.t.mapData.dataAddPaper));
			} else {
				UICommand.t.mapData.dataAddPaper = 0;
			}
			UICommand.t.addChild(obj as Sprite);
			if (UICommand.t.userData[3][3] != null && UICommand.t.userData[3][3] == 6003 && UICommand.t.gameGuideData[0] == 2) {
				(subMap[0] as Object).dataX = obj.contentMask.x;
				(subMap[0] as Object).dataY = obj.contentMask.y;
				TweenLite.from(obj, 0.4, {y:"600", ease:Back.easeInOut, onComplete:_hurdleTC, onCompleteParams:[subMap[0]]});
			} else {
				TweenLite.from(obj, 0.4, {y:"600", ease:Back.easeInOut});
			}
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.SLIDE_SOUND);
			obj.addEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			obj.addEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
			obj.addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
		}

		private static function _hurdleTC(obj : Sprite) : void {
			UICreate.addGuideHighlight(obj, String(UIXML.gameGuideXML.guide.(@id == 6003).tip.content[2]));
		}

		/*离开关卡和布防界面*/
		public static function outHurdle(obj : Object) : void {
			obj.removeEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			obj.removeEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			obj.removeEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
			UICommand.removeShield(UICommand.t.getChildIndex(obj as Sprite) - 1);
			TweenLite.to(obj, 0.4, {y:"600", ease:Back.easeIn, onComplete:restoreOrDestroyTC, onCompleteParams:[obj]});
			(UIMain.getInstance(SoundLayer.NAME) as SoundLayer).playSound(SoundName.SLIDE_SOUND);
			UICommand.t.stateFirst = UIState.SELECT_MAP;
		}

		/*进入选择地图界面*/
		private static function _inSelectMap(task : Boolean = true) : void {
			UICommand.t.stateFirst = UIState.SELECT_MAP;
			var defence : Sprite = (UICommand.t.ui[UIName.UI_SELECT_MAP] as Object).defence as Sprite;
			var defenceMax : uint = defence.numChildren;
			for (var i : uint = 0; i < defenceMax; i++) (defence.getChildAt(i) as Object).comp.enabled = false;
			var friendID : String = "0";
			var friendName : Object = (UICommand.t.ui[UIName.UI_SELECT_MAP] as Object).friendName;
			var openDossier : Object = (UICommand.t.ui[UIName.UI_SELECT_MAP] as Object).openDossier;
			var friendclose : Object = (UICommand.t.ui[UIName.UI_SELECT_MAP] as Object).friendclose;
			var addclose : DisplayObject = UICommand.t.ui[UIName.UI_SELECT_MAP].getChildByName(UIName.E_ADD + UIName.E_CLOSE);
			UICommand.t.ui[UIName.UI_SELECT_MAP].addChildAt(UICommand.getInstance(UIClass.ANIMATION_MAP_SEA), 0);
			UICommand.t.ui[UIName.UI_SELECT_MAP].addChildAt(new CloudLayer(), 9);
			(UICommand.t.ui[UIName.UI_SELECT_MAP] as Object).wave.gotoAndPlay(1);
			UICommand.t.addChildAt(UICommand.t.ui[UIName.UI_SELECT_MAP], 4);
			TweenLite.from(UICommand.t.ui[UIName.UI_SELECT_MAP], 0.4, {alpha:0.2});
			if (UICommand.t.stateSecond == UIState.FRIEND) {
				friendID = UICommand.t.selectedRivalData[0];
				(UICommand.t.ui[UIName.UI_SELECT_MAP] as Object).close.comp.enabled = false;
				friendName.visible = true;
				openDossier.visible = true;
				friendclose.visible = true;
				addclose.visible = false;
				var txt : TextField = friendName.txt;
				txt.width = 200;
				var bg : Sprite = friendName.bg;
				txt.text = UICommand.t.selectedRivalData[1] + String(UIXML.uiXML.phrase.home[0]);
				txt.width = txt.textWidth + 4;
				bg.width = (txt.x * 2) + txt.textWidth;
				UICommand.t.ui[UIName.UI_FRIEND].visible = true;
				UICommand.t.ui[UIName.UI_FRIEND].addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
				UICommand.t.swapChildrenAt(2, 4);
			} else {
				(UICommand.t.ui[UIName.UI_SELECT_MAP] as Object).close.comp.enabled = true;
				friendName.visible = false;
				openDossier.visible = false;
				friendclose.visible = false;
				addclose.visible = true;
				// UICommand.taskGuide();
			}
			if (task) {
				UICommand.uiDataTransfer([{m:UIDataFunList.GET_TASK, a:[UICommand.t.userData[0]]}, {m:UIDataFunList.GET_MAP, a:[UICommand.t.userData[0], friendID]}]);
			} else {
				UICommand.uiDataTransfer([{m:UIDataFunList.GET_MAP, a:[UICommand.t.userData[0], friendID]}]);
			}
			(UICommand.t.ui[UIName.UI_SELECT_MAP] as Object).mapName.visible = false;
			UICommand.t.ui[UIName.UI_SELECT_MAP].addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_SELECT_MAP].addEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_SELECT_MAP].addEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
		}

		/*离开选择地图界面*/
		private static function _outSelectMap() : void {
			UICommand.t.ui[UIName.UI_SELECT_MAP].removeEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_SELECT_MAP].removeEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_SELECT_MAP].removeEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
			(UICommand.t.ui[UIName.UI_SELECT_MAP] as Object).wave.gotoAndStop(1);
			if (UICommand.t.stateSecond == UIState.FRIEND) {
				UICommand.t.ui[UIName.UI_FRIEND].removeEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
				if ((UICommand.t.ui[UIName.UI_FRIEND] as Object).close.visible) inOrOutFriend(false);
				UICommand.t.ui[UIName.UI_FRIEND].visible = false;
				UICommand.t.swapChildrenAt(2, 4);
			}
			if (UICommand.t.userData[3][3] != null && UICommand.t.userData[3][3] == 6003 && UICommand.t.gameGuideData[0] == 6) UICommand.nextGuide();
			UICommand.removeSelectMapEasyHit();
			TweenLite.to(UICommand.t.ui[UIName.UI_SELECT_MAP], 0.4, {alpha:0.4, onComplete:restoreOrDestroyTC, onCompleteParams:[UICommand.t.ui[UIName.UI_SELECT_MAP]]});
			UICommand.t.stateFirst = "";
		}

		/*从战斗界面到选择地图界面*/
		public static function progressToSelectMap() : void {
			_outWarProgress();
			_inSelectMap();
		}

		/*从派兵界面到选择地图界面*/
		public static function selectAttackRoleToSelectMap() : void {
			_outSelectAttackRole();
			_inSelectMap();
		}

		/*从好友界面到选择地图界面*/
		public static function friendToSelectMap() : void {
			_outStart();
			UICommand.t.stateSecond = UIState.FRIEND;
			_toSelectMap();
		}

		/*从开始界面到选择地图界面*/
		public static function startToSelectMap() : void {
			_outStart();
			_toSelectMap();
		}

		/*从好友界面或开始界面到选择地图界面*/
		private static function _toSelectMap() : void {
			TweenLite.to(UICommand.t.ui[UIName.UI_USER_INFO], 0.4, {alpha:0, onComplete:restoreOrDestroyTC, onCompleteParams:[UICommand.t.ui[UIName.UI_USER_INFO], {remove:false, visible:false}]});
			UICommand.changeStartVisible(false);
			_inSelectMap(false);
		}

		/*从摆塔布防界面到选择地图界面*/
		public static function defenceToSelectMap() : void {
			_outDefence();
			_inSelectMap();
		}

		/*进入摆塔布防界面*/
		private static function _inDefence() : void {
			TweenLite.to(UICommand.t.ui[UIName.UI_USER_INFO], 0.4, {autoAlpha:1});
			(UICommand.t.ui[UIName.UI_DEFENCE_OPERATION] as Object).selected.visible = false;
			UICommand.t.addChildAt(UICommand.t.ui[UIName.UI_DEFENCE_OPERATION], 4);
			TweenLite.from(UICommand.t.ui[UIName.UI_DEFENCE_OPERATION], 0.2, {alpha:0.2});
			UICommand.t.ui[UIName.UI_DEFENCE_OPERATION].addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_DEFENCE_OPERATION].addEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_DEFENCE_OPERATION].addEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
		}

		/*离开摆塔布防界面*/
		private static function _outDefence() : void {
			UICommand.t.ui[UIName.UI_DEFENCE_OPERATION].removeEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_DEFENCE_OPERATION].removeEventListener(MouseEvent.MOUSE_OVER, UICommand.t.mouseEvent);
			UICommand.t.ui[UIName.UI_DEFENCE_OPERATION].removeEventListener(MouseEvent.MOUSE_OUT, UICommand.t.mouseEvent);
			(UIMain.getInstance(BackgroundLayer.NAME)as BackgroundLayer).removeAll();
			TweenLite.to(UICommand.t.ui[UIName.UI_DEFENCE_OPERATION], 0.2, {alpha:0, onComplete:restoreOrDestroyTC, onCompleteParams:[UICommand.t.ui[UIName.UI_DEFENCE_OPERATION]]});
			UICommand.destroy(UICommand.t.ui[UIName.UI_DEFENCE_OPERATION].getChildByName(UIName.PRESENT_DEFENCE_TOWER), UICommand.t.mouseEvent);
			TweenLite.to(UICommand.t.ui[UIName.UI_USER_INFO], 0.4, {alpha:0, onComplete:restoreOrDestroyTC, onCompleteParams:[UICommand.t.ui[UIName.UI_USER_INFO], {remove:false, visible:false}]});
			UICommand.t.stateFirst = "";
		}

		/*到摆塔布防过场动画*/
		public static function defenceTransition(into : Boolean = true) : void {
			var obj : Object;
			if (into) {
				UICommand.t.stateFirst = UIState.DEFENCE;
				if (UICommand.t.stateSecond == UIState.TEST_MAP) {
					UICreate.getTower((UICommand.t.ui[UIName.UI_DEFENCE_OPERATION] as Object).dataTower);
					UICreate.getDefence(UICommand.t.mapData);
					UICommand.t.stateSecond = "";
				} else {
					UICommand.uiDataTransfer([{m:UIDataFunList.GET_TOWER, a:[UICommand.t.userData[0], UICommand.t.userData[1][0]]}, {m:UIDataFunList.GET_DEFENCE, a:[UICommand.t.userData[0], UICommand.t.userData[1][0], UICommand.t.mapData.mapId]}]);
				}

				var ObjClass : Class = UICommand.getClass(UIClass.ANIMATION_INSIDE_LOADING);
				obj = new ObjClass();
				UICommand.t.addChild(obj as DisplayObject);
				TweenLite.from(obj, 0.2, {alpha:0, onComplete:transitionTC});
			} else {
				obj = UICommand.t.getChildAt(UICommand.t.numChildren - 1);
				TweenLite.to(obj, 0.2, {alpha:0, onComplete:restoreOrDestroyTC, onCompleteParams:[obj]});
				_inDefence();
			}
		}

		/*从派兵界面到摆塔布防界面*/
		public static function selectAttackRoleToDefence() : void {
			_outSelectAttackRole();
			defenceTransition();
		}

		/*从战斗界面到摆塔布防界面*/
		public static function progressToDefence() : void {
			_outWarProgress();
			defenceTransition();
		}

		/*从选择地图到摆塔布防界面*/
		public static function selectMapToDefence() : void {
			// UICommand.removeSyncServerTimeTimer();
			_outSelectMap();
			defenceTransition();
		}

		/*雇佣英雄卡片飞往已雇佣框*/
		public static function hireHeroToHadTC(par : Sprite, o : Sprite) : void {
			var had : Sprite = par.getChildAt(0) as Sprite;
			var point : Point = had.globalToLocal(new Point(o.x, o.y));
			o.x = point.x;
			o.y = point.y;
			had.addChild(o as Sprite);
			UICreate.addSmallBTN(par.getChildAt(1) as Sprite, UIClass.CARD_GEAR, o.x + 36, o.y + 70);
		}

		/*踢出出兵框角色飞回到选兵框*/
		public static function expendableToRoleScrollTC(form : DisplayObject, to : Object) : void {
			UICommand.destroy(form);
			/*卡片已经飞回，启用*/
			to.common.disable.visible = false;
			to.useHandCursor = true;
			if (to.dataPower != null || (UICommand.t.expendableData && UICommand.t.expendableData[1] && UICommand.t.expendableData[1].length == (UICommand.t.openLockNum - 1))) UICommand.changeAttackRoleCard(to.parent as Sprite);
			// UICommand.changeAttackRoleCardDisable(to.parent as Sprite, false);
		}

		/*如踢出角色不是出兵框最后一个，出兵框其他角色往前移*/
		public static function expendableForward(o : DisplayObject, par : Object) : void {
			// var sp : Sprite = UICommand.t.getChildByName(UIName.PRESENT_EXPENDABLE) as Sprite;
			(UICommand.t.ui[UIName.UI_SELECT_ATTACK_ROLE] as Object).dataTC = true;
			var num : uint = par.numChildren;
			var next : uint = par.getChildIndex(o) + 1;
			var offset : int = o.x - par.getChildAt(next).x;
			for (var i : uint = next; i < num; i++) {
				TweenLite.to(par.getChildAt(i), 0.4, {x:String(offset), onComplete:_expendableForwardTC});
			}
		}

		private static function _expendableForwardTC() : void {
			(UICommand.t.ui[UIName.UI_SELECT_ATTACK_ROLE] as Object).dataTC = null;
		}

		/*选择选兵框角色飞到出兵框里调整位置顺序*/
		public static function roleScrollToExpendableTC(o : DisplayObject) : void {
			var sp : Sprite = UICommand.t.getChildByName(UIName.PRESENT_EXPENDABLE) as Sprite;
			sp.addChild(o);
			UICommand.convertButtonMode(o as Sprite);
			if (o.name.indexOf(UIName.XML_HERO + UIName.CHAR_UNDERLINE) != -1) {
				sp.setChildIndex(o, 0);
				UICreate.addSmallBTN(UICommand.t.getChildByName(UIName.PRESENT_HERO_ATTRIBUTE) as Sprite, UIClass.CARD_GEAR, o.x + 36, o.y + 70);
			}
			(UICommand.t.ui[UIName.UI_SELECT_ATTACK_ROLE] as Object).dataTC == null;
		}

		/*出兵框CD时间*/
		public static function expendableCD(o : DisplayObjectContainer) : void {
			var mapCD : uint = uint(UIXML.mapXML.maps.(@id == UICommand.t.mapData.mapId).cdTime[0]);
			var roleCD : uint;
			var cdTime : uint;
			var max : uint = o.parent.numChildren;
			var childObj : Object;
			var have : uint;
			var ObjClass : Class;
			var cdBox : MovieClip;
			var timelineLite : TimelineLite;
			for (var i : uint = 0; i < max; i++) {
				childObj = o.parent.getChildAt(i);
				try {
					if (childObj.common) {
						have = animationGreenSock(UICommand.t.timelineLites, 2, childObj);
						if (have) continue;
						childObj.removeEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
						childObj.useHandCursor = false;
						if (childObj.name.indexOf(UIName.XML_HERO + UIName.CHAR_UNDERLINE) != -1) {
							roleCD = uint(UIXML.heroXML.hero.(@id == childObj.dataID).cdTime[0]);
						}
						if (childObj.name.indexOf(UIName.XML_SOLDIER + UIName.CHAR_UNDERLINE) != -1) {
							roleCD = uint(UIXML.soldierXML.soldier.(@id == childObj.dataID).cdTime[0]);
						}
						cdTime = mapCD;
						if (roleCD > mapCD && childObj == o) {
							cdTime = roleCD;
						}
						ObjClass = UICommand.getClass(UIClass.CARD_CD_ANIMATION);
						cdBox = new ObjClass();
						cdBox.name = UIClass.CARD_CD_ANIMATION;
						childObj.addChild(cdBox);
						if (childObj.common.disable.visible && childObj != o) cdTime = mapCD;
						cdBox.cd.gotoAndStop(1);
						timelineLite = new TimelineLite({onComplete:_cdEndTC, onCompleteParams:[childObj]});
						timelineLite.appendMultiple([TweenLite.to(cdBox.cd, cdTime, {frameLabel:UIName.F_START, ease:Sine.easeIn}), TweenLite.to(cdBox.cd, 0.2, {frameLabel:UIName.F_END})], 0, TweenAlign.SEQUENCE);
						timelineLite.data = childObj;
						UICommand.t.timelineLites.push(timelineLite);
					}
				} catch (error : Error) {
					trace(error.toString());
				}
			}
		}

		/*卡片CD*/
		private static function _cdEndTC(o : Object) : void {
			var num : uint = UICommand.getPaperNum();
			if (o.common.disable.visible) {
				if (uint(o.common.money.text) <= num) {
					o.common.disable.visible = false;
					o.useHandCursor = true;
					o.addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
				}
			} else {
				o.addEventListener(MouseEvent.CLICK, UICommand.t.mouseEvent);
				o.useHandCursor = true;
			}
			o.removeChildAt(o.numChildren - 1);
			var index : uint = animationGreenSock(UICommand.t.timelineLites, 3, o);
			UICommand.t.timelineLites[index].data = null;
			UICommand.t.timelineLites[index] = null;
			UICommand.t.timelineLites.splice(index, 1);
		}

		/*英雄技能卡片*/
		public static function heroSkillCardTC(temp : Sprite, skill : Sprite, remove : Sprite) : void {
			skill.x = temp.x - 35;
			skill.y = temp.y;
			var p : Sprite = temp.parent as Sprite;
			p.addChildAt(skill, 0);
			p.removeChild(temp);
			remove.parent.removeChild(remove);
			UICommand.changeHeroSkillCard(skill);
		}

		/*英雄技能卡片CD*/
		public static function heroSkillCDTC(o : Object) : void {
			UICommand.changeHeroSkillCard(o, false);
		}

		/*战斗结果奖励动画*/
		public static function resultsTween(sp : Sprite, time : Number, content : Object) : void {
			TweenLite.to(sp, time, {frameLabel:UIName.F_END, onComplete:resultsRewardTC, onCompleteParams:[content]});
			TweenLite.from(sp, 0.2, {x:"-100", y:"-200", scaleX:20, scaleY:20});
			TweenLite.from(content.parent, 0.2, {x:"-4", y:"-4", ease:Elastic.easeOut});
		}

		/*战斗结果奖励动画完成*/
		public static function resultsRewardTC(content : Object) : void {
			var obj : Object = content.parent;
			if (content.visible) {
				var buffExp : uint = 0;
				if (UICommand.t.stateSecond != UIState.PVE) {
					buffExp = obj.dataObj[1].dataBuffExp;
					if (buffExp) {
						content.langExperience.txt.textColor = 0xFF0000;
						UICommand.addEasyHit(content.langExperience, String(UIXML.uiXML.warResults.buff.info[0]).replace(UIName.VAR_A, obj.dataObj[1].dataBuffExpName).replace(UIName.VAR_B, buffExp), true);
					}
				}
				obj.dataObj[1].dataExp += buffExp;
				content.langExperience.txt.text = obj.dataObj[1].dataExp;
				content.langCap.text = obj.dataObj[1].dataCap;
			}
			obj.close.comp.enabled = true;
			if (UICommand.t.stateSecond == "" && obj.dataObj[3]) {
				var again : Object = obj.again;
				again.txt1.text = String(UIXML.uiXML.warResults.again[0]);
				again.txt2.text = String(UIXML.uiXML.phrase.need[0]);
				again.txt3.text = String(UIXML.levelXML.relate.againPrice[0]);
				TweenLite.to(again, 0.2, {y:"158", autoAlpha:1});
				TweenLite.to(obj, 0.2, {y:"-79"});
			}
		}

		/*抽奖翻牌动画*/
		public static function lotteryTM(target : Object, currentTarget : Object) : void {
			currentTarget.dataObj.dataItemSum--;
			var num : uint = currentTarget.dataObj.dataItemSum;
			currentTarget.num.txt.text = num;
			/*奖品容器*/
			var box : Sprite = currentTarget.box;
			/*抽奖按钮*/
			var lottery : Sprite = currentTarget.lottery;
			var index : uint = lottery.getChildIndex(target as Sprite);
			var fake : Sprite = box.getChildAt(index) as Sprite;
			var obj : Object;
			var goods : Array = currentTarget.dataGoods;
			var end : int = goods.length - 1;
			for (var j : int = end; j > -1; j--) {
				if ((goods[j].icon.getChildAt(0).filters[0] is GlowFilter)) {
					goods.splice(j, 1);
				} else {
					obj = goods[j];
					break;
				}
			}
			if (fake != obj) {
				var fakeXY : Point = new Point(fake.x, fake.y);
				var objXY : Point = new Point(obj.x, obj.y);
				obj.x = fakeXY.x;
				obj.y = fakeXY.y;
				fake.x = objXY.x;
				fake.y = objXY.y;
				box.swapChildren(obj as Sprite, fake);
			}
			TweenLite.to(target, 0.2, {transformMatrix:{skewY:-90}, onComplete:restoreOrDestroyTC, onCompleteParams:[obj, {remove:false, visible:true}]});
			TweenLite.to(obj, 0.2, {transformMatrix:{skewY:0}, delay:0.2});
			var glowFilter : GlowFilter = new GlowFilter(0xFFFF00, 1, 6, 6, 5);
			obj.icon.getChildAt(0).filters = [glowFilter];
			currentTarget.dataObj.dataSave[1].push(obj.data);
			if (num == 0) {
				var childA : Object;
				var childB : Object;
				for (var i : uint = 0; i < 9; i++) {
					childA = lottery.getChildAt(i);
					childB = box.getChildAt(i);
					if (!(childB.icon.getChildAt(0).filters[0] is GlowFilter)) {
						TweenLite.to(childA, 0.2, {transformMatrix:{skewY:-90}, onComplete:restoreOrDestroyTC, onCompleteParams:[childB, {remove:false, visible:true}]});
						TweenLite.to(childB, 0.2, {transformMatrix:{skewY:0}, delay:0.2});
					}
				}
				UICommand.remvoeEasyHit([currentTarget.submit]);
			}
		}

		/*去掉遮挡，加上背景，去掉顶栏用户信息栏*/
		private static function _removeShieldAddSubstrateRemoveUserInfo() : void {
			UICommand.removeShield(4);
			UICreate.addSubstrate(4);
			TweenLite.to(UICommand.t.ui[UIName.UI_USER_INFO], 0.4, {alpha:0, onComplete:restoreOrDestroyTC, onCompleteParams:[UICommand.t.ui[UIName.UI_USER_INFO], {remove:false, visible:false}]});
		}

		/*对于注册点在左上角的对象，需要改变注册点而实现的动画，现在主要是实现居中缩放，将来可扩展*/
		private static function needChangeRegPointTween(obj : DisplayObject, cX : Number, cY : Number, newX : Number, newY : Number, restore : Boolean = false) : void {
			var originalPar : DisplayObjectContainer = obj.parent as DisplayObjectContainer;
			var originalX : Number = obj.x;
			var originalY : Number = obj.y;
			var container : Sprite = new Sprite();
			container.x = cX;
			container.y = cY;
			obj.x = newX;
			obj.y = newY;
			var i : uint = UICommand.t.getChildIndex(obj);
			UICommand.t.addChildAt(container, i);
			container.addChild(obj);
			if (restore) {
				TweenLite.to(container, 0.4, {alpha:0, scaleX:0, scaleY:0, onComplete:restoreOrDestroyTC, onCompleteParams:[obj, {par:originalPar, x:originalX, y:originalY, index:i}]});
			} else {
				TweenLite.from(container, 0.4, {alpha:0, scaleX:0, scaleY:0, delay:0.2, onComplete:restoreOrDestroyTC, onCompleteParams:[obj, {par:originalPar, x:originalX, y:originalY, index:i, remove:false}]});
			}
		}

		/*timeline或tween动画数组方法，暂停0，播放1，返回对象是否正有动画在执行2，返回当前对象的动画索引3*/
		public static function animationGreenSock(vector : Object, type : uint, obj : Object = null) : uint {
			var max : uint = vector.length;
			for (var i : uint = 0; i < max; i++) {
				if (obj != null) {
					if (vector[i].data == obj) {
						switch (type) {
							case 2:
								return 1;
								break;
							case 3:
								return i;
								break;
						}
					}
				}
				switch (type) {
					case 0:
						vector[i].pause();
						break;
					case 1:
						vector[i].play();
						break;
				}
			}
			return 0;
		}

		/*分页向左向右向上向下动画完后是否到了最顶或最底，是则按钮禁用*/
		public static function pagesTC(type : String, btnA : Object, btnB : Object, num : uint = 0, max : uint = 0) : void {
			if ((type == UIName.E_PREV || type == UIName.E_UP) && num == 1) {
				btnA.comp.enabled = false;
				btnB.comp.enabled = true;
			} else if ((type == UIName.E_NEXT || type == UIName.E_DOWN) && num == max) {
				btnA.comp.enabled = true;
				btnB.comp.enabled = false;
			}

			// switch (type) {
			// case UIName.E_PREV:
			// if (num == 1) {
			// btnA.comp.enabled = false;
			// btnB.comp.enabled = true;
			// }
			// break;
			// case UIName.E_NEXT:
			// if (num == max) {
			// btnA.comp.enabled = true;
			// btnB.comp.enabled = false;
			// }
			// break;
			// case UIName.E_UP:
			//					//  if (content.y == mask.y) {
			// if (content.y == mask.y) {
			// btnA.comp.enabled = false;
			// btnB.comp.enabled = true;
			// }
			// break;
			// case UIName.E_DOWN:
			//					//  if (content.y == mask.y - (content.height / mask.height - 1) * mask.height) {
			// if (content.y == mask.y - (content.height / mask.height - 1) * mask.height) {
			// btnA.comp.enabled = true;
			// btnB.comp.enabled = false;
			// }
			// break;
			// }
		}

		/*tween动画完成后恢复初始状态，然后移除对象或者销毁*/
		public static function restoreOrDestroyTC(o : DisplayObject, vars : Object = null) : void {
			if (o == UICommand.t.ui[UIName.UI_SELECT_MAP]) {
				UICommand.t.ui[UIName.UI_SELECT_MAP].removeChildAt(9);
				UICommand.t.ui[UIName.UI_SELECT_MAP].removeChildAt(0);
			}
			if (vars == null) vars = {};
			var child : DisplayObject = (vars.c == null) ? o : vars.c;
			if (vars.par != null) {
				var container : Sprite = o.parent as Sprite;
				vars.par.addChildAt(o, vars.index);
				UICommand.t.removeChild(container);
			}
			if (vars.visible != null) child.visible = vars.visible;
			var remove : Boolean = (vars.remove == null) ? true : vars.remove;
			if (remove) {
				child.visible = true;
				child.alpha = 1;
				child.scaleX = 1;
				child.scaleY = 1;
				if (vars.x == null) o.x = 0;
				if (vars.y == null) o.y = 0;
			}
			if (vars.x != null) o.x = vars.x;
			if (vars.y != null) o.y = vars.y;
			var rec : Boolean = (vars.rec == null) ? false : vars.rec;
			if (vars.m != null || vars.f != null || remove) {
				if (UICommand.t.scrollBar != null && UICommand.t.scrollBar.parentMC == child) {
					UICommand.destroyScroll();
				} else {
					UICommand.destroy(child, vars.m, vars.f, rec, remove);
				}
			}
		}
	}
}
