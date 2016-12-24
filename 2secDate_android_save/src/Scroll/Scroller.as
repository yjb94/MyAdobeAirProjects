package Scroll
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
		
	import Header.NavigationBar;
	
	public class Scroller extends Sprite
	{
		private const TOUCH_SENSITIVE:Number = 15;
		private const TO_TOP_DURATION:Number = 0.2;
		private const AUTO_SCROLL_SPEED:Number = 0.35;
		private const SPEED_COEFFICIENT:Number = 30;
		private const SCROLL_ACCEL_COEFFICIENT:Number = 2;
		private const MOVE_PER_TOUCH:Number = 0.5;
		private const ACCELERATION:Number = 0.95;
		private const SPEED_LIMIT:Number = 10000;
		
		public static var _width:Number;
		public static var _height:Number;
		public function get Width():Number { return _width; }
		public function set Width(value:Number):void { _width = value; }
		public function get Height():Number { return _height; }
		public function set Height(value:Number):void { _height = value; }
		
		private var _doNotScroll:Boolean = false;
		public function set doNotScroll(value:Boolean):void { _doNotScroll = value; }
		
//		private static var _main:Scroller;
//		public static function get scroller():Scroller { return _main; }
		
		private static var _y:Number = 0;
		public static function get Y():Number { return _y; }
		public function getY():Number { return _y; }
		
		private var _prevPos:Point;			//the position that user has touched right before
		private var _downPos:Point;			//the position that user has started to touch
		private var _isTouching:Boolean;	//is player touching the screen
		
		private var _distance:Number;		//the distance between current touch from previous touch(y Value)
		private var _speed:Number = 0;		//speed to move the scroll
		private var _savedSpeed:Number = 0;	//speed saved when initialized
	
		private var _scroll_tween:TweenLite	//the tween that makes scroll to height and 0 pos when collision
		private var _doTween:Boolean;		//whether to start the tween
		public function set doTween(value:Boolean):void { _doTween = value; }
		
		private var _isMoving:Boolean = false;		//whether the scroll is moving
		
		private var _t:int;		//to count delta time
		
		private var _scrollDir:int;	//the direction to be scrolled
		
		private var _beginY:Number;
		
		private var _func_up_slide:Function;
				
		public function Scroller(width:Number, height:Number, scrollDir:int, beginY:Number, func_upSlide:Function=null)
			//if it is -1, the value will be set to pages value. scrollDir - (1 - diff from your gesture dir, -1 - exact dir from your gesture)
		{
			super();
//			_main = this;
			_func_up_slide = func_upSlide;
			
			//initialize positions
			_prevPos = new Point;
			_downPos = new Point;
			
			_width = (width < 0) ? Elever.Main.PageWidth : width;		//set the scroll width
			_height = (height < 0) ? Elever.Main.PageHeightForScroll : height;	//set the scroll height
			_scrollDir = scrollDir;
			_beginY = beginY;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		private function onAddedToStage(e:Event):void
		{	
			this.y = _beginY;
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);		//add event to stage to control every events on screen
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		private function onEnterFrame(e:Event):void
		{
			if(_doNotScroll) return;
			
			if(this.height > _height)
			{
				var t:int = getTimer(); var dt:Number = (t-_t)*0.001; _t = t;	//calculate the delta time
				
				if(SPEED_LIMIT > 0)		//check if there is speed limit
					if(Math.abs(_speed) > SPEED_LIMIT)			//checks if speed is larger than limit
						_speed = SPEED_LIMIT * ((_speed < 0) ? -1 : 1);		//set the speed to limit
				
				y -= _speed*dt;			//set the sprite y value(scrolling event)
				_speed *= ACCELERATION;	//makes the speed to reduce with acceleration
				
				//the scrollbar settings
				(parent as Scroll).scrollBar._scrollbar.y = -(y*Height)/height;
				
				if(Math.abs(Math.floor(_speed)) <= 10)	//speed will be initialized when it is below some value
				{
					_isMoving = false;
					_speed = 0;
				}
				
				if(_doTween)	//Tween when dragged to top or bottom
				{
					//initialize speed settings
					if(0 < y)
					{
						if(_start_y_zero)
							if(_func_up_slide)
								_func_up_slide();
						_scroll_tween = new TweenLite(this, AUTO_SCROLL_SPEED, {y:0});
						_doTween = false;
						_speed = 0;
						_savedSpeed = 0;
					}
					else if(_height-height > y)
					{
						_scroll_tween = new TweenLite(this, AUTO_SCROLL_SPEED, {y:_height-height});
						_doTween = false;
						_speed = 0;
						_savedSpeed = 0;
					}
				}
				_y = y;
			}
		}
		private var _start_y_zero:Boolean = false;
		private function onMouseDown(e:MouseEvent):void
		{
			if(_doNotScroll) return;
			
			if(this.height > _height && stage && (0 <= this.mouseY+y && this.mouseY+y <= _height) && 
				(0 <= this.mouseX+x && this.mouseX+x <= _width))
			{
				if(_scroll_tween)
					_scroll_tween.pause();	//pause the tween(to make soft movement)
				
				stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				
				//save current position
				_prevPos.x = mouseX;
				_prevPos.y = mouseY;
				
				_start_y_zero = y ? false : true;
				
				//save the position where touch started
				_downPos.x = mouseX;
				_downPos.y = mouseY;
				
				if(_isMoving)	//if touched while scrolling, intiailizes the speed and distance
				{
					_savedSpeed = _speed;	//save speed to use when moved
					_distance = 0;
					_speed = 0
				}
				
				_isTouching = true;	//set that it is been touched
			}
		}
		private function onMouseMove(e:MouseEvent):void
		{
			if(this.height > _height)
			{
				if(Point.distance(_downPos, new Point(_downPos.x, mouseY)) < TOUCH_SENSITIVE)	//not dragged
					return;

				if(_isTouching)
				{
					_distance = _scrollDir*(_prevPos.y - mouseY);	//get the distance from the touch before
					
					if(_fold_obj)
					{
						if(_fold_dir == 1)
						{
							if(-_fold_obj.height <= _fold_obj.y && _fold_obj.y <= _fold_obj_y)
								_fold_obj.y += _distance*MOVE_PER_TOUCH*_fold_dir;
							
							if(_fold_obj.y <= -_fold_obj.height)
								_fold_obj.y = -_fold_obj.height;
							
							if(_fold_obj.y >= _fold_obj_y)
								_fold_obj.y = _fold_obj_y;
						}
						setFoldAlpha();
					}
					
					y += _distance*MOVE_PER_TOUCH;					//move
				}
				_prevPos.y = mouseY;
			}
		}
		private function onMouseUp(e:MouseEvent):void
		{
			if(this.height > _height)
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				
				_doTween = true;
				
				//fold settings
				if(_fold_obj)
				{
					if(_fold_dir == 1)
					{
						if(-_fold_obj.height <= _fold_obj.y && _fold_obj.y <= _fold_obj_y)
						{
							TweenLite.to(_fold_obj, FOLD_TWEEN, { y:((_distance*_fold_dir < 0) ? -_fold_obj.height : _fold_obj_y), onUpdate:setFoldAlpha });
							//_doTween = false;
						}
					}
					setFoldAlpha();
				}
				
				if(Point.distance(_downPos, new Point(_downPos.x, mouseY)) < TOUCH_SENSITIVE)	//not dragged
					return;
				
				_doTween = true;
				
				_speed = -_distance*SPEED_COEFFICIENT;	//set speed(to move on enterframe)
				
				if(_speed)
				{
					_speed += _savedSpeed*SCROLL_ACCEL_COEFFICIENT;
					if(_downPos.y >= mouseY)	//scrolled down
						_speed = _speed*((_speed < 0) ? -1 : 1);
					else						//scrolled up
						_speed = _speed*((_speed < 0) ? 1 : -1);
					_savedSpeed = 0;
				}
				
				_isTouching = false;
				_isMoving = true;
			}
		}
		public function toTop():void
		{
			TweenLite.to(this, TO_TOP_DURATION, {y:0});
			_speed = 0;
			_savedSpeed = 0;
			_doTween = false;
		}
		private static var FOLD_TWEEN:Number = 0.2;
		private var _fold_obj:DisplayObject;
		private var _fold_dir:int;
		private var _fold_obj_y:Number;
		public function fold(displayObject:DisplayObject, dir:int):void
		{
			_fold_dir = dir;
			_fold_obj = displayObject;
			_fold_obj_y = _fold_obj.y;
		}
		private function setFoldAlpha():void
		{
			if(_fold_dir == 1)
			{
				//_fold_obj.alpha = 1.0 - (_fold_obj_y-_fold_obj.y)/(_fold_obj_y+_fold_obj.height);
				if(_fold_obj == (Elever.Main.header.getChildByName("NavigationBar")))
					(_fold_obj as NavigationBar).setAlpha(1.0 - (_fold_obj_y-_fold_obj.y)/(_fold_obj_y+_fold_obj.height));
			}
		}
		public function resetFoldObj():void
		{
			if(_fold_dir == 1)
			{
				TweenLite.to(_fold_obj, FOLD_TWEEN, { y:_fold_obj_y, onUpdate:setFoldAlpha });
				_doTween = false;
				
				_fold_obj = null;
			}
		}
		public function dispose():void
		{
			if(stage)	stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);		//remove event to stage to control every events on screen
			if(stage)	stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			NavigationBar.Y = y;
		}
	}
}
