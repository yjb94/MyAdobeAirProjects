package Page.Home
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.Text;
	
	import Footer.TabBar;
	
	import Header.NavigationBar;
	import Header.SlideBar;
	
	import Page.BasePage;
	
	public class Home extends BasePage
	{		
		public function Home(params:Object=null)
		{
			super();
		}
		
		public override function init():void
		{
			addHeaders();
			
			addFooters();
		}
		private function addHeaders():void
		{
			Elever.Main.header.addChildAt(new NavigationBar(BitmapControl.TOP_BG), 0);
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = BitmapControl.newBitmap(BitmapControl.ELEVER_LOGO);
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Left 
				= new Button(BitmapControl.SIDE_BUTTON, BitmapControl.SIDE_BUTTON, onSideButton);
			
			Elever.Main.header.onResize();
		}
		private function addFooters():void
		{
			Elever.Main.footer.addChildAt(new TabBar(BitmapControl.TOP_BG, 0), 0);
			
			(Elever.Main.footer.getChildByName("TabBar") as TabBar).addBar(BitmapControl.TAB1_UP, BitmapControl.TAB1_DOWN, "MainPage", {y:0});
			(Elever.Main.footer.getChildByName("TabBar") as TabBar).addBar(BitmapControl.TAB2_UP, BitmapControl.TAB2_DOWN, "MainPage", {y:0});
			(Elever.Main.footer.getChildByName("TabBar") as TabBar).addBar(BitmapControl.TAB3_UP, BitmapControl.TAB3_DOWN, "MainPage", {y:0});
		}
		
		private function onSideButton(e:MouseEvent):void
		{
			Elever.Main.sideMenu.open();
		}
		
		public override function onResize():void
		{
		}
		
		public override function dispose():void
		{
		}
	}
}