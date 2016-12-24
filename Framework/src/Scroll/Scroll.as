package Scroll
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Scroll extends Sprite
	{
		
		private static var _main:Scroll;
		public static function get scroll():Scroll { return _main; }
		
		private var _scroller:Scroller;
		public function get scroller():Scroller { return _scroller; }
		private var _scrollBar:ScrollBar;
				
		public function Scroll(isFitMode:Boolean=true, width:Number=-1, height:Number=-1, scrollDir:int=-1, beginY:Number=0)
		{
			super();
			
			_main = this;
			
			width = (width < 0) ? Framework.Main.PageWidth : width;		//set the scroll width
			height = (height < 0) ? Framework.Main.PageHeight : height;	//set the scroll height
			if(isFitMode) height = Framework.Main.PageHeight-Framework.Main.TopMargin-Framework.Main.HeaderHeight-Framework.Main.footer.height;
			
			_scroller = new Scroller(width, height, scrollDir, beginY);
			addChild(_scroller);
			
			_scrollBar = new ScrollBar(width, height);
			addChild(_scrollBar);	//add this later to show in top layer.
		}
		public function addObject(displayObj:DisplayObject):void
		{
			_scroller.addChild(displayObj);
		}
		public function dispose():void
		{
			_scroller.dispose();
			_scrollBar.dispose();
		}
		public function onResize(height:Number=-1):void
		{
			height = Framework.Main.PageHeight-Framework.Main.TopMargin-Framework.Main.HeaderHeight-Framework.Main.footer.height;
			_scroller.Height = height;
			_scrollBar.Height = height;
		}
		public function toTop():void
		{
			_scroller.toTop();
		}
	}
}