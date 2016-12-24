//brainAccountNotLoginPage
package Page.Account
{	
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.RemoteNotificationEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.geom.Rectangle;
	import flash.net.URLVariables;
	import flash.text.ReturnKeyLabel;
	import flash.text.SoftKeyboardType;
	import flash.text.StageText;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;
	
	import Page.BasePage;
	

	
	import kr.pe.hs.tween.Tween;
	import kr.pe.hs.ui.TabbedButton;
	
	public class Index1 extends BasePage
	{
		[Embed(source = "assets/page/account/index1/title.png")]
		private static const TITLE:Class;
		
		[Embed(source = "assets/top_menu/button_prev.png")]
		private static const BUTTON_PREV:Class;
		
		[Embed(source = "assets/page/account/index1/bg.png")]
		private static const BG:Class;
		
		[Embed(source = "assets/page/account/index1/button_login.png")]
		private static const BUTTON_LOGIN:Class;
		[Embed(source = "assets/page/account/index1/button_login_on.png")]
		private static const BUTTON_LOGIN_ON:Class;
		private var _btn_login:TabbedButton;
		[Embed(source = "assets/page/account/index1/button_join.png")]
		private static const BUTTON_JOIN:Class;
		[Embed(source = "assets/page/account/index1/button_join_on.png")]
		private static const BUTTON_JOIN_ON:Class;
		private var _btn_join:TabbedButton;
		
		public function Index1()
		{
			Brain.Main.LoadingVisible = false;
			super();
			
			//Top Menu Control
			Brain.Main.TopMenu.clearAddedChild();
			Brain.Main.TopMenuVisible = true;
			//title
			var bmp:Bitmap = new TITLE;
			bmp.smoothing=true;
			Brain.Main.TopMenu.Title=bmp;
			//left menu
			bmp = new BUTTON_PREV;
			bmp.smoothing = true;
			var bmp_on:Bitmap = new BUTTON_PREV;
			bmp_on.smoothing = true;
			bmp_on.alpha = 0.6;
			var btn_left_top:TabbedButton = new TabbedButton(bmp, bmp_on, bmp_on);
			Brain.Main.TopMenu.LeftButton = btn_left_top;
			Brain.Main.TopMenu.LeftButton.addEventListener(MouseEvent.CLICK, prevClicked);
			
			//bg
			bmp = new BG;
			bmp.smoothing = true;
			bmp.x = 48;
			bmp.y = 147-Brain.TopMenuHeight;
			addChild(bmp);
			
			//join_button
			bmp = new BUTTON_JOIN;
			bmp.smoothing=true;
			bmp_on = new BUTTON_JOIN_ON;
			bmp_on.smoothing=true;
			_btn_join = new TabbedButton(bmp,bmp_on,bmp_on);
			_btn_join.x = 49;
			_btn_join.y = 489-Brain.TopMenuHeight;
			_btn_join.addEventListener(MouseEvent.CLICK, joinClicked);
			addChild(_btn_join);
			//login_button
			bmp = new BUTTON_LOGIN;
			bmp.smoothing=true;
			bmp_on = new BUTTON_LOGIN_ON;
			bmp_on.smoothing=true;
			_btn_login = new TabbedButton(bmp,bmp_on,bmp_on);
			_btn_login.x = 49;
			_btn_login.y = 575-Brain.TopMenuHeight;
			_btn_login.addEventListener(MouseEvent.CLICK, loginClicked);
			addChild(_btn_login);
		}
		private function prevClicked(e:MouseEvent):void
		{
			Brain.Main.setPage("brainMainPage", null, BrainPageEffect.RIGHT, BrainPageEffect.RIGHT);
		}
		private function loginClicked(e:MouseEvent):void
		{
			Brain.Main.setPage("brainLoginPage");
		}
		private function joinClicked(e:MouseEvent):void
		{
			Brain.Main.setPage("brainAccountJoinPage");
		}
		
		public override function onResize():void
		{
		}
		
		public override function dispose():void
		{
			Brain.Main.TopMenu.LeftButton.removeEventListener(MouseEvent.CLICK, prevClicked);
			
			_btn_login.removeEventListener(MouseEvent.CLICK, loginClicked);
			_btn_login = null;
			
			_btn_join.removeEventListener(MouseEvent.CLICK, joinClicked);
			_btn_join = null;
		}
	}
}