package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import kr.pe.hs.tween.Tween;
	import kr.pe.hs.ui.TabbedButton;
	
	public class PopupMenu extends Sprite
	{
		private var _isOpened:Boolean;
		private var _tweenOpen:Vector.<Tween>;
		
		public function get isOpened():Boolean{ return _isOpened; }
		public function set isOpened(value:Boolean):void{			
			if(_isOpened!=value){
				var i:int;
				
				for(i=0;i<_tweenOpen.length;i++){
					_tweenOpen[i].endTween();
					_tweenOpen[i]=null;
				}
				_tweenOpen.splice(0,_tweenOpen.length);
				
				var startValue:Number=1;
				var endValue:Number=0;
				
				if(!value){
					startValue=_content.x/Brain.Main.FullWidth;
					if(_isOpened) endValue=-1;
					else endValue=1;
				}
				
				for(i=0;i<_buttons.length;i++){
					_buttons[i].x=startValue*Brain.Main.FullWidth;
					_tweenOpen[i]=new Tween(startValue,endValue,0,300+(75*i),function(value:Number,isFinish:Boolean):void{
						var idx:int=_tweenOpen.indexOf(this);
						_buttons[idx].x=value*Brain.Main.FullWidth;
						_buttons[idx].alpha=1-Math.abs(value);
						
						if(isFinish){
							if(idx==_buttons.length-1){
								visible=_isOpened;
								_content.visible=_isOpened;	
							}
						}
					});
				}
				
				_isOpened=value;
				visible=true;
				_content.visible=true;
				
				onResize();
			}
		}
		
		
		
		private var _buttonClickCallback:Function;
		
		private var _content:Sprite;
		
		private var _buttons:Vector.<TabbedButton>;
		public function get Buttons():Vector.<TabbedButton>{ return _buttons; }
		
		public function PopupMenu(buttonsBitmap:Vector.<Vector.<Class>>,onClickCallback:Function)
		{
			super();			
			
			_buttonClickCallback=onClickCallback;
			
			_content=new Sprite;
			
			addChild(_content);
			

			_tweenOpen=new Vector.<Tween>;
			_buttons=new Vector.<TabbedButton>;
			for(var i:int=0;i<buttonsBitmap.length;i++){
				var bmp:Bitmap = new buttonsBitmap[i][0]; bmp.smoothing=true;
				var bmp_on:Bitmap = null;
				if(buttonsBitmap[i][1]!=null) bmp_on=new buttonsBitmap[i][1];
				else{
					bmp_on=new buttonsBitmap[i][0];
					bmp_on.alpha=0.6;
				}
				bmp_on.smoothing=true;
				var btn:TabbedButton=new TabbedButton(bmp,bmp_on,bmp_on);
				btn.addEventListener(MouseEvent.CLICK,button_onClick);
				_content.addChild(btn);
				_buttons[_buttons.length]=btn;
			}
			
			
			visible=false;
			_isOpened=false;
						
			onResize();
			
			addEventListener(MouseEvent.CLICK,onClick);
		}
				
		public function onResize():void{
			if(!visible){
				graphics.clear();
				graphics.beginFill(0x000000,0);
				graphics.drawRect(0,Brain.Main.TopMargin,Brain.Main.FullWidth,Brain.Main.FullHeight-Brain.Main.TopMargin);
				graphics.endFill();
				
				_content.x=0;
				
				for(var i:int=0;i<_buttons.length;i++){
					if(i==0)
						_buttons[i].y=0;
					else
						_buttons[i].y=_buttons[i-1].y+_buttons[i-1].height;
				}
				
				_content.y=(Brain.Main.FullHeight-Brain.Main.TopMargin)/2-_content.height/2;
			}
		}
		
		public function dispose():void{
			var i:int;
			
			for(i=0;i<_tweenOpen.length;i++){
				_tweenOpen[i].endTween();
				_tweenOpen[i]=null;
			}
			_tweenOpen.splice(0,_tweenOpen.length);
		}
		
		private function onClick(e:MouseEvent):void{
			if(_content.y>this.mouseY || _content.y+_content.height<this.mouseY){
				isOpened=false;
			}
		}
		
		private function button_onClick(e:MouseEvent):void{
			var idx:int=_buttons.indexOf(e.currentTarget);
			_buttonClickCallback(idx);
		}
		
	}
}