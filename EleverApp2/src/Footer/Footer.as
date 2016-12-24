package Footer
{
	import flash.display.Sprite;
	
	public class Footer extends Sprite
	{
		public function Footer():void
		{
			super();
		}
		public function changePage(page_name:String=null, page_params:Object=null):void
		{
			for(var i:int = 0; i < this.numChildren; i++)
				(this.getChildAt(i) as Footer).changePage(page_name);
		}
	}
}