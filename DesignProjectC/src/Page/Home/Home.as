package Page.Home
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.text.TextField;
	
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
	
	import Utils.Timer;
	import Utils.Dijkstra;

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
		private var _station_field:Shape = new Shape;
		
		private var _start:int = -1;
		private var _finish:int = -1;
		
		private var _data_field:Sprite = new Sprite;
		
		public function Home(params:Object=null)
		{
			super();
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).clearPrev();
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = Text.newText(" ", 32, 0xFFFFFF);
			
			_param = params;
			
			addChild(_field);
			
			var text_loader:URLLoader = new URLLoader();
			text_loader.load(new URLRequest("Station2.txt"));
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
				drawStation();
			}
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
			
			if((_data_field.getChildByName("finish") as TextField).text.length == 0)
				err_msg = "도착지를 입력해주세요.";
			if((_data_field.getChildByName("start") as TextField).text.length == 0)
				err_msg = "출발지를 입력해주세요.";
			
			
			if(err_msg != "")
			{
				new Popup(Popup.OK_TYPE, { main_text:err_msg });
				return;
			}

			_start = int((_data_field.getChildByName("start") as TextField).text);
			_finish = int((_data_field.getChildByName("finish") as TextField).text);
			
			Dijkstra();
			for(var i:int = 0; i < _station_array.length; i++)
				trace("i = " + i +", sht= " + _sht[i] + ", pre = "+ _pre[i]);
			Elever.Main.changePage("ResultPage", PageEffect.LEFT, 
				{ index_array:[_start, 1, 7, 5, 8, 3, 11, 10, 2, 4, 6, 9, 0]});
		}
		private function Dijkstra():void
		{
			for(i=0; i < _station_array.length; i++)
			{
				if(i == _start)
				{
					_sht[i] = 0;
					_state[i] = 1;
					_pre[i] = 0;
				}
				else
				{
					_sht[i] = MAX;
					_state[i] = 0;
					_pre[i] = MAX;
				}
			}
			
			var i:int, j:int, min:int, tmp:int, k:int;
			
			for(k = _start, i = _start; k < _start + _station_array.length; k++)
			{ 
				//k는 단순히 정점의수(6)만큼 반복문을 실행하기 위한 변수.
				min = MAX; 
				//min은 다음 턴에 선택할 노드의 잠정적인 거리값중 최소값을 저장할 변수.
				
				for(j = 0; j < _station_array.length; j++)
				{
					if(i != j)
					{
						if(_state[j] == 0 && _station_array[i][j] < MAX)
						{ 
							//미방문 상태이고 i와 인접하고 있는 노드 선택.
							if(int(_sht[j]) > int(_sht[i]) + int(_station_array[i][j]))
							{ 
								// 알고리즘 분석의 3-1번과정 
								_sht[j] = int(_sht[i]) + int(_station_array[i][j]);
								_pre[j] = i;  
								//노드 j의 거리 값과 pre값을 갱신
								
								if(int(_sht[j]) < min)
								{
									tmp = j; 
									//tmp는 최소값을 가지는 노드의 번호를 임시 저장하는 변수.
									min = int(_sht[j]);
								}
							}
							else
							{ // 3-2번 과정  
								if(int(_sht[j]) < min)
								{ 
									tmp = j;
									min = int(_sht[j]);
								}
							}
						}
					}
					else // 자기 자신과의 비교는 패스.
						continue;
				}
				_state[tmp] = 1; //최소값을 가지는 노드를 방문상태로 바꾼다.
				i = tmp; // 최종적으로 최소값을 가지는 노드 번호를 i에 저장한다.  
			}
		}
		private function drawStation():void
		{
			//정점 찍는 작업
			for(var i:Number = 0; i < _station_array.length; i++)
			{
				_station_color[i] = Math.random() * 0xFFFFFF;
				_station_place_x[i] = Math.cos(Math.PI*2 * (i/_station_array.length) + Math.PI)*CIRCLE_SIZE;
				_station_place_y[i] = Math.sin(Math.PI*2 * (i/_station_array.length) + Math.PI)*CIRCLE_SIZE;
				trace(_station_field.x+_station_place_x[i] + "," + _station_field.y+_station_place_y[i]);
				
				_station_field.graphics.lineStyle(1,_station_color[i]);
				_station_field.graphics.drawCircle(_station_place_x[i], _station_place_y[i], 1);
			}
			
			//버텍스 그리는 작업
			for(i = 0; i < _station_array.length; i++)
			{
				for(var j:int = i+1; j < _station_array[i].length; j++)
				{
					var cur:String = _station_array[i][j];
					if(cur != MAX && cur != "0")
					{
						_station_field.graphics.lineStyle(1,_station_color[i]);
						_station_field.graphics.moveTo(_station_place_x[i], _station_place_y[i]);
						_station_field.graphics.lineTo(_station_place_x[j], _station_place_y[j]);
						_station_count++;
					}
				}
			}
			trace(_station_count);
			_data_field.y = _station_field.height + 40;
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