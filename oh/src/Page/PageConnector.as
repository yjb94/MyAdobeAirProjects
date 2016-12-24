package Page
{
	import Page.Home.AddPage;
	import Page.Home.GrowPage;
	import Page.Home.Home;
	
	public class PageConnector
	{
		private static const PageClass:Object=
		{
			"HomePage":Page.Home.Home,
			"AddPage":Page.Home.AddPage,
			"GrowPage":Page.Home.GrowPage
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