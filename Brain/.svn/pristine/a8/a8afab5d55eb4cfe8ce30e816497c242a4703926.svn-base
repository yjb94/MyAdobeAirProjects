package com.thanksmister.touchlist.renderers
{
	import flash.display.Sprite;
	
	public class SpaceItemRenderer extends Sprite implements ITouchListItemRenderer
	{
		private var _spaceHeight:Number;
		
		public function SpaceItemRenderer(spaceHeight:Number)
		{
			super();
			
			itemHeight=spaceHeight;
		}
		
		public function set data(value:Object):void
		{
		}
		
		public function get data():Object
		{
			return null;
		}
		
		public function set index(value:Number):void
		{
		}
		
		public function get index():Number
		{
			return 0;
		}
		
		public function set itemWidth(value:Number):void
		{
		}
		
		public function get itemWidth():Number
		{
			return 1;
		}
		
		public function set itemHeight(value:Number):void
		{
			_spaceHeight=value;
			
			graphics.clear();
			graphics.beginFill(0x000000,0);
			graphics.drawRect(0,0,1,_spaceHeight);
			graphics.endFill();
			
			cacheAsBitmap=true;
		}
		
		public function get itemHeight():Number
		{
			return _spaceHeight;
		}
		
		public function selectItem():void
		{
		}
		
		public function unselectItem():void
		{
		}
	}
}