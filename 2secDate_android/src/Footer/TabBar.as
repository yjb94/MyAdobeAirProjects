package Footer
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import Displays.BitmapControl;
	
	import Page.BasePage;
	import Page.PageEffect;
	
	import Scroll.Scroll;

	public class TabBar extends Footer
	{
		private static const NONE:int = -1;
		
		private var _bars:Sprite;
		private var _normal_bmp:Vector.<Bitmap> = new Vector.<Bitmap>;
		private var _tabbed_bmp:Vector.<Bitmap> = new Vector.<Bitmap>;
		private var _bars_page_name:Vector.<String> = new Vector.<String>;
		
		private var _bars_page_param:Vector.<Object> = new Vector.<Object>;
		
		private var _tabbed_index:int = 0;
				
		private function get barWidth():Number { return Elever.Main.PageWidth/_bars.numChildren; }

		public function TabBar(file_name:Class, alpha:Number=1):void
		{
			super();
			
			addChild(BitmapControl.newBitmap(file_name, 0, 0, false, 1));
			this.y = Elever.Main.FullHeight - this.height;
			this.alpha = alpha;
			this.name = "TabBar";
			
			_bars = new Sprite;
			addChild(_bars);
			
			addEventListener(MouseEvent.CLICK, onMouseClick);
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
				_bars_page_param[_tabbed_index].y = 0;
				Elever.Main.changePage(_bars_page_name[_tabbed_index], PageEffect.RIGHT, _bars_page_param[_tabbed_index]);
				//Scroll.Scroll.scroll.toTop();
				return;
			}
			//handel current tabbed page
			
			var bmp:Bitmap = _bars.getChildAt(_tabbed_index) as Bitmap;
			bmp.bitmapData = _normal_bmp[_tabbed_index].bitmapData;
			
			var dir:String = (_tabbed_index < index) ? PageEffect.LEFT : PageEffect.RIGHT;
			
//			_bars_page_param[_tabbed_index].y = Scroller.Y;
			
			//handle next tabbed page
			_tabbed_index = index;
			
			bmp = _bars.getChildAt(_tabbed_index) as Bitmap;
			bmp.bitmapData = _tabbed_bmp[_tabbed_index].bitmapData;
			
			Elever.Main.changePage(_bars_page_name[_tabbed_index], dir, _bars_page_param[_tabbed_index]);
		}
		private function get mouseIndex():int
		{
			return this.mouseX/barWidth;
		}
		public function addBar(normal:Class, tabbed:Class, page_name:String, page_param:Object, alpha:Number=1):void
		{
			var bmp_normal:Bitmap = BitmapControl.newBitmap(normal, 0, 0, false, alpha);
			_normal_bmp.push(bmp_normal);
			
			var bmp_tabbed:Bitmap = BitmapControl.newBitmap(tabbed, 0, 0, false, alpha);
			_tabbed_bmp.push(bmp_tabbed);
			
			var bmp:Bitmap = new Bitmap(_normal_bmp[_normal_bmp.length-1].bitmapData, "auto", true);
			if(!_bars.numChildren) bmp = new Bitmap(_tabbed_bmp[_tabbed_bmp.length-1].bitmapData, "auto", true);
			_bars.addChild(bmp);
			setBarPos();
			
			_bars_page_name.push(page_name);
			_bars_page_param.push(page_param);
		}
		private function setBarPos():void
		{
			for(var i:int = 0; i < _bars.numChildren; i++)
			{
				var bmp:Bitmap = _bars.getChildAt(i) as Bitmap;
				bmp.x = barWidth*i + barWidth/2 - bmp.width/2;
				bmp.y = this.height/2 - bmp.height/2;
			}
		}
		public override function changePage(page_name:String=null, page_params:Object=null):void
		{
			for(var i:int = 0; i < _bars_page_name.length; i++)
			{
				if(_bars_page_name[i] == page_name)
				{
					barIndex = i;
					if(page_params)	_bars_page_param[i] = page_params;
				}
			}
		}
		
		public override function onResize(e:Event=null):void
		{
			this.y = Elever.Main.FullHeight - this.height;
		}
	}
}