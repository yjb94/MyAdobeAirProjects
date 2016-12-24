package Page.Etc
{
	import com.facebook.graph.FacebookMobile;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.URLVariables;
	import flash.text.TextField;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.Text;
	
	import Footer.TabBar;
	
	import Header.Header;
	import Header.NavigationBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	
	public class Login extends BasePage
	{
		private var _id_spr:Sprite = new Sprite;
		private var _pw_spr:Sprite = new Sprite;
		
		private var _find_pw:Button;
		
		private var _fb_login:Button;
		private var _login_btn:Button;
		
		private var _join_spr:Sprite = new Sprite;
		
		//facebook
		private const APP_ID:String = "271344896402165";
		private const PERMISSIONS:Array = ["email", "user_birthday"];
		private var _facebookWebView:StageWebView;
		
		//params
		private var _params:Object = new Object;
		
		public function Login(params:Object=null)
		{
			super();
			_params = params;
			
			if(params.clearPrev)
				(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).clearPrev();
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = Text.newText("로그인", 26, 0xffffff);
			if(_params.noFooter && !params.clearPrev)
				(Elever.Main.footer.getChildByName("TabBar") as Footer.TabBar).disable = true;
			
			//e-mail
			var txt:TextField = Text.newText("이메일", 26);
			var obj:Object = Text.newInputTextbox(BitmapControl.TEXTFIELD, 26, "", 0x000000, txt.x + 120, txt.y - 8);
			(obj.txt as TextField).name = "text";
			if(params.email) (obj.txt as TextField).text = params.email;
			_id_spr.x = 50;	_id_spr.y = 70;
			_id_spr.addChild(obj.bmp); _id_spr.addChild(obj.txt);
			_id_spr.addChild(txt);
			addChild(_id_spr);
			
			//password
			txt = Text.newText("비밀번호", 26);
			obj = Text.newInputTextbox(BitmapControl.TEXTFIELD, 26, "", 0x000000, txt.x + 120, txt.y - 8);
			(obj.txt as TextField).displayAsPassword = true;
			(obj.txt as TextField).name = "text";
			if(params.password) (obj.txt as TextField).text = params.password;
			_pw_spr.x = 50; _pw_spr.y = 140;
			_pw_spr.addChild(obj.bmp); _pw_spr.addChild(obj.txt);
			_pw_spr.addChild(txt);
			addChild(_pw_spr);
			
			//find pw
			_find_pw = new Button(BitmapControl.TEMP_BUTTON_UP, BitmapControl.TEMP_BUTTON_DOWN, onFindPassword);
			_find_pw.x = Elever.Main.PageWidth-250;
			_find_pw.y = _pw_spr.y+_pw_spr.height+30;
			addChild(_find_pw);
			
			//facebook login
			_fb_login = new Button(BitmapControl.TEMP_BUTTON_UP, BitmapControl.TEMP_BUTTON_DOWN, onFacebookLogin);
			_fb_login.x = 20;
			_fb_login.y = _find_pw.y+_find_pw.height+30;
			addChild(_fb_login);
			
			//login
			_login_btn = new Button(BitmapControl.TEMP_BUTTON_UP, BitmapControl.TEMP_BUTTON_DOWN, onLogin);
			_login_btn.x = _find_pw.x;
			_login_btn.y = _find_pw.y+_find_pw.height+30;
			addChild(_login_btn);
			
			//join
			txt = Text.newText("아직 엘루비 회원이 아니신가요?", 19);
			var btn:Button = new Button(BitmapControl.TEMP_BUTTON_UP, BitmapControl.TEMP_BUTTON_DOWN, onJoin,
				txt.x+txt.width/2, txt.y+txt.height+50, true);
			_join_spr.addChild(txt);
			_join_spr.addChild(btn);
			_join_spr.x = Elever.Main.PageWidth/2 - _join_spr.width/2;
			_join_spr.y = _login_btn.y + _login_btn.height + 50;
			addChild(_join_spr);
			
		}
		private function onFacebookInit(response:Object, fail:Object):void
		{
			if(response)
			{
				onFacebookLoginFinished(response, fail);
			}
			else
			{
				trace("not logged in");
				_facebookWebView = new StageWebView();
				_facebookWebView.stage = stage;
				Elever.Main.LoadingVisible = true;
				_facebookWebView.addEventListener(Event.COMPLETE, function(e:Event):void{ Elever.Main.LoadingVisible = false; });
				var g_pt:Point = this.localToGlobal(new Point(0, 0));
				var g_size:Point = this.localToGlobal(new Point(Elever.Main.FullWidth, Elever.Main.FullHeight));
				_facebookWebView.viewPort = new Rectangle(0, 0, g_size.x, g_size.y);
				FacebookMobile.login(onFacebookLoginFinished, stage, PERMISSIONS, _facebookWebView);
			}
		}
		
		private function onFindPassword(e:MouseEvent=null):void
		{
			_params.email = (_id_spr.getChildByName("text") as TextField).text;
			_params.password = (_pw_spr.getChildByName("text") as TextField).text;
			_params.clearPrev = false;
			Elever.Main.changePage("FindPasswordPage", PageEffect.LEFT, _params);
		}
		private function onFacebookLogin(e:MouseEvent=null):void
		{
			//facebook api controls
			FacebookMobile.init(APP_ID, onFacebookInit);
			Elever.Main.LoadingVisible = true;
		}
		private var _is_fb_login:Boolean = false;
		private function onFacebookLoginFinished(response:Object, fail:Object):void
		{
			Elever.Main.LoadingVisible = false;
			
			if(_facebookWebView)
				_facebookWebView = null;
			
			if(response)
			{
				trace("logged in with facebook");
				_is_fb_login = true;
				
				var params:URLVariables = new URLVariables;
				params.user_email = response.user.email;
				params.user_gender = response.user.gender;
				params.user_birthday = response.user.birthday;
				params.user_name = response.user.name;
				params.facebook_id = response.uid;
				Elever.Main.LoadingVisible = true;
				Elever.Connection.post("facebookLogin", params, onLoadComplete);
			}
		}
		private function onLogin(e:MouseEvent=null):void
		{
			var params:URLVariables = new URLVariables;
			//input 
			//1. user_email : 사용자이메일
			//2. user_password : 사용자비밀번호
			params.user_email = (_id_spr.getChildByName("text") as TextField).text;
			params.user_password = (_pw_spr.getChildByName("text") as TextField).text;
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
					trace("Login Error : ID or Password error");
					return;
				}
				Elever.UserInfo = result.userInfoModel;
				Elever.AppData.isFB = _is_fb_login;
				Elever.saveEnviroment("AppData", Elever.AppData);
				Elever.saveUserEnviroment();
				
				if(_params.clearPrev)
					Elever.Main.changePage("HomePage");
				else
					(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).onPrevClick();
			}
		}
		private function onJoin(e:MouseEvent=null):void
		{
			_params.email = (_id_spr.getChildByName("text") as TextField).text;
			_params.password = (_pw_spr.getChildByName("text") as TextField).text;
			_params.clearPrev = false;
			Elever.Main.changePage("JoinPage", PageEffect.LEFT, _params);
		}
		
		public override function init():void
		{
		}
		public override function onResize():void
		{
		}
		
		public override function dispose():void
		{
			if(_facebookWebView)
				_facebookWebView = null;
		}
	}
}

