package Page.Home
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLVariables;
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
	
	public class Detail extends BasePage
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
		
		private const STAR_MARGIN:Number = 5*Config.ratio;
		
		private var _displays:Scroll;
		
		private var _bottom_line:Bitmap;
		
		private var _value1_star:Sprite;
		private var _value2_star:Sprite;
		
		private var _star_popup:Sprite;
		private var _stars:Vector.<Sprite> = new Vector.<Sprite>;
		private var _star_bg:Sprite;
		
		private var _option_popup:Sprite;
		
		private var _selected_num:int;
		
		private var _slide_image:SlideImage;
		public function get isZoomed():Boolean { return _slide_image.isZoomed(); }
		public function zoomOut():void { _slide_image.zoomOut(); }
		
		private var _item_data:Object;
		
		private var _car_options:Array;
		private var _option_data_list:Object;
		private var _addon_price:TextField;
		private var _car_total_price:Number;
		//private var _option_list:Vector.<Button>;
		
		public function Detail(params:Object=null)
		{
			super();
			
			getItemData(params);
			
			var txt:TextField = Text.newText(_item_data.name, TITLE_FONT_SIZE, 0xffffff);
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = txt;
			
			_slide_image = new SlideImage(null, 1, null, BitmapControl.INFO_SLIDE_TOP_BG, true);
			var ary:Array = _item_data.image.split("<br>");
			for(var i:int = 0; i < ary.length; i++)
				_slide_image.addItem(new WebImage(ary[i], BitmapControl.ITEM_MASK_BG), null);
			addChild(_slide_image);
			
			_displays = new Scroll(false, -1, Elever.Main.PageHeight-_slide_image.height+TRIANGLE_HEIGHT-Elever.Main.footer.height, -1, params.y, null, true);
			_displays.y = _slide_image.height-TRIANGLE_HEIGHT;
			addChild(_displays);
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).addMiddleTouchCallBack(_displays.toTop);
			
			var bmp:Bitmap = BitmapControl.newBitmap(BitmapControl.TOP_TRIANGLE);	//이름은 triangle인데 전부다 있는 배경
			bmp.name = "bg";
			_displays.addObject(bmp);
			
			_car_total_price = Number(removeNonNumericChars(_item_data.price)) * 10000;
			
			setText();
			initPopup();
			
			var btn:Button = new Button(BitmapControl.BUTTON_SELECT, BitmapControl.BUTTON_SELECT, onOption, 0, 805);
			btn.x = Elever.Main.PageWidth-btn.width;
			btn.name = "option";
			_displays.addObject(btn);
			
			btn = new Button(BitmapControl.BUTTON_SELECT, BitmapControl.BUTTON_SELECT, onSelectRate1, 0, 1075);
			btn.x = Elever.Main.PageWidth-btn.width;
			btn.name = "rate1";
			_displays.addObject(btn);
			
			btn = new Button(BitmapControl.BUTTON_SELECT, BitmapControl.BUTTON_SELECT, onSelectRate2, 0, 1166);
			btn.x = Elever.Main.PageWidth-btn.width;
			btn.name = "rate2";
			_displays.addObject(btn);
			
			Elever.Main.LoadingVisible = false;
		}
		private function removeNonNumericChars($str:String):Number 
		{
			var newStr:String = "";
			for (var i:int = 0; i<$str.length; i++) {
				var currentCharCode:Number = $str.charCodeAt(i);
				if ((currentCharCode >= 48) && (currentCharCode <= 57)) {
					newStr += $str.charAt(i);
				}
			}
			return Number(newStr);
		}
		private function initOptionPopup(result:Object):void
		{
			if(_option_data_list) return;
			
			var spr:Sprite = new Sprite;
			spr.graphics.beginFill(0xf4f4f4);
			spr.graphics.drawRect(0,0, 500, 100*result.length+50);
			spr.x = Elever.Main.PageWidth/2 - spr.width/2;
			spr.y = Elever.Main.PageHeight/2 - spr.height/2 - Elever.Main.HeaderHeight/2;
			
			spr.addChild(Text.newText("옵션을 선택해주세요", 26, 0xffffff, 0, 10, "center", "NanumBarunGothic", spr.width));
			spr.graphics.beginFill(0x234f62);
			spr.graphics.drawRect(0, 0, 500, 50);
			spr.graphics.endFill();
			
			_addon_price = Text.newText("Total : "+_car_total_price.toString()+"원", 26, 0xffffff, 0, spr.height+8, "center", "NanumBarunGothic", spr.width);
			spr.graphics.beginFill(0x234f62);
			spr.graphics.drawRect(0, spr.height, 500, 50);
			spr.graphics.endFill();
			spr.addChild(_addon_price);
			
			_option_popup.addChild(spr);
			
			
			_car_options = new Array;
			//_option_list = new Vector.<Button>;
			for(var i:int = 0; i < result.length; i++)
			{
				_car_options.push(result[i]);
				
				var btn_bg:Button = new Button(BitmapControl.OPTION_BG_OFF, BitmapControl.OPTION_BG, function(e:MouseEvent):void
				{
					_car_total_price += (btn_bg.isTabbed) ? Number(btn_bg.name) : -1 * Number(btn_bg.name);
					_addon_price.text = "Total : "+_car_total_price.toString()+"원";
					(_displays.scroller.getChildByName("price") as TextField).text = (_car_total_price/10000) + "만원";
				}, 0, 50+i*100, false, true);
				
				btn_bg.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
				{
					btn_bg = e.currentTarget as Button
					doNotRemovePopup = true;
				});
				btn_bg.name = result[i].company;
				spr.addChild(btn_bg);
				//_option_list.push(btn_bg);
				
				spr.addChild(Text.newText(result[i].name, 20, 0x000000, 5, 50+20+i*100, "left", "NanumBarunGothic", 450, 0, { bold:true }));
				spr.addChild(Text.newText(result[i].company, 20, 0x494949, 5, 50+50+i*(100), "left", "NanumBarunGothic", 450));
			}	
		}
		private function getItemData(params:Object):void
		{
			_item_data = Elever._car_data[params.seq];
		}
		private function onOption(e:MouseEvent):void
		{
			if(!_option_data_list)
			{
				var params:URLVariables = new URLVariables;
				params.Cseq = _item_data.seq;
				Elever.Main.LoadingVisible = true;
				Elever.Connection.post("temp14.jsp", params, function(data:String):void
				{
					Elever.Main.LoadingVisible = false;
					if(data)
					{
						var result:Object = JSON.parse(data);
						
						if(result.length)
						{
							initOptionPopup(result);		
							_option_data_list = result;
							
							if(_displays.scroller.isMoving) return;
							_displays.scroller.doNotScroll = true;
							
							addChild(_option_popup);
							_option_popup.addEventListener(MouseEvent.CLICK, removeOptionPopup);
							
							TweenLite.to(_option_popup, TWEEN_DURATION, { alpha:1 });	
						}
						else
						{
							new Popup(Popup.OK_TYPE, { main_text:"이 차량은 옵션이 없습니다" });
						}
					}
				});
			}
			else
			{
				if(_displays.scroller.isMoving) return;
				_displays.scroller.doNotScroll = true;
				
				addChild(_option_popup);
				_option_popup.addEventListener(MouseEvent.CLICK, removeOptionPopup);
				
				TweenLite.to(_option_popup, TWEEN_DURATION, { alpha:1 });	
			}
		}
		private function setText():void
		{
			var txt:TextField = Text.newText(_item_data.name, ITEM_NAME_FONT_SIZE, 0x000000, 0, 126, "center", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_displays.addObject(txt);
			
			txt = Text.newText(_item_data.company, SMALL_FONT_SIZE, 0x494949, 26, txt.y + 55, "left", "NanumBarunGothic");
			_displays.addObject(txt);
			
			txt = Text.newText(_item_data.date, SMALL_FONT_SIZE, 0x494949, 0, txt.y, "right", "NanumBarunGothic", 620);
			_displays.addObject(txt);
			
			txt = Text.newText(_item_data.size, ITEM_FONT_SIZE, 0x3b3b3b, 0, 242, "right", "NanumBarunGothic", 574);
			_displays.addObject(txt);
			
			txt = Text.newText(_item_data.fuel, ITEM_FONT_SIZE, 0x3b3b3b, 0, 334, "right", "NanumBarunGothic", 574);
			_displays.addObject(txt);
			
			txt = Text.newText(_item_data.number, ITEM_FONT_SIZE, 0x3b3b3b, 0, 432, "right", "NanumBarunGothic", 574);
			_displays.addObject(txt);
			
			txt = Text.newText(_item_data.type, ITEM_FONT_SIZE, 0x3b3b3b, 0, 535, "right", "NanumBarunGothic", 574);
			_displays.addObject(txt);
			
			txt = Text.newText(_item_data.f_type, ITEM_FONT_SIZE, 0x3b3b3b, 0, 635, "right", "NanumBarunGothic", 574);
			_displays.addObject(txt);
			
			txt = Text.newText(_item_data.speed, ITEM_FONT_SIZE, 0x3b3b3b, 0, 725, "right", "NanumBarunGothic", 574);
			_displays.addObject(txt);
			
			txt = Text.newText(_item_data.hp, ITEM_FONT_SIZE, 0x3b3b3b, 0, 900, "right", "NanumBarunGothic", 574);
			_displays.addObject(txt);
			
			txt = Text.newText(_item_data.torque, ITEM_FONT_SIZE, 0x3b3b3b, 0, 995, "right", "NanumBarunGothic", 574);
			_displays.addObject(txt);
			
			//stars 1
			_value1_star = new Sprite;
			for(var i:int = 0; i < 5; i++)
			{
				var cls:Class = BitmapControl.STAR_COLORED;
				if(i > _item_data.value1-1)
					cls = BitmapControl.STAR_BLANK;
				var bmp:Bitmap = BitmapControl.newBitmap(cls);
				bmp.scaleX = 0.7;
				bmp.scaleY = 0.7;
				bmp.x = i*bmp.width + STAR_MARGIN;
				
				var star:Sprite = new Sprite;
				star.addChild(bmp);
				_value1_star.addChild(star);
			}
			_value1_star.x = Elever.Main.PageWidth - _value1_star.width - 60;
			_value1_star.y = 1082;
			
			_displays.addObject(_value1_star);
			
			//stars 2
			_value2_star = new Sprite;
			for(i = 0; i < 5; i++)
			{
				cls = BitmapControl.STAR_COLORED;
				if(i > _item_data.value2-1)
					cls = BitmapControl.STAR_BLANK;
				bmp = BitmapControl.newBitmap(cls);
				bmp.scaleX = 0.7;
				bmp.scaleY = 0.7;
				bmp.x = i*bmp.width + STAR_MARGIN;
				
				star = new Sprite;
				star.addChild(bmp);
				_value2_star.addChild(star);
			}
			_value2_star.x = Elever.Main.PageWidth - _value2_star.width - 60;
			_value2_star.y = 1172;
			
			_displays.addObject(_value2_star);
			
			txt = Text.newText(_item_data.price, ITEM_FONT_SIZE, 0x3b3b3b, 0, 1270, "right", "NanumBarunGothic", 574);
			txt.name = "price";
			_displays.addObject(txt);
			
			var btn:Button = new Button(BitmapControl.BUTTON_REQUEST, BitmapControl.BUTTON_REQUEST, onRequest, 0, 1324);
			btn.name = "request";
			_displays.addObject(btn);
		}
		private function onRequest(e:MouseEvent):void
		{
			if(Elever._user_info == null)
				Elever.Main.changePage("LoginPage");
			else
				Elever.Main.changePage("BuyPage", PageEffect.LEFT, { car_info:Elever._car_data[_item_data.seq] });
		}
		private function initPopup():void
		{
			//OptionPopup
			_option_popup = new Sprite;
			_option_popup.graphics.beginFill(0x000000, 0.6);
			_option_popup.graphics.drawRect(0, 0, Elever.Main.PageWidth, Elever.Main.PageHeight);
			_option_popup.graphics.endFill();
			_option_popup.alpha = 0;
			
			
			//StarPopup
			_star_popup = new Sprite;
			_star_popup.graphics.beginFill(0x000000, 0.6);
			_star_popup.graphics.drawRect(0, 0, Elever.Main.PageWidth, Elever.Main.PageHeight);
			_star_popup.graphics.endFill();
			_star_popup.alpha = 0;
			
			var spr:Sprite = new Sprite;
			spr.graphics.beginFill(0xf4f4f4);
			spr.graphics.drawRect(0, 0, 290, 100);
			spr.graphics.endFill();
			spr.x = Elever.Main.PageWidth/2 - spr.width/2;
			spr.y = Elever.Main.PageHeight/2 - spr.height/2 - Elever.Main.HeaderHeight/2;
			spr.addChild(Text.newText("별점을 입력해주세요", ITEM_FONT_SIZE, 0xffffff, 0, 2, "center", "NanumBarunGothic", spr.width));
			spr.graphics.beginFill(0x234f62);
			spr.graphics.drawRect(0, 0, 290, 32);
			spr.graphics.endFill();
			_star_popup.addChild(spr);
			
			//stars
			_star_bg = new Sprite;
			for(var i:int = 0; i < 5; i++)
			{
				var cls:Class = BitmapControl.STAR_COLORED;
				var bmp:Bitmap = BitmapControl.newBitmap(cls);
				bmp.x = i*bmp.width + STAR_MARGIN;
				
				var star:Sprite = new Sprite;
				star.addChild(bmp);
				star.addEventListener(MouseEvent.MOUSE_MOVE, onStarMouseDown);
				star.addEventListener(MouseEvent.MOUSE_UP, onStarMouseDown);
				_stars.push(star);
				_star_bg.addChild(star);
			}
			_star_bg.x = 20;
			_star_bg.y = 40;
			
			spr.addChild(_star_bg);
		}
		private function resetStars(rate:Number):void
		{
			for(var i:int = 4; i > rate; i--)
				changeBitmap(BitmapControl.STAR_BLANK, _stars[i], i, _star_bg);
			
			for(i = rate; i >= 0; i--)
				changeBitmap(BitmapControl.STAR_COLORED, _stars[i], i, _star_bg);
		}
		private function onSelectRate1(e:MouseEvent):void
		{
			if(_displays.scroller.isMoving) return;
			_displays.scroller.doNotScroll = true;
			addChild(_star_popup);
			_selected_num = 1;
			_star_popup.addEventListener(MouseEvent.CLICK, removePopup);
			
			resetStars(_item_data.value1-1);
			TweenLite.to(_star_popup, TWEEN_DURATION, { alpha:1 });
		}
		private function onSelectRate2(e:MouseEvent):void
		{
			if(_displays.scroller.isMoving) return;
			_displays.scroller.doNotScroll = true;
			addChild(_star_popup);
			
			_selected_num = 2;
			_star_popup.addEventListener(MouseEvent.CLICK, removePopup);
			
			resetStars(_item_data.value1-1);
			TweenLite.to(_star_popup, TWEEN_DURATION, { alpha:1 });
		}
		private var doNotRemovePopup:Boolean = false;
		public function removeOptionPopup(e:MouseEvent):void
		{
			if(doNotRemovePopup) 
			{
				doNotRemovePopup = false;
				return;
			}
			TweenLite.to(_option_popup, TWEEN_DURATION, { alpha:0, onComplete:function():void
			{
				_displays.scroller.doNotScroll = false;
				removeChild(_option_popup);
			}});
		}
		public function removePopup(e:MouseEvent):void
		{
			TweenLite.to(_star_popup, TWEEN_DURATION, { alpha:0, onComplete:function():void
			{
				_displays.scroller.doNotScroll = false;
				removeChild(_star_popup);
			}});
		}
		private function onStarMouseDown(e:MouseEvent):void
		{
			var star_index:int = _stars.indexOf(e.currentTarget as Sprite);
			
			for(var i:int = 4; i > star_index; i--)
				changeBitmap(BitmapControl.STAR_BLANK, _stars[i], i, _star_bg);
			
			for(i = star_index; i >= 0; i--)
				changeBitmap(BitmapControl.STAR_COLORED, _stars[i], i, _star_bg);
			
			if(e.type == MouseEvent.MOUSE_UP)
			{
				var popup:Popup = new Popup(Popup.YESNO_TYPE, { main_text:"별점을 등록하시겠습니까?", callback:function(type:String):void
				{
					if(type == "yes")
					{
						removePopup(null);	
						
						Elever.Main.LoadingVisible = true;
						
						var params:URLVariables = new URLVariables;
						params.seq = _item_data.seq;
						if(_selected_num == 1)
							params.value1 = star_index+1;
						else
							params.value2 = star_index+1;
						var url:String = (_selected_num == 1) ? "temp3.jsp" : "temp11.jsp";
						Elever.Main.LoadingVisible = true;
						Elever.Connection.post(url, params, function(data:String):void
						{
							Elever.Main.LoadingVisible = false;
							if(data)
							{
								var result:Object = JSON.parse(data);
								
								if(result)
								{
									if(_selected_num == 1)
										Elever._car_data[_item_data.seq].value1 = result;
									else
										Elever._car_data[_item_data.seq].value2 = result;
									Elever.saveEnviroment("car_info", Elever._car_data);
									Elever.Main.changePage("DetailPage", PageEffect.FADE, { y:_displays.scroller.y, seq:_item_data.seq }, 0.37, true);
								}
							}
						});
					}
				}});
			}
		}
		private function changeBitmap(name:Class, spr:Sprite, index:int, box_spr:Sprite):void
		{
			box_spr.removeChild(spr);
			spr.removeEventListener(MouseEvent.MOUSE_MOVE, onStarMouseDown);
			spr.removeEventListener(MouseEvent.MOUSE_UP, onStarMouseDown);
			
			var bmp:Bitmap = BitmapControl.newBitmap(name);
			bmp.x = index*bmp.width + STAR_MARGIN;
			bmp.y = box_spr.height/2 - bmp.height/2;
			
			spr = new Sprite;
			spr.addChild(bmp);
			spr.addEventListener(MouseEvent.MOUSE_MOVE, onStarMouseDown);
			spr.addEventListener(MouseEvent.MOUSE_UP, onStarMouseDown);
			box_spr.addChild(spr);
			
			_stars[index] = spr;
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

