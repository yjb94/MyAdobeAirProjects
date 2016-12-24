//brainAccountNotLoginPage
package Page.Account
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
	import flash.events.TouchEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.net.URLVariables;
	import flash.text.ReturnKeyLabel;
	import flash.text.SoftKeyboardType;
	import flash.text.StageText;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;
	
	import Page.BasePage;
	
	import kr.pe.hs.tween.Tween;
	import kr.pe.hs.ui.TabbedButton;
	
	public class Login extends BasePage
	{
		[Embed(source = "assets/page/account/login/title.png")]
		private static const TITLE:Class;
		
		[Embed(source = "assets/top_menu/button_prev.png")]
		private static const BUTTON_PREV:Class;
		
		[Embed(source = "assets/page/account/login/email.png")]
		private static const EMAIL:Class;
		[Embed(source = "assets/page/account/login/password.png")]
		private static const PASSWORD:Class;
		
		[Embed(source = "assets/page/account/login/button_login.png")]
		private static const BUTTON_LOGIN:Class;
		[Embed(source = "assets/page/account/login/button_login_on.png")]
		private static const BUTTON_LOGIN_ON:Class;
		private var _btn_login:TabbedButton;

		[Embed(source = "assets/page/account/login/textField.png")]
		private static const TEXTFIELD:Class;
		private var _email_text:TextField;
		private var _password_text:TextField;
		
		private var _touchList:TouchList;
		
		private var _listSprite:Vector.<Sprite>;

		public function Login()
		{
			super();
			
			_listSprite=new Vector.<Sprite>(1,true);
			_listSprite[0]=new Sprite;
			
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
			
			//bg s
			bmp = new EMAIL;		  bmp.smoothing = true; bmp.x = 45; bmp.y = 120-Brain.TopMenuHeight; _listSprite[0].addChild(bmp);
			bmp = new PASSWORD; 	  bmp.smoothing = true; bmp.x = 45; bmp.y = 252-Brain.TopMenuHeight; _listSprite[0].addChild(bmp);
			
			//login_button
			bmp = new BUTTON_LOGIN;
			bmp.smoothing=true;
			bmp_on = new BUTTON_LOGIN_ON;
			bmp_on.smoothing=true;
			_btn_login = new TabbedButton(bmp,bmp_on,bmp_on);
			_btn_login.x = 25;
			_btn_login.y = 400-Brain.TopMenuHeight;
			_btn_login.addEventListener(MouseEvent.CLICK, loginClicked);
			_listSprite[0].addChild(_btn_login);
			
			
			//textfields
			
			bmp = new TEXTFIELD; bmp.smoothing = true; bmp.x = 28; bmp.y = 154-Brain.TopMenuHeight; _listSprite[0].addChild(bmp);
			
			_email_text = new TextField;
			_email_text.type = TextFieldType.INPUT;
			_email_text.height = 32;
			var fmt:TextFormat = _email_text.defaultTextFormat; fmt.font = "Main"; fmt.size = _email_text.height/1.3; _email_text.defaultTextFormat = fmt;
			_email_text.embedFonts = true;
			_email_text.x = bmp.x + 10;
			_email_text.y = bmp.y + 12;
			_email_text.width = bmp.width - 20;
			_email_text.addEventListener(Event.CHANGE, EmailChanged);
			
			_listSprite[0].addChild(_email_text);
			
			
			bmp = new TEXTFIELD; bmp.smoothing = true; bmp.x = 28; bmp.y = 286-Brain.TopMenuHeight; _listSprite[0].addChild(bmp);
			
			_password_text = new TextField;
			_password_text.type = TextFieldType.INPUT;
			_password_text.height = 32;
			fmt = _password_text.defaultTextFormat; fmt.font = "Main"; fmt.size = _password_text.height/1.3; _password_text.defaultTextFormat = fmt;
			_password_text.embedFonts = true;
			_password_text.x = bmp.x + 10;
			_password_text.y = bmp.y + 12;
			_password_text.width = bmp.width - 20;
			_password_text.displayAsPassword = true;
			_password_text.addEventListener(Event.CHANGE, PasswordChanged);
			
			_listSprite[0].addChild(_password_text);
			
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
			Brain.Main.setPage("brainAccountNotLoginPage", null, BrainPageEffect.RIGHT, BrainPageEffect.RIGHT);
		}
		private function loginClicked(e:MouseEvent):void
		{
			//임시코드
			var params:URLVariables = new URLVariables;
			//				input 
			//				1. user_email : 사용자이메일
			//				2. user_password : 사용자비밀번호
			params.user_email = _email_text.text;
			params.user_password = _password_text.text;
			
			Brain.Connection.post("loginAction.cog", params, onLoadComplete);
		}
		private function onLoadComplete(data:String):void
		{	
			if(data)
			{
				var result:Object = JSON.parse(data);
				//				output
				//				1. j_user_seq
				//				2. j_userLoginModelO : 클래스로 넘김
				//				- user_seq : 사용자번호
				//				- loginYn : 로그인유무(Y, N)
				//				3. j_errorMsg : 에러메시지
				
				if(result.j_errorMsg.length>0)
				{
					new Alert(result.j_errorMsg).show();
					return;
				}
				
				if(result.j_userLoginModelO.loginYn == "Y")
				{
					if(result.j_userLoginModelO.child_seq != 0)
					{
						Brain.UserInfo = { user_seq:result.j_user_seq,
							child_seq:result.j_childInfo[0].child_seq,
							child_pic:result.j_childInfo[0].child_pic,
							child_pic_thumbnail:result.j_childInfo[0].child_pic_thumbnail,
							rep_child_yn:true };
					}
					else
						Brain.UserInfo = { user_seq:result.j_user_seq, child_seq:-1, rep_child_yn:false };
					Brain.Account = { user_email:_email_text.text, user_password:_password_text.text };
					Brain.saveEnviroment();
					
					Brain.Main.setPage("brainMainPage");
				}
				else
				{
					new Alert("로그인 실패").show();
				}
				
				return;
			}
		}
		public override function onResize():void
		{
		}
		private function EmailChanged(e:Event):void
		{	
			var sprite:Sprite = _email_text.parent as Sprite;
			
			_touchList.removeListItemAt(_touchList.itemCount-1);
			
			if(sprite.parent)
				sprite.parent.removeChild(sprite);
			
			_touchList.addListItem(new DisplayObjectItemRenderer(sprite));
		}
		private function PasswordChanged(e:Event):void
		{	
			var sprite:Sprite = _password_text.parent as Sprite;
			
			_touchList.removeListItemAt(_touchList.itemCount-1);
			
			if(sprite.parent)
				sprite.parent.removeChild(sprite);
			
			_touchList.addListItem(new DisplayObjectItemRenderer(sprite));
		}
		
		public override function dispose():void
		{
			Brain.Main.TopMenu.LeftButton.removeEventListener(MouseEvent.CLICK, prevClicked);
			
			_btn_login.removeEventListener(MouseEvent.CLICK, loginClicked);
			_btn_login = null;

			_email_text.removeEventListener(Event.CHANGE, EmailChanged);
			_email_text = null;
			
			_password_text.removeEventListener(Event.CHANGE, PasswordChanged);
			_password_text = null;
		}
	}
}
