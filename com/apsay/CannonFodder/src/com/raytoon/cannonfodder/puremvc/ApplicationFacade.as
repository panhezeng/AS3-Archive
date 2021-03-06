///////////////////////////////////////////////////////////
//  ApplicationFacade.as
//  Macromedia ActionScript Implementation of the Class ApplicationFacade
//  Generated by Enterprise Architect
//  Created on:      01-六月-2011 10:50:07
//  Original author: LuXianli
///////////////////////////////////////////////////////////

package com.raytoon.cannonfodder.puremvc
{
	import com.raytoon.cannonfodder.puremvc.controller.StartupCommand;
	import com.raytoon.cannonfodder.puremvc.view.ui.UIMain;
	
	import org.puremvc.as3.patterns.facade.Facade;

	/**
	 * @author LuXianli
	 * @version 1.0
	 * @created 01-六月-2011 10:50:07
	 */
	public class ApplicationFacade extends Facade
	{
		public static const STARTUP:String = "startUp";//框架启动通知
		public function ApplicationFacade(){

		}
		
		public static function getInstance() : ApplicationFacade 
		{
			if (instance == null) 
				instance = new ApplicationFacade();
			return instance as ApplicationFacade;
		}
		
		public function startup( app:UIMain):void
		{
			sendNotification( STARTUP, app );
		}
		
		override protected function initializeController( ) : void 
		{
			super.initializeController();
			registerCommand(STARTUP,StartupCommand);
			
		}

	}//end ApplicationFacade

}