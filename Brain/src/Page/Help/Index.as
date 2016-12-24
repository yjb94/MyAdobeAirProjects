package Page.Help
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
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.text.ReturnKeyLabel;
	import flash.text.SoftKeyboardType;
	import flash.text.StageText;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;
	
	import Page.BasePage;
	
	import kr.pe.hs.tween.Tween;
	import kr.pe.hs.ui.TabbedButton;
	
	public class Index extends BasePage
	{	
		[Embed(source = "assets/page/help/index/title.png")]
		private static const TITLE:Class;
		
		[Embed(source = "assets/top_menu/button_prev.png")]
		private static const BUTTON_PREV:Class;
		
		[Embed(source = "assets/page/help/index/button_intro.png")]
		private static const BUTTON_INTRO:Class;
		[Embed(source = "assets/page/help/index/button_intro_on.png")]
		private static const BUTTON_INTRO_ON:Class;
		private var _btn_intro:TabbedButton;
		[Embed(source = "assets/page/help/index/button_suggest.png")]
		private static const BUTTON_SUGGEST:Class;
		[Embed(source = "assets/page/help/index/button_suggest_on.png")]
		private static const BUTTON_SUGGEST_ON:Class;
		private var _btn_suggest:TabbedButton;
		[Embed(source = "assets/page/help/index/button_terms.png")]
		private static const BUTTON_TERMS:Class;
		[Embed(source = "assets/page/help/index/button_terms_on.png")]
		private static const BUTTON_TERMS_ON:Class;
		private var _btn_terms:TabbedButton;
		
		public function Index()
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
			
			//buttons
			bmp = new BUTTON_INTRO;
			bmp.smoothing=true;
			bmp_on = new BUTTON_INTRO_ON;
			bmp_on.smoothing=true;
			_btn_intro = new TabbedButton(bmp,bmp_on,bmp_on);
			_btn_intro.x = 49;
			_btn_intro.y = 138-Brain.TopMenuHeight;
			_btn_intro.addEventListener(MouseEvent.CLICK, introClicked);
			addChild(_btn_intro);
			//
			bmp = new BUTTON_TERMS;
			bmp.smoothing=true;
			bmp_on = new BUTTON_TERMS_ON;
			bmp_on.smoothing=true;
			_btn_terms = new TabbedButton(bmp,bmp_on,bmp_on);
			_btn_terms.x = 49;
			_btn_terms.y = 225-Brain.TopMenuHeight;
			_btn_terms.addEventListener(MouseEvent.CLICK, termsClicked);
			addChild(_btn_terms);
			//
			bmp = new BUTTON_SUGGEST;
			bmp.smoothing=true;
			bmp_on = new BUTTON_SUGGEST_ON;
			bmp_on.smoothing=true;
			_btn_suggest = new TabbedButton(bmp,bmp_on,bmp_on);
			_btn_suggest.x = 49;
			_btn_suggest.y = 311-Brain.TopMenuHeight;
			_btn_suggest.addEventListener(MouseEvent.CLICK, suggestClicked);
			addChild(_btn_suggest);
		}
		private function prevClicked(e:MouseEvent):void
		{
			Brain.Main.setPage("brainMainPage", null, BrainPageEffect.RIGHT, BrainPageEffect.RIGHT);
		}
		private function introClicked(e:MouseEvent):void
		{
			Brain.Main.setPage("brainInfoPage");
		}
		private function termsClicked(e:MouseEvent):void
		{
		}
		private function suggestClicked(e:MouseEvent):void
		{
			var u:URLRequest = new URLRequest("mailto:"+"cog.max.spec@gmail.com");
			var v:URLVariables = new URLVariables();
			v.subject = "";
			v.body = "";
			u.data = v;
			navigateToURL(u, "_self");
		}
		public override function onResize():void
		{
		}
		
		public override function dispose():void
		{
			Brain.Main.TopMenu.LeftButton.removeEventListener(MouseEvent.CLICK, prevClicked);
			
			_btn_intro.removeEventListener(MouseEvent.CLICK, introClicked);
			_btn_intro = null;
			
			_btn_terms.removeEventListener(MouseEvent.CLICK, termsClicked);
			_btn_terms = null;
			
			_btn_suggest.removeEventListener(MouseEvent.CLICK, suggestClicked);
			_btn_suggest = null;
		}
	}
}
