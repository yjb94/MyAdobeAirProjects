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
	
	public class Home extends BasePage
	{		
		private const BANK_NAME:Array = ["국민은행", "우리은행", "기업은행", "우체국", "하나은행", "씨티은행", "SC은행", "농협", "신한은행"];
		private const INTEREST_NAME:Array = ["골프", "공부", "건강운동", "결혼", "게임", "교통비", "금연", "기부", "독서", "대출", "레저", "문화", "보험", "봉사", "상조",
			"세금", "여행", "연예", "자동차","장례","주유비","적립","창업","출산육아","친구","통일","펀드","항공","환전"];
		private const PERIOD_NAME:Array = ["3", "6", "12", "24", "36", "48", "60"];
		private const ANCHOR_TWEEN_DURATION:Number = 0.3;
		private const BASE_Y_INTERVAL:Number = 30;
		
		private const TEXT_Y_MARGIN:Number = 40;
		private const TEXTBOX_HEIGHT:Number = 58;
		
		private const LINE_X_MARGIN:Number = 52*Config.ratio;
		private const LINE_Y_MARGIN:Number = 68*Config.ratio;
		
		private const TITLE_FONT_SIZE:Number = 50*Config.ratio;
		private const TEXT_FONT_SIZE:Number = 40*Config.ratio;
		private const INPUT_TEXT_FONT_SIZE:Number = 42*Config.ratio;
		
		private const CAR_FONT_SIZE:Number = 50*Config.ratio;
		private const COMPANY_FONT_SIZE:Number = 40*Config.ratio;
		
		private const BASE_TEXT:String = "숫자만 입력해주세요.";
		private const BASE_TEXT2:String = "숫자만 입력해주세요.(단위 : 만원)";
		
		private const TEXT_MARGIN:Number = 22*Config.ratio;
		private const TEXTFILED_Y_MARGIN:Number = 57*Config.ratio;
		private const ITEM_Y_MARGIN:Number = 57*Config.ratio;
		
		private const BENEFI_MARGIN:Number = 40;
		
		private var _displays:Scroll;
		
		private var _btn_next:Button;
		
		private var _spr_car:Sprite;
		
		private var _btn_sex:Button;
		private var _btn_saving_type:Button;
		
		private var _btn_benefit_list:Vector.<Button>;
		private var _tabbed_index:Vector.<int> = new Vector.<int>;
		
		public function Home(params:Object=null)
		{
			super();
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).clearPrev();
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = Text.newText("정보입력", TITLE_FONT_SIZE, 0xffffff);
			
			_displays = new Scroll();
			addChild(_displays);
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).addMiddleTouchCallBack(_displays.toTop);
			
			//나이
			var txt:TextField = Text.newText("나이", TEXT_FONT_SIZE, 0x2c2c2c,  35, TEXT_Y_MARGIN+20, "left", "NanumBarunGothic", 0, 0);
			_displays.addObject(txt);
			
			var obj:Object = Text.newInputTextbox(BitmapControl.TEXTBOX, INPUT_TEXT_FONT_SIZE, BASE_TEXT, 0x252525, 192, txt.y + txt.height/2 - TEXTBOX_HEIGHT/2, "left", "NanumBarunGothic");
			(obj.txt as TextField).name = "age";
			(obj.txt as TextField).addEventListener(Event.CHANGE, function(e:Event):void
			{
				if(isNaN(e.currentTarget.text.substr(e.currentTarget.text.length-1)))
				{
					e.currentTarget.text = e.currentTarget.text.substr(0, e.currentTarget.length-1);
				}
			});
			(obj.txt as TextField).addEventListener(MouseEvent.CLICK, onClickInputText);
			(obj.txt as TextField).addEventListener(FocusEvent.FOCUS_OUT, onFocusInputText);
			_displays.addObject(obj.bmp); _displays.addObject(obj.txt);
			
			var bmp:Bitmap = BitmapControl.newBitmap(BitmapControl.BUY_SEPERATE_LINE, 0, obj.txt.y + obj.txt.height + TEXT_Y_MARGIN);
			_displays.addObject(bmp);
			
			//성별
			txt = Text.newText("성별", TEXT_FONT_SIZE, 0x2c2c2c, 35, bmp.y + bmp.height + TEXT_Y_MARGIN, "left", "NanumBarunGothic", 0, 0);
			_displays.addObject(txt);
			
			//성별 버튼
			_btn_sex = new Button(BitmapControl.SEX_MALE, BitmapControl.SEX_FEMALE, null, 0, 0, false, true);
			_btn_sex.x = Elever.Main.PageWidth - _btn_sex.width - 30;
			_btn_sex.y = txt.y + txt.height/2 - _btn_sex.height/2;
			_displays.addObject(_btn_sex);
			
			bmp = BitmapControl.newBitmap(BitmapControl.BUY_SEPERATE_LINE, 0, _btn_sex.y + _btn_sex.height + TEXT_Y_MARGIN);
			_displays.addObject(bmp);
			
			//주거래 은행
			txt = Text.newText("주거래 은행이 어느 곳 입니까?", TEXT_FONT_SIZE, 0x2c2c2c, 35, bmp.y + bmp.height + TEXT_Y_MARGIN, "left", "NanumBarunGothic", 0, 0);
			_displays.addObject(txt);
			//라디오 버튼
			var btn_bank:RadioButton = new RadioButton(false, 20);
			btn_bank.name = "bank";
			btn_bank.y = txt.y + txt.height + TEXT_Y_MARGIN;
			btn_bank.addButton(BitmapControl.KBBANK, BitmapControl.KBBANK_ON);
			btn_bank.addButton(BitmapControl.WOORIBANK, BitmapControl.WOORIBANK_ON);
			btn_bank.addButton(BitmapControl.KIUPBANK, BitmapControl.KIUPBANK_ON);
			btn_bank.addButton(BitmapControl.POSTBANK, BitmapControl.POSTBANK_ON);
			btn_bank.addButton(BitmapControl.HANABANK, BitmapControl.HANABANK_ON);
			btn_bank.addButton(BitmapControl.CITIBANK, BitmapControl.CITIBANK_ON);
			btn_bank.addButton(BitmapControl.SCBANK, BitmapControl.SCBANK_ON);
			btn_bank.addButton(BitmapControl.NHBANK, BitmapControl.NHBANK_ON);
			btn_bank.addButton(BitmapControl.SINHANBANK, BitmapControl.SINHANBANK_ON);
			_displays.addObject(btn_bank);
			
			bmp = BitmapControl.newBitmap(BitmapControl.BUY_SEPERATE_LINE, 0, btn_bank.y + btn_bank.height + TEXT_Y_MARGIN);
			_displays.addObject(bmp);
			
			//적립 방법
			txt = Text.newText("적립 방법", TEXT_FONT_SIZE, 0x2c2c2c, 35, bmp.y + bmp.height + TEXT_Y_MARGIN, "left", "NanumBarunGothic", 0, 0);
			_displays.addObject(txt);
			
			//적립 방법 버튼
			_btn_saving_type = new Button(BitmapControl.FIXED_SAVING, BitmapControl.FREE_SAVING, null, 0, 0, false, true);
			_btn_saving_type.x = Elever.Main.PageWidth - _btn_saving_type.width - 30;
			_btn_saving_type.y = txt.y + txt.height/2 - _btn_saving_type.height/2;
			_displays.addObject(_btn_saving_type);
			
			bmp = BitmapControl.newBitmap(BitmapControl.BUY_SEPERATE_LINE, 0, _btn_saving_type.y + _btn_saving_type.height + TEXT_Y_MARGIN);
			_displays.addObject(bmp);
			
			
			//관심 분야 리스트
			txt = Text.newText("관심 분야(2개 선택)", TEXT_FONT_SIZE, 0x2c2c2c, 35, bmp.y + bmp.height + TEXT_Y_MARGIN, "left", "NanumBarunGothic", 0, 0);
			txt.name = "interest";
			_displays.addObject(txt);
			_btn_benefit_list = new Vector.<Button>;
			
			//골프
			var btn:Button = new Button(BitmapControl.GOLF_UP, BitmapControl.GOLF_DOWN, onBenefitTabbed, 0, 0, false, true);
			_btn_benefit_list.push(btn);
			_displays.addObject(btn);
			
			//공부
			btn = new Button(BitmapControl.STUDY_UP, BitmapControl.STUDY_DOWN, onBenefitTabbed, 0, 0, false, true);
			_btn_benefit_list.push(btn);
			_displays.addObject(btn);
			
			//건강운동
			btn = new Button(BitmapControl.SPORTS_UP, BitmapControl.SPORTS_DOWN, onBenefitTabbed, 0, 0, false, true);
			_btn_benefit_list.push(btn);
			_displays.addObject(btn);
			
			//결혼
			btn = new Button(BitmapControl.WEDDING_UP, BitmapControl.WEDDING_DOWN, onBenefitTabbed, 0, 0, false, true);
			_btn_benefit_list.push(btn);
			_displays.addObject(btn);
			
			//게임
			btn = new Button(BitmapControl.GAME_UP, BitmapControl.GAME_DOWN, onBenefitTabbed, 0, 0, false, true);
			_btn_benefit_list.push(btn);
			_displays.addObject(btn);
			
			//교통비
			btn = new Button(BitmapControl.TRAFFIC_UP, BitmapControl.TRAFFIC_DOWN, onBenefitTabbed, 0, 0, false, true);
			_btn_benefit_list.push(btn);
			_displays.addObject(btn);
			
			//금연
			btn = new Button(BitmapControl.NO_SMOKE_UP, BitmapControl.NO_SMOKE_DOWN, onBenefitTabbed, 0, 0, false, true);
			_btn_benefit_list.push(btn);
			_displays.addObject(btn);
			
			//기부
			btn = new Button(BitmapControl.CHARITY_UP, BitmapControl.CHARITY_DOWN, onBenefitTabbed, 0, 0, false, true);
			_btn_benefit_list.push(btn);
			_displays.addObject(btn);
			
			//독서
			btn = new Button(BitmapControl.READ_UP, BitmapControl.READ_DOWN, onBenefitTabbed, 0, 0, false, true);
			_btn_benefit_list.push(btn);
			_displays.addObject(btn);
			
			//대출
			btn = new Button(BitmapControl.BORROW_UP, BitmapControl.BORROW_DOWN, onBenefitTabbed, 0, 0, false, true);
			_btn_benefit_list.push(btn);
			_displays.addObject(btn);
			
			//레저ㅓ
			btn = new Button(BitmapControl.LEISURE_UP, BitmapControl.LEISURE_DOWN, onBenefitTabbed, 0, 0, false, true);
			_btn_benefit_list.push(btn);
			_displays.addObject(btn);
			
			//문화
			btn = new Button(BitmapControl.CULTURE_UP, BitmapControl.CULTURE_DOWN, onBenefitTabbed, 0, 0, false, true);
			_btn_benefit_list.push(btn);
			_displays.addObject(btn);
			
			//보험
			btn = new Button(BitmapControl.INSURANCE_UP, BitmapControl.INSURANCE_DOWN, onBenefitTabbed, 0, 0, false, true);
			_btn_benefit_list.push(btn);
			_displays.addObject(btn);
			
			//봉사
			btn = new Button(BitmapControl.VOLUNTEER_UP, BitmapControl.VOLUNTEER_DOWN, onBenefitTabbed, 0, 0, false, true);
			_btn_benefit_list.push(btn);
			_displays.addObject(btn);
			
			
			//상조
			btn = new Button(BitmapControl.FUNERAL_SERVICE_UP, BitmapControl.FUNERAL_SERVICE_DOWN, onBenefitTabbed, 0, 0, false, true);
			_btn_benefit_list.push(btn);
			_displays.addObject(btn);
			
			//세금
			btn = new Button(BitmapControl.TAX_UP, BitmapControl.TAX_DOWN, onBenefitTabbed, 0, 0, false, true);
			_btn_benefit_list.push(btn);
			_displays.addObject(btn);
			
			//여행
			btn = new Button(BitmapControl.TRAVEL_UP, BitmapControl.TRAVEL_DOWN, onBenefitTabbed, 0, 0, false, true);
			_btn_benefit_list.push(btn);
			_displays.addObject(btn);
			
			//연예
			btn = new Button(BitmapControl.ENTER_UP, BitmapControl.ENTER_DOWN, onBenefitTabbed, 0, 0, false, true);
			_btn_benefit_list.push(btn);
			_displays.addObject(btn);
			
			//자동차
			btn = new Button(BitmapControl.CAR_UP, BitmapControl.CAR_DOWN, onBenefitTabbed, 0, 0, false, true);
			_btn_benefit_list.push(btn);
			_displays.addObject(btn);
			
			//장례
			btn = new Button(BitmapControl.FUNERAL_UP, BitmapControl.FUNERAL_DOWN, onBenefitTabbed, 0, 0, false, true);
			_btn_benefit_list.push(btn);
			_displays.addObject(btn);
			
			//주유비
			btn = new Button(BitmapControl.FULE_UP, BitmapControl.FUEL_DOWN, onBenefitTabbed, 0, 0, false, true);
			_btn_benefit_list.push(btn);
			_displays.addObject(btn);
			
			//적립
			btn = new Button(BitmapControl.SAVING_UP, BitmapControl.SAVING_DOWN, onBenefitTabbed, 0, 0, false, true);
			_btn_benefit_list.push(btn);
			_displays.addObject(btn);
			
			//창ㅇ업
			btn = new Button(BitmapControl.STARTUP_UP, BitmapControl.STARTUP_DOWN, onBenefitTabbed, 0, 0, false, true);
			_btn_benefit_list.push(btn);
			_displays.addObject(btn);
			
			//출산육아
			btn = new Button(BitmapControl.BABY_UP, BitmapControl.BABY_DOWN, onBenefitTabbed, 0, 0, false, true);
			_btn_benefit_list.push(btn);
			_displays.addObject(btn);
			
			//친구
			btn = new Button(BitmapControl.FREIND_UP, BitmapControl.FREIND_DOWN, onBenefitTabbed, 0, 0, false, true);
			_btn_benefit_list.push(btn);
			_displays.addObject(btn);
			
			//통이
			btn = new Button(BitmapControl.UNITY_UP, BitmapControl.UNITY_DOWN, onBenefitTabbed, 0, 0, false, true);
			_btn_benefit_list.push(btn);
			_displays.addObject(btn);
			
			//펀드
			btn = new Button(BitmapControl.FUND_UP, BitmapControl.FUND_DOWN, onBenefitTabbed, 0, 0, false, true);
			_btn_benefit_list.push(btn);
			_displays.addObject(btn);
			
			//항공
			btn = new Button(BitmapControl.FLIGHT_UP, BitmapControl.FLIGHT_DOWN, onBenefitTabbed, 0, 0, false, true);
			_btn_benefit_list.push(btn);
			_displays.addObject(btn);
			
			//환전
			btn = new Button(BitmapControl.EXCHANGE_UP, BitmapControl.EXCHANGE_DOWN, onBenefitTabbed, 0, 0, false, true);
			_btn_benefit_list.push(btn);
			_displays.addObject(btn);
			
			
			//나중에 한 번에 위치 조정
			setBenefitPos();
			
			
			//희망 월 입금액
			var height:Number = _displays.scroller.getChildByName("benefit_line").y + _displays.scroller.getChildByName("benefit_line").height;
				
			txt = Text.newText("희망 월 입금액", TEXT_FONT_SIZE, 0x2c2c2c,  35, height + TEXT_Y_MARGIN, "left", "NanumBarunGothic", 0, 0);
			_displays.addObject(txt);
			
			obj = Text.newInputTextbox(BitmapControl.TEXTBOX, INPUT_TEXT_FONT_SIZE, BASE_TEXT2, 0x252525, 192, txt.y + txt.height/2 - TEXTBOX_HEIGHT/2, "left", "NanumBarunGothic");
			(obj.txt as TextField).name = "money";
			(obj.txt as TextField).addEventListener(Event.CHANGE, function(e:Event):void
			{
				if(isNaN(e.currentTarget.text.substr(e.currentTarget.text.length-1)))
				{
					e.currentTarget.text = e.currentTarget.text.substr(0, e.currentTarget.length-1);
				}
			});(obj.txt as TextField).addEventListener(MouseEvent.CLICK, onClickInputText);
			(obj.txt as TextField).addEventListener(FocusEvent.FOCUS_OUT, onFocusInputText);
			_displays.addObject(obj.bmp); _displays.addObject(obj.txt);
			
			bmp = BitmapControl.newBitmap(BitmapControl.BUY_SEPERATE_LINE, 0, obj.txt.y + obj.txt.height + TEXT_Y_MARGIN);
			_displays.addObject(bmp);
			
			
			//희망 적립 기간
			txt = Text.newText("희망 적립 기간", TEXT_FONT_SIZE, 0x2c2c2c, 35, bmp.y + bmp.height + TEXT_Y_MARGIN, "left", "NanumBarunGothic", 0, 0);
			_displays.addObject(txt);
			//라디오 버튼
			var length_btn:RadioButton = new RadioButton(false, 40, null, 0, 0, 4);
			length_btn.name = "period";
			length_btn.y = txt.y + txt.height + TEXT_Y_MARGIN;
			length_btn.addButton(BitmapControl.THREE_MONTH, BitmapControl.THREE_MONTH_ON);
			length_btn.addButton(BitmapControl.SIX_MONTH, BitmapControl.SIX_MONTH_ON);
			length_btn.addButton(BitmapControl.ONE_YEAR, BitmapControl.ONE_YEAR_ON);
			length_btn.addButton(BitmapControl.TWO_YEAR, BitmapControl.TWO_YEAR_ON);
			length_btn.addButton(BitmapControl.THREE_YEAR, BitmapControl.THREE_YEAR_ON);
			length_btn.addButton(BitmapControl.FOUR_YEAR, BitmapControl.FOUR_YEAR_ON);
			length_btn.addButton(BitmapControl.FIVE_YEAR, BitmapControl.FIVE_YEAR_ON);
			_displays.addObject(length_btn);
			
			btn = new Button(BitmapControl.BUTTON_NEXT, BitmapControl.BUTTON_NEXT, onButtonNext, 0, length_btn.y + length_btn.height + TEXT_Y_MARGIN);
			btn.x = Elever.Main.PageWidth/2 - btn.width/2;
			_displays.addObject(btn);
			
			bmp = BitmapControl.newBitmap(BitmapControl.BUY_SEPERATE_LINE, 0, btn.y + btn.height + TEXT_Y_MARGIN + BENEFI_MARGIN);
			_displays.addObject(bmp);
		}
		private function onButtonNext(e:MouseEvent):void
		{
			var popup:Popup = new Popup(Popup.YESNO_TYPE, { main_text:"이대로 제출하시겠습니까? ", callback:function(type:String):void
			{
				if(type == "yes")
				{
					var obj:Object = new Object;
					var str:String = (_displays.scroller.getChildByName("age") as TextField).text
					obj.age = (str == BASE_TEXT) ? "0" : str;
					obj.sex = (_btn_sex.isTabbed) ? "0" : "1";	// 0 - 여자, 1 - 남자
					obj.bank = BANK_NAME[(_displays.scroller.getChildByName("bank") as RadioButton).Tab];
					obj.mathod = (_btn_saving_type.isTabbed) ? "자유적립" : "정액적립";
					str = (_displays.scroller.getChildByName("money") as TextField).text;
					obj.money = (str == BASE_TEXT) ? "0" : str;
					obj.period = PERIOD_NAME[(_displays.scroller.getChildByName("period") as RadioButton).Tab];
					if(_tabbed_index.length == 0)
					{
						Elever.Main.changePage("ResultPage", PageEffect.LEFT, obj);
						return;
					}
					if(_tabbed_index.length)
						obj.benefit1 = INTEREST_NAME[_tabbed_index.shift()];
					if(_tabbed_index.length)
						obj.benefit2 = INTEREST_NAME[_tabbed_index.shift()];
					Elever.Main.changePage("AHPPage", PageEffect.LEFT, obj);
				}
			}});
		}
		private function setBenefitPos():void
		{
			for(var i:int = 0; i < _btn_benefit_list.length; i++)
			{
				_btn_benefit_list[i].x = (_btn_benefit_list[i].width + BENEFI_MARGIN)*(i%5) + BENEFI_MARGIN;
				_btn_benefit_list[i].y = (_btn_benefit_list[i].height + BENEFI_MARGIN)*int(i/5) 
					+ (_displays.scroller.getChildByName("interest") as TextField).y + TEXT_Y_MARGIN + TEXT_FONT_SIZE;
			}
			
			var bmp:Bitmap = BitmapControl.newBitmap(BitmapControl.BUY_SEPERATE_LINE, 0, _btn_benefit_list[i-1].y + _btn_benefit_list[i-1].height + TEXT_Y_MARGIN);
			bmp.name = "benefit_line";
			_displays.addObject(bmp);
		}
		private function onBenefitTabbed(e:MouseEvent):void
		{
			var tabbed_index:int = -1;
			for(var i:int = 0; i < _btn_benefit_list.length; i++)
			{
				if(_btn_benefit_list[i].isTabbed)
				{
					if(_tabbed_index.indexOf(i) == -1)
						_tabbed_index.push(i);
				}
				else
					if(_tabbed_index.indexOf(i) != -1)
						_tabbed_index.splice(_tabbed_index.indexOf(i), 1);
			}
			
			if(_tabbed_index.length >= 3)
			{
				new Popup(Popup.OK_TYPE, { main_text:"2개만 선택해 주세요." });
				
				_btn_benefit_list[_tabbed_index.pop()].isTabbed = false;
			}
		}
		private function onCarSelect(e:MouseEvent):void
		{
			Elever.Main.changePage("ListPage", PageEffect.LEFT, { number:(e.currentTarget as WebImage).name });
		}
		private function onClickInputText(e:MouseEvent):void
		{
			if(e.type == MouseEvent.CLICK)
			{
				anchor(-(e.currentTarget as TextField).y - _displays.scroller.getY() + BASE_Y_INTERVAL);
			}
		}
		private function onFocusInputText(e:FocusEvent):void
		{
			if(e.type == FocusEvent.FOCUS_OUT)
			{
				if(stage.focus == null)
					anchor(0);
			}
		}
		private function anchor(y:Number):void
		{
			TweenLite.to(_displays, ANCHOR_TWEEN_DURATION, { y:y });
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