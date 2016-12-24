package Page.Home
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.net.URLVariables;
	import flash.text.TextField;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.Text;
	import Displays.WebImage;
	
	import Header.NavigationBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	
	import Scroll.Scroll;
	
	public class Category extends BasePage
	{		
		private const START_Y:Number = 0*Config.ratio;
		private const ITEM_Y_MARGIN:Number = 60*Config.ratio;
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
		
		private var _category_name:String;
		
		private var _cur_page:uint = 1;
		private var _list:Array = new Array;
		
		public function Category(params:Object=null)
		{
			super();
			_params = params;
			
			var txt:TextField = Text.newText(params.name, TITLE_FONT_SIZE, 0xffffff);
			txt.filters = [new DropShadowFilter()];
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = txt;
			_category_name = txt.text;
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Right = new Button(BitmapControl.RING_BUTTON_UP, BitmapControl.RING_BUTTON_UP, onRingClicked);
			
			_displays = new Scroll(true, -1, -1, -1, params.y, refreshDataList);
			addChild(_displays);
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).addMiddleTouchCallBack(_displays.toTop);
						
			if(_params.cur_page)
				_cur_page = _params.cur_page;
			else
				_cur_page = 1;
			
			if(params && params.rand_list)
			{
				_list = params.rand_list;
				loadItems(params.rand_list);
				setItems();
				_displays.onResize();
			}
			else
			{
				for(var i:int = 0; i < _cur_page; i++)
					onLoadData(i);
			}
		}
		private function onSeeMore(e:MouseEvent):void
		{
			onLoadData(_cur_page++);
		}
		private function onLoadData(page:int=1):void
		{
			var params:URLVariables = new URLVariables;
			params.store_category = Home.CATEGORY_NAME.indexOf(_category_name) + 1;
			params.page = page;
			Elever.Main.LoadingVisible = true;
			Elever.Connection.post("store/rand_list", params, function(data:String):void
			{
				Elever.Main.LoadingVisible = false;
				if(data)
				{
					var result:Object = JSON.parse(data);
					
					if(result)
					{						
						var list:Array = result.storeInfoList;
						_list = list;
						loadItems(list);
						setItems();
						_displays.onResize();
					}
				}
			});
		}
		private function onRingClicked(e:MouseEvent):void
		{
			Elever.Main.changePage("NoticePage", PageEffect.LEFT, { name:_category_name, cur_page:_cur_page });
		}
		private function refreshDataList():void
		{
			Elever.Main.LoadingVisible = true;
						
			var params:URLVariables = new URLVariables;
			params.store_category = Home.CATEGORY_NAME.indexOf(_category_name) + 1;
			params.page = 0;
			Elever.Connection.post("store/rand_list", params, function(data:String):void
			{
				Elever.Main.LoadingVisible = false;
				if(data)
				{
					var result:Object = JSON.parse(data);
					
					if(result)
					{
						Elever.Main.changePage("CategoryPage", PageEffect.FADE, { name:_category_name, totalpage:result.totalpage, cur_page:_cur_page }, 0.37, true);
					}
				}
			});
		}
		private function loadItems(data_list:Array):void
		{
			for(var i:int = 0; i < data_list.length; i++)
			{
				var cur:Object = data_list[i];
				_displays.addObject(makeItem(cur.store_main_image, cur.store_name, cur.store_division, cur.store_localtitle, cur.store_summary, cur.store_seq));
			}
		}
		private function makeItem(url:String, title:String, name:String, place:String, detail:String, seq:String):Sprite
		{
			var spr:Sprite = new Sprite;
			spr.name = seq;
			
			//item image
			spr.addChild(new WebImage(url, BitmapControl.ITEM_MASK_BG));
			
			//item main bg
			spr.addChild(BitmapControl.newBitmap(BitmapControl.ITEM_BG));
						
			//item texts
			//매장명
			var txt:TextField = Text.newText(title, NAME_FONT_SIZE, 0x000000, 36*Config.ratio, 550*Config.ratio, "left", "NanumBarunGothic", 0, 0, { bold:true });
			spr.addChild(txt);
			//타이틀
			txt = Text.newText(name, OTHER_FONT_SIZE, 0x494949, txt.x, txt.y + 60*Config.ratio);
			spr.addChild(txt);
			//설명
			txt = Text.newText(detail, OTHER_FONT_SIZE, 0x494949, txt.x, txt.y + 45*Config.ratio);
			spr.addChild(txt);
			//위치
			txt = Text.newText(place, OTHER_FONT_SIZE, 0x494949, 0, txt.y, "right", "NanumBarunGothic", 1044*Config.ratio);
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
				_item_list[i].y = _item_list[i-1].y + _item_list[i-1].height + ITEM_Y_MARGIN;
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
				
				var data:Object = Elever.loadEnviroment("item_seq"+(e.currentTarget as Sprite).name, data)
				if(data == null)
				{
					var params:URLVariables = new URLVariables;
					params.store_seq = (e.currentTarget as Sprite).name;
					Elever.Main.LoadingVisible = true;
					Elever.Connection.post("store/j_info", params, function(data:String):void
					{
						Elever.Main.LoadingVisible = false;
						if(data)
						{
							var result:Object = JSON.parse(data);
							
							if(result)
							{
								Elever.saveEnviroment("item_seq"+params.store_seq, result.storeInfoModel);
								Elever.Main.changePage("ItemInfoPage", PageEffect.LEFT, { name:_params.name, data:result.storeInfoModel, cur_page:_cur_page, rand_list:_list });
							}
						}
					});
				}
				else
				{
					Elever.Main.changePage("ItemInfoPage", PageEffect.LEFT, { name:_params.name, data:data, cur_page:_cur_page, rand_list:_list });
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

