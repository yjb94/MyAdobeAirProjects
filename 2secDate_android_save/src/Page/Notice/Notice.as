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
		private const ITEM_BEGIN_Y:Number = 60*Config.ratio;
		private const MARK_BEGIN_X:Number = 111*Config.ratio;
		private const LINE_BEGIN_X:Number = 335*Config.ratio;
		private const TEXT_BEGIN_Y:Number = 30*Config.ratio;
		private const TEXT_BEGIN_X:Number = 395.5*Config.ratio;
		private const TEXT_WIDTH:Number = 641.5*Config.ratio;
		private const ITEM_MARGIN:Number = 0; //67.25*Config.ratio;
		private const BUTTON_X_MARGIN:Number = 50*Config.ratio;
		private const SCALE_COEFFIECTINT:Number = 107.833333;
		
		private const LINE_COLORS:Array = [0xeed380, 0xb0cec5, 0xde9f93, 0xcbeda7];
		private var _color_index:int = 0;
		
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
			
			_displays.addObject(BitmapControl.newBitmap(BitmapControl.BLANK_MARGIN));
			
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
							makeItem(list[i].message, (list[i].type == "0") ? BitmapControl.MARK_ELEVER : BitmapControl.MARK_LIKE, list[i].register_time, list[i].rsv_seq);
						}
						if(_cur_page < _total_page)
						{
							_btn_see_more.y = _displays.height;
							_displays.addObject(_btn_see_more);
						}
						else
						{
							_displays.scroller.removeChild(_btn_see_more);
							_displays.addObject(BitmapControl.newBitmap(BitmapControl.BLANK_MARGIN, 0, _displays.height));
						}
						_displays.onResize();
					}
				}
			});
		}
		private function makeItem(text:String, mark_type:Class, time:String, rsv_seq:String=""):void
		{
			var spr:Sprite = new Sprite;
			var txt:TextField = Text.newText(text, 32*Config.ratio, 0x000000, TEXT_BEGIN_X, TEXT_BEGIN_Y,
				"left", "NanumBarunGothic", TEXT_WIDTH, -1, { leading:25*Config.ratio });
			var txt_y:Number = txt.y;
			var txt_height:Number = txt.height;
			spr.addChild(txt);
			
			txt = Text.newText(time, 32*Config.ratio, 0x000000, TEXT_BEGIN_X, txt.y + txt.height,
				"left", "NanumBarunGothic", TEXT_WIDTH, -1, { leading:25*Config.ratio });
			txt_height += txt.height;
			spr.addChild(txt);
			
			var bmp:Bitmap =  BitmapControl.newBitmap(mark_type, MARK_BEGIN_X);
			bmp.y = txt_y + txt_height/2 - bmp.height/2;
			spr.addChild(bmp);
			
			var line:Sprite = new Sprite;
			line.graphics.beginFill(LINE_COLORS[_color_index%4]);
			line.graphics.drawRect(LINE_BEGIN_X, 0, 4*Config.ratio, spr.height + TEXT_BEGIN_Y);
			line.graphics.endFill();
			spr.addChild(line);
			
			if(_item_list.length > 0)
				spr.y = _item_list[_item_list.length-1].y + _item_list[_item_list.length-1].height + ITEM_MARGIN;
			else
				spr.y = _displays.height;
			
			if((rsv_seq != "") && (rsv_seq != null))
			{
				var btn:Button = new Button(BitmapControl.ARROW[_color_index%4], BitmapControl.ARROW[_color_index%4], function(e:MouseEvent):void
				{
					Elever.Main.changePage("ReserveInfoPage", PageEffect.LEFT, { rsv_seq:(e.currentTarget as Button).name });
				});
				btn.name = rsv_seq;
				btn.scaleX = spr.height/SCALE_COEFFIECTINT;
				if(btn.scaleX > 1.5)		btn.scaleX = 1.5;
				btn.scaleY = btn.scaleX;
				btn.x = Elever.Main.PageWidth - btn.width - BUTTON_X_MARGIN;
				btn.y = spr.height/2 - btn.height/2;
				spr.addChild(btn);
				//				spr.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			}
			
			spr.addChild(BitmapControl.newBitmap(BitmapControl.NOTICE_SEPERATE_LINE, 0, spr.height));
			
			_color_index++;
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
