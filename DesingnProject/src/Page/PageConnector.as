package Page
{
	import Page.Home.Home;
	import Page.Home.Result;

	public class PageConnector
	{
		private static const PageClass:Object=
		{
			"HomePage":Page.Home.Home,
			"ResultPage":Page.Home.Result
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