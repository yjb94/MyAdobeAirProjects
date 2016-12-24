package Page.Temp
{
	import flash.events.MouseEvent;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.Text;
	
	import Page.BasePage;
	import Page.PageEffect;
	
	import Scroll.Scroll;
	
	public class Temp4 extends BasePage
	{
		private var _displays:Scroll;
		
		private var _button:Button;
		
		public function Temp4(params:Object=null)
		{
			super();
			Framework.Main.clearNavigation = true;
			
			_displays = new Scroll(true, -1, -1, -1, params.y);
			addChild(_displays);
			
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 0, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 200, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 400, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 600, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 800, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 1000, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 1200, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 1400, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 2000, false));
			
			_displays.addObject(Text.newText("4", 33, 0x000000, 0, 100, "left", "NanumGothicBold"));
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