//brainAccountNotLoginPage
package Page.Account
{	
	import com.thanksmister.touchlist.controls.TouchList;
	import com.thanksmister.touchlist.renderers.DisplayObjectItemRenderer;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
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
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.LoaderContext;
	import flash.text.AntiAliasType;
	import flash.text.ReturnKeyLabel;
	import flash.text.SoftKeyboardType;
	import flash.text.StageText;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import Page.BasePage;
	
	import kr.pe.hs.tween.Tween;
	import kr.pe.hs.ui.TabbedButton;
	
	public class Index2 extends BasePage
	{
		[Embed(source = "assets/page/account/index1/title.png")]
		private static const TITLE:Class;
		
		[Embed(source = "assets/top_menu/button_prev.png")]
		private static const BUTTON_PREV:Class;
		
		[Embed(source = "assets/page/account/index2/login_info.png")]
		private static const LOGIN_INFO:Class;
		[Embed(source = "assets/page/account/index2/login_info_bg.png")]
		private static const LOGIN_INFO_BG:Class;
		private var _login_info:TabbedButton;
		
		[Embed(source = "assets/page/account/index2/test_baby.png")]
		private static const TEST_BABY:Class;
		//임시
		[Embed(source = "assets/page/account/index2/index_bg.png")]
		private static const INDEX_BG:Class;
		private var _index_bg:Bitmap;
		//private var _list_bg:Vector.<Bitmap>;
		
		//private var _list_text:Vector.<TextField>;
		//private var _txt_text:Vector.<String>;
		
		[Embed(source = "assets/page/account/manage_baby/frame.png")]
		private static const PROFILE_FRAME:Class;
		[Embed(source = "assets/page/account/manage_baby/default_img.png")]
		private static const NO_PROFILE:Class;
		private var _profile:Sprite;
		private var _profileLoader:Loader;
		private var _profileCache:Loader;
		private var _profileArea:Bitmap;
		//private var _list_thumbnail:Bitmap;
		
		public function Index2()
		{
			Brain.Main.LoadingVisible = false;
			super();
			this.addEventListener(MouseEvent.CLICK, onTouch);
			
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
			
			//초기화
			var params:URLVariables = new URLVariables;
			params.user_seq = Brain.UserInfo.user_seq;
			Brain.Connection.post("childListAction.cog", params, onLoadComplete);
		}
		
		private function onLoadComplete(data:String):void
		{	
			if(data)
			{
				var result:Object = JSON.parse(data);
				//				output
				//				1. j_user_seq
				//				2. j_list
				//				- user_seq : 사용자번호
				//				- child_seq : 자식번호
				//				- child_name : 자식이름
				//				- child_year : 년도
				//				- child_sex : 성별
				//				- child_pic : 사진경로
				//				- child_pic_thumbnail : 썸네일경로
				if(result.j_errorMsg.length>0)
				{
					new Alert(result.j_errorMsg).show();
					return;
				}
				
				var text:String = "";
				for(var i:int; i < result.j_list.length; i++)
				{
					if(result.j_list[i].child_seq == Brain.UserInfo.child_seq)
					{
						text = "";
						text = text + result.j_list[i].child_year + "년생 ";
						if(result.j_list[i].child_sex == "1")
							text = text + "남아\n";
						else if(result.j_list[i].child_sex == "2")
							text = text + "여아\n";
						text = text + result.j_list[i].child_name;
					}
				}
				//list_bg
				_index_bg = new INDEX_BG;
				_index_bg.smoothing = true;
				_index_bg.x = 0;
				_index_bg.y = 257-Brain.TopMenuHeight;
				addChild(_index_bg);
				//text				
				var txt:TextField = new TextField;
				txt.x = 96.61; txt.y = 257-Brain.TopMenuHeight+39.5; txt.width = 400; txt.height = 19*1.3*2;
				var fmt:TextFormat = txt.defaultTextFormat;
				fmt.color = 0x585858;
				fmt.font="Main";
				fmt.size = 19;
				fmt.align = "left";
				txt.embedFonts = true;
				txt.defaultTextFormat = fmt;
				txt.antiAliasType = AntiAliasType.ADVANCED;
				if(text == "")
				{
					txt.text = "선택된 검사 아동이 없습니다.\n검사 아동을 추가해주세요.";
					Brain.UserInfo = { user_seq:Brain.UserInfo.user_seq, child_seq:-1, rep_child_yn:false };		//-1하면 반복시에 없다고 뜰거임.
					Brain.saveEnviroment();
				}
				else
				{
					txt.text = text;
					Brain.UserInfo = { 
						user_seq:Brain.UserInfo.user_seq,
						child_seq:Brain.UserInfo.child_seq,
						child_pic:Brain.UserInfo.child_pic,
						child_pic_thumbnail:Brain.UserInfo.child_pic_thumbnail,
						rep_child_yn:true 
					};
					Brain.saveEnviroment();
				}
				addChild(txt);
				
				initializeData();
				
				return;
			}
			
			new Alert("데이터 저장 실패.").show();
		}
		private function initializeData():void
		{
			//thumbnail있을때랑 없을때 다르게.
			//앨범쪽 코드 참고하셈.
			//나중에 혀.
			
			//bgs
			bmp = new LOGIN_INFO; 	 bmp.smoothing=true; bmp.x = 0; bmp.y =  80-Brain.TopMenuHeight; addChild(bmp);
			bmp = new TEST_BABY;  	 bmp.smoothing=true; bmp.x = 0; bmp.y = 207-Brain.TopMenuHeight; addChild(bmp);
			
			//login info
			var bmp:Bitmap    = new LOGIN_INFO_BG; bmp.smoothing    = true;
			var bmp_on:Bitmap = new LOGIN_INFO_BG; bmp_on.smoothing = true; bmp_on.alpha = 0.6;
			_login_info = new TabbedButton(bmp, bmp_on, bmp_on); _login_info.x = 0; _login_info.y = 129-Brain.TopMenuHeight;
			_login_info.addEventListener(MouseEvent.CLICK, loginInfoClicked); addChild(_login_info);
			//text
			
			var txt:TextField = new TextField;
			txt.x = 33; txt.y = 159-Brain.TopMenuHeight; txt.width = 450; txt.height = 19*1.3;
			var fmt:TextFormat = txt.defaultTextFormat;
			fmt.color = 0x585858;
			fmt.font = "Main";
			fmt.size = 19;
			fmt.align = "left";
			txt.embedFonts = true;
			txt.defaultTextFormat = fmt;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.text = Brain.Account.user_email;
			addChild(txt);
			
			_profile=new Sprite;
			
			_profileArea=new NO_PROFILE; _profileArea.smoothing=true;
			_profileArea.x=2; _profileArea.y=1;
			_profile.addChild(_profileArea);
			
			if(Brain.UserInfo.child_pic!=null && Brain.UserInfo.child_pic.length>0)
			{
				_profileLoader=new Loader;
				_profileLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onProfileLoadComplete);
				_profileLoader.load(new URLRequest(Config.SERVER_PATH+Brain.UserInfo.child_pic));
				
				var file:File=File.applicationStorageDirectory.resolvePath("cache/profile.jpg");
				if(file.exists){
					_profileCache=new Loader;
					_profileCache.contentLoaderInfo.addEventListener(Event.COMPLETE,onProfileLoadComplete);
					
					var bytes:ByteArray=new ByteArray;
					
					var fs:FileStream=new FileStream;
					fs.open(file,FileMode.READ);
					fs.readBytes(bytes);
					fs.close();
					
					var loaderContext:LoaderContext=new LoaderContext;
					loaderContext.allowCodeImport=false;
					loaderContext.allowLoadBytesCodeExecution=true;
					
					//_profileCache.loadBytes(bytes,loaderContext);
					//_profileCache.load(new URLRequest(file.url));
				}
			}
			
			var bmpFrame:Bitmap=new PROFILE_FRAME; bmpFrame.smoothing=true;
			_profile.addChild(bmpFrame);
			
			_profile.x=28;
			_profile.y=292-Brain.TopMenuHeight;
			addChild(_profile);
		}
		private function onProfileLoadComplete(e:Event):void
		{
			if(_profileLoader==null) return;
			
			var loaderInfo:LoaderInfo=e.currentTarget as LoaderInfo;
			var loader:Loader=loaderInfo.loader;
			
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onProfileLoadComplete);
			if(loader.content is Bitmap){
				(loader.content as Bitmap).smoothing=true;
			}
			
			if(_profileLoader==loader){
				if(_profileCache!=null){
					_profileCache.contentLoaderInfo.removeEventListener(Event.COMPLETE,onProfileLoadComplete);
					if(_profileCache.parent) 
						_profileCache.parent.removeChild(_profileCache);
					_profileCache=null;
				}
				
				var file:File=File.applicationStorageDirectory.resolvePath("cache/profile.jpg");
				file.parent.createDirectory();
				if(!file.exists || file.size!=_profileLoader.contentLoaderInfo.bytesTotal)
				{
					var fs:FileStream=new FileStream;
					fs.open(file,FileMode.WRITE);
					fs.writeBytes(_profileLoader.contentLoaderInfo.bytes);
					fs.close();
				}
			}
			
			loader.width=56;
			loader.height=56;
			if(loader.scaleX<loader.scaleY)
				loader.scaleX=loader.scaleY;
			else
				loader.scaleY=loader.scaleX;
			
			loader.x=2+56/2-loader.width/2;
			loader.y=1+56/2-loader.height/2;
			
			loader.mask=_profileArea;
			_profile.addChildAt(loader,_profile.numChildren-1);
			
			Brain.Main.invalidateAnimateBitmap();
		}
		private function prevClicked(e:MouseEvent):void
		{
			Brain.Main.setPage("brainMainPage", null, BrainPageEffect.RIGHT, BrainPageEffect.RIGHT);
		}
		private function loginInfoClicked(e:MouseEvent):void
		{
			Brain.Main.setPage("brainAccountInfoPage");
		}
		private function onTouch(e:MouseEvent):void
		{
			if(_index_bg.y <= this.mouseY && this.mouseY <= _index_bg.y + _index_bg.height)
				Brain.Main.setPage("brainAccountBabyManagePage");
		}
		public override function onResize():void
		{
		}
		
		public override function dispose():void
		{
			Brain.Main.TopMenu.LeftButton.removeEventListener(MouseEvent.CLICK, prevClicked);
			
			_login_info.removeEventListener(MouseEvent.CLICK, loginInfoClicked);
			_login_info = null;
		}
	}
}
