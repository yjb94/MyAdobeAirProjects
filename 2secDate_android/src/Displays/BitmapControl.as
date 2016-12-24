package Displays
{
	import flash.display.Bitmap;
	
	public class BitmapControl		//비트맵관련 모아놓는 곳.
	{
		[Embed(source="assets/header/bg.png")] public static const TOP_BG:Class;
		[Embed(source="assets/header/top_margin.png")] public static const TOP_MARGIN:Class;
		[Embed(source="assets/header/button_prev.png")] public static const PREV_BUTTON:Class;
		
		[Embed(source="assets/popup/bg.png")] public static const POPUP_BG:Class;
		[Embed(source="assets/popup/yes.png")] public static const POPUP_YES:Class;
		[Embed(source="assets/popup/no.png")] public static const POPUP_NO:Class;
		[Embed(source="assets/popup/ok.png")] public static const POPUP_OK:Class;
		
		[Embed(source="assets/home/List/item_bg.png")] public static const ITEM_BG:Class;
		[Embed(source="assets/home/List/item_mask_bg.png")] public static const ITEM_MASK_BG:Class;
		[Embed(source="assets/home/List/seperate_line.png")] public static const SEPERATE_LINE:Class;
		
		[Embed(source="assets/home/Detail/button_close.png")] public static const BUTTON_CLOSE:Class;
		[Embed(source="assets/home/Detail/info_slide_top_bg.png")] public static const INFO_SLIDE_TOP_BG:Class;
		[Embed(source="assets/home/Detail/top_triangle.png")] public static const TOP_TRIANGLE:Class;
		[Embed(source="assets/home/Detail/button_select.png")] public static const BUTTON_SELECT:Class;
		[Embed(source="assets/home/Detail/button_request.png")] public static const BUTTON_REQUEST:Class;
		[Embed(source="assets/home/Detail/star_blank.png")] public static const STAR_BLANK:Class;
		[Embed(source="assets/home/Detail/star_color.png")] public static const STAR_COLORED:Class;
		[Embed(source="assets/home/Detail/option_bg.png")] public static const OPTION_BG:Class;
		[Embed(source="assets/home/Detail/option_bg_off.png")] public static const OPTION_BG_OFF:Class;
		
		[Embed(source="assets/home/Compare/car_mask.png")] public static const CAR_MASK:Class;
		[Embed(source="assets/home/Compare/select_car.png")] public static const SELECT_CAR:Class;
		[Embed(source="assets/home/Compare/top_bg.png")] public static const COMPARE_TOP_BG:Class;
		[Embed(source="assets/home/Compare/bg.png")] public static const COMPARE_BG:Class;
		
		[Embed(source="assets/login/textbox.png")] public static const TEXTBOX:Class;
		[Embed(source="assets/login/login_button.png")] public static const LOGIN_BUTTON:Class;
		[Embed(source="assets/login/join_button.png")] public static const JOIN_BUTTON:Class;
		[Embed(source="assets/login/logout_button.png")] public static const LOGOUT_BUTTON:Class;
		[Embed(source="assets/login/is_seller_on.png")] public static const IS_SELLER_ON:Class;
		[Embed(source="assets/login/is_seller_up.png")] public static const IS_SELLER_UP:Class;
		
		[Embed(source="assets/home/Buy/reserve_seperate_line.png")] public static const BUY_SEPERATE_LINE:Class;
		[Embed(source="assets/home/Buy/complete.png")] public static const BUY_COMPLETE_BUTTON:Class;
		[Embed(source="assets/home/Buy/term_agree.png")] public static const TERM_AGREE:Class;
		[Embed(source="assets/home/Buy/term_disagree.png")] public static const TERM_DISAGREE:Class;
		
		[Embed(source="assets/home/Buy/RequestList/item_bg.png")] public static const REQUEST_ITEM_BG:Class;
		[Embed(source="assets/home/Buy/RequestList/item_mask_bg.png")] public static const REQUEST_CAR_MASK:Class;
		[Embed(source="assets/home/Buy/RequestList/button_call.png")] public static const BUTTON_CALL:Class;
		[Embed(source="assets/home/Buy/RequestList/button_mail.png")] public static const BUTTON_MAIL:Class;
		
		[Embed(source="assets/footer/btn1_down.png")] public static const TAB1_DOWN:Class;
		[Embed(source="assets/footer/btn1_normal.png")] public static const TAB1_UP:Class;
		[Embed(source="assets/footer/btn2_down.png")] public static const TAB2_DOWN:Class;
		[Embed(source="assets/footer/btn2_normal.png")] public static const TAB2_UP:Class;
		[Embed(source="assets/footer/btn3_down.png")] public static const TAB3_DOWN:Class;
		[Embed(source="assets/footer/btn3_normal.png")] public static const TAB3_UP:Class;
		[Embed(source="assets/footer/btn4_down.png")] public static const TAB4_DOWN:Class;
		[Embed(source="assets/footer/btn4_normal.png")] public static const TAB4_UP:Class;
		
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