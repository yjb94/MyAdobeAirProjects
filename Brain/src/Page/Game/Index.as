package Page.Game
{
	import com.thanksmister.touchlist.controls.TouchList;
	import com.thanksmister.touchlist.renderers.DisplayObjectItemRenderer;
	import com.thanksmister.touchlist.renderers.SpaceItemRenderer;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import Page.BasePage;
	
	import Popup.RotatePopup;
	
	import kr.pe.hs.ui.TabbedButton;
	
	public class Index extends BasePage
	{
		[Embed(source = "assets/page/game/index/game1_title.png")]
		private static const GAME1_TITLE:Class;
		[Embed(source = "assets/page/game/index/game2_title.png")]
		private static const GAME2_TITLE:Class;
		[Embed(source = "assets/page/game/index/game3_title.png")]
		private static const GAME3_TITLE:Class;
		[Embed(source = "assets/page/game/index/game4_title.png")]
		private static const GAME4_TITLE:Class;
		
		[Embed(source = "assets/top_menu/button_prev.png")]
		private static const BUTTON_PREV:Class;
		
		[Embed(source = "assets/page/game/index/button_practice.png")]
		private static const BUTTON_PRACTICE:Class;
		[Embed(source = "assets/page/game/index/button_practice_on.png")]
		private static const BUTTON_PRACTICE_ON:Class;
		private var _btn_practice:TabbedButton;
		
		[Embed(source = "assets/page/game/index/button_test_start.png")]
		private static const BUTTON_TEST:Class;
		[Embed(source = "assets/page/game/index/button_test_start_on.png")]
		private static const BUTTON_TEST_ON:Class;
		private var _btn_test:TabbedButton;
		
		
		[Embed(source = "assets/page/game/index/game1_bg.png")]
		private static const GAME1_BG:Class;
		[Embed(source = "assets/page/game/index/game2_bg.png")]
		private static const GAME2_BG:Class;
		[Embed(source = "assets/page/game/index/game3_bg.png")]
		private static const GAME3_BG:Class;
		[Embed(source = "assets/page/game/index/game4_bg.png")]
		private static const GAME4_BG:Class;
		
		[Embed(source = "assets/page/game/index/game1_explain.png")]
		private static const GAME1_EXPLAIN:Class;
		[Embed(source = "assets/page/game/index/game2_explain.png")]
		private static const GAME2_EXPLAIN:Class;
		[Embed(source = "assets/page/game/index/game3_explain.png")]
		private static const GAME3_EXPLAIN:Class;
		[Embed(source = "assets/page/game/index/game4_explain.png")]
		private static const GAME4_EXPLAIN:Class;
		
		[Embed(source = "assets/page/game/index/bottom.png")]
		private static const BOTTOM:Class;
		
		[Embed(source = "assets/page/game/index/popup.png")]
		private static const POPUP:Class;
		
		private var _listSprite:Vector.<Sprite>;
		private var _touchList:TouchList;
		
		public function Index()
		{
			super();
			
			//Top Menu Control
			Brain.Main.TopMenu.clearAddedChild();
			Brain.Main.TopMenuVisible = true;
			//title
			var bmp:Bitmap;
			switch(Brain.GameIndex)
			{
				case 0:
					bmp = new GAME1_TITLE;
					break;
				case 1:
					bmp = new GAME2_TITLE;
					break;
				case 2:
					bmp = new GAME3_TITLE;
					break;
				case 3:
				case 4:
					bmp = new GAME4_TITLE;
					break;
			}
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
			
			
			//listSprite initialize
			_listSprite = new Vector.<Sprite>(1, true);
			
			_listSprite[0] = new Sprite;
			_listSprite[0].graphics.beginFill(0x000000,0);
			_listSprite[0].graphics.drawRect(0,0,540,400);
			_listSprite[0].graphics.endFill();
			
			switch(Brain.GameIndex)
			{
				case 0:
					bmp = new GAME1_EXPLAIN;
					break;
				case 1:
					bmp = new GAME2_EXPLAIN;
					break;
				case 2:
					bmp = new GAME3_EXPLAIN;
					break;
				case 3:
				case 4:
					bmp = new GAME4_EXPLAIN;
					break;
			}
			bmp.smoothing = true;	bmp.x = 0;	bmp.y = 415.40-Brain.TopMenuHeight;	_listSprite[0].addChild(bmp);
			
			//touchlist initialize
			_touchList = new TouchList(Brain.Main.PageWidth, Brain.Main.PageHeight);
			_touchList.addEventListener(Event.ADDED_TO_STAGE,touchList_onAdded);
			addChild(_touchList);
			bmp = new BOTTOM; bmp.smoothing = true;	bmp.x = 0;	bmp.y = Brain.Main.PageHeight - bmp.height;	addChild(bmp);
			var height:Number = bmp.height;
			
			//game image
			switch(Brain.GameIndex)
			{
				case 0:
					bmp = new GAME1_BG;
					break;
				case 1:
					bmp = new GAME2_BG;
					break;
				case 2:
					bmp = new GAME3_BG;
					break;
				case 3:
				case 4:
					bmp = new GAME4_BG;
					break;
			}
			bmp.smoothing = true;	bmp.x = 0;	bmp.y = 128-Brain.TopMenuHeight;	addChild(bmp);
			
			//practice_button
			bmp = new BUTTON_PRACTICE;
			bmp.smoothing=true;
			bmp_on = new BUTTON_PRACTICE_ON;
			bmp_on.smoothing=true;
			_btn_practice = new TabbedButton(bmp,bmp_on,bmp_on);
			_btn_practice.x = 26;
			_btn_practice.y = Brain.Main.PageHeight - _btn_practice.height/2 - height/2;
			_btn_practice.addEventListener(MouseEvent.CLICK, practiceClicked);
			if(Brain.Account && Brain.UserInfo.child_seq != -1)
			{
				//game_button
				bmp = new BUTTON_TEST;
				bmp.smoothing=true;
				bmp_on = new BUTTON_TEST_ON;
				bmp_on.smoothing=true;
				_btn_test = new TabbedButton(bmp,bmp_on,bmp_on);
				_btn_test.x = 278;
				_btn_test.y = Brain.Main.PageHeight - _btn_test.height/2 - height/2;
				_btn_test.addEventListener(MouseEvent.CLICK, testClicked);
				addChild(_btn_test);
			}
			else
			{
				_btn_practice.x = Brain.Main.PageWidth/2 - _btn_practice.width/2;
			}
			addChild(_btn_practice);
			
		}
		private function touchList_onAdded(e:Event=null):void
		{
			_touchList.removeListItems();
			onResize();
			for(var i:int = 0; i < _listSprite.length; i++) 
			{
				_touchList.addListItem(new DisplayObjectItemRenderer(_listSprite[i]));
			}
		}
		private var _popup:Sprite;
		private function practiceClicked(e:MouseEvent):void
		{
			Brain.isTestGame = true;
			
			Brain.Main.showPopup(new RotatePopup(popupClicked));
		}
		private function testClicked(e:MouseEvent):void
		{
			Brain.isTestGame = false;
			
			Brain.Main.showPopup(new RotatePopup(popupClicked));
		}
		private function popupClicked():void
		{
			if(Brain.isTestGame)
			{
				switch(Brain.GameIndex)
				{
					case 0:
						Brain.Main.setPage("brainTutorial1Page");
						break;
					case 1:
						Brain.Main.setPage("brainTutorial2Page");
						break;
					case 2:
						Brain.Main.setPage("brainTutorial3Page");
						break;
					case 3:
						Brain.Main.setPage("brainTutorial4Page");
						break;
					case 4:
						Brain.Main.setPage("brainTutorial5Page");
						break;
				}
			}
			else
			{
				var params:URLVariables = new URLVariables;
				//			1.user_seq : 사용자번호
				//			2.child_seq : 아동번호
				//			3.test_id : 테스트ID - 001 (주의력검사) , 002 (추론) , 003 (업데이팅)
				params.user_seq = Brain.UserInfo.user_seq;
				params.child_seq = Brain.UserInfo.child_seq;
				params.test_id = "00" + String(Brain.GameIndex+1);
				
				Brain.Connection.post("cognitiveFirstGameAction.cog", params, onLoadComplete);
			}
		}
		private function onLoadComplete(data:String):void
		{	
			if(data)
			{
				var result:Object = JSON.parse(data);
//				1.j_user_seq : 사용자번호
//				2.j_child_seq : 아동번호
//				3.j_firstYn : 처음인 경우 Y, 처음이 아닌 경우 N
//				4.j_errorMsg : 에러메시지
				if(result.j_errorMsg.length>0)
				{
					new Alert(result.j_errorMsg).show();
				}
				
				switch(Brain.GameIndex)
				{
					case 0:
						Brain.Main.setPage("brainGame1Page");
						break;
					case 1:
						Brain.Main.setPage("brainGame2Page");
						break;
					case 2:
						Brain.Main.setPage("brainGame3Page");
						break;
					case 3:
						Brain.Main.setPage("brainGame4Page");
						break;
					case 4:
						Brain.Main.setPage("brainGame5Page");
						break;
				}
				return;
			}
			
			new Alert("데이터 저장 실패.").show();
		}
		private function prevClicked(e:MouseEvent):void
		{
			Brain.Main.setPage("brainMainPage", null, BrainPageEffect.RIGHT, BrainPageEffect.RIGHT);
		}
		
		public override function onResize():void
		{
		}
		
		public override function dispose():void
		{
			Brain.Main.TopMenu.LeftButton.removeEventListener(MouseEvent.CLICK, prevClicked);
			
			_btn_practice.removeEventListener(MouseEvent.CLICK, practiceClicked);
			_btn_practice = null;
			
			if(_btn_test) _btn_test.removeEventListener(MouseEvent.CLICK, testClicked);
			_btn_test = null;
		}
	}
}

