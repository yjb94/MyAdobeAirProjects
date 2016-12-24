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
		public function get scrollBar():ScrollBar { return _scrollBar; }
		
		private var _noScrollBar:Boolean;
		public function get noScrollBar():Boolean { return _noScrollBar; };
				
		public function Scroll(isFitMode:Boolean=true, width:Number=-1, height:Number=-1, scrollDir:int=-1, beginY:Number=0, func_upSlide:Function=null, noScrollBar:Boolean = false)
		{
			super();
			
			_main = this;
			
			this.name = "Scroll";
			width = (width < 0) ? Elever.Main.PageWidth : width;		//set the scroll width
			height = (height < 0) ? Elever.Main.PageHeightForScroll : height;	//set the scroll height
			if(isFitMode) height = Elever.Main.PageHeightForScroll-Elever.Main.TopMargin-Elever.Main.HeaderHeight-Elever.Main.footer.height;
			
			_scroller = new Scroller(width, height, scrollDir, beginY, func_upSlide);
			addChild(_scroller);
			
			_noScrollBar = noScrollBar;
			if(!noScrollBar)
			{
				_scrollBar = new ScrollBar(width, height, _scroller);
				addChild(_scrollBar);	//add this later to show in top layer.
			}
		}
		public function addObject(displayObj:DisplayObject):void
		{
			_scroller.addChild(displayObj);
		}
		public function dispose():void
		{
			_scroller.dispose();
			if(!noScrollBar) _scrollBar.dispose();
		}
		public function onResize(height:Number=-1):void
		{
			if(height < 0) height = Elever.Main.PageHeightForScroll-Elever.Main.TopMargin-Elever.Main.HeaderHeight-Elever.Main.footer.height;
			_scroller.Height = height;
			if(!noScrollBar) _scrollBar.Height = height;
		}
		public function toTop():void
		{
			_scroller.toTop();
		}
	}
}