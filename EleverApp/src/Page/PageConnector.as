package Page
{
	import Page.Home.Home;
	import Page.Main.Main;

	public class PageConnector
	{
		private static const PageClass:Object=
		{
			"MainPage":Page.Main.Main,
			"HomePage":Page.Home.Home
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