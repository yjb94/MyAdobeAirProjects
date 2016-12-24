package
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class TopMenuSprite extends Sprite
	{
		[Embed(source = "assets/top_menu/bg.png")]
		private static const TOP_MENU_BG:Class;
		
//		[Embed(source = "assets/top_menu/logo.png")]
//		private static const LOGO:Class;
		
		[Embed(source = "assets/top_menu/topMargin.png")]
		private static const TOP_MARGIN:Class;
		
		private var _bg:Bitmap;
		public function get Background():DisplayObject{ return _bg; }
//		private var _logo:Bitmap;
		
		
		private var _title:DisplayObject;
		public function get Title():DisplayObject{ return _title; }
		public function set Title(value:DisplayObject):void{ if(_title) removeChild(_title); _title=value; onResize(); }
		
		private var _leftButton:DisplayObject;
		public function get LeftButton():DisplayObject{ return _leftButton; }
		public function set LeftButton(value:DisplayObject):void{ if(_leftButton) removeChild(_leftButton); _leftButton=value; onResize(); }
		private var _rightButton:DisplayObject;
		public function get RightButton():DisplayObject{ return _rightButton; }
		public function set RightButton(value:DisplayObject):void{ if(_rightButton) removeChild(_rightButton); _rightButton=value; onResize(); }
		
		private var _addedChild:Vector.<DisplayObject>;
		
		
		public function TopMenuSprite()
		{
			super();
			
			_title=null;
			_leftButton=null;
			_rightButton=null;

			_addedChild=new Vector.<DisplayObject>;
			
			_bg=new TOP_MENU_BG;
			_bg.smoothing=true;
			super.addChild(_bg);
			
//			_logo=new LOGO;
//			_logo.smoothing=true;
//			super.addChild(_logo);
		}
		
		public function onResize():void{
			this.scaleX=Brain.Main.FullWidth/_bg.width;
			this.scaleY=this.scaleX;
			//_bg.width=Elever.Main.FullWidth;
			//_bg.scaleY=_bg.scaleX;
			
			//iPhone이고, iOS7일 경우 상단 바 버그가 있으므로 검사해서 강제로 40픽셀정도 그려준다.
			var topMargin:Number=Math.ceil(Brain.Main.TopMargin);
			if(_bg.y!=topMargin){
				_bg.y=topMargin;
				
				//graphics.clear();
				if(topMargin>0)
				{
//					graphics.beginFill(0xdd5858,1);
//					graphics.drawRect(0,0,_bg.width,_bg.y);
//					graphics.endFill();
					var bmp:Bitmap = new TOP_MARGIN;
					bmp.smoothing = true;
					super.addChild(bmp);
				}
			}
			
			if(_title){
				if(!_title.parent) super.addChild(_title);
				_title.x=_bg.width/2-_title.width/2;
				_title.y=_bg.y+(_bg.height-7)/2-_title.height/2;
			}
			
			if(_leftButton){
				//if(_logo.parent) removeChild(_logo);
				if(!_leftButton.parent) super.addChild(_leftButton);
				_leftButton.x=_bg.width*0.03;
				_leftButton.y=_bg.y+(_bg.height-7)/2-_leftButton.height/2;
			}
//			else{
//				if(!_logo.parent) super.addChild(_logo);
//				_logo.x=_bg.width*0.03;
//				_logo.y=_bg.y+(_bg.height-7)/2-_logo.height/2;
//			}
			
			
			if(_rightButton){
				if(!_rightButton.parent) super.addChild(_rightButton);
				_rightButton.x=_bg.width-_bg.width*0.03-_rightButton.width;
				_rightButton.y=_bg.y+(_bg.height-7)/2-_rightButton.height/2;
			}
		}
		
		public override function addChild(child:DisplayObject):DisplayObject{
			var mc:DisplayObject=super.addChild(child);
			
			_addedChild[_addedChild.length]=mc;
			
			return mc;
		}
		
		public function clearAddedChild():void{
			for(var i:int=0;i<_addedChild.length;i++){
				if(_addedChild[i].parent){
					removeChild(_addedChild[i]);
				}
				_addedChild[i]=null;
			}
			_addedChild.splice(0,_addedChild.length);
			
			Title=null;
			LeftButton=null;
			RightButton=null;
		}
	}
}