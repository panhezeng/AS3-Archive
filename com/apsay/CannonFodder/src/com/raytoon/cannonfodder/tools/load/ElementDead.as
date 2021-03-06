///////////////////////////////////////////////////////////
//  ElementDead.as
//  Macromedia ActionScript Implementation of the Class ElementDead
//  Generated by Enterprise Architect
//  Created on:      23-八月-2011 12:10:16
//  Original author: LuXianli
///////////////////////////////////////////////////////////

package com.raytoon.cannonfodder.tools.load
{
	import com.raytoon.cannonfodder.tools.BaseSprite;
	import com.raytoon.cannonfodder.tools.net.ConstPath;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.utils.Timer;
	/**
	 * @author LuXianli
	 * @version 1.0
	 * @created 23-八月-2011 12:10:16
	 */
	public class ElementDead extends BaseSprite
	{
		private var _elementRemove:Function;
		private var _elementDeath:Function;
		private var _elementName:String;
		private var _elementClass:Class;
		private var _elementMovieClip:MovieClip;
		private var _elementLoad:Loader;
		private var _elementFrame:int = 0;
		private var _fixName:String;
		private var _alphTime:int = 30;
		public function ElementDead(elementName:String,elementDeath:Function,elementRemove:Function = null,fixName:String = "",alphTime:int = 30){
			super();
			_elementName = elementName;
			_elementDeath = elementDeath;
			_elementRemove = elementRemove;
			_fixName = fixName;
			_alphTime = alphTime;
			if (ApplicationDomain.currentDomain.hasDefinition(elementName + fixName)) {
				
				_elementClass = ApplicationDomain.currentDomain.getDefinition(elementName + fixName) as Class;
				_elementMovieClip = new _elementClass() as MovieClip;
				_elementMovieClip.gotoAndStop(1);
				addChild(_elementMovieClip);
				_elementFrame = _elementMovieClip.totalFrames;
				addEventListener(Event.ENTER_FRAME, elementAlph);
				_elementDeath();
				_elementMovieClip.gotoAndPlay(1);
			}else {
				
				_elementLoad = new Loader();
				_elementLoad.contentLoaderInfo.addEventListener(Event.COMPLETE, elementLoadComplete);
				_elementLoad.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, elementLoadIOError);
				_elementLoad.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, elementLoadSecurityError);
				
				var _elementUrl:String = ConstPath.MATERIAL_PATH + ConstPath.SWF_PATH + elementName + ConstPath.SWF_SUFFIX;
				var context:LoaderContext = new LoaderContext();
				context.applicationDomain = ApplicationDomain.currentDomain;
				//context.securityDomain = SecurityDomain.currentDomain;
				
				_elementLoad.load(new URLRequest(_elementUrl), context);
			}
		}
		/**
		 * 原件加载完成
		 * @param	event
		 */
		private function elementLoadComplete(event:Event):void {
			
			_elementLoad.contentLoaderInfo.removeEventListener(Event.COMPLETE, elementLoadComplete);
			_elementLoad.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, elementLoadIOError);
			_elementLoad.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, elementLoadSecurityError);
			
			_elementClass = ApplicationDomain.currentDomain.getDefinition(_elementName + _fixName) as Class;
			_elementMovieClip = new _elementClass() as MovieClip;
			_elementMovieClip.gotoAndStop(1);
			addChild(_elementMovieClip);
			_elementFrame = _elementMovieClip.totalFrames;
			addEventListener(Event.ENTER_FRAME, elementAlph);
			_elementDeath();
			_elementMovieClip.gotoAndPlay(1);
			
		}
		
		private function elementLoadIOError(event:IOErrorEvent):void {
			_elementLoad.contentLoaderInfo.removeEventListener(Event.COMPLETE, elementLoadComplete);
			_elementLoad.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, elementLoadIOError);
			_elementLoad.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, elementLoadSecurityError);
		}
		private function elementLoadSecurityError(event:SecurityErrorEvent):void {
			_elementLoad.contentLoaderInfo.removeEventListener(Event.COMPLETE, elementLoadComplete);
			_elementLoad.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, elementLoadIOError);
			_elementLoad.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, elementLoadSecurityError);
		}
		private var _elementTimer:Timer;
		/**
		 * 死亡单位 渐渐 消失
		 */
		private function elementAlph(event:Event = null):void {
			
			if (_elementMovieClip.currentFrame == _elementFrame) {
				
				_elementMovieClip.gotoAndStop(_elementFrame);
				removeEventListener(Event.ENTER_FRAME, elementAlph);
				_elementTimer = new Timer(_alphTime);
				_elementTimer.addEventListener(TimerEvent.TIMER, elementTimerHandler);
				_elementTimer.start();
			}
			
		}
		private var _elementAlpha:Number = 1;
		private function elementTimerHandler(event:TimerEvent):void {
			
			_elementAlpha -= 0.01;
			this.alpha = _elementAlpha;
			if (_elementAlpha <= 0) {
				
				_elementTimer.reset();
				_elementTimer.removeEventListener(TimerEvent.TIMER, elementTimerHandler);
				_elementTimer = null;
				
				removeChild(_elementMovieClip);
				_elementMovieClip = null;
				
				if (_elementRemove != null)
					_elementRemove();
			}
		}
	}//end ElementDead

}