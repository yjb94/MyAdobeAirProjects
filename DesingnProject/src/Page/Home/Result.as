package Page.Home
{
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
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
	import Displays.SlideImage;
	import Displays.Text;
	import Displays.WebImage;
	
	import Header.NavigationBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	import Page.Home.Home;
	
	import Scroll.Scroll;
	
	import Utils.Timer;
	
	public class Result extends BasePage
	{
		private const LINE_TWEEN_DURATION:Number = 0.8;
		
		private const TEXT_FONT_SIZE:Number = 23.12;
		
		private var _data_field:Sprite = new Sprite;
		private var _station_field:Sprite = new Sprite;
		
		private var _indexs:Array = new Array;
		private var _station_line:Shape = new Shape;
		private var _timeline:TimelineMax;
		private var _dot:Shape = new Shape;
		
		private var _time:Number;
		
		public function Result(params:Object=null)
		{
			super();
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = Text.newText("결과", 32, 0xFFFFFF);
		
			_indexs = params.index_array;
			_time = params.time/1000;
			
			this.addEventListener(Event.ADDED_TO_STAGE, function(e:Event):void{
				initStationField();
				initDataField();
				animateLine();
			});
		}
		private function initStationField():void
		{
			addChild(_station_field);
			_station_field.x = Elever.Main.PageWidth/2;
			_station_field.y = Home.CIRCLE_SIZE + 10;
			
			//정점 찍는 작업
			for(var i:Number = 0; i < Home._station_array.length; i++)
			{
				Home._station_place_x[i] = Math.cos(Math.PI*2 * (i/Home._station_array.length) + Math.PI)*Home.CIRCLE_SIZE;
				Home._station_place_y[i] = Math.sin(Math.PI*2 * (i/Home._station_array.length) + Math.PI)*Home.CIRCLE_SIZE;
				trace(_station_field.x+Home._station_place_x[i] + "," + _station_field.y+Home._station_place_y[i]);
				
				var txt:TextField = Text.newText(String(i), 3);
				txt.x = Math.cos(Math.PI*2 * (i/Home._station_array.length) + Math.PI)*(Home.CIRCLE_SIZE+5) - txt.width/2;
				txt.y = Math.sin(Math.PI*2 * (i/Home._station_array.length) + Math.PI)*(Home.CIRCLE_SIZE+5) - txt.height/2;
				_station_field.addChild(txt);
				
				_station_field.graphics.lineStyle(0.1, 0x000000);
				_station_field.graphics.drawCircle(Home._station_place_x[i],Home._station_place_y[i], 1);
			}
			
			for(i = 0; i < Home.DKS.Path.length; i++)
			{
				var pre:int = Home.DKS.Path[i][0]; 
				for(var j:int = 1; j < Home.DKS.Path[i].length; j++)
				{
					var cur:int = Home.DKS.Path[i][j];
					if(cur > Home.MAX)
						break;
					_station_field.graphics.lineStyle(0.1, 0x000000);
					_station_field.graphics.moveTo(Home._station_place_x[pre], Home._station_place_y[pre]);
					_station_field.graphics.lineTo(Home._station_place_x[cur], Home._station_place_y[cur]);
					pre = cur;
				}
			}
			
			_station_field.scaleX = 1;
			_station_field.scaleY = 1;
			_data_field.y = _station_field.height + 40;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, move);
			stage.doubleClickEnabled = true;
			stage.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
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
				TweenLite.to(_station_field, 0.5, { scaleX:scale, scaleY:scale, x:Elever.Main.PageWidth/2, y:Home.CIRCLE_SIZE+10 });
			}
			else
			{
				TweenLite.to(_station_field, 0.5, { scaleX:scale, scaleY:scale });
			}
		} 
		private function initDataField():void
		{
			addChild(_data_field);
			_data_field.addChild(Text.newText("지나간 노선", TEXT_FONT_SIZE, 0x2c2c2c, 35));
			var txt:TextField = Text.newText(_indexs.join("-"), TEXT_FONT_SIZE, 0x2c2c2c, 0, 0, "right", "NanumBarunGothic", 300, -1);
			txt.x = Elever.Main.PageWidth - txt.width - 20;
			_data_field.addChild(txt);
			_data_field.addChild(Text.newText("소모시간", TEXT_FONT_SIZE, 0x2c2c2c, 35, txt.height + 35));
			txt = Text.newText(_time+"ms", TEXT_FONT_SIZE, 0x2c2c2c, 35, txt.height + 35);
			txt.x = Elever.Main.PageWidth - txt.width - 20;
			_data_field.addChild(txt);
			
			_data_field.y = Elever.Main.PageHeight/2;
		}
		private function animateLine():void
		{
			//kill existing line
			_station_line.graphics.clear();
			
			//start new line at first point
			_station_line.graphics.lineStyle(2, 0xFF0000, .8);
			_station_line.graphics.moveTo(Home._station_place_x[_indexs[0]], Home._station_place_y[_indexs[0]]);
			
			_dot.x = Home._station_place_x[_indexs[0]];
			_dot.y = Home._station_place_y[_indexs[0]];
			_dot.graphics.beginFill(0xFF0000, .8);
			_dot.graphics.drawCircle(0, 0, 2);
			_dot.graphics.endFill();
			
			_station_field.addChild(_station_line);
			_station_field.addChild(_dot);
			
			_timeline = new TimelineMax({paused:true, onUpdate:drawLine});
			_timeline.appendMultiple(getTweenPointArray(), 0, TweenAlign.SEQUENCE);
			
			_timeline.restart();
		}
		private function getTweenPointArray():Array
		{
			var result:Array = new Array;
			
			//시작위치 한 번 호출해서 딜레이 생성
			for(var i:int = 0; i < _indexs.length; i++)
				result.push(TweenLite.to(_dot, LINE_TWEEN_DURATION, { x:Home._station_place_x[_indexs[i]], y:Home._station_place_y[_indexs[i]]}));
			
			return result;
		}
		private function drawLine():void
		{
			_station_line.graphics.lineTo(_dot.x, _dot.y);
		}
		public override function init():void
		{
			(Elever.Main.header.getChildAt(0) as NavigationBar).previousPage.page_params = { start:_indexs[0], finish:_indexs[_indexs.length-1], index_array:_indexs };
		}
		public override function onResize():void
		{
		}
		
		public override function dispose():void
		{
		}
	}
}