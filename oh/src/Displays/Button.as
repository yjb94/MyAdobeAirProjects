package Displays
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class Button extends Sprite
	{	
		private const TOUCH_SENSITIVE:Number = 20;
		private const FADE_DURATION:Number = 0.2;
		private var _normal:DisplayObject;
		private var _down:DisplayObject;
		
		private var _isTabbed:Boolean;
		
		private var _callback:Function = null;
		
		private var _normal_alpha:Number;
		private var _down_alpha:Number;
		
		private var _is_tab_type:Boolean;
		
		private var _downPos:Point = new Point;
		
		public function Button(normal:Object, down:Object, callback:Function=null, x_pos:Number=0, y_pos:Number=0, isVectorPos:Boolean=false, isTabType:Boolean=false, alpha:Number=1):void
		{
			super();
			
			_is_tab_type = isTabType;
			
			this.x = x_pos;
			this.y = y_pos;
			
			_normal_alpha = alpha;
			if(normal is Class)
				_normal = BitmapControl.newBitmap(normal as Class, 0, 0, false, _normal_alpha);
			else
				_normal = normal as DisplayObject;
			addChild(_normal);
			
			_down_alpha = alpha
			if(normal is Class && down is Class)
				if(normal == down)	
					_down_alpha *= 0.6;
			
			if(down is Class)
				_down	= BitmapControl.newBitmap(	down as Class, 0, 0, false, _down_alpha);
			else
				_down = down as DisplayObject;
			_down.visible = false;
			addChild(_down);
			
			_isTabbed = false;
			
			_callback = callback;
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		private function onMouseDown(e:MouseEvent):void
		{
			_downPos.x = mouseX;
			_downPos.y = mouseY;
			
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			
			if(!_isTabbed)
				if(!_is_tab_type) 
					TabImage("IN");
		}
		private function onMouseUp(e:MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			
			if(Point.distance(_downPos, new Point(_downPos.x, mouseY)) > TOUCH_SENSITIVE)
			{
				if(_isTabbed)
					TabOut();
				return;
			}
			
			if(!_is_tab_type) 
			{
				if(_callback)	
					_callback(e);
			}
			else
			{
				TabImage(_isTabbed ? "OUT" : "IN");
			}
		}
		
		private function onStageMouseUp(e:MouseEvent):void
		{
			if(stage) stage.removeEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			
			if(Point.distance(_downPos, new Point(mouseX, mouseY)) < TOUCH_SENSITIVE)
			{
				if(_isTabbed)
					if(!_is_tab_type)
						TabOut();
				return;
			}
			
			if(_isTabbed)
			{
				if(!_is_tab_type)
					TabImage("OUT");
			}
		}
		
		public function get isTabbed():Boolean{ return _isTabbed; }
		public function set isTabbed(value:Boolean):void
		{
			_isTabbed=value;
			TabImage((_isTabbed ? "IN" : "OUT"));
		}
		
		private function TabImage(tabType:String):void
		{
			if(tabType == "IN")
			{
				TweenLite.to(_normal, FADE_DURATION, {alpha:0, onComplete:function onTweenEnded():void
				{
					_normal.visible = false;
					if(_is_tab_type) if(_callback)	_callback(null);
				}});
				_down.visible = true;
				_down.alpha = 0;
				TweenLite.to(_down, FADE_DURATION, {alpha:_down_alpha});	//fade-out
				_isTabbed = true;
			}
			else if(tabType == "OUT")
			{
				TweenLite.to(_down, FADE_DURATION, {alpha:0, onComplete:function onTweenEnded():void
				{
					_down.visible = false;
				}});
				_normal.visible = true;
				_normal.alpha = 0;
				TweenLite.to(_normal, FADE_DURATION, {alpha:_normal_alpha, onComplete:function tweenEnded():void	//fade-in
				{
					_isTabbed = false;
					if(_is_tab_type) if(_callback)	_callback(null);
				}});
			}
		}
		private function TabOut():void
		{
			TweenLite.to(_down, FADE_DURATION, {alpha:0, onComplete:function onTweenEnded():void
			{
				_down.visible = false;
			}});
			_normal.visible = true;
			_normal.alpha = 0;
			TweenLite.to(_normal, FADE_DURATION, {alpha:_normal_alpha, onComplete:function tweenEnded():void	//fade-in
			{
				_isTabbed = false;
			}});
		}
	}
}