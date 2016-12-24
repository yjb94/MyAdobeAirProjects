package Displays
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.AntiAliasType;
	import flash.text.ReturnKeyLabel;
	import flash.text.SoftKeyboardType;
	import flash.text.StageText;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class Text
	{
		private static const BASE_FONT:String = "Arial";
		public static const HEIGHT_COEFFICIENT:Number = 1.0;		//디자인에서의 폰트크기와 다르기 때문에 맞추기 위한 숫자.
		public static const INPUT_HEIGHT_COEFFICIENT:Number = 1.3;		//디자인에서의 폰트크기와 다르기 때문에 맞추기 위한 숫자.
		
		private static const GRAY:uint = 0xafafaf;
		
		[Embed(source="assets/fonts/NanumBarunGothic.ttf", mimeType = "application/x-font-truetype", fontName="NanumBarunGothic", embedAsCFF=false)]
		private static const fontMain:Class;
		
		public static function newText(message:String, size:Number=24, color:uint=0x000000, x_pos:Number=0, y_pos:Number=0, align:String="left", font_name:String="NanumBarunGothic", width:Number=0, height:Number=0, fmt_data:Object=null):TextField
		{
			var txt:TextField = new TextField;
			
			var fmt:TextFormat = txt.defaultTextFormat;
			fmt.size = size/HEIGHT_COEFFICIENT;
			fmt.font = font_name;
			fmt.align = align;
			fmt.color = color;
			if(fmt_data != null)
			{
				if(fmt_data.leading)
					fmt.leading = fmt_data.leading;
				if(fmt_data.bold)
					fmt.bold = fmt_data.bold;
			}
			txt.defaultTextFormat = fmt;
			
			if(font_name != BASE_FONT) txt.embedFonts = true;
			txt.text = message;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.x = x_pos;
			txt.y = y_pos;
			txt.width = width;
			txt.height = height;
			if(width == 0) txt.autoSize = TextFieldAutoSize.LEFT;
			if(height == -1)
			{
				txt.multiline = true;
				txt.wordWrap = true;
				txt.mouseEnabled = false;
				txt.height = txt.textHeight+size;
			}
			if(height == 0)	txt.height = size*INPUT_HEIGHT_COEFFICIENT;
			
			return txt;
		}
		
		private static const WIDTH_COEFFICIENT:Number = 0.46428571;
		private static const X_COEFFICIENT:Number = 0.35714286;
		private static const Y_COEFFICIENT:Number = 0.28571429;
		public static function newInputTextbox(file_name:Class, size:Number=24, base_text:String="", color:uint=0x000000, x_pos:Number=0, y_pos:Number=0, align:String="left", font_name:String=BASE_FONT, height:Number=0):Object
		{			
			var bmp:Bitmap = BitmapControl.newBitmap(file_name);
			bmp.x = x_pos;
			bmp.y = y_pos;
			bmp.name = "bmp";
			
			var txt:TextField = new TextField;
			txt.type = TextFieldType.INPUT;
			
			var fmt:TextFormat = txt.defaultTextFormat;
			fmt.font = font_name;
			fmt.size = size/HEIGHT_COEFFICIENT;
			fmt.align = align;
			fmt.color = color;
			txt.defaultTextFormat = fmt;
			
			if(font_name == "NanumBarunGothic") txt.embedFonts = true;
			txt.name = "text";
			txt.x = bmp.x + size*X_COEFFICIENT;
			txt.y = bmp.y + size*Y_COEFFICIENT/Config.ratio;
			txt.width = bmp.width - size*WIDTH_COEFFICIENT;
			txt.height = height;
			if(height == 0)	txt.height = size*INPUT_HEIGHT_COEFFICIENT;
			if(base_text != "")
			{
				fmt = txt.defaultTextFormat;
				fmt.color = GRAY;
				txt.defaultTextFormat = fmt;
				txt.text = base_text;
				
				txt.addEventListener(FocusEvent.FOCUS_IN, function(e:FocusEvent):void
				{
					if(e.currentTarget.text == base_text)
					{
						fmt = e.currentTarget.defaultTextFormat;
						fmt.color = color;
						e.currentTarget.defaultTextFormat = fmt;
						e.currentTarget.text = "";
					}
				});
				txt.addEventListener(FocusEvent.FOCUS_OUT, function(e:FocusEvent):void
				{
					if(e.currentTarget.text == "")
					{
						fmt = e.currentTarget.defaultTextFormat;
						fmt.color = GRAY;
						e.currentTarget.defaultTextFormat = fmt;
						e.currentTarget.text = base_text;
					}
				});
			}
			
			return { bmp:bmp, txt:txt };
		}
	}
}