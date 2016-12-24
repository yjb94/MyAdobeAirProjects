package Page.Temp
{
	import flash.events.MouseEvent;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.Text;
	
	import Header.Header;
	
	import Page.BasePage;
	import Page.PageEffect;
	
	import Scroll.Scroll;

	public class Temp extends BasePage
	{
		private var _displays:Scroll;
		
		private var _button:Button;
		
		public function Temp(params:Object=null)
		{
			super();
			Framework.Main.clearNavigation = true;
			
			if(params) _displays = new Scroll(true, -1, -1, -1, params.y);
			else	   _displays = new Scroll();
			addChild(_displays);
			
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 0, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 100, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 200, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 300, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 400, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 500, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 600, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 700, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 800, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 900, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 1000, false));
			
			_displays.addObject(Text.newText("1", 33, 0x000000, 0, 100, "left", "NanumGothicBold"));
			
			_button = new Button(BitmapControl.TEMP3, BitmapControl.TEMP2, onClick,0,0,false);
			_displays.addObject(_button);
		}
		public function onClick(e:MouseEvent=null):void
		{
			Framework.Main.changePage("Temp1_1Page", PageEffect.LEFT, {x:0.6});
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