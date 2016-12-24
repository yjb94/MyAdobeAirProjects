package Page.Main
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.GesturePhase;
	import flash.events.MouseEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.events.TransformGestureEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.ReturnKeyLabel;
	import flash.text.SoftKeyboardType;
	import flash.text.StageText;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.Text;
	
	import Header.NavigationBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	
	import Scroll.Scroll;
	
	public class DetailPage extends BasePage
	{
		private var _params:Object;	
		public function DetailPage(params:Object=null)
		{
			super();
			
			_params = params;
			
			//display top
			(Calender.Main.header.getChildAt(0) as NavigationBar).Right = null;
			var txt:TextField = new TextField;
			var fmt:TextFormat = txt.defaultTextFormat;
			fmt.font = "NanumGothicBold";
			fmt.size = 40;
			fmt.color = 0xffffff;
			txt.defaultTextFormat = fmt;
			txt.embedFonts=true;
			txt.text = _params.schedule;
			txt.autoSize = TextFieldAutoSize.CENTER;
			(Calender.Main.header.getChildAt(0) as NavigationBar).Middle = txt;
		}
		public override function onResize():void
		{
		}
		
		public override function dispose():void
		{
		}
	}
}