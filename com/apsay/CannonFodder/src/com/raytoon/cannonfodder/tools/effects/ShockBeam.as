package com.raytoon.cannonfodder.tools.effects
{
	import flash.filters.BitmapFilter;
	import flash.filters.GlowFilter;
	import flash.display.BlendMode;
	import flash.events.Event;
	import flash.display.Sprite;

	import com.raytoon.cannonfodder.tools.effects.Lightning;
	import com.raytoon.cannonfodder.tools.effects.LightningFadeType;

	/**
	 * @author Administrator
	 */
	public class ShockBeam extends Sprite
	{
		private var ll:Lightning;
		private var _startX:Number;
		private var _startY:Number;
		private var _endX:Number;
		private var _endY:Number;
		private var _vars:Object;
		private var _filter:BitmapFilter;
		private var _glow:GlowFilter;
		private var _preset:uint;
		private var _color:uint;
		private var _generation:uint;
		private var _blendMode:String;
		private var _childrenLifeSpanMin:Number;
		private var _childrenLifeSpanMax:Number;
		private var _childrenProbability:Number;
		private var _childrenMaxGenerations:uint;
		private var _childrenMaxCount:uint;
		private var _childrenMaxCountDecay:Number;
		private var _childrenAngleVariation:Number;
		private var _thickness:Number;
		private var _steps:uint;
		private var _smoothPercentage:uint;
		private var _wavelength:Number;
		private var _amplitude:Number;
		private var _speed:Number;
		private var _maxLength:Number;
		private var _maxLengthVary:Number;
		private var _childrenDetachedEnd:Boolean;
		private var _alphaFadeType:String;
		private var _thicknessFadeType:String;

		public function ShockBeam(startX:Number, startY:Number, endX:Number, endY:Number, preset:uint = 1, vars:Object = null)
		{
			if(stage)
			{
				_init();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, _init);
			}
			_set(startX, startY, endX, endY, preset, vars);
		}

		private function _set(startX:Number, startY:Number, endX:Number, endY:Number, preset:uint, vars:Object):void
		{
			_startX = startX ? startX : 50;
			_startY = startY ? startY : 200;
			_endX = endX ? endX : 50;
			_endY = endY ? endY : 600;
			_preset = preset;
			_vars = vars ? vars : new Object();
			_color = _vars.color ? _vars.color : 0xffffff;
			_glow = new GlowFilter(_color, 1.0, 10, 10, 2, 3);
			_filter = _vars.filter ? _vars.filter : _glow;

			_generation = _vars.generation ? _vars.generation : 0;
			_blendMode = _vars.blendMode ? _vars.blendMode : BlendMode.SUBTRACT;

			_childrenLifeSpanMin = _vars.childrenLifeSpanMin ? _vars.childrenLifeSpanMin : 0;
			_childrenLifeSpanMax = _vars.childrenLifeSpanMax ? _vars.childrenLifeSpanMax : 0;
			_childrenProbability = _vars.childrenProbability ? _vars.childrenProbability : 0.025;
			_childrenMaxGenerations = _vars.childrenMaxGenerations ? _vars.childrenMaxGenerations : 3;
			_childrenMaxCount = _vars.childrenMaxCount ? _vars.childrenMaxCount : 4;
			_childrenMaxCountDecay = _vars.childrenMaxCountDecay ? _vars.childrenMaxCountDecay : 0.5;
			_childrenAngleVariation = _vars.childrenAngleVariation ? _vars.childrenAngleVariation : 60;
			_thickness = _vars.thickness ? _vars.thickness : 1;
			_steps = _vars.steps ? _vars.steps : 100;
			_smoothPercentage = _vars.smoothPercentage ? _vars.smoothPercentage : 50;
			_wavelength = _vars.wavelength ? _vars.wavelength : 0.2;
			_amplitude = _vars.amplitude ? _vars.amplitude : 0.9;
			_speed = _vars.speed ? _vars.speed : 1;
			_maxLength = _vars.maxLength ? _vars.maxLength : 0;
			_maxLengthVary = _vars.maxLengthVary ? _vars.maxLengthVary : 0;
			_childrenDetachedEnd = _vars.childrenDetachedEnd ? _vars.childrenDetachedEnd : false;
			_alphaFadeType = _vars.alphaFadeType ? _vars.alphaFadeType : LightningFadeType.GENERATION;
			_thicknessFadeType = _vars.thicknessFadeType ? _vars.thicknessFadeType : LightningFadeType.NONE;
		}

		private function _init(e:Event = null):void
		{
			if(hasEventListener(Event.ADDED_TO_STAGE))
			{
				removeEventListener(Event.ADDED_TO_STAGE, _init);
			}
			ll = new Lightning(_color);
			ll.blendMode = _blendMode;
			ll.filters = [_filter];
			ll.startX = _startX;
			ll.startY = _startY;
			ll.endX = _endX;
			ll.endY = _endY;
			_setPreset(_preset);
			addChild(ll);
			addEventListener(Event.ENTER_FRAME, _onframe);
		}

		private function _onframe(event:Event):void
		{
			ll.update();
		}

		public function kill():void
		{
			ll.kill();
		}

		private function _setPreset(param:uint):void
		{
			switch(param)
			{
				case 0:
				{
					ll.childrenLifeSpanMin = _childrenLifeSpanMin;
					ll.childrenLifeSpanMax = _childrenLifeSpanMax;
					ll.childrenProbability = _childrenProbability;
					ll.childrenMaxGenerations = _childrenMaxGenerations;
					ll.childrenMaxCount = _childrenMaxCount;
					ll.childrenAngleVariation = _childrenAngleVariation;
					ll.thickness = _thickness;
					ll.steps = _steps;
					ll.smoothPercentage = _smoothPercentage;
					ll.wavelength = _wavelength;
					ll.amplitude = _amplitude;
					ll.speed = _speed;
					ll.maxLength = _maxLength;
					ll.maxLengthVary = _maxLengthVary;
					ll.childrenDetachedEnd = _childrenDetachedEnd;
					ll.alphaFadeType = _alphaFadeType;
					ll.thicknessFadeType = _thicknessFadeType;
					break;
				}
				case 1:
				{
					ll.childrenLifeSpanMin = 1;
					ll.childrenLifeSpanMax = 3;
					ll.childrenProbability = 1;
					ll.childrenMaxGenerations = 3;
					ll.childrenMaxCount = 4;
					ll.childrenAngleVariation = 110;
					ll.thickness = 0;
					ll.steps = 100;
					ll.smoothPercentage = 50;
					ll.wavelength = 0.2;
					ll.amplitude = 1.1;
					ll.speed = 0.7;
					ll.maxLength = 0;
					ll.maxLengthVary = 0;
					ll.childrenDetachedEnd = false;
					ll.alphaFadeType = LightningFadeType.GENERATION;
					ll.thicknessFadeType = LightningFadeType.NONE;
					break;
				}
				case 2:
				{
					ll.childrenLifeSpanMin = 1;
					ll.childrenLifeSpanMax = 3;
					ll.childrenProbability = 1;
					ll.childrenMaxGenerations = 3;
					ll.childrenMaxCount = 4;
					ll.childrenAngleVariation = 110;
					ll.thickness = 2;
					ll.steps = 100;
					ll.smoothPercentage = 50;
					ll.wavelength = 0.3;
					ll.amplitude = 0.5;
					ll.speed = 0.7;
					ll.maxLength = 440;
					ll.maxLengthVary = 75;
					ll.childrenDetachedEnd = false;
					ll.alphaFadeType = LightningFadeType.GENERATION;
					ll.thicknessFadeType = LightningFadeType.NONE;
					break;
				}
				case 3:
				{
					ll.childrenLifeSpanMin = 1;
					ll.childrenLifeSpanMax = 3;
					ll.childrenProbability = 1;
					ll.childrenMaxGenerations = 3;
					ll.childrenMaxCount = 4;
					ll.childrenAngleVariation = 110;
					ll.thickness = 2;
					ll.steps = 100;
					ll.smoothPercentage = 50;
					ll.wavelength = 0.3;
					ll.amplitude = 0.5;
					ll.speed = 0.1;
					ll.maxLength = 0;
					ll.maxLengthVary = 0;
					ll.childrenDetachedEnd = false;
					ll.alphaFadeType = LightningFadeType.GENERATION;
					ll.thicknessFadeType = LightningFadeType.NONE;
					break;
				}
				case 4:
				{
					ll.childrenLifeSpanMin = 0.1;
					ll.childrenLifeSpanMax = 2;
					ll.childrenProbability = 1;
					ll.childrenMaxGenerations = 3;
					ll.childrenMaxCount = 4;
					ll.childrenAngleVariation = 130;
					ll.thickness = 3;
					ll.steps = 100;
					ll.smoothPercentage = 50;
					ll.wavelength = 0.3;
					ll.amplitude = 0.5;
					ll.speed = 1;
					ll.maxLength = 0;
					ll.maxLengthVary = 0;
					ll.childrenDetachedEnd = true;
					ll.alphaFadeType = LightningFadeType.TIP_TO_END;
					ll.thicknessFadeType = LightningFadeType.GENERATION;
					break;
				}
				case 5:
				{
					ll.childrenLifeSpanMin = 0.1;
					ll.childrenLifeSpanMax = 2;
					ll.childrenProbability = 1;
					ll.childrenMaxGenerations = 3;
					ll.childrenMaxCount = 4;
					ll.childrenAngleVariation = 130;
					ll.thickness = 3;
					ll.steps = 100;
					ll.smoothPercentage = 50;
					ll.wavelength = 0.3;
					ll.amplitude = 0.5;
					ll.speed = 1;
					ll.maxLength = 440;
					ll.maxLengthVary = 75;
					ll.childrenDetachedEnd = true;
					ll.alphaFadeType = LightningFadeType.TIP_TO_END;
					ll.thicknessFadeType = LightningFadeType.GENERATION;
					break;
				}
				default:
				{
					break;
				}
			}
			ll.killAllChildren();
		}
	}
}
