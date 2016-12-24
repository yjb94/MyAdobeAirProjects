package Page.Temp
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.Text;
	
	import Header.NavigationBar;
	import Header.SlideBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	
	import Scroll.Scroll;
	
	import Utils.Sound;
	
	public class Temp2_1 extends BasePage
	{
		private var _displays:Scroll;
		
		private var _button:Button;
		
		private var _sound:Sound;
		
		public function Temp2_1(params:Object=null)
		{
			super();
			
			//(Framework.Main.header.getChildByName("NavigationBar") as NavigationBar).disable = true;
			(Framework.Main.header.getChildByName("SlideBar") as SlideBar).disable = true;
			
			_displays = new Scroll(true, -1, -1, -1, params.y);
			addChild(_displays);
			
			_button = new Button(BitmapControl.TEMP3, BitmapControl.TEMP2, onClick,0,0,false);
			_displays.addObject(_button);
			
			_displays.addObject(Text.newText("2-1", 33, 0x000000, 0, 0, "left", "NanumGothicBold"));
			
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 5000, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 6000, false));
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TEMP, 0, 7000, false));
			
			_sound = new Sound(Utils.Sound.CORRECT);
		} 
		public function onClick(e:MouseEvent=null):void
		{
			_sound.play();
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