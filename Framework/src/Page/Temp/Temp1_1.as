package Page.Temp
{
	import flash.events.MouseEvent;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.Text;
	
	import Page.BasePage;
	import Page.PageEffect;
	
	import Scroll.Scroll;
	
	public class Temp1_1 extends BasePage
	{
		private var _displays:Scroll;
		
		private var _button:Button;
		
		public function Temp1_1(params:Object=null)
		{
			super();
			
			_displays = new Scroll(true, -1, -1, -1, params.y);
			addChild(_displays);
			
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 0, false));
			
			_displays.addObject(Text.newText("1-1", 33, 0x000000, 0, 100, "left", "NanumGothicBold"));
			
			_button = new Button(BitmapControl.TEMP3, BitmapControl.TEMP2, onClick,0,0,false);
			_displays.addObject(_button);
		}
		public function onClick(e:MouseEvent=null):void
		{
			Framework.Main.changePage("Temp1_2Page", PageEffect.LEFT, {x:0.6});
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

