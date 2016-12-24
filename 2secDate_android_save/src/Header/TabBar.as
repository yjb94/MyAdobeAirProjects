package Header
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Point;
	
	import Displays.BitmapControl;
	
	import Page.BasePage;
	import Page.PageConnector;
	import Page.PageEffect;
	import Page.Home.Home;
	import Page.Home.Tabs.NowItem;
	import Page.Home.Tabs.PrevItem;
	import Page.Setting.Setting;
	import Page.Ticket.Ticket;
	
	import Scroll.Scroll;
	import Scroll.Scroller;
	
	import org.hamcrest.mxml.object.Null;
	
	public class TabBar extends Sprite
	{		
		private const NONE:int = -1;
		private const NONE_SELECTED_ALPHA:Number = 0.7;
		private const TWEEN_DURATION:Number = 0.4;
		private const TOUCH_COEFFICIENT:Number = 20;
		
		private const MOVE_PER_TOUCH:Number = 0.7;
		
		private var _anchor:Bitmap;
		private var _bars:Sprite;
		private var _bars_tab:Vector.<BasePage> = new Vector.<BasePage>;
		private var _bars_scroll:Vector.<Scroll> = new Vector.<Scroll>;
		
		private var _tabbed_index:int = 0;
		private var _alpha:Number;
		
		private var _prevPos:Point = new Point;
		//private var _downPos:Point = new Point;
		//private var _Move:Boolean = false;
		private var _distance:Number;
		private var _isDrag:Boolean;
		private var _doTween:Boolean;
		
		private function get barWidth():Number { return Elever.Main.PageWidth/_bars.numChildren; }
		
		public function TabBar(file_name:Class, anchor_name:Class, alpha:Number=1)
		{
			super();
			
			addChild(BitmapControl.newBitmap(file_name, 0, 0, false, 1));
			this.alpha = alpha;
			_alpha = alpha;
			this.name = "TabBar";
			
			_bars = new Sprite;
			addChild(_bars);
			
			_anchor = BitmapControl.newBitmap(anchor_name, 0, 0, false, 1);
			addChild(_anchor);
			
			addEventListener(MouseEvent.CLICK, onMouseClick);
			addEventListener(Event.ADDED_TO_STAGE, function(e:Event):void
			{
				//addEventListener(Event.ENTER_FRAME, onEnterFrame);
				//stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			});
		}
//		private function onEnterFrame(e:Event):void
//		{
//			if(_doTween)
//			{
//				_doTween = false;
//				
//				if(_distance < 0 && _tabbed_index < _bars_tab.length-1)	//right direction
//				{
//					barIndex = _tabbed_index+1;
//				}
//				else if(_distance > 0 && _tabbed_index > 0)	//left direction
//				{
//					barIndex = _tabbed_index-1;
//				}
//				else
//				{
//					for(var i:int = 0; i < _bars_tab.length; i++)
//					{
//						TweenLite.to(_bars_tab[i], TWEEN_DURATION, 
//							{
//								x: (i-_tabbed_index) * Elever.Main.FullWidth
//							});
//					}
//				}
//			}
//		}
//		private function onMouseDown(e:MouseEvent):void
//		{
//			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
//			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
//			
//			if(_bars_tab.length > 0)
//			{
////				_downPos.x = this.mouseX;
////				_downPos.y = this.mouseY;
//				_prevPos.x = this.mouseX;
//				_prevPos.y = this.mouseY;
//				
//				_distance = 0;
//				
//				_isDrag = false;
//			}
//		}
//		private function onMouseMove(e:MouseEvent):void
//		{			
//			if(_bars_tab.length > 0)
//			{	
////				if(Point.distance(_prevPos, new Point(_prevPos.x, mouseY)) > 10)
////					return;
//				if(Point.distance(_prevPos, new Point(mouseX, _prevPos.y)) < TOUCH_COEFFICIENT)	//not dragged
//					return;
//				
////				if(!_Move)
////				{
////					if(Point.distance(_downPos, new Point(mouseX, _downPos.y)) < TOUCH_COEFFICIENT)
////					{
////						_Move = false;
////						return;
////					}
////					else
////					{
////						_Move = true;
////						_prevPos.x = this.mouseX;
////					}
////				}
//				
//				_isDrag = true;
//				
//				//move items.
//				_distance = this.mouseX - _prevPos.x;
//				if(_distance > 0)
//				{
//					if(_tabbed_index)
//					{
//						_bars_tab[_tabbed_index-1].visible = true;
//					}
//				}
//				else 
//				{
//					if(_tabbed_index < _bars_tab.length-1)
//					{
//						_bars_tab[_tabbed_index+1].visible = true;
//					}
//				}
//				for(var i:int = 0; i < _bars_tab.length; i++)
//				{
//					_bars_tab[i].x += _distance*MOVE_PER_TOUCH;
//				}
//				_prevPos.x = this.mouseX;
//			}
//		}
//		private function onMouseUp(e:MouseEvent):void
//		{
//			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
//			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
//			
////			if(!_Move)
////				return;
//			
//			_doTween = true;
//		}
		public function initPos():void
		{
			for(var i:int = 1; i < _bars.numChildren; i++)
				_bars.getChildAt(i).alpha = NONE_SELECTED_ALPHA;
			AnchorIndex = 0;
			
			for(i = 1; i < _bars_tab.length; i++)
				_bars_tab[i].visible = false;
		}
		private function onMouseClick(e:MouseEvent):void
		{
			if(Elever.Main.isChangingPage) return;
			
			barIndex = mouseIndex;
		}
		public function set barIndex(index:int):void
		{
			if(_tabbed_index == index)
			{
				_bars_scroll[_tabbed_index].toTop();
				return;
			}
			//handel current tabbed page
			var cur_tab_index:int = _tabbed_index;
			
			(_bars.getChildAt(_tabbed_index) as DisplayObject).alpha = NONE_SELECTED_ALPHA;
			
			var dir:String = (_tabbed_index < index) ? PageEffect.LEFT : PageEffect.RIGHT;
			var distance:int = Math.abs(_tabbed_index - index);
			
			//_bars_page_param[_tabbed_index].y = Scroller.Y;
			
			//handle next tabbed page
			_tabbed_index = index;
			
			(_bars.getChildAt(_tabbed_index) as DisplayObject).alpha = 1.0;
			AnchorIndex = _tabbed_index;
			
			changeTab(distance, dir, cur_tab_index);
		}
		public function set barIndexWithoutTween(index:int):void
		{
			if(_tabbed_index == index)
			{
				_bars_scroll[_tabbed_index].toTop();
				return;
			}
			//handel current tabbed page
			var cur_tab_index:int = _tabbed_index;
			
			(_bars.getChildAt(_tabbed_index) as DisplayObject).alpha = NONE_SELECTED_ALPHA;
			
			//handle next tabbed page
			_tabbed_index = index;
			
			(_bars.getChildAt(_tabbed_index) as DisplayObject).alpha = 1.0;
			AnchorIndex = _tabbed_index;
			
			_bars_tab[_tabbed_index].visible = true;;
			for(var i:int = 0; i < _bars_tab.length; i++)
			{
				_bars_tab[i].x = (i-_tabbed_index) * Elever.Main.FullWidth;
			}
			_bars_tab[cur_tab_index].visible = false;
		}
		private function get mouseIndex():int
		{
			return this.mouseX/barWidth;
		}
		public function addBar(displayObject:DisplayObject, tab_name:String, base:BasePage, baseHeight:Number):void
		{
			_bars.addChild(displayObject);
			setBarPos();
			
			var pageClass:Class = PageConnector.GetPageClass(tab_name);
			Elever.Main.calcPageSize();
			var tab:BasePage = new pageClass({ height:Elever.Main.PageHeight-baseHeight });
			_bars_tab.push(tab);
			base.addChild(tab);
			setTab(baseHeight);
			_bars_scroll.push(tab.getChildByName("Scroll") as Scroll);
			
			initPos();
		}
		private function changeTab(distance:int, dir:String, cur_tab_index:int):void
		{
			_bars_tab[_tabbed_index].visible = true;
			_bars_scroll[_tabbed_index].scroller.doTween = true;
			
			for(var i:int = 0; i < _bars_tab.length; i++)
			{
				TweenLite.to(_bars_tab[i], TWEEN_DURATION, 
					{
						x: (i-_tabbed_index) * Elever.Main.FullWidth,
						onComplete:onTweenEnded,
						onCompleteParams:[cur_tab_index]
					});
			}
		}
		private function onTweenEnded(cur_tab_index:int):void
		{
			_bars_tab[cur_tab_index].visible = false;
			for(var i:int = 0; i < _bars_scroll.length; i++)
				_bars_scroll[i].scroller.doTween = false;
		}
		private function setTab(height:Number):void
		{
			for(var i:int = 0; i < _bars_tab.length; i++)
			{
				_bars_tab[i].y = height;
				_bars_tab[i].x = i*Elever.Main.FullWidth;
			}
		}
		private function setBarPos():void
		{
			for(var i:int = 0; i < _bars.numChildren; i++)
			{
				var bmp:DisplayObject = _bars.getChildAt(i) as DisplayObject;
				bmp.x = barWidth*i + barWidth/2 - bmp.width/2;
				bmp.y = this.height/2 - bmp.height/2;
			}
		}
		private function set AnchorIndex(index:int):void
		{
			_anchor.x = barWidth*index + barWidth/2 - _anchor.width/2;
			_anchor.y = this.height - _anchor.height;
		}
		public function clearBars():void
		{
			AnchorIndex = 0;
			_tabbed_index = 0;
			while(_bars.numChildren)
				_bars.removeChildAt(0);
			while(_bars_tab.length)
			{
				_bars_tab[_bars_tab.length-1].dispose();
				_bars_tab.pop();
			}
			while(_bars_scroll.length)
				_bars_scroll.pop();
		}
		public function dispose():void
		{
			//stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
	}
}