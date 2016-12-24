package Page.Reserve
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.SoftKeyboardEvent;
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
	
	public class Info extends BasePage
	{	
		private const TITLE_FONT_SIZE:Number = 50*Config.ratio;
		private const RIGHT_FONT_SIZE:Number = 48*Config.ratio;
		private const TEXT_FONT_SIZE:Number = 38*Config.ratio;
		private const ITEM_FONT_SIZE:Number = 33.71*Config.ratio;
		
		private const TIME_TEXT_MARGIN:Number = 10*Config.ratio;
		
		private const LINE_X_MARGIN:Number = 52*Config.ratio;
		private const LINE_Y_MARGIN:Number = 68*Config.ratio;
		
		private const TEXT_MARGIN:Number = 22*Config.ratio;
		private const TEXTFILED_Y_MARGIN:Number = 57*Config.ratio;
		private const ITEM_Y_MARGIN:Number = 57*Config.ratio;
		
		private const TEXT_Y_MARGIN:Number = 40;
		private const TEXTBOX_X_MARGIN:Number = 50;
		
		private const TEXT_TEMP_MARGIN:Number = 2;
		
		private var _displays:Scroll;

		private var _params:Object;
		
		private var _txt_list:Vector.<TextField> = new Vector.<TextField>;
		
		private var _spr_status:Sprite;
		
		private var _btn_cancel:Button;
		private var _last_blank:Bitmap;
		
		private var _comment_line:Bitmap;
				
		public function Info(params:Object=null)
		{
			super();
			
			_params = params;
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Right = null;
			if((Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).previousPage.page_name == "ReserveMainPage")
			{
				(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).clearPrev();
				(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Right
					= new Button(Text.newText("완료      ", RIGHT_FONT_SIZE, 0xffffff), Text.newText("완료      ", RIGHT_FONT_SIZE, 0xd9d9d9), function():void
					{
						Elever.Main.changePage("HomePage");
					});
			}
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = Text.newText("예약정보", TITLE_FONT_SIZE, 0xffffff);
			
			_displays = new Scroll();
			addChild(_displays);
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).addMiddleTouchCallBack(_displays.toTop);
			
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.BLANK_MARGIN));
			
			//위쪽 선
			var bmp:Bitmap = BitmapControl.newBitmap(BitmapControl.RESERVE_SEPERATE_LINE, 0, TEXT_Y_MARGIN);
			_displays.addObject(bmp);
			
			//예약 상태
			_spr_status = new Sprite;
			_spr_status.y = bmp.y + bmp.height + TEXT_Y_MARGIN;
			setReserveStatus(-1);
			_displays.addObject(_spr_status);
			
			//아래 선
			bmp = BitmapControl.newBitmap(BitmapControl.RESERVE_SEPERATE_LINE, 0, _spr_status.y + _spr_status.height + TEXT_Y_MARGIN);
			_displays.addObject(bmp);	
			
			//예약 날짜			
			var txt:TextField = Text.newText("예약날짜", TEXT_FONT_SIZE, 0x2c2c2c, 35, bmp.y + bmp.height + TEXT_Y_MARGIN, "left", "NanumBarunGothic", 0, 0);
			_displays.addObject(txt);
			
			var scnd_txt:TextField =Text.newText("", ITEM_FONT_SIZE, 0x3b3b3b, 0, txt.y, "right", "NanumBarunGothic", 574);
			scnd_txt.name = "rsv_date";
			_txt_list.push(scnd_txt);
			_displays.addObject(scnd_txt);
			
			bmp = BitmapControl.newBitmap(BitmapControl.RESERVE_SEPERATE_LINE, 0, txt.y + txt.height + TEXT_Y_MARGIN);
			_displays.addObject(bmp);	
			
			//예약 시간			
			txt = Text.newText("예약시간", TEXT_FONT_SIZE, 0x2c2c2c, 35, bmp.y + bmp.height + TEXT_Y_MARGIN, "left", "NanumBarunGothic", 0, 0);
			_displays.addObject(txt);
			
			scnd_txt =Text.newText("", ITEM_FONT_SIZE, 0x3b3b3b, 0, txt.y, "right", "NanumBarunGothic", 574);
			scnd_txt.name = "rsv_time";
			_txt_list.push(scnd_txt);
			_displays.addObject(scnd_txt);
			
			bmp = BitmapControl.newBitmap(BitmapControl.RESERVE_SEPERATE_LINE, 0, txt.y + txt.height + TEXT_Y_MARGIN);
			_displays.addObject(bmp);	
			
			//예약 인원			
			txt = Text.newText("예약인원", TEXT_FONT_SIZE, 0x2c2c2c, 35, bmp.y + bmp.height + TEXT_Y_MARGIN, "left", "NanumBarunGothic", 0, 0);
			_displays.addObject(txt);
			
			scnd_txt =Text.newText("", ITEM_FONT_SIZE, 0x3b3b3b, 0, txt.y, "right", "NanumBarunGothic", 574);
			scnd_txt.name = "rsv_member";
			_txt_list.push(scnd_txt);
			_displays.addObject(scnd_txt);
			
			bmp = BitmapControl.newBitmap(BitmapControl.RESERVE_SEPERATE_LINE, 0, txt.y + txt.height + TEXT_Y_MARGIN);
			_displays.addObject(bmp);
			
			//예약 사람			
			txt = Text.newText("예약자명", TEXT_FONT_SIZE, 0x2c2c2c, 35, bmp.y + bmp.height + TEXT_Y_MARGIN, "left", "NanumBarunGothic", 0, 0);
			_displays.addObject(txt);
			
			scnd_txt =Text.newText("", ITEM_FONT_SIZE, 0x3b3b3b, 0, txt.y, "right", "NanumBarunGothic", 574);
			scnd_txt.name = "rsv_user_name";
			_txt_list.push(scnd_txt);
			_displays.addObject(scnd_txt);
			
			bmp = BitmapControl.newBitmap(BitmapControl.RESERVE_SEPERATE_LINE, 0, txt.y + txt.height + TEXT_Y_MARGIN);
			_displays.addObject(bmp);
			
			//연락처
			txt = Text.newText("연락처", TEXT_FONT_SIZE, 0x2c2c2c, 35, bmp.y + bmp.height + TEXT_Y_MARGIN, "left", "NanumBarunGothic", 0, 0);
			_displays.addObject(txt);
			
			scnd_txt =Text.newText("", ITEM_FONT_SIZE, 0x3b3b3b, 0, txt.y, "right", "NanumBarunGothic", 574);
			scnd_txt.name = "rsv_user_phone";
			_txt_list.push(scnd_txt);
			_displays.addObject(scnd_txt);
			
			bmp = BitmapControl.newBitmap(BitmapControl.RESERVE_SEPERATE_LINE, 0, txt.y + txt.height + TEXT_Y_MARGIN);
			_displays.addObject(bmp);
			
			//남기신 말			
			txt = Text.newText("남기신말", TEXT_FONT_SIZE, 0x2c2c2c, 35, bmp.y + bmp.height + TEXT_Y_MARGIN, "left", "NanumBarunGothic", 0, 0);
			txt.name = "rsv_message";
			_displays.addObject(txt);	
			
			_comment_line = BitmapControl.newBitmap(BitmapControl.RESERVE_SEPERATE_LINE, 0, txt.y + txt.height + TEXT_Y_MARGIN);
			_displays.addObject(_comment_line);
			
			//취소 버튼
			_btn_cancel = new Button(BitmapControl.RESERVE_CANCEL_BUTTON, BitmapControl.RESERVE_CANCEL_BUTTON, onButtonCancel);
			_btn_cancel.x = Elever.Main.PageWidth/2 - _btn_cancel.width/2;
			_btn_cancel.y = _comment_line.y + _comment_line.height + ITEM_Y_MARGIN;
			_displays.addObject(_btn_cancel);

			_last_blank = BitmapControl.newBitmap(BitmapControl.BLANK_MARGIN, 0, _btn_cancel.y + _btn_cancel.height);
			_last_blank.height = 50;
			_displays.addObject(_last_blank);
			
			checkReserveInfo(params.rsv_seq);
		}
		private function onButtonCancel(e:MouseEvent):void
		{
			var popup:Popup = new Popup(Popup.YESNO_TYPE, { main_text:"정말로 예약을 취소하시겠습니까?", callback:function(type:String):void
			{
				if(type == "yes")
				{
					var params:URLVariables = new URLVariables;
					params.rsv_seq = _params.rsv_seq;
					Elever.Main.LoadingVisible = true;
					Elever.Connection.post("rsv/cancelAction", params, function(data:String):void
					{
						Elever.Main.LoadingVisible = false;
						Elever.Main.changePage("HomePage");
					});
				}
			}});
		}
		private function checkReserveInfo(rsv_seq:String):void
		{
			var params:URLVariables = new URLVariables;
			params.rsv_seq = rsv_seq;
			Elever.Main.LoadingVisible = true;
			Elever.Connection.post("rsv/info", params, function(data:String):void
			{
				Elever.Main.LoadingVisible = false;
				if(data)
				{
					var result:Object = JSON.parse(data);
					
					if(result)
					{
						_txt_list[0].text = (result.rsvInfoModel.rsv_date) ? result.rsvInfoModel.rsv_date : "";
						_txt_list[1].text = (result.rsvInfoModel.rsv_time) ? result.rsvInfoModel.rsv_time : "";
						_txt_list[2].text = (result.rsvInfoModel.rsv_member) ? result.rsvInfoModel.rsv_member : "";
						_txt_list[3].text = (result.rsvInfoModel.rsv_user_name) ? result.rsvInfoModel.rsv_user_name : "";
						_txt_list[4].text = (result.rsvInfoModel.rsv_user_number) ? result.rsvInfoModel.rsv_user_number : "";

						var txt:TextField = _displays.scroller.getChildByName("rsv_message") as TextField;
						txt = Text.newText(result.rsvInfoModel.rsv_message, ITEM_FONT_SIZE, 0x3b3b3b, TEXTBOX_X_MARGIN,
							txt.y+txt.height + 10, "left", "NanumBarunGothic", Elever.Main.PageWidth - TEXTBOX_X_MARGIN*2, -1,
							{ leading:15 });
						_displays.addObject(txt);
						txt.name = "rsv_message";
						_txt_list.push(txt);
						_displays.addObject(txt);
						
						if(txt.text != "")
						{
							_comment_line.y = txt.y + txt.height + TEXT_Y_MARGIN;
							_btn_cancel.y = _comment_line.y + _comment_line.height + ITEM_Y_MARGIN;
							_last_blank.y = _btn_cancel.y + _btn_cancel.height;
						}
						setReserveStatus(int(result.rsvInfoModel.rsv_status));

						_displays.onResize();
					}
				}
			});
		}
		private function setReserveStatus(index:int):void
		{
			while(_spr_status.numChildren)
				_spr_status.removeChildAt(0);
			
			for(var i:int = 0; i < BitmapControl.RESERVE_STATE.length; i++)
			{
				var bmp:Bitmap = BitmapControl.newBitmap(BitmapControl.RESERVE_STATE[i]);
				bmp.x = Elever.Main.PageWidth*(i+1)/4 - bmp.width/2;
				if(i != index)
					bmp.alpha = 0.3;
				_spr_status.addChild(bmp);
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

