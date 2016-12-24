package Displays
{
	import flash.display.Bitmap;
	
	public class BitmapControl		//비트맵관련 모아놓는 곳.
	{
		[Embed(source="assets/home/calc.png")] public static const CALCULATE_BUTTON:Class;
		
		[Embed(source="assets/header/bg.png")] public static const TOP_BG:Class;
		[Embed(source="assets/header/top_margin.png")] public static const TOP_MARGIN:Class;
		[Embed(source="assets/header/button_prev.png")] public static const PREV_BUTTON:Class;
		
		[Embed(source="assets/popup/bg.png")] public static const POPUP_BG:Class;
		[Embed(source="assets/popup/yes.png")] public static const POPUP_YES:Class;
		[Embed(source="assets/popup/no.png")] public static const POPUP_NO:Class;
		[Embed(source="assets/popup/ok.png")] public static const POPUP_OK:Class;
		
		[Embed(source="assets/home/Reserve/textbox.png")] public static const RESERVE_TEXTBOX:Class;
		
		
		public static function newBitmap(file_name:Class, x_pos:Number=0, y_pos:Number=0, isVectorPos:Boolean=false, alpha:Number=1):Bitmap
		{
			var bmp:Bitmap = new file_name;
			bmp.smoothing = false;
			bmp.x = x_pos - ((isVectorPos) ? bmp.width/2  : 0);
			bmp.y = y_pos - ((isVectorPos) ? bmp.height/2 : 0);
			bmp.alpha = alpha;
			return bmp;
		}
	}
}