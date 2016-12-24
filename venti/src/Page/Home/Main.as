package Page.Home
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.net.URLVariables;
	import flash.text.TextField;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.Popup;
	import Displays.RadioButton;
	import Displays.Text;
	import Displays.WebImage;
	
	import Header.NavigationBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	
	import Scroll.Scroll;
	
	public class Main extends BasePage
	{
		
		public function Main(params:Object=null)
		{
			super();
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).clearPrev();
			
			var spr:Sprite = new Sprite;
			spr.graphics.beginFill(0x234f62);
			spr.graphics.drawRect(0, 0, Elever.Main.PageWidth, Elever.Main.PageHeight);
			spr.graphics.endFill();
			spr.addEventListener(MouseEvent.CLICK, function(e:MouseEvent){ Elever.Main.changePage("HomePage", PageEffect.FADE) });
			addChild(spr);
			
			spr.addChild(Text.newText("'나'만의 FUN한 적금", 50, 0xffffff, 0, 400, "center", "NanumBarunGothic", Elever.Main.PageWidth));
			spr.addChild(Text.newText("당신만을 위한 적금을 추천해 드립니다", 24, 0xffffff, 0, 460, "center", "NanumBarunGothic", Elever.Main.PageWidth));
			spr.addChild(Text.newText("Venti", 20, 0xffffff, 0, 900, "center", "NanumBarunGothic", Elever.Main.PageWidth));
		}
		public override function init():void
		{
		}
		public override function onResize():void
		{
		}
		public override function dispose():void
		{
		}
	}
}

