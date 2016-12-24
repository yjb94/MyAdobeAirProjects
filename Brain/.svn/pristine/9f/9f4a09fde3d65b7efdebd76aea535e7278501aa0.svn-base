package kr.pe.hs.ui
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.SoftKeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.StageText;
	import flash.text.StageTextInitOptions;
	
	public class AppTextField extends Sprite
	{
		private var _stageText:StageText;
		public function get stageText():StageText{ return _stageText; }
		
		private var _softKeyboardEnabled:Boolean;
		public function get softKeyboardEnabled():Boolean{ return _softKeyboardEnabled; }
		public function set softKeyboardEnabled(value:Boolean):void{ _softKeyboardEnabled=value; }
		
		public function get softKeyboardType():String{ return _stageText.softKeyboardType; }
		public function set softKeyboardType(value:String):void{ _stageText.softKeyboardType=value; }
		
		public function get displayAsPassword():Boolean{ return _stageText.displayAsPassword; }
		public function set displayAsPassword(value:Boolean):void{ _stageText.displayAsPassword=value; }
		
		public function get fontFamily():String{ return _stageText.fontFamily; }
		public function set fontFamily(value:String):void{ _stageText.fontFamily=value; }
		
		public function get color():uint{ return _stageText.color; }
		public function set color(value:uint):void{ _stageText.color=value; }
		
		public function get textAlign():String{ return _stageText.textAlign; }
		public function set textAlign(value:String):void{ _stageText.textAlign=value; }
		
		public function get multiline():Boolean{ return _stageText.multiline; }
		
		private var _returnKeyLabel:String;
		public function get returnKeyLabel():String{ return _returnKeyLabel; }
		public function set returnKeyLabel(value:String):void{ _stageText.returnKeyLabel=value; }
		
		public function get text():String{ return _stageText.text; }
		public function set text(value:String):void{ _stageText.text=value; }
		
		private var _fontSize:Number;
		public function get fontSize():Number{ return _fontSize; }
		public function set fontSize(value:Number):void{ _fontSize=value; }
		
		private var _width:Number;
		public override function get width():Number{ return _width; }
		public override function set width(value:Number):void{ _width=value; }
		
		private var _height:Number;
		public override function get height():Number{ return _height; }
		public override function set height(value:Number):void{ _height=value; }
				
		public function AppTextField(multiline:Boolean=false)
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoved);
			
			cacheAsBitmap=true;
			softKeyboardEnabled=true;
			_width=0;
			_height=0;
			
			var option:StageTextInitOptions=new StageTextInitOptions(multiline);
			_stageText=new StageText(option);
			_stageText.visible=true;
			//_stageText.visible=false;
			_stageText.fontFamily="Arial";
		}
		
		private function onAdded(e:Event):void{
			_stageText.stage=stage;
			var startPoint:Point=localToGlobal(new Point(0,0));
			var endPoint:Point=localToGlobal(new Point(_width,_height));
			_stageText.viewPort=new Rectangle(Math.round(startPoint.x),Math.round(startPoint.y),Math.ceil(endPoint.x-startPoint.x),Math.ceil(endPoint.y-startPoint.y));			
			_stageText.fontSize=_stageText.viewPort.height/(_height/fontSize);
		}
		
		private function onRemoved(e:Event):void{
			_stageText.visible=false;
			_stageText.stage=null;
		}
		
		public override function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void{
			if(type==SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE || 
				type==SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING || 
				type==SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE ||
				type==Event.CHANGE
			){
				_stageText.addEventListener(type,listener,useCapture,priority,useWeakReference);
			}
			else{
				super.addEventListener(type,listener,useCapture,priority,useWeakReference);
			}
		}
		
		public override function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void{
			if(type==SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE || 
				type==SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATING || 
				type==SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE ||
				type==Event.CHANGE
			){
				_stageText.removeEventListener(type,listener,useCapture);
			}
			else{
				super.removeEventListener(type,listener,useCapture);
			}
		}
	}
}