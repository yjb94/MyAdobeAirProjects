package Page.Home
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.GesturePhase;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.getTimer;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.Popup;
	import Displays.SlideImage;
	import Displays.Text;
	import Displays.WebImage;
	
	import Header.NavigationBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	
	import Scroll.Scroll;
	
	import Utils.Dijkstra;
	import Utils.Timer;

	public class Home extends BasePage
	{
		public static const CIRCLE_SIZE:Number = 220;
		
		private const TEXT_FONT_SIZE:Number = 23.12;
		
		private const INPUT_TEXT_FONT_SIZE:Number = 42*Config.ratio;
		private const TEXTBOX_HEIGHT:Number = 58;
		
		private const TEXTBOX_MARGIN:Number = 30;
		
		private const ANCHOR_TWEEN_DURATION:Number = 0.3;
		private const BASE_Y_INTERVAL:Number = 100;
		
		public static const MAX:int = 99999;
		
		private var _param:Object = new Object;
		
		private var _field:Sprite = new Sprite;
		
		public static var _station_count:int = 0;
		public static var _station_array:Array = new Array;
		private var _state:Array = new Array;
		private var _sht:Array = new Array;
		private var _pre:Array = new Array;
		private var _result_array:Array = new Array;
		public static var _station_place_x:Array = new Array;
		public static var _station_place_y:Array = new Array;
		private var _station_color:Array = new Array;
		private var _station_field:Sprite = new Sprite;
		
		private var _start:int = -1;
		private var _finish:int = -1;
		
		private var _data_field:Sprite = new Sprite;
		
		public static var DKS:Dijkstra;
				
		public function Home(params:Object=null)
		{
			super();
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).clearPrev();
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = Text.newText(" ", 32, 0xFFFFFF);
			
			_param = params;
			
			addChild(_field);
			
			this.addEventListener(Event.ADDED_TO_STAGE, function(e:Event):void
			{
				if(_station_array.length == 0)
				{
					var text_loader:URLLoader = new URLLoader();
					text_loader.load(new URLRequest("Station.txt"));
					text_loader.addEventListener(Event.COMPLETE, loaderComplete);
					function loaderComplete(e:Event):void
					{
						var ary:Array = e.target.data.split(/\n/);
						for(var i:int = 0; i < ary.length; i++)
							_station_array[i] = (ary[i] as String).split(/\t/);
						for(i = 0; i < _station_array.length; i++)
							for(var j:int = 0; j < _station_array[i].length; j++)
								if(_station_array[i][j] == -1)
									_station_array[i][j] = MAX;
						calcStation();
						drawStation();
					}
					var txt:TextField = Text.newText("노선도 최적화 진행중...", 50, 0x000000);
					txt.x = Elever.Main.PageWidth/2 - txt.width/2;
					txt.y = 200;
					txt.name = "bg";
					addChild(txt);
				}
				else
				{
					drawStation();
				}
			});
			_station_field.x = Elever.Main.PageWidth/2;
			_station_field.y = CIRCLE_SIZE + 10;
			
			_field.addChild(_station_field);
			
			initDataField();
		}
		private function initDataField():void
		{	
			_field.addChild(_data_field);
			
			//출발 지점
			var txt:TextField = Text.newText("출발지점", TEXT_FONT_SIZE, 0x2c2c2c, 35, TEXTBOX_MARGIN/2);
			_data_field.addChild(txt);
			
			var obj:Object = Text.newInputTextbox(BitmapControl.RESERVE_TEXTBOX, INPUT_TEXT_FONT_SIZE, "", 0x252525, txt.x + txt.width + 50, txt.y - TEXTBOX_MARGIN/2, "left", "NanumBarunGothic");
			(obj.txt as TextField).name = "start";
			if(_param && _param.start)
				(obj.txt as TextField).text = _param.start;
			else
				(obj.txt as TextField).text = "0";
			(obj.txt as TextField).restrict = "0-9";
			(obj.txt as TextField).addEventListener(MouseEvent.CLICK, onClickInputText);
			(obj.txt as TextField).addEventListener(FocusEvent.FOCUS_OUT, onFocusInputText);
			_data_field.addChild(obj.bmp); _data_field.addChild(obj.txt);
			
			//도착 지점
			txt = Text.newText("도착지점", TEXT_FONT_SIZE, 0x2c2c2c, 35, obj.bmp.y + obj.bmp.height + TEXTBOX_MARGIN);
			_data_field.addChild(txt);
			
			obj = Text.newInputTextbox(BitmapControl.RESERVE_TEXTBOX, INPUT_TEXT_FONT_SIZE, "", 0x252525, txt.x + txt.width + 50, txt.y - TEXTBOX_MARGIN/2, "left", "NanumBarunGothic");
			(obj.txt as TextField).name = "finish";
			if(_param && _param.finish != null)
				(obj.txt as TextField).text = _param.finish;
			else
				(obj.txt as TextField).text = "1";
			(obj.txt as TextField).restrict = "0-9";
			(obj.txt as TextField).addEventListener(MouseEvent.CLICK, onClickInputText);
			(obj.txt as TextField).addEventListener(FocusEvent.FOCUS_OUT, onFocusInputText);
			_data_field.addChild(obj.bmp); _data_field.addChild(obj.txt);
			
			//계산 버튼
			var btn:Button = new Button(BitmapControl.CALCULATE_BUTTON, BitmapControl.CALCULATE_BUTTON, onCalculate);
			btn.name = "calculate";
			btn.x = Elever.Main.PageWidth/2 - btn.width/2;
			btn.y = obj.bmp.y + obj.bmp.height + 70;
			_data_field.addChild(btn);
			_data_field.y = 482;
		}
		private function onCalculate(e:MouseEvent):void
		{
			var err_msg:String = "";
			
			if((_data_field.getChildByName("finish") as TextField).text == (_data_field.getChildByName("start") as TextField).text)
				err_msg = "출발지와 도착지를 다르게 해주세요.";
			if((_data_field.getChildByName("finish") as TextField).text.length > _station_count)
				err_msg = "도착지가 존재하지 않습니다.";
			if((_data_field.getChildByName("start") as TextField).text.length > _station_count)
				err_msg = "출발지가 존재하지 않습니다.";
			
			if(int((_data_field.getChildByName("finish") as TextField).text) > _station_array.length-1 || int((_data_field.getChildByName("finish") as TextField).text) < 0)
				err_msg = "도착지가 존재하지 않습니다.";
			if((_data_field.getChildByName("finish") as TextField).text.length == 0)
				err_msg = "도착지를 입력해주세요.";
			if(int((_data_field.getChildByName("start") as TextField).text) > _station_array.length-1 || int((_data_field.getChildByName("start") as TextField).text) < 0)
				err_msg = "출발지가 존재하지 않습니다.";
			if((_data_field.getChildByName("start") as TextField).text.length == 0)
				err_msg = "출발지를 입력해주세요.";
			
			
			if(err_msg != "")
			{
				new Popup(Popup.OK_TYPE, { main_text:err_msg });
				return;
			}
			
			_start = int((_data_field.getChildByName("start") as TextField).text);
			_finish = int((_data_field.getChildByName("finish") as TextField).text);
			
			var date:Date = new Date();
			_result_array = DKS.StartToEnd(_start, _finish);
			
			Elever.Main.changePage("ResultPage", PageEffect.LEFT, 
				{ index_array:_result_array, time:(new Date()).milliseconds - date.milliseconds });
		}
		private function calcStation():void
		{
			DKS = new Dijkstra(_station_array);
			DKS.MakeAllPath();
			DKS.PathComp();
		}
		private function drawStation():void
		{
			if(this.getChildByName("bg"))
				this.removeChild(this.getChildByName("bg"));
			//정점 찍는 작업
			for(var i:Number = 0; i < _station_array.length; i++)
			{
				_station_color[i] = Math.random() * 0xFFFFFF;
				_station_place_x[i] = Math.cos(Math.PI*2 * (i/_station_array.length) + Math.PI)*CIRCLE_SIZE;
				_station_place_y[i] = Math.sin(Math.PI*2 * (i/_station_array.length) + Math.PI)*CIRCLE_SIZE;
				
				var txt:TextField = Text.newText(String(i), 3);
				txt.x = Math.cos(Math.PI*2 * (i/_station_array.length) + Math.PI)*(CIRCLE_SIZE+5) - txt.width/2;
				txt.y = Math.sin(Math.PI*2 * (i/_station_array.length) + Math.PI)*(CIRCLE_SIZE+5) - txt.height/2;
				_station_field.addChild(txt);
				
				_station_field.graphics.lineStyle(0.5,_station_color[i]);
				_station_field.graphics.drawCircle(_station_place_x[i], _station_place_y[i], 1);
			}
			//버텍스 그리는 작업
			for(i = 0; i < DKS.Path.length; i++)
			{
				var pre:int = DKS.Path[i][0]; 
				for(var j:int = 1; j < DKS.Path[i].length; j++)
				{
					var cur:int = DKS.Path[i][j];
					if(cur > MAX)
						break;
					_station_field.graphics.lineStyle(0.1, _station_color[i]);
					_station_field.graphics.moveTo(_station_place_x[pre], _station_place_y[pre]);
					_station_field.graphics.lineTo(_station_place_x[cur], _station_place_y[cur]);
					_station_count++;
					pre = cur;
				}
			}
			
			_station_field.scaleX = 1;
			_station_field.scaleY = 1;
			_data_field.y = _station_field.height + 40;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, move);
			stage.doubleClickEnabled = true;
			stage.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
			trace("역 개수 : "+_station_count);
		}
		private var oldx:Number = 0;
		private var oldy:Number = 0;
		//This will make the Drag
		private function move(e:MouseEvent):void
		{
			if(e.buttonDown)
			{
				_station_field.x += e.stageX-oldx;
				_station_field.y += e.stageY-oldy;
			}
			
			oldx = e.stageX;
			oldy = e.stageY;
		}
		private function onDoubleClick(e:MouseEvent):void
		{
			var scale:int = (_station_field.scaleX == 1) ? 7 : 1;
			if(scale == 1)
			{
				TweenLite.to(_station_field, 0.5, { scaleX:scale, scaleY:scale, x:Elever.Main.PageWidth/2, y:CIRCLE_SIZE+10 });
			}
			else
			{
				TweenLite.to(_station_field, 0.5, { scaleX:scale, scaleY:scale });
			}
		}
		private function onClickInputText(e:MouseEvent):void
		{
			if(e.type == MouseEvent.CLICK)
			{
				anchor(-(e.currentTarget as TextField).y + BASE_Y_INTERVAL - _data_field.y);
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
			TweenLite.to(_field, ANCHOR_TWEEN_DURATION, { y:y });
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