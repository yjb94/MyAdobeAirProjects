package Page.Temp
{
	import flash.events.MouseEvent;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.Text;
	
	import Page.BasePage;
	import Page.PageEffect;
	
	import Scroll.Scroll;
	
	import Utils.Timer;
	
	public class Temp3 extends BasePage
	{
		private var _displays:Scroll;
		
		private var _button:Button;
		
		private var _timer:Timer;
				
		public function Temp3(params:Object=null)
		{
			super();
			Framework.Main.clearNavigation = true;
			
			_displays = new Scroll(true, -1, -1, -1, params.y);
			addChild(_displays);
			
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 0, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 500, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 1000, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 1500, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 2000, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 2500, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 3000, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 3500, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 4000, false));
			
			_displays.addObject(Text.newText("3", 33, 0x000000, 0, 100, "left", "NanumGothicBold"));
			
			new Timer(100, secondAfter, 30, true);
		}
		private function secondAfter():void
		{
			_displays.addObject(Text.newText("3", 33, 0x000000, Config.rand(0, 540-33), 0, "left", "NanumGothicBold"));
		}
		public override function onResize():void
		{
		}
		
		public override function dispose():void
		{
			_displays.dispose();
		}
	}
}