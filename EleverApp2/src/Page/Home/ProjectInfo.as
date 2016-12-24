package Page.Home
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.net.URLVariables;
	import flash.text.TextField;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.SlideImage;
	import Displays.Text;
	import Displays.WebImage;
	
	import Footer.TabBar;
	
	import Header.Header;
	import Header.NavigationBar;
	import Header.TabBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	import Page.Home.Tabs.PrevItem;
	
	import Scroll.Scroll;
	
	public class ProjectInfo extends BasePage
	{
		private const BOTTOM_SPR_TWEEN_DURATION:Number = 0.5;
		private const ANCHOR_TWEEN_DURATION:Number = 0.3;
		private const BASE_Y_INTERVAL:Number = 30;
		private const PREV_ITEM:int = 0;
		private const NOW_ITEM:int = 0;
		private const INNER_MARGIN:Number = 10;
		
		private var _bottom_spr:Sprite;
		private var _bottom_y:Number;
		
		private var _display:Scroll;
		
		private var _project_data:Object;
		private var _project_type:int;
		
		private var _member_bmp:Bitmap;
		private var _member_text:TextField;
		private var _limit_member:int;
		private var _html_text:TextField;
		
		private var _slide_image:SlideImage;
		
		public function ProjectInfo(params:Object=null)
		{
			super();
			
			_project_data = params.model;	
			_project_type = params.now_item ? NOW_ITEM : PREV_ITEM;
			
			getInfo();
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = Text.newText(_project_data.gathering_name, 26, 0xffffff);
			(Elever.Main.footer.getChildByName("TabBar") as Footer.TabBar).disable = true;
			
			_bottom_spr = new Sprite;
			_bottom_spr.addChild(BitmapControl.newBitmap(BitmapControl.TOP_BG));
			var cls_up:Class = BitmapControl.TEMP_BUTTON_UP;
			var cls_down:Class = BitmapControl.TEMP_BUTTON_DOWN;
			var func:Function = onRegClick;
			_bottom_spr.addChild(new Button(cls_up, cls_down, func, _bottom_spr.width/2, _bottom_spr.height/2, true));
			_bottom_spr.alpha = 0;
			_bottom_y = Elever.Main.PageHeight+((params.noFooter) ? 0 : Elever.Main.footer.height);
			_bottom_spr.y = _bottom_y;
			TweenLite.to(_bottom_spr, BOTTOM_SPR_TWEEN_DURATION, { y:_bottom_y-_bottom_spr.height, alpha:1 });
			
			_display = new Scroll(false, -1, _bottom_y - _bottom_spr.height);
			
			//temp code
			_slide_image = new SlideImage(BitmapControl.TEMP_SLIDE_BG, 1, _display);
			_display.addObject(_slide_image);
			
			_html_text = Text.newText("");
			_html_text.width = Elever.Main.PageWidth;
			_html_text.wordWrap = true;
			_html_text.y = _slide_image.y + _slide_image.height + 10;
			_html_text.condenseWhite = true;
			_html_text.multiline = true;
			_display.addObject(_html_text);
			
			var obj:Object = Text.newInputTextbox(BitmapControl.TEXTFIELD, 24, "", 0x000000, 10, _slide_image.y + _slide_image.height + 10);
			_member_text = obj.txt as TextField;
			_member_text.restrict = "0-9";
			if(params) if(params.member) _member_text.text = params.member;
			_member_text.addEventListener(MouseEvent.CLICK, onClickInputText);
			_member_text.addEventListener(FocusEvent.FOCUS_OUT, onFocusInputText);
			_member_bmp = obj.bmp;
			_display.addObject(_member_bmp); _display.addObject(_member_text);
			
			//last margin
			var margin:Sprite = new Sprite;
			margin.name = "Margin";
			margin.graphics.beginFill(0xffffff);
			margin.graphics.drawRect(0, 0, Elever.Main.PageWidth, INNER_MARGIN);
			margin.graphics.endFill();
			margin.y = _member_bmp.y + _member_bmp.height;
			_display.addObject(margin);
			
			addChild(_display);
			
			addChild(_bottom_spr);
		}
		private function getInfo():void
		{
			var params:URLVariables = new URLVariables;
			params.gathering_seq = _project_data.gathering_seq;
			Elever.Main.LoadingVisible = true;
			Elever.Connection.post("Gatheringinfo", params, function(data:String):void
			{
				Elever.Main.LoadingVisible = false;
				
				if(data)
				{
					var result:Object = JSON.parse(data);

					_html_text.htmlText = result.gatheringInfoModel.gathering_instruction;
					var y_change:Number = _member_text.y;
					_member_text.y = _html_text.y + _html_text.height + 10;
					y_change -= _member_text.y;
					_limit_member = result.apply;
					_member_bmp.y -= y_change;
					
					var str:String = result.gatheringInfoModel.gathering_slide_image as String;
					var ary:Array = str.split("<br>");
					for(var i:int = 0; i < ary.length; i++)
						_slide_image.addItem(new WebImage(ary[i], BitmapControl.TEMP_SLIDE_MASK), null);
					
					var margin:Sprite = _display.scroller.getChildByName("Margin") as Sprite;
					margin.y = _member_bmp.y + _member_bmp.height;
				}
			});
		}
		private function onClickInputText(e:MouseEvent):void
		{
			if(e.type == MouseEvent.CLICK)
			{
				anchor(-(e.currentTarget as TextField).y - _display.scroller.getY() + BASE_Y_INTERVAL);
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
			TweenLite.to(_display, ANCHOR_TWEEN_DURATION, { y:y });
		}
		private function onRegClick(e:MouseEvent=null):void
		{
			var obj:Object = new Object;
			obj.model = _project_data;
			obj.noFooter = true;
			
			if(Elever.UserInfo == null)
			{
				Elever.Main.changePage("LoginPage", PageEffect.LEFT, obj);
			}
			else
			{
				if(isOKtoFinish())
				{
					var params:URLVariables = new URLVariables;
					params.user_seq = Elever.UserInfo.user_seq;
					params.gathering_seq = _project_data.gathering_seq;
					params.member = _member_text.text;
					Elever.Main.LoadingVisible = true;
					Elever.Connection.post("Gatheringconfirm", params, function(data:String):void
					{
						Elever.Main.LoadingVisible = false;
						if(data)
						{
							var result:Object = JSON.parse(data);
							
							if(result)
							{
								obj.member = result.member;
								obj.couponList = result.couponList;
								obj.gathering_price = result.gathering_price;
								Elever.Main.changePage("RegisterPage", PageEffect.LEFT, obj);
							}
						}
					});
					obj.member = _member_text.text;
					//Elever.Main.changePage("RegisterPage", PageEffect.LEFT, obj);
				}
			}
		}
		private function isOKtoFinish():Boolean
		{
			if(!(_member_text.length > 0 && int(_member_text.text) > 0)) return false;
			if(_limit_member < int(_member_text.text)) return false;
			
			return true;
		}
		public override function init():void
		{
			//_display.scroller.fold((Elever.Main.header.getChildByName("NavigationBar") as NavigationBar), 1);
		}
		public override function onResize():void
		{
		}
		
		public override function dispose():void
		{
			//_display.scroller.resetFoldObj();
			TweenLite.to(_bottom_spr, BOTTOM_SPR_TWEEN_DURATION, { y:_bottom_y, alpha:0 });
		}
	}
}
