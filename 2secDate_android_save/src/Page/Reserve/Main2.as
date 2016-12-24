package Page.Reserve
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.ReturnKeyLabel;
	import flash.text.SoftKeyboardType;
	import flash.text.StageText;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.Popup;
	import Displays.SlideImage;
	import Displays.Text;
	
	import Header.NavigationBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	import Page.Home.Home;
	
	import Scroll.Scroll;
	
	import co.uk.mikestead.net.URLRequestBuilder;
	
	import fl.controls.TextInput;
	
	public class Main2 extends BasePage
	{		
		private const ANCHOR_TWEEN_DURATION:Number = 0.3;
		private const BASE_Y_INTERVAL:Number = 30;
		
		private const LINE_X_MARGIN:Number = 52*Config.ratio;
		private const LINE_Y_MARGIN:Number = 68*Config.ratio;
		
		private const TITLE_FONT_SIZE:Number = 45*Config.ratio;
		private const TEXT_FONT_SIZE:Number = 40*Config.ratio;
		private const INPUT_TEXT_FONT_SIZE:Number = 42*Config.ratio;
		
		private const PHONE_BASE_TEXT:String = "'-'빼고 입력해주세요.";
		
		private const TEXT_MARGIN:Number = 22*Config.ratio;
		private const TEXTFILED_Y_MARGIN:Number = 57*Config.ratio;
		private const ITEM_Y_MARGIN:Number = 57*Config.ratio;
		
		private var _displays:Scroll;
		
		private var _btn_term:Button;
		private var _btn_next:Button;
		
		private var _params:Object;
		
		public function Main2(params:Object=null)
		{
			super();
		
			_params = params;
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = Text.newText("예약신청", TITLE_FONT_SIZE, 0x585858);
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Right = null;
			
			_displays = new Scroll();
			addChild(_displays);
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).addMiddleTouchCallBack(_displays.toTop);
			
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.BLANK_MARGIN));
			
			//위쪽 선
			var bmp:Bitmap = BitmapControl.newBitmap(BitmapControl.TOP_LINE, LINE_X_MARGIN , LINE_Y_MARGIN)
			_displays.addObject(bmp);
			
			//예약 사람
			bmp = BitmapControl.newBitmap(BitmapControl.TRIANGLE, 75*Config.ratio, bmp.y + bmp.height + TEXTFILED_Y_MARGIN); 
			_displays.addObject(bmp);
			
			var txt:TextField = Text.newText("예약자명", TEXT_FONT_SIZE, 0x585858, bmp.x+bmp.width+TEXT_MARGIN, 0, "left", "NanumBarunGothic", 0, 0, { bold:true });
			txt.y = bmp.y + bmp.height/2 - txt.height/2;
			_displays.addObject(txt);
			
			var obj:Object = Text.newInputTextbox(BitmapControl.BLUE_SMALL_TEXTFIELD, INPUT_TEXT_FONT_SIZE, "", 0x585858, 68*Config.ratio, txt.y + txt.height + TEXTFILED_Y_MARGIN, "left", "NanumBarunGothic");
			(obj.txt as TextField).name = "name";
			if(params.rsvMainData.name_text)
				(obj.txt as TextField).text = params.rsvMainData.name_text;
			(obj.txt as TextField).addEventListener(MouseEvent.CLICK, onClickInputText);
			(obj.txt as TextField).addEventListener(FocusEvent.FOCUS_OUT, onFocusInputText);
			_displays.addObject(obj.bmp); _displays.addObject(obj.txt);
			
			
			//연락처
			bmp = BitmapControl.newBitmap(BitmapControl.TRIANGLE, 75*Config.ratio, obj.bmp.y + obj.bmp.height + ITEM_Y_MARGIN); 
			_displays.addObject(bmp);
			
			txt = Text.newText("전화 번호", TEXT_FONT_SIZE, 0x585858, bmp.x+bmp.width+TEXT_MARGIN, 0, "left", "NanumBarunGothic", 0, 0, { bold:true });
			txt.y = bmp.y + bmp.height/2 - txt.height/2;
			_displays.addObject(txt);
			
			var str:String = (params.rsvMainData.phone_text) ? "" : PHONE_BASE_TEXT;
			var phone_obj:Object = Text.newInputTextbox(BitmapControl.RED_SMALL_TEXTFIELD, INPUT_TEXT_FONT_SIZE, str, 0x585858, 68*Config.ratio, txt.y + txt.height + TEXTFILED_Y_MARGIN, "left", "NanumBarunGothic");
			(phone_obj.txt as TextField).name = "phone";
			if(params.rsvMainData.phone_text)
			{
				(phone_obj.txt as TextField).text = params.rsvMainData.phone_text;
			}
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
			
			
			//남기는 말
			bmp = BitmapControl.newBitmap(BitmapControl.TRIANGLE, 75*Config.ratio, phone_obj.bmp.y + phone_obj.bmp.height + ITEM_Y_MARGIN); 
			_displays.addObject(bmp);
			
			txt = Text.newText("남기는 말", TEXT_FONT_SIZE, 0x585858, bmp.x+bmp.width+TEXT_MARGIN, 0, "left", "NanumBarunGothic", 0, 0, { bold:true });
			txt.y = bmp.y + bmp.height/2 - txt.height/2;
			_displays.addObject(txt);
			
			obj = Text.newInputTextbox(BitmapControl.GREEN_SMALL_TEXTFIELD, INPUT_TEXT_FONT_SIZE, "", 0x585858, 68*Config.ratio, txt.y + txt.height + TEXTFILED_Y_MARGIN, "left", "NanumBarunGothic");
			(obj.txt as TextField).name = "comment";
			if(params.rsvMainData.comment_text)
				(obj.txt as TextField).text = params.rsvMainData.comment_text;
			(obj.txt as TextField).addEventListener(MouseEvent.CLICK, onClickInputText);
			(obj.txt as TextField).addEventListener(FocusEvent.FOCUS_OUT, onFocusInputText);
			_displays.addObject(obj.bmp); _displays.addObject(obj.txt);
			
			//약관 버튼
			_btn_term = new Button(Text.newText("약관에 동의합니까?", TEXT_FONT_SIZE, 0x585858), Text.newText("동의합니다 뿌잉뿌잉", TEXT_FONT_SIZE, 0x585858), null, 0, obj.bmp.y + obj.bmp.height + ITEM_Y_MARGIN, false, true);
			_btn_term.x = Elever.Main.PageWidth/2 - _btn_term.width/2;
			if(params.rsvMainData.term_yn != null)
				_btn_term.isTabbed = params.rsvMainData.term_yn;
			_displays.addObject(_btn_term);
			
			
			//다음 버튼
			_btn_next = new Button(Text.newText("예약 확정", TEXT_FONT_SIZE, 0xed8176), Text.newText("예약 확정", TEXT_FONT_SIZE, 0xedada6), onButtonNext, 0, _btn_term.y + _btn_term.height + ITEM_Y_MARGIN);
			_btn_next.x = Elever.Main.PageWidth/2 - _btn_next.width/2;
			_displays.addObject(_btn_next);
			
			//아래 선
			if(Elever.Main.PageHeight > _displays.height)
			{
				bmp = BitmapControl.newBitmap(BitmapControl.BOTTOM_LINE_NO_BLANK, LINE_X_MARGIN);
				bmp.y = Elever.Main.PageHeight - bmp.height - LINE_Y_MARGIN;
			}
			else
			{
				bmp = BitmapControl.newBitmap(BitmapControl.BOTTOM_LINE, LINE_X_MARGIN);
				bmp.y = _displays.height + LINE_Y_MARGIN;
			}
			_displays.addObject(bmp);
		}
		
		private function onClickInputText(e:MouseEvent):void
		{
			if(e.type == MouseEvent.CLICK)
			{
				anchor(-(e.currentTarget as TextField).y - _displays.scroller.getY() + BASE_Y_INTERVAL);
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
				var popup:Popup = new Popup(Popup.YESNO_TYPE, { main_text:"정말로 예약하시겠습니까?", callback:function(type:String):void
				{
					if(type == "yes")
					{
						var params:Object = new Object;
						params.store_seq = _params.store_seq;
						
						params.udid_seq = Elever.PushService.UDID;
						
						var date_text:String = _params.rsvMainData.date_text;
						date_text = date_text.substr(0, 4) + "-" + date_text.substr(5,2) + "-" + date_text.substr(8,2);
						var time_text:String = _params.rsvMainData.time_text;
						params.rsv_date_time = date_text + " " + time_text;
						
						params.rsv_member = _params.rsvMainData.member_text;
						
						params.rsv_user_name = (_displays.scroller.getChildByName("name") as TextField).text;
						
						params.rsv_user_number = (_displays.scroller.getChildByName("phone") as TextField).text;
						
						params.rsv_message = (_displays.scroller.getChildByName("comment") as TextField).text;
						
						params.rsv_program_seq = _params.program_yn;
						
						var req:URLRequest = new URLRequest();
						req.method = URLRequestMethod.POST;
						req.contentType = "application/json;charset=UTF-8";
						req.data   = JSON.stringify(params);
						req.url    = Config.SERVER_PATH + "rsv/registerAction"
						
						var loader:URLLoader = new URLLoader();
						Elever.Main.LoadingVisible = true;
						loader.addEventListener(Event.COMPLETE, function(e:Event):void
						{
							Elever.Main.LoadingVisible = false;
							
							var urlLoader:URLLoader = (e.currentTarget as URLLoader);
							var data:String = urlLoader.data;
							
							if(!data) data="";
							else
							{
								var startPos:int=data.lastIndexOf("<textarea");
								if(startPos>=0)
								{
									startPos=data.indexOf(">",startPos)+1;
									var endPos:int=data.indexOf("</textarea>",startPos);
									
									data=data.substr(startPos,endPos-startPos);
								}
							}
							
							if(data)
							{
								var result:Object = JSON.parse(data);
								
								if(result)
								{
									Elever.Main.changePage("ReserveInfoPage", PageEffect.LEFT, 
										{
											rsv_seq:result.rsv_seq,
											program_yn:_params.program_yn,
											rsvMainData:_params.rsvMainData,
											store_seq:_params.store_seq
										});
								}
							}
						});
						loader.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void
						{
							trace(e.text);
							Elever.Main.LoadingVisible = false;
						});
						loader.load(req);
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
			if((_displays.scroller.getChildByName("name") as TextField).text.length == 0) error_msg = "예약자명을 입력해주세요.";
			
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
			var obj:Object = (Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).previousPage.page_params;
			
			obj.rsvMainData.name_text = (_displays.scroller.getChildByName("name") as TextField).text;
			var phone_str:String = (_displays.scroller.getChildByName("phone") as TextField).text;
			obj.rsvMainData.phone_text = (phone_str == PHONE_BASE_TEXT) ? "" : phone_str;
			obj.rsvMainData.comment_text = (_displays.scroller.getChildByName("comment") as TextField).text;
			obj.rsvMainData.term_yn = _btn_term.isTabbed;
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).previousPage.page_params = obj;
		}
	}
}