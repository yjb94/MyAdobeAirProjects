package Displays
{
	import flash.display.Bitmap;

	public class BitmapControl		//비트맵관련 모아놓는 곳.
	{
		[Embed(source="assets/header/bg.png")] public static const TOP_BG:Class;
		[Embed(source="assets/header/top_margin.png")] public static const TOP_MARGIN:Class;
		[Embed(source="assets/header/button_prev.png")] public static const PREV_BUTTON:Class;
		[Embed(source="assets/header/button_plus.png")] public static const PLUS_BUTTON:Class;
		[Embed(source="assets/header/button_check.png")] public static const CHECK_BUTTON:Class;
		[Embed(source="assets/header/button_ring_up.png")] public static const RING_BUTTON_UP:Class;
		[Embed(source="assets/header/button_ring_down.png")] public static const RING_BUTTON_DOWN:Class;
		[Embed(source="assets/header/logo.png")] public static const ELEVER_LOGO:Class;
		[Embed(source="assets/header/ring.png")] public static const RING:Class;
		
		[Embed(source="assets/home/Notice/mark_elever.png")] public static const MARK_ELEVER:Class;
		[Embed(source="assets/home/Notice/mark_like.png")] public static const MARK_LIKE:Class;
		[Embed(source="assets/home/Notice/see_more.png")] public static const SEE_MORE:Class;
		
		[Embed(source="assets/home/Notice/top_margin.png")] public static const BLANK_MARGIN:Class;
		
		[Embed(source="assets/utils/matrix.png")] public static const MATRIX:Class;
		
		[Embed(source="assets/home/slide_image_bg.png")] public static const SLIDE_IMAGE_BG:Class;
		[Embed(source="assets/home/slide_bg.png")] public static const SLIDE_IMAGE_TOP:Class;
		[Embed(source="assets/home/main_bg.png")] public static const HOME_MAIN_BG:Class;
		[Embed(source="assets/home/make_up.png")] public static const MAKE_UP:Class;
		[Embed(source="assets/home/make_down.png")] public static const MAKE_DOWN:Class;
		[Embed(source="assets/home/learn_up.png")] public static const LEARN_UP:Class;
		[Embed(source="assets/home/learn_down.png")] public static const LEARN_DOWN:Class;
		[Embed(source="assets/home/heal_up.png")] public static const HEAL_UP:Class;
		[Embed(source="assets/home/heal_down.png")] public static const HEAL_DOWN:Class;
		[Embed(source="assets/home/see_up.png")] public static const SEE_UP:Class;
		[Embed(source="assets/home/see_down.png")] public static const SEE_DOWN:Class;
		[Embed(source="assets/home/play_up.png")] public static const PLAY_UP:Class;
		[Embed(source="assets/home/play_down.png")] public static const PLAY_DOWN:Class;
		[Embed(source="assets/home/etc_up.png")] public static const ETC_UP:Class;
		[Embed(source="assets/home/etc_down.png")] public static const ETC_DOWN:Class;
		
		[Embed(source="assets/home/category/top_line.png")] public static const TOP_LINE:Class;
		[Embed(source="assets/home/category/bottom_line.png")] public static const BOTTOM_LINE:Class;
		[Embed(source="assets/home/category/bottom_line_noblank.png")] public static const BOTTOM_LINE_NO_BLANK:Class;
		[Embed(source="assets/home/category/seperate_line.png")] public static const SEPERATE_LINE:Class;
		[Embed(source="assets/home/category/item_bg.png")] public static const ITEM_BG:Class;
		[Embed(source="assets/home/category/title_bar_yellow.png")] private static const TITLE_BAR_YELLOW:Class;
		[Embed(source="assets/home/category/title_bar_red.png")] private static const TITLE_BAR_RED:Class;
		[Embed(source="assets/home/category/title_bar_blue.png")] private static const TITLE_BAR_BLUE:Class;
		public static const TITLE_BAR:Array = new Array(TITLE_BAR_YELLOW, TITLE_BAR_BLUE, TITLE_BAR_RED);
		
		[Embed(source="assets/home/itemInfo/name_bg.png")] public static const ITEM_NAME_BG:Class;
		[Embed(source="assets/home/itemInfo/dots.png")] public static const DOTS:Class;
		[Embed(source="assets/home/itemInfo/triangle.png")] public static const TRIANGLE:Class;
		[Embed(source="assets/home/itemInfo/work_hour.png")] public static const WORK_HOUR:Class;
		[Embed(source="assets/home/itemInfo/reserve_recommend.png")] public static const RESERVE_RECOMMEND:Class;
		[Embed(source="assets/home/itemInfo/reserve_ok.png")] public static const RESERVE_OK:Class;
		[Embed(source="assets/home/itemInfo/reserve_cannot.png")] public static const RESERVE_CANNOT:Class;
		[Embed(source="assets/home/itemInfo/call.png")] public static const CALL:Class;
		[Embed(source="assets/home/itemInfo/money.png")] public static const MONEY:Class;
		[Embed(source="assets/home/itemInfo/report.png")] public static const REPORT:Class;
		[Embed(source="assets/home/itemInfo/textbox.png")] public static const TEXTBOX:Class;
		[Embed(source="assets/home/itemInfo/button_see_more.png")] public static const BUTTON_SEE_MORE:Class;
		[Embed(source="assets/home/itemInfo/button_call.png")] public static const BUTTON_CALL:Class;
		[Embed(source="assets/home/itemInfo/date_popup.png")] public static const DATE_POPUP:Class;
		[Embed(source="assets/home/itemInfo/date_popup_bg.png")] public static const DATE_POPUP_BG:Class;
		
		[Embed(source="assets/home/Reserve/reserve_1.png")] public static const RESERVE_STATE_1:Class;
		[Embed(source="assets/home/Reserve/reserve_2.png")] public static const RESERVE_STATE_2:Class;
		[Embed(source="assets/home/Reserve/reserve_3.png")] public static const RESERVE_STATE_3:Class;
		public static const RESERVE_STATE:Array = new Array(RESERVE_STATE_1, RESERVE_STATE_2, RESERVE_STATE_3);
		[Embed(source="assets/home/Reserve/blue_textfield.png")] public static const BLUE_TEXTFIELD:Class;
		[Embed(source="assets/home/Reserve/green_textfield.png")] public static const GREEN_TEXTFIELD:Class;
		[Embed(source="assets/home/Reserve/red_textfield.png")] public static const RED_TEXTFIELD:Class;
		[Embed(source="assets/home/Reserve/blue_textbutton.png")] public static const BLUE_TEXTBUTTON:Class;
		[Embed(source="assets/home/Reserve/green_textbutton.png")] public static const GREEN_TEXTBUTTON:Class;
		[Embed(source="assets/home/Reserve/red_textbutton.png")] public static const RED_TEXTBUTTON:Class;
		[Embed(source="assets/home/Reserve/green_small_textfield.png")] public static const GREEN_SMALL_TEXTFIELD:Class;
		[Embed(source="assets/home/Reserve/blue_small_textfield.png")] public static const BLUE_SMALL_TEXTFIELD:Class;
		[Embed(source="assets/home/Reserve/red_small_textfield.png")] public static const RED_SMALL_TEXTFIELD:Class;
		
		[Embed(source="assets/temp/star.png")] public static const STAR_BLANK:Class;
		[Embed(source="assets/temp/star2.png")] public static const STAR_COLORED:Class;
		[Embed(source="assets/temp/schedule_textfield.png")] public static const SCHEDULE_TEXTFIELD:Class;
		[Embed(source="assets/temp/starbar.png")] public static const STAR_BAR:Class;
		[Embed(source="assets/temp/memobar.png")] public static const MEMO_BAR:Class;
		[Embed(source="assets/temp/textfield.png")] public static const TEXTFIELD:Class;
		[Embed(source="assets/temp/nelbobobo.png")] public static const NELBO_HEAD:Class;
		
		
		[Embed(source="assets/temp/1-1.png")] public static const ANIME_1_1:Class;
		[Embed(source="assets/temp/1-2.png")] public static const ANIME_1_2:Class;
		[Embed(source="assets/temp/1-3.png")] public static const ANIME_1_3:Class;
		[Embed(source="assets/temp/1-4.png")] public static const ANIME_1_4:Class;
		[Embed(source="assets/temp/1-5.png")] public static const ANIME_1_5:Class;
		[Embed(source="assets/temp/1-6.png")] public static const ANIME_1_6:Class;
		public static const ANIME_1:Array = new Array(ANIME_1_1, ANIME_1_2, ANIME_1_3, ANIME_1_4, ANIME_1_5, ANIME_1_6);
		
		[Embed(source="assets/temp/2-1.png")] public static const ANIME_2_1:Class;
		[Embed(source="assets/temp/2-2.png")] public static const ANIME_2_2:Class;
		[Embed(source="assets/temp/2-3.png")] public static const ANIME_2_3:Class;
		[Embed(source="assets/temp/2-4.png")] public static const ANIME_2_4:Class;
		[Embed(source="assets/temp/2-5.png")] public static const ANIME_2_5:Class;
		[Embed(source="assets/temp/2-6.png")] public static const ANIME_2_6:Class;
		[Embed(source="assets/temp/2-7.png")] public static const ANIME_2_7:Class;
		[Embed(source="assets/temp/2-8.png")] public static const ANIME_2_8:Class;
		[Embed(source="assets/temp/2-9.png")] public static const ANIME_2_9:Class;
		public static const ANIME_2:Array = new Array(ANIME_2_1, ANIME_2_2, ANIME_2_3, ANIME_2_4, ANIME_2_5, ANIME_2_6, ANIME_2_7, ANIME_2_8, ANIME_2_9);
		
		
		[Embed(source="assets/temp/3-1.png")] public static const ANIME_3_1:Class;
		[Embed(source="assets/temp/3-2.png")] public static const ANIME_3_2:Class;
		[Embed(source="assets/temp/3-3.png")] public static const ANIME_3_3:Class;
		[Embed(source="assets/temp/3-4.png")] public static const ANIME_3_4:Class;
		[Embed(source="assets/temp/3-5.png")] public static const ANIME_3_5:Class;
		[Embed(source="assets/temp/3-6.png")] public static const ANIME_3_6:Class;
		[Embed(source="assets/temp/3-7.png")] public static const ANIME_3_7:Class;
		[Embed(source="assets/temp/3-8.png")] public static const ANIME_3_8:Class;
		public static const ANIME_3:Array = new Array(ANIME_3_1, ANIME_3_2, ANIME_3_3, ANIME_3_4, ANIME_3_5, ANIME_3_6, ANIME_3_7, ANIME_3_8);
		
		
		[Embed(source="assets/temp/4-1.png")] public static const ANIME_4_1:Class;
		[Embed(source="assets/temp/4-2.png")] public static const ANIME_4_2:Class;
		[Embed(source="assets/temp/4-3.png")] public static const ANIME_4_3:Class;
		[Embed(source="assets/temp/4-4.png")] public static const ANIME_4_4:Class;
		[Embed(source="assets/temp/4-5.png")] public static const ANIME_4_5:Class;
		[Embed(source="assets/temp/4-6.png")] public static const ANIME_4_6:Class;
		[Embed(source="assets/temp/4-7.png")] public static const ANIME_4_7:Class;
		public static const ANIME_4:Array = new Array(ANIME_4_1, ANIME_4_2, ANIME_4_3, ANIME_4_4, ANIME_4_5, ANIME_4_6, ANIME_4_7);
		
		
		
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