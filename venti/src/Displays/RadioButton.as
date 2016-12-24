package Displays
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class RadioButton extends Sprite
	{	
		private static const FADE_DURATION:Number = 0.1;
		
		private var _callback:Function = null;
		
		private var _margin:Number;
		
		private var _tabbed_index:int = 0;
		public function set Tab(index:int):void
		{
			if(index != _tabbed_index)
			{
				TabImage("OUT", _tabbed_index);
				TabImage("IN", index);
			}	
		}
		public function get Tab():int { return _tabbed_index; }
		
		private var _btn_list:Vector.<Sprite> = new Vector.<Sprite>;
		private var _change_row:int=-1;
		
		private var _is_height_type:Boolean;
		public function RadioButton(isHeightType:Boolean=true, margin:Number=20, callback:Function=null, x_pos:Number=0, y_pos:Number=0, change_row:int=4):void
		{
			super();
			
			_change_row = change_row;
			_callback = callback;
			_margin = margin;
			_is_height_type = isHeightType;
			this.x = x_pos;
			this.y = y_pos;
		}
		public function addButton(normal:Class, down:Class, callback:Function=null):void
		{
			var spr:Sprite = new Sprite;
			addChild(spr);
			
			var normal_bmp:Bitmap = BitmapControl.newBitmap(normal);
			normal_bmp.name = "Normal";
			spr.addChild(normal_bmp);
			
			var down_bmp:Bitmap = BitmapControl.newBitmap(down);
			if(normal == down)	down_bmp.alpha *= 0.6;
			down_bmp.name = "Down";
			down_bmp.visible = false;
			spr.addChild(down_bmp);

			spr.addEventListener(MouseEvent.CLICK, onItemClick);
			
			_btn_list.push(spr);
			
			setItems();
			
			if(_btn_list.length == 1)
				TabImage("IN", 0);
		}
		private function setItems():void
		{
			for(var i:int = 0; i < _btn_list.length; i++)
			{
				var spr:Sprite = _btn_list[i];
				
				if(_is_height_type) spr.y = _btn_list[i-1].y + spr.height + _margin;
				else				spr.x = (_btn_list[i].width + _margin)*(i%_change_row) + _margin;
				spr.y =  (_btn_list[i].height + _margin) * int(i/_change_row);
			}
		}
		private function onItemClick(e:MouseEvent):void
		{	
			Tab = _btn_list.indexOf(e.currentTarget as Sprite);
		}
		public function TabImage(tabType:String, index:int):void
		{
			var spr:Sprite = _btn_list[index];
			var normal:Bitmap = spr.getChildByName("Normal") as Bitmap;
			var down:Bitmap = spr.getChildByName("Down") as Bitmap;
			
			if(tabType == "IN")
			{
				TweenLite.to(normal, FADE_DURATION, {alpha:0, onComplete:function onTweenEnded():void
				{
					normal.visible = false;
					_tabbed_index = index;
					if(_callback)	_callback();
				}});
				down.visible = true;
				down.alpha = 0;
				TweenLite.to(down, FADE_DURATION, {alpha:1});	//fade-out
			}
			else if(tabType == "OUT")
			{
				TweenLite.to(down, FADE_DURATION, {alpha:0, onComplete:function onTweenEnded():void
				{
					down.visible = false;
				}});
				normal.visible = true;
				normal.alpha = 0;
				TweenLite.to(normal, FADE_DURATION, {alpha:1, onComplete:function tweenEnded():void	//fade-in
				{
					if(_callback)	_callback();
				}});
			}
		}
	}
}