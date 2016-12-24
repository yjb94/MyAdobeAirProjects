package Page
{
	import Page.Home.Category;
	import Page.Home.Home;
	import Page.Home.ItemInfo;
	import Page.Notice.Notice;
	import Page.Reserve.Info;
	import Page.Reserve.Main;
	import Page.Reserve.Program;
	import Page.Reserve.Popup.DatePopup;

	public class PageConnector
	{
		private static const PageClass:Object=
		{
			"HomePage":Page.Home.Home,
			"CategoryPage":Page.Home.Category,
			"ItemInfoPage":Page.Home.ItemInfo,
			
			"NoticePage":Page.Notice.Notice,
			
			"ReserveMainPage":Page.Reserve.Main,
			"ReserveMain2Page":Page.Reserve.Main2,
			"ReserveInfoPage":Page.Reserve.Info,
			"ReserveProgramPage":Page.Reserve.Program,
			
			"ReserveDatePopup":Page.Reserve.Popup.DatePopup
		};
		
		public function PageConnector()
		{
		}
		
		public static function GetPageClass(name:String):Class
		{
			return PageClass[name];
		}
	}
}