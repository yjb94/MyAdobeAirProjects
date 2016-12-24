package Page.Login
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.Popup;
	import Displays.Text;
	import Displays.WebImage;
	
	import Header.NavigationBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	
	import Scroll.Scroll;
	
	public class Join extends BasePage
	{		
		private const ANCHOR_TWEEN_DURATION:Number = 0.3;
		private const BASE_Y_INTERVAL:Number = 30;
		
		private const TEXT_Y_MARGIN:Number = 40;
		private const TEXTBOX_HEIGHT:Number = 58;
		
		private const LINE_X_MARGIN:Number = 52*Config.ratio;
		private const LINE_Y_MARGIN:Number = 68*Config.ratio;
		
		private const TITLE_FONT_SIZE:Number = 50*Config.ratio;
		private const TEXT_FONT_SIZE:Number = 40*Config.ratio;
		private const INPUT_TEXT_FONT_SIZE:Number = 42*Config.ratio;
		
		private const CAR_FONT_SIZE:Number = 50*Config.ratio;
		private const COMPANY_FONT_SIZE:Number = 40*Config.ratio;
		
		private const PHONE_BASE_TEXT:String = "'-'빼고 입력해주세요.";
		
		private const TEXT_MARGIN:Number = 22*Config.ratio;
		private const TEXTFILED_Y_MARGIN:Number = 57*Config.ratio;
		private const ITEM_Y_MARGIN:Number = 57*Config.ratio;
		
		private var _displays:Scroll;
		
		private var _btn_next:Button;
		
		private var _params:Object;
		
		private var _spr_car:Sprite;
		
		private var _btn_is_seller:Button;
		private var _btn_term:Button;
		
		public function Join(params:Object=null)
		{
			super();
			
			_params = params;
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = Text.newText("회원가입", TITLE_FONT_SIZE, 0xffffff);
			
			_displays = new Scroll();
			addChild(_displays);
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).addMiddleTouchCallBack(_displays.toTop);
			
			
			//아이디		
			var txt:TextField = Text.newText("아이디", TEXT_FONT_SIZE, 0x2c2c2c,  35, TEXT_Y_MARGIN+20, "left", "NanumBarunGothic", 0, 0);
			_displays.addObject(txt);
			
			var obj:Object = Text.newInputTextbox(BitmapControl.TEXTBOX, INPUT_TEXT_FONT_SIZE, "", 0x252525, 192, txt.y + txt.height/2 - TEXTBOX_HEIGHT/2, "left", "NanumBarunGothic");
			(obj.txt as TextField).name = "ID";
			(obj.txt as TextField).addEventListener(MouseEvent.CLICK, onClickInputText);
			(obj.txt as TextField).addEventListener(FocusEvent.FOCUS_OUT, onFocusInputText);
			_displays.addObject(obj.bmp); _displays.addObject(obj.txt);
			
			var bmp:Bitmap = BitmapControl.newBitmap(BitmapControl.BUY_SEPERATE_LINE, 0, obj.txt.y + obj.txt.height + TEXT_Y_MARGIN);
			_displays.addObject(bmp);
			
			//비밀번호
			txt = Text.newText("비밀번호", TEXT_FONT_SIZE, 0x2c2c2c, 35, bmp.y + bmp.height + TEXT_Y_MARGIN, "left", "NanumBarunGothic", 0, 0);
			_displays.addObject(txt);
			
			var pw_obj:Object = Text.newInputTextbox(BitmapControl.TEXTBOX, INPUT_TEXT_FONT_SIZE, ""/*str*/, 0x252525, 192, txt.y + txt.height/2 - TEXTBOX_HEIGHT/2, "left", "NanumBarunGothic");
			(pw_obj.txt as TextField).name = "PW";
			(pw_obj.txt as TextField).addEventListener(MouseEvent.CLICK, onClickInputText);
			(pw_obj.txt as TextField).addEventListener(FocusEvent.FOCUS_OUT, onFocusInputText);
			_displays.addObject(pw_obj.bmp); _displays.addObject(pw_obj.txt);
			
			bmp = BitmapControl.newBitmap(BitmapControl.BUY_SEPERATE_LINE, 0, pw_obj.txt.y + pw_obj.txt.height + TEXT_Y_MARGIN);
			_displays.addObject(bmp);
			
			//성함	
			txt = Text.newText("성함", TEXT_FONT_SIZE, 0x2c2c2c, 35, bmp.y + bmp.height + TEXT_Y_MARGIN, "left", "NanumBarunGothic", 0, 0);
			_displays.addObject(txt);
			
			obj = Text.newInputTextbox(BitmapControl.TEXTBOX, INPUT_TEXT_FONT_SIZE, "", 0x252525, 192, txt.y + txt.height/2 - TEXTBOX_HEIGHT/2, "left", "NanumBarunGothic");
			(obj.txt as TextField).name = "name";
			//if(params.rsvMainData.comment_text)
			//	(obj.txt as TextField).text = params.rsvMainData.comment_text;
			(obj.txt as TextField).addEventListener(MouseEvent.CLICK, onClickInputText);
			(obj.txt as TextField).addEventListener(FocusEvent.FOCUS_OUT, onFocusInputText);
			_displays.addObject(obj.bmp); _displays.addObject(obj.txt);
			
			bmp = BitmapControl.newBitmap(BitmapControl.BUY_SEPERATE_LINE, 0, obj.txt.y + obj.txt.height + TEXT_Y_MARGIN);
			_displays.addObject(bmp);
			
			//이메일	
			txt = Text.newText("이메일", TEXT_FONT_SIZE, 0x2c2c2c, 35, bmp.y + bmp.height + TEXT_Y_MARGIN, "left", "NanumBarunGothic", 0, 0);
			_displays.addObject(txt);
			
			obj = Text.newInputTextbox(BitmapControl.TEXTBOX, INPUT_TEXT_FONT_SIZE, "", 0x252525, 192, txt.y + txt.height/2 - TEXTBOX_HEIGHT/2, "left", "NanumBarunGothic");
			(obj.txt as TextField).name = "email";
			(obj.txt as TextField).addEventListener(MouseEvent.CLICK, onClickInputText);
			(obj.txt as TextField).addEventListener(FocusEvent.FOCUS_OUT, onFocusInputText);
			_displays.addObject(obj.bmp); _displays.addObject(obj.txt);
			
			bmp = BitmapControl.newBitmap(BitmapControl.BUY_SEPERATE_LINE, 0, obj.txt.y + obj.txt.height + TEXT_Y_MARGIN);
			_displays.addObject(bmp);
			
			//전화번호
			txt = Text.newText("전화번호", TEXT_FONT_SIZE, 0x2c2c2c, 35, bmp.y + bmp.height + TEXT_Y_MARGIN, "left", "NanumBarunGothic", 0, 0);
			_displays.addObject(txt);
			
			//var str:String = (params.rsvMainData.phone_text) ? "" : PHONE_BASE_TEXT;
			var phone_obj:Object = Text.newInputTextbox(BitmapControl.TEXTBOX, INPUT_TEXT_FONT_SIZE, ""/*str*/, 0x252525, 192, txt.y + txt.height/2 - TEXTBOX_HEIGHT/2, "left", "NanumBarunGothic");
			(phone_obj.txt as TextField).name = "phone";
			//if(params.rsvMainData.phone_text)
			{
				//	(phone_obj.txt as TextField).text = params.rsvMainData.phone_text;
			}
			(phone_obj.txt as TextField).addEventListener(Event.CHANGE, function(e:Event):void
			{
				if(isNaN(e.currentTarget.text.substr(e.currentTarget.text.length-1)))
				{
					e.currentTarget.text = e.currentTarget.text.substr(0, e.currentTarget.length-1);
				}
			});
			(phone_obj.txt as TextField).addEventListener(MouseEvent.CLICK, onClickInputText);
			(phone_obj.txt as TextField).addEventListener(FocusEvent.FOCUS_OUT, onFocusInputText);
			_displays.addObject(phone_obj.bmp); _displays.addObject(phone_obj.txt);
			
			bmp = BitmapControl.newBitmap(BitmapControl.BUY_SEPERATE_LINE, 0, phone_obj.txt.y + phone_obj.txt.height + TEXT_Y_MARGIN);
			_displays.addObject(bmp);
			
			//판매자 계정 버튼
			_btn_is_seller = new Button(BitmapControl.IS_SELLER_UP, BitmapControl.IS_SELLER_ON, null, 413, bmp.y + bmp.height + TEXT_Y_MARGIN/2, false, true);
			_displays.addObject(_btn_is_seller);
			
			//약관 버튼
			_btn_term = new Button(BitmapControl.TERM_DISAGREE, BitmapControl.TERM_AGREE, null, 413, _btn_is_seller.y + _btn_is_seller.height + TEXT_Y_MARGIN/2, false, true);
			_displays.addObject(_btn_term);
			
			//다음 버튼
			_btn_next = new Button(BitmapControl.BUY_COMPLETE_BUTTON, BitmapControl.BUY_COMPLETE_BUTTON, onButtonNext, 0, _btn_term.y + _btn_term.height + TEXT_Y_MARGIN/2);
			_btn_next.x = Elever.Main.PageWidth/2 - _btn_next.width/2;
			_displays.addObject(_btn_next);
			
		}
		private function onCarSelect(e:MouseEvent):void
		{
			Elever.Main.changePage("ListPage", PageEffect.LEFT, { number:(e.currentTarget as WebImage).name });
		}
		private function onClickInputText(e:MouseEvent):void
		{
			if(e.type == MouseEvent.CLICK)
			{
				anchor(-(e.currentTarget as TextField).y + BASE_Y_INTERVAL);
			}
		}
		private function onFocusInputText(e:FocusEvent):void
		{
			if(e.type == FocusEvent.FOCUS_OUT)
			{
				if(stage.focus == null)
					anchor(0);
			}
		}
		private function anchor(y:Number):void
		{
			TweenLite.to(_displays, ANCHOR_TWEEN_DURATION, { y:y });
		}
		private function onButtonNext(e:MouseEvent):void
		{
			if(checkNext())
			{
				var popup:Popup = new Popup(Popup.YESNO_TYPE, { main_text:"회원가입 하시겠습니까?", callback:function(type:String):void
				{
					if(type == "yes")
					{
						//회원가입 처리
						var params:URLVariables = new URLVariables;
						params.id = (_displays.scroller.getChildByName("ID") as TextField).text;
						params.password = (_displays.scroller.getChildByName("PW") as TextField).text;
						params.name = (_displays.scroller.getChildByName("name") as TextField).text;
						params.email = (_displays.scroller.getChildByName("email") as TextField).text;
						params.type = (_btn_is_seller.isTabbed) ? "1" : "0";
						params.phone = (_displays.scroller.getChildByName("phone") as TextField).text;;
						
						//아이디, 비번, 이름, 이메일, 타입
						Elever.Main.LoadingVisible = true;
						Elever.Connection.post("temp5.jsp", params, function(data:String):void
						{
							Elever.Main.LoadingVisible = false;
							if(data)
							{
								var result:Object = JSON.parse(data);
								
								if(result)
								{
									if(result.success == "1")
									{
										//Elever._user_info = result;
										Elever.Main.changePage("LoginPage");
									}
								}
							}
						});
					}
				}});
			}
		}
		private function checkNext():Boolean
		{
			anchor(0);
			var error_msg:String = "";
			
			if(!_btn_term.isTabbed) error_msg = "약관에 동의해주세요.";
			
			if((_displays.scroller.getChildByName("phone") as TextField).text.length != 11) error_msg = "전화번호가 올바르지 않습니다.";
			if((_displays.scroller.getChildByName("phone") as TextField).text == PHONE_BASE_TEXT) error_msg = "전화번호를 입력해주세요.";
			var emailExpression:RegExp = /^[\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
			if(!emailExpression.test((_displays.scroller.getChildByName("email") as TextField).text))
				error_msg = "이메일이 올바르지 않습니다.";
			if((_displays.scroller.getChildByName("email") as TextField).text.length == 0) error_msg = "이메일을 입력해주세요.";
			if((_displays.scroller.getChildByName("name") as TextField).text.length == 0) error_msg = "성함을 입력해주세요.";
			if((_displays.scroller.getChildByName("PW") as TextField).text.length == 0) error_msg = "비밀번호를 입력해주세요.";
			if((_displays.scroller.getChildByName("ID") as TextField).text.length == 0) error_msg = "아이디를 입력해주세요.";

			
			if(error_msg == "")
				return true;
			else
			{
				var popup:Popup = new Popup(Popup.OK_TYPE, { main_text:error_msg });
				return false;
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
//			var obj:Object = (Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).previousPage.page_params;
//			
//			obj.rsvMainData.name_text = (_displays.scroller.getChildByName("name") as TextField).text;
//			var phone_str:String = (_displays.scroller.getChildByName("phone") as TextField).text;
//			obj.rsvMainData.phone_text = (phone_str == PHONE_BASE_TEXT) ? "" : phone_str;
//			obj.rsvMainData.comment_text = (_displays.scroller.getChildByName("comment") as TextField).text;
//			obj.rsvMainData.term_yn = _btn_term.isTabbed;
//			
//			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).previousPage.page_params = obj;
		}
	}
}

