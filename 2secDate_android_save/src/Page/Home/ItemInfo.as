package Page.Home
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.SlideImage;
	import Displays.Text;
	import Displays.WebImage;
	
	import Header.NavigationBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	
	import Scroll.Scroll;
	
	public class ItemInfo extends BasePage
	{
		
		private const ICONS_MARGIN:Number = 32*Config.ratio;
		private const TEXTBOX_X_MARGIN:Number = 25*Config.ratio;
		private const TEXTBOX_Y_MARGIN:Number = 37*Config.ratio;
		private const TWEEN_DURATION:Number = 0.3;
		
		private const TITLE_FONT_SIZE:Number = 45*Config.ratio;
		private const ITEM_FONT_SIZE:Number = 38*Config.ratio;
		private const ITEM_NAME_FONT_SIZE:Number = 42*Config.ratio;
		private const DETAIL_FONT_SIZE:Number = 35*Config.ratio;
		private const DOT_FONT_SIZE:Number = 32*Config.ratio;
		
		private const POPUP_WIDTH:Number = 962*Config.ratio;
		private const POPUP_HEIGHT:Number = 1193*Config.ratio;
		private const BASE_POPUP_Y:Number = 178*Config.ratio;
		private const POPUP_TEXT_MARGIN:Number = 137*Config.ratio;
		
		private var _displays:Scroll;
		
		private var _bottom_line:Bitmap;
		
		private var _slide_image:SlideImage;
		public function get isZoomed():Boolean { return _slide_image.isZoomed(); }
		public function zoomOut():void { _slide_image.zoomOut(); }
		
		private var _date_popup:Sprite;
		private var _date_popup_bg:Sprite;
		
		private var _item_data:Object;
		
		private var _date_arr:Array;
		
		public function ItemInfo(params:Object=null)
		{
			super();
						
			getItemData(params.data);
			var txt:TextField = Text.newText(_item_data.store_name , TITLE_FONT_SIZE, 0x585858);
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = txt;
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Right = new Button(BitmapControl.RING_BUTTON_UP, BitmapControl.RING_BUTTON_UP, onRingClicked);
			
			_displays = new Scroll();
			addChild(_displays);
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).addMiddleTouchCallBack(_displays.toTop);
			
			var bmp:Bitmap = BitmapControl.newBitmap(BitmapControl.TOP_LINE, 37*Config.ratio, 63*Config.ratio);
			_displays.addObject(bmp);
			
			//temp code
			_slide_image = new SlideImage(null, 1, _displays, BitmapControl.SLIDE_IMAGE_TOP, true);
			_slide_image.y = 124*Config.ratio;
			var str:String = _item_data.store_slide_image as String;
			var ary:Array = str.split("<br>");
			for(var i:int = 0; i < ary.length; i++)
				_slide_image.addItem(new WebImage(ary[i], BitmapControl.SLIDE_IMAGE_BG), null);
			_displays.addObject(_slide_image);
			
			bmp = BitmapControl.newBitmap(BitmapControl.ITEM_NAME_BG, 24*Config.ratio, _slide_image.y + _slide_image.height + 54*Config.ratio);
			bmp.name = "item_name_bg";
			_displays.addObject(bmp);
			
			bmp = BitmapControl.newBitmap(BitmapControl.DOTS, bmp.x + bmp.width, _slide_image.y + _slide_image.height + 159*Config.ratio);
			bmp.name = "dots";
			_displays.addObject(bmp);
			
			bmp = BitmapControl.newBitmap(BitmapControl.TRIANGLE, 119*Config.ratio, bmp.y + bmp.height + 161*Config.ratio);
			bmp.name = "triangle";
			_displays.addObject(bmp);
			
			bmp = BitmapControl.newBitmap(BitmapControl.WORK_HOUR, 102*Config.ratio, bmp.y + bmp.height + 107*Config.ratio);
			bmp.name = "work_hour";
			_displays.addObject(bmp);
			
			switch(int(_item_data.store_reservation))
			{
				case 1: bmp = BitmapControl.newBitmap(BitmapControl.RESERVE_OK, bmp.x, bmp.y + bmp.height + ICONS_MARGIN); break;			//가능
				case 2: bmp = BitmapControl.newBitmap(BitmapControl.RESERVE_CANNOT, bmp.x, bmp.y + bmp.height + ICONS_MARGIN); break;		//불가
				case 3: bmp = BitmapControl.newBitmap(BitmapControl.RESERVE_RECOMMEND, bmp.x, bmp.y + bmp.height + ICONS_MARGIN); break;	//필수(아직이미지없음)
				default: bmp = BitmapControl.newBitmap(BitmapControl.RESERVE_RECOMMEND, bmp.x, bmp.y + bmp.height + ICONS_MARGIN); break;	//권장
			}
			bmp.name = "reserve";
			_displays.addObject(bmp);
			
			bmp = BitmapControl.newBitmap(BitmapControl.CALL, bmp.x, bmp.y + bmp.height + ICONS_MARGIN);
			bmp.name = "call";
			_displays.addObject(bmp);
			
			bmp = BitmapControl.newBitmap(BitmapControl.MONEY, bmp.x, bmp.y + bmp.height + ICONS_MARGIN);
			bmp.name = "money";
			_displays.addObject(bmp);
			
			bmp = BitmapControl.newBitmap(BitmapControl.REPORT, bmp.x, bmp.y + bmp.height + ICONS_MARGIN);
			bmp.name = "report";
			_displays.addObject(bmp);
			
			bmp = _displays.scroller.getChildByName("work_hour") as Bitmap;
			var btn:Button = new Button(BitmapControl.BUTTON_SEE_MORE, BitmapControl.BUTTON_SEE_MORE, onSeeMore,
				bmp.x + bmp.width + 590*Config.ratio);
			btn.y = bmp.y + bmp.height/2 - btn.height/2;
			btn.name = "see_more";
			_displays.addObject(btn);
			
			if(_item_data.store_reservation != 2)		//예약 불가 아닐 때
			{
				bmp = _displays.scroller.getChildByName("reserve") as Bitmap;
				btn = new Button(BitmapControl.BUTTON_RESERVE, BitmapControl.BUTTON_RESERVE, onReservation);
				btn.x = bmp.x + bmp.width + 590*Config.ratio;
				btn.y = bmp.y + bmp.height/2 - btn.height/2;
				_displays.addObject(btn);
			}
			
			bmp = _displays.scroller.getChildByName("call") as Bitmap;
			btn = new Button(BitmapControl.BUTTON_CALL, BitmapControl.BUTTON_CALL, onCall);
			btn.x = bmp.x + bmp.width + 590*Config.ratio;
			btn.y = bmp.y + bmp.height/2 - btn.height/2;
			_displays.addObject(btn);
			
			bmp = _displays.scroller.getChildByName("report") as Bitmap;
			bmp = BitmapControl.newBitmap(BitmapControl.TEXTBOX, bmp.x + bmp.width + 41*Config.ratio, bmp.y + 25*Config.ratio);
			bmp.name = "textbox";
			_displays.addObject(bmp);
			
			_bottom_line = BitmapControl.newBitmap(BitmapControl.BOTTOM_LINE, 37*Config.ratio, bmp.y + bmp.height + 60*Config.ratio);
			_displays.addObject(_bottom_line);
			
			initPopup();
			setText();
		}
		private function onRingClicked(e:MouseEvent):void
		{
			Elever.Main.changePage("NoticePage", PageEffect.LEFT, { data:_item_data });
		}
		private function getItemData(params:Object):void
		{
			_item_data = Elever.loadEnviroment("item_seq"+params.store_seq, _item_data) as Array;
			if(_item_data == null)
			{
				_item_data = params;
				Elever.saveEnviroment("item_seq"+params.store_seq, _item_data);
			}
		}
		private function initPopup():void
		{
			var btn:Button = _displays.scroller.getChildByName("see_more") as Button;
			var bg:Bitmap = BitmapControl.newBitmap(BitmapControl.DATE_POPUP_BG);
			bg.name = "bg";
			var main:Bitmap = BitmapControl.newBitmap(BitmapControl.DATE_POPUP);
			main.name = "main";
			
			_date_popup = new Sprite;
			_date_popup.addChild(main);
			_date_popup.x = btn.x;
			_date_popup.y = btn.y;
			_date_popup.alpha = 0;
			_date_popup.scaleX = 0;
			_date_popup.scaleY = 0;
			
			_date_arr = String(_item_data.store_time).split("/");
			for(var i:int = 1; i < _date_arr.length; i++)
			{
				var txt:TextField = Text.newText("", ITEM_FONT_SIZE, 0x737373, 205*Config.ratio, BASE_POPUP_Y + (i-1)*POPUP_TEXT_MARGIN, "center", "NanumBarunGothic", 680*Config.ratio);
				txt.text = _date_arr[i];
				_date_popup.addChild(txt);
			}
			txt = Text.newText("", ITEM_FONT_SIZE, 0x737373, 205*Config.ratio, BASE_POPUP_Y + 6*POPUP_TEXT_MARGIN, "center", "NanumBarunGothic", 680*Config.ratio);
			txt.text = _date_arr[0];
			_date_popup.addChild(txt);
			
			_date_popup_bg = new Sprite;
			_date_popup_bg.addChild(bg);
			_date_popup_bg.alpha = 0;
		}
		private function setText():void
		{
			var bmp:Bitmap = _displays.scroller.getChildByName("item_name_bg") as Bitmap;
			var txt:TextField = Text.newText(_item_data.store_name, ITEM_NAME_FONT_SIZE, 0xffffff, bmp.x, bmp.y + 35*Config.ratio, "center", "NanumBarunGothic", bmp.width, 0, { bold:true });
			_displays.addObject(txt);
			
			bmp = _displays.scroller.getChildByName("dots") as Bitmap;
			txt = Text.newText(_item_data.store_division, DOT_FONT_SIZE, 0x58595b, bmp.x + bmp.width, 0, "right", "NanumBarunGothic", 208*Config.ratio, 0, { bold:true });
			txt.y = bmp.y + bmp.height/2 - txt.height/2;
			_displays.addObject(txt);
		
			bmp = _displays.scroller.getChildByName("triangle") as Bitmap;
			txt = Text.newText(_item_data.store_summary, ITEM_FONT_SIZE, 0x737373, bmp.x + 35*Config.ratio, 0, "left", "NanumBarunGothic");
			txt.y = bmp.y + bmp.height/2 - txt.height/2;
			_displays.addObject(txt);
			
			var date:Date = new Date;
			bmp = _displays.scroller.getChildByName("work_hour") as Bitmap;
			txt = Text.newText(_date_arr[date.day], ITEM_FONT_SIZE, 0x737373, bmp.x + bmp.width + 41*Config.ratio, 0, "left", "NanumBarunGothic");
			txt.y = bmp.y + bmp.height/2 - txt.height/2;
			_displays.addObject(txt);
			
			var reserve_str:String;
			switch(int(_item_data.store_reservation))
			{
				case 0: reserve_str = "예약 권장"; break;	//권장
				case 1: reserve_str = "예약 가능"; break;	//가능
				case 2: reserve_str = "예약 불가"; break;	//불가
				case 3: reserve_str = "예약 필수"; break;	//필수(아직이미지없음)
			}
			bmp = _displays.scroller.getChildByName("reserve") as Bitmap;
			txt = Text.newText(reserve_str, ITEM_FONT_SIZE, 0x737373, bmp.x + bmp.width + 41*Config.ratio, 0, "left", "NanumBarunGothic");
			txt.y = bmp.y + bmp.height/2 - txt.height/2;
			_displays.addObject(txt);
			
			bmp = _displays.scroller.getChildByName("call") as Bitmap;
			txt = Text.newText(_item_data.store_number, ITEM_FONT_SIZE, 0x737373, bmp.x + bmp.width + 41*Config.ratio, 0, "left", "NanumBarunGothic");
			txt.y = bmp.y + bmp.height/2 - txt.height/2;
			txt.name = "call_text";
			_displays.addObject(txt);
			
			bmp = _displays.scroller.getChildByName("money") as Bitmap;
			txt = Text.newText(_item_data.store_price, ITEM_FONT_SIZE, 0x737373, bmp.x + bmp.width + 41*Config.ratio, 0, "left", "NanumBarunGothic");
			txt.y = bmp.y + bmp.height/2 - txt.height/2;
			_displays.addObject(txt);
			
			bmp = _displays.scroller.getChildByName("textbox") as Bitmap;
			txt = Text.newText(_item_data.store_description, DETAIL_FONT_SIZE, 0x737373,
				bmp.x + TEXTBOX_X_MARGIN, bmp.y + TEXTBOX_Y_MARGIN, "left", "NanumBarunGothic", bmp.width - TEXTBOX_X_MARGIN*2, bmp.height-TEXTBOX_Y_MARGIN,
				{ leading:25*Config.ratio });
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
		}
		private var _popup_opened:Boolean = false;
		public function get isPopupOpend():Boolean { return _popup_opened; }
		private function onSeeMore(e:MouseEvent):void
		{
			_displays.scroller.doNotScroll = true;
			_popup_opened = true;
			addChild(_date_popup_bg);
			addChild(_date_popup);
			
			_date_popup.addEventListener(MouseEvent.CLICK, removePopup);
			_date_popup_bg.addEventListener(MouseEvent.CLICK, removePopup);
			
			TweenLite.to(_date_popup, TWEEN_DURATION, { x:_date_popup_bg.width/2-POPUP_WIDTH/2, y:_date_popup_bg.height/2-POPUP_HEIGHT/2-Elever.Main.HeaderHeight, alpha:1, scaleX:1, scaleY:1 });
			TweenLite.to(_date_popup_bg, TWEEN_DURATION, { alpha:1 });
		}
		public function removePopup(e:MouseEvent):void
		{
			var btn:Button = _displays.scroller.getChildByName("see_more") as Button;
			TweenLite.to(_date_popup, TWEEN_DURATION, { x:btn.x, y:btn.y+_displays.scroller.y, alpha:0, scaleX:0, scaleY:0, onComplete:function():void
			{
				_displays.scroller.doNotScroll = false;
				_popup_opened = false;
				removeChild(_date_popup);
				removeChild(_date_popup_bg);
			}});
			TweenLite.to(_date_popup_bg, TWEEN_DURATION, { alpha:0 });
		}
		private function onCall(e:MouseEvent):void
		{
			var params:URLVariables = new URLVariables;
			params.store_seq = _item_data.store_seq;
			Elever.Connection.post("store_call_count", params, function(data:String):void
			{
			});
			const callURL:String="tel:"+((_displays.scroller.getChildByName("call_text") as TextField).text.split("-;").join(""));
			navigateToURL(new URLRequest(callURL));
		}
		private function onReservation(e:MouseEvent):void
		{
			var data:Object = Elever.loadEnviroment("store_seq/program_yn"+_item_data.store_seq, data);
			if(data == null)
			{
				var params:URLVariables = new URLVariables;
				params.store_seq = _item_data.store_seq;
				Elever.Main.LoadingVisible = true;
				Elever.Connection.post("rsv/register", params, function(data:String):void
				{
					Elever.Main.LoadingVisible = false;
					if(data)
					{
						var result:Object = JSON.parse(data);
						
						if(result)
						{
							Elever.saveEnviroment("store_seq/program_yn"+_item_data.store_seq, result.program_yn);
							Elever.Main.changePage("ReserveMainPage", PageEffect.LEFT, { data:_item_data, program_yn:result.program_yn, store_seq:_item_data.store_seq });
						}
					}
				});
			}
			else
			{
				Elever.Main.changePage("ReserveMainPage", PageEffect.LEFT, { data:_item_data, program_yn:data, store_seq:_item_data.store_seq });
			}
		}
		private function onStageMouseEvent(e:MouseEvent):void
		{
			if(e.type == MouseEvent.MOUSE_UP)
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseEvent);
				_displays.scroller.doNotScroll = false;
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
