///////////////////////////////////////////////////////////
//  BackgroundLayerMediator.as
//  Macromedia ActionScript Implementation of the Class BackgroundLayerMediator
//  Generated by Enterprise Architect
//  Created on:      01-六月-2011 14:19:22
//  Original author: LuXianli
///////////////////////////////////////////////////////////

package com.raytoon.cannonfodder.puremvc.view.mediator.backgroundLayerMediator
{
	import com.raytoon.cannonfodder.puremvc.view.ui.backgroundLayer.BackgroundLayer;
	import com.raytoon.cannonfodder.tools.EventBindingData;
	import com.raytoon.cannonfodder.tools.utils.EventNameList;
	import com.raytoon.cannonfodder.tools.utils.NotificationNameList;
	import flash.events.Event;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	/**
	 * @author LuXianli
	 * @version 1.0
	 * @created 01-六月-2011 14:19:22
	 */
	public class BackgroundLayerMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "BackgroundLayerMediator";
		public function BackgroundLayerMediator(viewComponent:BackgroundLayer){
			super(NAME,viewComponent);
		}
		
		public function get backgroundLayer():BackgroundLayer {
			return viewComponent as BackgroundLayer;
		}
		
		override public function onRegister():void 
		{
			backgroundLayer.addEventListener(EventNameList.SHOW_CHAPTER, sendShowChapter);
			backgroundLayer.addEventListener(EventNameList.BACKGROUND_MAP_INFO, sendMapTowerInfo);
		}
		/**
		 * 发送 显示战斗场景的 通知
		 * @param	event
		 */
		private function sendShowChapter(event:Event):void {
			
			//sendNotification(NotificationNameList.SHOW_CHAPTER_INFO);
		}
		/**
		 * 发送 地图 布防完成 信息 通知
		 * @param	event
		 */
		private function sendMapTowerInfo(event:EventBindingData):void {
			
			sendNotification(NotificationNameList.DEPLOYMENT_MAP_INFO, event.data);
		}
		
		override public function listNotificationInterests():Array 
		{
			return [NotificationNameList.DEPLOYMENT_TOWER_INFO,
					NotificationNameList.SHOW_CHAPTER_INFO,
					NotificationNameList.QUIT_WAR,
					NotificationNameList.ANIMATION_COMPLETE];
		}
		
		override public function handleNotification(notification:INotification):void 
		{
			switch (notification.getName()) {
				
				case NotificationNameList.DEPLOYMENT_TOWER_INFO:
					backgroundLayer.addTowers(notification.getBody().towerType as String, notification.getBody().id as int);
				break;
				
				case NotificationNameList.SHOW_CHAPTER_INFO:
					var _mapObj:Object = notification.getBody();
					backgroundLayer.addWarMap(int(_mapObj.mapId), int(_mapObj.materialId));
					//_mapObj = null;
				break;
				
				case NotificationNameList.QUIT_WAR:
					backgroundLayer.removeWarMap();
				break;
				
				case NotificationNameList.ANIMATION_COMPLETE:
					backgroundLayer.sendMapLoadComplete();
				break;
			}
		}

	}//end BackgroundLayerMediator

}