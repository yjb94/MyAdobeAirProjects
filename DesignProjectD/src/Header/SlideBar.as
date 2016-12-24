package Header
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import Displays.BitmapControl;
	
	import Scroll.Scroll;
	
	public class SlideBar extends Header
	{
		private static const MOVE_PER_TOUCH:Number = 0.7;
		private static const TWEEN_DURATION:Number = 0.2;
		private static const BASE_INDEX_NUM:int = 3;
		
		private var _items:Sprite;
		private var _items_callback:Vector.<Function> = new Vector.<Function>;
		private var _indexNum:int = BASE_INDEX_NUM;
		
		private var _prevPos:Point = new Point;
		private var _distance:Number;
		
		private var _anchor_changed:Boolean = false;
		private var _anchor_index:int;
		
		private var _doTween:Boolean = false;
		
		private var _isDrag:Boolean = false;
		
		private var _alpha:Number;
		
		private function get itemWidth():Number { return Elever.Main.PageWidth/_indexNum; }
				
		public function SlideBar(file_name:Class, alpha:Number=1, indexNum:int=BASE_INDEX_NUM):void
		//indexNum 은 홀수 입력할것. 3-5민
		{
			super();
			_indexNum = indexNum;
			
			_anchor_index = BASE_INDEX_NUM/2;
			
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

				if(_distance < 0 && AnchorXPos > -itemWidth*(_items.numChildren-1-_indexNum/2))	//right direction
				{
					_anchor_index++;
					_anchor_changed = true;
				}
				else if(_distance > 0 && AnchorXPos < itemWidth+(_indexNum-3))	//left direction
				{
					_anchor_index--;
					_anchor_changed = true;
				}
				TweenLite.to(_items, TWEEN_DURATION, { x:AnchorXPos, onComplete:onTweenEnd });
				setAlpha();
				
				if(_anchor_changed)
				{
					_items_callback[_anchor_index](_anchor_index);
					_anchor_changed = false;
				}
			}
		}
		private function onTweenEnd():void
		{
		}
		private function onMouseDown(e:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			if(_items.numChildren >= BASE_INDEX_NUM)
			{
				_prevPos.x = this.mouseX;
				_prevPos.y = this.mouseY;
				
				_distance = 0;
				
				_isDrag = false;
			}
		}
		private function onMouseMove(e:MouseEvent):void
		{
			if(_items.numChildren >= BASE_INDEX_NUM)
			{
				if(Point.distance(_prevPos, new Point(mouseX, _prevPos.y)) < 10)	//not dragged
					return;
				_isDrag = true;
				
				//move items.
				_distance = this.mouseX - _prevPos.x
				_items.x += _distance*MOVE_PER_TOUCH;
				_prevPos.x = this.mouseX;
			}
		}
		private function onMouseUp(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			if(!_isDrag)
			{
				if(_prevPos.x < itemWidth && _anchor_index > 0)
				{
					setAnchor(_anchor_index-1);
					_anchor_changed = true;
				}
				else if(itemWidth*2 < _prevPos.x && _anchor_index < _items.numChildren-1)
				{
					setAnchor(_anchor_index+1);
					_anchor_changed = true;
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
			
			setAlpha();
		}
		public override function changePage(page_name:String=null, page_params:Object=null):void
		{
		}
		public override function clear():void
		{
			while(_items.numChildren)
				_items.removeChildAt(_items.numChildren-1);
		}
		private function placeItem(index:int):void
		{
			//place item for each index.
			var obj:DisplayObject = _items.getChildAt(index);
			obj.x = itemWidth*index + itemWidth/2 - obj.width/2;
			obj.y = this.height/2 - obj.height/2;
			obj.addEventListener(MouseEvent.CLICK, onItemClicked);
			
			setAlpha();
		}
		private function onItemClicked(e:MouseEvent):void
		{
			for(var i:int = 0; i < _items.numChildren; i++)
				if(_items.getChildAt(i) == e.currentTarget)
					break;
			setAnchor(i);
		}
		private function get AnchorXPos():Number
		{			
			return (-_anchor_index+1)*itemWidth;
		}
		private function setAlpha():void
		{
			for(var i:int = 0; i < _items.numChildren; i++)
				_items.getChildAt(i).alpha = (i == _anchor_index) ? 1.0 : 0.6;
		}
		private var _saved_y:Number;
		public function set disable(value:Boolean):void
		{
			if(value)
			{
				Elever.Main.dictionary["SlideBar"] = this;
				_saved_y = y;
				TweenLite.to(this, DISABLE_TWEEN_DURATION, { y:-y-this.height, alpha:0, onComplete:Disabled });
				Elever.Main.header.onResize();
			}
			else
			{
				Elever.Main.header.addChild(Elever.Main.dictionary["SlideBar"]);
				Elever.Main.deleteItemInDict("SlideBar");
				TweenLite.to(this, DISABLE_TWEEN_DURATION, { y:_saved_y, alpha:_alpha, onComplete:Abled });
			}
		}
		private function Disabled():void
		{
			Elever.Main.header.removeChild(Elever.Main.header.getChildByName("SlideBar"));
		}
		private function Abled():void
		{
			Scroll.Scroll.scroll.onResize();
		}
	}
}