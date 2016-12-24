package Displays
{
	import flash.display.Bitmap;

	public class BitmapControl		//비트맵관련 모아놓는 곳.
	{
		[Embed(source="assets/temp/logo.png")] public static const TEMP:Class;
		[Embed(source="assets/temp/button_coupleinfo_on.png")] public static const TEMP2:Class;
		[Embed(source="assets/temp/button_coupleinfo.png")] public static const TEMP3:Class;
		[Embed(source="assets/temp/bg.png")] public static const TOP_BG:Class;
		[Embed(source="assets/temp/button_prev.png")] public static const PREV_BUTTON:Class;
		[Embed(source="assets/temp/slideBG.png")] public static const SLIDE_BG:Class;
		
		[Embed(source="assets/temp/btn1_down.png")] public static const TAB1_DOWN:Class;
		[Embed(source="assets/temp/btn1_normal.png")] public static const TAB1_UP:Class;
		[Embed(source="assets/temp/btn2_down.png")] public static const TAB2_DOWN:Class;
		[Embed(source="assets/temp/btn2_normal.png")] public static const TAB2_UP:Class;
		[Embed(source="assets/temp/btn3_down.png")] public static const TAB3_DOWN:Class;
		[Embed(source="assets/temp/btn3_normal.png")] public static const TAB3_UP:Class;
		[Embed(source="assets/temp/btn4_down.png")] public static const TAB4_DOWN:Class;
		[Embed(source="assets/temp/btn4_normal.png")] public static const TAB4_UP:Class;
		
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