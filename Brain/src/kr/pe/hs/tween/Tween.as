package kr.pe.hs.tween
{
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mx.effects.Tween;
	
	import spark.effects.Animate;
	
	public class Tween
	{
		private var _animate:Animate;
		
		private var _tween:mx.effects.Tween;
		private var _listener:Object;
		private var _delayTimer:Number;
		private var _isFinish:Boolean;
		
		private var _startValue:Number;
		private var _endValue:Number;
		private var _delay:Number;
		private var _duration:Number;
		private var _callback:Function;
		
		public function Tween(startValue:Number,endValue:Number,delay:Number,duration:Number,callback:Function)
		{
			if(startValue==endValue)
			{
				callback(endValue,true);
				return;
			}
			
			_isFinish=false;
			
			_startValue=startValue;
			_endValue=endValue;
			_delay=delay;
			_duration=duration;
			_callback=callback;
			
			_listener=
				{
				onTweenUpdate:function(value:Number):void
				{
					if(!_isFinish)
					{
						var ease:Number=3;
						if(ease<0)
						{
							//easeIn
							value=_startValue+Math.pow((value-_startValue)/(_endValue-_startValue),Math.abs(ease))*(_endValue-_startValue);
						}
						else if(ease>0)
						{
							//easeOut
							if(ease%2==0)
							{
								value=_startValue+(-Math.pow((value-_startValue)/(_endValue-_startValue)-1,ease)+1)*(_endValue-_startValue);
							}
							else
							{
								value=_startValue+(Math.pow((value-_startValue)/(_endValue-_startValue)-1,ease)+1)*(_endValue-_startValue);
							}
						}
						
						_callback(value,false);
					}
				},
				onTweenEnd:function(value:Number):void
				{
					if(!_isFinish)
					{
						_isFinish=true;
						
						_listener=null;
						_tween=null;
						
						_callback(value,true);
						_callback=null;
					}
				}
			}
			
			_delayTimer=NaN;
			if(_delay)
			{
				_delayTimer=setTimeout(startTween,_delay);
			}
			else
			{
				startTween();
			}
		}
		private function startTween():void
		{
			_animate=new Animate;
			
			if(!isNaN(_delayTimer)) clearTimeout(_delayTimer);
			_delayTimer=NaN;
			_tween=new mx.effects.Tween(_listener,_startValue,_endValue,_duration,30);
		}
		
		public function endTween():void
		{
			if(_tween) _tween.endTween();
			
			if(!isNaN(_delayTimer)) clearTimeout(_delayTimer);
			_delayTimer=NaN;
			_callback=null;
			_listener=null;
			_tween=null;
		}
		
	}
}