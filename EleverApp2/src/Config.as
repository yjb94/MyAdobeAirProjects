package
{
	public class Config		//상수 모아놓는 곳.
	{
		public static const OriginalWidth:Number = 640; //타겟 해상도의 원본 가로
		public static const OriginalHeight:Number = 1136; //타겟 해상도의 원본 세로
		
		public static const MainBGColor:uint = 0xebebeb;
		
		public static const TOP_MARGIN:Number = 41;
		
		public static const SERVER_PATH:String="http://192.168.0.53:8080/eleverapp/";
		
		public static const VERSION_NUMBER:String = "0.9.9";
		
		public static function rand(from:int, to:int):int
		{
			return from + (to + 1 - from) * Math.random();
		}
	}
}