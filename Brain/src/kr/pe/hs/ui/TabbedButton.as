package kr.pe.hs.ui
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class TabbedButton extends Sprite
	{		
		private var _isTabbed:Boolean;
		
		private var _normalButton:DisplayObject;
		public function get Normal():DisplayObject{ return _normalButton; }
		public function set Normal(obj:DisplayObject):void{
			if(_normalButton.parent!=null){
				removeChild(_normalButton);
				addChild(obj);
			}
			_normalButton=obj; 
		}
		private var _downButton:DisplayObject;
		public function get Down():DisplayObject{ return _downButton; }
		public function set Down(obj:DisplayObject):void{
			if(_downButton.parent!=null){
				removeChild(_downButton);
				addChild(obj);
			}
			_downButton=obj; 
		}
		private var _tabbedButton:DisplayObject;
		public function get Tabbed():DisplayObject{ return _tabbedButton; }
		public function set Tabbed(obj:DisplayObject):void{
			if(_tabbedButton.parent!=null){
				removeChild(_tabbedButton);
				addChild(obj);
			}
			_tabbedButton=obj;
		}
		 
		public function TabbedButton(normal:DisplayObject,down:DisplayObject=null,tabbed:DisplayObject=null)
		{
			super();
			
			_normalButton=normal;
			if(down==null) _downButton=normal;
			else _downButton=down;
			if(down==null) _tabbedButton=normal;
			else _tabbedButton=tabbed;	
			_isTabbed=false;
			addChild(_normalButton);
			
			buttonMode=true;
			
			/*addEventListener(MouseEvent.ROLL_OVER,onRollOver);
			addEventListener(MouseEvent.ROLL_OUT,onRollOut);*/
			addEventListener(MouseEvent.MOUSE_DOWN,onDown);
		}
		
		private function onDown(e:MouseEvent):void{
			if(!_isTabbed){
				removeChild(_normalButton);
				addChild(_downButton);
				
				stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
			}
		}
		private function onUp(e:MouseEvent):void{
			if(!_isTabbed){
				removeChild(_downButton);
				addChild(_normalButton);
			}
			stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
		}
		/*private function onRollOver(e:MouseEvent):void{
			if(!_isTabbed){
				removeChild(_normalButton);
				addChild(_downButton);
			}
		}
		private function onRollOut(e:MouseEvent):void{
			if(!_isTabbed){
				removeChild(_downButton);
				addChild(_normalButton);
			}
		}*/
		
		public function get isTabbed():Boolean{ return _isTabbed; }
		public function set isTabbed(value:Boolean):void{
			_isTabbed=value;
			if(_isTabbed){
				if(_normalButton.parent) removeChild(_normalButton);
				if(_downButton.parent) removeChild(_downButton);
				addChild(_tabbedButton);
			}
			else{
				if(_tabbedButton.parent) removeChild(_tabbedButton);
				if(_downButton.parent) removeChild(_downButton);				
				addChild(_normalButton);
			}
		}
	}
}