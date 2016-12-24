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
	
	public class RepRegPopup extends BasePopup
	{
		[Embed(source = "assets/popup/sel_rep.png")]
		private static const BG:Class;
		
		private var _callback:Function;
		
		public function RepRegPopup(callback:Function)
		{
			super();
			
			var bmp:Bitmap = new BG;
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
		}
	}
}// ActionScript file