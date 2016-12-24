package Page
{
	import flash.display.Sprite;
	
	public class BasePage extends Sprite
	{		
		public function BasePage(params:Object=null)
		{
			super();
		}
		
		public function init():void
		{
			throw new Error("init 함수가 override되지 않았습니다.");
		}
		
		public function onResize():void
		{
			throw new Error("onResize 함수가 override되지 않았습니다.");
		}
		
		public function dispose():void
		{
			throw new Error("dispose 함수가 override되지 않았습니다.");
		}
	}
}