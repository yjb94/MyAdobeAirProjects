package Displays
{
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Text
	{
		private static const BASE_FONT:String = "Times New Roman";
		private static const HEIGHT_COEFFICIENT:Number = 1.3;
		
		[Embed(source="assets/fonts/NanumGothicBold.ttf", mimeType = "application/x-font-truetype", fontName="NanumGothicBold", embedAsCFF=false)]
		private static const fontMain:Class;
		
		public static function newText(message:String, size:Number, color:uint=0x000000, x_pos:Number=0, y_pos:Number=0, align:String="left", font_name:String=BASE_FONT, width:Number=0, height:Number=0):TextField
		{
			var txt:TextField = new TextField;
			
			var fmt:TextFormat = txt.defaultTextFormat;
			fmt.size = size;
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
			if(height == 0)	txt.height = size*HEIGHT_COEFFICIENT;
			
			return txt;
		}
	}
}