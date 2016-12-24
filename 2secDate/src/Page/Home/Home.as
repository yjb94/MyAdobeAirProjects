package Page.Home
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLVariables;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.SlideImage;
	import Displays.Text;
	import Displays.WebImage;
	
	import Header.NavigationBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	
	import Scroll.Scroll;

	"main/slide";
	public class Home extends BasePage
	{
		public static const CATEGORY_NAME:Array = ["뭐먹지?", "어디가지?", "뭐하지?"];
		private const DRAG_COEFFICIENT:Number = 15*Config.ratio;
		
		private const BOTTOM_BG_Y:Number = 421 - 67;//config.ratio 곱하지 마
		private const DOT_HEIGHT:Number = 16*Config.ratio;
		private const DOT_MARGIN:Number = 10*Config.ratio;
		private const MENU_BASE_Y:Number = 191*Config.ratio;
		private const ICON_END_Y:Number = 85*Config.ratio;
		private const GRAY_HEIGHT:Number = 418*Config.ratio;
		
		private const FIRST_Y:Number = 844*Config.ratio;
		private const SECOND_Y:Number = 1304*Config.ratio;
		private const THIRD_Y:Number = 1777*Config.ratio;
		private const WIDTH_MARGIN:Number = 36*Config.ratio;
		
		private var _displays:Scroll;
		private var _menu_bar:Sprite;
		private var _downPos:Point = new Point;
		private var _dots:Sprite;
		
		private var _slide_image:SlideImage;
		private var _slide_image_data:Object;
		private var _image_length:int;
		private var _image_index:int = 0;
		
		private var _btn_list:Vector.<Button> = new Vector.<Button>;
		
		public function Home(params:Object=null)
		{
			super();
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).clearPrev();
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = Text.newText("", 0);
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Right = new Button(BitmapControl.RING_BUTTON_UP, BitmapControl.RING_BUTTON_UP, onRingClicked);
		
			
			_slide_image = new SlideImage(null, 1, null, BitmapControl.HOME_SLIDE_TOP_BG);
			Elever.Connection.post("main/slide", new URLVariables, function(data:String):void
			{
				if(data)
				{
					var result:Object = JSON.parse(data);
					
					if(result)
					{
						_slide_image_data = result.mainInfoModel;
						setSlidImage();
						setDots();
						if(params.slide_index)
							_slide_image.setAnchor(params.slide_index as int);
					}
				}
			});
			addChild(_slide_image);
			
			var spr:Sprite = new Sprite;
			spr.graphics.beginFill(0xf48c3f);
			spr.graphics.drawRect(0, _slide_image.height, 640, Elever.Main.FullHeight-_slide_image.height);
			spr.graphics.endFill();
			addChild(spr);
			
			var bmp:Bitmap = BitmapControl.newBitmap(BitmapControl.BOTTOM_BG);
			bmp.y = _slide_image.height - MENU_BASE_Y + BOTTOM_BG_Y;
			addChild(bmp);
			
			_menu_bar = new Sprite;
			_menu_bar.y = _slide_image.height - MENU_BASE_Y;
			addChild(_menu_bar);
			
			_dots = new Sprite;
			_dots.y = _menu_bar.y + MENU_BASE_Y/6*5 - DOT_HEIGHT/2;
			addChild(_dots);
						
			bmp = BitmapControl.newBitmap(BitmapControl.MENU_BG);
			_menu_bar.addChild(bmp);
			
			var btn:Button = new Button(BitmapControl.EAT_UP, BitmapControl.EAT_UP, onButtonDown);
			btn.x = 132*Config.ratio;
			btn.y = GRAY_HEIGHT - ICON_END_Y - btn.height + MENU_BASE_Y;
			btn.name = CATEGORY_NAME[0];
			_menu_bar.addChild(btn);
			_btn_list.push(btn);
			
			btn = new Button(BitmapControl.PLACE_UP, BitmapControl.PLACE_UP, onButtonDown);
			btn.x = 448*Config.ratio;
			btn.y = GRAY_HEIGHT - ICON_END_Y - btn.height + MENU_BASE_Y;
			btn.name = CATEGORY_NAME[1];
			_menu_bar.addChild(btn);
			_btn_list.push(btn);
			
			btn = new Button(BitmapControl.WHAT_UP, BitmapControl.WHAT_UP, onButtonDown);
			btn.x = 801*Config.ratio;
			btn.y = GRAY_HEIGHT - ICON_END_Y - btn.height + MENU_BASE_Y;
			btn.name = CATEGORY_NAME[2];
			_menu_bar.addChild(btn);
			_btn_list.push(btn);
		}
		private function onRingClicked(e:MouseEvent):void
		{
			Elever.Main.changePage("NoticePage", PageEffect.LEFT, { slide_index:_slide_image.Index });
		}
		private function onButtonDown(e:MouseEvent):void
		{
			var btn:Button = e.currentTarget as Button;
			var params:URLVariables = new URLVariables;
			params.store_category = _btn_list.indexOf(btn) + 1;
			params.page = 0;
			Elever.Main.LoadingVisible = true;
			Elever.Connection.post("store/rand_list", params, function(data:String):void
			{
				Elever.Main.LoadingVisible = false;
				if(data)
				{
					var result:Object = JSON.parse(data);
					
					if(result)
					{
						Elever.Main.changePage("CategoryPage", PageEffect.LEFT, { name:btn.name, list:result.storeInfoList, totalpage:result.totalpage, slide_index:_slide_image.Index });	
					}
				}
			});
		}
		private function setDots():void
		{
			for(var i:int = 0; i < _image_length; i++)
			{
				var btn:Button = new Button(BitmapControl.DOT_UNSELECTED, BitmapControl.DOT_SELECTED, null, 0, 0, false, true);
				btn.mouseEnabled = false;
				btn.x = Elever.Main.PageWidth/2 - (_image_length/2-i)*(btn.width + DOT_MARGIN);
				btn.isTabbed = (i==_image_index) ? true : false;
				_dots.addChild(btn);
			}
		}
		private function setSlidImage():void
		{
			var image_str:String = _slide_image_data.main_slide_image as String;
			var image_ary:Array = image_str.split("<br>");
			_image_length = image_ary.length;
			for(var i:int = 0; i < image_ary.length; i++)
			{
				_slide_image.addItem(new WebImage(image_ary[i], BitmapControl.SLIDE_IMAGE_BG), function(index:int):void
				{
					(_dots.getChildAt(_image_index) as Button).isTabbed = false;
					(_dots.getChildAt(index) as Button).isTabbed = true;
					_image_index = index;
				});
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
								Elever.Main.changePage("ItemInfoPage", PageEffect.LEFT, { data:result.storeInfoModel, slide_index:_slide_image.Index });
							}
						}
					});
				}
				else
				{
					Elever.Main.changePage("ItemInfoPage", PageEffect.LEFT, { data:data, slide_index:_slide_image.Index });
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