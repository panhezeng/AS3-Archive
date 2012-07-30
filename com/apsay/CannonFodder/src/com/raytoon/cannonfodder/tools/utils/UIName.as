package com.raytoon.cannonfodder.tools.utils {
	import com.raytoon.cannonfodder.tools.net.ConstPath;

	/**
	 * @author Administrator
	 */
	public class UIName {
		/*XML文件的名称类型*/
		public static const XML_SUFFIX : String = ".xml";
		public static const XML_UI : String = "UISite";
		public static const XML_GAME_GUIDE : String = "GameGuide";
		public static const XML_LEVEL : String = "LevelInfo";
		public static const XML_SOLDIER : String = "SoldierInfo";
		public static const XML_HERO : String = "HeroInfo";
		public static const XML_HERO_NAME_RACE : String = "HeroNameRace";
		public static const XML_HERO_SKILL : String = "HeroSkillsInfo";
		public static const XML_HERO_LEVEL : String = "HeroLevelInfo";
		public static const XML_TOWER : String = "TowerInfo";
		public static const XML_MAP : String = "MapInfo";
		public static const XML_PROP : String = "Props";
		public static const XML_MATERIAL : String = "Materials";
		public static const XML_GEM : String = "GemSkills";
		public static const XML_EQUIPMENT : String = "Equipment";
		public static const XML_SOLDIER_TECH_TREE : String = "SoldierTechTree";
		public static const XML_SOLDIER_LEVEL : String = "SoldierLevelInfo";
		public static const XML_SOLDIER_SKILL : String = "SoldierSkillsInfo";
		public static const XML_TOWER_TECH_TREE : String = "TowerTechTree";
		public static const XML_TOWER_LEVEL : String = "TowerLevelInfo";
		public static const XML_TOWER_SKILL : String = "TowerSkillsInfo";
		public static const XML_MAIN_TASK : String = "MainTaskInfo";
		public static const XML_API : String = "API";
		public static const XML_ANN : String = "ANN";
		public static const XML_EVENT : String = "Event";
		public static const XML_GIFT_BAG : String = "GiftBag";
		/*UI容器的访问名称*/
		public static const UI_USER_INFO : uint = 0;
		public static const UI_USER_SET : uint = 1;
		public static const UI_MAP_NAME : uint = 2;
		public static const UI_MAIN_NAV : uint = 3;
		public static const UI_SECONDARY_NAV : uint = 4;
		public static const UI_FRIEND : uint = 5;
		public static const UI_SELECT_RIVAL : uint = 6;
		public static const UI_SELECT_ATTACK_ROLE : uint = 7;
		public static const UI_DEADLINE : uint = 8;
		public static const UI_STOP_PLAY : uint = 9;
		public static const UI_SELECT_MAP : uint = 10;
		public static const UI_DEFENCE_OPERATION : uint = 11;
		public static const UI_HERO : uint = 12;
		public static const UI_DOSSIER : uint = 13;
		public static const UI_TECH : uint = 14;
		public static const UI_BAG : uint = 15;
		public static const UI_SHOP : uint = 16;
		public static const UI_HANDBOOK : uint = 17;
		public static const UI_TAX : uint = 18;
		public static const UI_TOP : uint = 19;
		public static const UI_REPORT : uint = 20;
		public static const UI_TASK : uint = 21;
		/*每次请求后根据数据生成的容器，用完后销毁*/
		public static const PRESENT_RIVAL_TOWER : String = "presentRivalTower";
		public static const PRESENT_ATTACK_HERO : String = "presentAttackHero";
		public static const PRESENT_ATTACK_SOLDIER : String = "presentAttackSoldier";
		public static const PRESENT_DEFENCE_TOWER : String = "presentDefenceTower";
		public static const PRESENT_EXPENDABLE : String = "presentExpendable";
		public static const PRESENT_BAG : String = "presentBag";
		public static const PRESENT_HERO_ATTRIBUTE : String = "presentHeroAttribute";
		public static const PRESENT_HERO_REFRESH : String = "presentHeroRefresh";
		public static const PRESENT_HAD_HERO : String = "presentHadHero";
		public static const PRESENT_BUY_SOLDIER : String = "presentBuySoldier";
		public static const PRESENT_HAD_SOLDIER : String = "presentHadSoldier";
		/*事件逻辑判断时用到的字符窜*/
		/*实例名*/
		public static const E_NO_USER : String = "-1";
		public static const E_NAV : String = "nav";
		public static const E_DISABLE : String = "disable";
		public static const E_LEVEL : String = "level";
		public static const E_CAP : String = "cap";
		public static const E_MONEY : String = "money";
		public static const E_TOKEN : String = "token";
		public static const E_CONTENT : String = "content";
		public static const E_DEFENCE : String = "defence";
		public static const E_PVE : String = "pve";
		public static const E_WAR_START : String = "warStart";
		public static const E_DEFENCE_START : String = "defenceStart";
		public static const E_HERO_START : String = "heroStart";
		public static const E_SOLDIER_START : String = "soldierStart";
		public static const E_TECH_START : String = "techStart";
		public static const E_TAX_START : String = "taxStart";
		public static const E_TRADE_START : String = "tradeStart";
		public static const E_OPEN_SHOP : String = "openShop";
		public static const E_OPEN_BAG : String = "openBag";
		public static const E_OPEN_HANDBOOK : String = "openHandbook";
		public static const E_OPEN_GIFT_BAG : String = "openGiftBag";
		public static const E_OPEN_TASK : String = "openTask";
		public static const E_OPEN_ACTIVTITY : String = "openActivity";
		public static const E_OPEN_ANNOUNCEMENT : String = "openAnnouncement";
		public static const E_OPEN_FRIEND : String = "openFriend";
		public static const E_OPEN_REPORT : String = "openReport";
		public static const E_OPEN_TOP : String = "openTop";
		public static const E_OPEN_DOSSIER : String = "openDossier";
		public static const E_SUBMIT : String = "submit";
		public static const E_CLOSE : String = "close";
		public static const E_REFRESH : String = "refresh";
		public static const E_STOP_WAR : String = "stopWar";
		public static const E_PLAY_WAR : String = "playWar";
		public static const E_GO_WAR : String = "goWar";
		public static const E_MUSIC : String = "music";
		public static const E_SOUND_EFFECT : String = "soundEffect";
		public static const E_HP : String = "HP";
		public static const E_GRID : String = "grid";
		public static const E_UP : String = "up";
		public static const E_DOWN : String = "down";
		public static const E_PREV : String = "prev";
		public static const E_NEXT : String = "next";
		public static const E_LEFT : String = "left";
		public static const E_RIGHT : String = "right";
		public static const E_REMOVE : String = "remove";
		public static const E_ATTRIBUTE : String = "attribute";
		public static const E_ALL : String = "all";
		public static const E_SOLDIER : String = "soldier";
		public static const E_TOWER : String = "tower";
		public static const E_TEST : String = "test";
		public static const E_RECEIVE : String = "receive";
		public static const E_PLAYBACK : String = "playback";
		public static const E_LOTTERY : String = "lottery";
		public static const E_BOX : String = "box";
		public static const E_LOCK : String = "lock";
		public static const E_SALE : String = "sale";
		public static const E_RECHARGE : String = "recharge";
		public static const E_GUIDE : String = "guide";
		public static const E_BG : String = "bg";
		public static const E_ICON : String = "icon";
		public static const E_SCORE : String = "score";
		public static const E_SCROLL_THUMB : String = "scrollThumb";
		public static const E_GIFT_GOODS_HIGH : String = "GiftGoodsHigh";
		public static const E_GIFT_GOODS_LOW : String = "GiftGoodsLow";
		public static const E_GIFT_HERO : String = "GiftHero";
		public static const E_GIFT : String = "Gift";
		public static const E_TASK : String = "task";
		/*实例名中包含字符*/
		public static const E_INSTANCE : String = "instance";
		public static const E_POPUP : String = "popup";
		public static const E_PROP : String = "Prop";
		public static const E_MATERIAL : String = "Material";
		public static const E_GEM : String = "Gem";
		public static const E_EQUIPMENT : String = "Equip";
		public static const E_ADD : String = "add";
		public static const E_APPRAISE : String = "Appraise";
		public static const E_REPLACE_DISABLE_HIT : String = "replaceDisableHit";
		public static const E_PAGE : String = "page";
		public static const E_GOODS : String = "goods";
		/*字体名*/
		public static const FONT_ART : String = "DFHaiBaoW12-GB";
		public static const FONT_SHOW_CARD : String = "Showcard Gothic";
		/*帧标签*/
		public static const F_START : String = "start";
		public static const F_END : String = "end";
		/*常用字符*/
		public static const CHAR_AND : String = "&";
		public static const CHAR_UNDERLINE : String = "_";
		public static const CHAR_ELLIPSIS : String = "…";
		public static const CHAR_SlASH : String = "/";
		public static const CHAR_BREAK : String = "\n";
		public static const CHAR_RETURN_WRAP : String = "\r\n";
		/*数据类型方法名*/
		public static const UI_GET_DATA : String = "UIGetData";
		public static const UI_SAVE_DATA : String = "UISaveData";
		/*JS方法名*/
		public static const JS_LOAD_COMPLETE : String = "jsLoadComplete";
		public static const JS_GAMERS : String = "jsGamers";
		public static const JS_ERROR : String = "jsError";
		public static const JS_PAY : String = "jsPay";
		public static const JS_INVITE : String = "jsInvite";
		public static const JS_FEED : String = "jsFeed";
		public static const JS_SYS : String = "jsSys";
		public static const JS_SEND_TO_AS : String = "jsSendToAS";
		/*变量标签*/
		public static const VAR_A : String = "{_VAR_A_}";
		public static const VAR_B : String = "{_VAR_B_}";
		/*HTML模板标签*/
		public static const REGEXP_BR : RegExp = /{_HTML_BR_}/g;
		public static const REGEXP_RED_A : RegExp = /{_HTML_RED_A_}/g;
		public static const REGEXP_RED_B : RegExp = /{_HTML_RED_B_}/g;
		public static const HTML_BR : String = "{_HTML_BR_}";
		public static const HTML_RED_A : String = "{_HTML_RED_A_}";
		public static const HTML_RED_B : String = "{_HTML_RED_B_}";
		/*API替换内容模板标签*/
		public static const API_APPRAISE : String = "{_APPRAISE_}";
		public static const API_RIVAL : String = "{_RIVAL_}";
		public static const API_TECH_ICON : String = "{_TECH_ICON_}";
		public static const API_TECH_NAME : String = "{_TECH_NAME_}";
		public static const API_TECH_LEVEL : String = "{_TECH_LEVEL_}";
		public static const API_TASK_NAME : String = "{_TASK_NAME_}";
		public static const API_MAP_NAME : String = "{_MAP_NAME_}";
	}
}
