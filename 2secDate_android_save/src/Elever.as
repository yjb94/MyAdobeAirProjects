package
{
	import com.greensock.TweenLite;
	import com.sticksports.nativeExtensions.SilentSwitch;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.RemoteNotificationEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;
	
	import Displays.BitmapControl;
	
	import Header.Header;
	import Header.NavigationBar;
	
	import Page.BasePage;
	import Page.PageConnector;
	import Page.PageEffect;
	import Page.Home.ItemInfo;
	
	import Scroll.Scroll;
	
	import Utils.HTTPUtil;
	import Utils.PushAPI;
	
	import pl.mateuszmackowiak.nativeANE.dialogs.NativeAlertDialog;
	import pl.mateuszmackowiak.nativeANE.events.NativeDialogEvent;
	
	public class Elever extends Sprite
	{		
		public function get OsType():String { return Capabilities.os; }
		public function get IsIPhone():Boolean { return (OsType.substr(0,9)=="iPhone OS") ? true : false; }
		public function get IsIOS7():Boolean { return ((IsIPhone) && (OsType.substr(10,OsType.indexOf(" ",10)-10).substr(0,2)=="7.")) ? true : false; }
		public function get IsIOS8():Boolean { return ((IsIPhone) && (OsType.substr(10,OsType.indexOf(" ",10)-10).substr(0,2)=="8.")) ? true : false; }
		
		public function get TopMargin():Number { return (IsIOS7 || IsIOS8) ? Config.TOP_MARGIN : 0; }
		public function get HeaderHeight():Number 
		{ 
			var height:Number = (_header!=null) ? _header.height-Config.HEADER_SHADOW : 0;
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
		
		private static var _pushService:PushAPI;
		public static function get PushService():PushAPI{ return _pushService; }
		
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
		
		public static function removeAllEnviroment():void
		{
			var appStorage:File = File.applicationStorageDirectory;
			var list:Array=appStorage.getDirectoryListing();
			for(var i:int=0;i<list.length;i++)
			{
				var file:File=list[i] as File;
				
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
		public static function removeEnviroment(url:String):void
		{
			var appStorage:File = File.applicationStorageDirectory;
			var dbFile:File = appStorage.resolvePath(url);
			if(dbFile.exists)
			{
				if(!dbFile.isDirectory)
				{
					dbFile.deleteFile();
				}
				else
				{
					dbFile.deleteDirectoryAsync(true);
				}
			}
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
			
			_main = this;	//set Main Object
			
			
			addEventListener(Event.ADDED_TO_STAGE, initialize);
			
			
			var _urlRequest:URLRequest = new URLRequest("Displays/assets/loading/loading.swf");
			_loader = new Loader();
			var _lc:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain, null);
			_loader.load(_urlRequest, _lc);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteLoad);
						
			if(!_connection) _connection=new HTTPUtil(Config.SERVER_PATH);
		}
		
		private function onCompleteLoad(e:Event):void
		{
			_loading=new Sprite;
			_loading.visible=false;
			
			_loadingBG=new Sprite;
			_loadingBG.graphics.beginFill(0x000000,0.6);
			_loadingBG.graphics.drawRect(0,0,FullWidth,FullHeight);
			_loadingBG.graphics.endFill();
			_loadingBG.cacheAsBitmap=true;
			_loading.addChild(_loadingBG);
			
			_loadingAni = MovieClip(_loader.contentLoaderInfo.content); //addChild 하려면 DisplayObject 로 캐스팅
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onCompleteLoad);
			_loading.addChild(_loadingAni);
			
			
			_loadingBG.x=0;
			_loadingBG.y=0;
			_loadingAni.x=_loadingBG.width/2-_loadingAni.width/2;
			_loadingAni.y=_loadingBG.height/2-_loadingAni.height/2;
		}
		public function initialize(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initialize);
			
			var first_time_run:Object = loadEnviroment("First_run", first_time_run);
			_pushService = new PushAPI;
			
			if(first_time_run == null)
			{
				if(Elever.PushService != null)
				{
					if(Elever.PushService.TokenID == null)
					{
						var osValue:String = Capabilities.os;
						
						if(osValue.substr(0,9)=="iPhone OS")
						{
							Elever.PushService.addEventListener(RemoteNotificationEvent.TOKEN, onTokenId);
							Elever.PushService.register();
						}
						else
							Elever.PushService.register(updateGCMID);
					}
					else
					{
						updateGCMID();
					}
				}
				saveEnviroment("First_run", true);
			}
			else
				Elever.PushService.register();
			
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
			
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, onActivate, false, 0, true);		//Applictaion came back from background
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onDeactivate, false, 0, true);	//Application sent to background
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);//Applictaion button Clicked

			
			stage.addEventListener(Event.RESIZE, stage_onResize);
			
			
			
			setTimeout(Render, 1);
		}
		private function drawTopMargin(color:uint, alpha:Number=1):void
		{
			var bmp:Bitmap = BitmapControl.newBitmap(BitmapControl.TOP_MARGIN);
			bmp.height = Config.TOP_MARGIN;
//			var sprite:Sprite = new Sprite;
//			sprite.graphics.beginFill(color, alpha);
//			sprite.graphics.drawRect(0,0,PageWidth,Config.TOP_MARGIN);
//			sprite.graphics.endFill();
			_topLayer.addChild(bmp);
		}
		private var _isRenderCalled:Boolean = false;
		private function Render():void
		{	
			if(_isRenderCalled) return;
			_isRenderCalled = true;
			
			if(IsIOS7 || IsIOS8)	drawTopMargin(0xfafafa, 0.88);
			
			_header = new Header;
			_topLayer.addChild(_header);
			
			_header.addChildAt(new NavigationBar(BitmapControl.TOP_BG), 0);
						
			_header.onResize();
			
			changePage(Config.firstPage);
		}
		private function onActivate(e:Event):void
		{
			//load my stuff
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
		}
		private function onDeactivate(e:Event):void
		{
			//save my stuff
			//_cur_page.dispose();		//주석을 풀면 앱 껏다가 킬 때 버그 생기던데 이 코드 왜 있었는지 모르겠음.
			NativeApplication.nativeApplication.exit();
		}
		private function onKeyDown(e:KeyboardEvent):void
		{
			if(e.keyCode == Keyboard.BACK)
			{
				if(_cur_page_name == "ItemInfoPage" && (((_cur_page as ItemInfo).isZoomed) || ((_cur_page as ItemInfo).isPopupOpend)))
				{
					if((_cur_page as ItemInfo).isZoomed)
						(_cur_page as ItemInfo).zoomOut();
					else if((_cur_page as ItemInfo).isPopupOpend)
						(_cur_page as ItemInfo).removePopup(null);
					e.preventDefault();
					e.stopImmediatePropagation();
				}
				else if(_topLayer.getChildByName("popup") != null)
				{
					TweenLite.to(_topLayer.getChildByName("popup"), 0.1, { alpha:0, onComplete:function():void
					{
						topLayer.removeChild(_topLayer.getChildByName("popup"));
					}});
					e.preventDefault();
					e.stopImmediatePropagation();
				}
				else if((_header.getChildByName("NavigationBar") as NavigationBar).hasPrev)
				{
					(_header.getChildByName("NavigationBar") as NavigationBar).onPrevClick();
					e.preventDefault();
					e.stopImmediatePropagation();
				}
				else
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
		}
		private function stage_onResize(e:Event):void
		{
			onResize(true);		//if you set this false, images can be twisted
		}
		public function onResize(isScrollMode:Boolean=true):void
		{
			//set the scale of the stage
			scaleX = stage.stageWidth/Config.InsideWidth;
			scaleY = (isScrollMode) ? scaleX : stage.stageHeight/Config.InsideHeight;	
			
			calcPageSize();
		}
		public function calcPageSize():void
		{
			_pageHeight=FullHeight-Elever.Main.TopMargin-Elever.Main.HeaderHeight;
			
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
			
			//LoadingVisible = true;
			
			if(!params) params = new Object;
			var pageClass:Class = PageConnector.GetPageClass(name);
			
			var init_page:Boolean = false;
			
			//do tween for loading
			var do_tween:Boolean = false;
			
			if(_cur_page)	//not called once
			{
				_cur_page.dispose();
				_next_page = new pageClass(params);
				_pageLayer.addChild(_next_page);
				if(type == PageEffect.NONE)			//effect with none
				{
					PageTweenEnded();
					
					if(!renewPage) _header.changePage(_cur_page_name, params);		//send _cur_page_name(to send the name before)
					_cur_page_name = name;
					
					calcPageSize();		//calculate page size after adding page
					
					if(init_page)
						_cur_page.init();
					
					return;
				}
				if(type == PageEffect.LEFT || type == PageEffect.RIGHT || type == PageEffect.FADE)
				{
					do_tween = true;
				}
				
			}
			else			//when called for the first time
			{
				_cur_page = new pageClass;
				_pageLayer.addChild(_cur_page);
				init_page = true;
			}
			
			if(!renewPage) _header.changePage(_cur_page_name, params);		//send _cur_page_name(to send the name before)
			
			if(do_tween)
			{
				//LoadingVisible = false;
				if(type == PageEffect.LEFT)			// <- effect
				{
					_next_page.x = PageWidth;
					do_tween = true;
					TweenLite.to(_next_page, duration, {x:0});
					TweenLite.to(_cur_page , duration, {x:-PageWidth, onComplete:PageTweenEnded});
				}
				else if(type == PageEffect.RIGHT)	// -> effect
				{
					_next_page.x = -PageWidth;
					do_tween = true;
					TweenLite.to(_next_page, duration, {x:0});
					TweenLite.to(_cur_page , duration, {x:PageWidth, onComplete:PageTweenEnded});
				}
				else if(type == PageEffect.FADE)	// fade-in effect.
				{
					_next_page.alpha = 0;
					do_tween = true;
					TweenLite.to(_cur_page, duration, {alpha:0});
					TweenLite.to(_next_page, duration, {alpha:1, onComplete:PageTweenEnded});
				}
				_changingPage = true;
			}
			
			_cur_page_name = name;
						
			calcPageSize();		//calculate page size after adding page
			
			if(init_page)
				_cur_page.init();
		}
		private function PageTweenEnded():void
		{
			//intitialize after page tween
			//LoadingVisible = false;
			_pageLayer.removeChild(_cur_page);
			_cur_page = _next_page;
			_changingPage = false;
			_cur_page.init();
		}
		
		private function updateGCMID():void
		{
			Elever.Main.LoadingVisible = false;
			
			var osValue:String = Capabilities.os;
			var params:URLVariables = new URLVariables;
			if(osValue.substr(0,9) == "iPhone OS")
			{
				params.udid = "A" + Elever.PushService.TokenID;
				
				Elever.Connection.post("get_udid", params, onSetUDID);
				
				Elever.PushService.removeEventListener(RemoteNotificationEvent.TOKEN, onTokenId);		
			}
			else
			{
				params.udid = "G" + Elever.PushService.TokenID;
				
				Elever.Connection.post("get_udid", params, onSetUDID);
			}
		}
		private function onSetUDID(data:String):void
		{
			if(data)
			{
				var result:Object = JSON.parse(data);
				
				if(result)
				{
					_pushService.UDID = result.udid_seq;
					saveEnviroment("UDID", _pushService.UDID);
				}
			}
		}
		private function onTokenId(e:RemoteNotificationEvent):void
		{	
			updateGCMID();
		}
	}
}