package Header
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import Displays.BitmapControl;
	import Displays.Button;
	
	import Page.PageEffect;
	
	import Scroll.Scroll;
	import Scroll.Scroller;

	public class NavigationBar extends Header
	{		
		private var _prev_page:Array = new Array;
		
		private var _leftChild:DisplayObject;
		private var _rightChild:DisplayObject;
		private var _middleChild:DisplayObject;
		
		private static var _isPrevClicked:Boolean = false;
		
		private var _alpha:Number;
		
//		private static var _y:Number = 0;
//		public static function set Y(value:Number):void { _y = value; }
		
		public function NavigationBar(file_name:Class, alpha:Number=1):void
		{
			_alpha = alpha;
			this.alpha = alpha;
			this.name = "NavigationBar";
			addChild(BitmapControl.newBitmap(file_name, 0, 0, false, 1));
		}
		public function set Left(value:DisplayObject):void
		{//set left child
			if(_leftChild) removeChild(_leftChild);
			_leftChild = value;
			if(value==null)	return;
			_leftChild.y = this.height/2 - _leftChild.height/2;
			addChild(_leftChild);
		}
		public function set Right(value:DisplayObject):void
		{//set right child
			if(_rightChild) removeChild(_rightChild);
			_rightChild = value;
			if(value==null)	return;
			_rightChild.x = this.width - _rightChild.width;
			_rightChild.y = this.height/2 - _rightChild.height/2;
			addChild(_rightChild);
		}
		public function set Middle(value:DisplayObject):void
		{//set middle child
			if(_middleChild) removeChild(_middleChild);
			_middleChild = value;
			if(value==null)	return;
			_middleChild.x = this.width/2 - _middleChild.width/2;
			_middleChild.y = this.height/2 - _middleChild.height/2;
			addChild(_middleChild);
		}
		public override function changePage(page_name:String=null, page_params:Object=null):void
		{
			Left = null;
			Right = null;
			Middle = null;
			
			if(page_name != "")		//if it is called for second time
			{
				if(!_isPrevClicked)
				{
					var obj:Object = new Object;
					obj.page_name = page_name;
					if(!page_params) page_params = new Object;
					page_params.y = Scroller.Y;
					obj.page_params = page_params;
					_prev_page.push(obj);
				}
				
				if(!(_isPrevClicked && _prev_page.length-1 == 0))
					Left = new Button(BitmapControl.PREV_BUTTON, BitmapControl.PREV_BUTTON, onPrevClick);
			}
			
			_isPrevClicked = false;
		}
		private function onPrevClick(e:MouseEvent):void
		{
			if(Elever.Main.isChangingPage)	return;
			_isPrevClicked = true;
			Elever.Main.changePage(_prev_page[_prev_page.length-1].page_name, PageEffect.RIGHT, _prev_page[_prev_page.length-1].page_params);
			_prev_page.pop();
		}
		public function clear():void
		{
			Left = null;
			Right = null;
			Middle = null;
			while(_prev_page.length)
				_prev_page.pop();
		}
		private var _saved_y:Number;
		public function set disable(value:Boolean):void
		{
			if(value)
			{
				Elever.Main.dictionary["NavigationBar"] = this;
				_saved_y = y;
				TweenLite.to(this, DISABLE_TWEEN_DURATION, { y:-y-this.height, alpha:0, onComplete:Disabled });
				Elever.Main.header.onResize();
			}
			else
			{
				Elever.Main.header.addChild(Elever.Main.dictionary["NavigationBar"]);
				Elever.Main.deleteItemInDict("NavigationBar");
				TweenLite.to(this, DISABLE_TWEEN_DURATION, { y:_saved_y, alpha:_alpha, onComplete:Abled });
			}
		}
		private function Disabled():void
		{
			Elever.Main.header.removeChild(Elever.Main.header.getChildByName("NavigationBar"));
		}
		private function Abled():void
		{
			Scroll.Scroll.scroll.onResize();
		}
	}
}