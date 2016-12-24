package Page.Main
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.GesturePhase;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.Text;
	
	import Header.NavigationBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	
	import Scroll.Scroll;
	
	public class MainPage extends BasePage
	{
		[Embed(source="fonts/NanumGothicBold.ttf", mimeType = "application/x-font-truetype", fontName="NanumGothicBold", embedAsCFF=false)]
		private static const fontMain:Class;
		
		private static const DAY_HEIGHT:Number = 40;
		
		private var _cur_date:Date = new Date;
		
		private var _dayOfWeek:Sprite;
		private var _display:Scroll;
		
		private var _prev_month:Sprite;
		private var _calendar:Sprite;
		private var _next_month:Sprite;
		
		private var rowHeight:Number;
		private var rowWidth:Number;
		
		private var mode:String = "month";
		
		private var _cur_row:int = -1;
		private var _cur_col:int = -1;
		private var _date_rowcol:Vector.<Vector.<String>> = new Vector.<Vector.<String>>(6);
		
		private var _params:Object;
		
		private var _isDragged:Boolean = false;
		
		public function MainPage(params:Object=null)
		{
			super();
			_params = params;
			addEventListener(Event.ADDED_TO_STAGE, render);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			//display day			
			_dayOfWeek = new Sprite;
			addChild(_dayOfWeek);
			
			const dayOfWeekString:Vector.<String> = Vector.<String>(["SUN","MON","TUE","WED","THU","FRI","SAT"]);
			var rowWidth:Number = Calender.Main.PageWidth/7;
			
			_dayOfWeek.graphics.beginFill(0xd6d6d6);
			for(var i:int = 0;i<7;i++)
			{
				var txt:TextField=new TextField;
				var fmt:TextFormat=txt.defaultTextFormat;
				fmt.font = "NanumGothicBold";
				if(i==0) fmt.color=0xff4242;
				else if(i==6) fmt.color=0x6585f0;
				else fmt.color=0x595959;
				fmt.size = 25;
				txt.defaultTextFormat=fmt;
				txt.autoSize=TextFieldAutoSize.LEFT;
				txt.selectable=false;
				txt.embedFonts=true;
				txt.antiAliasType=AntiAliasType.ADVANCED;
				txt.text=dayOfWeekString[i];
				_dayOfWeek.addChild(txt);
				txt.x=Math.round((rowWidth*i)+rowWidth/2-txt.width/2);
				txt.y = DAY_HEIGHT/2-txt.height/2+2;
				
				if(i>0) _dayOfWeek.graphics.drawRect(Math.round(rowWidth*i),0,1,DAY_HEIGHT+1);
			}
			_dayOfWeek.graphics.drawRect(0,DAY_HEIGHT,Calender.Main.PageWidth,1);
			_dayOfWeek.graphics.endFill();
		}
		
		private var _downPos:Point = new Point;
		private function onMouseDown(e:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			_downPos.x = this.mouseX;
			_downPos.y = this.mouseY;
			
			_isDragged = false;
		}
		private function onMouseMove(e:MouseEvent):void
		{
//			if(mode == "day")
//			{
//				var _curPos:Point = new Point(this.mouseX, this.mouseY);
//				
//				var y_diff:Number = -(_downPos.y - _curPos.y);
//				var x_diff:Number = -(_downPos.x - _curPos.x);
//				
//				this.x += x_diff*this.scaleX;
//				this.y += y_diff*this.scaleY;
//				
//				_downPos.x = this.mouseX;
//				_downPos.y = this.mouseY;
//			}
		}
		private function onMouseUp(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			var _curPos:Point = new Point(this.mouseX, this.mouseY);
//			if(Math.abs(Point.distance(_curPos, _downPos)) < rowHeight)
//				return;
			
			var y_diff:Number = Math.abs(_downPos.y - _curPos.y);
			var x_diff:Number = Math.abs(_downPos.x - _curPos.x);
			var swipe_dir:Boolean = (x_diff < y_diff) ? true : false;
			
			if(mode == "month")
			{
				if(Math.abs(Point.distance(_curPos, _downPos)) < rowHeight)
				return;
				if(swipe_dir)
				{
					if(_downPos.y < _curPos.y)// go prev month
					{
						if(_cur_date.month > 0)
							_cur_date.month--;
					}
					else
					{
						if(_cur_date.month < 11)
							_cur_date.month++;
					}
				}
				else
				{
					if(_downPos.x < _curPos.x)// go prev month
					{
						if(_cur_date.month > 0)
							_cur_date.month--;
					}
					else
					{
						if(_cur_date.month < 11)
							_cur_date.month++;
					}
				}
				render();
			}
			else if(mode == "day")
			{
				if(Math.abs(Point.distance(_curPos, _downPos)) < 15)
					return;
				_isDragged = true;
				if(swipe_dir)
				{
					y_diff = 0;
					if(_downPos.y < _curPos.y)
					{
						if(_cur_row > 0)
							y_diff = rowHeight;
					}
					else
					{
						if(_cur_row < 5)
							y_diff = -rowHeight;
					}
					if(y_diff) _cur_row += (y_diff > 0) ? -1 : 1;
					this.y += y_diff*this.scaleY;
				}
				else
				{
					x_diff = 0;
					if(_downPos.x < _curPos.x)
					{
						if(_cur_col > 0)//->
							x_diff = rowWidth;
					}
					else
					{
						if(_cur_col < 6)//<-
							x_diff = -rowWidth;
					}
					if(x_diff) _cur_col += (x_diff > 0) ? -1 : 1;
					this.x += x_diff*this.scaleX;
				}
				changeTopMonthDate(_date_rowcol[_cur_row][_cur_col].substr(0,2)+"월", _date_rowcol[_cur_row][_cur_col].substr(2,4)+"일");
			}
		}
		private function render(e:Event=null):void
		{
			if(_display)	
			{
				removeChild(_display);
				while(_display.numChildren > 0)
				{
					while((_display.getChildAt(0) as Sprite).numChildren > 0)
						(_display.getChildAt(0) as Sprite).removeChildAt(0);
					_display.removeChildAt(0);
				}
			}
			
			//scroll for calender
			_display = new Scroll();
			addChild(_display);
			
			//display calender
			rowHeight = (Calender.Main.PageHeight-Calender.Main.TopMargin-Calender.Main.HeaderHeight-_dayOfWeek.height)/6;
			rowWidth = Calender.Main.PageWidth/7;
			
			_calendar = new Sprite;
			
			if(_params)
			{
				_cur_date.month = int((_params.md as String).substr(0,2))-1;
				_cur_date.date = int((_params.md as String).substr(2,4));
				_params = null;
			}
			var curdate:Date = new Date(_cur_date.fullYear, _cur_date.month, 1);
			var now:Date = new Date;
			while(curdate.day)	//if not sunday
				curdate.date--;
			
			for(var i:int = 0; i < 6; i++)
			{
				_date_rowcol[i] = new Vector.<String>(7);
				for(var j:int = 0; j < 7; j++)
				{
					var txt:TextField = new TextField;
					var fmt:TextFormat = txt.defaultTextFormat;
					fmt.font = "NanumGothicBold";
					if(j==0) fmt.color=0xff4242;
					else if(j==6) fmt.color=0x6585f0;
					else fmt.color=0x595959;
					if(curdate.month != _cur_date.month)
						fmt.color = 0xafafaf;
					fmt.size = 22;
					txt.defaultTextFormat = fmt;
					txt.autoSize=TextFieldAutoSize.RIGHT;
					txt.antiAliasType = AntiAliasType.ADVANCED;
					txt.embedFonts=true;
					txt.text = curdate.date.toString();
					txt.x = Math.round(rowWidth*j);
					txt.width = rowWidth;
					txt.y = _dayOfWeek.y+_dayOfWeek.height+rowHeight*i;
					
					var month:String = ((curdate.month+1 >= 10) ? "" : "0") + (curdate.month+1).toString();
					var date:String = ((curdate.date >= 10) ? "" : "0") + curdate.date.toString();
					_date_rowcol[i][j] = month+date;
					
					var cal_index:Sprite = new Sprite;
					if(now.fullYear == curdate.fullYear && now.month == curdate.month && now.date == curdate.date)
						cal_index.graphics.beginFill(0xd6d6d6);
					else
						cal_index.graphics.beginFill(0xffffff);
					cal_index.graphics.lineStyle(1,0xd6d6d6);
					cal_index.graphics.drawRect(Math.round(rowWidth*j), _dayOfWeek.y+_dayOfWeek.height+rowHeight*i-1,
						rowWidth+1, rowHeight);
					cal_index.graphics.lineStyle();
					cal_index.graphics.endFill();
					//cal_index.addEventListener(MouseEvent.CLICK, onIndexClick);
					
					cal_index.addChild(txt);
					
					_calendar.addChild(cal_index);
					
					var cur_vec_obj:Vector.<Object> = Calender._cal_data[curdate.month][curdate.date-1];
					var spr:Sprite = new Sprite;
					var sch_spr:Sprite =new Sprite;
					var drawn_sch:int = 0;
					var spr_y: Number = txt.y + txt.height + 3;
					for(var k:int = 0; k < cur_vec_obj.length; k++)
					{
						if(cur_vec_obj[k].type == "term")
						{
							if(cur_vec_obj[k].level >= 7)
								break;
							
							sch_spr =new Sprite;
							
							spr = new Sprite;
							spr.graphics.beginFill(cur_vec_obj[k].color);
							spr.x = Math.round(rowWidth*j)-1;
							spr.y = spr_y + 4*(cur_vec_obj[k].level) + (cur_vec_obj[k].level)*10;
							spr.graphics.drawRect(0, 0, rowWidth+1, 12);
							spr.graphics.endFill();
							spr.name = "sprite";
							sch_spr.addChild(spr);
							
							txt = new TextField;
							fmt = txt.defaultTextFormat;
							fmt.font = "NanumGothicBold";
							fmt.color = 0x000000;
							fmt.align = TextFormatAlign.CENTER
							fmt.size = 10;
							txt.defaultTextFormat = fmt;
							txt.antiAliasType = AntiAliasType.ADVANCED;
							txt.embedFonts = true;
							txt.text = (cur_vec_obj[k].schedule.length > 7) ? (cur_vec_obj[k].schedule).substr(0,6)+"..." : cur_vec_obj[k].schedule;
							//txt.text = cur_vec_obj[k].schedule;
							txt.width = rowWidth;
							txt.x = spr.x;
							txt.y = spr.y - 2;
							txt.name = "text";
							sch_spr.addChild(txt);
							
							txt = new TextField;
							txt.visible = false;
							txt.text = month+date+k;
							txt.name = "mdk";
							sch_spr.addChild(txt);
							
							sch_spr.addEventListener(MouseEvent.CLICK, onScheduleClick);
							_calendar.addChild(sch_spr);
							
							if(cur_vec_obj[k].level >= drawn_sch)
								drawn_sch = cur_vec_obj[k].level+1;
						}
					}
					for(k = 0; k < cur_vec_obj.length; k++)
					{
						if(drawn_sch >= 7)
							break;
						if(cur_vec_obj[k].type == "time")
						{		
							sch_spr =new Sprite;
							
							spr = new Sprite;
							spr.graphics.beginFill(cur_vec_obj[k].color);
							spr.x = Math.round(rowWidth*j) + 5;
							spr.y = spr_y + 4*(drawn_sch) + drawn_sch*10;
							spr.graphics.drawRect(0, 0, 10, 12);
							spr.graphics.endFill();
							spr.name = "sprite";
							sch_spr.addChild(spr);
							
							txt = new TextField;
							fmt = txt.defaultTextFormat;
							fmt.font = "NanumGothicBold";
							fmt.color = 0x000000;
							fmt.size = 10;
							txt.defaultTextFormat = fmt;
							txt.antiAliasType = AntiAliasType.ADVANCED;
							txt.embedFonts = true;
							txt.text = (cur_vec_obj[k].schedule.length > 5) ? (cur_vec_obj[k].schedule).substr(0,4)+"..." : cur_vec_obj[k].schedule;
							txt.x = spr.x + spr.width + 3;
							txt.y = spr.y - 2;
							txt.name = "text";
							sch_spr.addChild(txt);
							
							txt = new TextField;
							txt.visible = false;
							txt.text = month+date+k;
							txt.name = "mdk";
							sch_spr.addChild(txt);
							
							sch_spr.addEventListener(MouseEvent.CLICK, onScheduleClick);
							_calendar.addChild(sch_spr);
							
							drawn_sch++;
						}
					}
					
					curdate.date++;
				}
			}
			_calendar.addEventListener(MouseEvent.CLICK, onIndexClick);
			_display.addChild(_calendar);
			
			//display month
			(Calender.Main.header.getChildAt(0) as NavigationBar).Left = null;
			(Calender.Main.header.getChildAt(0) as NavigationBar).Right = null;
			txt = new TextField;
			fmt = txt.defaultTextFormat;
			fmt.font = "NanumGothicBold";
			fmt.size = 40;
			fmt.color = 0xffffff;
			txt.defaultTextFormat = fmt;
			txt.embedFonts=true;
			txt.text = (_cur_date.fullYear).toString()+"년"+(_cur_date.month+1).toString()+"월";
			txt.autoSize = TextFieldAutoSize.CENTER;
			(Calender.Main.header.getChildAt(0) as NavigationBar).Middle = txt;
		}
		private function onScheduleClick(e:MouseEvent):void
		{
			if(mode == "day")
			{
				if(_isDragged)	return;
				
				var obj:Object = new Object;
				var str:String = ((e.currentTarget as Sprite).getChildByName("mdk") as TextField).text;
				obj.month = str.substr(0,2);
				obj.date = str.substr(2,2);
				obj.md = str.substr(0,4);
				obj.k = str.substr(4,1);
				str = ((e.currentTarget as Sprite).getChildByName("text") as TextField).text;
				obj.schedule = str;
				Calender.Main.changePage("AddPage", PageEffect.NONE, obj);
			}
		}
//		private var _doTween1:Boolean = false;
//		private var _doTween2:Boolean = false;
		private function onIndexClick(e:MouseEvent):void
		{
			if(mode == "day")	return;
			
			_cur_row = int((this.mouseY-_dayOfWeek.height)/rowHeight);
			_cur_col = int(this.mouseX/rowWidth);
			
			var scale_x:Number = Calender.Main.PageWidth/rowWidth;
			var scale_y:Number = (Calender.Main.PageHeight-Calender.Main.TopMargin-Calender.Main.HeaderHeight-_dayOfWeek.height)/rowHeight;
			var x_pos:Number = (int(this.mouseX/rowWidth))*rowWidth;
			var y_pos:Number = (int((this.mouseY-_dayOfWeek.height)/rowHeight))*rowHeight+_dayOfWeek.y+_dayOfWeek.height-1-Calender.Main.TopMargin-Calender.Main.HeaderHeight;
			var scaled_y_pos:Number = ((int(this.mouseY/rowHeight))*rowHeight+_dayOfWeek.y+_dayOfWeek.height-1)*scale_y-Calender.Main.TopMargin-Calender.Main.HeaderHeight;
			scaled_y_pos = (_cur_row)*rowHeight*scale_y + Calender.Main.TopMargin + Calender.Main.HeaderHeight;
			
			this.scaleX = scale_x;
			this.scaleY = scale_y;
			this.x = -x_pos*scale_x;
			this.y = -scaled_y_pos;
			endTween();
//			if(_doTween1)	return;
//			_doTween1 = true;
//			if(_doTween1)
//			{
//				TweenLite.to(this, 1, {scaleX:scale_x, scaleY:scale_y, x:-x_pos*scale_x, y:-scaled_y_pos, onComplete:endTween});
//				_doTween1 = false
//			}
		}
		private function endTween():void
		{
			(Calender.Main.header.getChildAt(0) as NavigationBar).Left = new Button(BitmapControl.PREV_BUTTON, BitmapControl.PREV_BUTTON, prevClicked);
			(Calender.Main.header.getChildAt(0) as NavigationBar).Right = new Button(BitmapControl.PLUS_BUTTON, BitmapControl.PLUS_BUTTON, plusClicked, -20);
			mode = "day";
			changeTopMonthDate(_date_rowcol[_cur_row][_cur_col].substr(0,2)+"월", _date_rowcol[_cur_row][_cur_col].substr(2,4)+"일");
				
//			_doTween1 = false;
//			_doTween2 = false;
		}
		private function plusClicked(e:MouseEvent):void
		{
			Calender.Main.changePage("AddPage", PageEffect.NONE, 
				{ md:_date_rowcol[_cur_row][_cur_col] });
		}
		private function prevClicked(e:MouseEvent):void
		{
			(Calender.Main.header.getChildAt(0) as NavigationBar).Left = null;
			(Calender.Main.header.getChildAt(0) as NavigationBar).Right = null;
			this.scaleX = 1;
			this.scaleY = 1;
			this.x = 0;
			this.y = Calender.Main.TopMargin+Calender.Main.HeaderHeight;
			mode = "month";
			changeTopMonthDate(_cur_date.fullYear.toString()+"년", (_cur_date.month+1).toString()+"월");
//			if(_doTween2) return;
//			_doTween2 = true;
//			if(_doTween2)
//			{
//				TweenLite.to(this, 1, { scaleX:1, scaleY:1, x:0, y:Calender.Main.TopMargin+Calender.Main.HeaderHeight });
//				_doTween2 = false;
//			}
		}
		private function changeTopMonthDate(month:String, date:String):void
		{
			//display month
			var txt:TextField = new TextField;
			var fmt:TextFormat = txt.defaultTextFormat;
			fmt.font = "NanumGothicBold";
			fmt.size = 40;
			fmt.color = 0xffffff;
			txt.defaultTextFormat = fmt;
			txt.embedFonts=true;
			txt.text = month+date;
			txt.autoSize = TextFieldAutoSize.CENTER;
			(Calender.Main.header.getChildAt(0) as NavigationBar).Middle = txt;
		}
		public override function onResize():void
		{
		}
		
		public override function dispose():void
		{
			if(_display)	
			{
				removeChild(_display);
				while(_display.numChildren > 0)
				{
					while((_display.getChildAt(0) as Sprite).numChildren > 0)
						(_display.getChildAt(0) as Sprite).removeChildAt(0);
					_display.removeChildAt(0);
				}
			}
		}
	}
}