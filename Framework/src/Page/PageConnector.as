package Page
{	
	import Page.Temp.Temp;

	public class PageConnector
	{
		private static const PageClass:Object=
		{
			"TempPage":Page.Temp.Temp,
			"Temp1_1Page":Page.Temp.Temp1_1,
			"Temp1_2Page":Page.Temp.Temp1_2,
			"Temp2Page":Page.Temp.Temp2,
			"Temp2_1Page":Page.Temp.Temp2_1,
			"Temp3Page":Page.Temp.Temp3,
			"Temp4Page":Page.Temp.Temp4
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