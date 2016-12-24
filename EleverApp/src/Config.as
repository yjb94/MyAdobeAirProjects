package
{
	public class Config		//상수 모아놓는 곳.
	{
		public static const OriginalWidth:Number=540; //타겟 해상도의 원본 가로
		public static const OriginalHeight:Number=960; //타겟 해상도의 원본 세로
		
		public static const TOP_MARGIN:Number = 41;
		
		public static function rand(from:int, to:int):int
		{
			return from + (to + 1 - from) * Math.random();
		}
	}
}