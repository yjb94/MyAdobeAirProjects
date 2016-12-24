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
		private const TITLE_FONT_SIZE:Number = 45*Config.ratio;
		private const TEXT_FONT_SIZE:Number = 38*Config.ratio;
		
		private const TIME_TEXT_MARGIN:Number = 10*Config.ratio;
		
		private const LINE_X_MARGIN:Number = 52*Config.ratio;
		private const LINE_Y_MARGIN:Number = 68*Config.ratio;
		
		private const TEXT_MARGIN:Number = 22*Config.ratio;
		private const TEXTFILED_Y_MARGIN:Number = 57*Config.ratio;
		private const ITEM_Y_MARGIN:Number = 57*Config.ratio;
		
		private const TEXT_TEMP_MARGIN:Number = 2;
		
		private var _displays:Scroll;

		private var _params:Object;
		
		private var _txt_list:Vector.<TextField> = new Vector.<TextField>;
		
		private var _spr_status:Sprite;
		
		private var _btn_cancel:Button;
				
		public function Info(params:Object=null)
		{
			super();
			
			_params = params;
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Right = null;
			if((Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).previousPage.page_name == "ReserveMainPage")
			{
				(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).clearPrev();
				(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Right
					= new Button(Text.newText("완료      ", TEXT_FONT_SIZE, 0x585858), Text.newText("완료      ", TEXT_FONT_SIZE, 0xb6b6b6), function():void
					{
						Elever.Main.changePage("HomePage");
					});
			}
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = Text.newText("예약정보", TITLE_FONT_SIZE, 0x585858);
			
			_displays = new Scroll();
			addChild(_displays);
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).addMiddleTouchCallBack(_displays.toTop);
			
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.BLANK_MARGIN));
			
			//위쪽 선
			var bmp:Bitmap = BitmapControl.newBitmap(BitmapControl.TOP_LINE, LINE_X_MARGIN , LINE_Y_MARGIN)
			_displays.addObject(bmp);
			
			//예약 상태
			_spr_status = new Sprite;
			_spr_status.y = bmp.y + 114*Config.ratio;
			setReserveStatus(-1);
			_displays.addObject(_spr_status);
			
			//아래 선
			bmp = BitmapControl.newBitmap(BitmapControl.BOTTOM_LINE, LINE_X_MARGIN, _spr_status.y + _spr_status.height + LINE_Y_MARGIN)
			_displays.addObject(bmp);		
			
			
			//예약 날짜
			bmp = BitmapControl.newBitmap(BitmapControl.TRIANGLE, 75*Config.ratio, bmp.y + bmp.height - 30*Config.ratio); 
			_displays.addObject(bmp);
			
			var txt:TextField = Text.newText("예약 날짜", TEXT_FONT_SIZE, 0x585858, bmp.x+bmp.width+TEXT_MARGIN, 0, "left", "NanumBarunGothic", 0, 0, { bold:true });
			txt.y = bmp.y + bmp.height/2 - txt.height/2;
			_displays.addObject(txt);
			
			bmp = BitmapControl.newBitmap(BitmapControl.BLUE_SMALL_TEXTFIELD, 68*Config.ratio, txt.y + txt.height + TEXTFILED_Y_MARGIN); 
			_displays.addObject(bmp);
			
			var scnd_txt:TextField = Text.newText("", TEXT_FONT_SIZE, 0x585858, bmp.x + TEXT_MARGIN, 0, "left", "NanumBarunGothic");
			scnd_txt.name = "rsv_date";
			scnd_txt.y = bmp.y + bmp.height/2 - TEXT_FONT_SIZE/2-TEXT_TEMP_MARGIN;
			_txt_list.push(scnd_txt);
			_displays.addObject(scnd_txt);
			
			
			//예약 시간
			bmp = BitmapControl.newBitmap(BitmapControl.TRIANGLE, 75*Config.ratio, bmp.y + bmp.height + ITEM_Y_MARGIN); 
			_displays.addObject(bmp);
			
			txt = Text.newText("예약 시간", TEXT_FONT_SIZE, 0x585858,  bmp.x+bmp.width+TEXT_MARGIN, 0, "left", "NanumBarunGothic", 0, 0, { bold:true });
			txt.y = bmp.y + bmp.height/2 - txt.height/2;
			_displays.addObject(txt);
			
			bmp = BitmapControl.newBitmap(BitmapControl.RED_SMALL_TEXTFIELD, 68*Config.ratio, txt.y + txt.height + TEXTFILED_Y_MARGIN); 
			_displays.addObject(bmp);
			
			scnd_txt = Text.newText("", TEXT_FONT_SIZE, 0x585858, bmp.x+TEXT_MARGIN, 0, "left", "NanumBarunGothic");
			scnd_txt.name = "rsv_time";
			scnd_txt.y = bmp.y + bmp.height/2 - TEXT_FONT_SIZE/2-TEXT_TEMP_MARGIN;
			_txt_list.push(scnd_txt);
			_displays.addObject(scnd_txt);
			
			
			//예약 인원
			bmp = BitmapControl.newBitmap(BitmapControl.TRIANGLE, 75*Config.ratio, bmp.y + bmp.height + ITEM_Y_MARGIN); 
			_displays.addObject(bmp);
			
			txt = Text.newText("예약 인원", TEXT_FONT_SIZE, 0x585858,  bmp.x+bmp.width+TEXT_MARGIN, 0, "left", "NanumBarunGothic", 0, 0, { bold:true });
			txt.y = bmp.y + bmp.height/2 - txt.height/2;
			_displays.addObject(txt);
			
			bmp = BitmapControl.newBitmap(BitmapControl.GREEN_SMALL_TEXTFIELD, 68*Config.ratio, txt.y + txt.height + TEXTFILED_Y_MARGIN); 
			_displays.addObject(bmp);
			
			scnd_txt = Text.newText("", TEXT_FONT_SIZE, 0x585858, bmp.x+TEXT_MARGIN, 0, "left", "NanumBarunGothic");
			scnd_txt.name = "rsv_member";
			scnd_txt.y = bmp.y + bmp.height/2 - TEXT_FONT_SIZE/2-TEXT_TEMP_MARGIN;
			_txt_list.push(scnd_txt);
			_displays.addObject(scnd_txt);
			
			
			//예약 사람
			bmp = BitmapControl.newBitmap(BitmapControl.TRIANGLE, 75*Config.ratio, bmp.y + bmp.height + ITEM_Y_MARGIN); 
			_displays.addObject(bmp);
			
			txt = Text.newText("예약자 명", TEXT_FONT_SIZE, 0x585858, bmp.x+bmp.width+TEXT_MARGIN, 0, "left", "NanumBarunGothic", 0, 0, { bold:true });
			txt.y = bmp.y + bmp.height/2 - txt.height/2;
			_displays.addObject(txt);
			
			bmp = BitmapControl.newBitmap(BitmapControl.BLUE_SMALL_TEXTFIELD, 68*Config.ratio, txt.y + txt.height + TEXTFILED_Y_MARGIN); 
			_displays.addObject(bmp);
			
			scnd_txt = Text.newText("", TEXT_FONT_SIZE, 0x585858, bmp.x+TEXT_MARGIN, 0, "left", "NanumBarunGothic");
			scnd_txt.name = "rsv_user_name";
			scnd_txt.y = bmp.y + bmp.height/2 - TEXT_FONT_SIZE/2-TEXT_TEMP_MARGIN;
			_txt_list.push(scnd_txt);
			_displays.addObject(scnd_txt);
			
			
			//연락처
			bmp = BitmapControl.newBitmap(BitmapControl.TRIANGLE, 75*Config.ratio, bmp.y + bmp.height + ITEM_Y_MARGIN); 
			_displays.addObject(bmp);
			
			txt = Text.newText("연락처", TEXT_FONT_SIZE, 0x585858, bmp.x+bmp.width+TEXT_MARGIN, 0, "left", "NanumBarunGothic", 0, 0, { bold:true });
			txt.y = bmp.y + bmp.height/2 - txt.height/2;
			_displays.addObject(txt);
			
			bmp = BitmapControl.newBitmap(BitmapControl.RED_SMALL_TEXTFIELD, 68*Config.ratio, txt.y + txt.height + TEXTFILED_Y_MARGIN); 
			_displays.addObject(bmp);
			
			scnd_txt = Text.newText("", TEXT_FONT_SIZE, 0x585858, bmp.x+TEXT_MARGIN, 0, "left", "NanumBarunGothic");
			scnd_txt.name = "rsv_user_phone";
			scnd_txt.y = bmp.y + bmp.height/2 - TEXT_FONT_SIZE/2-TEXT_TEMP_MARGIN;
			_txt_list.push(scnd_txt);
			_displays.addObject(scnd_txt);
			
			
			//남기신 말
			bmp = BitmapControl.newBitmap(BitmapControl.TRIANGLE, 75*Config.ratio, bmp.y + bmp.height + ITEM_Y_MARGIN); 
			_displays.addObject(bmp);
			
			txt = Text.newText("남기신 말", TEXT_FONT_SIZE, 0x585858,  bmp.x+bmp.width+TEXT_MARGIN, 0, "left", "NanumBarunGothic", 0, 0, { bold:true });
			txt.y = bmp.y + bmp.height/2 - txt.height/2;
			txt.name = "rsv_message";
			_displays.addObject(txt);	
			
			bmp = BitmapControl.newBitmap(BitmapControl.GREEN_TEXTFIELD, 68*Config.ratio, txt.y + txt.height + TEXTFILED_Y_MARGIN);
			bmp.name = "rsv_bmp";
			_displays.addObject(bmp);		
			
			//취소 버튼
			_btn_cancel = new Button(Text.newText("예약 취소", TEXT_FONT_SIZE, 0xed8176), Text.newText("예약 취소", TEXT_FONT_SIZE, 0xedada6), onButtonCancel);
			_btn_cancel.x = Elever.Main.PageWidth/2 - _btn_cancel.width/2;
			_btn_cancel.y = bmp.y + bmp.height + ITEM_Y_MARGIN;
			_displays.addObject(_btn_cancel);
			
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.BLANK_MARGIN, 0, _btn_cancel.y + _btn_cancel.height));
			
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
						
						var bmp:Bitmap = _displays.scroller.getChildByName("rsv_bmp") as Bitmap;
						var txt:TextField = Text.newText(result.rsvInfoModel.rsv_message, TEXT_FONT_SIZE, 0x585858,  bmp.x+TEXT_MARGIN, bmp.y + TEXT_MARGIN,
							"left", "NanumBarunGothic",	Elever.Main.PageWidth - TEXT_MARGIN*2, bmp.height-TEXT_MARGIN);
						txt.wordWrap = true;
						txt.multiline = true;
						txt.name = "rsv_message";
						_txt_list.push(txt);
						_displays.addObject(txt);
						
						if(txt.height < txt.textHeight)
						{
							txt.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void
							{
								_displays.scroller.doNotScroll = true;
								stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseEvent);
							});
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

