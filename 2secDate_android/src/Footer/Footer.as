package Footer
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Footer extends Sprite
	{
		public function Footer():void
		{
			super();
			addEventListener(Event.RESIZE, onResize);
		}
		public function onResize(e:Event=null):void
		{
			(this.getChildAt(0) as TabBar).onResize(e);
		}
		public function changePage(page_name:String=null, page_params:Object=null):void
		{
			for(var i:int = 0; i < this.numChildren; i++)
				(this.getChildAt(i) as Footer).changePage(page_name);
		}
	}
}