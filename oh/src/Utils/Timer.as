package Utils
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class Timer
	{
		private var _timer:flash.utils.Timer;
		private var _callback:Function;
		private var _end_callback:Function;
		
		public function Timer(time:Number, callback:Function, repeat_cnt:Number=0, immediate_start:Boolean=true, end_callback:Function=null):void
		{
			_timer = new flash.utils.Timer(time, repeat_cnt);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, dispose);
			if(immediate_start) _timer.start();
			
			_callback = callback;
			_end_callback = end_callback;
		}
		public function start():void
		{
			_timer.start();
		}
		public function stop():void
		{
			_timer.stop();
		}
		public function dispose(e:TimerEvent=null):void
		{
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, dispose);
			_timer.removeEventListener(TimerEvent.TIMER, dispose);
			_end_callback();
		}
		private function onTimer(e:TimerEvent):void
		{
			_callback();
		}
	}
}