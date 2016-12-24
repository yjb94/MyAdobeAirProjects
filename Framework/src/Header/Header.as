package Header
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Header extends Sprite
	{
		protected static const DISABLE_TWEEN_DURATION:Number = 0.25;
		
		public function Header():void
		{
			super();
			
			addEventListener(Event.RESIZE, onResize);
		}
		public function onResize(e:Event=null):void
		{
			for(var i:int = 0; i < this.numChildren; i++)
			{
				var total_height:Number = 0;
				for(var j:int = 0; j < i; j++)
				{
					total_height += this.getChildAt(j).height;
				}
				this.getChildAt(i).y = Framework.Main.TopMargin + total_height;
			}
		}
		public function getYByName(name:String):Number
		{
			var height:Number = 0;
			for(var i:int = 0; i < this.numChildren; i++)
			{
				if(this.getChildAt(i) != this.getChildByName(name))
					height += this.getChildAt(i).height;
				else
					break;
			}
			return height + this.y + Framework.Main.TopMargin;
		}
		public function changePage(page_name:String=null, page_params:Object=null):void
		{
			for(var i:int = 0; i < this.numChildren; i++)
				(this.getChildAt(i) as Header).changePage(page_name, page_params);
		}
		public function clear():void
		{
			
		}
	}
}