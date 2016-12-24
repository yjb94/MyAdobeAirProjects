package SideMenu
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class SideMenu extends Sprite
	{
		private static const SIDE_MENU_OPEN_DURATION:Number = 0.3;
		private static const GESTURE_TOUCH_LENGTH:Number = 100;
		
		private var _isOpen:Boolean = false;
		
		private var _downPos:Point;
		
		private var _touched_outside:Boolean = false;
		
		public function SideMenu(bg:Bitmap):void
		{
			super();
			
			addChild(bg);
			
			this.x = -this.width;
		}
		
		private function onStageMouseDown(e:MouseEvent):void
		{
			if(!(x <= mouseX && mouseX <= x+width))	//while touched outside
				_touched_outside = true;;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseEvent);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseEvent);
			_downPos = new Point(mouseX, mouseY);
		}
		private function onStageMouseEvent(e:MouseEvent):void
		{
			if(e.type == MouseEvent.MOUSE_MOVE)
			{
				
			}
			else if(e.type == MouseEvent.MOUSE_UP)
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseEvent);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseEvent);
				if(_touched_outside)
					open();
				
				if(Point.distance(_downPos, new Point(mouseX, mouseY)) < 10)
					return;
				
				if(_downPos.x - GESTURE_TOUCH_LENGTH >= mouseX)
					open();
			}
		}
		
		private var _tweenComplete:Boolean = true;
		public function open():void
		{
			if(!_tweenComplete) return;
			
			if(_isOpen)
			{
				TweenLite.to(this, SIDE_MENU_OPEN_DURATION, { x:0 });
				TweenLite.to(Elever.Main.topLayer, SIDE_MENU_OPEN_DURATION, { x:this.width });
				TweenLite.to(Elever.Main.pageLayer, SIDE_MENU_OPEN_DURATION, { x:this.width, onComplete:tweenEnded });
				
				stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
			}
			else
			{
				TweenLite.to(this, SIDE_MENU_OPEN_DURATION, { x:-this.width });
				TweenLite.to(Elever.Main.topLayer, SIDE_MENU_OPEN_DURATION, { x:0 });
				TweenLite.to(Elever.Main.pageLayer, SIDE_MENU_OPEN_DURATION, { x:0, onComplete:tweenEnded });
			
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
			}
			_tweenComplete = false;
		}
		
		private function tweenEnded():void
		{
			_isOpen = !_isOpen;
			_tweenComplete = true;
		}
	}
}