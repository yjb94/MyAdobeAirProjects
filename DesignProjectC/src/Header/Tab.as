package Header
{
	import flash.display.Sprite;

	public class Tab extends Sprite
	{
		public function Tab()
		{
			super();
		}
		
		public function dispose():void
		{
			throw new Error("dispose not overrided");
		}
	}
}