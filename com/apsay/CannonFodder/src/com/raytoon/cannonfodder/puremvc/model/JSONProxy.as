package com.raytoon.cannonfodder.puremvc.model {
	import com.raytoon.cannonfodder.puremvc.controller.LoadOtherXmlCommand;
	import com.raytoon.cannonfodder.tools.json.JSON;
	import com.raytoon.cannonfodder.tools.net.ClientSocket;
	import com.raytoon.cannonfodder.tools.net.ClientSocketEvent;
	import com.raytoon.cannonfodder.tools.net.ConstPath;
	import com.raytoon.cannonfodder.tools.utils.ProxyNotificationNameList;
	import com.raytoon.cannonfodder.tools.utils.UIClass;
	import com.raytoon.cannonfodder.tools.utils.UICommand;
	import com.raytoon.cannonfodder.tools.utils.UICreate;
	import com.raytoon.cannonfodder.tools.utils.UIDataFunList;
	import com.raytoon.cannonfodder.tools.utils.UIName;
	import com.raytoon.cannonfodder.tools.utils.UIState;
	import com.raytoon.cannonfodder.tools.utils.UIXML;

	import flash.external.ExternalInterface;

	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	/**
	 * @author LuXianli
	 * @version 1.0
	 * @created 02-六月-2011 11:36:12
	 */
	public class JSONProxy extends Proxy implements IProxy {
		private var _server : ClientSocket;
		private var _first : Boolean = true;
		public static const NAME : String = "JSONProxy";
		private var _flushAry : Array = [];

		public function JSONProxy() {
			super(NAME);
			_server = ClientSocket.getInstance();
			_server.addEventListener(ClientSocketEvent.CONNECTED, _socketHandler);
			_server.addEventListener(ClientSocketEvent.DISCONNECTED, _socketHandler);
			_server.addEventListener(ClientSocketEvent.JSON_DATA_OK, _socketHandler);
		}

		private function _socketHandler(event : ClientSocketEvent) : void {
			switch (event.type) {
				case ClientSocketEvent.CONNECTED :
					if (_first) {
						requestData({m:UIDataFunList.GET_USER, a:[ConstPath.SESSION]}, ProxyNotificationNameList.GET_USER);
					}
					break;
				case ClientSocketEvent.DISCONNECTED :
					if (_first) {
						if (ExternalInterface.available) ExternalInterface.call(UIName.JS_ERROR, 0);
					} else if (_flushAry.length != 0 && _flushAry[0][0].m != UIDataFunList.GET_SERVER_TIME) {
						if (ExternalInterface.available) ExternalInterface.call(UIName.JS_ERROR, 2, String(UIXML.uiXML.socketClose[0]));
					} else {
						try {
							if (UICommand.t.stage.getChildAt(UICommand.t.stage.numChildren - 1).name.indexOf(UIClass.POPUP_PROMPT + UIState.SOCKET) == -1) UICreate.popupPrompt(String(UIXML.uiXML.socketDisconnect[0]), UIState.SOCKET);
						} catch (error : Error) {
							if (ExternalInterface.available) ExternalInterface.call(UIName.JS_ERROR, 0);
							trace(error.toString() + "socket");
						}
					}
					break;
				case ClientSocketEvent.JSON_DATA_OK :
					_resultsData(event.data);
					break;
			}
		}

		private function _resultsData(data : Object) : void {
			var dataObj : Object = JSON.decode(String(data));
			var no : Boolean;
			if ((dataObj is Array) && (dataObj as Array).length == 1 && (dataObj as Array)[0] == UIName.E_NO_USER) no = true;
			switch (_flushAry[0][1]) {
				case ProxyNotificationNameList.GET_USER :
					if (_first) {
						_first = false;
						if (no) {
							if (ExternalInterface.available) ExternalInterface.call(UIName.JS_ERROR, 1);
						} else {
//							var xmlProxy : XMLProxy = facade.retrieveProxy(XMLProxy.NAME) as XMLProxy;
//							xmlProxy.requestMainXml("TDMain.xml");
//							facade.registerCommand(ProxyNotificationNameList.MAIN_XML_RECEIVED, LoadOtherXmlCommand);
							sendNotification(ProxyNotificationNameList.GET_USER, dataObj);
						}
					}
					break;
				case ProxyNotificationNameList.UI_GET_DATA :
					if (no) {
						if (ExternalInterface.available) ExternalInterface.call(UIName.JS_ERROR, 1, String(UIXML.uiXML.noSession[0]));
					} else {
						sendNotification(ProxyNotificationNameList.UI_GET_DATA, dataObj);
					}
					break;
				case ProxyNotificationNameList.UI_SAVE_DATA :
					sendNotification(ProxyNotificationNameList.UI_SAVE_DATA, dataObj);
					break;
			}
			_flushAry.shift();
		}

		public function requestData(obj : Object, dataType : String) : void {
			_flushAry[_flushAry.length] = [obj, dataType];
			var data : String = JSON.encode(obj);
			_server.writeSend(data, ClientSocketEvent.JSON_DATA_OK);
		}
	}
}