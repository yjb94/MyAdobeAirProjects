package Page.Help
{	
	import com.thanksmister.touchlist.controls.TouchList;
	import com.thanksmister.touchlist.renderers.DisplayObjectItemRenderer;
	
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
	
	public class Info extends BasePage
	{	
		[Embed(source = "assets/page/help/index/title.png")]
		private static const TITLE:Class;
		
		[Embed(source = "assets/top_menu/button_prev.png")]
		private static const BUTTON_PREV:Class;
		
		[Embed(source = "assets/page/help/index/info.png")]
		private static const INFO:Class;

		private var _touchList:TouchList;
		private var _listSprite:Vector.<Sprite>;

		public function Info()
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
			
			
			_listSprite=new Vector.<Sprite>(1,true);
			_listSprite[0]=new Sprite;
			
			bmp = new INFO;
			bmp.smoothing = true;
			bmp.x = 21;
			bmp.y = 115.4 - Brain.TopMenuHeight;
			_listSprite[0].addChild(bmp);
			
			//touch list
			_touchList = new TouchList(Brain.Main.PageWidth, Brain.Main.PageHeight);
			_touchList.addEventListener(Event.ADDED_TO_STAGE, touchList_onAdded);
			addChild(_touchList);
		}
		private function touchList_onAdded(e:Event=null):void
		{
			_touchList.removeListItems();
			//onResize();
			for(var i:int = 0; i < _listSprite.length; i++) 
			{
				_touchList.addListItem(new DisplayObjectItemRenderer(_listSprite[i]));
			}
		}
		private function prevClicked(e:MouseEvent):void
		{
			Brain.Main.setPage("brainHelpPage", null, BrainPageEffect.RIGHT, BrainPageEffect.RIGHT);
		}
		public override function onResize():void
		{
		}
		
		public override function dispose():void
		{
			Brain.Main.TopMenu.LeftButton.removeEventListener(MouseEvent.CLICK, prevClicked);
		}
	}
}

