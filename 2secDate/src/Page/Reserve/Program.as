package Page.Reserve
{
	import com.freshplanet.ane.AirDatePicker.AirDatePicker;
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLVariables;
	import flash.text.ReturnKeyLabel;
	import flash.text.SoftKeyboardType;
	import flash.text.StageText;
	import flash.text.TextField;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.SlideImage;
	import Displays.Text;
	import Displays.WebImage;
	
	import Header.NavigationBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	import Page.Home.Home;
	
	import Scroll.Scroll;
		
	public class Program extends BasePage
	{
		private const TWEEN_DURATION:Number = 0.25;
		
		private const LINE_X_MARGIN:Number = 52*Config.ratio;
		private const LINE_Y_MARGIN:Number = 68*Config.ratio;
		private const TEXTBOX_MARGIN:Number = 25*Config.ratio;
		
		private const TITLE_FONT_SIZE:Number = 50*Config.ratio;
		private const TEXT_FONT_SIZE:Number = 40*Config.ratio;
		private const TEXTBOX_FONT_SIZE:Number = 38*Config.ratio;
		
		private const TEXT_MARGIN:Number = 22*Config.ratio;
		private const TEXTFILED_Y_MARGIN:Number = 57*Config.ratio;
		private const ITEM_Y_MARGIN:Number = 57*Config.ratio;
		
		private var _program_list:Array;
		
		private var _slide_image:SlideImage;
		
		private var _textfield_bmp:Bitmap;
		private var _textfield_txt:TextField;
		private var _txt_for_tween:TextField;
		
		private var _program_index:uint = 0;
		
		private var _selected:Boolean = false;
		
		public function Program(params:Object=null)
		{
			_program_list = params.program_list;
			
			if(params.rsvMainData.program_index)
				_program_index = params.rsvMainData.program_index;
			
			super();
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = Text.newText("프로그램", TITLE_FONT_SIZE, 0xffffff);
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Right
				= new Button(Text.newText("선택      ", TEXT_FONT_SIZE, 0x585858), Text.newText("선택      ", TEXT_FONT_SIZE, 0xb6b6b6), function():void
				{
					_selected = true;
					(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).onPrevClick();
				});
			
			//위쪽 선
			
			var bmp:Bitmap = BitmapControl.newBitmap(BitmapControl.TOP_LINE, LINE_X_MARGIN, LINE_Y_MARGIN);
			addChild(bmp);
			
			//슬라이드 이미지
			
			_slide_image = new SlideImage(null, 1, null, BitmapControl.SLIDE_IMAGE_TOP, true);
			_slide_image.y = 124*Config.ratio;
			for(var i:int = 0; i < _program_list.length; i++)
				_slide_image.addItem(new WebImage(_program_list[i].program_image, BitmapControl.SLIDE_IMAGE_BG), onItemChanged);
			_slide_image.setAnchor(_program_index);
			addChild(_slide_image);
			
			//예약 날짜
			
			bmp = BitmapControl.newBitmap(BitmapControl.TRIANGLE, 75*Config.ratio, _slide_image.y + _slide_image.height + TEXTFILED_Y_MARGIN); 
			addChild(bmp);
			
			var txt:TextField = Text.newText("설명", TEXT_FONT_SIZE, 0x585858, bmp.x+bmp.width+TEXT_MARGIN, 0, "left", "NanumBarunGothic", 0, 0, { bold:true });
			txt.y = bmp.y + bmp.height/2 - txt.height/2;
			addChild(txt);
			
			//텍스트 박스
			
			_textfield_bmp = BitmapControl.newBitmap(BitmapControl.PROGRAM_TEXTFIELD, 130*Config.ratio, txt.y + txt.height + TEXTFILED_Y_MARGIN);
			addChild(_textfield_bmp);
			
			_textfield_txt = Text.newText(_program_list[_program_index].program_description, TEXTBOX_FONT_SIZE, 0x585858,
				_textfield_bmp.x + TEXTBOX_MARGIN, _textfield_bmp.y + TEXTBOX_MARGIN, "left", "NanumBarunGothic", _textfield_bmp.width - TEXTBOX_MARGIN*2, _textfield_bmp.height-TEXTBOX_MARGIN,
				{ leading:25*Config.ratio });
			_textfield_txt.wordWrap = true;
			_textfield_txt.multiline = true;
			addChild(_textfield_txt);
			
			//아래선
			
			bmp = BitmapControl.newBitmap(BitmapControl.BOTTOM_LINE_NO_BLANK, LINE_X_MARGIN);
			bmp.y = Elever.Main.PageHeight - bmp.height - LINE_Y_MARGIN;
			addChild(bmp);
		}
		private function onItemChanged(index:int):void
		{
			_program_index = index;
			
			_txt_for_tween = _textfield_txt;
			TweenLite.to(_txt_for_tween, TWEEN_DURATION, { alpha:0, onComplete:function():void
			{
				removeChild(_txt_for_tween);
				_txt_for_tween = null;
			}});
			
			_textfield_txt = Text.newText(_program_list[_program_index].program_description, TEXTBOX_FONT_SIZE, 0x585858,
				_textfield_bmp.x + TEXTBOX_MARGIN, _textfield_bmp.y + TEXTBOX_MARGIN, "left", "NanumBarunGothic", _textfield_bmp.width - TEXTBOX_MARGIN*2, _textfield_bmp.height-TEXTBOX_MARGIN,
				{ leading:25*Config.ratio });
			_textfield_txt.wordWrap = true;
			_textfield_txt.multiline = true;
			_textfield_txt.alpha = 0;
			addChild(_textfield_txt);
			
			TweenLite.to(_textfield_txt, TWEEN_DURATION, { alpha:1 });
		}
		public override function init():void
		{
		}
		public override function onResize():void
		{
		}
		
		public override function dispose():void
		{
			if(_selected)
			{
				var obj:Object = (Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).previousPage.page_params;
				
				obj.rsvMainData.program_seq = _program_list[_program_index].program_seq;
				obj.rsvMainData.program_index = _program_index;
				obj.rsvMainData.program_title = _program_list[_program_index].program_title;
	
				(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).previousPage.page_params = obj;
			}
		}
	}
}