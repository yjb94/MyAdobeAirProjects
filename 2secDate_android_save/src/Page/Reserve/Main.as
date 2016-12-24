package Page.Reserve
{
	import com.devactionscript.datetimepicker.DateTimePickerEvent;
	import com.devactionscript.datetimepicker.FreeAneDateTimePicker;
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
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
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.Popup;
	import Displays.SlideImage;
	import Displays.Text;
	
	import Header.NavigationBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	import Page.Home.Home;
	
	import Scroll.Scroll;
		
	public class Main extends BasePage
	{
		private const DATE_ARRAY:Array = ["일", "월", "화", "수", "목", "금", "토"];
		
		private const LINE_X_MARGIN:Number = 52*Config.ratio;
		private const LINE_Y_MARGIN:Number = 68*Config.ratio;
		
		private const ANCHOR_TWEEN_DURATION:Number = 0.3;
		private const BASE_Y_INTERVAL:Number = 30;
		
		private const TITLE_FONT_SIZE:Number = 45*Config.ratio;
		private const TEXT_FONT_SIZE:Number = 40*Config.ratio;
		private const INPUT_TEXT_FONT_SIZE:Number = 42*Config.ratio;
		
		private const TIME_TEXT_MARGIN:Number = 10*Config.ratio;
		
		private const TEXT_MARGIN:Number = 22*Config.ratio;
		private const TEXTFILED_Y_MARGIN:Number = 57*Config.ratio;
		private const ITEM_Y_MARGIN:Number = 57*Config.ratio;
		
		private const MEMBER_BASE_TEXT:String = "숫자만 입력해주세요.";
		
		private var _displays:Scroll;
		
//		private var _stg_member_text:StageText;
		
		private var _date_text:TextField;
		private var _time_text:TextField;
		
		private var _btn_next:Button;
		
		private var _program_yn:String;
		private var _program_text:TextField;
		private var _rsv_data:Object = null;
		
		private var _store_seq:String;
		
		//private var _time_picker:FreeAneDateTimePicker = FreeAneDateTimePicker.getInstance();
		
		public function Main(params:Object=null)
		{
			super();
			if(params)
			{
				if(params.rsvMainData)
					_rsv_data = params.rsvMainData;
				if(params.store_seq)
					_store_seq = params.store_seq;
			}
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = Text.newText("예약신청", TITLE_FONT_SIZE, 0x585858);
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Right = null;
			
			_displays = new Scroll();
			addChild(_displays);
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).addMiddleTouchCallBack(_displays.toTop);
			
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.BLANK_MARGIN));
			
			//위쪽 선
			var bmp:Bitmap = BitmapControl.newBitmap(BitmapControl.TOP_LINE, LINE_X_MARGIN , LINE_Y_MARGIN)
			_displays.addObject(bmp);
			
			//예약 날짜
			bmp = BitmapControl.newBitmap(BitmapControl.TRIANGLE, 75*Config.ratio, bmp.y + bmp.height + TEXTFILED_Y_MARGIN); 
			_displays.addObject(bmp);
			
			var txt:TextField = Text.newText("예약 날짜", TEXT_FONT_SIZE, 0x585858, bmp.x+bmp.width+TEXT_MARGIN, 0, "left", "NanumBarunGothic", 0, 0, { bold:true });
			txt.y = bmp.y + bmp.height/2 - txt.height/2;
			_displays.addObject(txt);
			
			var btn:Button = new Button(BitmapControl.BLUE_SMALL_TEXTFIELD, BitmapControl.BLUE_SMALL_TEXTFIELD, function(e:MouseEvent):void
			{
				setRsvData();
				Elever.Main.changePage("ReserveDatePopup", PageEffect.LEFT, PageParam);
			}, 68*Config.ratio, txt.y + txt.height + TEXTFILED_Y_MARGIN);
			_displays.addObject(btn);
			
			_date_text = Text.newText("", TEXT_FONT_SIZE, 0x585858, TIME_TEXT_MARGIN, 0, "left", "NanumBarunGothic", btn.width - TIME_TEXT_MARGIN);
			_date_text.y = btn.height/2 - _date_text.height/2;
			var now_date:Date = new Date;
			var date_str:String = Config.dateToYYYYMMDD(now_date);
			if(_rsv_data == null)
				_date_text.text = now_date.fullYear + "년" + date_str.substr(4,2) + "월" + date_str.substr(6,2) + "일" + DATE_ARRAY[now_date.day] + "요일";
			else
				_date_text.text = _rsv_data.date_text;
			btn.addChild(_date_text);
			
			
			//예약 시간
			bmp = BitmapControl.newBitmap(BitmapControl.TRIANGLE, 75*Config.ratio, btn.y + btn.height + ITEM_Y_MARGIN); 
			_displays.addObject(bmp);
			
			txt = Text.newText("예약 시간", TEXT_FONT_SIZE, 0x585858,  bmp.x+bmp.width+TEXT_MARGIN, 0, "left", "NanumBarunGothic", 0, 0, { bold:true });
			txt.y = bmp.y + bmp.height/2 - txt.height/2;
			_displays.addObject(txt);
			
			btn = new Button(BitmapControl.RED_SMALL_TEXTFIELD, BitmapControl.RED_SMALL_TEXTFIELD, function(e:MouseEvent):void
			{
				//_time_picker.showTimePicker();
				//_time_picker.addEventListener(DateTimePickerEvent.TIME_CHANGED, onStartTimeChanged);
			}, 68*Config.ratio, txt.y + txt.height + TEXTFILED_Y_MARGIN);
			_displays.addObject(btn);
			
			_time_text = Text.newText("", TEXT_FONT_SIZE, 0x585858, TIME_TEXT_MARGIN, 0, "left", "NanumBarunGothic", btn.width - TIME_TEXT_MARGIN);
			_time_text.y = btn.height/2 - _time_text.height/2;
			now_date.minutes -= now_date.minutes%10;
			if(_rsv_data == null)
				_time_text.text = now_date.toTimeString().substr(0,5);
			else
				_time_text.text = _rsv_data.time_text;
			btn.addChild(_time_text);
			
			
			//예약 인원
			bmp = BitmapControl.newBitmap(BitmapControl.TRIANGLE, 75*Config.ratio, btn.y + btn.height + ITEM_Y_MARGIN); 
			_displays.addObject(bmp);
			
			txt = Text.newText("예약 인원", TEXT_FONT_SIZE, 0x585858, bmp.x+bmp.width+TEXT_MARGIN, 0, "left", "NanumBarunGothic", 0, 0, { bold:true });
			txt.y = bmp.y + bmp.height/2 - txt.height/2;
			_displays.addObject(txt);
			
			var str:String = MEMBER_BASE_TEXT;
			if(_rsv_data)
				if(_rsv_data.member_text)
					str = "";
			var obj:Object = Text.newInputTextbox(BitmapControl.GREEN_SMALL_TEXTFIELD, INPUT_TEXT_FONT_SIZE, str, 0x585858, 68*Config.ratio, txt.y + txt.height + TEXTFILED_Y_MARGIN, "left", "NanumBarunGothic");
			(obj.txt as TextField).name = "InputText";
			if(_rsv_data)
				if(_rsv_data.member_text)
				(obj.txt as TextField).text = _rsv_data.member_text;
			(obj.txt as TextField).addEventListener(Event.CHANGE, function(e:Event):void
			{
				if(isNaN(obj.txt.text.substr(obj.txt.text.length-1)))
				{
					obj.txt.text = obj.txt.text.substr(0, obj.txt.length-1);
					//여기다가 팝업 띄우면서 숫자만 입력하게 하는거.
				}
			});
			(obj.txt as TextField).addEventListener(MouseEvent.CLICK, onClickInputText);
			(obj.txt as TextField).addEventListener(FocusEvent.FOCUS_OUT, onFocusInputText);
			_displays.addObject(obj.bmp); _displays.addObject(obj.txt);
			
			var next_y:Number = obj.bmp.y + obj.bmp.height + ITEM_Y_MARGIN;
			
			//프로그램
			_program_yn = params.program_yn;
			if(_program_yn == "1")	//프로그램이 있으면
			{
				bmp = BitmapControl.newBitmap(BitmapControl.TRIANGLE, 75*Config.ratio, obj.bmp.y + obj.bmp.height + ITEM_Y_MARGIN); 
				_displays.addObject(bmp);
				
				txt = Text.newText("프로그램", TEXT_FONT_SIZE, 0x585858, bmp.x+bmp.width+TEXT_MARGIN, 0, "left", "NanumBarunGothic", 0, 0, { bold:true });
				txt.y = bmp.y + bmp.height/2 - txt.height/2;
				_displays.addObject(txt);
				
				btn = new Button(BitmapControl.BLUE_SMALL_TEXTFIELD, BitmapControl.BLUE_SMALL_TEXTFIELD, function(e:MouseEvent):void
				{
					var data:Object = Elever.loadEnviroment("store_seq/program_list"+_store_seq, data);
					if(data == null)
					{
						var params:URLVariables = new URLVariables;
						params.store_seq = _store_seq;
						Elever.Main.LoadingVisible = true;
						Elever.Connection.post("store/program", params, function(data:String):void
						{
							Elever.Main.LoadingVisible = false;
							if(data)
							{
								var result:Object = JSON.parse(data);
								
								if(result)
								{
									Elever.saveEnviroment("store_seq/program_list"+_store_seq, result.programInfoList);
									setRsvData();
									var obj:Object = PageParam;
									obj.program_list = result.programInfoList;
									Elever.Main.changePage("ReserveProgramPage", PageEffect.LEFT, obj);
								}
							}
						});
					}
					else
					{
						setRsvData();
						var obj:Object = PageParam;
						obj.program_list = data;
						Elever.Main.changePage("ReserveProgramPage", PageEffect.LEFT, obj);
					}
				}, 68*Config.ratio, txt.y + txt.height + TEXTFILED_Y_MARGIN);
				_displays.addObject(btn);
				
				next_y = btn.y + btn.height + ITEM_Y_MARGIN;
				
				str = "";
				if(_rsv_data)
					if(_rsv_data.program_title)
						str = _rsv_data.program_title;
				
				_program_text = Text.newText(str, TEXT_FONT_SIZE, 0x585858, TIME_TEXT_MARGIN, 0, "left", "NanumBarunGothic", btn.width - TIME_TEXT_MARGIN);
				_program_text.y = btn.height/2 - _program_text.height/2;
				btn.addChild(_program_text);
			}
			
			
			//다음 버튼
			_btn_next = new Button(Text.newText("다음", TEXT_FONT_SIZE, 0xed8176), Text.newText("다음", TEXT_FONT_SIZE, 0xedada6), onButtonNext, 0, next_y);
			_btn_next.x = Elever.Main.PageWidth/2 - _btn_next.width/2;
			_displays.addObject(_btn_next);
			
			//아래 선
			if(Elever.Main.PageHeight > _displays.height)
			{
				bmp = BitmapControl.newBitmap(BitmapControl.BOTTOM_LINE_NO_BLANK, LINE_X_MARGIN);
				bmp.y = Elever.Main.PageHeight - bmp.height - LINE_Y_MARGIN;
			}
			else
			{
				bmp = BitmapControl.newBitmap(BitmapControl.BOTTOM_LINE, LINE_X_MARGIN);
				bmp.y = _displays.height + LINE_Y_MARGIN;
			}
			_displays.addObject(bmp);	
		}
		private function onClickInputText(e:MouseEvent):void
		{
			if(e.type == MouseEvent.CLICK)
			{
				anchor(-(e.currentTarget as TextField).y - _displays.scroller.getY() + BASE_Y_INTERVAL);
			}
		}
		private function onFocusInputText(e:FocusEvent):void
		{
			if(e.type == FocusEvent.FOCUS_OUT)
			{
				if(stage.focus == null)
					anchor(0);
			}
		}
		private function anchor(y:Number):void
		{
			TweenLite.to(_displays, ANCHOR_TWEEN_DURATION, { y:y });
		}
		private function onButtonNext(e:MouseEvent):void
		{
			if(checkNext())
			{				
				Elever.Main.changePage("ReserveMain2Page", PageEffect.LEFT, PageParam);
			}
		}
		private function get PageParam():Object
		{
			var obj:Object = new Object;
			setRsvData();
			obj = { 
				program_yn:_program_yn, 
				rsvMainData:_rsv_data,
				store_seq:_store_seq
			};
			return obj;
		}
		private function setRsvData():void
		{
			if(_rsv_data == null)
				_rsv_data = new Object;
			_rsv_data.date_text = _date_text.text;
			_rsv_data.time_text = _time_text.text;
			var member_str:String = (_displays.scroller.getChildByName("InputText") as TextField).text;
			_rsv_data.member_text = (member_str == MEMBER_BASE_TEXT) ? "" : member_str;
		}
		private function checkNext():Boolean
		{
			anchor(0);
			var error_msg:String = "";
			
			if(_program_yn == "1")	if(_program_text.text.length == 0)  error_msg = "프로그램을 선택해 주세요.";
			if((_displays.scroller.getChildByName("InputText") as TextField).text.length > 2) error_msg = "예약 인원이 너무 많습니다.";
			if((_displays.scroller.getChildByName("InputText") as TextField).text.length == 0) error_msg = "예약 인원을 입력해주세요.";
			if((_displays.scroller.getChildByName("InputText") as TextField).text == MEMBER_BASE_TEXT) error_msg = "예약 인원을 입력해주세요.";
			if(_time_text.text.length == 0) error_msg = "시간을 선택해주세요.";
			if(_date_text.text.length == 0) error_msg = "날짜를 선택해주세요.";
			
			if(error_msg == "")
				return true;
			else
			{
				var popup:Popup = new Popup(Popup.OK_TYPE, { main_text:error_msg });
				return false;
			}
		}
		private function onStartTimeChanged(e:Event):void
		{
			//var hour:String = _time_picker.getHour().toString();
			//if(hour.length == 1) hour = "0"+hour;
			//var min:String = _time_picker.getMinute().toString();
			//if(min.length == 1) min = "0"+min;
			
			//_time_text.text = hour + ":" + min;
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

