package Page.Home
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLVariables;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.Text;
	
	import Header.Header;
	import Header.NavigationBar;
	import Header.TabBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	import Page.Home.Tabs.PrevItem;
	
	import Scroll.Scroll;

	public class Home extends BasePage
	{
		private var _tabBar:TabBar;
		
		private static var _now_item_data:Object = null;
		
		public function Home(params:Object=null)
		{
			super();
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).clearPrev();
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = BitmapControl.newBitmap(BitmapControl.ELEVER_LOGO);
			
			_tabBar = new TabBar(BitmapControl.SLIDE_BG, BitmapControl.TABBAR_ANCHOR);
			_tabBar.addBar(Text.newText("진행중인 프로젝트", 24, 0xffffff), "NowItem", this, _tabBar.height);
			_tabBar.addBar(Text.newText("지난 프로젝트", 24, 0xffffff), "PrevItem", this, _tabBar.height);
			if(params)
				if(params.now_item != null) 
					_tabBar.barIndexWithoutTween = (params.now_item == true) ? 0 : 1;
			//_tabBar.barIndexWithoutTween = 1;
			addChild(_tabBar);
		}
		
		public override function init():void
		{
		}
		public override function onResize():void
		{
		}
		
		public override function dispose():void
		{
			_tabBar.dispose();
		}
	}
}