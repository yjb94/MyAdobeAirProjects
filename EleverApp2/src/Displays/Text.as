package Displays
{
	import flash.display.Bitmap;
	import flash.events.Event;
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
		private static const HEIGHT_COEFFICIENT:Number = 1.2;		//디자인에서의 폰트크기와 다르기 때문에 맞추기 위한 숫자.
		
		[Embed(source="assets/fonts/NanumGothicBold.ttf", mimeType = "application/x-font-truetype", fontName="NanumGothicBold", embedAsCFF=false)]
		private static const fontMain:Class;
		
		public static function newText(message:String, size:Number=19, color:uint=0x000000, x_pos:Number=0, y_pos:Number=0, align:String="left", font_name:String="NanumGothicBold", width:Number=0, height:Number=0):TextField
		{
			var txt:TextField = new TextField;
			
			var fmt:TextFormat = txt.defaultTextFormat;
			fmt.size = size/HEIGHT_COEFFICIENT;
			fmt.font = font_name;
			fmt.align = align;
			fmt.color = color;
			txt.defaultTextFormat = fmt;
			
			if(font_name != BASE_FONT) txt.embedFonts = true;
			txt.text = message;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.x = x_pos;
			txt.y = y_pos;
			txt.width = width;
			txt.height = height;
			if(width == 0) txt.autoSize = TextFieldAutoSize.LEFT;
			if(height == 0)	txt.height = size;
			
			return txt;
		}
		
		private static const WIDTH_COEFFICIENT:Number = 0.46428571;
		private static const X_COEFFICIENT:Number = 0.35714286;
		private static const Y_COEFFICIENT:Number = 0.28571429;
		public static function newInputTextbox(file_name:Class, size:Number=19, base_text:String="", color:uint=0x000000, x_pos:Number=0, y_pos:Number=0, align:String="left", font_name:String="Arial", height:Number=0):Object
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
			
			if(font_name == "NanumGothicBold") txt.embedFonts = true;
			txt.name = "text";
			txt.x = bmp.x + size*X_COEFFICIENT;
			txt.y = bmp.y + size*Y_COEFFICIENT;
			txt.width = bmp.width - size*WIDTH_COEFFICIENT;
			txt.height = height;
			if(height == 0)	txt.height = size;
			if(base_text != "")	txt.text = base_text;
			
			return { bmp:bmp, txt:txt };
		}
	}
}