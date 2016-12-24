package Utils
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;

	public class Sound
	{
		public static const CORRECT:String = "Sound/assets/correct.mp3";
		
		private var _sound:flash.media.Sound;
		
		public function Sound(file_name:String):void
		{
			_sound = new flash.media.Sound();
			_sound.addEventListener(Event.COMPLETE, onSoundLoaded);
			_sound.addEventListener(IOErrorEvent.IO_ERROR, isError);
			_sound.load(new URLRequest(file_name));
		}
		
		private function onSoundLoaded(e:Event):void
		{
			if(_sound) _sound.removeEventListener(Event.COMPLETE, onSoundLoaded);
		}
		private function isError(e:IOErrorEvent):void
		{
			trace(e.text);
		}
		
		public function play():void
		{
			_sound.play();
		}
	}
}