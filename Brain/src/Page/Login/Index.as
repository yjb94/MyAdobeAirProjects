package Page.Login
{	
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.RemoteNotificationEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.net.URLVariables;
	import flash.text.ReturnKeyLabel;
	import flash.text.SoftKeyboardType;
	import flash.text.StageText;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;
	
	import Page.BasePage;
	
	import kr.pe.hs.tween.Tween;
	import kr.pe.hs.ui.TabbedButton;
	
	public class Index extends BasePage
	{	
		[Embed(source = "assets/page/login/index/start_button.png")]
		private static const START_BUTTON:Class;
		[Embed(source = "assets/page/login/index/start_button_on.png")]
		private static const START_BUTTON_ON:Class;
		private static var _btn_start:TabbedButton;
		
		
		[Embed(source = "assets/page/login/index/bg.png")]
		private static const BG:Class;
		
		private var _isCalled:Boolean = false;
		
		public function Index()
		{
			super();
			
			Brain.Main.TopMenuVisible = false;
			
			var bmp:Bitmap = new BG; bmp.smoothing = true; addChild(bmp);
			
			bmp = new START_BUTTON; bmp.smoothing = true;
			var bmp_on:Bitmap = new START_BUTTON_ON; bmp_on.smoothing = true;
			_btn_start = new TabbedButton(bmp, bmp_on, bmp_on);
			_btn_start.x = 155; _btn_start.y = 666;
			_btn_start.addEventListener(MouseEvent.CLICK, onStart);
			addChild(_btn_start);
		}
		private function onStart(e:MouseEvent):void
		{
			if(_isCalled)
				return;
			_isCalled = true;
			Brain.loadEnviroment();
			if(Brain.Account)		//계정 있을
			{
				Brain.Main.LoadingVisible = true;
				var params:URLVariables = new URLVariables;
				//				input 
				//				1. user_email : 사용자이메일
				//				2. user_password : 사용자비밀번호
				params.user_email = Brain.Account.user_email;
				params.user_password = Brain.Account.user_password;
				
				Brain.Connection.post("loginAction.cog", params, onLoadComplete);
			}
			else			//없을
			{
				setTimeout(changePage,1);
			}
		}
		private function onLoadComplete(data:String):void
		{	
			Brain.Main.LoadingVisible = false;
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
				Brain.saveEnviroment();
				Brain.Main.setPage("brainMainPage");
				
				return;
			}
			new Alert("로딩 실패.").show();
		}
		private function onAddedToStage(e:Event):void
		{
		}
		
		private function changePage():void
		{
			Brain.Main.setPage("brainMainPage");
		}
		public override function onResize():void
		{
		}
		
		public override function dispose():void
		{
//			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
	}
}