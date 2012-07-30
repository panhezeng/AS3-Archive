package com.raytoon.cannonfodder.puremvc.controller
{
	import com.raytoon.cannonfodder.puremvc.model.JSONProxy;
	import com.raytoon.cannonfodder.puremvc.view.ui.UIMain;
	import com.raytoon.cannonfodder.tools.utils.ProxyNotificationNameList;
	import com.raytoon.cannonfodder.tools.utils.UIDataFunList;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	import flash.display.LoaderInfo;

	/**
	 * @author LuXianli
	 * @version 1.0
	 * @created 02-六月-2011 11:29:42
	 */
	public class InitCommand extends SimpleCommand
	{
		public function InitCommand()
		{
		}

		override public function execute(notification:INotification):void
		{
			try
			{
				var keyStr:String;
				var valueStr:String;
				var paramObj:Object = LoaderInfo(UIMain.getInstance(UIMain.NAME).root.loaderInfo).parameters;
				for(keyStr in paramObj)
				{
					valueStr = String(paramObj[keyStr]);
					trace(valueStr);
				}
			}
			catch (error:Error)
			{
				trace(error.toString());
			}
			// (facade.retrieveProxy(JSONProxy.NAME) as JSONProxy).requestData({m:UIDataFunList.GET_USER, a:[valueStr]}, ProxyNotificationNameList.GET_UI_DATA);
			// var xmlProxy:XMLProxy = facade.retrieveProxy(XMLProxy.NAME) as XMLProxy;
			// xmlProxy.requestMainXml("TDMain.xml");
			// facade.registerCommand(ProxyNotificationNameList.MAIN_XML_RECEIVED, LoadOtherXmlCommand);
		}
	}
}