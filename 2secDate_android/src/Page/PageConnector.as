package Page
{
	import Page.Buy.Buy;
	import Page.Buy.RequestDetail;
	import Page.Buy.RequestList;
	import Page.Home.Compare;
	import Page.Home.Detail;
	import Page.Home.List;
	import Page.Login.Join;
	import Page.Login.Login;

	public class PageConnector
	{
		private static const PageClass:Object=
		{
			"LoginPage":Page.Login.Login,
			"JoinPage":Page.Login.Join,
			"ListPage":Page.Home.List,
			"DetailPage":Page.Home.Detail,
			"ComparePage":Page.Home.Compare,
			"BuyPage":Page.Buy.Buy,
			"RequestListPage":Page.Buy.RequestList,
			"RequestDetailPage":Page.Buy.RequestDetail
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