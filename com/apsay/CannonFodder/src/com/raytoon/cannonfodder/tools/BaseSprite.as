package com.raytoon.cannonfodder.tools 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class BaseSprite extends Sprite
	{
		/**
		 * 
		 * @param	_selfEnabled  是否支持鼠标事件
		 * @param	_childEnabled  子对象 是否支持鼠标事件
		 * @param	_buttonMode    是否为按钮模式
		 * @param	_cacheAsBitmap  是否打开位图缓存
		 */
		public function BaseSprite(_selfEnabled:Boolean = false, _childEnabled:Boolean = false, _buttonMode:Boolean = false, _cacheAsBitmap:Boolean = true) 
		{
			super();
			this.mouseEnabled=_selfEnabled;
			this.mouseChildren=_childEnabled;
			this.buttonMode = _buttonMode;
			this.cacheAsBitmap=_cacheAsBitmap;
		}
		
	}

}