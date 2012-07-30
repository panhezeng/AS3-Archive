package com.raytoon.cannonfodder.puremvc.view.mediator.toolsLayerMediator {
	import com.raytoon.cannonfodder.puremvc.model.JSONProxy;
	import com.raytoon.cannonfodder.puremvc.view.ui.toolsLayer.ToolsLayer;
	import com.raytoon.cannonfodder.tools.EventBindingData;
	import com.raytoon.cannonfodder.tools.net.ClientSocket;
	import com.raytoon.cannonfodder.tools.utils.EventNameList;
	import com.raytoon.cannonfodder.tools.utils.NotificationNameList;
	import com.raytoon.cannonfodder.tools.utils.ProxyNotificationNameList;
	import com.raytoon.cannonfodder.tools.utils.UIClass;
	import com.raytoon.cannonfodder.tools.utils.UICommand;
	import com.raytoon.cannonfodder.tools.utils.UICreate;
	import com.raytoon.cannonfodder.tools.utils.UIDataFunList;
	import com.raytoon.cannonfodder.tools.utils.UIName;
	import com.raytoon.cannonfodder.tools.utils.UITransition;
	import com.raytoon.cannonfodder.tools.utils.UIXML;

	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	import flash.external.ExternalInterface;

	/**
	 * @author LuXianli
	 * @version 1.0
	 * @created 01-六月-2011 14:24:00
	 */
	public class ToolsLayerMediator extends Mediator implements IMediator {
		public static const NAME : String = "ToolsLayerMediator";
		private var _flushGet : Array = [];
		private var _flushSave : Array = [];

		public function ToolsLayerMediator(viewComponent : ToolsLayer) {
			super(NAME, viewComponent);
		}

		public function get toolsLayer() : ToolsLayer {
			return viewComponent as ToolsLayer;
		}

		override public function onRegister() : void {
			toolsLayer.addEventListener(EventNameList.UI_GET_DATA, _hander);
			toolsLayer.addEventListener(EventNameList.UI_SAVE_DATA, _hander);
		}

		private function _hander(e : EventBindingData) : void {
			if (toolsLayer.lastRequest) toolsLayer.lastRequest[1] = toolsLayer.serverTime;
			switch (e.type) {
				case EventNameList.UI_GET_DATA :
					var len : uint = _flushGet.length;
					var b : Boolean = true;
					if (ClientSocket.getInstance().connected) {
						if (toolsLayer.stage.getChildByName(UIClass.LOADING_SOCKET) == null && e.data.noLoading == null) UICreate.addLoading(UIClass.LOADING_SOCKET);
						if (len > 0 && e.data.m == _flushGet[len - 1]) b = false;
						if (b) {
							e.data.noLoading = null;
							_flushGet.push(e.data.m);
							(facade.retrieveProxy(JSONProxy.NAME) as JSONProxy).requestData(e.data, ProxyNotificationNameList.UI_GET_DATA);
						}
					}
					break;
				case EventNameList.UI_SAVE_DATA :
					_flushSave.push(e.data.m);
					(facade.retrieveProxy(JSONProxy.NAME) as JSONProxy).requestData(e.data, ProxyNotificationNameList.UI_SAVE_DATA);
					break;
			}
		}

		override public function listNotificationInterests() : Array {
			return [ProxyNotificationNameList.GET_USER, NotificationNameList.MAIN_MATERIAL_LOAD_COMPLETE, ProxyNotificationNameList.UI_GET_DATA, ProxyNotificationNameList.UI_SAVE_DATA, NotificationNameList.BACKGROUND_MAP_LOAD_COMPLETE, NotificationNameList.NEW_USER_MOVIE_PLAY_COMPLETE];
		}

		override public function handleNotification(notification : INotification) : void {
			// if (notification.getBody() == UIName.E_NO_USER) {
			// if (ExternalInterface.available) ExternalInterface.call(UIName.JS_ERROR, 1, String(UIXML.uiXML.noSession[0]));
			// return;
			// }
			switch (notification.getName()) {
				case ProxyNotificationNameList.GET_USER:
					toolsLayer.userData = notification.getBody() as Array;
					break;
				case NotificationNameList.MAIN_MATERIAL_LOAD_COMPLETE:
					UICreate.initUI();
					break;
				case NotificationNameList.NEW_USER_MOVIE_PLAY_COMPLETE:
					UICommand.nextGuide();
					break;
				case NotificationNameList.BACKGROUND_MAP_LOAD_COMPLETE:
					if (notification.getBody()) {
						UITransition.warTransition(false);
					} else {
						UITransition.defenceTransition(false);
					}
					break;
				case ProxyNotificationNameList.UI_GET_DATA:
					if (_flushGet.length == 1 && (toolsLayer.stage.getChildByName(UIClass.LOADING_SOCKET) != null)) UICommand.removeLoading();
					switch (_flushGet[0]) {
						case UIDataFunList.GET_SERVER_TIME :
							UICreate.getServerTime(notification.getBody());
							break;
						case UIDataFunList.GET_MONEY:
							UICreate.getMoney(notification.getBody());
							break;
						case UIDataFunList.GET_TOKEN:
							UICreate.getToken(notification.getBody());
							break;
						case UIDataFunList.GET_PAY:
							UICreate.getPay(notification.getBody());
							break;
						case UIDataFunList.GET_FEED_RESULT:
							UICreate.getFeedResult(notification.getBody());
							break;
						case UIDataFunList.GET_BUFF:
							UICreate.getBuff(notification.getBody());
							break;
						case UIDataFunList.GET_BUFF_START:
							UICreate.getBuffStart(notification.getBody());
							break;
						case UIDataFunList.GET_TAX_START_TIME:
							UICreate.getTaxStartTime(notification.getBody());
							break;
						case UIDataFunList.GET_RIVAL :
							UICreate.getRival(notification.getBody());
							break;
						case UIDataFunList.GET_DEFENCE :
							UICreate.getDefence(notification.getBody());
							break;
						case UIDataFunList.GET_ATTACK_ROLE :
							UICreate.getAttackRole(notification.getBody());
							break;
						case UIDataFunList.GET_MAP :
							UICreate.getMap(notification.getBody());
							break;
						case UIDataFunList.GET_TOWER:
							UICreate.getTower(notification.getBody());
							break;
						case UIDataFunList.GET_HERO:
							UICreate.getHero(notification.getBody());
							break;
						case UIDataFunList.GET_HAD_HERO:
							UICreate.getHadHero(notification.getBody());
							break;
						case UIDataFunList.GET_TASK:
							UICreate.getTask(notification.getBody());
							break;
						case UIDataFunList.GET_EVENT_TASKS:
							UICreate.getEventTasks(notification.getBody());
							break;
						case UIDataFunList.GET_GIFT:
							UICreate.getGift(notification.getBody());
							break;
						case UIDataFunList.GET_ANNOUNCEMENT:
							UICreate.getAnnouncement(notification.getBody());
							break;
						case UIDataFunList.GET_TOP:
							UICreate.getTop(notification.getBody());
							break;
						case UIDataFunList.GET_REPORT:
							UICreate.getReport(notification.getBody());
							break;
						case UIDataFunList.GET_REWARD:
							UICreate.getReward(notification.getBody());
							break;
						case UIDataFunList.GET_APPRAISE:
							UICreate.getAppraise(notification.getBody());
							break;
						case UIDataFunList.GET_PLAYBACK:
							UICreate.getPlayback(notification.getBody());
							break;
						case UIDataFunList.GET_TECH:
							UICreate.getTech(notification.getBody());
							break;
						case UIDataFunList.GET_TECH_START_TIME:
							UICreate.getTechStartTime(notification.getBody());
							break;
						case UIDataFunList.GET_BAG:
							UICreate.getBag(notification.getBody());
							break;
						case UIDataFunList.GET_LOTTERY:
							UICreate.getLottery(notification.getBody());
							break;
						case UIDataFunList.GET_SHOP:
							UICreate.getShop(notification.getBody());
							break;
						case UIDataFunList.GET_FRIEND:
							UICreate.getFriend(notification.getBody());
							break;
						case UIDataFunList.GET_DOSSIER:
							UICreate.getDossier(notification.getBody());
							break;
						case UIDataFunList.GET_HANDBOOK:
							UICreate.getHandbook(notification.getBody());
							break;
						default:
							break;
					}
					_flushGet.shift();
					break;
				case ProxyNotificationNameList.UI_SAVE_DATA:
					switch (_flushSave[0]) {
						default:
							trace(notification.getBody());
							break;
					}
					_flushSave.shift();
					break;
			}
		}
	}
}