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
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import Page.BasePage;
	
	import Popup.LoginPopup;
	import Popup.Test2Popup;
	import Popup.TestPopup;
	
	import kr.pe.hs.ui.TabbedButton;
	
	public class Result extends BasePage
	{
		[Embed(source = "assets/page/game/result/title.png")]
		private static const TITLE:Class;
		[Embed(source = "assets/page/game/result/test_title.png")]
		private static const TEST_TITLE:Class;
		
		
		[Embed(source = "assets/page/game/result/button_first.png")]
		private static const BUTTON_FIRST:Class;
		[Embed(source = "assets/page/game/result/button_first_on.png")]
		private static const BUTTON_FIRST_ON:Class;
		private var _btn_first:TabbedButton;
		
		[Embed(source = "assets/page/game/result/button_retest.png")]
		private static const BUTTON_RETEST:Class;
		[Embed(source = "assets/page/game/result/button_retest_on.png")]
		private static const BUTTON_RETEST_ON:Class;
		[Embed(source = "assets/page/game/result/button_repractice.png")]
		private static const BUTTON_PRACTICE:Class;
		[Embed(source = "assets/page/game/result/button_repractice_on.png")]
		private static const BUTTON_PRACTICE_ON:Class;
		private var _btn_retest:TabbedButton;
		
		[Embed(source = "assets/page/game/result/bg.png")]
		private static const BG:Class;
		[Embed(source = "assets/page/game/result/bg2.png")]
		private static const BG2:Class;
		[Embed(source = "assets/page/game/result/testgame_bg.png")]
		private static const TESTGAME_BG:Class;
		
		[Embed(source = "assets/page/game/result/result.png")]
		private static const RESULT:Class;
		
		[Embed(source = "assets/popup/result_popup.png")]
		private static const RESULT_POPUP:Class;
		
		
		public function Result()
		{
			super();
			
			//Top Menu Control
			Brain.Main.TopMenu.clearAddedChild();
			Brain.Main.TopMenuVisible = true;
			
			if(Brain.isTestGame)
			{
				bmp = new TEST_TITLE; bmp.smoothing = true; Brain.Main.TopMenu.Title = bmp;
				bmp = new TESTGAME_BG;	bmp.smoothing = true;	bmp.x = 35;	bmp.y = 211-Brain.TopMenuHeight;	addChild(bmp);
  
				bmp = new BUTTON_FIRST;
				bmp.smoothing=true;
				bmp_on = new BUTTON_FIRST_ON;
				bmp_on.smoothing=true;
				_btn_first = new TabbedButton(bmp,bmp_on,bmp_on);
				_btn_first.x = 26;
				_btn_first.y =  Brain.Main.PageHeight - _btn_first.height/2 - 66;
				_btn_first.addEventListener(MouseEvent.CLICK, firstClicked);
				addChild(_btn_first);
				
				//retest_button
				bmp = new BUTTON_PRACTICE;
				bmp.smoothing=true;
				bmp_on = new BUTTON_PRACTICE_ON;
				bmp_on.smoothing=true;
				_btn_retest = new TabbedButton(bmp,bmp_on,bmp_on);
				_btn_retest.x = 278;
				_btn_retest.y =  Brain.Main.PageHeight - _btn_retest.height/2 - 66;
				_btn_retest.addEventListener(MouseEvent.CLICK, retestClicked);
				addChild(_btn_retest);
				
				return;
			}
			
			//title
			var bmp:Bitmap = new TITLE;
			bmp.smoothing=true;
			Brain.Main.TopMenu.Title=bmp;
			//bg
			bmp = new BG2;	bmp.smoothing = true;	bmp.x = 36;	bmp.y = 115-Brain.TopMenuHeight;	addChild(bmp);
			bmp = new BG;	bmp.smoothing = true;	bmp.x = 0;	bmp.y = 403.80-Brain.TopMenuHeight;	addChild(bmp);
			
			//first_button
			bmp = new BUTTON_FIRST;
			bmp.smoothing=true;
			var bmp_on:Bitmap = new BUTTON_FIRST_ON;
			bmp_on.smoothing=true;
			_btn_first = new TabbedButton(bmp,bmp_on,bmp_on);
			_btn_first.x = 26;
			_btn_first.y =  Brain.Main.PageHeight - _btn_first.height/2 - 66;
			_btn_first.addEventListener(MouseEvent.CLICK, firstClicked);
			addChild(_btn_first);
			
			//retest_button
			bmp = new BUTTON_RETEST;
			bmp.smoothing=true;
			bmp_on = new BUTTON_RETEST_ON;
			bmp_on.smoothing=true;
			_btn_retest = new TabbedButton(bmp,bmp_on,bmp_on);
			_btn_retest.x = 278;
			_btn_retest.y =  Brain.Main.PageHeight - _btn_retest.height/2 - 66;
			_btn_retest.addEventListener(MouseEvent.CLICK, retestClicked);
			addChild(_btn_retest);
			
			txt = new TextField;
			txt.x = 119.57; txt.y = 176.8-Brain.TopMenuHeight; txt.height = 19*1.3;
			fmt = txt.defaultTextFormat;
			fmt.color = 0x585858;
			fmt.font="Main";
			fmt.size = 19;
			txt.embedFonts = true;
			txt.defaultTextFormat = fmt;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.autoSize = TextFieldAutoSize.LEFT;
			switch(Brain.GameIndex)
			{
				case 0: txt.text = "평균반응시간	"; break;
				default:txt.text = "맞춘 갯수		"; break;
			}
			txt.text = txt.text + Brain.Main.PageParameters.index1;
			addChild(txt);
			
			txt = new TextField;
			txt.x = 119.57; txt.y = 240.8-Brain.TopMenuHeight; txt.height = 19*1.3;
			fmt = txt.defaultTextFormat;
			fmt.color = 0x585858;
			fmt.font="Main";
			fmt.size = 19;
			txt.embedFonts = true;
			txt.defaultTextFormat = fmt;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.autoSize = TextFieldAutoSize.LEFT;
			switch(Brain.GameIndex)
			{
				case 0: txt.text = "맞춘 갯수		"; break;
				default:txt.text = "정답률		"; break;
			}
			txt.text = txt.text + Brain.Main.PageParameters.index2;
			addChild(txt);
						
			if(Brain.Main.PageParameters.dataYn == "N")
			{
//				//결과 수집중일때 띄우는거.
				bmp = new RESULT_POPUP;	bmp.smoothing = true;	bmp.x = 39;	bmp.y = 459-Brain.TopMenuHeight;	addChild(bmp);
				return;
			}
			
			//result text
			var txt:TextField = new TextField;
//			txt.x = 0; txt.y = 634.8-Brain.TopMenuHeight; txt.width = 540; txt.height = 19*1.3;
			var fmt:TextFormat = txt.defaultTextFormat;
//			fmt.color = 0x585858;
//			fmt.font="Main";
//			fmt.size = 19;
//			fmt.align = "center";
//			txt.embedFonts = true;
//			txt.defaultTextFormat = fmt;
//			txt.antiAliasType = AntiAliasType.ADVANCED;
//			switch(Brain.GameIndex)
//			{
//				case 0: txt.text = "주의력 검사 결과 귀하의 아동은"; break;
//				case 1: txt.text = "추론 검사 결과 귀하의 아동은"; break;
//				case 2: txt.text = "Updating 검사 결과 귀하의 아동은"; break;
//			}
//			addChild(txt);
//			
//			txt = new TextField;
//			txt.x = 130.91; txt.y = 634.8-Brain.TopMenuHeight+19*1.3; txt.width = 540; txt.height = 22*1.3;
//			fmt = txt.defaultTextFormat;
//			fmt.color = 0xfc7700;
//			fmt.font="Main";
//			fmt.size = 22;
//			txt.embedFonts = true;
//			txt.defaultTextFormat = fmt;
//			
			var obj:Object = Brain.Main.PageParameters;
			var n1:Number = new Number, n2:Number = new Number, n3:Number = new Number;
			switch(Brain.GameIndex)
			{
				case 0: n1 = obj.avr_correct_avr_time; n2 = obj.std_correct_avr_time; n3 = obj.correct_avr_time; break;
				case 1: 
				case 2:
				case 3:
				case 4: n1 = obj.avr_correct_point; n2 = obj.std_correct_point; n3 = obj.correct_point; break;
			}
			
//			//검사결과에 따라서 다르게 하셈.
//			txt.text = setResult(n1,n2,n3) ? "정상" : "비정상";
//			txt.autoSize = TextFieldAutoSize.LEFT;
//			txt.antiAliasType = AntiAliasType.ADVANCED;
//			addChild(txt);
//			
//			var txt2:TextField = new TextField;
//			txt2.x = txt.x + txt.width; txt2.y = txt.y+3*1.3; txt2.width = 540; txt2.height = 19*1.3;
//			fmt = txt2.defaultTextFormat;
//			fmt.color = 0x585858;
//			fmt.font="Main";
//			fmt.size = 19;
//			txt2.embedFonts = true;
//			txt2.defaultTextFormat = fmt;
//			txt2.text = "범위 안에 속해있습니다."
//			txt2.autoSize = TextFieldAutoSize.LEFT;
//			txt2.antiAliasType = AntiAliasType.ADVANCED;
//			addChild(txt2);
			
			setResult(n1,n2,n3);
			
		}
		private function onTest(value:Boolean):void
		{
			if(value)
			{
				Brain.Main.setPage("brainAccountLoginPage");
			}
			else
			{
				Brain.Main.setPage("brainGameIndexPage");
			}
		}
		private function firstClicked(e:MouseEvent):void
		{
			if(Brain.isTestGame)
			{
				if(Brain.Account == null)
					Brain.Main.showPopup(new LoginPopup(popupClicked));
				else if(Brain.UserInfo.child_seq == -1)
					Brain.Main.showPopup(new Test2Popup(onTest));
				else
					Brain.Main.setPage("brainGameIndexPage");
			}
			else
				Brain.Main.setPage("brainGameIndexPage");
		}
		private function popupClicked(value:Boolean):void
		{
			if(value)
				Brain.Main.setPage("brainAccountNotLoginPage");
			else
				Brain.Main.setPage("brainGameIndexPage");
			Brain.Main.closePopup();
		}
		private function retestClicked(e:MouseEvent):void
		{
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
				case 4:
					Brain.Main.setPage("brainGame4Page");
					break;
			}
		}
		private function setResult(all_avr:Number, all_std:Number, usr_avr:Number):Boolean
		{
			//평균
			var txt:TextField = new TextField;
			txt.x = 0; txt.y = 709-Brain.TopMenuHeight; txt.width = 540; txt.height = 19*1.3;
			var fmt:TextFormat = txt.defaultTextFormat;
			fmt.color = 0x585858;
			fmt.font="Main";
			fmt.size = 19;
			fmt.align = "center";
			txt.embedFonts = true;
			txt.defaultTextFormat = fmt;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.text = String(all_avr.toFixed(2));
			addChild(txt);
			
			//표준편차
			txt = new TextField;
			fmt = txt.defaultTextFormat;
			fmt.color = 0x585858;
			fmt.font="Main";
			fmt.size = 19;
			txt.embedFonts = true;
			txt.defaultTextFormat = fmt;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.text = String((all_avr+all_std*-2).toFixed(2));
			txt.x = 35-txt.width/2; txt.y = 709-Brain.TopMenuHeight; txt.height = 19*1.3;
			addChild(txt);
			
			txt = new TextField;
			fmt = txt.defaultTextFormat;
			fmt.color = 0x585858;
			fmt.font="Main";
			fmt.size = 19;
			txt.embedFonts = true;
			txt.defaultTextFormat = fmt;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.text = String((all_avr+all_std*-1).toFixed(2));
			txt.x = 154-txt.width/2; txt.y = 709-Brain.TopMenuHeight; txt.height = 19*1.3;
			addChild(txt);
			
			txt = new TextField;
			fmt = txt.defaultTextFormat;
			fmt.color = 0x585858;
			fmt.font="Main";
			fmt.size = 19;
			txt.embedFonts = true;
			txt.defaultTextFormat = fmt;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.text = String((all_avr+all_std*1).toFixed(2));
			txt.x = 393-txt.width/2; txt.y = 709-Brain.TopMenuHeight; txt.height = 19*1.3;
			addChild(txt);
			
			txt = new TextField;
			fmt = txt.defaultTextFormat;
			fmt.color = 0x585858;
			fmt.font="Main";
			fmt.size = 19;
			txt.embedFonts = true;
			txt.defaultTextFormat = fmt;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.text = String((all_avr+all_std*2).toFixed(2));
			txt.x = 512-txt.width/2; txt.y = 709-Brain.TopMenuHeight; txt.height = 19*1.3;
			addChild(txt);
			
			var bmp:Bitmap = new RESULT;	bmp.smoothing = true;
			
			var index:int;
			if(usr_avr < all_avr-2*all_std) index = 0;
			else if(usr_avr < all_avr-1*all_std) index = 1;
			else if(usr_avr < all_avr-0.5*all_std) index = 1.5;
			else if(usr_avr < all_avr) index = 2;
			else if(usr_avr < all_avr+0.5*all_std) index = 2.5;
			else if(usr_avr < all_avr+1*all_std) index = 3;
			else if(usr_avr < all_avr+2*all_std) index = 4;
			bmp.x = 35+120*index-bmp.width/2
			
			bmp.y = txt.y + txt.height + 3;
			addChild(bmp);
			
			return (all_avr-all_std <= usr_avr && usr_avr <= all_avr+all_std) ? true : false;
		}
		public override function onResize():void
		{
		}
		
		public override function dispose():void
		{	
			_btn_first.removeEventListener(MouseEvent.CLICK, firstClicked);
			_btn_first = null;
			
			_btn_retest.removeEventListener(MouseEvent.CLICK, retestClicked);
			_btn_retest = null;
		}
	}
}