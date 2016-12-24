package Page.Etc
{
	import com.greensock.TweenLite;
	
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
	import Displays.Text;
	
	import Footer.TabBar;
	
	import Header.Header;
	import Header.NavigationBar;
	import Header.TabBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	import Page.Home.Tabs.PrevItem;
	
	import Scroll.Scroll;
	
	public class Join extends BasePage
	{
		private static var ANCHOR_TWEEN_DURATION:Number = 0.3;
		private static var BASE_Y_INTERVAL:Number = 30;
		
		private var _display:Scroll;
		
		private var _name_spr:Sprite = new Sprite;
		
		private var _gender_spr:Sprite = new Sprite;
		
		private var _dob_spr:Sprite = new Sprite;
		
		private var _phonenum_spr:Sprite = new Sprite;
		
		private var _email_spr:Sprite = new Sprite;
		
		private var _pw_spr:Sprite = new Sprite;
		private var _re_pw_spr:Sprite = new Sprite;
		
		private var _policy_agree:Button;
		private var _policy_display:Button;
		
		private var _finish:Button
		
		private var _params:Object;
		
		public function Join(params:Object=null)
		{
			super();
			_params = params;
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = Text.newText("회원 가입", 26, 0xffffff);
			(Elever.Main.footer.getChildByName("TabBar") as Footer.TabBar).disable = true;
			
			_display = new Scroll();
			addChild(_display);
			
			//name
			var txt:TextField = Text.newText("이름", 19);
			var obj:Object = Text.newInputTextbox(BitmapControl.TEXTFIELD, 26, "", 0x000000, txt.x + 120, txt.y - 8);
			(obj.txt as TextField).name = "text";
			(obj.txt as TextField).addEventListener(MouseEvent.CLICK, onClickInputText);
			(obj.txt as TextField).addEventListener(FocusEvent.FOCUS_OUT, onFocusInputText);
			_name_spr.addChild(obj.bmp); _name_spr.addChild(obj.txt);
			_name_spr.addChild(txt);
			_name_spr.x = 50;	_name_spr.y = 70;
			_display.addObject(_name_spr);
			
			//gender
			txt = Text.newText("성별", 19);
			var btn:Button = new Button(BitmapControl.TEMP_BUTTON_UP, BitmapControl.TEMP_BUTTON_DOWN, null, 0,0,false,true);
			btn.name = "button";
			btn.x = txt.x + 120;
			_gender_spr.addChild(btn);
			_gender_spr.addChild(txt);
			_gender_spr.x = _name_spr.x;
			_gender_spr.y = _name_spr.y + _name_spr.height + 20;
			_display.addObject(_gender_spr);
			
			//date of birth
			txt = Text.newText("생년월일", 19);
			obj = Text.newInputTextbox(BitmapControl.TEXTFIELD, 26, "", 0x000000, txt.x + 120, txt.y - 8);
			(obj.txt as TextField).name = "text";
			(obj.txt as TextField).addEventListener(MouseEvent.CLICK, onClickInputText);
			(obj.txt as TextField).addEventListener(FocusEvent.FOCUS_OUT, onFocusInputText);
			_dob_spr.addChild(obj.bmp); _dob_spr.addChild(obj.txt);
			_dob_spr.addChild(txt);
			_dob_spr.x = _name_spr.x;	_dob_spr.y = _gender_spr.y + _gender_spr.height + 30;
			_display.addObject(_dob_spr);
			
			//phone number
			txt = Text.newText("핸드폰", 19);
			obj = Text.newInputTextbox(BitmapControl.TEXTFIELD, 26, "", 0x000000, txt.x + 120, txt.y - 8);
			(obj.txt as TextField).name = "text";
			(obj.txt as TextField).addEventListener(MouseEvent.CLICK, onClickInputText);
			(obj.txt as TextField).addEventListener(FocusEvent.FOCUS_OUT, onFocusInputText);
			_phonenum_spr.addChild(obj.bmp); _phonenum_spr.addChild(obj.txt);
			_phonenum_spr.addChild(txt);
			_phonenum_spr.x = _name_spr.x;	_phonenum_spr.y = _dob_spr.y + _dob_spr.height + 30;
			_display.addObject(_phonenum_spr);
			
			//email
			txt = Text.newText("이메일", 19);
			obj = Text.newInputTextbox(BitmapControl.TEXTFIELD, 26, "", 0x000000, txt.x + 120, txt.y - 8);
			(obj.txt as TextField).name = "text";
			(obj.txt as TextField).addEventListener(MouseEvent.CLICK, onClickInputText);
			(obj.txt as TextField).addEventListener(FocusEvent.FOCUS_OUT, onFocusInputText);
			_email_spr.addChild(obj.bmp); _email_spr.addChild(obj.txt);
			_email_spr.addChild(txt);
			_email_spr.x = _name_spr.x;	_email_spr.y = _phonenum_spr.y + _phonenum_spr.height + 30;
			_display.addObject(_email_spr);
			
			//password
			txt = Text.newText("비밀번호", 19);
			obj = Text.newInputTextbox(BitmapControl.TEXTFIELD, 26, "", 0x000000, txt.x + 120, txt.y - 8);
			(obj.txt as TextField).name = "text";
			(obj.txt as TextField).displayAsPassword = true;
			(obj.txt as TextField).addEventListener(MouseEvent.CLICK, onClickInputText);
			(obj.txt as TextField).addEventListener(FocusEvent.FOCUS_OUT, onFocusInputText);
			_pw_spr.addChild(obj.bmp); _pw_spr.addChild(obj.txt);
			_pw_spr.addChild(txt);
			_pw_spr.x = _name_spr.x;	_pw_spr.y = _email_spr.y + _email_spr.height + 30;
			_display.addObject(_pw_spr);
			
			//re password
			txt = Text.newText("비밀번호 확인", 19);
			obj = Text.newInputTextbox(BitmapControl.TEXTFIELD, 26, "", 0x000000, txt.x + 120, txt.y - 8);
			(obj.txt as TextField).name = "text";
			(obj.txt as TextField).displayAsPassword = true;
			(obj.txt as TextField).addEventListener(MouseEvent.CLICK, onClickInputText);
			(obj.txt as TextField).addEventListener(FocusEvent.FOCUS_OUT, onFocusInputText);
			_re_pw_spr.addChild(obj.bmp); _re_pw_spr.addChild(obj.txt);
			_re_pw_spr.addChild(txt);
			_re_pw_spr.x = _name_spr.x;	_re_pw_spr.y = _pw_spr.y + _pw_spr.height + 30;
			_display.addObject(_re_pw_spr);
			
			//policy agree button
			_policy_agree = new Button(BitmapControl.TEMP_BUTTON_UP, BitmapControl.TEMP_BUTTON_DOWN, null, 0,0,false, true);
			_policy_agree.x = _name_spr.x - 20;
			_policy_agree.y = _re_pw_spr.y + _re_pw_spr.height + 30;
			_display.addObject(_policy_agree);
			
			//policy display button
			_policy_display = new Button(BitmapControl.TEMP_BUTTON_UP, BitmapControl.TEMP_BUTTON_DOWN, onPolicyDisplay);
			_policy_display.x = _policy_agree.x + _policy_agree.width + 20;
			_policy_display.y = _policy_agree.y;
			_display.addObject(_policy_display);
			
			//finish join button
			_finish = new Button(BitmapControl.TEMP_BUTTON_UP, BitmapControl.TEMP_BUTTON_DOWN, onFinish);
			_finish.x = Elever.Main.PageWidth/2 - _finish.width/2;
			_finish.y = _policy_agree.y + _policy_agree.height + 50;
			_display.addObject(_finish);
		}
		private function onClickInputText(e:MouseEvent):void
		{
			var spr:Sprite = (e.currentTarget as TextField).parent as Sprite;
			if(e.type == MouseEvent.CLICK)
			{
				anchor(-spr.y - _display.scroller.getY() + BASE_Y_INTERVAL);
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
			TweenLite.to(_display, ANCHOR_TWEEN_DURATION, { y:y });
		}
		private function onPolicyDisplay(e:MouseEvent):void
		{
			
		}
		private function onFinish(e:MouseEvent):void
		{
			if(isOktoFinish())
			{
				var params:URLVariables = new URLVariables;
				params.user_email = (_email_spr.getChildByName("text") as TextField).text;
				params.user_gender = (_gender_spr.getChildByName("button") as Button).isTabbed ? 0 : 1;
				//나중에 하이픈 넣어주는거 할 것. 3개 분리
				params.user_birthday = (_dob_spr.getChildByName("text") as TextField).text;
				params.user_password = (_pw_spr.getChildByName("text") as TextField).text;
				params.user_name = (_name_spr.getChildByName("text") as TextField).text;
				//나중에 하이픈 넣어주는거 할 것. 3개 분리
				params.user_phoneno = (_phonenum_spr.getChildByName("text") as TextField).text;
				Elever.Main.LoadingVisible = true;
				Elever.Connection.post("register", params, onLoadComplete);
			}
		}
		private function onLoadComplete(data:String):void
		{
			Elever.Main.LoadingVisible = false;
			
			if(data)
			{
				var result:Object = JSON.parse(data);
				
				if(result.email_check)		// email already exists
				{
					trace("Join Error : Email already exists");
					(_email_spr.getChildByName("text") as TextField).text = "";
				}
				else
				{
					Elever.UserInfo = result.userInfoModel;
					Elever.saveUserEnviroment();
					
					_params.clearPrev = true;
					_params.email = (_email_spr.getChildByName("text") as TextField).text;
					_params.password = "";
					Elever.Main.changePage("LoginPage", PageEffect.LEFT, _params);
					//(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).onPrevClick();
				}
			}
		}
		private function isOktoFinish():Boolean
		{
			if(_policy_agree.isTabbed == false)
			{
				trace("Join Error : Policy not agreed");
				return false;
			}
			
			if((_phonenum_spr.getChildByName("text") as TextField).text.length != 11)
			{
				trace("Join Error : Phone Number wrong data");
				(_phonenum_spr.getChildByName("text") as TextField).text = "";
				return false;
			}
			
			if((_dob_spr.getChildByName("text") as TextField).text.length != 8)
			{
				trace("Join Error : Date of Birth wrong data");
				(_dob_spr.getChildByName("text") as TextField).text = "";
				return false;
			}
			
			var emailPattern : RegExp = /^[0-9a-zA-Z][-._a-zA-Z0-9]*@([0-9a-zA-Z][-._0-9a-zA-Z]*\.)+[a-zA-Z]{2,4}$/;
			if((_email_spr.getChildByName("text") as TextField).text.match(emailPattern) == null)
			{
				trace("Join Error : Not an Email Pattern");
				(_email_spr.getChildByName("text") as TextField).text = "";
				return false;
			}
			
			if((_pw_spr.getChildByName("text") as TextField).text != (_re_pw_spr.getChildByName("text") as TextField).text)
			{
				trace("Join Error : Password and Repassword diffent");
				(_pw_spr.getChildByName("text") as TextField).text = "";
				(_re_pw_spr.getChildByName("text") as TextField).text = "";
				return false;
			}
			
			return true;
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

