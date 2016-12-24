package Page.Reserve.Popup
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.globalization.DateTimeFormatter;
	import flash.net.URLVariables;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.SlideImage;
	import Displays.Text;
	
	import Header.NavigationBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	
	import Scroll.Scroll;
	
	public class DatePopup extends BasePage
	{
		private const MONTH_FONT_SIZE:Number = 52.6*Config.ratio;
		private const TITLE_FONT_SIZE:Number = 50*Config.ratio;
		private const TEXT_FONT_SIZE:Number = 48*Config.ratio;
		private const DATE_FONT_SIZE:Number = 34*Config.ratio;
		
		private const LINE_COLOR:uint = 0xb8b8b8;
		private const FRAME_THICKNESS:Number = 8*Config.ratio;
		
//		private const COLOR_CANNOT:uint = 0xdd5858;
		private const COLOR_SELECT:uint = 0xeed380;
		
		private const CALENDER_WIDTH:Number = 111*Config.ratio;
		private const CALENDER_HEIGHT:Number = 126*Config.ratio;
				
		private var _cur_date:Date = new Date;
		
		private var _month:TextField;
		
		private var _calender:Sprite = null;
		private var _selected_index:int = -1;
		private var _sel_date:Date = new Date;
		
		private var _store_seq:String;
		
		private var _selected:Boolean = false;
		
		public function DatePopup(params:Object=null)
		{
			super();
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = Text.newText("예약날짜", TITLE_FONT_SIZE, 0xffffff);
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Right
				= new Button(Text.newText("선택      ", TEXT_FONT_SIZE, 0xffffff), Text.newText("선택      ", TEXT_FONT_SIZE, 0xd9d9d9), function():void
				{
					_selected= true;
					(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).onPrevClick();
				});
			
			if(params.rsvMainData.date_text)
			{
				var date_text:String = params.rsvMainData.date_text;
				
				_cur_date.fullYear = Number(date_text.substr(0, 4));
				_cur_date.month	   = Number(date_text.substr(5, 2))-1;
				_cur_date.date	   = Number(date_text.substr(8, 2));
				
				_sel_date.fullYear = Number(date_text.substr(0, 4));
				_sel_date.month	   = Number(date_text.substr(5, 2))-1;
				_sel_date.date	   = Number(date_text.substr(8, 2));
				
				_store_seq = params.store_seq;
				setCalender(_store_seq);
								
				_month = Text.newText(String(_cur_date.month+1)+"월", MONTH_FONT_SIZE, 0x585858, 0, 233*Config.ratio);
				_month.x = Elever.Main.PageWidth/2 - _month.width/2;
				addChild(_month);
				
				addChild(new Button(BitmapControl.LEFT_BUTTON, BitmapControl.LEFT_BUTTON, function():void
				{
					_cur_date.month--;
					setCalender(_store_seq);
				}, 300*Config.ratio, _month.y-32*Config.ratio));
				
				addChild(new Button(BitmapControl.RIGHT_BUTTON, BitmapControl.RIGHT_BUTTON, function():void
				{
					_cur_date.month++;
					setCalender(_store_seq);
				}, 752*Config.ratio, _month.y-32*Config.ratio));
			}
		}
		private function setCalender(store_seq:String):void
		{
			if(_month)
			{
				_month.text = String(_cur_date.month+1)+"월";
				_month.x = Elever.Main.PageWidth/2 - _month.width/2;
			}
			drawCalender();
			setCalenderState(store_seq);
		}
		private function drawCalender():void
		{
			removeCalender();
			
			_calender = new Sprite;
			
			_calender.graphics.beginFill(LINE_COLOR);
			_calender.graphics.lineStyle(FRAME_THICKNESS, LINE_COLOR);
			_calender.graphics.drawRect(-FRAME_THICKNESS/2, -FRAME_THICKNESS/2, CALENDER_WIDTH*7+FRAME_THICKNESS, CALENDER_HEIGHT*6+FRAME_THICKNESS);
			_calender.graphics.lineStyle();
			_calender.graphics.endFill();	
			
			var curdate:Date = new Date(_cur_date.fullYear, _cur_date.month, 1);
			var now:Date = new Date;
			while(curdate.day)	//if not sunday
				curdate.date--;
			
			for(var i:int = 0; i < 6; i++)
			{
				for(var j:int = 0; j < 7; j++)
				{
					var color:uint = 0x585858;
					if(j==0) color=0xed8176;
					else if(j==6) color=0x7d9bfb;
					if(curdate.month != _cur_date.month)
						color = 0xafafaf;
					
					var txt:TextField = Text.newText(curdate.date.toString(), DATE_FONT_SIZE, color, 
						0, 3, TextFieldAutoSize.RIGHT, "NanumBarunGothic", CALENDER_WIDTH-3);
					txt.name = "text";
					
					var cal_index:Sprite = new Sprite;
					cal_index.x = Math.round(CALENDER_WIDTH*j);
					cal_index.y = Math.round(CALENDER_HEIGHT*i-1);
					
					cal_index.name = Config.dateToYYYYMMDD(curdate);
					
					setItemColor(cal_index, 0xffffff);
					
					cal_index.addChild(txt);
					_calender.addChild(cal_index);
					
					curdate.date++;
				}
			}
			
			_calender.x = Elever.Main.PageWidth/2 - _calender.width/2;
			_calender.y = Elever.Main.PageHeight/2 - _calender.height/2;
			addChild(_calender);
		}
		private function removeCalender():void
		{			
			if(_calender)
			{
				while(_calender.numChildren)
					_calender.removeChildAt(0);
				
				removeChild(_calender);
				_calender = null;
			}
		}
		private function setCalenderState(store_seq:String):void
		{
			var date_arr:Array = (Elever.loadEnviroment("item_seq"+store_seq, null).store_time).split("/");
			
			for(var i:int = 0; i < _calender.numChildren; i++)
			{
				var spr:Sprite = _calender.getChildAt(i) as Sprite;
				
				if(date_arr[i%7] == "휴무")
				{	
					setCannot(spr);
				}
				else
					spr.addEventListener(MouseEvent.CLICK, onMouseClick);
				
				if(spr.name == selDate)
				{
					setItemColor(spr, COLOR_SELECT);
					_selected_index = _calender.getChildIndex(spr);
				}
			}
		}
		private function get selDate():String
		{
			return Config.dateToYYYYMMDD(_sel_date);
		}
		private function set selDate(str:String):void
		{
			_sel_date.fullYear = Number(str.substr(0,4));
			_sel_date.month = Number(str.substr(4,2))-1;
			_sel_date.date = Number(str.substr(6,2));
		}
		private function onMouseClick(e:MouseEvent):void
		{
			if(_selected_index != -1)
				setItemColor(_calender.getChildAt(_selected_index) as Sprite, 0xffffff);
			
			setItemColor(e.currentTarget as Sprite, COLOR_SELECT);
			
			_selected_index = _calender.getChildIndex(e.currentTarget as Sprite);
			
			selDate = (e.currentTarget as Sprite).name; 
		}
		private function setItemColor(spr:Sprite, color:uint, line_color:uint=LINE_COLOR):void
		{
			spr.graphics.clear();
			
			spr.graphics.beginFill(color);
			spr.graphics.lineStyle(1, line_color);
			spr.graphics.drawRect(0, 0, CALENDER_WIDTH+1, CALENDER_HEIGHT);
			spr.graphics.lineStyle();
			spr.graphics.endFill();	
		}
		private function setCannot(spr:Sprite):void
		{
			spr.removeChild(spr.getChildByName("text"));
			spr.addChild(BitmapControl.newBitmap(BitmapControl.CALNEDER_CANNOT, spr.width/2, spr.height/2, true));
		}
		public override function init():void
		{
		}
		public override function onResize():void
		{
		}
		
		public override function dispose():void
		{
			if(_selected)
			{
				var obj:Object = (Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).previousPage.page_params;
				
				const DATE_ARRAY:Array = ["일", "월", "화", "수", "목", "금", "토"];
				var date_str:String = Config.dateToYYYYMMDD(_sel_date);
				obj.rsvMainData.date_text = _sel_date.fullYear + "년" + date_str.substr(4,2) + "월" + date_str.substr(6,2) + "일" + DATE_ARRAY[_sel_date.day] + "요일";
				
				(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).previousPage.page_params = obj;
			}
		}
	}
}