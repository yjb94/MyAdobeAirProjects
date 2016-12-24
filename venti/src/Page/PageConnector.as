package Page
{
	import Page.Buy.Buy;
	import Page.Buy.RequestDetail;
	import Page.Buy.RequestList;
	import Page.Home.AHP;
	import Page.Home.Compare;
	import Page.Home.Detail;
	import Page.Home.Home;
	import Page.Home.List;
	import Page.Home.Main;
	import Page.Home.result;
	import Page.Login.Join;
	import Page.Login.Login;

	public class PageConnector
	{
		private static const PageClass:Object=
		{
			"MainPage":Page.Home.Main,
			"HomePage":Page.Home.Home,
			"AHPPage":Page.Home.AHP,
			"ResultPage":Page.Home.result
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