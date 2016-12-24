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
		private const START_Y:Number = 124*Config.ratio;
		private const DRAG_COEFFICIENT:Number = 15*Config.ratio;
		private const TITLE_FONT_SIZE:Number = 45*Config.ratio;
		private const OTHER_FONT_SIZE:Number = 38*Config.ratio;
		
		private const STRANGE_ADD_NUMBER:Number = 37;
		
		private var _displays:Scroll;
		
		private var _bottom_line:Bitmap;
		
		private var _item_list:Vector.<Sprite> = new Vector.<Sprite>;
//		private var _data_list:Array;
		private var _downPos:Point = new Point;
		
		private var _params:Object;
		
		private var _category_name:String;
		
		private var _cur_page:uint = 1;
		private var _total_page:uint;
		
		private var _btn_see_more:Button;
		
		public function Category(params:Object=null)
		{
			super();
			_params = params;
			
			var txt:TextField = Text.newText(params.name, TITLE_FONT_SIZE, 0x585858);
			txt.filters = [new DropShadowFilter()];
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = txt;
			_category_name = txt.text;
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Right = new Button(BitmapControl.RING_BUTTON_UP, BitmapControl.RING_BUTTON_UP, onRingClicked);
			
			_displays = new Scroll(true, -1, -1, -1, params.y, refreshDataList);
			addChild(_displays);
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).addMiddleTouchCallBack(_displays.toTop);
			
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.TOP_LINE, 37*Config.ratio, 63*Config.ratio));
			
			if(_params.cur_page)
				_cur_page = _params.cur_page;
			else
				_cur_page = 1;
			
			_total_page = params.totalpage;
			_btn_see_more = new Button(BitmapControl.SEE_MORE, BitmapControl.SEE_MORE, onSeeMore);
			_btn_see_more.y = _displays.height + STRANGE_ADD_NUMBER;
			_displays.addObject(_btn_see_more);
			
			_bottom_line = BitmapControl.newBitmap(BitmapControl.BOTTOM_LINE, 37*Config.ratio);
			_bottom_line.y = _displays.height + STRANGE_ADD_NUMBER;
			_displays.addObject(_bottom_line);
			
			for(var i:int = 0; i < _cur_page; i++)
				onLoadData(i);
		}
		private function onSeeMore(e:MouseEvent):void
		{
			onLoadData(_cur_page++);
		}
		private function onLoadData(page:int=1):void
		{
			var data:Object = Elever.loadEnviroment(_category_name + "List/page/"+page, data);
			if(data == null)
			{
				var params:URLVariables = new URLVariables;
				params.store_category = Home.CATEGORY_NAME.indexOf(_category_name) + 1;
				params.page = page;
				Elever.Main.LoadingVisible = true;
				Elever.Connection.post("store/list", params, function(data:String):void
				{
					Elever.Main.LoadingVisible = false;
					if(data)
					{
						var result:Object = JSON.parse(data);
						
						if(result)
						{
							Elever.saveEnviroment(_category_name + "List/page/"+page, result.storeInfoList);
							Elever.saveEnviroment(_category_name + "List/totalpage", result.totalpage);
							
							_total_page = result.totalpage;
							var list:Array = result.storeInfoList;
							loadItems(list);
							setItems();
							if(_cur_page < _total_page)
							{
								_btn_see_more.y = _displays.height + STRANGE_ADD_NUMBER;
								_displays.addObject(_btn_see_more);
							}
							else
							{
								if(_btn_see_more.parent == _displays.scroller)
									_displays.scroller.removeChild(_btn_see_more);
							}
							_bottom_line.y = _displays.height + STRANGE_ADD_NUMBER;
							_displays.onResize();
						}
					}
				});
			}
			else
			{
				var list:Array = data as Array;
				loadItems(list);
				setItems();
				if(_cur_page < _total_page)
				{
					_btn_see_more.y = _displays.height + STRANGE_ADD_NUMBER;
					_displays.addObject(_btn_see_more);
				}
				else
				{
					if(_btn_see_more.parent == _displays.scroller)
						_displays.scroller.removeChild(_btn_see_more);
				}
				_bottom_line.y = _displays.height + STRANGE_ADD_NUMBER;
				_displays.onResize();
			}
		}
		private function onRingClicked(e:MouseEvent):void
		{
			Elever.Main.changePage("NoticePage", PageEffect.LEFT, { name:_category_name, totalpage:_total_page, cur_page:_cur_page });
		}
		private function refreshDataList():void
		{
			Elever.Main.LoadingVisible = true;
			
			for(var i:int = 0; i < _cur_page; i++)
			{
				Elever.removeEnviroment(_category_name + "List/page/"+i);
			}
			
			var params:URLVariables = new URLVariables;
			params.store_category = Home.CATEGORY_NAME.indexOf(_category_name) + 1;
			params.page = 0;
			Elever.Connection.post("store/list", params, function(data:String):void
			{
				Elever.Main.LoadingVisible = false;
				if(data)
				{
					var result:Object = JSON.parse(data);
					
					if(result)
					{
						Elever.saveEnviroment(_category_name + "List/page/0", result.storeInfoList);
						Elever.saveEnviroment(_category_name + "List/totalpage", result.totalpage);
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
			
			//item Title Bar
			var title_bar:Bitmap = BitmapControl.newBitmap(BitmapControl.TITLE_BAR[_item_list.length%4], 0, 32*Config.ratio);
			spr.addChild(title_bar);
			
			//item texts
			//매장명
			var txt:TextField = Text.newText(title, OTHER_FONT_SIZE, 0xffffff, 0, 0, "left", "NanumBarunGothic", 0, 0, { bold:true });
			txt.y = title_bar.y + title_bar.height/2 - txt.height/2 - 5*Config.ratio;
			txt.x = title_bar.x + title_bar.width/2 - txt.width/2;
			spr.addChild(txt);
			//타이틀
			txt = Text.newText(name, OTHER_FONT_SIZE, 0xffffff, 55*Config.ratio, 487*Config.ratio);
			//txt.filters = [new DropShadowFilter()];
			spr.addChild(txt);
			//위치
			txt = Text.newText(place, OTHER_FONT_SIZE, 0xffffff, 0, 440*Config.ratio, "right", "NanumBarunGothic", 1044*Config.ratio);
			//txt.width = 1044;
			//txt.filters = [new DropShadowFilter()];
			spr.addChild(txt);
			//설명
			txt = Text.newText(detail, OTHER_FONT_SIZE, 0xffffff, 0, 487*Config.ratio, "right", "NanumBarunGothic", 1044*Config.ratio);
			//txt.filters = [new DropShadowFilter()];
			spr.addChild(txt);
			
			//seperate line
			spr.addChild(BitmapControl.newBitmap(BitmapControl.SEPERATE_LINE, 0, spr.height));
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
								Elever.Main.changePage("ItemInfoPage", PageEffect.LEFT, { name:_params.name, data:result.storeInfoModel, totalpage:_total_page, cur_page:_cur_page });
							}
						}
					});
				}
				else
				{
					Elever.Main.changePage("ItemInfoPage", PageEffect.LEFT, { name:_params.name, data:data, totalpage:_total_page, cur_page:_cur_page });
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
