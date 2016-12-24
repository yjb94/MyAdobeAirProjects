package Page.Home
{	
	import flash.display.Bitmap;
	import flash.display.Sprite;
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
	
	public class Home extends BasePage
	{	
		private const DRAG_COEFFICIENT:Number = 15*Config.ratio;
		
		private const TITLE_FONT_SIZE:Number = 27*Config.ratio;
		private const TEXT_FONT_SIZE:Number = 30*Config.ratio;
		private const TIME_TEXT_FONT_SIZE:Number = 24*Config.ratio;
		
		private const ITEM_WIDTH:Number = Config.InsideWidth;
		private const ITEM_STAR_HEIGHT:Number = 50*Config.ratio;
		
		private const ITEM_X_MARGIN:Number = 75*Config.ratio;
		private const ITEM_Y_MARGIN:Number = 30*Config.ratio;
		
		private const TITLE_X_MARGIN:Number = 82*Config.ratio;
		
		private const STAR_MARGIN:Number = 5*Config.ratio;
		
		private var _displays:Scroll;
		
		private var _item_list:Vector.<Sprite> = new Vector.<Sprite>;
		private var _base_item_list:Vector.<Sprite> = new Vector.<Sprite>;
		private var _list_stars:Vector.<Vector.<Sprite>> = new Vector.<Vector.<Sprite>>;
		private var _item_star_box:Vector.<Sprite> = new Vector.<Sprite>;
		private var _item_details:Vector.<Sprite> = new Vector.<Sprite>;
		private var _downPos:Point = new Point;
		
		private static var _title_text:Vector.<String> = new Vector.<String>;
		private static  var _start_time_text:Vector.<String> = new Vector.<String>;
		private static  var _end_time_text:Vector.<String> = new Vector.<String>;
		private static  var _detail_text:Vector.<String> = new Vector.<String>;
		private static  var _rate:Vector.<int> = new Vector.<int>;
		
		private var _check_btn:Button;
		
		public function Home(params:Object=null)
		{
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).clearPrev();
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = Text.newText("", TITLE_FONT_SIZE);
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Right =
				new Button(BitmapControl.newBitmap(BitmapControl.PLUS_BUTTON), BitmapControl.newBitmap(BitmapControl.PLUS_BUTTON), function():void
				{
					Elever.Main.changePage("AddPage");
				});
			
			_check_btn = new Button(BitmapControl.CHECK_BUTTON, BitmapControl.CHECK_BUTTON, function(e:MouseEvent):void
			{
				if(checkGrow())
					Elever.Main.changePage("GrowPage");
			});
			Elever.Main.topLayer.addChild(_check_btn);
		
			_displays = new Scroll();
			addChild(_displays);
			
			_title_text = new Vector.<String>;
			_start_time_text = new Vector.<String>;
			_end_time_text = new Vector.<String>;
			_detail_text = new Vector.<String>;
			_rate = new Vector.<int>;
			
			for(var i:int = 0; i < Elever.ScheduleIndex; i++)//추가해.
			{
				var obj:Object = Elever.loadEnviroment("Schedule/"+i, obj);
				addItem(obj.start_time, obj.end_time, obj.title, obj.detail, obj.rate, i);
			}
			
			if(!Elever.ScheduleIndex)
				addItem("00:00", "24:00", "일정을 입력하세요!", "오늘의 할일들을 입력해 봅시다.", 2, 0);
		}
		private function addItem(start_time:String, end_time:String, title:String, detail:String, rate:int, index:int):void
		{
			//push texts;
			_start_time_text.push(start_time);
			_end_time_text.push(end_time);
			_title_text.push(title);
			_detail_text.push(detail);
			_rate.push(rate);
			
			//main spr;
			var spr:Sprite = new Sprite;
			
			var base_spr:Sprite = new Sprite;
			var bmp:Bitmap = BitmapControl.newBitmap(BitmapControl.SCHEDULE_TEXTFIELD);
			base_spr.x = Elever.Main.PageWidth/2 - bmp.width/2;
			base_spr.y = base_spr.x;
			base_spr.addChild(bmp);
			
			//title
			var txt:TextField = Text.newText(title, TEXT_FONT_SIZE, 0x585858);
			txt.x = TITLE_X_MARGIN;
			txt.y = bmp.height/2 - txt.height/2;
			base_spr.addChild(txt);
			
			//time
			txt = Text.newText(start_time, TIME_TEXT_FONT_SIZE, 0xffffff);
			txt.x = Elever.Main.PageWidth - txt.width - ITEM_X_MARGIN;
			txt.y = 10;
			base_spr.addChild(txt);
			txt = Text.newText("~     ", TIME_TEXT_FONT_SIZE, 0xffffff);
			txt.x = Elever.Main.PageWidth - txt.width - ITEM_X_MARGIN;
			txt.y = bmp.height/2 - txt.height/2;
			base_spr.addChild(txt);
			txt = Text.newText(end_time, TIME_TEXT_FONT_SIZE, 0xffffff);
			txt.x = Elever.Main.PageWidth - txt.width - ITEM_X_MARGIN;
			txt.y = bmp.height - txt.height - 10;
			base_spr.addChild(txt);
			
			//last set
			base_spr.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			
			_base_item_list.push(base_spr);
			
			spr.addChild(base_spr);
			
			//stars
			var star_box:Sprite = new Sprite;
			bmp = BitmapControl.newBitmap(BitmapControl.STAR_BAR);
			star_box.addChild(bmp);
			star_box.y = base_spr.height + base_spr.y;
			star_box.x = Elever.Main.PageWidth - star_box.width - base_spr.x;
			
			var list:Vector.<Sprite> = new Vector.<Sprite>;
			for(var i:int = 0; i < 5; i++)
			{
				var cls:Class = BitmapControl.STAR_COLORED;
				if(i > rate)
					cls = BitmapControl.STAR_BLANK;
				bmp = BitmapControl.newBitmap(cls);
				bmp.x = i*bmp.width + STAR_MARGIN;
				bmp.y = star_box.height/2 - bmp.height/2;
				
				var star:Sprite = new Sprite;
				star.addChild(bmp);
				star.addEventListener(MouseEvent.MOUSE_MOVE, onStarMouseDown);
				star_box.addChild(star);
				list.push(star);
			}
			_list_stars.push(list);
			_item_star_box.push(star_box);
			
			spr.addChild(star_box);
			
			
			//detail text
			var detail_spr:Sprite = new Sprite;
			detail_spr.visible = false;
			
			bmp = BitmapControl.newBitmap(BitmapControl.MEMO_BAR);
			detail_spr.addChild(bmp);
			detail_spr.y = spr.height + base_spr.y;
			detail_spr.x = Elever.Main.PageWidth - detail_spr.width - base_spr.x;
			
			txt = Text.newText(detail, TITLE_FONT_SIZE, 0xeeeeee, 30, 40, "left", "NanumBarunGothic", bmp.width - 30*2, 120, { leading:7 });
			txt.wordWrap = true;
			txt.multiline = true;
			if(txt.height < txt.textHeight)
			{
				txt.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void
				{
					_displays.scroller.doNotScroll = true;
					stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseEvent);
				});
			}
			_displays.addObject(txt);
			
			detail_spr.addChild(txt);
			
			_item_details.push(detail_spr);
			
			
			//total
			_item_list.push(spr);
			spr.y = index*(star_box.height + base_spr.height+ITEM_Y_MARGIN) ;
			_displays.addObject(spr);
		}
		private function onMouseEvent(e:MouseEvent):void
		{
			if(e.type == MouseEvent.MOUSE_DOWN)
			{
				(e.currentTarget as Sprite).addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
				
				_downPos.x = mouseX;
				_downPos.y = mouseY;
			}
			else if(e.type == MouseEvent.MOUSE_UP)
			{
				(e.currentTarget as Sprite).removeEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
				
				if(Point.distance(_downPos, new Point(mouseX, mouseY)) > DRAG_COEFFICIENT)
					return;
				
				//열기
				var index:int = _base_item_list.indexOf(e.currentTarget as Sprite);
				var length:int = _item_details[index].height*((_item_details[index].visible) ? -1 : 1);
				
				//details setting
				_item_details[index].visible = !_item_details[index].visible;
				if(_item_details[index].visible)
					_item_list[index].addChild(_item_details[index]);
				else
					_item_list[index].removeChild(_item_details[index]);
				
				//add stars on end
				_item_details[index].y += _item_star_box[index].height*((_item_details[index].visible) ? -1 : 1);
				_item_star_box[index].y += length;
				for(var i:int = index+1; i < Elever.ScheduleIndex; i++)
				{
					_item_list[i].y += length;
				}
				_displays.onResize();
			}
		}
		private function onStarMouseDown(e:MouseEvent):void
		{
			var top_index:int = _item_star_box.indexOf(e.currentTarget.parent as Sprite);
			var star_index:int = _list_stars[top_index].indexOf(e.currentTarget as Sprite);
			
			_rate[top_index] = star_index;
			
			for(var i:int = 4; i > star_index; i--)
				changeBitmap(BitmapControl.STAR_BLANK, _list_stars[top_index][i], i, top_index, _item_star_box[top_index]);
			
			for(i = star_index; i >= 0; i--)
				changeBitmap(BitmapControl.STAR_COLORED, _list_stars[top_index][i], i, top_index, _item_star_box[top_index]);
		}
		private function changeBitmap(name:Class, spr:Sprite, index:int, top_index:int, box_spr:Sprite):void
		{
			box_spr.removeChild(spr);
			spr.removeEventListener(MouseEvent.MOUSE_MOVE, onStarMouseDown);
			
			var bmp:Bitmap = BitmapControl.newBitmap(name);
			bmp.x = index*bmp.width + STAR_MARGIN;
			bmp.y = box_spr.height/2 - bmp.height/2;
			
			spr = new Sprite;
			spr.addChild(bmp);
			spr.addEventListener(MouseEvent.MOUSE_MOVE, onStarMouseDown);
			box_spr.addChild(spr);
			
			_list_stars[top_index][index] = spr;
		}
		private function onStageMouseEvent(e:MouseEvent):void
		{
			if(e.type == MouseEvent.MOUSE_UP)
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseEvent);
				_displays.scroller.doNotScroll = false;
			}
		}
		public static function getIndexObjData(index:int):Object
		{
			var obj:Object = 
				{
					start_time:_start_time_text[index],
					end_time:_end_time_text[index],
					title:_title_text[index],
					detail:_detail_text[index],
					rate:_rate[index]
				};
			return obj;
		}
		public static function calculateRate():Number
		{
			var lazy:Number = 0;
			for(var i:int = 0; i < _rate.length; i++)
			{
				lazy += AddPage.compareTime(_start_time_text[i], _end_time_text[i]) * (5-_rate[i]) / 5;
			}
			return lazy;
		}
		
		private function checkGrow():Boolean
		{
			var str:String = "";
			if(!Elever.ScheduleIndex)
				str = "스케쥴을 먼저 입력해주세요.";

			
			if(str == "")
				return true;
			else
			{
				NativeAlertDialog.show(str, "알림");
				return false;
			}
		}
		public override function init():void
		{
		}
		public override function onResize():void
		{
		}
		
		public override function dispose():void
		{
			for(var i:int = 0; i < Elever.ScheduleIndex; i++)
			{
				Elever.saveEnviroment("Schedule/"+i, Page.Home.Home.getIndexObjData(i));
			}
			Elever.Main.topLayer.removeChild(_check_btn);
		}
	}
}