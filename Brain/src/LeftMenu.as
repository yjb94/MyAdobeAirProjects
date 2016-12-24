package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import Page.Main.Index;
	
	import kr.pe.hs.tween.Tween;
	import kr.pe.hs.ui.TabbedButton;
	
	public class LeftMenu extends Sprite
	{
		
		[Embed(source = "assets/left_menu/bg.png")]
		private static const BG:Class;

		private var _isOpened:Boolean;
		private var _tweenOpen:Tween;
		
		public function get isOpened():Boolean{ return _isOpened; }
		public function set isOpened(value:Boolean):void
		{			
			if(_isOpened != value)
			{
				if(_tweenOpen)
				{
					_tweenOpen.endTween();
					_tweenOpen=null;
				}
				
				_tweenOpen = new Tween(_content.x/_bg.width, (value)?0:-1, 0, 500, function(value:Number,isFinish:Boolean):void
				{
					Brain.setXPos(_content.x + _bg.width);
					Page.Main.Index.setXPos(_content.x+_bg.width);
					
					_content.x = value*_bg.width;
					if(isFinish)
					{
						visible = _isOpened;
						_content.visible = _isOpened;
					}
				});
				
				_isOpened = value;
				visible = true;
				_content.visible = true;
				
				onResize();
			}
		}
		
		
		
		private var _buttonClickCallback:Function;
		
		private static var _content:Sprite;
		public function get contentX():Number { return _content.x; }
		
		private var _bg:Bitmap;
		private var _buttons:Vector.<TabbedButton>;
		public function get Buttons():Vector.<TabbedButton>{ return _buttons; }
		
		private var _isDrag:Boolean;
		private var _dragStart:Point;
		private var _dragCurrent:Point;
		private var _dragMovement:Point;
		
		public function LeftMenu(buttonsBitmap:Vector.<Vector.<Class>>,onClickCallback:Function)
		{
			super();			
			
			_buttonClickCallback=onClickCallback;
			
			_content=new Sprite;
			
			_bg=new BG; _bg.smoothing=true;
			_content.addChild(_bg);
			
			addChild(_content);
			
			
			_buttons=new Vector.<TabbedButton>;
			for(var i:int=0;i<buttonsBitmap.length;i++)
			{
				var bmp:Bitmap = new buttonsBitmap[i][0]; bmp.smoothing=true;
				var bmp_on:Bitmap = null;
				if(buttonsBitmap[i][1]!=null) bmp_on=new buttonsBitmap[i][1];
				else
				{
					bmp_on=new buttonsBitmap[i][0];
					bmp_on.alpha=0.6;
				}
				var btn:TabbedButton=new TabbedButton(bmp,bmp_on,bmp_on);
				btn.addEventListener(MouseEvent.CLICK,button_onClick);
				_content.addChild(btn);
				_buttons[_buttons.length]=btn;
			}
			
			
			visible = false;
			_isOpened = false;
			_content.cacheAsBitmap=true;
			_content.x=-_bg.width;
			
			_isDrag=false;
			
			onResize();
			
			addEventListener(MouseEvent.CLICK,onClick);
			addEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE,onRemovedFromStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function onRemovedFromStage(e:Event):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		public function onResize():void
		{
			if(!visible)
			{
				var percent:Number = _content.x/_bg.width;
				
				graphics.clear();
				graphics.beginFill(0x000000,0);
				graphics.drawRect(0, Brain.Main.TopMargin, Brain.Main.FullWidth, Brain.Main.FullHeight-Brain.Main.TopMargin);
				graphics.endFill();
				
				_bg.y = 0;
				_bg.height = Math.ceil(Brain.Main.FullHeight-Brain.Main.TopMargin);
				
				var col:int = 1;
				var cellWidth:Number = (_bg.width+70)/col;
				for(var i:int=0;i<_buttons.length;i++)
				{
					_buttons[i].x = 0;//48;//cellWidth*(i%col) + cellWidth/2 - _buttons[i].width/2;
					if(Math.floor(i/col)==0)
						_buttons[i].y=0;//20;
					else
						_buttons[i].y = _buttons[i-col].y+_buttons[i-col].height;// + 20;
				}
				
				_content.x=percent*_bg.width;
				_content.y=Math.floor(Brain.Main.TopMargin);
			}
		}
		
		private function onClick(e:MouseEvent):void
		{
			if(this.mouseX >= _bg.width-70)
			{
				isOpened=false;
			}
		}
		
		private function button_onClick(e:MouseEvent):void
		{
			var idx:int=_buttons.indexOf(e.currentTarget);
			_buttonClickCallback(idx);
		}
		
		public function onMouseDown(e:MouseEvent):void
		{
			if(isOpened)
			{
				if(this.mouseX > _bg.width-70-10)
				{
					if(!_isDrag)
					{
						_dragStart=new Point(this.mouseX,this.mouseY);
						_dragCurrent=new Point(this.mouseX,this.mouseY);
						_dragMovement=new Point(0,0);
						
						stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
						stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
						
						_isDrag=true;
						onMouseMove(null);
					}
				}
			}
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			_dragMovement.x=_dragCurrent.x-this.mouseX;
			_dragMovement.y=_dragCurrent.y-this.mouseY;
			
			_content.x=this.mouseX-_bg.width+70;
			if(_content.x>0) _content.x=0;
			
			Brain.setXPos(_content.x+_bg.width);
			Page.Main.Index.setXPos(_content.x+_bg.width);
			
			_dragCurrent.x=this.mouseX;
			_dragCurrent.y=this.mouseY;
		}
		
		private function onMouseUp(e:MouseEvent):void
		{	
			var moveX:Number=this.mouseX;
			if(_dragMovement.x<=-20 && moveX<(_bg.width-70)/2)
			{
				moveX=(_bg.width-70);
			}
			else if(_dragMovement.x>=20 && moveX>(_bg.width-70)/2)
			{
				moveX=0;
			}
			if(moveX >= (_bg.width-70)/2)
			{
				_isOpened=false;
				isOpened=true;
			}
			else
			{
				_isOpened=true;
				isOpened=false;
			}
			
			_isDrag=false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		public function dispose():void
		{
			if(_tweenOpen)
			{
				_tweenOpen.endTween();
				_tweenOpen=null;
			}
			
			removeEventListener(Event.ADDED_TO_STAGE,onAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE,onRemovedFromStage);
			
			stage.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
	}
}