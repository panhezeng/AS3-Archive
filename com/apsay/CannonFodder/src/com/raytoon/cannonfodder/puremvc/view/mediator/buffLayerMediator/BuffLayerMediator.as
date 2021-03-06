///////////////////////////////////////////////////////////
//  BuffLayerMediator.as
//  Macromedia ActionScript Implementation of the Class BuffLayerMediator
//  Generated by Enterprise Architect
//  Created on:      29-九月-2011 14:59:49
//  Original author: LuXianli
///////////////////////////////////////////////////////////

package com.raytoon.cannonfodder.puremvc.view.mediator.buffLayerMediator
{
	import com.raytoon.cannonfodder.puremvc.view.ui.buffLayer.BuffLayer;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	/**
	 * @author LuXianli
	 * @version 1.0
	 * @created 29-九月-2011 14:59:49
	 */
	public class BuffLayerMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "BuffLayerMediator";
		public function BuffLayerMediator(viewComponent:BuffLayer){
			super(NAME, viewComponent);
		}
		
		public function get buffLayer():BuffLayer {
			return viewComponent as BuffLayer;
		}
		
		override public function onRegister():void 
		{
			
		}
		
		override public function listNotificationInterests():Array 
		{
			return [];
		}
		
		override public function handleNotification(notification:INotification):void 
		{
			
		}
	}//end BuffLayerMediator

}