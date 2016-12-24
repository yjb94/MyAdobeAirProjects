package Page.Login
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLVariables;
	import flash.text.TextField;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.Popup;
	import Displays.SlideImage;
	import Displays.Text;
	import Displays.WebImage;
	
	import Header.NavigationBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	
	import Scroll.Scroll;
	
	"main/slide";
	public class Login extends BasePage
	{
		private const DRAG_COEFFICIENT:Number = 15*Config.ratio;
		
		private const FIRST_Y:Number = 844*Config.ratio;
		private const SECOND_Y:Number = 1304*Config.ratio;
		private const THIRD_Y:Number = 1777*Config.ratio;
		private const WIDTH_MARGIN:Number = 36*Config.ratio;
		
		private const TEXT_Y_MARGIN:Number = 40;
		
		private const TITLE_FONT_SIZE:Number = 50*Config.ratio;
		private const TEXT_FONT_SIZE:Number = 23.12;
		
		private const INPUT_TEXT_FONT_SIZE:Number = 42*Config.ratio;
		private const TEXTBOX_HEIGHT:Number = 58;
		
		private const TEXTBOX_MARGIN:Number = 30;
		
		private const ANCHOR_TWEEN_DURATION:Number = 0.3;
		private const BASE_Y_INTERVAL:Number = 100;
		
		private const BASE_Y:Number = 300;
		private var _displays:Sprite;

		private var _login_btn:Button;
		
		
		public function Login(params:Object=null)
		{
			super();
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).clearPrev();
			
			if(Elever._user_info != null)
			{
				(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = Text.newText("내정보", TITLE_FONT_SIZE, 0xffffff);
				
				//아이디		
				var txt:TextField = Text.newText("아이디", TEXT_FONT_SIZE, 0x2c2c2c,  35, TEXT_Y_MARGIN+20, "left", "NanumBarunGothic", 0, 0);
				addChild(txt);
				
				txt = Text.newText(Elever._user_info.id, TEXT_FONT_SIZE, 0x3b3b3b, 0, txt.y, "right", "NanumBarunGothic", 574);
				addChild(txt);
				
				var bmp:Bitmap = BitmapControl.newBitmap(BitmapControl.BUY_SEPERATE_LINE, 0, txt.y + txt.height + TEXT_Y_MARGIN);
				addChild(bmp);
				
				//성함	
				txt = Text.newText("성함", TEXT_FONT_SIZE, 0x2c2c2c, 35, bmp.y + bmp.height + TEXT_Y_MARGIN, "left", "NanumBarunGothic", 0, 0);
				addChild(txt);
				
				txt = Text.newText(Elever._user_info.name, TEXT_FONT_SIZE, 0x3b3b3b, 0, txt.y, "right", "NanumBarunGothic", 574);
				addChild(txt);
				
				bmp = BitmapControl.newBitmap(BitmapControl.BUY_SEPERATE_LINE, 0, txt.y + txt.height + TEXT_Y_MARGIN);
				addChild(bmp);
				
				//이메일	
				txt = Text.newText("이메일", TEXT_FONT_SIZE, 0x2c2c2c, 35, bmp.y + bmp.height + TEXT_Y_MARGIN, "left", "NanumBarunGothic", 0, 0);
				addChild(txt);
				
				txt = Text.newText(Elever._user_info.email, TEXT_FONT_SIZE, 0x3b3b3b, 0, txt.y, "right", "NanumBarunGothic", 574);
				addChild(txt);
				
				bmp = BitmapControl.newBitmap(BitmapControl.BUY_SEPERATE_LINE, 0, txt.y + txt.height + TEXT_Y_MARGIN);
				addChild(bmp);
				
				//전화번호
				txt = Text.newText("전화번호", TEXT_FONT_SIZE, 0x2c2c2c, 35, bmp.y + bmp.height + TEXT_Y_MARGIN, "left", "NanumBarunGothic", 0, 0);
				addChild(txt);
				
				txt = Text.newText(Elever._user_info.phone, TEXT_FONT_SIZE, 0x3b3b3b, 0, txt.y, "right", "NanumBarunGothic", 574);
				addChild(txt);
				
				bmp = BitmapControl.newBitmap(BitmapControl.BUY_SEPERATE_LINE, 0, txt.y + txt.height + TEXT_Y_MARGIN);
				addChild(bmp);
				
				if(Elever._user_info.type == "1")
				{
					txt = Text.newText("판매자 계정입니다.", TEXT_FONT_SIZE, 0x2c2c2c, 35, bmp.y + bmp.height + TEXT_Y_MARGIN, "left", "NanumBarunGothic", 0, 0);
					addChild(txt);
					
					bmp = BitmapControl.newBitmap(BitmapControl.BUY_SEPERATE_LINE, 0, txt.y + txt.height + TEXT_Y_MARGIN);
					addChild(bmp);
				}
				
				//가입 버튼
				var btn:Button = new Button(BitmapControl.LOGOUT_BUTTON, BitmapControl.LOGOUT_BUTTON, onLogout);
				btn.name = "logout";
				btn.x = Elever.Main.PageWidth/2 - btn.width/2;
				btn.y = bmp.y + bmp.height + 70;
				addChild(btn);
				
				return;
			}
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = Text.newText("로그인", TITLE_FONT_SIZE, 0xffffff);
			
			_displays = new Sprite;
			_displays.y = BASE_Y;
			addChild(_displays);
			
			//아이디
			txt = Text.newText("ID", TEXT_FONT_SIZE, 0x2c2c2c, 40, TEXTBOX_MARGIN/2);
			_displays.addChild(txt);
			
			var obj:Object = Text.newInputTextbox(BitmapControl.TEXTBOX, INPUT_TEXT_FONT_SIZE, "", 0x252525, 125, txt.y - TEXTBOX_MARGIN/2, "left", "NanumBarunGothic");
			(obj.txt as TextField).name = "ID";
			(obj.txt as TextField).addEventListener(MouseEvent.CLICK, onClickInputText);
			(obj.txt as TextField).addEventListener(FocusEvent.FOCUS_OUT, onFocusInputText);
			_displays.addChild(obj.bmp); _displays.addChild(obj.txt);
			
			//비번
			txt = Text.newText("PW", TEXT_FONT_SIZE, 0x2c2c2c, 40, obj.bmp.y + obj.bmp.height + TEXTBOX_MARGIN);
			_displays.addChild(txt);
			
			obj = Text.newInputTextbox(BitmapControl.TEXTBOX, INPUT_TEXT_FONT_SIZE, "", 0x252525, 125, txt.y - TEXTBOX_MARGIN/2, "left", "NanumBarunGothic");
			(obj.txt as TextField).name = "PW";
			(obj.txt as TextField).displayAsPassword = true;
			(obj.txt as TextField).addEventListener(MouseEvent.CLICK, onClickInputText);
			(obj.txt as TextField).addEventListener(FocusEvent.FOCUS_OUT, onFocusInputText);
			_displays.addChild(obj.bmp); _displays.addChild(obj.txt);
			
			//가입 버튼
			btn = new Button(BitmapControl.JOIN_BUTTON, BitmapControl.JOIN_BUTTON, onJoin);
			btn.name = "join";
			btn.x = Elever.Main.PageWidth/2 - btn.width - 20;
			btn.y = obj.bmp.y + obj.bmp.height + 70;
			_displays.addChild(btn);
			
			//로그인 버튼
			btn = new Button(BitmapControl.LOGIN_BUTTON, BitmapControl.LOGIN_BUTTON, onLogin);
			btn.name = "login";
			btn.x = Elever.Main.PageWidth/2 + 30;
			btn.y = obj.bmp.y + obj.bmp.height + 70;
			_displays.addChild(btn);
		}
		private function onLogout(e:MouseEvent):void
		{
			var popup:Popup = new Popup(Popup.YESNO_TYPE, { main_text:"정말로 로그아웃하시겠습니까?", callback:function(type:String):void
			{
				if(type == "yes")
				{
					Elever.removeEnviroment("user_info");
					Elever._user_info = null;
					Elever.Main.changePage("LoginPage", PageEffect.FADE, null, 0.37, true);
				}
			}});
		}
		private function onJoin(e:MouseEvent):void
		{
			Elever.Main.changePage("JoinPage");
		}
		private function onLogin(e:MouseEvent):void
		{
			var btn:Button = e.currentTarget as Button;
			
			var err_msg:String = checkError();
			if(err_msg != "")
			{
				new Popup(Popup.OK_TYPE, { main_text:err_msg });
			}
			else
			{
				//로그인 처리
				var params:URLVariables = new URLVariables;
				params.id = (_displays.getChildByName("ID") as TextField).text;
				params.password = (_displays.getChildByName("PW") as TextField).text;
				Elever.Main.LoadingVisible = true;
				Elever.Connection.post("temp2.jsp", params, function(data:String):void
				{
					Elever.Main.LoadingVisible = false;
					if(data)
					{
						var result:Object = JSON.parse(data);
						
						if(result)
						{
							if(result.isLogin == "1")
							{
								Elever._user_info = result;
								Elever.saveEnviroment("user_info", Elever._user_info);
								Elever.Main.changePage("LoginPage", PageEffect.FADE, null, 0.37, true);
							}
						}
					}
				});
			}
		}
		private function checkError():String
		{
			var err_msg:String = "";
			if((_displays.getChildByName("PW") as TextField).text == "")
				err_msg = "비밀번호를 입력해주세요";
			if((_displays.getChildByName("ID") as TextField).text == "")
				err_msg = "아이디를 입력해주세요";
			
			return err_msg;
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
					anchor(BASE_Y);
			}
		}
		private function anchor(y:Number):void
		{
			TweenLite.to(_displays, ANCHOR_TWEEN_DURATION, { y:y });
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