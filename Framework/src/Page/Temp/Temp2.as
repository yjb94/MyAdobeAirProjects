package Page.Temp
{
	import flash.events.MouseEvent;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.Text;
	
	import Page.BasePage;
	import Page.PageEffect;
	
	import Scroll.Scroll;
	
	public class Temp2 extends BasePage
	{
		private var _displays:Scroll;
		
		private var _button:Button;
		
		public function Temp2(params:Object=null)
		{
			super();
			Framework.Main.clearNavigation = true;
			
			_displays = new Scroll(true, -1, -1, -1, params.y);
			addChild(_displays);
			
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 0, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 1000, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 2000, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 3000, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 4000, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 5000, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 6000, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 7000, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 8000, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 9000, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 10000, false));
			
			_displays.addObject(Text.newText("2", 33, 0x000000, 0, 100, "left", "NanumGothicBold"));
			
			_button = new Button(BitmapControl.TEMP3, BitmapControl.TEMP2, onClick,0,0,false);
			_displays.addObject(_button);
		}
		public function onClick(e:MouseEvent=null):void
		{
			Framework.Main.changePage("Temp2_1Page", PageEffect.LEFT, {x:0.6});
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

