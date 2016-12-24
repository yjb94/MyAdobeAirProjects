package Scroll
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class ScrollBar extends Sprite
	{
		private static const HEIGHT_MARGIN:Number = 5;
		private static const WIDTH_MARGIN:Number = 5;	//pixel
		private static const THICKNESS:Number = 5;		//pixel
		private static const ROUNDNESS:Number = 5;
		private static const COLOR:uint = 0x000000;
		//private static const LINE_COLOR:uint = 0xffffff;
		private static const ALPHA:Number = 0.4;
		
		private static const SCROLL_BOUND_COEFFICIENT:Number = 100;
		
		private static const FADE_OUT_DELAY:Number = 100;		//millisecond	has to be bigger than 100 to be natural
		private static const TWEEN_DELAY:Number = 0.2;			//second
		
		//scrollbar size
		private var _width:Number;		//this will be the width of page if bigger than pageWidth
		private var _height:Number;		//this will be the height of page if bigger than pageHeight
		public function get Width():Number { return _width; }
		public function set Width(value:Number):void { _width = value; onResize() }
		public function get Height():Number { return _height; }
		public function set Height(value:Number):void { _height = value; onResize(); }
		public function setSize(width:Number, height:Number):void
		{
			_width  = (width > Framework.Main.PageWidth) ? Framework.Main.PageWidth : width;		//set the scroll width
			_height = (height > Framework.Main.PageHeight) ? Framework.Main.PageHeight : height;	//set the scroll height
			onResize();
		}
		
		private static var _scrollbar:Sprite;	//main scrollbar
		public static function get scrollBar():Sprite { return _scrollbar; }
		
		private var _total_height:Number;		//the total height that will scale the bar
		
		private var _prev_y:Number = 0;
		private var _prev_height:Number = 0;
		private var _timeout_id:uint = 0;
		
		public function ScrollBar(width:Number, height:Number)
		{
			super();
			
			_width  = (width > Framework.Main.PageWidth) ? Framework.Main.PageWidth : width;		//set the scroll width
			_height = (height > Framework.Main.PageHeight) ? Framework.Main.PageHeight : height;	//set the scroll height
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			_scrollbar = new Sprite;
			addChild(_scrollbar);
			
			onResize();
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		private function onEnterFrame(e:Event):void
		{			
			this.visible = Framework.Main.isChangingPage ? false : true;	//가독성을 위한 !연산자 안붙히고 논리연산자씀.
			if((_prev_y != _scrollbar.y) || (_prev_height != _scrollbar.height))
			{
				if(_scrollbar.alpha == 0)
					TweenLite.to(_scrollbar, TWEEN_DELAY, {alpha:1});	//fade in
				
				clearTimeout(_timeout_id);
				_timeout_id = setTimeout(fadeOut, FADE_OUT_DELAY);		//set timer to fade out
				
				_prev_y = _scrollbar.y;									//save the previous pos
				_prev_height = _scrollbar.height						//save the previous height(changes when scaled)
			}
			
			//makes the scroll bar smaller when it hit top or bottom
			if(_scrollbar.y < 0)
			{
				_scrollbar.scaleY = _height/(_total_height+(Scroller.scroller.y*SCROLL_BOUND_COEFFICIENT));
				_scrollbar.y = 0;
			}
			else if(Scroller.scroller.Height-Scroller.scroller.height > Scroller.scroller.y)
			{
				_scrollbar.scaleY = _height/(_total_height+((Scroller.scroller.Height-Scroller.scroller.height-Scroller.scroller.y)*SCROLL_BOUND_COEFFICIENT));
				_scrollbar.y = _height-height-HEIGHT_MARGIN*2;
			}
			else
				_scrollbar.scaleY = _height/_total_height;
		}
		private function fadeOut():void
		{
			TweenLite.to(_scrollbar, TWEEN_DELAY, {alpha:0});
		}
		public function onResize():void
		{
			if(Scroller.scroller.height < Scroller.scroller.Height)
				return;
			
			_total_height = Scroller.scroller.height;		//sets the total height of scroll
			
			//calculates the height margins and roundness
			var scale:Number = _total_height/_height;
			var height_margin:Number = HEIGHT_MARGIN*scale;
			var roundness:Number = ROUNDNESS*scale;
			
			//makes the scrollbar
			_scrollbar.graphics.clear();
			_scrollbar.graphics.beginFill(COLOR, ALPHA);
			//_scrollbar.graphics.lineStyle(2, LINE_COLOR, ALPHA);
			_scrollbar.graphics.drawRoundRect(0, height_margin, THICKNESS, _height-height_margin*2, roundness, roundness);
			_scrollbar.graphics.endFill();
			
			//sets the scrollbar datas
			_scrollbar.x = _width - _scrollbar.width - WIDTH_MARGIN;
			_scrollbar.scaleY = _height/_total_height;
			
			_scrollbar.alpha = 0;	//to fade in when moved
			
			_prev_height = _scrollbar.height;
			_prev_y = _scrollbar.y;
		}
		public function dispose():void
		{
			if(stage) stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.visible = false;
		}
	}
}