package Page.Home
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
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
	
	public class ItemInfo extends BasePage
	{
		
		private const ICONS_MARGIN:Number = 32*Config.ratio;
		private const TEXTBOX_X_MARGIN:Number = 50;
		private const TEXTBOX_Y_MARGIN:Number = 37*Config.ratio;
		private const TWEEN_DURATION:Number = 0.3;
		
		private const TITLE_FONT_SIZE:Number = 50*Config.ratio;
		private const ITEM_FONT_SIZE:Number = 33.71*Config.ratio;
		private const ITEM_NAME_FONT_SIZE:Number = 58*Config.ratio;
		private const SMALL_FONT_SIZE:Number = 30.87*Config.ratio;
		
		private const BASE_POPUP_Y:Number = 116;
		private const POPUP_TEXT_MARGIN:Number = 77;
		
		private const TRIANGLE_HEIGHT:Number = 121;
				
		private var _displays:Scroll;
		
		private var _bottom_line:Bitmap;
		
		private var _slide_image:SlideImage;
		public function get isZoomed():Boolean { return _slide_image.isZoomed(); }
		public function zoomOut():void { _slide_image.zoomOut(); }
		
		private var _date_popup_bg:Sprite;
		
		private var _item_data:Object;
		
		private var _date_arr:Array;
		
		private var _bottom_bg_spr:Sprite;
		
		public function ItemInfo(params:Object=null)
		{
			super();
			
			getItemData(params.data);
			var txt:TextField = Text.newText(_item_data.store_name , TITLE_FONT_SIZE, 0xffffff);
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = txt;
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Right = new Button(BitmapControl.RING_BUTTON_UP, BitmapControl.RING_BUTTON_UP, onRingClicked);
			
			_slide_image = new SlideImage(null, 1, null, BitmapControl.INFO_SLIDE_TOP_BG, true);
			var str:String = _item_data.store_slide_image as String;
			var ary:Array = str.split("<br>");
			for(var i:int = 0; i < ary.length; i++)
				_slide_image.addItem(new WebImage(ary[i], BitmapControl.ITEM_MASK_BG), null);
			addChild(_slide_image);
			
			_displays = new Scroll(false, -1, Elever.Main.PageHeight-_slide_image.height+TRIANGLE_HEIGHT, -1, 0, null, true);
			_displays.y = _slide_image.height-TRIANGLE_HEIGHT;
			addChild(_displays);
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).addMiddleTouchCallBack(_displays.toTop);
			
			var bmp:Bitmap = BitmapControl.newBitmap(BitmapControl.TOP_TRIANGLE);	//이름은 triangle인데 전부다 있는 배경
			bmp.name = "bg";
			_displays.addObject(bmp);
			
			_bottom_bg_spr = new Sprite;
			_bottom_bg_spr.y =  _displays.height;
			_displays.addObject(_bottom_bg_spr);
			
			initPopup();
			setText();
			
			var btn:Button = new Button(BitmapControl.BUTTON_SELECT, BitmapControl.BUTTON_SELECT, onSeeMore, 0, 228);
			btn.x = Elever.Main.PageWidth-btn.width;
			btn.name = "see_more";
			_displays.addObject(btn);
			
			if(_item_data.store_reservation != 2)		//예약 불가 아닐 때
			{
				btn = new Button(BitmapControl.BUTTON_SELECT, BitmapControl.BUTTON_SELECT, onReservation, btn.x, 321);
				btn.x = Elever.Main.PageWidth-btn.width;
				_displays.addObject(btn);
			}
			
			btn = new Button(BitmapControl.BUTTON_SELECT, BitmapControl.BUTTON_SELECT, onCall, btn.x, 420);
			btn.x = Elever.Main.PageWidth-btn.width;
			_displays.addObject(btn);
			
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.INFO_BOTTOM_LINE, 0, _displays.height));
			
			_bottom_bg_spr.graphics.beginFill(Config.MainBGColor);
			_bottom_bg_spr.graphics.drawRect(0,0, Elever.Main.PageWidth, _displays.height - bmp.height);
			_bottom_bg_spr.graphics.endFill();
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
			_date_popup_bg = new Sprite;
			_date_popup_bg.graphics.beginFill(0x000000, 0.6);
			_date_popup_bg.graphics.drawRect(0, 0, Elever.Main.PageWidth, Elever.Main.PageHeight);
			_date_popup_bg.graphics.endFill();
			_date_popup_bg.alpha = 0;
			
			var spr:Sprite = new Sprite;
			spr.x = 11;
			_date_popup_bg.addChild(spr);
			
			var main:Bitmap = BitmapControl.newBitmap(BitmapControl.DATE_POPUP);
			main.name = "main";
			spr.addChild(main);
			spr.y = _date_popup_bg.height/2 - spr.height/2;
			
			_date_arr = String(_item_data.store_time).split("/");
			for(var i:int = 1; i < _date_arr.length; i++)
			{
				var txt:TextField = Text.newText("", ITEM_FONT_SIZE, 0x737373, 0, BASE_POPUP_Y + (i-1)*POPUP_TEXT_MARGIN, "right", "NanumBarunGothic", 563);
				txt.text = _date_arr[i];
				spr.addChild(txt);
			}
			txt = Text.newText("", ITEM_FONT_SIZE, 0x737373, 0, BASE_POPUP_Y + 6*POPUP_TEXT_MARGIN, "right", "NanumBarunGothic", 563);
			txt.text = _date_arr[0];
			spr.addChild(txt);
		}
		private function setText():void
		{
			var txt:TextField = Text.newText(_item_data.store_name, ITEM_NAME_FONT_SIZE, 0x000000, 0, 126, "center", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_displays.addObject(txt);
			
			txt = Text.newText(_item_data.store_division, SMALL_FONT_SIZE, 0x494949, 26, txt.y + 55, "left", "NanumBarunGothic");
			_displays.addObject(txt);
			
			txt = Text.newText(_item_data.store_summary, SMALL_FONT_SIZE, 0x494949, 0, txt.y, "right", "NanumBarunGothic", 620);
			_displays.addObject(txt);
			
			var date:Date = new Date;
			txt = Text.newText(_date_arr[date.day], ITEM_FONT_SIZE, 0x3b3b3b, 0, 242, "right", "NanumBarunGothic", 574);
			_displays.addObject(txt);
			
			var reserve_str:String;
			switch(int(_item_data.store_reservation))
			{
				case 0: reserve_str = "예약 권장"; break;	//권장
				case 1: reserve_str = "예약 가능"; break;	//가능
				case 2: reserve_str = "예약 불가"; break;	//불가
				case 3: reserve_str = "예약 필수"; break;	//필수(아직이미지없음)
			}
			txt = Text.newText(reserve_str, ITEM_FONT_SIZE, 0x3b3b3b, 0, 334, "right", "NanumBarunGothic", 574);
			_displays.addObject(txt);
			
			txt = Text.newText(_item_data.store_number, ITEM_FONT_SIZE, 0x3b3b3b, 0, 432, "right", "NanumBarunGothic", 574);
			txt.name = "call_text";
			_displays.addObject(txt);
			
			txt = Text.newText(_item_data.store_price, ITEM_FONT_SIZE, 0x3b3b3b, 0, 535, "right", "NanumBarunGothic", 574);
			_displays.addObject(txt);
			
			txt = Text.newText(_item_data.store_localtitle, ITEM_FONT_SIZE, 0x3b3b3b, 0, 635, "right", "NanumBarunGothic", 574);
			_displays.addObject(txt);
			
			var bmp:Bitmap = _displays.scroller.getChildByName("bg") as Bitmap;
			txt = Text.newText(_item_data.store_description, ITEM_FONT_SIZE, 0x3b3b3b,
				TEXTBOX_X_MARGIN, bmp.y+bmp.height, "left", "NanumBarunGothic", Elever.Main.PageWidth - TEXTBOX_X_MARGIN*2, -1,
				{ leading:15 });
			_displays.addObject(txt);
		}
		private var _popup_opened:Boolean = false;
		public function get isPopupOpend():Boolean { return _popup_opened; }
		private function onSeeMore(e:MouseEvent):void
		{
			if(_displays.scroller.isMoving) return;
			_displays.scroller.doNotScroll = true;
			_popup_opened = true;
			addChild(_date_popup_bg);
			
			_date_popup_bg.addEventListener(MouseEvent.CLICK, removePopup);
			
			TweenLite.to(_date_popup_bg, TWEEN_DURATION, { alpha:1 });
		}
		public function removePopup(e:MouseEvent):void
		{
			TweenLite.to(_date_popup_bg, TWEEN_DURATION, { alpha:0, onComplete:function():void
			{
				_popup_opened = false;
				_displays.scroller.doNotScroll = false;
				removeChild(_date_popup_bg);
			}});
		}
		private function onCall(e:MouseEvent):void
		{
			if(_displays.scroller.isMoving) return;
			
			var phone_num:String = (_displays.scroller.getChildByName("call_text") as TextField).text;
			var popup:Popup = new Popup(Popup.YESNO_TYPE, { main_text:phone_num, title_text:"통화", callback:function(type:String):void
			{
				if(type == "yes")
				{
					var params:URLVariables = new URLVariables;
					params.store_seq = _item_data.store_seq;
					Elever.Connection.post("store_call_count", params, function(data:String):void
					{
					});
					const callURL:String="tel:"+(phone_num.split("-;").join(""));
					navigateToURL(new URLRequest(callURL));
				}
			}});
		}
		private function onReservation(e:MouseEvent):void
		{
			if(_displays.scroller.isMoving) return;
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
