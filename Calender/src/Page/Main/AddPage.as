package Page.Main
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.GesturePhase;
	import flash.events.MouseEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.events.TransformGestureEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.ReturnKeyLabel;
	import flash.text.SoftKeyboardType;
	import flash.text.StageText;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.Text;
	
	import Header.NavigationBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	
	import Scroll.Scroll;
	
	public class AddPage extends BasePage
	{
		[Embed(source="fonts/NanumGothicBold.ttf", mimeType = "application/x-font-truetype", fontName="NanumGothicBold", embedAsCFF=false)]
		private static const fontMain:Class;
		
		[Embed(source = "assets/temp/textField.png")]
		private static const TEXTFIELD:Class;
		
		private var _start_time:TextField;
		private var _help_text:TextField;
		private var _time_text:TextField;
		
		private var _end_time:TextField;
		private var _end_bmp:Bitmap;
		private var _end_text:TextField;
		
		private var _schedule_spr:Sprite;
		private var _schedule_text:TextField;
		private var _lastHeightSch:Number;
		
		private var _splitter:Sprite;
		
		private var _save_start_day:String = "1200";
		private var _save_end_day:String = "1200";
		private var _save_time:String = "1200";
		
		private var _checkButton:Button;
		private var _plusButton:Sprite;
		private var _mode:String = "time";
		
		private var _params:Object = new Object;
		
		private static var _term_level:Vector.<int> = new Vector.<int>(6);
		private static var _cur_color:Object = new Object;
		private static var _cur_term_color:int = 0;
		private static var _cur_time_color:int = 0;
		
		public static function saveData():void
		{			
			var appStorage:File=File.applicationStorageDirectory;
			var dbFile:File = appStorage.resolvePath("add_data");
			var fs:FileStream=new FileStream;
			fs.open(dbFile,FileMode.WRITE);
			fs.writeUTF(JSON.stringify(_term_level));
			fs.close();
		}
		private static function loadData():void
		{
			var appStorage:File=File.applicationStorageDirectory;
			var dbFile:File = appStorage.resolvePath("add_data");
			if(dbFile.exists)
			{
				var fs:FileStream=new FileStream;
				fs.open(dbFile,FileMode.READ);
				var result:Object=JSON.parse(fs.readUTF());
				fs.close();
				
				for(var i:int = 0; i < result.length; i++)
				{
					_term_level[i] = result[i];
				}
			}
		}
		public static function saveColor():void
		{			
			var appStorage:File=File.applicationStorageDirectory;
			var dbFile:File = appStorage.resolvePath("cur_color");
			var fs:FileStream=new FileStream;
			fs.open(dbFile,FileMode.WRITE);
			fs.writeUTF(JSON.stringify(_cur_color));
			fs.close();
		}
		private static function loadColor():void
		{
			var appStorage:File=File.applicationStorageDirectory;
			var dbFile:File = appStorage.resolvePath("cur_color");
			if(dbFile.exists)
			{
				var fs:FileStream=new FileStream;
				fs.open(dbFile,FileMode.READ);
				var result:Object=JSON.parse(fs.readUTF());
				fs.close();
				
				_cur_color = result;
			}
		}
		
		public function AddPage(params:Object=null)
		{
			super();
			
			loadColor();
			loadData();
			
			_params = params;
			
			_checkButton = new Button(BitmapControl.CHECK_BUTTON, BitmapControl.CHECK_BUTTON, checkClicked, -20);
			_checkButton.isTabbed = true;;
			(Calender.Main.header.getChildAt(0) as NavigationBar).Right = _checkButton;
			this.y += Calender.Main.TopMargin+Calender.Main.HeaderHeight;
			
			//
			_start_time = Text.newText("시간 - ", 28, 0x555555, 40, 50, "left", "NaNumGothicBold");
			addChild(_start_time);
			
			_end_time = Text.newText("종료 - ", 28, 0x555555, 40, _start_time.y + _start_time.height + 30, "left", "NaNumGothicBold");
			
			//
			var bmp:Bitmap = new TEXTFIELD; bmp.smoothing = true; bmp.x = _start_time.x+_start_time.width+10; bmp.y = _start_time.y-5; addChild(bmp);
			
			_end_bmp = new TEXTFIELD; _end_bmp.smoothing = true; _end_bmp.x = bmp.x; _end_bmp.y = _end_time.y-5;
			//
			_time_text = new TextField;
			_time_text.type = TextFieldType.INPUT;
			_time_text.height = 28;
			var fmt:TextFormat = _time_text.defaultTextFormat; fmt.font = "NaNumGothicBold"; 
			fmt.size = _time_text.height/1.3; _time_text.defaultTextFormat = fmt;
			_time_text.embedFonts = true;
			_time_text.x = bmp.x + 10;
			_time_text.y = bmp.y + 8;
			_time_text.restrict = "0-9";
			_time_text.width = bmp.width - 13;
			_time_text.addEventListener(FocusEvent.FOCUS_IN, timeFocus);
			_time_text.addEventListener(FocusEvent.FOCUS_OUT, timeFocus);
			
			_save_start_day = _params.md as String;
			var month:int = int((_params.md as String).substr(0,2));
			var day:int = int((_params.md as String).substr(2,4));
			_save_end_day = (_params.md as String).substr(0,2)+((String(day+1).length < 2) ? "0"+String(day+1) : String(day+1));
			
			_time_text.text = month+"월 "+day+"일 "+"오후 12시 0분";
			
			addChild(_time_text);
			
			
			_end_text = new TextField;
			_end_text.type = TextFieldType.INPUT;
			_end_text.height = 28;
			fmt = _end_text.defaultTextFormat; fmt.font = "NaNumGothicBold"; 
			fmt.size = _end_text.height/1.3; _end_text.defaultTextFormat = fmt;
			_end_text.embedFonts = true;
			_end_text.x = _end_bmp.x + 10;
			_end_text.y = _end_bmp.y + 8;
			_end_text.restrict = "0-9";
			_end_text.width = _end_bmp.width - 13;
			_end_text.addEventListener(FocusEvent.FOCUS_IN, endtimeFocus);
			_end_text.addEventListener(FocusEvent.FOCUS_OUT, endtimeFocus);
			
			_end_text.text = getEndMD();
			
			//
			_plusButton = new Sprite;
			_plusButton.x = bmp.x+bmp.width+10-5;
			_plusButton.y = bmp.y-5;
			_plusButton.addEventListener(MouseEvent.CLICK, plusClicked);
			addChild(_plusButton);
		
			_plusButton.addChild(BitmapControl.newBitmap(BitmapControl.PLUS, 5, 5));
			
			//
			_help_text = Text.newText("4자리의 숫자를 입력할것.\n   ex)오후 1시 3분 - 1303", 22, 0xbdbdbd, bmp.x+50, bmp.y+bmp.height+10, "left", "NaNumGothicBold");
			addChild(_help_text);
			
			//
			_splitter = new Sprite;
			_splitter.graphics.beginFill(0xafafaf);
			_splitter.graphics.drawRect(20, 0, Calender.Main.PageWidth-40, 2);
			_splitter.graphics.endFill();
			_splitter.y = _help_text.y + _help_text.height + 20;
			addChild(_splitter);
			
			//
			_schedule_spr = new Sprite;
			var spr:Sprite = new Sprite;
			_schedule_spr.x = 40;
			_schedule_spr.y = _splitter.y + _splitter.height + 20;
			
			var txt:TextField  = Text.newText("내용", 28, 0x555555, 0, 0, "left", "NaNumGothicBold");
			_schedule_spr.addChild(txt);
			
			
			_schedule_text=new TextField;
			_schedule_text.type=TextFieldType.INPUT;
			fmt=_schedule_text.defaultTextFormat; fmt.font="NaNumGothicBold"; 
			fmt.size = 28/1.3; _schedule_text.defaultTextFormat = fmt;
			//_schedule_text.autoSize=TextFieldAutoSize.LEFT;
			_schedule_text.x = txt.x + 10;
			_schedule_text.y = txt.y + txt.height + 20;
			_schedule_text.width = 450;
			_schedule_text.height = 28*3;
			_schedule_text.embedFonts=true;
			_schedule_text.multiline = true;
			_schedule_text.wordWrap = true;
			_schedule_text.addEventListener(Event.CHANGE, scheduleChange);
			spr.addChild(_schedule_text);
			
			spr.graphics.beginFill(0xf6f6f6);
			spr.graphics.lineStyle(1,0x909191);
			spr.graphics.drawRoundRect(_schedule_text.x-10,_schedule_text.y-8,_schedule_text.width+8,_schedule_text.height+12,10,10);
			spr.graphics.lineStyle();
			spr.graphics.endFill();
			_lastHeightSch = _schedule_text.height;
			
			_schedule_spr.addChild(spr);
			addChild(_schedule_spr);
		}
		private function scheduleChange(e:Event):void
		{
			if(_schedule_text.text.length > 0)	
			{
				if(_checkButton.isTabbed)
					_checkButton.isTabbed = false;
			}
			else 
			{
				if(!_checkButton.isTabbed)
					_checkButton.isTabbed = true;
			}
			
			if(_lastHeightSch == _schedule_text.height) return;
			
			var sprite:Sprite = _schedule_text.parent as Sprite;
			
			sprite.graphics.clear();
			sprite.graphics.beginFill(0x000000,0);
			sprite.graphics.drawRect(0,0,485,1);
			sprite.graphics.endFill();
			
			sprite.graphics.beginFill(0xf6f6f6);
			sprite.graphics.lineStyle(1,0x909191);
			sprite.graphics.drawRoundRect(_schedule_text.x-10,_schedule_text.y-8,_schedule_text.width+10,_schedule_text.height+12,10,10);
			sprite.graphics.lineStyle();
			sprite.graphics.endFill();
			
			_lastHeightSch = _schedule_text.height;
		}
		private function timeFocus(e:FocusEvent):void
		{
			if(e.type == FocusEvent.FOCUS_OUT)
			{
				stage.focus = null;
				if(_time_text.text.length > 4)
				{
					_time_text.text = _time_text.text.substr(0,4);
				}
				if(_time_text.text.length == 4)
				{
					if(_mode == "time")
					{
						_save_time = _time_text.text;
						var hour:int = int(_time_text.text.substr(0,2));
						var min:int = int(_time_text.text.substr(2,4));
						var text:String = (hour >= 12) ? "오후 " : "오전 ";
						if(hour == 24)
						{
							text = "오전 "; hour = 0;
						}
						if(hour > 24) hour = 23;
						if(hour > 12) hour -= 12;
						if(min > 59) min = 59;
						
						var month:int = int((_params.md as String).substr(0,2));
						var day:int = int((_params.md as String).substr(2,4));
						
						_time_text.text = month+"월 "+day+"일 "+ text + hour + "시 " + min + "분";
					}
					else if(_mode == "term")
					{
						_save_start_day = _time_text.text;
						month = int(_save_start_day.substr(0,2));
						day = int(_save_start_day.substr(2,4));
						
						if(month > 12) month = 12;
						if(day > 31) day = 31;
						if(day == 31 && (month == 4 || month == 6 || month == 9 || month == 11))
							day = 30;
						if(day >= 29 && month == 2)
							day = 28;
						
						_time_text.text = month+"월 "+day+"일 ";
					}
				}
			}
			else if(e.type == FocusEvent.FOCUS_IN)
			{
				if(_mode == "time")
					_time_text.text = _save_time;
				else if(_mode == "term")
					_time_text.text = _save_start_day;
			}
		}
		private function endtimeFocus(e:FocusEvent):void
		{
			if(_mode != "term")	return;
			
			if(e.type == FocusEvent.FOCUS_OUT)
			{
				stage.focus = null;
				if(_end_text.text.length > 4)
				{
					_end_text.text = _end_text.text.substr(0,4);
				}
				else if(_end_text.text.length == 4)
				{
					_save_end_day = _end_text.text;
					var month:int = int(_save_end_day.substr(0,2));
					var day:int = int(_save_end_day.substr(2,4));
					
					if(month > 12) month = 12;
					if(day > 31) day = 31;
					if(day == 31 && (month == 4 || month == 6 || month == 9 || month == 11))
						day = 30;
					if(day >= 29 && month == 2)
						day = 28;
					
					_end_text.text = month+"월 "+day+"일 ";
				}
			}
			else if(e.type == FocusEvent.FOCUS_IN)
			{
				_end_text.text = _save_end_day;
			}
		}
		private function checkClicked(e:MouseEvent):void
		{
			if(_mode == "time")
			{
				var color_arr:Array = new Array(0x000000, 0x41aee2, 0x72c69b, 0xc172c6, 0xe2c641, 0xb6e241, 0xe2415f);
				
				var month:int = int(_save_start_day.substr(0,2));
				var day:int = int(_save_start_day.substr(2,4));
				var obj:Object = new Object;
				obj.schedule = _schedule_text.text;
				obj.type = "time";
				obj.color =  color_arr[_cur_time_color];
				obj.time = _save_time;
				
				_cur_time_color++;
				if(_cur_time_color > color_arr.length-1) _cur_time_color = 0;
				
				Calender._cal_data[month-1][day-1].push(obj);
			}
			else if(_mode == "term")
			{
				var start_month:int = int(getMD(_save_start_day).substr(0,2));
				var start_day:int = int(getMD(_save_start_day).substr(2,4));
				var end_month:int = int(getMD(_save_end_day).substr(0,2));
				var end_day:int = int(getMD(_save_end_day).substr(2,4));
				
				var start_date:Date = new Date(2014, start_month-1, start_day);
				var end_date:Date = new Date(2014, end_month-1, end_day);
				
				var week:int;
				var prev_week:int = getWeekNum(start_date);
				color_arr = new Array(0xed6767, 0xedeb67, 0x67a0ed, 0xc2ed67, 0xeda967, 0x9667ed, 0xff7f46);
				
				while(!((start_date.month == end_date.month) && (start_date.date == end_date.date)))
				{
					obj = new Object;
					obj.schedule = _schedule_text.text;
					obj.type = "term";
					obj.color = color_arr[_cur_term_color];
					
					week = getWeekNum(start_date);
					obj.level = _term_level[week];
					
					if(prev_week != week) _term_level[prev_week]++;
					prev_week = week;
					
					Calender._cal_data[start_date.month][start_date.date-1].push(obj);
					start_date.date++;
				}
				obj = new Object;
				obj.schedule = _schedule_text.text;
				obj.type = "term";
				obj.color = color_arr[_cur_term_color];			
				
				_cur_term_color++;
				if(_cur_term_color > color_arr.length-1) _cur_term_color = 0;
				
				week = getWeekNum(start_date);
				if(prev_week != week) _term_level[prev_week]++;
				obj.level = _term_level[week]++;
				
				Calender._cal_data[start_date.month][start_date.date-1].push(obj);
				start_date.date++;
			}
			_cur_color.term = _cur_term_color;
			_cur_color.time = _cur_time_color;
//			saveColor();
//			saveData();
//			Calender.saveCalData();
			Calender.Main.changePage("MainPage", PageEffect.LEFT, { md:_params.md });
		}
		private function plusClicked(e:MouseEvent):void
		{
			var txt:TextField = new TextField;
			var fmt:TextFormat = txt.defaultTextFormat;
			fmt.font = "NanumGothicBold";
			fmt.size = 40;
			fmt.color = 0xffffff;
			txt.defaultTextFormat = fmt;
			txt.embedFonts=true;
			txt.autoSize = TextFieldAutoSize.CENTER;
			
			if(_mode == "time")
			{
				_plusButton.removeChildAt(0);
				_plusButton.addChild(BitmapControl.newBitmap(BitmapControl.MINUS, 5, 5));
				
				_start_time.text = "시작 - ";
				_help_text.text = "4자리의 숫자를 입력할것.\n   ex)6월 15일 - 0615";
				_help_text.y = _end_bmp.y + _end_bmp.height + 10;
				_time_text.text = getStartMD();
				
				txt.text = "기간";
				
				addChild(_end_time);
				addChild(_end_bmp);
				addChild(_end_text);
				
				_splitter.y = _help_text.y + _help_text.height + 20;
				_schedule_spr.y = _splitter.y + _splitter.height + 20;
				
				_mode = "term";
			}
			else if(_mode == "term")
			{
				_plusButton.removeChildAt(0);
				_plusButton.addChild(BitmapControl.newBitmap(BitmapControl.PLUS, 5, 5));
				
				_start_time.text = "시간 - ";
				_help_text.text = "4자리의 숫자를 입력할것.\n   ex)오후 1시 3분 - 1303";
				_help_text.y = _time_text.y + _time_text.height + 23;
				_time_text.text = getTime();
				
				
				var month:String = (_params.md as String).substr(0,2);
				var date:String = (_params.md as String).substr(2,4);
				txt.text = month+"월"+date+"일";
				
				removeChild(_end_time);
				removeChild(_end_bmp);
				removeChild(_end_text);
				
				_splitter.y = _help_text.y + _help_text.height + 20;
				_schedule_spr.y = _splitter.y + _splitter.height + 20;
				
				_mode = "time";
			}
			(Calender.Main.header.getChildAt(0) as NavigationBar).Middle = txt;
		}
		private function getStartMD():String
		{
			var month:int = int(_save_start_day.substr(0,2));
			var day:int = int(_save_start_day.substr(2,4));
			return  month+"월 "+day+"일 ";
		}
		private function getEndMD():String
		{
			var month:int = int(_save_end_day.substr(0,2));
			var day:int = int(_save_end_day.substr(2,4));
			return  month+"월 "+day+"일 ";
		}
		private function getTime():String
		{
			var hour:int = int(_save_time.substr(0,2));
			var min:int = int(_save_time.substr(2,4));
			var text:String = (hour >= 12) ? "오후 " : "오전 ";
			if(hour == 24)
			{
				text = "오전 "; hour = 0;
			}
			if(hour > 24) hour = 23;
			if(hour > 12) hour -= 12;
			if(min > 59) min = 59;
			
			var month:int = int((_params.md as String).substr(0,2));
			var day:int = int((_params.md as String).substr(2,4));
			return month+"월 "+day+"일 "+ text + hour + "시 " + min + "분";
		}
		private function getMD(str:String):String
		{
			var month:int = int(str.substr(0,2));
			var day:int = int(str.substr(2,4));
			
			if(month > 12) month = 12;
			if(day > 31) day = 31;
			if(day == 31 && (month == 4 || month == 6 || month == 9 || month == 11))
				day = 30;
			if(day >= 29 && month == 2)
				day = 28;
			
			var str1:String = String(month);
			if(str1.length < 2) str1 = "0"+str1;
			var str2:String = String(day);
			if(str2.length < 2) str2 = "0"+str2;
			
			return str1+str2;
		}
		public override function onResize():void
		{
		}
		
		public override function dispose():void
		{
		}
		private function getWeekNum(date:Date):int
		{
			var firstDay:Date = new Date(date.fullYear, date.month, date.date, date.hours, date.minutes, date.seconds, date.milliseconds);
			var firstOfWeek:Date = new Date(date.fullYear, date.month, date.date, date.hours, date.minutes, date.seconds, date.milliseconds);
			firstDay.date = 1;
			while(firstDay.day)	firstDay.date--;
			while(firstOfWeek.day)	firstOfWeek.date--;
			
			
			for(var week:int = 0; firstOfWeek.date != firstDay.date; week++)
				firstDay.date += 7;
			
			return week;
		}
	}
}