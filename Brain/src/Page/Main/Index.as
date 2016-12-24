package Page.Main
{	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.RemoteNotificationEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
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
	
	import CoverFlow.Cover;
	import CoverFlow.CoverFlow;
	
	import Page.BasePage;
	
	import Popup.LoginPopup;
	import Popup.TestPopup;
	
	import kr.pe.hs.tween.Tween;
	import kr.pe.hs.ui.TabbedButton;
	
	public class Index extends BasePage
	{
		[Embed(source = "assets/page/login/index/title.png")]
		private static const TITLE:Class;
		
		[Embed(source = "assets/page/login/index/menu_button.png")]
		private static const MENU_BUTTON:Class;
		
		[Embed(source = "assets/page/main/index/bottom_bg.png")]
		private static const BOTTOM_BG:Class;
		private static var _bmp_bottom:Bitmap;

		//[Embed(source = "assets/page/login/index/temp_img.png")]
		//private static const TEMP_BUTTON:Class;
		//private static var _btn_game:TabbedButton;
		
		
		[Embed(source = "assets/page/main/index/start_button.png")]
		private static const START_BUTTON:Class;
		[Embed(source = "assets/page/main/index/start_button_on.png")]
		private static const START_BUTTON_ON:Class;
		private static var _btn_start:TabbedButton;
		
		
		[Embed(source = "assets/page/main/index/button_help.png")]
		private static const BUTTON_HELP:Class;
		[Embed(source = "assets/page/main/index/button_help_on.png")]
		private static const BUTTON_HELP_ON:Class;
		[Embed(source = "assets/page/main/index/button_account.png")]
		private static const BUTTON_ACCOUNT:Class;
		[Embed(source = "assets/page/main/index/button_account_on.png")]
		private static const BUTTON_ACCOUNT_ON:Class;
		[Embed(source = "assets/page/main/index/button_test.png")]
		private static const BUTTON_TEST:Class;
		[Embed(source = "assets/page/main/index/button_test_on.png")]
		private static const BUTTON_TEST_ON:Class;
		private static const LEFT_BUTTONS:Vector.<Vector.<Class>>=Vector.<Vector.<Class>>([
			Vector.<Class>([BUTTON_TEST , BUTTON_TEST_ON]),
			Vector.<Class>([BUTTON_ACCOUNT , BUTTON_ACCOUNT_ON]),
			Vector.<Class>([BUTTON_HELP , BUTTON_HELP_ON])
		]);
		
		private var _leftMenu:LeftMenu;
		private var _saveMenu:int;
		
		private static var _coverFlow:CoverFlow;
		
		private var _coverFlow_loaded:Boolean = false;
		private var _server_loaded:Boolean = false;
		
		[Embed(source = "assets/page/main/index/frame.png")]
		private static const PROFILE_FRAME:Class;
		[Embed(source = "assets/page/main/index/default_profile.png")]
		private static const NO_PROFILE:Class;
		private static var _profile:Sprite;
		private var _profileLoader:Loader;
		private var _profileCache:Loader;
		private var _profileArea:Bitmap;
		
		private static var _txt_child:TextField;
		
		public function Index()
		{
			super();
			
			//Top Menu Control
			Brain.Main.TopMenu.clearAddedChild();
			Brain.Main.TopMenuVisible = true;
			//title
			var bmp:Bitmap = new TITLE;
			bmp.smoothing=true;
			Brain.Main.TopMenu.Title=bmp;
			//left menu
			bmp = new MENU_BUTTON;
			bmp.smoothing = true;
			var bmp_on:Bitmap = new MENU_BUTTON;
			bmp_on.smoothing = true;
			bmp_on.alpha = 0.6;
			var btn_left_top:TabbedButton = new TabbedButton(bmp, bmp_on, bmp_on);
			Brain.Main.TopMenu.LeftButton = btn_left_top;
			Brain.Main.TopMenu.LeftButton.addEventListener(MouseEvent.CLICK, menuClicked);
			
			this.addEventListener(MouseEvent.CLICK, onClicked);
			
			//server
			if(Brain.UserInfo)
			{
				var params:URLVariables = new URLVariables;
				params.user_seq = Brain.UserInfo.user_seq;
				Brain.Connection.post("childListAction.cog", params, onLoadComplete);
			}
			else
			{
				//Bottom Menu Control
				_bmp_bottom = new BOTTOM_BG; _bmp_bottom.smoothing = true; _bmp_bottom.x = 0; _bmp_bottom.y = Brain.Main.PageHeight - _bmp_bottom.height; addChild(_bmp_bottom);
				
				//text				
				_txt_child = new TextField;
				_txt_child.width = 400; _txt_child.height = 22*1.3; _txt_child.x = 75; _txt_child.y = Brain.Main.PageHeight - _txt_child.height/2 - _bmp_bottom.height/2;
				var fmt:TextFormat = _txt_child.defaultTextFormat;
				fmt.color = 0xffffff;
				fmt.font = "Main";
				fmt.size = 22;
				fmt.align = "left";
				_txt_child.embedFonts = true;
				_txt_child.defaultTextFormat = fmt;
				_txt_child.antiAliasType = AntiAliasType.ADVANCED;
				_server_loaded = true;
				_txt_child.text = "검사자 정보가 없습니다.";
				addChild(_txt_child);
				
				InitializeData();
			}
		
			//coverFlow
			_coverFlow = new CoverFlow(540, 269*2, startClicked);
			
			addChild(_coverFlow);
			_coverFlow.backgroundColor = 0xFFFFFF;
			_coverFlow.horizontalSpacing = 60;
			_coverFlow.centerMargin = 100;
			_coverFlow.selectedIndex = 2;
			_coverFlow.load("coverFlowImages.xml");
			_coverFlow.addEventListener(Event.COMPLETE, onCoverFlowLoaded);
			_coverFlow.addEventListener(ProgressEvent.PROGRESS, onCoverFlowProgress);
			
			_leftMenu = null;
			_saveMenu = -1;
		}
		private function onClicked(e:MouseEvent):void
		{
			if(_bmp_bottom)
			{
				if(_bmp_bottom.y <= this.mouseY && this.mouseY <= Brain.Main.PageHeight)
				{
					if(Brain.Account)
						Brain.Main.setPage("brainAccountLoginPage");
					else
						Brain.Main.setPage("brainAccountNotLoginPage");
				}
			}
		}
		private function onCoverFlowProgress(e:ProgressEvent):void 
		{
			trace("Coverflow progress: " + e.bytesLoaded + " / " + e.bytesTotal);
		}
		private function onCoverFlowLoaded(e:Event):void 
		{
			trace("Coverflow loaded and ready to go.");
			
			_coverFlow_loaded = true;
			
			InitializeData();
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
						text = result.j_list[i].child_name;
					}
				}
				//Bottom Menu Control
				_bmp_bottom = new BOTTOM_BG; _bmp_bottom.smoothing = true; _bmp_bottom.x = 0; _bmp_bottom.y = Brain.Main.PageHeight - _bmp_bottom.height; addChild(_bmp_bottom);
				
				//text				
				_txt_child = new TextField;
				_txt_child.width = 400; _txt_child.height = 22*1.3; _txt_child.x = 75; _txt_child.y = Brain.Main.PageHeight - _txt_child.height/2 - _bmp_bottom.height/2;
				var fmt:TextFormat = _txt_child.defaultTextFormat;
				fmt.color = 0xffffff;
				fmt.font = "Main";
				fmt.size = 22;
				fmt.align = "left";
				_txt_child.embedFonts = true;
				_txt_child.defaultTextFormat = fmt;
				_txt_child.antiAliasType = AntiAliasType.ADVANCED;
				_server_loaded = true;
				_txt_child.text = "검사자 정보가 없습니다.";
				addChild(_txt_child);
				if(text == "")
				{
					_txt_child.text = "검사자 정보가 없습니다.";
					Brain.UserInfo = { user_seq:Brain.UserInfo.user_seq, child_seq:-1, rep_child_yn:false };		//-1하면 반복시에 없다고 뜰거임.
					Brain.saveEnviroment();
				}
				else
				{
					_txt_child.text = text;
					Brain.UserInfo = { 
						user_seq:Brain.UserInfo.user_seq,
							child_seq:Brain.UserInfo.child_seq,
							child_pic:Brain.UserInfo.child_pic,
							child_pic_thumbnail:Brain.UserInfo.child_pic_thumbnail,
							rep_child_yn:true 
					};
					Brain.saveEnviroment();
				}
				addChild(_txt_child);
				_server_loaded = true;
				
				InitializeData();
				
				return;
			}
			
			new Alert("데이터 저장 실패.").show();
		}
		private function InitializeData():void
		{
			if(_coverFlow_loaded && _server_loaded)
			{
				var bmp_start:Bitmap=new START_BUTTON;
				bmp_start.smoothing=true;
				var bmp_start_on:Bitmap=new START_BUTTON_ON;
				bmp_start_on.smoothing=true;
				_btn_start = new TabbedButton(bmp_start,bmp_start_on,bmp_start_on);
				_btn_start.x = 86;
				_btn_start.y = _coverFlow.y+_coverFlow.height + (_bmp_bottom.y-(_coverFlow.y+_coverFlow.height))/2 - _btn_start.height/2;
				_btn_start.addEventListener(MouseEvent.CLICK, startClicked);
				addChild(_btn_start);
				
				_profile=new Sprite;
				
				_profileArea=new NO_PROFILE; _profileArea.smoothing=true;
				_profileArea.x=1; _profileArea.y=1;
				_profile.addChild(_profileArea);
				
				if(Brain.UserInfo)
				{
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
				}
				
				var bmpFrame:Bitmap=new PROFILE_FRAME; bmpFrame.smoothing=true;
				_profile.addChild(bmpFrame);
				
				_profile.x=14;
				_profile.y=Brain.Main.PageHeight-12-_profile.height;
				addChild(_profile);
			}
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
			
			loader.x=1+56/2-loader.width/2;
			loader.y=1+56/2-loader.height/2;
			
			loader.mask=_profileArea;
			_profile.addChildAt(loader,_profile.numChildren-1);
			
			Brain.Main.invalidateAnimateBitmap();
		}
		private function menuClicked(e:MouseEvent):void
		{
			if(!_leftMenu)
			{
				_leftMenu=new LeftMenu(LEFT_BUTTONS, leftMenuClicked);
				Brain.Main.addChild(_leftMenu);
			}
			if(!_leftMenu.isOpened)
				_leftMenu.isOpened = true;
		}
		private function leftMenuClicked(index:int):void
		{
			if(_leftMenu.isOpened)
			{
				_leftMenu.isOpened = false;
				
				if(index != 0)
				{
					//Brain.Main.LoadingVisible = true;
					addEventListener(Event.ENTER_FRAME, isLeftMenuClosed);
					_saveMenu = index;
				}
			}
		}
		private function isLeftMenuClosed(e:Event):void
		{
			if(_leftMenu.contentX == -455)
			{
				if(_saveMenu == 1)
				{
					if(Brain.Account)
						Brain.Main.setPage("brainAccountLoginPage");
					else
						Brain.Main.setPage("brainAccountNotLoginPage");
				}
				else if(_saveMenu == 2)
				{
					Brain.Main.setPage("brainHelpPage");
				}
			}
		}
		private function onTest(value:Boolean):void
		{
			if(value)
			{
				Brain.Main.setPage("brainAccountLoginPage");
			}
			else
			{
				//현재 coverflow에서 선택한 인덱스의 게임으로 넘어가는 코드로 바꾸삼.
				// 0 - 곰돌이 게임.
				Brain.GameIndex = _coverFlow.selectedIndex;
				Brain.Main.setPage("brainGameIndexPage");
			}
		}
		private function startClicked(e:MouseEvent):void
		{
			if(Brain.Account)
			{
				if(!Brain.UserInfo.rep_child_yn)
				{
					Brain.Main.showPopup(new TestPopup(onTest));
					
					if(_leftMenu)
					{
						if(_leftMenu.isOpened)
						{
							_leftMenu.isOpened = false;
							_leftMenu.dispose();
							Brain.Main.removeChild(_leftMenu);
							_leftMenu=null;
						}
					}
				}
				else
				{
					Brain.GameIndex = _coverFlow.selectedIndex;
					Brain.Main.setPage("brainGameIndexPage");
				}
			}
			else
			{
				Brain.Main.showPopup(new LoginPopup(popupClicked));
			}
		}
		private function popupClicked(value:Boolean):void
		{
			if(value)
				Brain.Main.setPage("brainAccountNotLoginPage");
			else
			{
				Brain.GameIndex = _coverFlow.selectedIndex;
				Brain.Main.setPage("brainGameIndexPage");
			}
			Brain.Main.closePopup();
		}
		public static function setXPos(x:int):void
		{
			_bmp_bottom.x = x;
			_txt_child.x = x+75;
			_btn_start.x = x+86;
			_coverFlow.x = x;
			_profile.x = x+14;
		}
		
		public override function onResize():void
		{
			if(_leftMenu) if(_leftMenu.isOpened) _leftMenu.onResize();
		}
		
//		private function CoveronResize(e:Event):void {
//			_coverFlow.width = stage.stageWidth;
//			_coverFlow.height = stage.stageHeight;
//		}
		
		public override function dispose():void
		{
			Brain.Main.TopMenu.LeftButton.removeEventListener(MouseEvent.CLICK, menuClicked);
			
			_btn_start.removeEventListener(MouseEvent.CLICK, startClicked);
			_btn_start = null;
			_bmp_bottom = null;
			
			removeEventListener(Event.ENTER_FRAME, isLeftMenuClosed);
			
			if(_leftMenu)
			{
				_leftMenu.dispose();
				Brain.Main.removeChild(_leftMenu);
				_leftMenu=null;
			}
		}
	}
}

