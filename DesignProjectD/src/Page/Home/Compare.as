package Page.Home
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
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
	
	public class Compare extends BasePage
	{
		public static const CAR_SIZE:Array = ["경차", "소형", "준중형", "중형", "대형", "스포츠카", "슈퍼카"];
		public static const CAR_TYPE:Array = ["FF", "FR", "RR", "MR", "4WD", "AWD"];
		
		private const ICONS_MARGIN:Number = 32*Config.ratio;
		private const TEXTBOX_X_MARGIN:Number = 50;
		private const TEXTBOX_Y_MARGIN:Number = 37*Config.ratio;
		private const TWEEN_DURATION:Number = 0.3;
		
		private const TITLE_FONT_SIZE:Number = 50*Config.ratio;
		private const ITEM_FONT_SIZE:Number = 40*Config.ratio;
		private const ITEM_NAME_FONT_SIZE:Number = 58*Config.ratio;
		private const SMALL_FONT_SIZE:Number = 30.87*Config.ratio;
		
		private const BAR_HEIGHT:Number = 15;
		
		private const BASE_POPUP_Y:Number = 116;
		private const POPUP_TEXT_MARGIN:Number = 77;
		
		private const TRIANGLE_HEIGHT:Number = 121;
		
		private const BAR_MARGIN:Number = 61;
		
		private var _displays:Scroll;
		
		private var _bottom_line:Bitmap;
		
		private var _car_cnt:int = 0;
		
		private var _slide_image:SlideImage;
		public function get isZoomed():Boolean { return _slide_image.isZoomed(); }
		public function zoomOut():void { _slide_image.zoomOut(); }
		
		private var _date_popup_bg:Sprite;
		
		private var _car1_bg:Sprite;
		private var _car2_bg:Sprite;
		private var _data_bg:Sprite;
		
		private var _item_data:Object;
		public function Compare(params:Object=null)
		{
			super();
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).clearPrev();
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = Text.newText("차량비교", TITLE_FONT_SIZE, 0xffffff);
			
			
			var bg:Sprite = new Sprite;
			var bmp:Bitmap = BitmapControl.newBitmap(BitmapControl.COMPARE_TOP_BG);
			bg.addChild(bmp);
			
			
			var url:String = "";
			
			if(Elever._car_save_data[0] != null)
				url = Elever._car_save_data[0].thumbnail;
	
			_car1_bg = new Sprite;
			setCarSprite(_car1_bg, url, "1");
			
			url = "";
			
			if(Elever._car_save_data[1] != null)
				url = Elever._car_save_data[1].thumbnail;
			
			_car2_bg = new Sprite;
			_car2_bg.x = Elever.Main.PageWidth/2;
			setCarSprite(_car2_bg, url, "2");
			
			_displays = new Scroll(true, -1, Elever.Main.PageHeight-_car1_bg.height-Elever.Main.footer.height, -1, 0, null, true);
			_displays.y = 400;
			bmp = BitmapControl.newBitmap(BitmapControl.COMPARE_BG);
			bmp.name = "bg";
			_displays.addObject(bmp);
			setbg();
			addChild(_displays);
			
			addChild(bg);
			addChild(_car1_bg);
			addChild(_car2_bg);
			
			if(Elever._car_save_data[0] != null)
				setData1();
			if(Elever._car_save_data[1] != null)
				setData2();
			
			if(_car_cnt == 2)
			{
				compare();
			}
			
			Elever.Main.LoadingVisible = false;
		}
		private function setData1():void
		{
			var obj:Object = Elever._car_save_data[0];
			
			var txt:TextField = Text.newText(obj.price, SMALL_FONT_SIZE, 0x000000, 0, 0, "left", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_data_bg.addChild(txt);
			
			txt = Text.newText(obj.size, SMALL_FONT_SIZE, 0x000000, 0, txt.y + txt.height + 38, "left", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_data_bg.addChild(txt);
			
			txt = Text.newText(obj.number, SMALL_FONT_SIZE, 0x000000, 0, txt.y + txt.height + 38, "left", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_data_bg.addChild(txt);
			
			txt = Text.newText(obj.type, SMALL_FONT_SIZE, 0x000000, 0, txt.y + txt.height + 38, "left", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_data_bg.addChild(txt);
			
			txt = Text.newText(obj.fuel, SMALL_FONT_SIZE, 0x000000, 0, txt.y + txt.height + 38, "left", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_data_bg.addChild(txt);
			
			txt = Text.newText(obj.f_type, SMALL_FONT_SIZE, 0x000000, 0, txt.y + txt.height + 38, "left", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_data_bg.addChild(txt);
			
			txt = Text.newText(obj.speed, SMALL_FONT_SIZE, 0x000000, 0, txt.y + txt.height + 38, "left", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_data_bg.addChild(txt);
			
			txt = Text.newText(obj.hp, SMALL_FONT_SIZE, 0x000000, 0, txt.y + txt.height + 38, "left", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_data_bg.addChild(txt);
			
			txt = Text.newText(obj.torque, SMALL_FONT_SIZE, 0x000000, 0, txt.y + txt.height + 38, "left", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_data_bg.addChild(txt);
			
			txt = Text.newText(obj.value1, SMALL_FONT_SIZE, 0x000000, 0, txt.y + txt.height + 38, "left", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_data_bg.addChild(txt);
			
			txt = Text.newText(obj.value2, SMALL_FONT_SIZE, 0x000000, 0, txt.y + txt.height + 38, "left", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_data_bg.addChild(txt);
			
			_car_cnt++;
		}
		private function setData2():void
		{
			var obj:Object = Elever._car_save_data[1];
			
			var txt:TextField = Text.newText(obj.price, SMALL_FONT_SIZE, 0x000000, 0, 0, "right", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_data_bg.addChild(txt);
			
			txt = Text.newText(obj.size, SMALL_FONT_SIZE, 0x000000, 0, txt.y + txt.height + 38, "right", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_data_bg.addChild(txt);
			
			txt = Text.newText(obj.number, SMALL_FONT_SIZE, 0x000000, 0, txt.y + txt.height + 38, "right", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_data_bg.addChild(txt);
			
			txt = Text.newText(obj.type, SMALL_FONT_SIZE, 0x000000, 0, txt.y + txt.height + 38, "right", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_data_bg.addChild(txt);
			
			txt = Text.newText(obj.fuel, SMALL_FONT_SIZE, 0x000000, 0, txt.y + txt.height + 38, "right", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_data_bg.addChild(txt);
			
			txt = Text.newText(obj.f_type, SMALL_FONT_SIZE, 0x000000, 0, txt.y + txt.height + 38, "right", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_data_bg.addChild(txt);
			
			txt = Text.newText(obj.speed, SMALL_FONT_SIZE, 0x000000, 0, txt.y + txt.height + 38, "right", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_data_bg.addChild(txt);
			
			txt = Text.newText(obj.hp, SMALL_FONT_SIZE, 0x000000, 0, txt.y + txt.height + 38, "right", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_data_bg.addChild(txt);
			
			txt = Text.newText(obj.torque, SMALL_FONT_SIZE, 0x000000, 0, txt.y + txt.height + 38, "right", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_data_bg.addChild(txt);
			
			txt = Text.newText(obj.value1, SMALL_FONT_SIZE, 0x000000, 0, txt.y + txt.height + 38, "right", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_data_bg.addChild(txt);
			
			txt = Text.newText(obj.value2, SMALL_FONT_SIZE, 0x000000, 0, txt.y + txt.height + 38, "right", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_data_bg.addChild(txt);
			
			_car_cnt++;
		}
		private function compare():void
		{
			var obj1:Object = Elever._car_save_data[0];
			var obj2:Object = Elever._car_save_data[1];
			
			//출시일 비교
			compareAndDraw(obj1.price, obj2.price, 7, true);
			
			//차량 크기 비교
			rankAndDraw(CAR_SIZE.indexOf(obj1.size), CAR_SIZE.indexOf(obj2.size), 7+BAR_MARGIN);
			
			//인원수 비교
			compareAndDraw(obj1.number, obj2.number, 7+BAR_MARGIN*2);
			
			//구동방식 비교
			var str1:String = obj1.type.split('(')[1].substring(0, obj1.type.split('(')[1].length -1);
			var str2:String = obj2.type.split('(')[1].substring(0, obj2.type.split('(')[1].length -1);
			
			rankAndDraw(CAR_TYPE.indexOf(str1), CAR_TYPE.indexOf(str2), 7+BAR_MARGIN*3);
			
			//연비 비교
			compareAndDraw(obj1.fuel, obj2.fuel, 7+BAR_MARGIN*4);
			
			//연료 배기량 비교
			compareAndDraw(obj1.f_type, obj2.f_type, 7+BAR_MARGIN*5);
			
			//최고속도 비교
			compareAndDraw(obj1.speed, obj2.speed, 7+BAR_MARGIN*6);
			
			//출력 비교
			compareAndDraw(obj1.hp, obj2.hp, 7+BAR_MARGIN*7);
			
			//토크 비교
			compareAndDraw(obj1.torque, obj2.torque, 7+BAR_MARGIN*8);
			
			//승차감 비교
			compareAndDraw(obj1.value1, obj2.value1, 7+BAR_MARGIN*9);
			
			//주행성능 비교
			compareAndDraw(obj1.value2, obj2.value2, 7+BAR_MARGIN*10);
		}
		private function compareAndDraw(str1:String, str2:String, y:Number, isReverse:Boolean=false):void
		{
			if(isReverse)
			{
				var temp:String = str1;
				str1 = str2;
				str2 = temp;
			}
			var num1:Number = removeNonNumericChars(str1);
			var num2:Number = removeNonNumericChars(str2);
			var whoes_big:String = ((num1-num2) < 0) ? "left" : "right";
			if(num1 == num2) whoes_big = "same";
			var total:Number = num1 + num2;
			drawbar(y, (num1/total)*10.0, "left", whoes_big);   drawbar(y, (num2/total)*10.0, "right", whoes_big);
		}
		private function rankAndDraw(num1:Number, num2:Number, y:Number):void
		{
			num1++; num2++;
			var whoes_big:String = ((num1-num2) < 0) ? "left" : "right";
			if(num1 == num2) whoes_big = "same";
			drawbar(y, 1*num1, "left", whoes_big);   drawbar(y, 1*num2, "right", whoes_big);
		}
		private function drawbar(y:Number, level:Number, dir:String, big:String):void
		{
			var bar:Sprite = new Sprite;
			if(dir != big || big == "same")
				bar.graphics.beginFill(0x234f62);
			else
				bar.graphics.beginFill(0x959c9f);
			bar.graphics.drawRect(0, 0, BAR_HEIGHT, 15);
			bar.graphics.endFill();
			
			if(level > 10) level = 10;
			bar.width = BAR_HEIGHT*level;
			bar.y = y;
			bar.x = Elever.Main.PageWidth/2 + ((dir == "left") ? -bar.width - 30 : 30);
			_data_bg.addChild(bar);
		}
		private function removeNonNumericChars($str:String):Number 
		{
			var newStr:String = "";
			for (var i:int = 0; i<$str.length; i++) {
				var currentCharCode:Number = $str.charCodeAt(i);
				if ((currentCharCode >= 48) && (currentCharCode <= 57)) {
					newStr += $str.charAt(i);
				}
			}
			return Number(newStr);
		}
		private function setbg():void
		{
			_data_bg = new Sprite;
			_data_bg.graphics.beginFill(0x000000, 0);
			_data_bg.graphics.drawCircle(0, 0, 100);
			_data_bg.graphics.endFill();
			_displays.addObject(_data_bg);
			
			var txt:TextField = Text.newText("가격", ITEM_FONT_SIZE, 0x000000, 0, 0, "center", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_data_bg.addChild(txt);
			
			txt = Text.newText("차종", ITEM_FONT_SIZE, 0x000000, 0, txt.y + txt.height + 30, "center", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_data_bg.addChild(txt);
			
			txt = Text.newText("인원", ITEM_FONT_SIZE, 0x000000, 0, txt.y + txt.height + 30, "center", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_data_bg.addChild(txt);
			
			txt = Text.newText("구동", ITEM_FONT_SIZE, 0x000000, 0, txt.y + txt.height + 30, "center", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_data_bg.addChild(txt);
			
			txt = Text.newText("연비", ITEM_FONT_SIZE, 0x000000, 0, txt.y + txt.height + 30, "center", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_data_bg.addChild(txt);
			
			txt = Text.newText("연료", ITEM_FONT_SIZE, 0x000000, 0, txt.y + txt.height + 30, "center", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_data_bg.addChild(txt);
			
			txt = Text.newText("최속", ITEM_FONT_SIZE, 0x000000, 0, txt.y + txt.height + 30, "center", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_data_bg.addChild(txt);
			
			txt = Text.newText("출력", ITEM_FONT_SIZE, 0x000000, 0, txt.y + txt.height + 30, "center", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_data_bg.addChild(txt);
			
			txt = Text.newText("토크", ITEM_FONT_SIZE, 0x000000, 0, txt.y + txt.height + 30, "center", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_data_bg.addChild(txt);
			
			txt = Text.newText("승차", ITEM_FONT_SIZE, 0x000000, 0, txt.y + txt.height + 30, "center", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_data_bg.addChild(txt);
			
			txt = Text.newText("주행", ITEM_FONT_SIZE, 0x000000, 0, txt.y + txt.height + 30, "center", "NanumBarunGothic", Elever.Main.PageWidth, 0);
			_data_bg.addChild(txt);
		}
		private function setCarSprite(bg:Sprite, url:String, name:String):void
		{
			bg.y = 50;
			
			if(url != "")
			{
				var img:WebImage = new WebImage(url, BitmapControl.CAR_MASK);
				img.name = name;
				img.x = Elever.Main.PageWidth/2/2 - img.width/2;
				img.addEventListener(MouseEvent.CLICK, onCarSelect);
				bg.addChild(img);
				
				
				car_name = Elever._car_save_data[Number(name)-1].name;
				company_name = Elever._car_save_data[Number(name)-1].company;
			}
			else
			{
				var spr:Sprite = new Sprite;
				spr.addChild(BitmapControl.newBitmap(BitmapControl.SELECT_CAR));
				spr.name = name;
				spr.x = Elever.Main.PageWidth/2/2 - spr.width/2;
				spr.addEventListener(MouseEvent.CLICK, onCarSelect);
				bg.addChild(spr);
				
				var car_name:String = "차량명";
				var company_name:String = "회사";
			}
			
			var height:Number = (url != "") ? img.height : spr.height;
			
			var txt:TextField = Text.newText(car_name, SMALL_FONT_SIZE, 0x000000, 0, height + 10, "center", "NanumBarunGothic", Elever.Main.PageWidth/2, 0, { bold:true });
			txt.name = "name";
			bg.addChild(txt);
			txt = Text.newText(company_name, SMALL_FONT_SIZE, 0x494949, 0, txt.y + txt.height + 10, "center", "NanumBarunGothic", Elever.Main.PageWidth/2, 0);
			txt.name = "company";
			bg.addChild(txt);
		}
		private function onCarSelect(e:MouseEvent):void
		{
			Elever.Main.changePage("ListPage", PageEffect.LEFT, { number:e.currentTarget.name });
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
