package Page.Notice
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.SlideImage;
	import Displays.Text;
	
	import Header.NavigationBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	
	import Scroll.Scroll;
	
	public class Notice extends BasePage
	{
		private const LINE_BEGIN_X:Number = 40;
		private const MARK_BEGIN_X:Number = 26;
		private const TEXT_BEGIN_Y:Number = 35;
		private const TEXT_BEGIN_X:Number = 83;
		private const TEXT_WIDTH:Number = 457;
		private const BUTTON_X_MARGIN:Number = 12;
		private const SCALE_COEFFIECTINT:Number = 107.833333;
		
		
		private var _displays:Scroll;
		private var _item_list:Vector.<Sprite> = new Vector.<Sprite>;
		
		private var _btn_see_more:Button;
		private var _cur_page:uint = 0;
		
		private var _total_page:uint;
		
		public function Notice(params:Object=null)
		{
			super();
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Right = null;
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = BitmapControl.newBitmap(BitmapControl.RING);
			
			_displays = new Scroll(true, -1, -1, -1, 0, function():void
			{
				Elever.Main.changePage("NoticePage", PageEffect.FADE, params, 0.37, true);
			});
			addChild(_displays);
						
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).addMiddleTouchCallBack(_displays.toTop);
			
			_btn_see_more = new Button(BitmapControl.SEE_MORE, BitmapControl.SEE_MORE, onSeeMore);
			onLoadData(_cur_page++);
		}
		private function onSeeMore(e:MouseEvent):void
		{
			onLoadData(_cur_page++);
		}
		private function onLoadData(page:int=1):void
		{
			var params:URLVariables = new URLVariables;
			params.udid_seq = Elever.PushService.UDID;
			params.page = page;
			Elever.Main.LoadingVisible = true;
			Elever.Connection.post("user/timeline", params, function(data:String):void
			{
				Elever.Main.LoadingVisible = false;
				if(data)
				{
					var result:Object = JSON.parse(data);
					
					if(result)
					{
						_total_page = result.totalpage;
						var list:Array = result.timelineInfoList;
						for(var i:int = 0; i < list.length; i++)
						{
							makeItem(list[i].message, list[i].register_time, list[i].rsv_seq);
						}
						if(_cur_page < _total_page)
						{
							_btn_see_more.y = _displays.height;
							_displays.addObject(_btn_see_more);
						}
						else
						{
							_displays.scroller.removeChild(_btn_see_more);
						}
						_displays.onResize();
					}
				}
			});
		}
		private function makeItem(text:String, time:String, rsv_seq:String=""):void
		{
			var spr:Sprite = new Sprite;
			
			var box:Sprite = new Sprite;
			spr.addChild(box);
			
			//텍스트
			var txt:TextField = Text.newText(text, 26, 0x000000, TEXT_BEGIN_X, TEXT_BEGIN_Y, "left", "NanumBarunGothic", TEXT_WIDTH, -1);
			spr.addChild(txt);
			
			//원
			var circle:Bitmap = BitmapControl.newBitmap(BitmapControl.NOTICE_CIRCLE, MARK_BEGIN_X, txt.height);
			spr.addChild(circle);
			
			//원 위 선
			var line:Sprite = new Sprite;
			line.graphics.beginFill(0xb7bcc6);
			line.graphics.drawRect(0, 0, 8, circle.y+2);
			line.graphics.endFill();
			line.x = LINE_BEGIN_X;
			spr.addChild(line);
			
			//시계이미지
			var clock:Bitmap = BitmapControl.newBitmap(BitmapControl.NOTICE_CLOCK, txt.x, circle.y + circle.height);
			spr.addChild(clock);
			
			//날짜
			txt = Text.newText(time, 20, 0x9b9b9b, clock.x + clock.width + 8, 0, "left", "NanumBarunGothic", TEXT_WIDTH);
			txt.y = clock.y + clock.height/2 - txt.height/2;
			spr.addChild(txt);
			
			//전체 상자
			box.graphics.beginFill((_item_list.length%2) ? 0xe0e0e0 : Config.MainBGColor);
			box.graphics.drawRect(0, 0, Elever.Main.PageWidth, spr.height + TEXT_BEGIN_Y);
			box.graphics.endFill();
			
			//원 아래 선
			line = new Sprite;
			line.graphics.beginFill(0xb7bcc6);
			line.graphics.drawRect(0, 0, 8, spr.height - (circle.y + circle.height -2));
			line.graphics.endFill();
			line.x = LINE_BEGIN_X;
			line.y = circle.y + circle.height - 2;
			spr.addChild(line);
			
			if(_item_list.length > 0)
				spr.y = _item_list[_item_list.length-1].y + _item_list[_item_list.length-1].height;
			else
				spr.y = _displays.height;
			
			if((rsv_seq != "") && (rsv_seq != null))
			{
				var btn:Button = new Button(BitmapControl.NOTICE_SEE_MORE, BitmapControl.NOTICE_SEE_MORE, function(e:MouseEvent):void
				{
					Elever.Main.changePage("ReserveInfoPage", PageEffect.LEFT, { rsv_seq:(e.currentTarget as Button).name });
				});
				btn.name = rsv_seq;
				btn.x = Elever.Main.PageWidth - btn.width - BUTTON_X_MARGIN;
				btn.y = clock.y + clock.height/2 - btn.height/2;
				spr.addChild(btn);
			}
						
			_item_list.push(spr);
			_displays.addObject(spr);
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
