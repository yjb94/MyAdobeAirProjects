package CoverFlow
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;
	
	import Page.Main.Index;
	
	public class CoverFlow extends Sprite 
	{
		private var _coversContainer:Sprite;
		
		private var _width:Number;
		private var _height:Number;
		
		private var _backgroundColor:uint = 0;//0x000000;
		private var _background:Shape;
		
		private var _urlLoader:URLLoader;
		private var _xml:XML;
		
		private var _covers:Vector.<Cover>;
		
		private var _loadCounter:uint;
		
		private var _bytesPerImage:int;
		private var _bytesTotal:int;
		
		private var _selectedIndex:uint;
		
		private var _centerMargin:Number;
		private var _horizontalSpacing:Number;
		private var _backRowDepth:Number;
		private var _backRowAngle:Number;
		private var _verticalOffset:Number;
		
		private static const DEFAULT_CENTER_MARGIN:Number      = 60;
		private static const DEFAULT_HORIZONTAL_SPACING:Number = 30;
		private static const DEFAULT_BACK_ROW_DEPTH:Number     = 150;
		private static const DEFAULT_BACK_ROW_ANGLE:Number     = 45;
		private static const DEFAULT_VERTICAL_OFFSET:Number    = 0;
		
		private var _captionField:TextField;
		
		private var _tweenDuration:int = 1200;
		private var _startTime:int;
		private var _elapsed:int;
		private var _coversLength:uint;
		private var _iteration:uint
		private var _iterationCover:Cover;
		private var _sortedCovers:Vector.<Cover>;
		private var _unitsFromCenter:uint;
		private var _distanceA:Number;
		private var _distanceB:Number;
		
		private var _isDrag:Boolean;
		private var _lastPlace:int = -1;
		private var _moveDir:Boolean;
		
		private var _callback:Function;
		
		public function CoverFlow(w:Number, h:Number, callback:Function)
		{
			_callback = callback;
			
			_width = w;
			_height = h;
			_covers = new Vector.<Cover>();
			
			_centerMargin      = DEFAULT_CENTER_MARGIN;
			_horizontalSpacing = DEFAULT_HORIZONTAL_SPACING;
			_backRowDepth      = DEFAULT_BACK_ROW_DEPTH;
			_backRowAngle      = DEFAULT_BACK_ROW_ANGLE;
			_verticalOffset    = DEFAULT_VERTICAL_OFFSET;
			
			_coversContainer = new Sprite();
			addChild(_coversContainer);
			
			_background = new Shape();
			addChildAt(_background, 0);
			drawBackground();
			
			scrollRect = new Rectangle(0, 0, _width, _height);
			this.transform.perspectiveProjection = new PerspectiveProjection()
			this.transform.perspectiveProjection.projectionCenter = new Point(_width/2, _height-190);
			
			_urlLoader = new URLLoader();
			_urlLoader.addEventListener(Event.COMPLETE, onXMLLoad);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onXMLLoadError);
			
			this.addEventListener(Event.RENDER, onRender);
			
			_captionField = new TextField;
			addChild(_captionField);
			_captionField.width = 200;
			_captionField.height = 50;
			_captionField.x = (_width - _captionField.width) / 2;
			_captionField.y = _height - 60;
			_captionField.multiline = true;
			_captionField.wordWrap = true;
			_captionField.embedFonts = true;
			var fmt:TextFormat = _captionField.defaultTextFormat;
			fmt.color = 0x585858;
			fmt.font="Main";
			fmt.bold = true;
			fmt.align = TextFormatAlign.CENTER;
			fmt.size = 24;
			_captionField.defaultTextFormat = fmt;
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		public function onMouseDown(e:MouseEvent):void
		{
			if(!_isDrag)
			{	
				_lastPlace = this.mouseX/(_width/3);	// 0,1,2칸.
				
				stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
				stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
				
				_isDrag=true;
				onMouseMove(null);
			}
		}
		private function onMouseMove(e:MouseEvent):void
		{
			var currentPlace:int  = this.mouseX/(_width/3);
			
			if(_lastPlace != currentPlace)
			{
				if(_selectedIndex + (_lastPlace-currentPlace) >= 0)
					this.selectedIndex = _selectedIndex + (_lastPlace-currentPlace);
				
				_lastPlace = currentPlace;
			}
			_moveDir;
		}
		private function onMouseUp(e:MouseEvent):void
		{	
			_isDrag=false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		
		private function onRender(e:Event):void 
		{
			layout();
		}
		private function onXMLLoad(e:Event):void 
		{
			_xml = new XML(_urlLoader.data);
			
			var imageList:XMLList = _xml.image;
			var iLen:uint = imageList.length();
			var imageNode:XML;
			var cover:Cover;
			for (var i:uint = 0; i < iLen; i++) {
				imageNode = imageList[i];
				var src:String = imageNode.@src;
				var title:String = imageNode.@title;
				cover = new Cover(title, imageNode, _backgroundColor);
				cover.addEventListener(MouseEvent.MOUSE_DOWN, onCoverClick);
				cover.addEventListener(MouseEvent.MOUSE_MOVE, onCoverClick);
				cover.addEventListener(MouseEvent.MOUSE_UP, onCoverClick);
				_coversContainer.addChild(cover);
				_covers.push(cover);
			}
			layout();
			_loadCounter = 0;
			loadNextCover();
		}
		private var _prev_sel:int = -1;
		private var _isDragged:Boolean = false;
		private function onCoverClick(e:MouseEvent):void 
		{
			if(e.type == MouseEvent.MOUSE_DOWN)
			{
				_isDragged = false;
				_prev_sel = this.selectedIndex;
			}
			else if(e.type == MouseEvent.MOUSE_MOVE)
			{
				if(_prev_sel != _covers.indexOf(e.currentTarget))
					_isDragged = true;
			}
			else if(e.type == MouseEvent.MOUSE_UP)
			{
				if(!_isDragged)
				{
					if(this.selectedIndex == _covers.indexOf(e.currentTarget))
						_callback(null);
					else
						if(_prev_sel == this.selectedIndex)
							this.selectedIndex = _covers.indexOf(e.currentTarget);
				}
			}
		}
		private function layout():void 
		{
			//_selectedIndex = 4;
			var len:uint = _covers.length;
			var cover:Cover;
			var distanceFromCenter:uint
			for (var i:uint = 0; i < len; i++) {
				cover = _covers[i];
				if (i == _selectedIndex) {
					cover.rotationY = 0;
					cover.x = _background.width / 2;
					cover.z = 0;
					_coversContainer.setChildIndex(cover, _coversContainer.numChildren-1);
					_captionField.text = cover.caption;
				} else if (i < _selectedIndex) {
					distanceFromCenter = _selectedIndex - i;
					cover.rotationY = -_backRowAngle;
					cover.x = ((_background.width / 2) - _centerMargin) - (distanceFromCenter * _horizontalSpacing);
					cover.z = _backRowDepth;
					_coversContainer.setChildIndex(cover, _coversContainer.numChildren - (distanceFromCenter + 1));
					cover.dropOff = distanceFromCenter / 10;
				} else if (i > _selectedIndex) {
					distanceFromCenter = i - _selectedIndex;
					cover.rotationY = _backRowAngle;
					cover.x = ((_background.width / 2) + _centerMargin) + (distanceFromCenter * _horizontalSpacing);
					cover.z = _backRowDepth;
					_coversContainer.setChildIndex(cover, _coversContainer.numChildren - (distanceFromCenter + 1));
					cover.dropOff = distanceFromCenter / 10;
				}
				cover.y = _background.height - 90 + _verticalOffset;
			}
			_captionField.x = (_background.width - _captionField.width) / 2;
			_captionField.y = _background.height - 60 + _verticalOffset;
		}
		
		private function loadNextCover():void 
		{
			var cover:Cover = _covers[_loadCounter];
			var src:String = _xml.image[_loadCounter].@src;
			cover.load(src);
			cover.addEventListener(Event.COMPLETE, onCoverLoad);
			cover.addEventListener(ProgressEvent.PROGRESS, onCoverProgress);
		}
		
		private function onCoverLoad(e:Event):void 
		{
			e.target.removeEventListener(Event.COMPLETE, onCoverLoad);
			_loadCounter++;
			if (_loadCounter < _covers.length) {
				loadNextCover();
			} else {
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		private function onCoverProgress(e:ProgressEvent):void 
		{
			if (_bytesPerImage == 0) {
				_bytesPerImage = e.bytesTotal;
				_bytesTotal = _bytesPerImage * _covers.length;
			}
			var adjustedBytesLoaded:uint = e.bytesLoaded * (_bytesPerImage / e.bytesTotal);
			var cumulativeBytesLoaded:uint = (_loadCounter * _bytesPerImage) + adjustedBytesLoaded;
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, cumulativeBytesLoaded, _bytesTotal));
		}
		private function onXMLLoadError(e:IOErrorEvent):void 
		{
			trace("There was an error loading the XML document: " + e.text);
		}
		
		public function load(url:String):void 
		{
			clearContents();
			_urlLoader.load(new URLRequest(url));
		}
		public function set backgroundColor(val:uint):void 
		{
			_backgroundColor = val;
			drawBackground();
			for each (var cover:Cover in _covers) 
			{
				cover.backgroundColor = val;
			}
		}
		public function get backgroundColor():uint 
		{
			return _backgroundColor;
		}
		
		private function drawBackground():void 
		{
			_background.graphics.clear();
			//_background.graphics.beginFill(_backgroundColor, 1);
			_background.graphics.beginFill(0, 0);
			_background.graphics.drawRect(0, 0, _width, _height);
		}
		
		override public function set width(num:Number):void 
		{
			_width = num;
			_background.width = _width;
			scrollRect = new Rectangle(0, 0, _width, _height);
			this.transform.perspectiveProjection.projectionCenter = new Point(_width/2, _height-190);
			stage.invalidate();
		}
		override public function get width():Number 
		{
			return _width;
		}
		override public function set height(num:Number):void 
		{
			_height = num;
			_background.height = _height;
			scrollRect = new Rectangle(0, 0, _width, _height);
			this.transform.perspectiveProjection.projectionCenter = new Point(_width/2, _height-190);
			stage.invalidate();
		}
		override public function get height():Number 
		{
			return _height;
		}
		public function set centerMargin(num:Number):void {
			if (isNaN(num)) num = DEFAULT_CENTER_MARGIN;
			_centerMargin = Math.max(0, num);
			if (stage) stage.invalidate();
		}
		public function get centerMargin():Number {
			return _centerMargin;
		}
		
		public function set horizontalSpacing(num:Number):void {
			if (isNaN(num)) num = DEFAULT_HORIZONTAL_SPACING;
			_horizontalSpacing = Math.max(0, num);
			if (stage) stage.invalidate();
		}
		public function get horizontalSpacing():Number {
			return _horizontalSpacing;
		}
		
		public function set backRowDepth(num:Number):void {
			if (isNaN(num)) num = DEFAULT_BACK_ROW_DEPTH;
			_backRowDepth = Math.max(0, num);
			if (stage) stage.invalidate();
		}
		public function get backRowDepth():Number {
			return _backRowDepth;
		}
		
		public function set backRowAngle(num:Number):void {
			if (isNaN(num)) num = DEFAULT_BACK_ROW_ANGLE;
			_backRowAngle = Math.min(90, Math.abs(num));
			if (stage) stage.invalidate();
		}
		public function get backRowAngle():Number {
			return _backRowAngle;
		}
		
		public function set verticalOffset(num:Number):void {
			if (isNaN(num)) num = DEFAULT_VERTICAL_OFFSET;
			_verticalOffset = num;
			if (stage) stage.invalidate();
		}
		public function get verticalOffset():Number {
			return _verticalOffset;
		}
		public function set selectedIndex(index:uint):void {
			if (_covers.length == 0) {
				_selectedIndex = index;
				return;
			}
			_selectedIndex = Math.max(0, Math.min(index, _covers.length - 1));
			
			// if (stage) stage.invalidate();
			
			_startTime = getTimer();
			determineLayout(_selectedIndex);
			removeEventListener(Event.ENTER_FRAME, animate);
			addEventListener(Event.ENTER_FRAME, animate);
		}
		public function get selectedIndex():uint {
			return _selectedIndex;
		}
		
		private function determineLayout(destinationIndex:uint):void {
			_coversLength = _covers.length;
			for (var i:uint = 0; i < _coversLength; i++) {
				_iterationCover = _covers[i];
				if (i == destinationIndex) {
					_iterationCover.endRotationY = 0;
					_iterationCover.endX = _background.width / 2;
					_iterationCover.endZ = 0;
					_captionField.text = _iterationCover.caption;
				} else if (i < destinationIndex) {
					_unitsFromCenter = destinationIndex - i;
					_iterationCover.endRotationY = -_backRowAngle;
					_iterationCover.endX = ((_background.width / 2) - _centerMargin) - (_unitsFromCenter * _horizontalSpacing);
					_iterationCover.endZ = _backRowDepth;
				} else if (i > destinationIndex) {
					_unitsFromCenter = i - destinationIndex;
					_iterationCover.endRotationY = _backRowAngle;
					_iterationCover.endX = ((_background.width / 2) + _centerMargin) + (_unitsFromCenter * _horizontalSpacing);
					_iterationCover.endZ = _backRowDepth;
				}
			}
		}
		private function animate(e:Event):void {
			_elapsed = getTimer() - _startTime;
			if (_elapsed > _tweenDuration) {
				removeEventListener(Event.ENTER_FRAME, animate);
				return;
			}
			
			for (_iteration = 0; _iteration < _coversLength; _iteration++) {
				_iterationCover = _covers[_iteration];
				_iterationCover.updateTween(_elapsed, _tweenDuration);
			}
			
			_sortedCovers = _covers.concat();
			_sortedCovers = _sortedCovers.sort(depthSort);
			for (_iteration = 0; _iteration < _coversLength; _iteration++) {
				_iterationCover = _sortedCovers[_iteration];
				_coversContainer.setChildIndex(_iterationCover, _coversContainer.numChildren-(_iteration+1));
			}
			
		}
		private function depthSort(a:Cover, b:Cover):Number {
			var _distanceA:Number = Math.abs(a.x - _background.width/2);
			var _distanceB:Number = Math.abs(b.x - _background.width/2);
			if (_distanceA < _distanceB) { return -1;}
			if (_distanceA > _distanceB) { return 1; }
			
			return 0;
		}
		
		private function clearContents():void {
			for each (var cover:Cover in _covers) {
				cover.removeEventListener(Event.COMPLETE, onCoverLoad);
				cover.removeEventListener(ProgressEvent.PROGRESS, onCoverProgress);
				//				cover.addEventListener(MouseEvent.CLICK, onCoverClick);

				this.removeChild(cover);
			}
			_covers = new Vector.<Cover>();
			this.removeEventListener(Event.ENTER_FRAME, animate);
		}
	}
}