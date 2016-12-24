package Displays
{
	import flash.display.Bitmap;

	public class BitmapControl		//비트맵관련 모아놓는 곳.
	{
		[Embed(source="assets/temp/bg.png")] public static const TOP_BG:Class;
		[Embed(source="assets/temp/button_prev.png")] public static const PREV_BUTTON:Class;
		[Embed(source="assets/temp/button_plus.png")] public static const PLUS_BUTTON:Class;
		[Embed(source="assets/temp/button_check.png")] public static const CHECK_BUTTON:Class;
		[Embed(source="assets/temp/plus.png")] public static const PLUS:Class;
		[Embed(source="assets/temp/minus.png")] public static const MINUS:Class;
		
		public static function newBitmap(file_name:Class, x_pos:Number=0, y_pos:Number=0, isVectorPos:Boolean=false, alpha:Number=1):Bitmap
		{
			var bmp:Bitmap = new file_name;
			bmp.smoothing = true;
			bmp.x = x_pos - ((isVectorPos) ? bmp.width/2  : 0);
			bmp.y = y_pos - ((isVectorPos) ? bmp.height/2 : 0);
			bmp.alpha = alpha;
			return bmp;
		}
	}
}