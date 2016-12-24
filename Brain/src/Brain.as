package
{
	import com.sticksports.nativeExtensions.SilentSwitch;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.media.AudioPlaybackMode;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	import flash.utils.getTimer;
	
	import mx.effects.easing.Back;
	
	import Page.BasePage;
	
	import Popup.BasePopup;
	
	import kr.co.tiein.brain.HTTPUtil;
	import kr.pe.hs.push.ApplePush;
	import kr.pe.hs.tween.Tween;
	
	public class Brain extends Sprite
	{
		[Embed(source="assets/fonts/NanumGothicBold.ttf", mimeType = "application/x-font-truetype", fontName="Main", embedAsCFF=false)]
		private static const fontMain:Class;
		public static function get FontMain():Class{ return fontMain; }

		public static const OriginalWidth:Number=540; //타겟 해상도의 원본 가로
		public static const OriginalHeight:Number=960; //타겟 해상도의 원본 세로
		
		private static const _topMenuHeight:int = 80;
		public static function get TopMenuHeight():int{ return _topMenuHeight; }
		
		
		//메인 객체
		private static var _brainMain:Brain;
		public static function get Main():Brain{ return _brainMain; }
		
		//HTTP 서버 연동08SeoulNamsanM08SeoulNamsanMf
		private static var _connection:HTTPUtil;
		public static function get Connection():HTTPUtil{ return _connection; }
		
		//현재 사용자 정보
		private static var _account:Object;
		public static function get Account():Object{ return _account; }
		public static function set Account(value:Object):void{ _account=value; }
		private static var _userInfo:Object;
		public static function get UserInfo():Object{ return _userInfo; }
		public static function set UserInfo(value:Object):void{ _userInfo=value; }
		
		private static var _pushService:ApplePush;
		public static function get PushService():ApplePush{ return _pushService; }
		
//		private static var _isLogin:Boolean;
//		public static function get Login():Boolean{ return _isLogin; }
//		public static function set Login(value:Boolean):void{ _isLogin=value; }
		
//		private static var _testBaby:Boolean;
//		public static function get HaveTestBaby():Boolean{ return _testBaby; }
//		public static function set HaveTestBaby(value:Boolean):void{ _testBaby = value; }
		
		private static var _gameIndex:Number;
		public static function get GameIndex():Number { return _gameIndex; }
		public static function set GameIndex(value:Number):void { _gameIndex = value; }
		
		private static var _testGame:Boolean;
		public static function get isTestGame():Boolean { return _testGame; }
		public static function set isTestGame(value:Boolean):void { _testGame = value; }
		
		public static function loadEnviroment():void
		{
			//return;
			_account=null;
			_userInfo=null;
			
			var appStorage:File=File.applicationStorageDirectory;
			var dbFile:File = appStorage.resolvePath("config.db");
			if(dbFile.exists){
				var fs:FileStream=new FileStream;
				fs.open(dbFile,FileMode.READ);
				var result:Object=JSON.parse(fs.readUTF());
				fs.close();
				
				_account=result.account;
				_userInfo=result.userInfo;
			}
			
//			Page.Calendar.Index.loadEnviroment();
//			Page.Album.Index.loadEnviroment();
//			Page.Chat.Index.loadEnviroment();
		}
		
		public static function saveEnviroment():void{
			var dbData:Object={
				account:_account,
				userInfo:_userInfo
			};
			
			var appStorage:File=File.applicationStorageDirectory;
			var dbFile:File = appStorage.resolvePath("config.db");
			var fs:FileStream=new FileStream;
			fs.open(dbFile,FileMode.WRITE);
			fs.writeUTF(JSON.stringify(dbData));
			fs.close();
			
//			Page.Calendar.Index.saveEnviroment();
//			Page.Album.Index.saveEnviroment();
//			Page.Chat.Index.saveEnviroment();
		}
		
		//로그아웃
		public static function Logout():void
		{
			var appStorage:File = File.applicationStorageDirectory;
			var list:Array=appStorage.getDirectoryListing();
			for(var i:int=0;i<list.length;i++)
			{
				var file:File=list[i] as File;
				if(file!=null)
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
			loadEnviroment();
			
			Account = null;
			
			Main.setPage("brainMainPage",null,BrainPageEffect.RIGHT,BrainPageEffect.RIGHT);
		}
		
		//iOS7체크해서 상단에 40px마진을 줘야함...
		private var _isiOS7:Boolean;
		public function get TopMargin():Number{ return (_isiOS7)?(40/scaleY):0; }
		
		//원본 크기
		public function get FullWidth():Number{ return stage.stageWidth/scaleX; }
		public function get FullHeight():Number{ return stage.stageHeight/scaleY; }
		
		//로딩
//		[Embed(source = "assets/loading/loading.swf")]
//		private var LOADING_ANI:Class;
		private var _loadingAni:MovieClip;
		private var _loadingBG:Sprite;
		private var _loading:Sprite;
		public function set LoadingVisible(value:Boolean):void{ 
			if(value && !_loading.visible) addChild(_loading); 
			else if(!value && _loading.visible) removeChild(_loading);
			
			_loading.visible=value;
		}
		public function get LoadingVisible():Boolean{ return _loading.visible; }
		
		//상단 메뉴
		private static var _topMenu:TopMenuSprite;
		private static var _topMenuTween:Tween;
		private var _topMenuVisible:Boolean;
		public function get TopMenu():TopMenuSprite{ return _topMenu; }
		public function set TopMenuVisible(value:Boolean):void{
			_topMenu.cacheAsBitmap=true;
			if(value){
				if(!_topMenuVisible) _topMenu.y=-_topMenu.height;
				_topMenu.visible=true;
				_topMenuTween=new Tween(_topMenu.y,0,1,300,function(value:Number,isFinish:Boolean):void{
					_topMenu.y=value;
					if(isFinish){
						_topMenu.cacheAsBitmap=false;
						//calcPageSize();
					}
				});
			}
			else{
				if(_topMenuVisible) _topMenu.y=0;
				_topMenuTween=new Tween(_topMenu.y,-_topMenu.height,1,300,function(value:Number,isFinish:Boolean):void{
					_topMenu.y=value;
					if(isFinish){
						_topMenu.visible=false;
						//calcPageSize();
						if(isFinish){
							_topMenu.cacheAsBitmap=false;
							_topMenu.clearAddedChild();
						}
					}
				});
			}
			_topMenuVisible=value;
			calcPageSize();
		}
		public function get TopMenuVisible():Boolean{ return _topMenuVisible; }
		
		
		//배경
		[Embed(source = "assets/bg.png")]
		private var MAIN_BG:Class;		
		private static var _bg:Bitmap;
		
		//화면전환 트루뽈쓰.
		private static var _isChangePage:Boolean;
		public function get isPageChanged():Boolean { return _isChangePage; }
		
		
		//페이지
		private var _prevPageBitmapData:BitmapData;
		private var _prevPageBitmap:Bitmap;
		private var _prevPageBitmapTween:Tween;
		private var _page:BasePage;
		public function get Page():BasePage{ return _page; }
		private var _invalidatePageBitmap:Boolean;
		private var _invalidatePageBitmapDelay:int;
		private var _pageBitmapData:BitmapData;
		private var _pageBitmap:Bitmap;
		private var _pageTween:Tween;
		private var _pageY:Number;
		private var _pageHeight:Number;
		public function get PageWidth():Number{ return FullWidth; }
		public function get PageHeight():Number{ return _pageHeight; }
		private var _pageName:String;
		public function get PageName():String{ return _pageName; }
		private var _pageParams:Object;
		public function get PageParameters():Object{ return _pageParams; }
		
		//팝업
		private var _prevPopupBitmapData:BitmapData;
		private var _prevPopupBitmap:Bitmap;
		private var _prevPopupBitmapTween:Tween;
		private var _popupBitmapData:BitmapData;
		private var _popupBitmap:Bitmap;
		
		private var _popup:Sprite;
		public function get Popup():Sprite{ return _popup; }
		private var _popupBG:Sprite;
		private var _popupAlphaTween:Tween;
		private var _popupTween:Tween;
		private var _popupList:Vector.<BasePopup>;
		public function get PopupList():Vector.<BasePopup>{ return _popupList; }
		
		//생성자
		public function Brain()
		{
			super();
			
			SilentSwitch.apply();
			
			//iOS7일 경우 상단 바 버그가 있으므로 검사해서 강제로 40픽셀정도 그려줘야한다.
			_isiOS7=false;
			var osValue:String=Capabilities.os;
			if(osValue.substr(0,9)=="iPhone OS"){
				//iPhone인지?
				var osVersion:String=osValue.substr(10,osValue.indexOf(" ",10)-10);
				var deviceModel:String=osValue.substr(10+osVersion.length+1,osValue.lastIndexOf(","));
				if(/*deviceModel.substr(0,6)=="iPhone" && */ osVersion.substr(0,2)=="7."){
					_isiOS7=true;
				}
			}

			
			
			_bg=new MAIN_BG;
			addChild(_bg);
			
			_brainMain=this;
			if(!_connection) _connection=new HTTPUtil(Config.SERVER_PATH);
			loadEnviroment();
			
			stage.frameRate=60;
			stage.color=0x000000;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, onActivate, false, 0, true);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onDeactivate, false, 0, true);
			/*if(Capabilities.cpuArchitecture == "ARM") {
				NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, onActivate, false, 0, true);
				NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onDeactivate, false, 0, true);
			}*/
			
			_topMenu=new TopMenuSprite;
			_topMenu.y=-_topMenu.height;
			_topMenu.visible=false;
			addChild(_topMenu);
			_topMenuVisible=false;
			
			
			
			var _urlRequest:URLRequest = new URLRequest("loading.swf");
			_loader = new Loader();
			var _lc:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain, null);
			_loader.load(_urlRequest, _lc);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteLoad);
			
			_popup=new Sprite;
			_popup.visible=false;
			addChild(_popup);
			_popupBG=new Sprite;
			_popup.addChild(_popupBG);
			_popupBG.addEventListener(MouseEvent.CLICK,Popup_onClose);
			_popupList=new Vector.<BasePopup>;
			
			setPage("brainUserLoginPage",null,BrainPageEffect.NONE,BrainPageEffect.NONE);
			
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
			
			_pushService=new ApplePush;
			//PushNotification.getInstance().sendLocalNotification("Start",0,"Elever");
			
			_testGame = false;
		}
		private var _loader:Loader;
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
		
		//화면 좌표 바꾸는 코드
		public static function setXPos(x:int):void
		{
			_bg.x = x;
			_topMenu.x = x;
		}
				
		//페이지 이동
		public function setPage(name:String,params:Object=null,fadein:String=BrainPageEffect.LEFT,fadeout:String=BrainPageEffect.LEFT):void
		{
			if(_isChangePage)
				_isChangePage = false;
			if(_pageBitmap){
				_pageBitmap.parent.removeChild(_pageBitmap);
				_pageBitmap=null;
			}
			if(_pageBitmapData){
				_pageBitmapData.dispose();
				_pageBitmapData=null;
			}
			if(_pageTween){
				_pageTween.endTween();
				_pageTween=null;
			}
			if(_prevPageBitmap){
				_prevPageBitmap.parent.removeChild(_prevPageBitmap);
				_prevPageBitmap=null;
			}
			if(_prevPageBitmapData){
				_prevPageBitmapData.dispose();
				_prevPageBitmapData=null;
			}
			if(_prevPageBitmapTween){
				_prevPageBitmapTween.endTween();
				_prevPageBitmapTween=null;
			}
			
			if(_pageName==name && _pageParams==params){
				if(!_page.visible){
					_page.cacheAsBitmap=false;
					_page.x=0;
					_page.visible=true;
				}
				
				return;
			}
			
			y=0;
			
			if(_page)
			{			
				if(fadeout!=BrainPageEffect.NONE)
				{
					_prevPageBitmapData=new BitmapData(PageWidth,PageHeight,true,0x00FFFFFF);
					_prevPageBitmapData.draw(_page,null,null,null,new Rectangle(0,0,PageWidth,PageHeight));
					_prevPageBitmap=new Bitmap(_prevPageBitmapData);
					_prevPageBitmap.cacheAsBitmap=true;
					addChildAt(_prevPageBitmap,1);
					var fadeoutCallbackX:Function=function(value:Number,isFinish:Boolean):void
					{
						
						if(!_prevPageBitmap) return;
						_prevPageBitmap.x=value;
						if(isFinish)
						{
							_prevPageBitmap.parent.removeChild(_prevPageBitmap);
							_prevPageBitmap = null;
							
							_prevPageBitmapData.dispose();
							_prevPageBitmapData=null;
							
							_prevPageBitmapTween=null;
							_isChangePage = true;
						}
					};
					
					_prevPageBitmap.y = _page.y;
					if(fadeout==BrainPageEffect.RIGHT){
						_prevPageBitmapTween=new Tween(0,PageWidth,1,500,fadeoutCallbackX);
					}
					else{
						_prevPageBitmapTween=new Tween(0,-PageWidth,1,500,fadeoutCallbackX);
					}
				}
				
				removeChild(_page);
				_page.dispose();
				_page=null;
			}
			
			var pageClass:Class= PageConnector.GetPageClass(name);
			
			if(pageClass)
			{
				_pageName=name;
				_pageParams=params;
				
				_page=new pageClass;
				_page.y=_pageY;
				
				addChildAt(_page,1);
				_page.onResize();
				
				if(fadein != BrainPageEffect.NONE)
				{
					_page.cacheAsBitmap=true;
					
					_invalidatePageBitmap=false;
					_pageBitmapData=new BitmapData(PageWidth,PageHeight,true,0x00FFFFFF);
					_pageBitmapData.draw(_page,null,null,null,new Rectangle(0,0,PageWidth,PageHeight));
					_pageBitmap=new Bitmap(_pageBitmapData);
					addChildAt(_pageBitmap,2);
					
					_page.visible=false;
					
					var fadeinCallbackX:Function=function(value:Number,isFinish:Boolean):void
					{
						if(_invalidatePageBitmap){
							if(getTimer()-_invalidatePageBitmapDelay>=0){
								invalidateAnimateBitmap(true);	
							}
						}
						
						//_page.x=value;
						if(!_pageBitmap) return;
						_pageBitmap.x=value;
						
						if(isFinish){
							if(_pageBitmap){
								_pageBitmap.parent.removeChild(_pageBitmap);
								_pageBitmap=null;
							}
							if(_pageBitmapData){
								_pageBitmapData.dispose();
								_pageBitmapData=null;
							}
							
							_page.cacheAsBitmap=false;
							_page.x=value;
							_page.visible=true;
							_pageTween=null;
							_isChangePage = true;
						}
					};
					
					if(fadein == BrainPageEffect.RIGHT)
					{
						_pageBitmap.x=-PageWidth;
						//_page.x=-PageWidth;
						_pageTween=new Tween(-PageWidth,0,1,500,fadeinCallbackX);
					}
					else
					{
						_pageBitmap.x=PageWidth;
						//_page.x=PageWidth;
						_pageTween=new Tween(PageWidth,0,1,500,fadeinCallbackX);
					}
					//_pageBitmap.x=_page.x;
					_pageBitmap.y=_page.y;
				}
			}
		}
		
		public function invalidateAnimateBitmap(invalidateNow:Boolean=false):void{
			if(_pageBitmapData){
				if(invalidateNow){
					_invalidatePageBitmap=false;
					
					_pageBitmapData.fillRect(new Rectangle(0,0,_pageBitmapData.width,_pageBitmapData.height),0x00000000);
					_pageBitmapData.draw(_page,null,null,null,new Rectangle(0,0,PageWidth,PageHeight));
					//_pageBitmapData.draw(_page);	
				}
				else{
					if(!_invalidatePageBitmap){
						_invalidatePageBitmap=true;
						_invalidatePageBitmapDelay=getTimer()+100;
					}
				}
			}
		}
		
		//팝업
		public function showPopup(popup:BasePopup):void{
			y=0;
			
			_popupList[_popupList.length]=popup;
			
			nextPopup();
		}
		
		public function closePopup(cancel:Boolean=false):void{
			var popup:BasePopup=_popupList[0];
			
			_popupList[0]=null;
			_popupList.splice(0,1);
			
			if(_popupList.length==0){
				if(_popupBitmap){
					_popupBitmap.parent.removeChild(_popupBitmap);
					_popupBitmap=null;
				}
				if(_popupBitmapData){
					_popupBitmapData.dispose();
					_popupBitmapData=null;
				}
				if(_prevPopupBitmap){
					_prevPopupBitmap.parent.removeChild(_prevPopupBitmap);
					_prevPopupBitmap=null;
				}
				if(_prevPopupBitmapData){
					_prevPopupBitmapData.dispose();
					_prevPopupBitmapData=null;
				}
				if(_prevPopupBitmapTween){
					_prevPopupBitmapTween.endTween();
					_prevPopupBitmapTween=null;
				}
			
				if(popup.width>0 && popup.height>0){
					_prevPopupBitmapData=new BitmapData(popup.width,popup.height,true,0x00FFFFFF);
					_prevPopupBitmapData.draw(popup);
					_prevPopupBitmap=new Bitmap(_prevPopupBitmapData);
					_prevPopupBitmap.cacheAsBitmap=true;
					_popup.addChild(_prevPopupBitmap);
					_prevPopupBitmap.x=popup.x;
					_prevPopupBitmap.y=popup.y;
					
					var fadeoutCallbackX:Function=function(value:Number,isFinish:Boolean):void{
						if(!_prevPopupBitmap) return;
						
						_prevPopupBitmap.x=value;
						
						if(isFinish){
							if(_prevPopupBitmap){
								_prevPopupBitmap.parent.removeChild(_prevPopupBitmap);
								_prevPopupBitmap=null;
							}
							if(_prevPopupBitmapData){
								_prevPopupBitmapData.dispose();
								_prevPopupBitmapData=null;
							}
							if(_prevPopupBitmapTween){
								//_prevPopupBitmapTween.endTween();
								_prevPopupBitmapTween=null;
							}
						}
					};
					
					if(cancel==false){
						_prevPopupBitmapTween=new Tween(_prevPopupBitmap.x,-PageWidth,1,500,fadeoutCallbackX);
					}
					else{
						_prevPopupBitmapTween=new Tween(_prevPopupBitmap.x,PageWidth,1,500,fadeoutCallbackX);
					}
				}
			}
						
			_popup.removeChild(popup);
			popup.dispose();
			popup=null;
				
			nextPopup();
		}
		
		private function Popup_onClose(e:MouseEvent):void{
			closePopup(true);
		}
		
		private function nextPopup():void{
			if(_popupList.length>0){				
				if(!_popup.visible){
					_popupBG.alpha=0;
					
					if(_popupAlphaTween) _popupAlphaTween.endTween();
					_popupAlphaTween=new Tween(0,1,1,200,function(value:Number,isFinish:Boolean):void{
						_popupBG.alpha=value;
						if(isFinish){
							//_popupAlphaTween.endTween();
							_popupAlphaTween=null;
						}
					});
				}
				
				
				if(_popupTween) _popupTween.endTween();
				_popup.addChild(_popupList[0]);
				_popup.visible=true;
				resizePopup();
				
				if(_popupBitmap){
					_popupBitmap.parent.removeChild(_popupBitmap);
					_popupBitmap=null;
				}
				if(_popupBitmapData){
					_popupBitmapData.dispose();
					_popupBitmapData=null;
				}
				
				_popupBitmapData=new BitmapData(_popupList[0].width,_popupList[0].height,true,0x00FFFFFF);
				_popupBitmapData.draw(_popupList[0]);
				_popupBitmap=new Bitmap(_popupBitmapData);
				_popupBitmap.cacheAsBitmap=true;
				addChild(_popupBitmap);
				
				_popupList[0].visible=false;
				_popupBitmap.x=PageWidth;
				if(PageHeight/2-_popupBitmap.height/2 < 0)
					_popupBitmap.y = TopMargin;
				else
					_popupBitmap.y=PageHeight/2-_popupBitmap.height/2+TopMargin;
				_popupTween=new Tween(_popupBitmap.x,0,1,200,function(value:Number,isFinish:Boolean):void{
					if(!_popupBitmap) return;
					_popupBitmap.x=value;
					
					if(isFinish){
						if(_popupBitmap){
							_popupBitmap.parent.removeChild(_popupBitmap);
							_popupBitmap=null;
						}
						if(_popupBitmapData){
							_popupBitmapData.dispose();
							_popupBitmapData=null;
						}
						
						_popupList[0].x=0;
						if(PageHeight/2-_popupList[0].height/2 < 0)
							_popupList[0].y = TopMargin;
						else
							_popupList[0].y=PageHeight/2-_popupList[0].height/2+TopMargin;
						_popupList[0].visible=true;
						_popupList[0].onResize();
						//_popupTween.endTween();
						_popupTween=null;
					}
				});
			}
			else{
				if(_popupAlphaTween) _popupAlphaTween.endTween();
				_popupAlphaTween=new Tween(1,0,1,200,function(value:Number,isFinish:Boolean):void{
					_popupBG.alpha=value;
					if(isFinish){
						_popup.visible=false;
						//_popupAlphaTween.endTween();
						_popupAlphaTween=null;
					}
				});
			}
		}
		private function resizePopup():void{
			if(_popup.visible){
				_popupBG.graphics.clear();
				_popupBG.graphics.beginFill(0x000000,0.6);
				_popupBG.graphics.drawRect(0,0,FullWidth,FullHeight);
				_popupBG.graphics.endFill();
				
				if(_popupList.length>0){
					if(_popupList[0].parent){
						_popupList[0].x=FullWidth/2-_popupList[0].width/2;
						_popupList[0].y=FullHeight/2-_popupList[0].height/2;
						_popupList[0].onResize();
					}
				}
			}
		}
		
		//페이지 크기 설정
		private function calcPageSize():void
		{
			if(_topMenu && _topMenuVisible) _pageY=_topMenu.height-7;
			else _pageY=0;
			
			//if(_bottomMenu && _bottomMenuVisible) _pageHeight=(FullHeight-_bottomMenu.height+2)-_pageY;
			_pageHeight=FullHeight-_pageY;
			
			if(_page)
			{
				_page.y=_pageY;
				_page.onResize();
			}
			 
		}
		
		//화면크기 재설정
		public function onResize():void
		{
			scaleX=stage.stageWidth/OriginalWidth;
			scaleY=scaleX;
			
			_bg.width=FullWidth;
			_bg.height=FullHeight;
			
			resizePopup();
			
			if(_topMenu) _topMenu.onResize();
			calcPageSize();
		}
		
		private function onAdded(e:Event):void{
			onResize();
			stage.addEventListener(Event.RESIZE, Stage_onResize);
		}
		private function onRemoved(e:Event):void{
			stage.removeEventListener(Event.RESIZE, Stage_onResize);
		}
		
		protected function Stage_onResize(e:Event):void{
			onResize();
		}
		
		private function onActivate(event:Event):void
		{
			stage.frameRate=30;
			//NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			
		}
		
		private function onDeactivate(event:Event):void
		{
			saveEnviroment();
			stage.frameRate=0.01;
			//NativeApplication.nativeApplication.exit();
		}
	}
}