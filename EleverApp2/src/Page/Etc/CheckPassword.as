package Page.Etc
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLVariables;
	import flash.text.ReturnKeyLabel;
	import flash.text.SoftKeyboardType;
	import flash.text.StageText;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.Popup;
	import Displays.Text;
	
	import Footer.TabBar;
	
	import Header.Header;
	import Header.NavigationBar;
	import Header.TabBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	import Page.Home.Tabs.PrevItem;
	
	import Scroll.Scroll;
	
	public class CheckPassword extends BasePage
	{
		private static var DEFAULT_TEXT:String = "비밀번호를 입력해 주세요.";
		private static var UNSELECTED_ALPHA:Number = 0.7;
		
		private var _explain_text:TextField;
		
		private var _pw_spr:Sprite = new Sprite;
		
		private var _check_pw:Button;
		
		private var _params:Object;
		
		public function CheckPassword(params:Object=null)
		{
			super();
			_params = params;
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = Text.newText("비밀번호 확인", 26, 0xffffff);
			(Elever.Main.footer.getChildByName("TabBar") as Footer.TabBar).disable = true;
			
			//explaining text
			_explain_text = Text.newText("개인 정보를 안전하게 보호하기 위하여 비밀번호를 다시 한 번 확인합니다.\n항상 비밀번호는 다른 사람에게 노출되지 않도록 주의하세요.", 15, 0x000000, 0, 0, "center");
			_explain_text.x = Elever.Main.PageWidth/2 - _explain_text.width/2;
			_explain_text.y = 50;
			addChild(_explain_text);
			
			//e-mail
			var obj:Object = Text.newInputTextbox(BitmapControl.TEXTFIELD, 24, DEFAULT_TEXT);
			_pw_spr.addChild(obj.bmp); _pw_spr.addChild(obj.txt);
			(obj.txt as TextField).name = "password";
			(obj.txt as TextField).alpha = UNSELECTED_ALPHA;
			(obj.txt as TextField).addEventListener(FocusEvent.FOCUS_IN, onFocusEmail);
			(obj.txt as TextField).addEventListener(FocusEvent.FOCUS_OUT, onFocusEmail);
			_pw_spr.x = Elever.Main.PageWidth/2 - _pw_spr.width/2;
			_pw_spr.y = _explain_text.y + _explain_text.height + 30;
			addChild(_pw_spr);
			
			//send pw
			_check_pw = new Button(BitmapControl.TEMP_BUTTON_UP, BitmapControl.TEMP_BUTTON_DOWN, onCheckPassword);
			_check_pw.x = Elever.Main.PageWidth/2 - _check_pw.width/2;
			_check_pw.y = _pw_spr.y+_pw_spr.height+30;
			addChild(_check_pw);
		}
		private function onFocusEmail(e:FocusEvent):void
		{
			var txt:TextField = _pw_spr.getChildByName("password") as TextField;
			
			if(e.type == FocusEvent.FOCUS_IN)
			{
				if(txt.text == DEFAULT_TEXT)
				{
					txt.text = "";
					txt.alpha = 1.0;
				}
			}
			else if(e.type == FocusEvent.FOCUS_OUT)
			{
				if(txt.length == 0)
				{
					txt.text = DEFAULT_TEXT;
					txt.alpha = UNSELECTED_ALPHA;
				}
			}
		}
		private function onCheckPassword(e:MouseEvent=null):void
		{			
			var params:URLVariables = new URLVariables;
			params.user_email = Elever.UserInfo.user_email;
			params.user_password = (_pw_spr.getChildByName("password") as TextField).text;
			Elever.Main.LoadingVisible = true;
			Elever.Connection.post("loginRequest", params, onLoadComplete);
		}
		private function onLoadComplete(data:String):void
		{
			Elever.Main.LoadingVisible = false;
			
			if(data)
			{
				var result:Object = JSON.parse(data);
				
				if(result.userInfoModel.success == false)
				{
					new Popup(Popup.NONE_TYPE , "알림", "비밀번호가 일치하지 않습니다.", null);
					trace("CheckPassword Error : Password error");
					return;
				}
				Elever.UserInfo = result.userInfoModel;
				Elever.saveUserEnviroment();
				
				Elever.Main.changePage("ModifyUserInfoPage");
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

