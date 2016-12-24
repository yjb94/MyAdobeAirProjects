package
{
	import com.greensock.TweenLite;
	import com.sticksports.nativeExtensions.SilentSwitch;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import Displays.BitmapControl;
	import Displays.Text;
	
	import Footer.Footer;
	import Footer.TabBar;
	
	import Header.Header;
	import Header.NavigationBar;
	import Header.SlideBar;
	
	import Page.BasePage;
	import Page.PageConnector;
	import Page.PageEffect;
	
	import Scroll.Scroll;
	
	import pl.mateuszmackowiak.nativeANE.dialogs.NativeAlertDialog;
	import pl.mateuszmackowiak.nativeANE.events.NativeDialogEvent;
	
	public class Calender extends Sprite
	{
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
			return height;
		}
		
		private static var _main:Calender;
		public static function get Main():Calender{ return _main; }
		
		private var _pageHeight:Number;
		public function get PageWidth():Number{ return FullWidth; }
		public function get PageHeight():Number{ return _pageHeight; }
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
		private var _pageLayer:Sprite;
		
		private var _header:Header;
		public function get header():Header { return _header; }
		private var _clear_navigation:Boolean = false;
		public function set clearNavigation(value:Boolean):void { _clear_navigation = value; }
		
		private var _footer:Footer;
		public function get footer():Footer { return _footer; }
		
		private var _dictionary:Dictionary = new Dictionary;		//A Dictionary to save datas to use all over the field.(HAVE TO REMOVE AFTER USAGE)
		public function get dictionary():Dictionary { return _dictionary; }
		public function deleteItemInDict(key:Object):void { if(_dictionary[key]) delete _dictionary[key]; }
		
		public static var _cal_data:Vector.<Vector.<Vector.<Object>>> = new Vector.<Vector.<Vector.<Object>>>(12);
		
		public static function loadEnvironments(obj:Object, path:String):void
		{
			var appStorage:File=File.applicationStorageDirectory;
			var dbFile:File = appStorage.resolvePath(path);
			if(dbFile.exists)
			{
				var fs:FileStream=new FileStream;
				fs.open(dbFile,FileMode.READ);
				var result:Object=JSON.parse(fs.readUTF());
				fs.close();
				
				obj=result;
			}
		}
		public static function saveEnvironments(obj:Object, path:String):void
		{			
			var appStorage:File=File.applicationStorageDirectory;
			var dbFile:File = appStorage.resolvePath(path);
			var fs:FileStream=new FileStream;
			fs.open(dbFile,FileMode.WRITE);
			fs.writeUTF(JSON.stringify(obj));
			fs.close();
		}
		public static function deleteAllEnvironments():void
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
		}
		public static function saveCalData():void
		{			
			var appStorage:File=File.applicationStorageDirectory;
			var dbFile:File = appStorage.resolvePath("cal_data");
			var fs:FileStream=new FileStream;
			fs.open(dbFile,FileMode.WRITE);
			fs.writeUTF(JSON.stringify(_cal_data));
			fs.close();
		}
		private static function loadCalData():void
		{
			var appStorage:File=File.applicationStorageDirectory;
			var dbFile:File = appStorage.resolvePath("cal_data");
			if(dbFile.exists)
			{
				var fs:FileStream=new FileStream;
				fs.open(dbFile,FileMode.READ);
				var result:Object=JSON.parse(fs.readUTF());
				fs.close();
				
				for(var i:int = 0; i < result.length; i++)
				{
					_cal_data[i] = new Vector.<Vector.<Object>>(result[i].length);
					for(var j:int = 0; j < result[i].length; j++)
					{
						_cal_data[i][j] = new Vector.<Object>(result[i][j].length);
						for(var k:int = 0; k < result[i][j].length; k++)
						{
							_cal_data[i][j][k] = result[i][j][k];
						}
					}
				}
			}
		}
		public function Calender()
		{
			super();
			
			if(IsIPhone) SilentSwitch.apply();	//iPhoneMute Control
			
			_main = this;	//set Main Object
			
//			for(var i:int = 0; i < 12; i++)
//			{
//				var day:int = 31;
//				
//				if(day == 31 && (i == 3 || i == 5 || i == 8 || i == 10))
//					day = 30;
//				if(day >= 29 && i == 1)
//					day = 28;
//				_cal_data[i] = new Vector.<Vector.<Object>>(day);
//				for(var j:int = 0; j < day; j++)
//				{
//					_cal_data[i][j] = new Vector.<Object>;
//				}
//			}
//			saveEnvironments(_cal_data, "cal_data");
			//loadEnvironments(_cal_data, "cal_data");
			loadCalData();
			
			addEventListener(Event.ADDED_TO_STAGE, initialize);
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
				fps.x = FullWidth/2 - fps.width/2;
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
			stage.color = 0xffffff;	//set the stage background color(initial)
			stage.scaleMode = StageScaleMode.NO_SCALE;	//EXACT_FIT - 종횡 비율 유지안하고 전체표시
														//NO_BORDER - 종횡 비율 유지하고 전체표시
														//NO_SCALE - 디바이스 해상도 상관없이 크기 유지
														//SHOW_ALL - 종횡비율유지하고 지정영역에 표시
			stage.align = StageAlign.TOP_LEFT;	//align stage to left top

			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, onActivate, false, 0, true);		//Applictaion came back from background
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, onDeactivate, false, 0, true);	//Application sent to background
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);//Applictaion button Clicked

			
			stage.addEventListener(Event.RESIZE, stage_onResize);
			if(IsIOS7)	drawTopMargin(0x64beb4);
			setTimeout(Render, 1);
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
			
			_header = new Header;
			_topLayer.addChild(_header);
//			_footer = new Footer;
//			_topLayer.addChild(_footer);
//			
//			
//			_footer.addChildAt(new TabBar(BitmapControl.TOP_BG), 0);
//			
//			(_footer.getChildByName("TabBar") as TabBar).addBar(BitmapControl.TAB1_UP, BitmapControl.TAB1_DOWN, "TempPage", {y:0});
//			(_footer.getChildByName("TabBar") as TabBar).addBar(BitmapControl.TAB2_UP, BitmapControl.TAB2_DOWN, "Temp2Page", {y:0});
//			(_footer.getChildByName("TabBar") as TabBar).addBar(BitmapControl.TAB3_UP, BitmapControl.TAB3_DOWN, "Temp3Page", {y:0});
//			(_footer.getChildByName("TabBar") as TabBar).addBar(BitmapControl.TAB4_UP, BitmapControl.TAB4_DOWN, "Temp4Page", {y:0});
//			
//			
			_header.addChildAt(new NavigationBar(BitmapControl.TOP_BG), 0);
//			_header.addChildAt(new SlideBar(BitmapControl.SLIDE_BG), 1);
//			
//			
//			(_header.getChildByName("SlideBar") as SlideBar).addItem(Text.newText("관심지역", 19, 0xfffefe,0,0,"left","NanumGothicBold"), null);
//			(_header.getChildByName("SlideBar") as SlideBar).addItem(Text.newText("지역 전체", 19, 0xfffefe,0,0,"left","NanumGothicBold"), null);
//			(_header.getChildByName("SlideBar") as SlideBar).addItem(Text.newText("강남구", 19, 0xfffefe,0,0,"left","NanumGothicBold"), null);
//			(_header.getChildByName("SlideBar") as SlideBar).addItem(Text.newText("마포구", 19, 0xfffefe,0,0,"left","NanumGothicBold"), null);
//			(_header.getChildByName("SlideBar") as SlideBar).addItem(Text.newText("송파구", 19, 0xfffefe,0,0,"left","NanumGothicBold"), null);
//			(_header.getChildByName("SlideBar") as SlideBar).addItem(Text.newText("김구", 19, 0xfffefe,0,0,"left","NanumGothicBold"), null);
//			(_header.getChildByName("SlideBar") as SlideBar).addItem(Text.newText("안구", 19, 0xfffefe,0,0,"left","NanumGothicBold"), null);
//			(_header.getChildByName("SlideBar") as SlideBar).addItem(Text.newText("지마구", 19, 0xfffefe,0,0,"left","NanumGothicBold"), null);
//			(_header.getChildByName("SlideBar") as SlideBar).addItem(Text.newText("으이구", 19, 0xfffefe,0,0,"left","NanumGothicBold"), null);
//			(_header.getChildByName("SlideBar") as SlideBar).addItem(Text.newText("비둘기구구구", 19, 0xfffefe,0,0,"left","NanumGothicBold"), null);
//			
			_header.onResize();
			
			changePage("MainPage", PageEffect.RIGHT);
			
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
			_pageHeight=FullHeight;
			
			//set page's default y pos
			if(_cur_page ) _cur_page.y = TopMargin+HeaderHeight;			
			if(_next_page) _next_page.y = TopMargin+HeaderHeight;
		}
		private var _changingPage:Boolean = false;
		public function get isChangingPage():Boolean { return _changingPage; }
		public function changePage(name:String, type:String=PageEffect.LEFT, params:Object=null, duration:Number=0.5):void
		{
			if(_changingPage)	return;
			
			if(_cur_page_name == name)	return;		//if it is same page, don't change.
			
			if(!params) params = new Object;
			var pageClass:Class = PageConnector.GetPageClass(name);
						
			if(_cur_page)	//not called once
			{
				_cur_page.dispose();
				if(Calender.Main.dictionary["NavigationBar"])	Calender.Main.dictionary["NavigationBar"].disable = false;
				if(Calender.Main.dictionary["SlideBar"])		Calender.Main.dictionary["SlideBar"].disable = false;
				_next_page = new pageClass(params);
				_pageLayer.addChild(_next_page);
				if(type == PageEffect.NONE)			//effect with none
				{
					PageTweenEnded();
					
					if(_cur_page_name != "AddPage") _header.changePage(_cur_page_name, params);		//send _cur_page_name(to send the name before)
					if(_clear_navigation) (_header.getChildAt(0) as NavigationBar).clear();
					_clear_navigation = false;
					_cur_page_name = name;
					
					//_footer.changePage(_cur_page_name, params);
					
					//calcPageSize();		//calculate page size after adding page
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
				
				if(_cur_page_name != "AddPage") _header.changePage(_cur_page_name, params);		//send _cur_page_name(to send the name before)
				if(_clear_navigation) (_header.getChildAt(0) as NavigationBar).clear();
				_clear_navigation = false;
			}
			else			//when called for the first time
			{
				_cur_page = new pageClass;
				_pageLayer.addChild(_cur_page);
			}
			
			
			_cur_page_name = name;
			
			//_footer.changePage(_cur_page_name, params);
			
			calcPageSize();		//calculate page size after adding page
		}
		private function PageTweenEnded():void
		{
			//intitialize after page tween
			_pageLayer.removeChild(_cur_page);
			_cur_page = _next_page;
			_changingPage = false;
			(_header.getChildAt(0) as NavigationBar).prevClicked = false;
		}
	}
}