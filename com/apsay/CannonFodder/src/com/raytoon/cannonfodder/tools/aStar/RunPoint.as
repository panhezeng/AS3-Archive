package com.raytoon.cannonfodder.tools.aStar 
{
	/**
	 * 行走 步进点 ，距离 
	 * @author ...
	 */
	public class RunPoint 
	{
		
		public var x:Number = 0;
		public var y:Number = 0;
		public var state:int = 0;// 0:正常行走；1：加速行走；2：加速行走
		public var commonX:Number = 0;//步进 X
		public var commonY:Number = 0;//步进 Y
		public var downX:Number = 0; //步进 减速 距离 X
		public var downY:Number = 0;// 步进 减速 距离 Y
		public var upX:Number = 0; //步进 加速 距离 X
		public var upY:Number = 0; //步进 加速 距离 Y
		public function RunPoint(commonX:Number, commonY:Number, downX:Number = 0, downY:Number = 0,upX:Number = 0,upY:Number = 0) 
		{
			this.commonX = commonX;
			this.commonY = commonY;
			this.downX = downX;
			this.downY = downY;
			this.upX = upX;
			this.upY = upY;
		}
		
	}

}