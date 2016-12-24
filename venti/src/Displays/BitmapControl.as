package Displays
{
	import flash.display.Bitmap;
	
	public class BitmapControl		//비트맵관련 모아놓는 곳.
	{
		[Embed(source="assets/ALL/no_smoke_down.png")] public static const NO_SMOKE_DOWN:Class;
		[Embed(source="assets/ALL/no_smoke_up.png")] public static const NO_SMOKE_UP:Class;
		[Embed(source="assets/ALL/sports_down.png")] public static const SPORTS_DOWN:Class;
		[Embed(source="assets/ALL/sports_up.png")] public static const SPORTS_UP:Class;
		[Embed(source="assets/ALL/unity_down.png")] public static const UNITY_DOWN:Class;
		[Embed(source="assets/ALL/unity_up.png")] public static const UNITY_UP:Class;
		[Embed(source="assets/ALL/local_down.png")] public static const LOCAL_DOWN:Class;
		[Embed(source="assets/ALL/local_up.png")] public static const LOCAL_UP:Class;
		[Embed(source="assets/ALL/patriot_down.png")] public static const PATRIOT_DOWN:Class;
		[Embed(source="assets/ALL/patriot_up.png")] public static const PATRIOT_UP:Class;
		[Embed(source="assets/ALL/edu_down.png")] public static const EDU_DOWN:Class;
		[Embed(source="assets/ALL/edu_up.png")] public static const EDU_UP:Class;
		[Embed(source="assets/ALL/film_down.png")] public static const FILM_DOWN:Class;
		[Embed(source="assets/ALL/film_up.png")] public static const FILM_UP:Class;
		[Embed(source="assets/ALL/traffic_down.png")] public static const TRAFFIC_DOWN:Class;
		[Embed(source="assets/ALL/traffic_up.png")] public static const TRAFFIC_UP:Class;
		[Embed(source="assets/ALL/insurance_down.png")] public static const INSURANCE_DOWN:Class;
		[Embed(source="assets/ALL/insurance_up.png")] public static const INSURANCE_UP:Class;
		[Embed(source="assets/ALL/job_down.png")] public static const JOB_DOWN:Class;
		[Embed(source="assets/ALL/job_up.png")] public static const JOB_UP:Class;
		[Embed(source="assets/ALL/volunteer_down.png")] public static const VOLUNTEER_DOWN:Class;
		[Embed(source="assets/ALL/volunteer_up.png")] public static const VOLUNTEER_UP:Class;
		[Embed(source="assets/ALL/read_down.png")] public static const READ_DOWN:Class;
		[Embed(source="assets/ALL/read_up.png")] public static const READ_UP:Class;
		[Embed(source="assets/ALL/travel_down.png")] public static const TRAVEL_DOWN:Class;
		[Embed(source="assets/ALL/travel_up.png")] public static const TRAVEL_UP:Class;
		[Embed(source="assets/ALL/baby_down.png")] public static const BABY_DOWN:Class;
		[Embed(source="assets/ALL/baby_up.png")] public static const BABY_UP:Class;
		[Embed(source="assets/ALL/game_down.png")] public static const GAME_DOWN:Class;
		[Embed(source="assets/ALL/game_up.png")] public static const GAME_UP:Class;
		[Embed(source="assets/ALL/flight_down.png")] public static const FLIGHT_DOWN:Class;
		[Embed(source="assets/ALL/flight_up.png")] public static const FLIGHT_UP:Class;
		[Embed(source="assets/ALL/fuel_down.png")] public static const FUEL_DOWN:Class;
		[Embed(source="assets/ALL/fuel_up.png")] public static const FULE_UP:Class;
		[Embed(source="assets/ALL/enter_down.png")] public static const ENTER_DOWN:Class;
		[Embed(source="assets/ALL/enter_up.png")] public static const ENTER_UP:Class;
		[Embed(source="assets/ALL/environment_down.png")] public static const ENVIRONMENT_DOWN:Class;
		[Embed(source="assets/ALL/environment_up.png")] public static const ENVIRONMENT_UP:Class;
		
		
		[Embed(source="assets/ALL/car_down.png")] public static const CAR_DOWN:Class;
		[Embed(source="assets/ALL/car_up.png")] public static const CAR_UP:Class;
		[Embed(source="assets/ALL/golf_down.png")] public static const GOLF_DOWN:Class;
		[Embed(source="assets/ALL/golf_up.png")] public static const GOLF_UP:Class;
		[Embed(source="assets/ALL/charity_down.png")] public static const CHARITY_DOWN:Class;
		[Embed(source="assets/ALL/charity_up.png")] public static const CHARITY_UP:Class;
		[Embed(source="assets/ALL/culture_down.png")] public static const CULTURE_DOWN:Class;
		[Embed(source="assets/ALL/culture_up.png")] public static const CULTURE_UP:Class;
		[Embed(source="assets/ALL/wedding_down.png")] public static const WEDDING_DOWN:Class;
		[Embed(source="assets/ALL/wedding_up.png")] public static const WEDDING_UP:Class;
		[Embed(source="assets/ALL/saving_down.png")] public static const SAVING_DOWN:Class;
		[Embed(source="assets/ALL/saving_up.png")] public static const SAVING_UP:Class;
		[Embed(source="assets/ALL/funeral_service_down.png")] public static const FUNERAL_SERVICE_DOWN:Class;
		[Embed(source="assets/ALL/funeral_service_up.png")] public static const FUNERAL_SERVICE_UP:Class;
		[Embed(source="assets/ALL/funeral_down.png")] public static const FUNERAL_DOWN:Class;
		[Embed(source="assets/ALL/funeral_up.png")] public static const FUNERAL_UP:Class;
		[Embed(source="assets/ALL/study_down.png")] public static const STUDY_DOWN:Class;
		[Embed(source="assets/ALL/study_up.png")] public static const STUDY_UP:Class;
		[Embed(source="assets/ALL/borrow_down.png")] public static const BORROW_DOWN:Class;
		[Embed(source="assets/ALL/borrow_up.png")] public static const BORROW_UP:Class;
		[Embed(source="assets/ALL/startup_down.png")] public static const STARTUP_DOWN:Class;
		[Embed(source="assets/ALL/startup_up.png")] public static const STARTUP_UP:Class;
		[Embed(source="assets/ALL/friend_down.png")] public static const FREIND_DOWN:Class;
		[Embed(source="assets/ALL/friend_up.png")] public static const FREIND_UP:Class;
		[Embed(source="assets/ALL/tax_down.png")] public static const TAX_DOWN:Class;
		[Embed(source="assets/ALL/tax_up.png")] public static const TAX_UP:Class;
		[Embed(source="assets/ALL/fund_down.png")] public static const FUND_DOWN:Class;
		[Embed(source="assets/ALL/fund_up.png")] public static const FUND_UP:Class;
		[Embed(source="assets/ALL/leisure_down.png")] public static const LEISURE_DOWN:Class;
		[Embed(source="assets/ALL/leisure_up.png")] public static const LEISURE_UP:Class;
		[Embed(source="assets/ALL/exchange_down.png")] public static const EXCHANGE_DOWN:Class;
		[Embed(source="assets/ALL/exchange_up.png")] public static const EXCHANGE_UP:Class;

		[Embed(source="assets/ALL/sex_tab.png")] public static const SEX_MALE:Class;
		[Embed(source="assets/ALL/sex_tab2.png")] public static const SEX_FEMALE:Class;
		
		[Embed(source="assets/ALL/wooribank.png")] public static const WOORIBANK:Class;
		[Embed(source="assets/ALL/wooribank_on.png")] public static const WOORIBANK_ON:Class;
		[Embed(source="assets/ALL/kbbank.png")] public static const KBBANK:Class;
		[Embed(source="assets/ALL/kbbank_on.png")] public static const KBBANK_ON:Class;
		[Embed(source="assets/ALL/kiupbank.png")] public static const KIUPBANK:Class;
		[Embed(source="assets/ALL/kiupbank_on.png")] public static const KIUPBANK_ON:Class;
		[Embed(source="assets/ALL/postbank.png")] public static const POSTBANK:Class;
		[Embed(source="assets/ALL/postbank_on.png")] public static const POSTBANK_ON:Class;
		[Embed(source="assets/ALL/hanabank.png")] public static const HANABANK:Class;
		[Embed(source="assets/ALL/hanabank_on.png")] public static const HANABANK_ON:Class;
		[Embed(source="assets/ALL/citibank.png")] public static const CITIBANK:Class;
		[Embed(source="assets/ALL/citibank_on.png")] public static const CITIBANK_ON:Class;
		[Embed(source="assets/ALL/scbank.png")] public static const SCBANK:Class;
		[Embed(source="assets/ALL/scbank_on.png")] public static const SCBANK_ON:Class;
		[Embed(source="assets/ALL/nhbank.png")] public static const NHBANK:Class;
		[Embed(source="assets/ALL/nhbank_on.png")] public static const NHBANK_ON:Class;
		[Embed(source="assets/ALL/sinhanbank.png")] public static const SINHANBANK:Class;
		[Embed(source="assets/ALL/sinhanbank_on.png")] public static const SINHANBANK_ON:Class;
		
		[Embed(source="assets/ALL/fixed_saving.png")] public static const FIXED_SAVING:Class;
		[Embed(source="assets/ALL/free_saving.png")] public static const FREE_SAVING:Class;
		
		[Embed(source="assets/ALL/3month.png")] public static const THREE_MONTH:Class;
		[Embed(source="assets/ALL/3month_on.png")] public static const THREE_MONTH_ON:Class;
		[Embed(source="assets/ALL/6month.png")] public static const SIX_MONTH:Class;
		[Embed(source="assets/ALL/6month_on.png")] public static const SIX_MONTH_ON:Class;
		[Embed(source="assets/ALL/1year.png")] public static const ONE_YEAR:Class;
		[Embed(source="assets/ALL/1year_on.png")] public static const ONE_YEAR_ON:Class;
		[Embed(source="assets/ALL/2year.png")] public static const TWO_YEAR:Class;
		[Embed(source="assets/ALL/2year_on.png")] public static const TWO_YEAR_ON:Class;
		[Embed(source="assets/ALL/3year.png")] public static const THREE_YEAR:Class;
		[Embed(source="assets/ALL/3year_on.png")] public static const THREE_YEAR_ON:Class;
		[Embed(source="assets/ALL/4year.png")] public static const FOUR_YEAR:Class;
		[Embed(source="assets/ALL/4year_on.png")] public static const FOUR_YEAR_ON:Class;
		[Embed(source="assets/ALL/5year.png")] public static const FIVE_YEAR:Class;
		[Embed(source="assets/ALL/5year_on.png")] public static const FIVE_YEAR_ON:Class;
		
		[Embed(source="assets/ALL/button_next.png")] public static const BUTTON_NEXT:Class;
		
		[Embed(source="assets/ALL/ahq/3_up.png")] public static const THREE_UP:Class;
		[Embed(source="assets/ALL/ahq/3_down.png")] public static const THREE_DOWN:Class;
		[Embed(source="assets/ALL/ahq/2_up.png")] public static const TWO_UP:Class;
		[Embed(source="assets/ALL/ahq/2_down.png")] public static const TWO_DOWN:Class;
		[Embed(source="assets/ALL/ahq/1_up.png")] public static const ONE_UP:Class;
		[Embed(source="assets/ALL/ahq/1_down.png")] public static const ONE_DOWN:Class;
		[Embed(source="assets/ALL/ahq/12_up.png")] public static const HALF_UP:Class;
		[Embed(source="assets/ALL/ahq/12_down.png")] public static const HALF_DOWN:Class;
		[Embed(source="assets/ALL/ahq/13_up.png")] public static const THONE_UP:Class;
		[Embed(source="assets/ALL/ahq/13_down.png")] public static const THONE_DOWN:Class;
		
		[Embed(source="assets/ALL/ahq/button_link.png")] public static const BUTTON_LINK:Class;
		
		
		
		
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