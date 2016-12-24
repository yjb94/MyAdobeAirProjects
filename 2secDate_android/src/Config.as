package
{
	public class Config		//상수 모아놓는 곳.
	{
		public static const firstPage:String = "ListPage";
		
		public static const OriginalWidth:Number = 1080; //타겟 해상도의 원본 가로
		public static const OriginalHeight:Number = 1920; //타겟 해상도의 원본 세로
		
		public static const InsideWidth:Number = 640; //타겟 해상도의 원본 가로
		public static const InsideHeight:Number = 1136; //타겟 해상도의 원본 세로
		
		public static const ratio:Number = InsideWidth/OriginalWidth;
		
		public static const MainBGColor:uint = 0xf4f4f4;
		
		public static const TOP_MARGIN:Number = 76*Config.ratio;
		public static const HEADER_SHADOW:Number = 26*Config.ratio;
	
//		public static const SERVER_PATH:String = "http://172.16.205.197:8080/Car/";
		public static const SERVER_PATH:String = "http://localhost:8080/Car/";
//		public static const SERVER_PATH:String="http://121.162.20.79:8080/elever/";
//		public static const SERVER_PATH:String="http://192.168.0.53:8080/elever/";
//		public static const SERVER_PATH:String="http://192.168.0.101:8080/elever/";
		
		public static const VERSION_NUMBER:String = "0.9.9";
		
		public static function rand(from:int, to:int):int
		{
			return from + (to + 1 - from) * Math.random();
		}
		public static function dateToYYYYMMDD(aDate:Date):String 
		{
			var mm:String = (aDate.month + 1).toString();
			if (mm.length < 2) mm = "0" + mm;
			
			var dd:String = aDate.date.toString();
			if (dd.length < 2) dd = "0" + dd;
			
			var yyyy:String = aDate.fullYear.toString();
			return yyyy + mm + dd;
		}
	}
}