package Displays
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class Popup extends Sprite
	{
		public static const NONE_TYPE:String = "NONE";
		public static const OK_TYPE:String = "OK";
		public static const YESNO_TYPE:String = "YESNO";
	
		public const TWEEN_DURATION:Number = 0.1;
		public const TITLE_MARGIN:Number = 18;
		public const MAIN_MINUS_MARGIN:Number = 40;
		public const BG_ALPHA:Number = 0.6;
		
		private var _bg:Sprite;
		
		private var _callback:Function;
		
		public function Popup(type:String, params:Object = null):void
		{
			super();
			
			var title_text:String = "알림";
			var main_text:String = "내용 없음";
			
			if(params) 
			{
				if(params.callback) 
					_callback = params.callback;
				if(params.title_text)
					title_text = params.title_text;
				if(params.main_text)
					main_text = params.main_text;
			}
			
			_bg = new Sprite;
			_bg.name = "popup";
			
			_bg.graphics.beginFill(0x000000, BG_ALPHA);
			_bg.graphics.drawRect(0,0,Elever.Main.FullWidth,Elever.Main.FullHeight);
			_bg.graphics.endFill();
			_bg.cacheAsBitmap=true;
			_bg.alpha = 0;
			
			var bmp:Bitmap = BitmapControl.newBitmap(BitmapControl.POPUP_BG, Elever.Main.FullWidth/2, Elever.Main.FullHeight/2, true);
			_bg.addChild(bmp);
			
			_bg.addChild(Text.newText(title_text, 25, 0xffffff, bmp.x, bmp.y + TITLE_MARGIN, "center", "NanumBarunGothic", bmp.width));
			var txt:TextField = Text.newText(main_text, 25, 0x828282, bmp.x, bmp.y + bmp.height/2 - MAIN_MINUS_MARGIN, "center", "NanumBarunGothic", bmp.width);
			_bg.addChild(txt);
			
			if(type == YESNO_TYPE)
			{
				//no button
				var btn:Button = new Button(BitmapControl.POPUP_NO, BitmapControl.POPUP_NO);
				btn.name = "no";
				btn.x = bmp.x + bmp.width/2/2 - btn.width/2;
				btn.y = bmp.y + bmp.height - bmp.height/2/2 - btn.height/2;
				_bg.addChild(btn);
				//yes button
				btn = new Button(BitmapControl.POPUP_YES, BitmapControl.POPUP_YES);
				btn.name = "yes";
				btn.x = bmp.x + bmp.width/2 + bmp.width/2/2 - btn.width/2;
				btn.y = bmp.y + bmp.height - bmp.height/2/2 - btn.height/2;
				_bg.addChild(btn);
			}
			else if(type == OK_TYPE)
			{
				//ok button
				btn = new Button(BitmapControl.POPUP_OK, BitmapControl.POPUP_OK);
				btn.name = "ok";
				btn.x = bmp.x + bmp.width/2 - btn.width/2;
				btn.y = bmp.y + bmp.height - bmp.height/2/2 - btn.height/2;
				_bg.addChild(btn);
			}
			else if(type == NONE_TYPE)
			{
				txt.y = bmp.y + bmp.height/2;
			}
			
			Elever.Main.topLayer.addChild(_bg);
			
			_bg.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			TweenLite.to(_bg, TWEEN_DURATION, { alpha:1 });
		}
		private function onMouseClick(e:MouseEvent):void
		{
			var type:String = "none";
			
			if((_bg.getChildByName("yes") as Button) != null)
				if((_bg.getChildByName("yes") as Button).isTabbed)
					type = "yes";
			
			if((_bg.getChildByName("no") as Button) != null)
				if((_bg.getChildByName("no") as Button).isTabbed)
					type = "no";
			
			if((_bg.getChildByName("ok") as Button) != null)
				if((_bg.getChildByName("ok") as Button).isTabbed)
					type = "ok";
			
			close();
			
			if(_callback) _callback(type);
		}
		
		public function close():void
		{
			TweenLite.to(_bg, TWEEN_DURATION, { alpha:0, onComplete:function():void
			{
				_bg.removeEventListener(MouseEvent.CLICK, onMouseClick);
				Elever.Main.topLayer.removeChild(_bg);
			}});
		}
	}
}