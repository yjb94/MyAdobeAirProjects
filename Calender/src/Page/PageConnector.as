package Page
{	
	import Page.Main.AddPage;
	import Page.Main.DetailPage;
	import Page.Main.MainPage;
	
	public class PageConnector
	{
		private static const PageClass:Object=
		{
			"MainPage":Page.Main.MainPage,
			"AddPage":Page.Main.AddPage,
			"DetailPage":Page.Main.DetailPage
		};
		
		public static function GetPageClass(name:String):Class
		{
			return PageClass[name];
		}
	}
}