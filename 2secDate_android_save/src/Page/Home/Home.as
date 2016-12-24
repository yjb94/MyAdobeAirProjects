package Page.Home
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLVariables;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.SlideImage;
	import Displays.WebImage;
	
	import Header.NavigationBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	
	import Scroll.Scroll;
	
	"main/slide";
	public class Home extends BasePage
	{
		public static const CATEGORY_NAME:Array = ["뭐먹지?", "어디가지?", "뭐하지?", "감상하기", "놀기", "기타"];
		private const DRAG_COEFFICIENT:Number = 15*Config.ratio;
		
		private const FIRST_Y:Number = 844*Config.ratio;
		private const SECOND_Y:Number = 1304*Config.ratio;
		private const THIRD_Y:Number = 1777*Config.ratio;
		private const WIDTH_MARGIN:Number = 36*Config.ratio;
		
		private var _displays:Scroll;
		private var _downPos:Point = new Point;
		
		private var _slide_image:SlideImage;
		private var _slide_image_data:Object;
		
		private var _btn_list:Vector.<Button> = new Vector.<Button>;
		
		
		public function Home(params:Object=null)
		{
			super();
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).clearPrev();
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = BitmapControl.newBitmap(BitmapControl.ELEVER_LOGO);
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Right = new Button(BitmapControl.RING_BUTTON_UP, BitmapControl.RING_BUTTON_UP, onRingClicked);
			
			_displays = new Scroll();
			addChild(_displays);
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).addMiddleTouchCallBack(_displays.toTop);
			
			_slide_image = new SlideImage(null, 1, _displays, BitmapControl.SLIDE_IMAGE_TOP);
			_slide_image_data = Elever.loadEnviroment("main/slide", _slide_image_data);
			if(_slide_image_data == null)
			{
				var param:URLVariables = new URLVariables;
				Elever.Main.LoadingVisible = true;
				Elever.Connection.post("main/slide", param, function(data:String):void
				{
					Elever.Main.LoadingVisible = false;
					if(data)
					{
						var result:Object = JSON.parse(data);
						
						if(result)
						{
							_slide_image_data = result.mainInfoModel;
							Elever.saveEnviroment("main/slide", result.mainInfoModel);
							setSlidImage();
						}
					}
				});
			}
			else
				setSlidImage();
			_displays.addObject(_slide_image);
			
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.HOME_MAIN_BG, 0, _displays.height));
			
			var btn:Button = new Button(BitmapControl.MAKE_UP, BitmapControl.MAKE_DOWN, onButtonDown);
			btn.x = Elever.Main.PageWidth/2 - btn.width - WIDTH_MARGIN;
			btn.y = FIRST_Y - Elever.Main.HeaderHeight;
			btn.name = CATEGORY_NAME[0];
			_displays.addObject(btn);
			_btn_list.push(btn);
			
			btn = new Button(BitmapControl.LEARN_UP, BitmapControl.LEARN_DOWN, onButtonDown);
			btn.x = Elever.Main.PageWidth/2 + WIDTH_MARGIN;
			btn.y = FIRST_Y - Elever.Main.HeaderHeight;
			btn.name = CATEGORY_NAME[1];
			_displays.addObject(btn);
			_btn_list.push(btn);
			
			btn = new Button(BitmapControl.HEAL_UP, BitmapControl.HEAL_DOWN, onButtonDown);
			btn.x = Elever.Main.PageWidth/2 - btn.width - WIDTH_MARGIN;
			btn.y = SECOND_Y - Elever.Main.HeaderHeight;
			btn.name = CATEGORY_NAME[2];
			_displays.addObject(btn);
			_btn_list.push(btn);
			
			btn = new Button(BitmapControl.SEE_UP, BitmapControl.SEE_DOWN, onButtonDown);
			btn.x = Elever.Main.PageWidth/2 + WIDTH_MARGIN;
			btn.y = SECOND_Y - Elever.Main.HeaderHeight;
			btn.name = CATEGORY_NAME[3];
			_displays.addObject(btn);
			_btn_list.push(btn);
			
			btn = new Button(BitmapControl.PLAY_UP, BitmapControl.PLAY_DOWN, onButtonDown);
			btn.x = Elever.Main.PageWidth/2 - btn.width - WIDTH_MARGIN;
			btn.y = THIRD_Y - Elever.Main.HeaderHeight;
			btn.name = CATEGORY_NAME[4];
			_displays.addObject(btn);
			_btn_list.push(btn);
			
			btn = new Button(BitmapControl.ETC_UP, BitmapControl.ETC_DOWN, onButtonDown);
			btn.x = Elever.Main.PageWidth/2 + WIDTH_MARGIN;
			btn.y = THIRD_Y - Elever.Main.HeaderHeight;
			btn.name = CATEGORY_NAME[5];
			_displays.addObject(btn);
			_btn_list.push(btn);
		}
		private function onRingClicked(e:MouseEvent):void
		{
			Elever.Main.changePage("NoticePage");
		}
		private function onButtonDown(e:MouseEvent):void
		{
			var btn:Button = e.currentTarget as Button;
			var data:Object = Elever.loadEnviroment(btn.name + "List/page/0", data)
			if(data == null)
			{
				var params:URLVariables = new URLVariables;
				params.store_category = _btn_list.indexOf(btn) + 1;
				params.page = 0;
				Elever.Main.LoadingVisible = true;
				Elever.Connection.post("store/list", params, function(data:String):void
				{
					Elever.Main.LoadingVisible = false;
					if(data)
					{
						var result:Object = JSON.parse(data);
						
						if(result)
						{
							Elever.saveEnviroment(btn.name + "List/page/0", result.storeInfoList);
							Elever.saveEnviroment(btn.name + "List/totalpage", result.totalpage);
							Elever.Main.changePage("CategoryPage", PageEffect.LEFT, { name:btn.name, list:result.storeInfoList, totalpage:result.totalpage });	
						}
					}
				});
			}
			else
			{
				Elever.Main.changePage("CategoryPage", PageEffect.LEFT, { name:btn.name, list:data, totalpage:Elever.loadEnviroment(btn.name + "List/totalpage", null) });
			}
		}
		private function setSlidImage():void
		{
			var image_str:String = _slide_image_data.main_slide_image as String;
			var image_ary:Array = image_str.split("<br>");
			for(var i:int = 0; i < image_ary.length; i++)
			{
				_slide_image.addItem(new WebImage(image_ary[i], BitmapControl.SLIDE_IMAGE_BG), null);
			}
			_slide_image.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
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
				
				var link_str:String = _slide_image_data.main_slide_link as String;
				var link_ary:Array = link_str.split("<br>");
				
				if(link_ary[_slide_image.Index] == "" || isNaN(link_ary[_slide_image.Index])) return;
				
				var data:Object = Elever.loadEnviroment("item_seq"+link_ary[_slide_image.Index], data);
				if(data == null)
				{
					var params:URLVariables = new URLVariables;
					params.store_seq = link_ary[_slide_image.Index];
					Elever.Main.LoadingVisible = true;
					Elever.Connection.post("store/j_info", params, function(data:String):void
					{
						Elever.Main.LoadingVisible = false;
						if(data)
						{
							var result:Object = JSON.parse(data);
							
							if(result)
							{
								Elever.saveEnviroment("item_seq"+link_ary[_slide_image.Index], result.storeInfoModel);
								Elever.Main.changePage("ItemInfoPage", PageEffect.LEFT, { data:result.storeInfoModel });
							}
						}
					});
				}
				else
				{
					Elever.Main.changePage("ItemInfoPage", PageEffect.LEFT, { data:data });
				}
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
		}
	}
}

