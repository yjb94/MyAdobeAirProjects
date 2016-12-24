package Displays
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAspectRatio;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.GesturePhase;
	import flash.events.MouseEvent;
	import flash.events.StageOrientationEvent;
	import flash.events.TouchEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import Displays.BitmapControl;
	
	import Scroll.Scroll;
	
	import fl.motion.MatrixTransformer;
	
	public class SlideImage extends Sprite
	{
		private const ZOOM_MOVE_PER_TOURCH:Number = 0.11;
		private const MOVE_PER_TOUCH:Number = 0.7;
		private const TWEEN_DURATION:Number = 0.2;
		private const RESET_TWEEN_DURATION:Number = 0.1;
		private const ZOOM_TOP_LIMIT:Number = 300;
		
		private var _items:Sprite;
		public function get Item():Sprite { return _items; }
		private var _items_callback:Vector.<Function> = new Vector.<Function>;
		
		private var _prevPos:Point = new Point;
		private var _distance:Number;
		
		private var _anchor_changed:Boolean = false;
		private var _anchor_index:int;
		public function get Index():int { return _anchor_index; }
		
		private var _doTween:Boolean = false;
		
		private var _isDrag:Boolean = false;
		
		private var _alpha:Number;
		
		private var _scroll:Scroll;
		
		private var _is_zoom_mode:Boolean;
		private var _is_zoomed:Boolean = false;
		
		private var _touched_fingers:int = 0;
						
		public function SlideImage(file_name:Class, alpha:Number=1, scroll:Scroll=null, topImage:Class=null, zoom_mode:Boolean=false):void
			//indexNum 은 홀수 입력할것. 3-5민
		{
			super();
			
			_is_zoom_mode = zoom_mode;
			
			_anchor_index = 0;
			if(scroll) _scroll = scroll;
			
			_alpha = alpha;
			this.alpha = alpha;
			this.name = "SlideBar";
			if(file_name != null) addChild(BitmapControl.newBitmap(file_name, 0, 0, false, 1));
			
			_items = new Sprite;
			addChild(_items);
						
			if(topImage)
				addChild(BitmapControl.newBitmap(topImage, 0, 0, false, 1));
			
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
				
				if(!_is_zoomed)
				{
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
					if(_is_zoom_mode && _zoom)
						TweenLite.to(_zoom_items, TWEEN_DURATION, { x:zoomAnchorXPos });
					
					if(_anchor_changed)
					{
						if(_items_callback[_anchor_index] != null)
							_items_callback[_anchor_index](_anchor_index);
						_anchor_changed = false;
					}
				}
				else
				{
//					var item:Sprite = _zoom_items.getChildAt(_anchor_index) as Sprite;
//					if(item.x > 0)
//					{
//						TweenLite.to(item, TWEEN_DURATION, { x:0 });
//					}
//					else if(item.x + item.width < stage.stageWidth)
//					{
//						TweenLite.to(item, TWEEN_DURATION, { x:stage.stageWidth-item.width });
//					}
//
//					if(item.y < -ZOOM_TOP_LIMIT*item.scaleY)
//					{
//						TweenLite.to(item, TWEEN_DURATION, { y:-ZOOM_TOP_LIMIT*item.scaleY });
//					}
//					else if(item.y + item.height > stage.stageHeight)
//					{
//						TweenLite.to(item, TWEEN_DURATION, { x:stage.stageHeight-item.height });
//					}
				}
			}
		}
		private function onTweenEnd():void
		{
			setAlpha();
		}
		private function onMouseDown(e:MouseEvent):void
		{			
			if(_zoom && _touched_fingers > 1)
				return;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);

			if(_items.numChildren > 0)
			{
				if(_scroll) _scroll.scroller.doNotScroll = true;
				
				_prevPos.x = this.mouseX;
				_prevPos.y = this.mouseY;
				
				_distance = 0;
				
				_isDrag = false;
			}
		}
		private function onMouseMove(e:MouseEvent):void
		{
			if(_is_zoomed)	//zoom Mouse Move
			{
				(_zoom_items.getChildAt(_anchor_index) as Sprite).startDrag();
				return;
			}
			
			if(_zoom && _touched_fingers > 1)
				return;
			
			if(_scroll) _scroll.scroller.doNotScroll = true;
			
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
				if(_zoom)
					_zoom_items.x += _distance*MOVE_PER_TOUCH;
				else
					_items.x += _distance*MOVE_PER_TOUCH;
				_prevPos.x = this.mouseX;
			}
		}
		private function onMouseUp(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			if(_is_zoomed)		//zoom Mouse Up
			{
				(_zoom_items.getChildAt(_anchor_index) as Sprite).stopDrag();
				//_doTween = true;
				return;
			}
			
			if(_zoom && _touched_fingers > 1)
				return;
			
			if(_scroll) _scroll.scroller.doNotScroll = false;
			
			if(_isDrag)
			{
				if(_distance > 0)
				{
					if(_anchor_index > 0)
					{
						if(_zoom)
							resetZoomItemPos(_anchor_index);
						setAnchor(_anchor_index-1);
						_anchor_changed = true;
					}
				}
				else 
				{
					if(_anchor_index < _items.numChildren-1)
					{
						if(_zoom)
							resetZoomItemPos(_anchor_index);
						setAnchor(_anchor_index+1);
						_anchor_changed = true;
					}
				}
			}
			else
			{
				if(_is_zoom_mode)
				{
					if(!_zoom)
						zoomIn();
				}
			}
			
			_doTween = true;
		}
		private var _zoom:Sprite = null;
		private var _zoom_items:Sprite;
		public function isZoomed():Boolean { return (_zoom) ? true : false; }
		private function isAllLoaded():Boolean
		{
			for(var i:int = 0; i < _items.numChildren; i++)
			{
				if((_items.getChildAt(i) as WebImage).Content == null)
					return false;
			}
			return true;
		}
		public function zoomIn(index:int=-1):void
		{
			if(!isAllLoaded())
				return;
			
			if(index == -1)
				index = _anchor_index;
			if(_scroll) _scroll.scroller.doNotScroll = true;
			
			stage.setAspectRatio(StageAspectRatio.ANY);
			stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, orientationChangeEvent);
			stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGING, orientationChangeEvent);
			
			_zoom = new Sprite;
			_zoom.graphics.beginFill(0x000000);
			_zoom.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			_zoom.graphics.endFill();
			_zoom.alpha = 0;
			_zoom_items = new Sprite;
			_zoom.addChild(_zoom_items);
			
			for(var i:int = 0; i < _items.numChildren; i++)
			{
				var spr:Sprite = new Sprite;
				var bmp:Bitmap = new Bitmap((_items.getChildAt(i) as WebImage).Content.bitmapData);
				spr.addChild(bmp);
				
				bmp.width = stage.stageWidth;
				bmp.scaleY = bmp.scaleX;
				if(bmp.height > stage.stageHeight)
				{
					bmp.height = stage.stageHeight;
					bmp.scaleX = bmp.scaleY;
				}
				
				bmp.x = stage.stageWidth*i;
				bmp.y = stage.stageHeight/2 - bmp.height/2;
				
				_zoom_items.addChild(spr);
				spr.addEventListener(TransformGestureEvent.GESTURE_ZOOM, zoomGestureEvent);
				spr.addEventListener(MouseEvent.MOUSE_MOVE, zoomMouseEvent);
			}
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			_zoom.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchEvent);
			_zoom.addEventListener(TouchEvent.TOUCH_END, onTouchEvent);
			
			_zoom_items.x += stage.stageWidth*(-index);
			
			TweenLite.to(_zoom, TWEEN_DURATION, { alpha:1 });
			
			_zoom.addEventListener(MouseEvent.MOUSE_DOWN , onMouseDown);
			_zoom.addEventListener(MouseEvent.DOUBLE_CLICK , onDoubleClick);
			
			var btn:Button = new Button(BitmapControl.BUTTON_CLOSE, BitmapControl.BUTTON_CLOSE, zoomOut, 0, Elever.Main.TopMargin + 10);
			btn.scaleX = 0.6;
			btn.scaleY = btn.scaleX;
			btn.x = stage.stageWidth - btn.width;
			_zoom.addChild(btn);
			
			stage.addChild(_zoom);
		}
		private var _is_portrait:Boolean = true;
		private function orientationChangeEvent(e:StageOrientationEvent):void
		{
			if(e.type == StageOrientationEvent.ORIENTATION_CHANGE)
			{
				_is_portrait = !_is_portrait;
				
				_zoom.graphics.clear();
				
				_zoom.graphics.beginFill(0x000000);
				_zoom.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
				_zoom.graphics.endFill();
				
				for(var i:int = 0; i < _zoom_items.numChildren; i++)
				{
					var bmp:Bitmap = (_zoom_items.getChildAt(i) as Sprite).getChildAt(0) as Bitmap;
					
					bmp.width = stage.stageWidth;
					bmp.scaleY = bmp.scaleX;
					
					bmp.x = stage.stageWidth*i;
					bmp.y = stage.stageHeight/2 - bmp.height/2;
				}
				_zoom_items.x = zoomAnchorXPos;
			}
			else if(e.type == StageOrientationEvent.ORIENTATION_CHANGING)
			{
				_zoom.graphics.clear();
				
				_zoom.graphics.beginFill(0x000000);
				_zoom.graphics.drawRect(0, 0, stage.stageHeight, stage.stageHeight);
				_zoom.graphics.endFill();
			}
		}
		private function onDoubleClick(e:MouseEvent):void
		{
			if(_is_zoomed)
				resetZoomItemPos(_anchor_index);
			else
			{
				TweenLite.to(_zoom_items.getChildAt(_anchor_index), RESET_TWEEN_DURATION, { scaleX:2, scaleY:2, x:-e.localX, y:-e.localY });
				
				_is_zoomed = true;
			}
		}
		private function onTouchEvent(e:TouchEvent):void
		{
			if(e.type == TouchEvent.TOUCH_BEGIN)
			{
				if(!_isDrag)
					_touched_fingers++;
			}
			else if(e.type == TouchEvent.TOUCH_END)
			{
				if(_touched_fingers > 0)
					_touched_fingers--;
			}
			
			if(_touched_fingers >= 2)
			{
				Multitouch.inputMode = MultitouchInputMode.GESTURE;
			}
			else
			{
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			}
		}
		private function zoomGestureEvent(e:TransformGestureEvent):void
		{
			if(e.type == TransformGestureEvent.GESTURE_ZOOM)
			{				
				var item:Sprite = _zoom_items.getChildAt(_anchor_index) as Sprite;
				
				var scale_x:Number = item.scaleX*e.scaleX;
				var scale_y:Number = item.scaleY*e.scaleY;

				if(scale_x > 4) scale_x = 4;
				if(scale_x < 1.1) scale_x = 1;
//				if(scale_y > 4) scale_y = 4;
//				if(scale_y < 1.1) scale_y = 1;
				
				_is_zoomed = ((scale_y != 1) || (scale_x != 1)) ? true : false;
				if(!_is_zoomed)
					item.stopDrag();
				
				var mat:Matrix = new Matrix();
				mat.translate(-e.localX, -e.localY);
//				mat.scale(scale_x, scale_y);
				mat.scale(scale_x, scale_x);
				mat.translate(e.localX, e.localY);
				item.transform.matrix = mat;
				
				if(e.phase == GesturePhase.END)
				{
					Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
					//_wait = true;
					_touched_fingers = 0;
				}
			}
			else if(e.type == TransformGestureEvent.GESTURE_SWIPE)
			{
				if(e.offsetX == 0)
				{
					if(e.offsetY == 1 || e.offsetY == -1)
					{
						zoomOut();
					}
				}
			}
		}
		private var _zoom_prevPos:Point = new Point;
		private function zoomMouseEvent(e:MouseEvent):void
		{
			if(_is_zoomed && _touched_fingers == 1)
			{
				var item:Sprite = _zoom_items.getChildAt(_anchor_index) as Sprite;
				if(e.type == MouseEvent.MOUSE_DOWN)
				{
					stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
					stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
					
					_zoom_prevPos.x = mouseX;
					_zoom_prevPos.y = mouseY;
				}
			}
		}
		private function resetZoomItemPos(index:int):void
		{
			var item:Sprite = _zoom_items.getChildAt(index) as Sprite;
			item.stopDrag();
			TweenLite.to(item, RESET_TWEEN_DURATION, { scaleX:1, scaleY:1, x:0, y:0 });
			_is_zoomed = false;
		}
		public function zoomOut(e:MouseEvent=null):void		//버튼 콜백 땜에 귀찮아서 넣은 마우스 이벤트임
		{
			TweenLite.to(_zoom, TWEEN_DURATION, { alpha:0, onComplete:function():void
			{
				stage.removeChild(_zoom);
				_zoom.removeEventListener(TouchEvent.TOUCH_BEGIN, onTouchEvent);
				_zoom.removeEventListener(TouchEvent.TOUCH_END, onTouchEvent);
				_zoom.removeEventListener(MouseEvent.MOUSE_DOWN , onMouseDown);
				_zoom.removeEventListener(MouseEvent.DOUBLE_CLICK , onDoubleClick);
				_zoom = null;
				_is_zoomed = false;
				stage.setAspectRatio(StageAspectRatio.PORTRAIT);
				_touched_fingers = 0;
				if(_scroll) _scroll.scroller.doNotScroll = false;
			}});
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
			
//			setAlpha();
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
		private function get zoomAnchorXPos():Number
		{
			return (-_anchor_index)*stage.stageWidth;
		}
		private function setAlpha():void
		{
			for(var i:int = 0; i < _items.numChildren; i++)
			{
				_items.getChildAt(i).visible = (i == _anchor_index) ? true : false;
				//_items.getChildAt(i).alpha = (i == _anchor_index) ? 1.0 : 0.6;
			}
		}
		private function setVisible(index:int):void
		{
			_items.getChildAt(index).visible = true;
		}
	}
}