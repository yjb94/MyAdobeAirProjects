package Popup
{
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	import kr.pe.hs.ui.TabbedButton;
	
	public class RotatePopup extends BasePopup
	{
		[Embed(source = "assets/page/game/index/popup.png")]
		private static const BG:Class;
		[Embed(source = "assets/page/game/game4/game4_popup.png")]
		private static const BG2:Class;
		
		private var _callback:Function;
		
		public function RotatePopup(callback:Function)
		{
			super();
			
			var bmp:Bitmap = new BG;
			if(Brain.GameIndex == 3 || Brain.GameIndex == 4)
				bmp = new BG2; 
			bmp.smoothing=true;
			addChild(bmp);
			
			_callback=callback;
			
			this.addEventListener(MouseEvent.CLICK, isClicked);
		}
		
		private function isClicked(e:MouseEvent):void
		{
			_callback();
			Brain.Main.closePopup();
		}
		
		public override function onResize():void
		{
			
		}
		
		public override function dispose():void
		{
			removeEventListener(MouseEvent.CLICK, isClicked);
		}
	}
}