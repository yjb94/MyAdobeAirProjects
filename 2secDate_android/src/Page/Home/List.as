package Page.Home
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.net.URLVariables;
	import flash.net.dns.ARecord;
	import flash.text.TextField;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.Text;
	import Displays.WebImage;
	
	import Header.NavigationBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	
	import Scroll.Scroll;
	
	public class List extends BasePage
	{		
		private const START_Y:Number = 0*Config.ratio;
		private const DRAG_COEFFICIENT:Number = 15*Config.ratio;
		private const TITLE_FONT_SIZE:Number = 50*Config.ratio;
		private const OTHER_FONT_SIZE:Number = 36*Config.ratio;
		private const NAME_FONT_SIZE:Number = 45*Config.ratio;
		
		private const STRANGE_ADD_NUMBER:Number = 37;
		private const BOTTOM_LINE_NUMBER:Number = 50;
		
		private var _displays:Scroll;
		
		private var _item_list:Vector.<Sprite> = new Vector.<Sprite>;
		//		private var _data_list:Array;
		private var _downPos:Point = new Point;
		
		private var _params:Object;
		
		private var _list:Array = new Array;
		
		public function List(params:Object=null)
		{
			super();
			
			Elever.Main.LoadingVisible = false;
			if(params == null)
			{
				params = new Object;
				params.y = 0;
			}
			_params = params;
			
			var title:String = "차량선택";
			if(!params.number)
			{
				(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).clearPrev();
				title = "견적보기";
				_displays = new Scroll(true, -1, -1, -1, params.y, refreshDataList);
			}
			else
				_displays = new Scroll(true, -1, -1, -1, params.y);
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = Text.newText(title, TITLE_FONT_SIZE, 0xffffff);
			addChild(_displays);
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).addMiddleTouchCallBack(_displays.toTop);
			
			getCarData();
		}
		private function getCarData():void
		{
			for(var i:int = 0; i < Elever._car_data.length; i++)
			{
				_displays.addObject(makeItem(Elever._car_data[i].image.split("<br>")[0] , Elever._car_data[i].name, Elever._car_data[i].company, Elever._car_data[i].price,  Elever._car_data[i].fuel, i.toString()));
			}
			setItems();
			_displays.onResize();
		}
		private function refreshDataList():void
		{
			Elever.Main.LoadingVisible = true;
			
			var params:URLVariables = new URLVariables;
			Elever.Main.LoadingVisible = true;
			Elever.Connection.post("temp8.jsp", params, function(data:String):void
			{
				Elever.Main.LoadingVisible = false;
				if(data)
				{
					var result:Object = JSON.parse(data);
					
					if(result)
					{
						Elever.saveEnviroment("car_info", result);
						Elever._car_data = new Array;
						for(var i:int = 0; i < result.length; i++)
							Elever._car_data.push(result[i]);
						Elever.Main.changePage("ListPage", PageEffect.FADE, null, 0.37, true);
					}
				}
			});
		}
		private function makeItem(url:String, name:String, company:String, price:String, fuel_efficiency:String, seq:String):Sprite
		{
			var spr:Sprite = new Sprite;
			spr.name = seq;
			
			//item image
			spr.addChild(new WebImage(url, BitmapControl.ITEM_MASK_BG));
			
			//item main bg
			spr.addChild(BitmapControl.newBitmap(BitmapControl.ITEM_BG));
			
			//item texts
			//이름
			var txt:TextField = Text.newText(name, NAME_FONT_SIZE, 0x000000, 36*Config.ratio, 550*Config.ratio, "left", "NanumBarunGothic", 0, 0, { bold:true });
			txt.name = "name";
			spr.addChild(txt);
			//제조사
			txt = Text.newText(company, OTHER_FONT_SIZE, 0x494949, txt.x, txt.y + 60*Config.ratio);
			txt.name = "company";
			spr.addChild(txt);
			//연비
			txt = Text.newText(fuel_efficiency, OTHER_FONT_SIZE, 0x494949, txt.x, txt.y + 45*Config.ratio);
			txt.name = "fuel";
			spr.addChild(txt);
			//가격
			txt = Text.newText(price, OTHER_FONT_SIZE, 0x494949, 0, txt.y, "right", "NanumBarunGothic", 1044*Config.ratio);
			txt.name = "price";
			spr.addChild(txt);
			
			spr.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			
			_item_list.push(spr);
			
			return spr;
		}
		private function setItems():void
		{
			_item_list[0].y = START_Y;
			
			for(var i:int = 1; i < _item_list.length; i++)
			{
				_item_list[i].y = _item_list[i-1].y + _item_list[i-1].height;
			}
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
				
				var item:Sprite = _item_list[Number((e.currentTarget as Sprite).name)];
				
				if((Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).previousPage == null)
				{
					Elever.Main.changePage("DetailPage", PageEffect.LEFT, { seq:item.name });
				}
				else
				{
					//save car data
					if((Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).previousPage.page_params.number == "1")
						Elever._car_save_data[0] = Elever._car_data[Number((e.currentTarget as Sprite).name)];
					else
						Elever._car_save_data[1] = Elever._car_data[Number((e.currentTarget as Sprite).name)];
					
					(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).previousPage.page_params.data_index = item.name;	//나중에 만들 차량 데이터 arraylist 인덱스
					(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).onPrevClick();
				}
			}
		}
		
		public override function init():void
		{
			_displays.scroller.fold((Elever.Main.header.getChildByName("NavigationBar") as NavigationBar), 1);
		}
		public override function onResize():void
		{
		}
		
		public override function dispose():void
		{
			_displays.scroller.resetFoldObj();
		}
	}
}