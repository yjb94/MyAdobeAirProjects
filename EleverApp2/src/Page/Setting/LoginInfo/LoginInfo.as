package Page.Setting.LoginInfo
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.Popup;
	import Displays.Text;
	
	import Header.Header;
	import Header.NavigationBar;
	import Header.TabBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	import Page.Home.Tabs.PrevItem;
	
	import Scroll.Scroll;
	
	public class LoginInfo extends BasePage
	{
		private const UPPER_MARGIN:Number = 100;
		private const BUTTON_MARGIN:Number = 50;
		
		private var _logout_popup:Popup;
		
		public function LoginInfo(params:Object=null)
		{
			super();
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = Text.newText("로그인 정보", 26, 0xffffff);;
		
			//회원 정보 수정
			var btn:Button = new Button(BitmapControl.TEMP_BUTTON_UP, BitmapControl.TEMP_BUTTON_DOWN, onModifyUserInfo);
			btn.x = Elever.Main.PageWidth/2 - btn.width/2;
			btn.y = UPPER_MARGIN;
			addChild(btn);
			
			//로그아웃
			var btn2:Button = new Button(BitmapControl.TEMP_BUTTON_UP, BitmapControl.TEMP_BUTTON_DOWN, onLogout);
			btn2.x = Elever.Main.PageWidth/2 - btn2.width/2;
			btn2.y = btn.y + btn.height + BUTTON_MARGIN;
			addChild(btn2);
		}
		
		private function onModifyUserInfo(e:MouseEvent):void
		{
			if(Elever.AppData.isFB)
				Elever.Main.changePage("ModifyUserInfoPage");
			else
				Elever.Main.changePage("CheckPasswordPage");
		}
		private function onLogout(e:MouseEvent):void
		{
			_logout_popup = new Popup(Popup.YESNO_TYPE , "알림", "로그아웃 하시겠습니까?", onPopupClicked);
		}
		private function onPopupClicked(type:String):void
		{
			if(type == "yes")
			{
				Elever.removeAllEnviroment();
				Elever.Main.changePage("HomePage");
			}
		}
		
		public override function init():void
		{
		}
		public override function onResize():void
		{
		}
		
		public override function dispose():void
		{
		}
	}
}

