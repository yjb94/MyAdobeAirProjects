package Displays
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class Button extends Sprite
	{	
		private static const FADE_DURATION:Number = 0.1;
		private var _normal:Bitmap;
		private var _down:Bitmap;
		
		private var _isTabbed:Boolean;
		
		private var _callback:Function = null;
		
		private var _normal_alpha:Number;
		private var _down_alpha:Number;
		
		private var _is_tab_type:Boolean;
		
		public function Button(normal:Class, down:Class, callback:Function=null, x_pos:Number=0, y_pos:Number=0, isVectorPos:Boolean=false, isTabType:Boolean=false, alpha:Number=1):void
		{
			super();
			
			_is_tab_type = isTabType;
			
			_normal_alpha = alpha;
			_normal = BitmapControl.newBitmap(normal, x_pos, y_pos, isVectorPos, _normal_alpha);
			addChild(_normal);
			
			_down_alpha = alpha
			if(normal == down)	_down_alpha *= 0.6;
			_down	= BitmapControl.newBitmap(	down, x_pos, y_pos, isVectorPos, _down_alpha);
			_down.visible = false;
			addChild(_down);
			
			_isTabbed = false;
			
			_callback = callback;
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		private function onMouseDown(e:MouseEvent):void
		{
			if(_is_tab_type)
			{
				addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			}
			else if(!_isTabbed)
			{
				TabImage("IN");

				addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				stage.addEventListener(MouseEvent.MOUSE_UP,onStageMouseUp);
			}
		}
		private function onMouseUp(e:MouseEvent):void
		{
			removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
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
	}
}