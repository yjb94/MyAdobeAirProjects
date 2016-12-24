package Page.Home
{	
	import com.devactionscript.datetimepicker.DateTimePickerEvent;
	import com.devactionscript.datetimepicker.FreeAneDateTimePicker;
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLVariables;
	import flash.text.TextField;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.SlideImage;
	import Displays.Text;
	
	import Header.NavigationBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	
	import Scroll.Scroll;
	
	import pl.mateuszmackowiak.nativeANE.dialogs.NativeAlertDialog;
	
	public class AddPage extends BasePage
	{	
		private const ANCHOR_TWEEN_DURATION:Number = 0.3;
		private const BASE_Y_INTERVAL:Number = 30;
		
		private const TITLE_FONT_SIZE:Number = 32*Config.ratio;
		private const TEXT_FONT_SIZE:Number = 40*Config.ratio;
		
		private const ITEM_Y_MARGIN:Number = 50;
		
		private const TITLE_BASE_TEXT:String = "제목을 입력해주세요.";
		private const DETAIL_BASE_TEXT:String = "내용을 입력해주세요.";
		
		private var _start_time_btn:Button;
		private var _start_time_text:TextField;
		private var _start_time_picker:FreeAneDateTimePicker = FreeAneDateTimePicker.getInstance();
		
		private var _end_time_btn:Button;
		private var _end_time_text:TextField;
		private var _end_time_picker:FreeAneDateTimePicker = FreeAneDateTimePicker.getInstance();
		
		private var _title_text:Object;
		private var _detail_text:Object;
		
		private var _is_picker_on:Boolean;
		
		public function AddPage(params:Object=null)
		{
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = Text.newText("일정 추가", TITLE_FONT_SIZE, 0xffffff);
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Right = 
				new Button(BitmapControl.newBitmap(BitmapControl.CHECK_BUTTON), BitmapControl.newBitmap(BitmapControl.CHECK_BUTTON), onAddComplete);
			
			
			
			
			bmp = BitmapControl.newBitmap(BitmapControl.NELBO_HEAD, 40, 50);
			addChild(bmp);
			
			txt = Text.newText("제목", TITLE_FONT_SIZE, 0x564330, bmp.x + bmp.width + 10);
			txt.y = bmp.y + bmp.height/2 - txt.height/2 + 5;
			addChild(txt);
			
			_title_text = Text.newInputTextbox(BitmapControl.TEXTFIELD, TEXT_FONT_SIZE, TITLE_BASE_TEXT, 0x585858, 23, bmp.y + bmp.height-2);
			(_title_text.txt as TextField).addEventListener(MouseEvent.CLICK, onClickInputText);
			(_title_text.txt as TextField).addEventListener(FocusEvent.FOCUS_OUT, onFocusInputText);
			addChild(_title_text.bmp);
			addChild(_title_text.txt);
			
			
			
			bmp = BitmapControl.newBitmap(BitmapControl.NELBO_HEAD, 40, 250);
			addChild(bmp);
			
			txt = Text.newText("내용", TITLE_FONT_SIZE, 0x564330, bmp.x + bmp.width + 10);
			txt.y = bmp.y + bmp.height/2 - txt.height/2 + 5;
			addChild(txt);
			
			_detail_text = Text.newInputTextbox(BitmapControl.TEXTFIELD, TEXT_FONT_SIZE, DETAIL_BASE_TEXT, 0x585858, 23, bmp.y + bmp.height-2);
			(_detail_text.txt as TextField).addEventListener(MouseEvent.CLICK, onClickInputText);
			(_detail_text.txt as TextField).addEventListener(FocusEvent.FOCUS_OUT, onFocusInputText);
			addChild(_detail_text.bmp);
			addChild(_detail_text.txt);
			
			
			
			
			
			var bmp:Bitmap = BitmapControl.newBitmap(BitmapControl.NELBO_HEAD, 40, 450);
			addChild(bmp);
			
			var txt:TextField = Text.newText("시작 시간", TITLE_FONT_SIZE, 0x564330, bmp.x + bmp.width + 10);
			txt.y = bmp.y + bmp.height/2 - txt.height/2 + 5;
			addChild(txt);
			
			_start_time_btn = new Button(BitmapControl.TEXTFIELD, BitmapControl.TEXTFIELD, function(e:MouseEvent):void
			{
				_start_time_picker.showTimePicker();
				_end_time_picker.removeEventListener(DateTimePickerEvent.TIME_CHANGED, onEndTimeChanged);
				_start_time_picker.addEventListener(DateTimePickerEvent.TIME_CHANGED, onStartTimeChanged);
			}, 23, bmp.y + bmp.height-2);
			addChild(_start_time_btn);
			_start_time_text = Text.newText("", TEXT_FONT_SIZE, 0x585858, 10);
			_start_time_btn.addChild(_start_time_text);
			
			
			
			bmp = BitmapControl.newBitmap(BitmapControl.NELBO_HEAD, 40, 650);
			addChild(bmp);
			
			txt = Text.newText("종료 시간", TITLE_FONT_SIZE, 0x564330, bmp.x + bmp.width + 10);
			txt.y = bmp.y + bmp.height/2 - txt.height/2 + 5;
			addChild(txt);
			
			_end_time_btn = new Button(BitmapControl.TEXTFIELD, BitmapControl.TEXTFIELD, function(e:MouseEvent):void
			{
				_end_time_picker.showTimePicker();
				_start_time_picker.removeEventListener(DateTimePickerEvent.TIME_CHANGED, onStartTimeChanged);
				_end_time_picker.addEventListener(DateTimePickerEvent.TIME_CHANGED, onEndTimeChanged);
			}, 23, bmp.y + bmp.height - 2);
			addChild(_end_time_btn);
			_end_time_text = Text.newText("", TEXT_FONT_SIZE, 0x585858, 10);
			_end_time_btn.addChild(_end_time_text);
		}
		private function onClickInputText(e:MouseEvent):void
		{
			if(e.type == MouseEvent.CLICK)
			{
				anchor(-(e.currentTarget as TextField).y + Elever.Main.HeaderHeight + BASE_Y_INTERVAL);
			}
		}
		private function onFocusInputText(e:FocusEvent):void
		{
			if(e.type == FocusEvent.FOCUS_OUT)
			{
				if(stage.focus == null)
					anchor(Elever.Main.HeaderHeight);
			}
		}
		private function anchor(y:Number):void
		{
			TweenLite.to(this, ANCHOR_TWEEN_DURATION, { y:y });
		}
		private function onStartTimeChanged(e:Event):void
		{
			var hour:String = _start_time_picker.getHour().toString();
			if(hour.length == 1) hour = "0"+hour;
			var min:String = _start_time_picker.getMinute().toString();
			if(min.length == 1) min = "0"+min;
			
			_start_time_text.text = hour + ":" + min;
			_start_time_text.y = _start_time_btn.height/2 - _start_time_text.height/2;
		}
		private function onEndTimeChanged(e:Event):void
		{
			var hour:String = _end_time_picker.getHour().toString();
			if(hour.length == 1) hour = "0"+hour;
			var min:String = _end_time_picker.getMinute().toString();
			if(min.length == 1) min = "0"+min;
			
			_end_time_text.text = hour + ":" + min;
			_end_time_text.y = _end_time_btn.height/2 - _end_time_text.height/2;
		}
		private function onAddComplete(e:MouseEvent):void
		{
			if(checkNext())
			{
				var obj:Object = { start_time:_start_time_text.text, end_time:_end_time_text.text, title:_title_text.txt.text, detail:_detail_text.txt.text, rate:0 };
				Elever.saveEnviroment("Schedule/"+Elever.ScheduleIndex, obj);
				Elever.ScheduleIndex++;
				Elever.saveEnviroment("ScheduleIndex", Elever.ScheduleIndex);
				Elever.Main.changePage("HomePage", PageEffect.LEFT, obj);
			}
		}
		private function checkNext():Boolean
		{
			var str:String = "";
			if((_title_text.txt as TextField).text == "" || (_title_text.txt as TextField).text == TITLE_BASE_TEXT)
				str = "제목을 입력해주세요.";
			else if((_detail_text.txt as TextField).text == "" || (_detail_text.txt as TextField).text == DETAIL_BASE_TEXT)
				str = "내용을 입력해주세요.";
			else if(_start_time_text.text == "")
				str = "시작시간을 입력해주세요.";
			else if(_end_time_text.text == "")
				str = "종료시간을 입력해주세요.";
			else if(_start_time_text.text == _end_time_text.text)
				str = "시작시간과 종료시간을 다르게 설정해주세요.";
			else if(compareTime(_start_time_text.text, _end_time_text.text) < 0)
				str = "종료시간이 시작시간보다 크게 해주세요.";
			
			
			if(str == "")
				return true;
			else
			{
				NativeAlertDialog.show(str, "알림");
				return false;
			}
		}
		public static function compareTime(start_time:String, end_time:String):Number
		{
			var hour1:Number = Number(start_time.substr(0,2));
			var min1:Number = Number(start_time.substr(3,2));
			
			var hour2:Number = Number(end_time.substr(0,2));
			var min2:Number = Number(end_time.substr(3,2));
			
			min1 += hour1*60;
			min2 += hour2*60;
			
			return min2-min1;
		}
		public override function init():void
		{
		}
		public override function onResize():void
		{
		}
		
		public override function dispose():void
		{
			_start_time_picker.removeEventListener(DateTimePickerEvent.TIME_CHANGED, onStartTimeChanged);
			_end_time_picker.removeEventListener(DateTimePickerEvent.TIME_CHANGED, onEndTimeChanged);
		}
	}
}