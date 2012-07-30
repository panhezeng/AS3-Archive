package com.raytoon.cannonfodder.tools.utils {
	import com.raytoon.cannonfodder.tools.xml.XMLSource;

	/**
	 * @author Administrator
	 */
	public class UIXML {
		/*XML文件容器*/
		private static var _uiXML : XML;
		private static var _gameGuideXML : XML;
		private static var _levelXML : XML;
		private static var _mapXML : XML;
		private static var _soldierXML : XML;
		private static var _soldierTechTreeXML : XML;
		private static var _soldierLevelXML : XML;
		private static var _soldierSkillXML : XML;
		private static var _heroXML : XML;
		private static var _heroNameRaceXML : XML;
		private static var _heroSkillXML : XML;
		private static var _heroLevelXML : XML;
		private static var _towerXML : XML;
		private static var _towerTechTreeXML : XML;
		private static var _towerLevelXML : XML;
		private static var _towerSkillXML : XML;
		private static var _propXML : XML;
		private static var _materialXML : XML;
		private static var _gemXML : XML;
		private static var _equipmentXML : XML;
		private static var _mainTaskXML : XML;
		private static var _apiXML : XML;
		private static var _annXML : XML;
		private static var _eventXML : XML;
		private static var _giftBagXML : XML;

		public static function get uiXML() : XML {
			_uiXML = XMLSource.getXMLSource(UIName.XML_UI + UIName.XML_SUFFIX);
			return _uiXML;
		}

		public static function get gameGuideXML() : XML {
			_gameGuideXML = XMLSource.getXMLSource(UIName.XML_GAME_GUIDE + UIName.XML_SUFFIX);
			return _gameGuideXML;
		}

		static public function get levelXML() : XML {
			_levelXML = XMLSource.getXMLSource(UIName.XML_LEVEL + UIName.XML_SUFFIX);
			return _levelXML;
		}

		static public function get mapXML() : XML {
			_mapXML = XMLSource.getXMLSource(UIName.XML_MAP + UIName.XML_SUFFIX);
			return _mapXML;
		}

		static public function get soldierXML() : XML {
			_soldierXML = XMLSource.getXMLSource(UIName.XML_SOLDIER + UIName.XML_SUFFIX);
			return _soldierXML;
		}

		static public function get soldierTechTreeXML() : XML {
			_soldierTechTreeXML = XMLSource.getXMLSource(UIName.XML_SOLDIER_TECH_TREE + UIName.XML_SUFFIX);
			return _soldierTechTreeXML;
		}

		static public function get soldierLevelXML() : XML {
			_soldierLevelXML = XMLSource.getXMLSource(UIName.XML_SOLDIER_LEVEL + UIName.XML_SUFFIX);
			return _soldierLevelXML;
		}

		static public function get soldierSkillXML() : XML {
			_soldierSkillXML = XMLSource.getXMLSource(UIName.XML_SOLDIER_SKILL + UIName.XML_SUFFIX);
			return _soldierSkillXML;
		}

		static public function get heroXML() : XML {
			_heroXML = XMLSource.getXMLSource(UIName.XML_HERO + UIName.XML_SUFFIX);
			return _heroXML;
		}

		static public function get heroNameRaceXML() : XML {
			_heroNameRaceXML = XMLSource.getXMLSource(UIName.XML_HERO_NAME_RACE + UIName.XML_SUFFIX);
			return _heroNameRaceXML;
		}

		static public function get heroSkillXML() : XML {
			_heroSkillXML = XMLSource.getXMLSource(UIName.XML_HERO_SKILL + UIName.XML_SUFFIX);
			return _heroSkillXML;
		}

		static public function get heroLevelXML() : XML {
			_heroLevelXML = XMLSource.getXMLSource(UIName.XML_HERO_LEVEL + UIName.XML_SUFFIX);
			return _heroLevelXML;
		}

		static public function get towerXML() : XML {
			_towerXML = XMLSource.getXMLSource(UIName.XML_TOWER + UIName.XML_SUFFIX);
			return _towerXML;
		}

		static public function get towerTechTreeXML() : XML {
			_towerTechTreeXML = XMLSource.getXMLSource(UIName.XML_TOWER_TECH_TREE + UIName.XML_SUFFIX);
			return _towerTechTreeXML;
		}

		static public function get towerLevelXML() : XML {
			_towerLevelXML = XMLSource.getXMLSource(UIName.XML_TOWER_LEVEL + UIName.XML_SUFFIX);
			return _towerLevelXML;
		}

		static public function get towerSkillXML() : XML {
			_towerSkillXML = XMLSource.getXMLSource(UIName.XML_TOWER_SKILL + UIName.XML_SUFFIX);
			return _towerSkillXML;
		}

		static public function get propXML() : XML {
			_propXML = XMLSource.getXMLSource(UIName.XML_PROP + UIName.XML_SUFFIX);
			return _propXML;
		}

		static public function get materialXML() : XML {
			_materialXML = XMLSource.getXMLSource(UIName.XML_MATERIAL + UIName.XML_SUFFIX);
			return _materialXML;
		}

		static public function get gemXML() : XML {
			_gemXML = XMLSource.getXMLSource(UIName.XML_GEM + UIName.XML_SUFFIX);
			return _gemXML;
		}

		static public function get equipmentXML() : XML {
			_equipmentXML = XMLSource.getXMLSource(UIName.XML_EQUIPMENT + UIName.XML_SUFFIX);
			return _equipmentXML;
		}

		static public function get mainTaskXML() : XML {
			_mainTaskXML = XMLSource.getXMLSource(UIName.XML_MAIN_TASK + UIName.XML_SUFFIX);
			return _mainTaskXML;
		}

		static public function get apiXML() : XML {
			_apiXML = XMLSource.getXMLSource(UIName.XML_API + UIName.XML_SUFFIX);
			return _apiXML;
		}

		static public function get annXML() : XML {
			_annXML = XMLSource.getXMLSource(UIName.XML_ANN + UIName.XML_SUFFIX);
			return _annXML;
		}

		static public function get eventXML() : XML {
			_eventXML = XMLSource.getXMLSource(UIName.XML_EVENT + UIName.XML_SUFFIX);
			return _eventXML;
		}

		static public function get giftBagXML() : XML {
			_giftBagXML = XMLSource.getXMLSource(UIName.XML_GIFT_BAG + UIName.XML_SUFFIX);
			return _giftBagXML;
		}
	}
}
