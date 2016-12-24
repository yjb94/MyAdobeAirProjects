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
	
	public class CancelGamePopup extends BasePopup
	{
		[Embed(source = "assets/popup/exit_popup.png")]
		private static const BG:Class;
		
		[Embed(source = "assets/popup/button_yes.png")]
		private static const BUTTON_YES:Class;
		[Embed(source = "assets/popup/button_yes_on.png")]
		private static const BUTTON_YES_ON:Class;
		
		[Embed(source = "assets/popup/button_no.png")]
		private static const BUTTON_NO:Class;
		[Embed(source = "assets/popup/button_no_on.png")]
		private static const BUTTON_NO_ON:Class;
		
		private var _button_yes:TabbedButton;
		private var _button_no:TabbedButton;
		
		private var _callback:Function;
		
		public function CancelGamePopup(callback:Function)
		{
			super();
			
			var bmp:Bitmap = new BG;
			bmp.smoothing=true;
			addChild(bmp);
			
			bmp = new BUTTON_YES;
			bmp.smoothing=true;
			var bmp_on:Bitmap=new BUTTON_YES_ON;
			bmp_on.smoothing=true;
			_button_yes=new TabbedButton(bmp, bmp_on, bmp_on);
			_button_yes.x=120;
			_button_yes.y=251;
			_button_yes.addEventListener(MouseEvent.CLICK, onYes);
			addChild(_button_yes);
			
			bmp = new BUTTON_NO;
			bmp.smoothing=true;
			bmp_on = new BUTTON_NO_ON;
			bmp_on.smoothing=true;
			_button_no=new TabbedButton(bmp, bmp_on, bmp_on);
			_button_no.x=120;
			_button_no.y=250+_button_yes.height;
			_button_no.addEventListener(MouseEvent.CLICK, onNo);
			addChild(_button_no);
			
			_callback=callback;
		}
		
		private function onYes(e:MouseEvent):void
		{
			_callback(true);
		}
		private function onNo(e:MouseEvent):void
		{
			_callback(false);
		}
		
		public override function onResize():void
		{
			
		}
		
		public override function dispose():void
		{
			removeChild(_button_yes);
			_button_yes=null;
			removeChild(_button_no);
			_button_no=null;
		}
	}
}