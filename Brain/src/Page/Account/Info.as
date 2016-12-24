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
	import flash.text.AntiAliasType;
	import flash.text.ReturnKeyLabel;
	import flash.text.SoftKeyboardType;
	import flash.text.StageText;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;
	
	import Page.BasePage;
	
	import kr.pe.hs.tween.Tween;
	import kr.pe.hs.ui.TabbedButton;
	
	public class Info extends BasePage
	{	
		[Embed(source = "assets/page/account/info/title.png")]
		private static const TITLE:Class;
		
		[Embed(source = "assets/top_menu/button_prev.png")]
		private static const BUTTON_PREV:Class;
		
		
		[Embed(source = "assets/page/account/info/button_logout.png")]
		private static const BUTTON_LOGOUT:Class;
		[Embed(source = "assets/page/account/info/button_logout_on.png")]
		private static const BUTTON_LOGOUT_ON:Class;
		private var _btn_logout:TabbedButton;
		
		[Embed(source = "assets/page/account/info/button_change_pass.png")]
		private static const BUTTON_CHANGE_PASS:Class;
		[Embed(source = "assets/page/account/info/button_change_pass_on.png")]
		private static const BUTTON_CHANGE_PASS_ON:Class;
		private var _btn_chg_pass:TabbedButton;
		
		public function Info()
		{
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
			
			//login text
			var txt:TextField = new TextField;
			txt.x = 0; txt.y = 176-Brain.TopMenuHeight; txt.width = 540; txt.height = 22*1.3;
			var fmt:TextFormat = txt.defaultTextFormat;
			fmt.color = 0x585858;
			fmt.font = "Main";
			fmt.size = 22;
			fmt.align = "center";
			txt.embedFonts = true;
			txt.defaultTextFormat = fmt;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.text = Brain.Account.user_email;
			addChild(txt);
			
			//buttons
			bmp    = new BUTTON_CHANGE_PASS;    bmp.smoothing    = true;
			bmp_on = new BUTTON_CHANGE_PASS_ON; bmp_on.smoothing = true;
			_btn_chg_pass = new TabbedButton(bmp, bmp_on, bmp_on); _btn_chg_pass.x = 49; _btn_chg_pass.y = 272-Brain.TopMenuHeight;
			_btn_chg_pass.addEventListener(MouseEvent.CLICK, chgPassClicked); addChild(_btn_chg_pass);
			
			bmp    = new BUTTON_LOGOUT;    bmp.smoothing    = true;
			bmp_on = new BUTTON_LOGOUT_ON; bmp_on.smoothing = true;
			_btn_logout = new TabbedButton(bmp, bmp_on, bmp_on); _btn_logout.x = 49; _btn_logout.y = 358-Brain.TopMenuHeight;
			_btn_logout.addEventListener(MouseEvent.CLICK, logoutClicked); addChild(_btn_logout);
		}
		private function prevClicked(e:MouseEvent):void
		{
			Brain.Main.setPage("brainAccountLoginPage", null, BrainPageEffect.RIGHT, BrainPageEffect.RIGHT);
		}
		private function logoutClicked(e:MouseEvent):void
		{
			//서버 없음.
			Brain.Logout();
		}
		
		private function chgPassClicked(e:MouseEvent):void
		{
			Brain.Main.setPage("brainAccountSetPassword");
		}
		
		public override function onResize():void
		{
		}
		
		public override function dispose():void
		{
			Brain.Main.TopMenu.LeftButton.removeEventListener(MouseEvent.CLICK, prevClicked);

			_btn_chg_pass.removeEventListener(MouseEvent.CLICK, chgPassClicked);
			_btn_chg_pass = null;
			
			_btn_logout.addEventListener(MouseEvent.CLICK, logoutClicked);
			_btn_logout = null;
		}
	}
}
