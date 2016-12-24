package Page.Setting
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.RadioButton;
	import Displays.Text;
	
	import Header.Header;
	import Header.NavigationBar;
	import Header.TabBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	import Page.Home.Tabs.PrevItem;
	
	import Scroll.Scroll;
	
	public class Purchase extends BasePage
	{
		private const ONE_MONTH:int = 1;
		private const SIX_MONTH:int = 6;
		private const ONE_YEAR:int = 12;
		private const BEGIN_X:Number = 15;
		private const BEGIN_Y:Number = 44;
		private const INNER_MARGIN:Number = 10;
		private const MARGIN_HEIGHT:Number = 20;
		private const LINE_THICKNESS:Number = 1;
		
		private var _displays:Scroll;
		
		private var _purchase_num:TextField;
		
		private var _month_radiobtn:RadioButton;
		
		private var _item_spr_list:Vector.<Sprite> = new Vector.<Sprite>;
		
		public function Purchase(params:Object=null)
		{
			super();
			
			var spr:Sprite = new Sprite;
			
			var txt:TextField = Text.newText("현재까지 구매한 상품은 총", 27, 0x000000, BEGIN_X, BEGIN_Y);
			
			_purchase_num = Text.newText(0 + "건 입니다.", 27, 0x000000, txt.x + txt.width, txt.y);
			var fmt:TextFormat = _purchase_num.defaultTextFormat;
			fmt.color = 0xff0000;
			_purchase_num.setTextFormat(fmt, 0, 2);
			
			_month_radiobtn = new RadioButton(false, 17, onPurchasedMonthClick);
			_month_radiobtn.addButton(BitmapControl.PURCHASE_1MONTH_ON, BitmapControl.PURCHASE_1MONTH_DOWN);
			_month_radiobtn.addButton(BitmapControl.PURCHASE_6MONTH_ON, BitmapControl.PURCHASE_6MONTH_DOWN);
			_month_radiobtn.addButton(BitmapControl.PURCHASE_1YEAR_ON, BitmapControl.PURCHASE_1YEAR_DOWN);
			_month_radiobtn.x = txt.x;
			_month_radiobtn.y = txt.y + txt.height + MARGIN_HEIGHT;
			
			spr.graphics.beginFill(0xffffff);
			spr.graphics.drawRect(0, 0, Elever.Main.FullWidth, _month_radiobtn.y + _month_radiobtn.height + MARGIN_HEIGHT);
			spr.graphics.endFill();
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = Text.newText("구매 내역", 26, 0xffffff);
		
			
			_displays = new Scroll(false, -1, Elever.Main.PageHeight - (_month_radiobtn.y + _month_radiobtn.height + MARGIN_HEIGHT));
			_displays.y = _month_radiobtn.y + _month_radiobtn.height + MARGIN_HEIGHT;
			addChild(_displays);
			
			//last margin
			var margin:Sprite = new Sprite;
			margin.name = "Margin";
			margin.graphics.beginFill(0xffffff);
			margin.graphics.drawRect(0, 0, Elever.Main.PageWidth, INNER_MARGIN);
			margin.graphics.endFill();
			_displays.addObject(margin);
			
			addChild(spr);
			addChild(txt);
			addChild(_purchase_num);
			addChild(_month_radiobtn);
		}
		private function onPurchasedMonthClick():void
		{
			var type:int;
			switch(_month_radiobtn.Tab)
			{
				case 0: type = ONE_MONTH; break;
				case 1: type = SIX_MONTH; break;
				case 2: type = ONE_YEAR; break;
			}
			loadPurchase(type);
		}
		private function loadPurchase(type:int):void
		{
			var params:URLVariables = new URLVariables;
			params.user_seq = Elever.UserInfo.user_seq;
			params.m = type;
			Elever.Main.LoadingVisible = true;
			Elever.Connection.post("purchase", params, function(data:String):void
			{
				Elever.Main.LoadingVisible = false;
				
				if(data)
				{
					var result:Object = JSON.parse(data);
					
					deleteItems();

					_purchase_num.text = result.total_count + "건 입니다.";
					var fmt:TextFormat = _purchase_num.defaultTextFormat;
					fmt.color = 0xff0000;
					_purchase_num.setTextFormat(fmt, 0, result.total_count.length+1);
					
					for(var i:int = 0; i < result.total_count; i++)
					{
						var cur_obj:Object = result.ticketInfoList[i];
						drawPurchase(cur_obj.reg_cdd, cur_obj.order_no, cur_obj.name, cur_obj.price, cur_obj.member, cur_obj.start_time + " - " + cur_obj.end_time, cur_obj.status);
					}
				}
			});
		}
		private function drawPurchase(date:String, number:String, name:String, price:String, member:String, time:String, type:String):void
		{
			var spr:Sprite = new Sprite;

			var fmt:TextFormat;
			//주문일자
			var txt:TextField = Text.newText("주문 일자 : " + date, 21, 0x000000, BEGIN_X + INNER_MARGIN, INNER_MARGIN);
			spr.addChild(txt);
			//주문번호
			number = number.substr(9);
			txt = Text.newText("주문 번호 : " + number, 21, 0x000000, txt.x, txt.y, "right", "NanumGothicBold", Elever.Main.FullWidth - BEGIN_X*2 - BEGIN_X - INNER_MARGIN);
			fmt = txt.defaultTextFormat;
			fmt.color = 0xee0000;
			fmt.underline = true;
			txt.setTextFormat(fmt, 8, txt.text.length);
			spr.addChild(txt);
			//<상호명>상품명
			txt = Text.newText(name, 21, 0x000000, txt.x, txt.y + txt.height + INNER_MARGIN);
			spr.addChild(txt);
			//가격
			txt = Text.newText(price + "원", 21, 0xff0000, txt.x, txt.y, "right", "NanumGothicBold", Elever.Main.FullWidth - BEGIN_X*2 - BEGIN_X - INNER_MARGIN);
			spr.addChild(txt);
			//예약인원
			txt = Text.newText("예약 인원 : " + member, 17, 0x000000, txt.x+8, txt.y + txt.height + INNER_MARGIN);
			spr.addChild(txt);
			//예약시간
			txt = Text.newText("예약 시간 : " + time, 17, 0x000000, txt.x, txt.y + txt.height + INNER_MARGIN);
			spr.addChild(txt);
			//결제 정보
			txt = Text.newText("결제 정보 : " + type, 21, 0x000000, txt.x, txt.y + txt.height + INNER_MARGIN);
			fmt = txt.defaultTextFormat;
			fmt.color = 0x0000ff;
			txt.setTextFormat(fmt, 8, txt.text.length);
			spr.addChild(txt);
			
			//draw rect
			spr.graphics.lineStyle(LINE_THICKNESS, 0x00000);
			spr.graphics.beginFill(0xffffff);
			spr.graphics.drawRect(BEGIN_X, 0, Elever.Main.FullWidth - BEGIN_X*2, txt.y + txt.height + INNER_MARGIN);
			spr.graphics.endFill();
			
			//draw button
			var btn:Button = new Button(BitmapControl.TEMP_BUTTON_UP, BitmapControl.TEMP_BUTTON_DOWN);
			btn.x = spr.width - btn.width - INNER_MARGIN;
			btn.y = spr.height - btn.height - INNER_MARGIN;
			spr.addChild(btn);
			
			_displays.addObject(spr);
			_item_spr_list.push(spr);
			
			setItems();
		}
		private function setItems():void
		{
			for(var i:int = 1; i < _item_spr_list.length; i++)
			{
				var spr:Sprite = _item_spr_list[i];
				spr.y = _item_spr_list[i-1].y + spr.height + MARGIN_HEIGHT;
			}
			var last_spr:Sprite = _item_spr_list[_item_spr_list.length-1];
			var margin:Sprite = _displays.scroller.getChildByName("Margin") as Sprite;
			margin.y = last_spr.y + last_spr.height;
		}
		private function deleteItems():void
		{
			while(_item_spr_list.length)
				_displays.scroller.removeChild(_item_spr_list.pop());
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

