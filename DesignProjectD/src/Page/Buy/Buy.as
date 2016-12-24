package Page.Buy
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.net.URLVariables;
	import flash.text.TextField;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.Popup;
	import Displays.Text;
	import Displays.WebImage;
	
	import Header.NavigationBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	
	import Scroll.Scroll;
	
	public class Buy extends BasePage
	{		
		private const ANCHOR_TWEEN_DURATION:Number = 0.3;
		private const BASE_Y_INTERVAL:Number = 30;
		
		private const TEXT_Y_MARGIN:Number = 40;
		private const TEXTBOX_HEIGHT:Number = 58;
		
		private const LINE_X_MARGIN:Number = 52*Config.ratio;
		private const LINE_Y_MARGIN:Number = 68*Config.ratio;
		
		private const TITLE_FONT_SIZE:Number = 50*Config.ratio;
		private const TEXT_FONT_SIZE:Number = 40*Config.ratio;
		private const INPUT_TEXT_FONT_SIZE:Number = 42*Config.ratio;
		
		private const CAR_FONT_SIZE:Number = 50*Config.ratio;
		private const COMPANY_FONT_SIZE:Number = 40*Config.ratio;
		
		private const PHONE_BASE_TEXT:String = "'-'빼고 입력해주세요.";
		
		private const TEXT_MARGIN:Number = 22*Config.ratio;
		private const TEXTFILED_Y_MARGIN:Number = 57*Config.ratio;
		private const ITEM_Y_MARGIN:Number = 57*Config.ratio;
		
		private var _displays:Scroll;
		
		private var _btn_term:Button;
		private var _btn_next:Button;
		
		private var _params:Object;
		
		private var _spr_car:Sprite;
		private var _item_data:Object;
		
		public function Buy(params:Object=null)
		{
			super();
			
			_params = params;
			_item_data = params.car_info;
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = Text.newText("견적요청", TITLE_FONT_SIZE, 0xffffff);
			
			_displays = new Scroll();
			addChild(_displays);
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).addMiddleTouchCallBack(_displays.toTop);
			
			
			//Car Spr
			_spr_car = new Sprite;
			_displays.addObject(_spr_car);
			_spr_car.y = 50;
			
			var img:WebImage = new WebImage(params.car_info.thumbnail, BitmapControl.CAR_MASK);
			img.name = name;
			img.x = 50;
			_spr_car.addChild(img);
			
			
			var car_name:String = params.car_info.name;
			var company_name:String = params.car_info.company;
			
			var width:Number = img.x + img.width;
			
			var txt:TextField = Text.newText(car_name, CAR_FONT_SIZE, 0x000000, width + 15, 10, "left", "NanumBarunGothic", Elever.Main.PageWidth, 0, { bold:true });
			txt.name = "name";
			_spr_car.addChild(txt);
			txt = Text.newText(company_name, COMPANY_FONT_SIZE, 0x494949, txt.x, txt.y + txt.height + 10, "left", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			txt.name = "company";
			_spr_car.addChild(txt);
			
			
			//예약 사람			
			txt = Text.newText("신청자명", TEXT_FONT_SIZE, 0x2c2c2c,  35, _spr_car.y + _spr_car.height + TEXT_Y_MARGIN, "left", "NanumBarunGothic", 0, 0);
			_displays.addObject(txt);
			
			var obj:Object = Text.newInputTextbox(BitmapControl.TEXTBOX, INPUT_TEXT_FONT_SIZE, ""/*Elever._user_info.name*/, 0x252525, 192, txt.y + txt.height/2 - TEXTBOX_HEIGHT/2, "left", "NanumBarunGothic");
			(obj.txt as TextField).name = "name";
			if(Elever._user_info.name)
				(obj.txt as TextField).text = Elever._user_info.name;
			(obj.txt as TextField).addEventListener(MouseEvent.CLICK, onClickInputText);
			(obj.txt as TextField).addEventListener(FocusEvent.FOCUS_OUT, onFocusInputText);
			_displays.addObject(obj.bmp); _displays.addObject(obj.txt);
			
			var bmp:Bitmap = BitmapControl.newBitmap(BitmapControl.BUY_SEPERATE_LINE, 0, obj.txt.y + obj.txt.height + TEXT_Y_MARGIN);
			_displays.addObject(bmp);
			
			//연락처			
			txt = Text.newText("전화번호", TEXT_FONT_SIZE, 0x2c2c2c, 35, bmp.y + bmp.height + TEXT_Y_MARGIN, "left", "NanumBarunGothic", 0, 0);
			_displays.addObject(txt);
			
			var str:String = (Elever._user_info.phone) ? /*Elever._user_info.phone*/"" : PHONE_BASE_TEXT;
			var phone_obj:Object = Text.newInputTextbox(BitmapControl.TEXTBOX, INPUT_TEXT_FONT_SIZE, str, 0x252525, 192, txt.y + txt.height/2 - TEXTBOX_HEIGHT/2, "left", "NanumBarunGothic");
			(phone_obj.txt as TextField).name = "phone";
			if(Elever._user_info.phone)
				(phone_obj.txt as TextField).text = Elever._user_info.phone;
			(phone_obj.txt as TextField).addEventListener(Event.CHANGE, function(e:Event):void
			{
				if(isNaN(e.currentTarget.text.substr(e.currentTarget.text.length-1)))
				{
					e.currentTarget.text = e.currentTarget.text.substr(0, e.currentTarget.length-1);
				}
			});
			(phone_obj.txt as TextField).addEventListener(MouseEvent.CLICK, onClickInputText);
			(phone_obj.txt as TextField).addEventListener(FocusEvent.FOCUS_OUT, onFocusInputText);
			_displays.addObject(phone_obj.bmp); _displays.addObject(phone_obj.txt);
			
			bmp = BitmapControl.newBitmap(BitmapControl.BUY_SEPERATE_LINE, 0, phone_obj.txt.y + phone_obj.txt.height + TEXT_Y_MARGIN);
			_displays.addObject(bmp);
			
			//남기는 말			
			txt = Text.newText("남기는말", TEXT_FONT_SIZE, 0x2c2c2c, 35, bmp.y + bmp.height + TEXT_Y_MARGIN, "left", "NanumBarunGothic", 0, 0);
			_displays.addObject(txt);
			
			obj = Text.newInputTextbox(BitmapControl.TEXTBOX, INPUT_TEXT_FONT_SIZE, "", 0x252525, 192, txt.y + txt.height/2 - TEXTBOX_HEIGHT/2, "left", "NanumBarunGothic");
			(obj.txt as TextField).name = "comment";
			(obj.txt as TextField).addEventListener(MouseEvent.CLICK, onClickInputText);
			(obj.txt as TextField).addEventListener(FocusEvent.FOCUS_OUT, onFocusInputText);
			_displays.addObject(obj.bmp); _displays.addObject(obj.txt);
			
			bmp = BitmapControl.newBitmap(BitmapControl.BUY_SEPERATE_LINE, 0, obj.txt.y + obj.txt.height + TEXT_Y_MARGIN);
			_displays.addObject(bmp);
			
			//약관 버튼
			_btn_term = new Button(BitmapControl.TERM_DISAGREE, BitmapControl.TERM_AGREE, null, 413, bmp.y + bmp.height + TEXT_Y_MARGIN, false, true);
			_displays.addObject(_btn_term);
			
			//다음 버튼
			_btn_next = new Button(BitmapControl.BUY_COMPLETE_BUTTON, BitmapControl.BUY_COMPLETE_BUTTON, onButtonNext, 0, _btn_term.y + _btn_term.height + TEXT_Y_MARGIN);
			_btn_next.x = Elever.Main.PageWidth/2 - _btn_next.width/2;
			_displays.addObject(_btn_next);
		}
		private function onCarSelect(e:MouseEvent):void
		{
			Elever.Main.changePage("ListPage", PageEffect.LEFT, { number:"1" });
		}
		private function onClickInputText(e:MouseEvent):void
		{
			if(e.type == MouseEvent.CLICK)
			{
				anchor(-(e.currentTarget as TextField).y + BASE_Y_INTERVAL);
			}
		}
		private function onFocusInputText(e:FocusEvent):void
		{
			if(e.type == FocusEvent.FOCUS_OUT)
			{
				if(stage.focus == null)
					anchor(0);
			}
		}
		private function anchor(y:Number):void
		{
			TweenLite.to(_displays, ANCHOR_TWEEN_DURATION, { y:y });
		}
		private function onButtonNext(e:MouseEvent):void
		{
			if(checkNext())
			{
				var popup:Popup = new Popup(Popup.YESNO_TYPE, { main_text:"정말로 신청하시겠습니까?", callback:function(type:String):void
				{
					if(type == "yes")
					{
						var params:URLVariables = new URLVariables;
						params.Cseq = _item_data.seq;
						params.Useq = Elever._user_info.seq;
						params.comment = (_displays.scroller.getChildByName("comment") as TextField).text;
						Elever.Main.LoadingVisible = true;
						Elever.Connection.post("temp13.jsp", params, function(data:String):void
						{
							Elever.Main.LoadingVisible = false;
							if(data)
							{
								var result:Object = JSON.parse(data);
								
								if(result == "1")
								{
									Elever.Main.changePage("ListPage");
								}
							}
						});
					}
				}});
			}
		}
		private function checkNext():Boolean
		{
			anchor(0);
			var error_msg:String = "";
			
			if(!_btn_term.isTabbed) error_msg = "약관에 동의해주세요.";
			if((_displays.scroller.getChildByName("phone") as TextField).text.length != 11) error_msg = "전화번호가 올바르지 않습니다.";
			if((_displays.scroller.getChildByName("phone") as TextField).text == PHONE_BASE_TEXT) error_msg = "전화번호를 입력해주세요.";
			if((_displays.scroller.getChildByName("name") as TextField).text.length == 0) error_msg = "신청자명을 입력해주세요.";
			
			if(error_msg == "")
				return true;
			else
			{
				var popup:Popup = new Popup(Popup.OK_TYPE, { main_text:error_msg });
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
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).previousPage.page_params.seq = _item_data.seq;
		}
	}
}
