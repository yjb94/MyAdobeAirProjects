package
{
	import com.greensock.TweenLite;
	import com.sticksports.nativeExtensions.SilentSwitch;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import Displays.BitmapControl;
	import Displays.Text;
	
	import Footer.Footer;
	import Footer.TabBar;
	
	import Header.Header;
	import Header.NavigationBar;
	
	import Page.BasePage;
	import Page.PageConnector;
	import Page.PageEffect;
	
	import Scroll.Scroll;
	
	import Utils.HTTPUtil;
	import Utils.JPEGAsyncCompleteEvent;
	import Utils.JPEGAsyncEncoder;
	
	import pl.mateuszmackowiak.nativeANE.dialogs.NativeAlertDialog;
	import pl.mateuszmackowiak.nativeANE.events.NativeDialogEvent;
	
	public class Elever extends Sprite
	{
		//UserInfo Model
		private static var _userInfo:Object = new Object;
		public static function get UserInfo():Object{ return _userInfo; }
		public static function set UserInfo(value:Object):void{ _userInfo = value; }
		
		private static var _appData:Object = new Object;
		public static function get AppData():Object{ return _appData; }
		public static function set AppData(value:Object):void 
		{ 
			if(value == null) 
				return;
			_appData = value;
			saveEnviroment("AppData", _appData);
		}
		
		//NowProject Model
		private static var _now_item_list:Array;
		public static function get NowItemList():Array{ return _now_item_list; }
		public static function set NowItemList(value:Array):void{ _now_item_list = value; }
		
		//PrevProject Model
		private static var _prev_item_list:Object;
		public static function get PrevItemList():Object{ return _prev_item_list; }
		public static function set PrevItemList(value:Object):void{ _prev_item_list = value; }
		
		public function get OsType():String { return Capabilities.os; }
		public function get IsIPhone():Boolean { return (OsType.substr(0,9)=="iPhone OS") ? true : false; }
		public function get IsIOS7():Boolean { return ((IsIPhone) && (OsType.substr(10,OsType.indexOf(" ",10)-10).substr(0,2)=="7.")) ? true : false; }
		//public function get IsAndroid():Boolean { return (Capabilities.cpuArchitecture == "ARM") ? true : false; }
		
		public function get TopMargin():Number { return IsIOS7 ? Config.TOP_MARGIN : 0; }
		//public function get HeaderHeight():Number { return (_header!=null) ? _header.height-7 : 0; }		//don't know why i have to minus 7
		public function get HeaderHeight():Number 
		{ 
			var height:Number = (_header!=null) ? _header.height : 0;
			if(_dictionary["NavigationBar"]) height -= _dictionary["NavigationBar"].height;
			if(_dictionary["SlideBar"]) 	 height -= _dictionary["SlideBar"].height;
			//if(_dictionary["HeaderTabBar"])	 height -= _dictionary["HeaderTabBar"].height;
			return height;
		}
		public function get FooterHeight():Number
		{
			var height:Number = (_footer != null) ? _footer.height : 0;
			if(_dictionary["TabBar"]) height -= dictionary["TabBar"].height;
			return height;
		}
		
		private static var _main:Elever;
		public static function get Main():Elever{ return _main; }
		
		private var _pageHeight:Number;
		public function get PageWidth():Number{ return FullWidth; }
		public function get PageHeight():Number { return _pageHeight; }
		public function get PageHeightForScroll():Number{ return FullHeight; }
		//원본 크기
		public function get FullWidth():Number{ return stage.stageWidth/scaleX; }
		public function get FullHeight():Number{ return stage.stageHeight/scaleY; }
		
		private var _displays:Scroll;
		public function get DisplayController():Sprite{ return _displays; }
		
		private var _cur_page_name:String = "";
		public function get CurPageName():String { return _cur_page_name; }
		private var _cur_page:BasePage = null;
		public function get CurPage():BasePage { return _cur_page; }
		public function set CurPage(page:BasePage):void { _cur_page = page; }
		private var _next_page:BasePage = null;
		public function get NextPage():BasePage { return _next_page; }
		
		private var _topLayer:Sprite;
		public function get topLayer():Sprite { return _topLayer; }
		private var _pageLayer:Sprite;
		public function get pageLayer():Sprite { return _pageLayer; }
		
		private var _header:Header;
		public function get header():Header { return _header; }
		//private var _clear_navigation:Boolean = false;
		//public function set clearNavigation(value:Boolean):void { _clear_navigation = value; }
		
		private var _footer:Footer;
		public function get footer():Footer { return _footer; }
		
		private var _dictionary:Dictionary = new Dictionary;		//A Dictionary to save datas to use all over the field.(HAVE TO REMOVE AFTER USAGE)
		public function get dictionary():Dictionary { return _dictionary; }
		public function deleteItemInDict(key:Object):void { if(_dictionary[key]) delete _dictionary[key]; }
		
		//loading
		private var _loader:Loader;
		private var _loadingAni:MovieClip;
		private var _loadingBG:Sprite;
		private var _loading:Sprite;
		public function set LoadingVisible(value:Boolean):void
		{
			if(_loading == null) return;
			
			if(value && !_loading.visible) addChild(_loading); 
			else if(!value && _loading.visible) removeChild(_loading);
			
			_loading.visible=value;
		}
		public function get LoadingVisible():Boolean{ return _loading.visible; }
		
		//server
		private static var _connection:HTTPUtil;
		public static function get Connection():HTTPUtil{ return _connection; }
		
		private static var _is_auto_login:Boolean = true;
//		private function loadIsAutoLogin():void
//		{
//			var appStorage:File=File.applicationStorageDirectory;
//			var dbFile:File = appStorage.resolvePath("AutoLogin.db");
//			if(dbFile.exists)
//			{
//				var fs:FileStream=new FileStream;
//				fs.open(dbFile,FileMode.READ);
//				var result:Object=JSON.parse(fs.readUTF());
//				fs.close();
//				
//				_is_auto_login = result;
//			}
//		}
		public static function refreshUserInfo():void
		{
			if(Elever.UserInfo == null)
			{
				trace("Refresh UserInfo Error : No UserInfo Initially");
				return;
			}
			var urlVar:URLVariables = new URLVariables;
			urlVar.user_seq = Elever.UserInfo.user_seq;
			Main.LoadingVisible = true;
			Elever.Connection.post("Modifypage", urlVar, function(data:String):void
			{
				Main.LoadingVisible = false;
				
				if(data)
				{
					var result:Object = JSON.parse(data);
					
					Elever.UserInfo = result.userInfoModel;
					saveUserEnviroment();
				}
			});
		}
		public static function loadUserEnviroment():void
		{
			_userInfo=null;
			
			var appStorage:File=File.applicationStorageDirectory;
			var dbFile:File = appStorage.resolvePath("config.db");
			if(dbFile.exists)
			{
				var fs:FileStream=new FileStream;
				fs.open(dbFile,FileMode.READ);
				var result:Object=JSON.parse(fs.readUTF());
				fs.close();
				
				_userInfo = result;
			}
		}
		public static function saveUserEnviroment():void
		{			
			var appStorage:File=File.applicationStorageDirectory;
			var dbFile:File = appStorage.resolvePath("config.db");
			var fs:FileStream=new FileStream;
			fs.open(dbFile,FileMode.WRITE);
			fs.writeUTF(JSON.stringify(_userInfo));
			fs.close();
		}
		public static function removeAllEnviroment():void
		{
			var appStorage:File = File.applicationStorageDirectory;
			var list:Array=appStorage.getDirectoryListing();
			for(var i:int=0;i<list.length;i++)
			{
				var file:File=list[i] as File;
				if((file.url.search("NowItem") == -1) && (file.url.search("PrevItem") == -1) && (file.url.search("Images") == -1))
				{
					if(file != null)
					{
						if(!file.isDirectory)
						{
							file.deleteFile();
						}
						else
						{
							file.deleteDirectoryAsync(true);
						}
					}
				}
			}
			loadUserEnviroment();
		}
		
		public static function loadEnviroment(url:String, obj:Object):Object
		{			
			var appStorage:File=File.applicationStorageDirectory;
			var dbFile:File = appStorage.resolvePath(url);
			if(dbFile.exists)
			{
				var fs:FileStream=new FileStream;
				fs.open(dbFile,FileMode.READ);
				var result:Object=JSON.parse(fs.readUTF());
				fs.close();
				
				obj = result;
				return result;
			}
			return null;
		}
		public static function saveEnviroment(url:String, obj:Object):void
		{		
			var appStorage:File = File.applicationStorageDirectory;
			var dbFile:File = appStorage.resolvePath(url);
			var fs:FileStream = new FileStream;
			fs.open(dbFile,FileMode.WRITE);
			fs.writeUTF(JSON.stringify(obj));
			fs.close();
		}		
		public function Elever()
		{
			super();
			
			if(IsIPhone) SilentSwitch.apply();	//iPhoneMute Control
			
			_main = this;	//set Main Object
			
			
			addEventListener(Event.ADDED_TO_STAGE, initialize);
			
			
			var _urlRequest:URLRequest = new URLRequest("Displays/assets/loading/loading.swf");
			_loader = new Loader();
			var _lc:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain, null);
			_loader.load(_urlRequest, _lc);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteLoad);
			
			_userInfo=null;
			_is_auto_login = loadEnviroment("AutoLogin.db", _is_auto_login);
			Elever.AppData = loadEnviroment("AppData", _appData);
			if(_is_auto_login)
				loadUserEnviroment();
			else
				removeAllEnviroment();
			
			
			if(!_connection) _connection=new HTTPUtil(Config.SERVER_PATH);
		}
		
		private function onCompleteLoad(e:Event):void
		{
			_loading=new Sprite;
			_loading.visible=false;
			
			_loadingBG=new Sprite;
			_loadingBG.graphics.beginFill(0x000000,0.6);
			_loadingBG.graphics.drawRect(0,0,100,100);
			_loadingBG.graphics.endFill();
			_loadingBG.cacheAsBitmap=true;
			_loading.addChild(_loadingBG);
			
			_loadingAni = MovieClip(_loader.contentLoaderInfo.content); //addChild 하려면 DisplayObject 로 캐스팅
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onCompleteLoad);
			_loading.addChild(_loadingAni);
			
			
			_loadingBG.x=0;
			_loadingBG.y=0;
			_loadingBG.width=FullWidth;
			_loadingBG.height=FullHeight;
			_loadingAni.x=_loadingBG.width/2-100/2;
			_loadingAni.y=_loadingBG.height/2-_loadingAni.height/2;
		}
		
/////////TEMPORARY FPS CODE from here//////////////////////////////////////////
		private var startTime:Number;
		private var framesNumber:Number = 0;
		private var fps:TextField = new TextField;
		private function fpsCounter():void
		{
			startTime = getTimer();
			_topLayer.addChild(fps);
			
			addEventListener(Event.ENTER_FRAME, checkFPS);
		}
		private function checkFPS(e:Event):void
		{
			var currentTime:Number = (getTimer() - startTime) / 100;
			
			framesNumber++;
			
			if(currentTime > 1)
			{
				var fmt:TextFormat = fps.defaultTextFormat;
				fmt.size = 20;
				fps.defaultTextFormat = fmt;
				fps.y = TopMargin;
				fps.x = FullWidth - fps.width;
				fps.text = "FPS: " + (Math.floor((framesNumber/currentTime)*10.0)/1.0);
				startTime = getTimer();
				framesNumber = 0;
			}
		}
////////to here////////////////////////////////////////////////////////////////
		public function initialize(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initialize);
			
			_topLayer = new Sprite;
			_pageLayer = new Sprite;
			addChild(_pageLayer);
			addChild(_topLayer);
			
			stage.frameRate = 60;	//set to 60 frame
			stage.color = Config.MainBGColor;	//set the stage background color(initial)
			stage.scaleMode = StageScaleMode.NO_SCALE;	//EXACT_FIT - 종횡 비율 유지안하고 전체표시
														//NO_BORDER - 종횡 비율 유지하고 전체표시
														//NO_SCALE - 디바이스 해상도 상관없이 크기 유지
														//SHOW_ALL - 종횡비율유지하고 지정영역에 표시
			stage.align = StageAlign.TOP_LEFT;	//align stage to left top

			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, onActivate, false, 0, true);		//Applictaion came back from background
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onDeactivate, false, 0, true);	//Application sent to background
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);//Applictaion button Clicked

			
			stage.addEventListener(Event.RESIZE, stage_onResize);
			
			NowItemList = loadEnviroment("NowItem", NowItemList) as Array;
			PrevItemList = loadEnviroment("PrevItem", PrevItemList) as Array;
			if((NowItemList == null) || (PrevItemList == null))
				setTimeout(LoadingPage, 1);
			else
				setTimeout(Render, 1);
		}
		private var _project_load_cnt:int = 0;
		private const PROJECT_LOAD_COMPLETED:int = 2;
		private var _loading_page_spr:Sprite;
		private function LoadingPage():void
		{
			_loading_page_spr = new Sprite;
			_loading_page_spr.graphics.beginFill(0xdd5858);
			_loading_page_spr.graphics.drawRect(0, 0, FullWidth, FullHeight);
			_loading_page_spr.graphics.endFill();
			_loading_page_spr.addChild(Text.newText("Loading...", 32, 0xffffff, 100, 100));
			_pageLayer.addChild(_loading_page_spr);
			
			//FPS TEMP CODE
			fpsCounter();
			
			loadProjectsDataFromServer();
		}
		private function loadProjectsDataFromServer():void
		{
			//load NowProject(Now item);
			Elever.Connection.post("Nowproject", null, function(data:String):void
			{
				if(data)
				{
					_project_load_cnt++;
					saveEnviroment("NowItem", JSON.parse(data).nowGatheringList);
					NowItemList = JSON.parse(data).nowGatheringList as Array;
					if(_project_load_cnt == PROJECT_LOAD_COMPLETED)
						loadAndSaveProjectDataToApp();
				}
			});
			//load PrevProject(prev item);
			Elever.Connection.post("Pastproject", null, function(data:String):void
			{
				if(data)
				{
					_project_load_cnt++;
					saveEnviroment("PrevItem", JSON.parse(data).pastGatheringList);
					PrevItemList = JSON.parse(data).pastGatheringList as Array;
					if(_project_load_cnt == PROJECT_LOAD_COMPLETED)
						loadAndSaveProjectDataToApp();
				}
			});
		}
		private var _load_project_data_cnt:int = 0;
		private function loadAndSaveProjectDataToApp():void
		{
			//nowItem
			if(_now_item_list != null)
			{
				for(var i:int = 0; i < _now_item_list.length; i++)
				{
					loadProjectImage(_now_item_list[i].gathering_sub_image);
				}
			}
			//prevItem
			if(_prev_item_list != null)
			{
				for(i = 0; i < _prev_item_list.length; i++)
				{
					loadProjectImage(_prev_item_list[i].gathering_sub_image);
				}
			}
		}
		private function loadProjectImage(url:String):void
		{
			if(url == "")
			{
				trace("Elever error : loadProjectImage - load Image with no url");
				doRenderIfOk();
				return;
			}
			
			var file:File = File.applicationStorageDirectory.resolvePath("Images/"+url);
			if(!file.exists)
			{
				var url_req:URLRequest = new URLRequest(url);
				var img:Loader = new Loader();
				img.load(url_req);
				Elever.Main.LoadingVisible = true;
				img.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void
				{
					Elever.Main.LoadingVisible = false;
					
					var bmp:Bitmap = e.target.content;
					
					saveProjectImage(bmp.bitmapData, url);
				});
				img.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void
				{
					Elever.Main.LoadingVisible = false;
					doRenderIfOk();
				});
			}
			else
			{
				doRenderIfOk();
			}
		}
		private function saveProjectImage(bitmapData:BitmapData, url:String):void
		{
			var jpgEncoder:JPEGAsyncEncoder = new JPEGAsyncEncoder(20);
			jpgEncoder.PixelsPerIteration = 128;
			jpgEncoder.addEventListener(JPEGAsyncCompleteEvent.JPEGASYNC_COMPLETE, function(e:JPEGAsyncCompleteEvent):void{ encodeDone(e,url) });
			jpgEncoder.encode(bitmapData);
		}
		private function encodeDone(e:JPEGAsyncCompleteEvent, url:String):void
		{
			var byteArray:ByteArray = e.ImageData;
			
			var file:File = File.applicationStorageDirectory.resolvePath("Images/"+url );
			var wr:File = new File( file.nativePath );
			var stream:FileStream = new FileStream();
			stream.open( wr , FileMode.WRITE);
			stream.writeBytes(byteArray, 0, byteArray.length);
			stream.close();
			
			doRenderIfOk();
		}
		private function doRenderIfOk():void
		{
			_load_project_data_cnt++;
			if(_load_project_data_cnt == (_now_item_list.length + _prev_item_list.length))
				Render();
		}
		private function drawTopMargin(color:uint, alpha:Number=1):void
		{
			var sprite:Sprite = new Sprite;
			sprite.graphics.beginFill(color, alpha);
			sprite.graphics.drawRect(0,0,PageWidth,Config.TOP_MARGIN);
			sprite.graphics.endFill();
			_topLayer.addChild(sprite);
		}
		private var _isRenderCalled:Boolean = false;
		private function Render():void
		{	
			if(_isRenderCalled) return;
			_isRenderCalled = true;
			
			if(IsIOS7)	drawTopMargin(0xdd5858);
			
			_header = new Header;
			_topLayer.addChild(_header);
			_footer = new Footer;
			_topLayer.addChild(_footer);
			
			
			_footer.addChildAt(new Footer.TabBar(BitmapControl.BOTTOM_BG), 0);
			
			(_footer.getChildByName("TabBar") as Footer.TabBar).addBar(BitmapControl.TAB1_UP, BitmapControl.TAB1_DOWN, "HomePage", {y:0});
			(_footer.getChildByName("TabBar") as Footer.TabBar).addBar(BitmapControl.TAB2_UP, BitmapControl.TAB2_DOWN, "TicketPage", {y:0});
			(_footer.getChildByName("TabBar") as Footer.TabBar).addBar(BitmapControl.TAB3_UP, BitmapControl.TAB3_DOWN, "SettingPage", {y:0});
			
			_header.addChildAt(new NavigationBar(BitmapControl.TOP_BG), 0);
			//_header.addChildAt(new Header.TabBar(BitmapControl.SLIDE_BG, BitmapControl.TABBAR_ANCHOR), 1);
						
			_header.onResize();
			
			changePage("HomePage");
			
			//FPS TEMP CODE
			fpsCounter();
		}
		private function onActivate(e:Event):void
		{
			//load my stuff
			if(IsIPhone) SilentSwitch.apply();	//iPhoneMute Control
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
		}
		private function onDeactivate(e:Event):void
		{
			//save my stuff
			_cur_page.dispose();
			NativeApplication.nativeApplication.exit();
		}
		private function onKeyDown(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.BACK)
			{
				if(NativeAlertDialog.isSupported)
				{
					NativeAlertDialog.show("종료하시겠습니까?", "알림", "예", "아니오", function AnswerFunc(e:NativeDialogEvent):void
					{
						if(!parseInt(e.index))	//Clicked Yes
						{
							// save my stuff
							NativeApplication.nativeApplication.exit();
						}
					}, true, NativeAlertDialog.DEFAULT_THEME);	//Native Diaglog Thema
				}
			}
		}
		private function stage_onResize(e:Event):void
		{
			onResize(true);		//if you set this false, images can be twisted
		}
		public function onResize(isScrollMode:Boolean=true):void
		{
			//set the scale of the stage
			scaleX = stage.stageWidth/Config.OriginalWidth;
			scaleY = (isScrollMode) ? scaleX : stage.stageHeight/Config.OriginalHeight;	
			
			calcPageSize();
		}
		public function calcPageSize():void
		{
			_pageHeight=FullHeight-Elever.Main.TopMargin-Elever.Main.HeaderHeight-Elever.Main.FooterHeight;
			
			//set page's default y pos
			if(_cur_page ) _cur_page.y = TopMargin+HeaderHeight;			
			if(_next_page) _next_page.y = TopMargin+HeaderHeight;
		}
		private var _changingPage:Boolean = false;
		public function get isChangingPage():Boolean { return _changingPage; }
		public function changePage(name:String, type:String=PageEffect.LEFT, params:Object=null, duration:Number=0.37, renewPage:Boolean=false):void
		{
			if(_changingPage)	return;
			
			if(!renewPage) if(_cur_page_name == name)	return;		//if it is same page, don't change.
			
			if(!params) params = new Object;
			var pageClass:Class = PageConnector.GetPageClass(name);
			
			var init_page:Boolean = false;
			
			if(_cur_page)	//not called once
			{
				_cur_page.dispose();
				if(Elever.Main.dictionary["NavigationBar"])	Elever.Main.dictionary["NavigationBar"].disable = false;
				if(Elever.Main.dictionary["SlideBar"])		Elever.Main.dictionary["SlideBar"].disable = false;
				if(Elever.Main.dictionary["TabBar"])		Elever.Main.dictionary["TabBar"].disable = false;
				_next_page = new pageClass(params);
				_pageLayer.addChild(_next_page);
				if(type == PageEffect.NONE)			//effect with none
				{
					PageTweenEnded();
					
					_header.changePage(_cur_page_name, params);		//send _cur_page_name(to send the name before)
					_cur_page_name = name;
					
					_footer.changePage(_cur_page_name, params);
					
					calcPageSize();		//calculate page size after adding page
					
					if(init_page)
						_cur_page.init();
					
					return;
				}
				if(type == PageEffect.LEFT)			// <- effect
				{
					_next_page.x = PageWidth;
					TweenLite.to(_next_page, duration, {x:0});
					TweenLite.to(_cur_page , duration, {x:-PageWidth, onComplete:PageTweenEnded});
				}
				else if(type == PageEffect.RIGHT)	// -> effect
				{
					_next_page.x = -PageWidth;
					TweenLite.to(_next_page, duration, {x:0});
					TweenLite.to(_cur_page , duration, {x:PageWidth, onComplete:PageTweenEnded});
				}
				else if(type == PageEffect.FADE)	// fade-in effect.
				{
					_next_page.alpha = 0;
					TweenLite.to(_cur_page, duration, {alpha:0});
					TweenLite.to(_next_page, duration, {alpha:1, onComplete:PageTweenEnded});
				}
				_changingPage = true;
				
			}
			else			//when called for the first time
			{
				_cur_page = new pageClass;
				_cur_page.alpha = 0;
				TweenLite.to(_cur_page, duration, {alpha:1, onComplete:function():void
				{
					if(_loading_page_spr) _pageLayer.removeChild(_loading_page_spr);
				}});
				_pageLayer.addChild(_cur_page);
				init_page = true;
			}
			
			_header.changePage(_cur_page_name, params);		//send _cur_page_name(to send the name before)
			
			_cur_page_name = name;
			
			_footer.changePage(_cur_page_name, params);
			
			calcPageSize();		//calculate page size after adding page
			
			if(init_page)
				_cur_page.init();
		}
		private function PageTweenEnded():void
		{
			//intitialize after page tween
			_pageLayer.removeChild(_cur_page);
			_cur_page = _next_page;
			_changingPage = false;
			_cur_page.init();
		}
	}
}