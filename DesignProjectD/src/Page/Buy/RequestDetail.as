package Page.Buy
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.Popup;
	import Displays.SlideImage;
	import Displays.Text;
	import Displays.WebImage;
	
	import Header.NavigationBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	
	import Scroll.Scroll;
	
	"main/slide";
	public class RequestDetail extends BasePage
	{
		private const DRAG_COEFFICIENT:Number = 15*Config.ratio;
		
		private const FIRST_Y:Number = 844*Config.ratio;
		private const SECOND_Y:Number = 1304*Config.ratio;
		private const THIRD_Y:Number = 1777*Config.ratio;
		private const WIDTH_MARGIN:Number = 36*Config.ratio;
		
		private const TEXT_Y_MARGIN:Number = 26;
		
		private const TITLE_FONT_SIZE:Number = 50*Config.ratio;
		private const TEXT_FONT_SIZE:Number = 20;
		
		private const INPUT_TEXT_FONT_SIZE:Number = 42*Config.ratio;
		private const TEXTBOX_HEIGHT:Number = 58;
		
		private const TEXTBOX_MARGIN:Number = 30;
		
		private const CAR_FONT_SIZE:Number = 50*Config.ratio;
		private const COMPANY_FONT_SIZE:Number = 40*Config.ratio;
		
		private const ANCHOR_TWEEN_DURATION:Number = 0.3;
		private const BASE_Y_INTERVAL:Number = 100;
		
		private const BASE_Y:Number = 300;
		private var _displays:Sprite;
		
		private var _user_data:Object;
		
		public function RequestDetail(params:Object=null)
		{
			super();
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = Text.newText(params.car_data.name, TITLE_FONT_SIZE, 0xffffff);
			
			//Car Spr
			var spr:Sprite = new Sprite;
			addChild(spr);
			spr.y = 50;
			
			var img:WebImage = new WebImage(params.car_data.thumbnail, BitmapControl.CAR_MASK);
			img.name = name;
			img.x = 50;
			spr.addChild(img);

			var txt:TextField = Text.newText(params.car_data.name, CAR_FONT_SIZE, 0x000000, img.x + img.width + 15, 10, "left", "NanumBarunGothic", Elever.Main.PageWidth, 0, { bold:true });
			txt.name = "name";
			spr.addChild(txt);
			txt = Text.newText(params.car_data.company, COMPANY_FONT_SIZE, 0x494949, txt.x, txt.y + txt.height + 10, "left", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			txt.name = "company";
			spr.addChild(txt);
			
			var bmp:Bitmap = BitmapControl.newBitmap(BitmapControl.BUY_SEPERATE_LINE, 0, img.y + img.height + TEXT_Y_MARGIN);
			spr.addChild(bmp);
			
			_user_data = params.request_data;	//user_name, user_email, user_phone, user_comment
			
			//예약 사람
			txt = Text.newText("신청자", TEXT_FONT_SIZE, 0x2c2c2c,  img.x + img.width + 15, txt.y + txt.height + 50, "left", "NanumBarunGothic", 0, 0);
			spr.addChild(txt);
			
			txt = Text.newText(_user_data.user_name, TEXT_FONT_SIZE, 0x3b3b3b, 0, txt.y, "right", "NanumBarunGothic", 600);
			spr.addChild(txt);
			
			//예약 이메일
			txt = Text.newText("이메일", TEXT_FONT_SIZE, 0x2c2c2c,  img.x + img.width + 15, txt.y + txt.height + 10, "left", "NanumBarunGothic", 0, 0);
			spr.addChild(txt);
			
			txt = Text.newText(_user_data.user_email, TEXT_FONT_SIZE, 0x3b3b3b, 0, txt.y, "right", "NanumBarunGothic", 600);
			spr.addChild(txt);
			
			//예약 핸드폰
			txt = Text.newText("휴대폰", TEXT_FONT_SIZE, 0x2c2c2c,  img.x + img.width + 15, txt.y + txt.height + 10, "left", "NanumBarunGothic", 0, 0);
			spr.addChild(txt);
			
			txt = Text.newText(_user_data.user_phone, TEXT_FONT_SIZE, 0x3b3b3b, 0, txt.y, "right", "NanumBarunGothic", 600);
			spr.addChild(txt);
			
			//남기는말
			txt = Text.newText("남기는말", 40*Config.ratio, 0x2c2c2c,  35, bmp.y + bmp.height + TEXT_Y_MARGIN, "left", "NanumBarunGothic", 0, 0);
			spr.addChild(txt);
			
			txt = Text.newText(_user_data.user_comment, TEXT_FONT_SIZE, 0x3b3b3b, 35, txt.y +txt.height + 10, "left", "NanumBarunGothic", 545, -1, { leading:10 });
			spr.addChild(txt);
			
			
			//전화 버튼
			var btn:Button = new Button(BitmapControl.BUTTON_CALL, BitmapControl.BUTTON_CALL, onButtonCall, 0, 0);
			btn.y = Elever.Main.PageHeight - Elever.Main.HeaderHeight*2 - btn.height - 10;
			btn.x = Elever.Main.PageWidth - btn.width - 30;
			spr.addChild(btn);
			
			btn = new Button(BitmapControl.BUTTON_MAIL, BitmapControl.BUTTON_MAIL, onButtonMail, btn.x - 30, btn.y);
			btn.x -= btn.width;
			spr.addChild(btn);
		}
		private function onButtonCall(e:MouseEvent):void
		{
			const callURL:String="tel:"+_user_data.user_phone;
			navigateToURL(new URLRequest(callURL));
		}
		private function onButtonMail(e:MouseEvent):void
		{
			const callURL:String="mailto:"+_user_data.user_email;
			navigateToURL(new URLRequest(callURL));
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
