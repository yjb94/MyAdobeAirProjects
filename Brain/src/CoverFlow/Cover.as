package CoverFlow
{
	import flash.display.*;
	import flash.geom.*;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	
	public class Cover extends Sprite 
	{	
		private var _src:String;
		private var _caption:String;
		private var _data:XML;
		private var _loader:Loader;
		private var _reflection:Bitmap;
		private var _backgroundColor:uint;

		private var _startX:Number;
		private var _endX:Number;
		private var _startRotationY:Number;
		private var _endRotationY:Number;
		private var _startZ:Number;
		private var _endZ:Number;
		private var _coverFlowParent:CoverFlow;
		private var _centerMargin:Number;
		private var _distanceFromCenter:Number;
		
		public function Cover(caption:String, data:XML, backgroundColor:Number) 
		{
			_caption = caption;
			_data = data;
			_backgroundColor = backgroundColor;
			
			//graphics.beginFill(0xff0000);
			//graphics.drawRect(0, 0, 237, 269);
		}
		public function set dropOff(value:Number):void 
		{
			value = Math.max(0, Math.min(1, value));
			
			var r:uint = _backgroundColor >> 16;
			var g:uint = _backgroundColor >> 8 & 0xFF;
			var b:uint = _backgroundColor & 0xFF;
			
			var multiplier:Number = 1 - value;
			
			var color:ColorTransform = new ColorTransform(multiplier, multiplier, multiplier, 1, r * value, g * value, b * value, 0);
			this.transform.colorTransform = color;
		}
		
		public function load(src:String):void 
		{
			_src = src;
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			addChild(_loader);
			_loader.load(new URLRequest(_src));
		}
		private function onLoadProgress(e:ProgressEvent):void 
		{
			dispatchEvent(e);
		}
		
		private function onLoadComplete(e:Event):void 
		{
			_loader.x = -Math.round(_loader.width / 2);
			_loader.y = -_loader.height;
			//drawReflection();
			dispatchEvent(e);
		}
		
//		private function drawReflection():void 
//		{
//			if (_loader.width == 0 || _loader.height == 0) 
//			{
//				return;
//			}
//			
//			var clone:BitmapData = new BitmapData(_loader.width, _loader.height, false, 0x000000);
//			var flip:Matrix = new Matrix();
//			flip.scale(1, -1);
//			flip.translate(0, _loader.height);
//			clone.draw(_loader, flip);
//			_reflection = new Bitmap(clone);
//			addChild(_reflection);
//			_reflection.x = _loader.x;
//
//			var gradient:Shape = new Shape();
//			var gradientMatrix:Matrix = new Matrix();
//			gradientMatrix.createGradientBox(_reflection.width, _reflection.height, Math.PI / 2);
//			var gradientFill:GraphicsGradientFill = new GraphicsGradientFill(GradientType.LINEAR, [_backgroundColor, _backgroundColor], [.5, 1], [0, 255], gradientMatrix);
//			var gradientRect:GraphicsPath = new GraphicsPath();
//			gradientRect.moveTo(0, 0);
//			gradientRect.lineTo(_reflection.width, 0);
//			gradientRect.lineTo(_reflection.width, _reflection.height);
//			gradientRect.lineTo(0, _reflection.height);
//			gradientRect.lineTo(0, 0);
//			var graphicsData:Vector.<IGraphicsData> = new Vector.<IGraphicsData>();
//			graphicsData.push(gradientFill, gradientRect);
//			gradient.graphics.drawGraphicsData(graphicsData);
//			
//			_reflection.bitmapData.draw(gradient);
//		}
		
		private function onLoadError(e:IOErrorEvent):void 
		{
			trace("error: " + e.text)
		}
		public function get caption():String 
		{
			return _caption;
		}
		
		public function get data():XML 
		{
			return _data;
		}
		
		public function set backgroundColor(num:Number):void 
		{
			_backgroundColor = num;
			//drawReflection();
		}
		public function get backgroundColor():Number 
		{
			return _backgroundColor;
		}
		internal function set endX(n:Number):void {
			_startX = this.x;
			_endX = n;
		}
		internal function set endRotationY(n:Number):void {
			_startRotationY = this.rotationY;
			_endRotationY = n;
		}
		internal function set endZ(n:Number):void {
			_startZ = this.z;
			_endZ = n;
		}
		internal function updateTween(elapsedTime:Number, duration:Number):void {
			this.x         = ExponentialEaseOut(elapsedTime, _startX, _endX - _startX, duration);
			this.rotationY = ExponentialEaseOut(elapsedTime, _startRotationY, _endRotationY - _startRotationY, duration);
			this.z         = ExponentialEaseOut(elapsedTime, _startZ, _endZ - _startZ, duration);
			
			if (!_coverFlowParent) _coverFlowParent = this.parent.parent as CoverFlow;
			
			_distanceFromCenter = Math.abs(this.x - (_coverFlowParent.width / 2));
			_centerMargin = _coverFlowParent.centerMargin;
			if (_distanceFromCenter < _centerMargin) {
				this.dropOff = .1 * _distanceFromCenter / _centerMargin;
			} else {
				this.dropOff = .1 + ((_distanceFromCenter - _centerMargin) / _coverFlowParent.horizontalSpacing) * .1;
			}
			
		}
		private static function ExponentialEaseOut(t:Number, b:Number, c:Number, d:Number):Number {
			return (t==d) ? b+c : c * (-Math.pow(2, -10 * t/d) + 1) + b;
		}
	}
}