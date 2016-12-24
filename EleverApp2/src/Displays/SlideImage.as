package Displays
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import Displays.BitmapControl;
	
	import Scroll.Scroll;
	
	public class SlideImage extends Sprite
	{
		private const MOVE_PER_TOUCH:Number = 0.7;
		private const TWEEN_DURATION:Number = 0.2;
		
		private var _items:Sprite;
		private var _items_callback:Vector.<Function> = new Vector.<Function>;
		
		private var _prevPos:Point = new Point;
		private var _distance:Number;
		
		private var _anchor_changed:Boolean = false;
		private var _anchor_index:int;
		
		private var _doTween:Boolean = false;
		
		private var _isDrag:Boolean = false;
		
		private var _alpha:Number;
		
		private var _scroll:Scroll;
				
		public function SlideImage(file_name:Class, alpha:Number=1, scroll:Scroll=null):void
			//indexNum 은 홀수 입력할것. 3-5민
		{
			super();
			
			_anchor_index = 0;
			if(scroll) _scroll = scroll;
			
			_alpha = alpha;
			this.alpha = alpha;
			this.name = "SlideBar";
			addChild(BitmapControl.newBitmap(file_name, 0, 0, false, 1));
			
			_items = new Sprite;
			addChild(_items);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		private function onEnterFrame(e:Event):void
		{
			if(_doTween)
			{
				_doTween = false;
				
				if(_distance < 0 && _anchor_index < _items.numChildren-1)	//right direction
				{
					_anchor_index++;
					_anchor_changed = true;
				}
				else if(_distance > 0 && _anchor_index > 0)	//left direction
				{
					_anchor_index--;
					_anchor_changed = true;
				}
				TweenLite.to(_items, TWEEN_DURATION, { x:AnchorXPos, onComplete:onTweenEnd });
				
				if(_anchor_changed)
				{
					if(_items_callback[_anchor_index] != null)
						_items_callback[_anchor_index](_anchor_index);
					_anchor_changed = false;
				}
			}
		}
		private function onTweenEnd():void
		{
			setAlpha();
		}
		private function onMouseDown(e:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);

			if(_items.numChildren > 0)
			{
				_scroll.scroller.doNotScroll = true;
				
				_prevPos.x = this.mouseX;
				_prevPos.y = this.mouseY;
				
				_distance = 0;
				
				_isDrag = false;
			}
		}
		private function onMouseMove(e:MouseEvent):void
		{
			_scroll.scroller.doNotScroll = true;
			
			if(_items.numChildren > 0)
			{	
				if(Point.distance(_prevPos, new Point(mouseX, _prevPos.y)) < 10)	//not dragged
					return;
				_isDrag = true;
				
				//move items.
				_distance = this.mouseX - _prevPos.x;
				if(_distance > 0)
				{
					if(_anchor_index > 0)
					{
						setVisible(_anchor_index-1);
					}
				}
				else 
				{
					if(_anchor_index < _items.numChildren-1)
					{
						setVisible(_anchor_index+1);
					}
				}
				_items.x += _distance*MOVE_PER_TOUCH;
				_prevPos.x = this.mouseX;
			}
		}
		private function onMouseUp(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			_scroll.scroller.doNotScroll = false;
			
			if(_isDrag)
			{
				if(_distance > 0)
				{
					if(_anchor_index > 0)
					{
						setAnchor(_anchor_index-1);
						_anchor_changed = true;
					}
				}
				else 
				{
					if(_anchor_index < _items.numChildren-1)
					{
						setAnchor(_anchor_index+1);
						_anchor_changed = true;
					}
				}
			}
			
			_doTween = true;
		}
		public function addItem(display:DisplayObject, callback:Function):void
		{
			_items.addChild(display);
			placeItem(_items.numChildren-1);
			_items_callback.push(callback);
		}
		public function setAnchor(index:int):void
		{
			if(_anchor_index == index) return;
			_anchor_index = index;
			
			_distance = 0;
			_doTween = true;
			_anchor_changed = true;
			
			//setAlpha();
		}
		public function clear():void
		{
			while(_items.numChildren)
				_items.removeChildAt(_items.numChildren-1);
		}
		private function placeItem(index:int):void
		{
			//place item for each index.
			var obj:DisplayObject = _items.getChildAt(index);
			obj.x = Elever.Main.PageWidth*index + Elever.Main.PageWidth/2 - obj.width/2;
			obj.y = this.height/2 - obj.height/2;
			
			setAlpha();
		}
		private function get AnchorXPos():Number
		{			
			return (-_anchor_index)*Elever.Main.PageWidth;
		}
		private function setAlpha():void
		{
			for(var i:int = 0; i < _items.numChildren; i++)
			{
				_items.getChildAt(i).visible = (i == _anchor_index) ? true : false;
				_items.getChildAt(i).alpha = (i == _anchor_index) ? 1.0 : 0.6;
			}
		}
		private function setVisible(index:int):void
		{
			_items.getChildAt(index).visible = true;
		}
	}
}