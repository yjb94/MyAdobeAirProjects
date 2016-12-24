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
	import Displays.Text;
	
	import Footer.TabBar;
	
	import Header.Header;
	import Header.NavigationBar;
	import Header.TabBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	import Page.Home.Tabs.PrevItem;
	
	import Scroll.Scroll;
	
	public class FindPassword extends BasePage
	{
		private static var DEFAULT_TEXT:String = "이메일 주소를 입력해 주세요.";
		private static var UNSELECTED_ALPHA:Number = 0.7;
		
		private var _explain_text:TextField;
		
		private var _id_spr:Sprite = new Sprite;
		
		private var _send_pw:Button;
		
		private var _params:Object;
		
		public function FindPassword(params:Object=null)
		{
			super();
			_params = params;
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = Text.newText("비밀번호 찾기", 26, 0xffffff);
			(Elever.Main.footer.getChildByName("TabBar") as Footer.TabBar).disable = true;
			
			//explaining text
			_explain_text = Text.newText("가입시에 사용한 이메일 주소를 입력하여 주세요.\n해당 이메일 주소로 임시 비밀번호를 발송해 드립니다.", 21);
			_explain_text.x = Elever.Main.PageWidth/2 - _explain_text.width/2;
			_explain_text.y = 50;
			addChild(_explain_text);
			
			//e-mail
			var obj:Object = Text.newInputTextbox(BitmapControl.TEXTFIELD, 24, DEFAULT_TEXT);
			_id_spr.addChild(obj.bmp); _id_spr.addChild(obj.txt);
			(obj.txt as TextField).name = "e-mail";
			(obj.txt as TextField).alpha = UNSELECTED_ALPHA;
			(obj.txt as TextField).addEventListener(FocusEvent.FOCUS_IN, onFocusEmail);
			(obj.txt as TextField).addEventListener(FocusEvent.FOCUS_OUT, onFocusEmail);
			_id_spr.x = Elever.Main.PageWidth/2 - _id_spr.width/2;
			_id_spr.y = _explain_text.y + _explain_text.height + 30;
			addChild(_id_spr);

			
			//send pw
			_send_pw = new Button(BitmapControl.TEMP_BUTTON_UP, BitmapControl.TEMP_BUTTON_DOWN, onSendPassword);
			_send_pw.x = Elever.Main.PageWidth/2 - _send_pw.width/2;
			_send_pw.y = _id_spr.y+_id_spr.height+30;
			addChild(_send_pw);
		}
		private function onFocusEmail(e:FocusEvent):void
		{
			var txt:TextField = _id_spr.getChildByName("e-mail") as TextField;
			
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
		private function onSendPassword(e:MouseEvent=null):void
		{
			var emailPattern : RegExp = /^[0-9a-zA-Z][-._a-zA-Z0-9]*@([0-9a-zA-Z][-._0-9a-zA-Z]*\.)+[a-zA-Z]{2,4}$/;
			var txt:TextField = _id_spr.getChildByName("e-mail") as TextField;
			if(txt.text.match(emailPattern) != null)
			{
				var params:URLVariables = new URLVariables;
				params.user_email = (_id_spr.getChildByName("e-mail") as TextField).text;
				Elever.Main.LoadingVisible = true;
				Elever.Connection.post("passwordRequest", params, function(data:String):void
				{
					Elever.Main.LoadingVisible = false;
					
					if(data)
					{
						var result:Object = JSON.parse(data);
						
						if(result.email_Check && result.isCheck)
						{
							_params.clearPrev = true;
							Elever.Main.changePage("LoginPage", PageEffect.LEFT, _params);
						}
						else
							trace("Find Password Error : no such email or not isCheck");
					}
				});
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