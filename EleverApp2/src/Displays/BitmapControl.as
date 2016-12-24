package Displays
{
	import flash.display.Bitmap;

	public class BitmapControl		//비트맵관련 모아놓는 곳.
	{
		[Embed(source="assets/header/bg.png")] public static const TOP_BG:Class;
		[Embed(source="assets/header/button_prev.png")] public static const PREV_BUTTON:Class;
		[Embed(source="assets/header/button_side.png")] public static const SIDE_BUTTON:Class;
		[Embed(source="assets/header/logo.png")] public static const ELEVER_LOGO:Class;
		
		[Embed(source="assets/footer/bg.png")] public static const BOTTOM_BG:Class;
		[Embed(source="assets/footer/btn1_down.png")] public static const TAB1_DOWN:Class;
		[Embed(source="assets/footer/btn1_up.png")] public static const TAB1_UP:Class;
		[Embed(source="assets/footer/btn2_down.png")] public static const TAB2_DOWN:Class;
		[Embed(source="assets/footer/btn2_up.png")] public static const TAB2_UP:Class;
		[Embed(source="assets/footer/btn3_down.png")] public static const TAB3_DOWN:Class;
		[Embed(source="assets/footer/btn3_up.png")] public static const TAB3_UP:Class;
		
		[Embed(source="assets/item/no_item_bg.png")] public static const ITEM_NO_IMAGE:Class;
		[Embed(source="assets/item/item_explain_bg.png")] public static const ITEM_EXPLAIN_BG:Class;
		
		[Embed(source="assets/ticket/cancel_button.png")] public static const BUTTON_TICKET_CANCEL:Class;
		[Embed(source="assets/ticket/dot_up.png")] public static const TICKET_DOT_UP:Class;
		[Embed(source="assets/ticket/dot_down.png")] public static const TICKET_DOT_DOWN:Class;
		
		[Embed(source="assets/setting/next_button.png")] public static const SETTING_NEXT_BUTTON:Class;
		[Embed(source="assets/setting/on_button.png")] public static const SETTING_ON_BUTTON:Class;
		[Embed(source="assets/setting/off_button.png")] public static const SETTING_OFF_BUTTON:Class;
		
		[Embed(source="assets/setting/purchase/1month_up.png")] public static const PURCHASE_1MONTH_ON:Class;
		[Embed(source="assets/setting/purchase/1month_down.png")] public static const PURCHASE_1MONTH_DOWN:Class;
		[Embed(source="assets/setting/purchase/6month_up.png")] public static const PURCHASE_6MONTH_ON:Class;
		[Embed(source="assets/setting/purchase/6month_down.png")] public static const PURCHASE_6MONTH_DOWN:Class;
		[Embed(source="assets/setting/purchase/1year_up.png")] public static const PURCHASE_1YEAR_ON:Class;
		[Embed(source="assets/setting/purchase/1year_down.png")] public static const PURCHASE_1YEAR_DOWN:Class;
		
		[Embed(source="assets/header/slideBG.png")] public static const SLIDE_BG:Class;
		[Embed(source="assets/header/TabBar_anchor.png")] public static const TABBAR_ANCHOR:Class;
		
		[Embed(source="assets/side_menu/bg.png")] public static const SIDE_MENU_BG:Class;
		
		[Embed(source="assets/popup/bg.png")] public static const POPUP_BG:Class;
		[Embed(source="assets/popup/yes.png")] public static const POPUP_YES:Class;
		[Embed(source="assets/popup/no.png")] public static const POPUP_NO:Class;
		[Embed(source="assets/popup/ok.png")] public static const POPUP_OK:Class;
		
		[Embed(source="assets/temp/button_male_on.png")] public static const TEMP_BUTTON_DOWN:Class;
		[Embed(source="assets/temp/button_male.png")] public static const TEMP_BUTTON_UP:Class;
		
		[Embed(source="assets/temp/temp_noimage.png")] public static const TEMP_NO_IMAGE:Class;
		[Embed(source="assets/temp/dot_selected.png")] public static const TEMP_DOT_DOWN:Class;
		[Embed(source="assets/temp/dot_unselected.png")] public static const TEMP_DOT_UP:Class;
		
		[Embed(source="assets/temp/button_next.png")] public static const BUTTON_NEXT_UP:Class;
		[Embed(source="assets/temp/button_next_on.png")] public static const BUTTON_NEXT_DOWN:Class;
		
		[Embed(source="assets/temp/temp_slide_bg.png")] public static const TEMP_SLIDE_BG:Class;
		[Embed(source="assets/temp/temp_slide_mask.png")] public static const TEMP_SLIDE_MASK:Class;
		
		[Embed(source="assets/temp/textField.png")] public static const TEXTFIELD:Class;
		
		
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