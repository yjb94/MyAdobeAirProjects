package com.thanksmister.touchlist.renderers
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class DisplayObjectItemRenderer extends Sprite implements ITouchListItemRenderer
	{
		private var _child:DisplayObject;
		
		public function DisplayObjectItemRenderer(obj:DisplayObject=null)
		{
			_child=obj;
			if(_child) addChild(_child);
		}
		
		public function set data(value:Object):void
		{
			_child=value as DisplayObject;
			if(_child) addChild(_child);
		}
		
		public function get data():Object
		{
			return _child;
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
			return _child.width;
		}
		
		public function set itemHeight(value:Number):void
		{
		}
		
		public function get itemHeight():Number
		{
			return _child.height;
		}
		
		public function selectItem():void
		{
		}
		
		public function unselectItem():void
		{
		}
	}
}