package Page.Home
{
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.Text;
	
	import Header.NavigationBar;
	
	import Page.BasePage;
	
	import Scroll.Scroll;
	
	public class result extends BasePage
	{	
		private const BANK_NAME:Array = ["국민은행", "우리은행", "기업은행", "우체국은행", "하나은행", "씨티은행", "SC은행", "농협은행", "신한은행"];
		private const BANK_URL:Array = ["https://www.kbstar.com/", "https://www.wooribank.com/", "www.kiupbank.co.kr/", "www.epostbank.go.kr/",
			"http://www.hanabank.co.kr", "www.citibank.co.kr/", "www.standardchartered.co.kr/", "https://www.nonghyup.com/", "www.shinhan.com/"];
		private const TITLE_FONT_SIZE:Number = 50*Config.ratio;
		private const BIG_TEXT_FONT_SIZE:Number = 45*Config.ratio;
		private const TEXT_FONT_SIZE:Number = 40*Config.ratio;
		private const INPUT_TEXT_FONT_SIZE:Number = 42*Config.ratio;
		
		private const TEXT_Y_MARGIN:Number = 40;
		
		private const BANK_ADD_POINT:Number = 0.2;
		
		private var _savings_list:Array;
		private var _user_data:Object;
		
		private var _result_datas:Array = new Array;
		
		private var _displays:Scroll;
		
		private var _obj:Object;
		
		public function result(params:Object=null)
		{
			super();
			_user_data = params;
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = Text.newText("당신의 FUN한 결과", TITLE_FONT_SIZE, 0xffffff);
			
			_displays = new Scroll();
			addChild(_displays);
			
			calculate();
		}
		
		private function calculate():void
		{
			var data:Object = Elever.loadEnviromentSavings("SavingsList");
			if(data == null)
			{
				var params:URLVariables = new URLVariables;
				Elever.Main.LoadingVisible = true;
				Elever.Connection.post("getSavingsList.jsp", params, function(data:String):void
				{
					Elever.Main.LoadingVisible = false;
					if(data)
					{
						var result:Object = JSON.parse(data);
						
						if(result)
						{
							//set result to array
							_savings_list = new Array;
							for(var i:int = 0; i < result.length; i++)
							{
								result[i].weight = 0;	//최초 가중치 0으로 초기화
								_savings_list.push(result[i]);	
							}
							
							//save datas split
							
							var index:int = 0;
							while(result.length)
							{
								var object_40:Object = new Object;
								for(i = 0; i < 40; i++)
								{
									object_40[i+(index*40)] = result.shift();
									if(result.length == 0)
										break;
								}
								
								Elever.saveEnviroment("SavingsList"+index, object_40);
								index++;
							}
							
							//remove index which does not match in money
							removeWithMoney();
							
							//remove index which does not match in mathod
							removeWithMathod();
							
							//remove index which does not match in period
							removeWithAge();
							
							//remove index which does not match in period
							removeWithPeriod();
							
							//compare bank
							compareBank();
							
							//compare benefits and rates
							if(_user_data.weight1)
								compareBenefit();//.0/i  - i는 index
							else
								compareRate();
							
							_result_datas.sort(Array.DESCENDING);
							
							Render();
						}
					}
				});
			}
			else
			{
				_savings_list = new Array;
				for(var i:int = 0; i < 369; i++)
					_savings_list.push(data[i]);
				
				//remove index which does not match in money
				removeWithMoney();
				
				//remove index which does not match in mathod
				removeWithMathod();
				
				//remove index which does not match in period
				removeWithAge();
				
				//remove index which does not match in period
				removeWithPeriod();
				
				//compare bank
				compareBank();
				
				//compare benefits and rates
				if(_user_data.weight1)
					compareBenefit();//.0/i  - i는 index
				else
					compareRate();
				
				_result_datas.sort(Array.DESCENDING);
				
				Render();
			}
		}
		private function Render():void
		{
			if(_savings_list.length == 0)
			{
				addChild(Text.newText("조건에 맞는 적금이 없습니다ㅠ", 40, 0x000000, 0, 400, "center", "NanumBarunGothic", Elever.Main.PageWidth));
				return;
			}
			
			var num:int = (_user_data.weight1) ? 5 : 7;
			if(_user_data.weight1)
			{
				var list_index:int = Number((_result_datas[0] as String).substr((_result_datas[0] as String).indexOf("/")+1));
				var result_data:Number = Number((_result_datas[0] as String).substr(0, (_result_datas[0] as String).length-5));
				//반올림
				result_data *= 10000;
				result_data = Math.round(result_data);
				result_data /= 10000;
			}
			else
				list_index = 0;
			
			_obj = _savings_list[list_index];
			
			
			//상품명
			var txt:TextField = Text.newText(_obj.name, BIG_TEXT_FONT_SIZE, 0x000000,  35, TEXT_Y_MARGIN+20, "left", "NanumBarunGothic", 0, 0);
			_displays.addObject(txt);
			
			//은행명
			txt = Text.newText(_obj.bank, TEXT_FONT_SIZE, 0x2c2c2c,  txt.x + txt.width + 20, txt.y + 5*Config.ratio , "left", "NanumBarunGothic", 574);
			_displays.addObject(txt);
			
			var bmp:Bitmap = BitmapControl.newBitmap(BitmapControl.BUY_SEPERATE_LINE, 0, txt.y + txt.height + TEXT_Y_MARGIN);
			_displays.addObject(bmp);
			
			//금리
			txt = Text.newText("금리", TEXT_FONT_SIZE, 0x000000,  35, bmp.y + bmp.height + TEXT_Y_MARGIN, "left", "NanumBarunGothic", 0, 0);
			_displays.addObject(txt);
			
			txt = Text.newText(_obj.rate, TEXT_FONT_SIZE, 0x2c2c2c,  35, txt.y, "right", "NanumBarunGothic", 574);
			_displays.addObject(txt);
			
			//결과값
			if(_user_data.weight1)
			{
				txt = Text.newText("결과값(가중치고려)", TEXT_FONT_SIZE, 0x000000,  35, txt.y + txt.height + TEXT_Y_MARGIN, "left", "NanumBarunGothic", 0, 0);
				_displays.addObject(txt);
			
				txt = Text.newText(result_data.toString(), TEXT_FONT_SIZE, 0x2c2c2c,  35, txt.y, "right", "NanumBarunGothic", 574);
				_displays.addObject(txt);
			}
			
			//대상연령
			if(_obj.age != "null")
			{
				txt = Text.newText("대상 연령", TEXT_FONT_SIZE, 0x000000,  35, txt.y + txt.height + TEXT_Y_MARGIN, "left", "NanumBarunGothic", 0, 0);
				_displays.addObject(txt);
				
				txt = Text.newText(_obj.age + "~", TEXT_FONT_SIZE, 0x2c2c2c,  35, txt.y, "right", "NanumBarunGothic", 574);
				_displays.addObject(txt);
			}
			
			//혜택
			if(_obj.benefit1 != "null")
			{
				txt = Text.newText("혜택1", TEXT_FONT_SIZE, 0x000000,  35, txt.y + txt.height + TEXT_Y_MARGIN, "left", "NanumBarunGothic", 0, 0);
				_displays.addObject(txt);
				
				txt = Text.newText(_obj.benefit1, TEXT_FONT_SIZE, 0x2c2c2c,  35, txt.y, "right", "NanumBarunGothic", 574);
				_displays.addObject(txt);
				
				if(_obj.benefit2 != "null")
				{
					txt = Text.newText("혜택2", TEXT_FONT_SIZE, 0x000000,  35, txt.y + txt.height + TEXT_Y_MARGIN, "left", "NanumBarunGothic", 0, 0);
					_displays.addObject(txt);
					
					txt = Text.newText(_obj.benefit2, TEXT_FONT_SIZE, 0x2c2c2c,  35, txt.y, "right", "NanumBarunGothic", 574);
					_displays.addObject(txt);
					
					if(_obj.benefit3 != "null")
					{
						txt = Text.newText("혜택3", TEXT_FONT_SIZE, 0x000000,  35, txt.y + txt.height + TEXT_Y_MARGIN, "left", "NanumBarunGothic", 0, 0);
						_displays.addObject(txt);
						
						txt = Text.newText(_obj.benefit3, TEXT_FONT_SIZE, 0x2c2c2c,  35, txt.y, "right", "NanumBarunGothic", 574);
						_displays.addObject(txt);
					}
				}
			}
			
			if(_obj.bank != "null")
			{	
				var btn:Button = new Button(BitmapControl.BUTTON_LINK, BitmapControl.BUTTON_LINK, onButtonLink, 0, txt.y + txt.height + TEXT_Y_MARGIN);
				btn.x = Elever.Main.PageWidth/2 - btn.width/2;
				_displays.addObject(btn);
			}
		}
		private function onButtonLink(e:MouseEvent):void
		{
			navigateToURL(new URLRequest(BANK_URL[BANK_NAME.indexOf(_obj.bank)]));
		}
		private function compareRate():void
		{
			for(var i:int = 0; i < _savings_list.length; i++)
			{
				var rate:Number = Number((_savings_list[i].rate as String).substr(0, (_savings_list[i].rate as String).length-1));
				_result_datas.push(rate);
			}
		}
		private function compareBenefit():void
		{
			var weight1:Number = _user_data.weight1;
			var weight2:Number = _user_data.weight2;
			var weight3:Number = _user_data.weight3;
			for(var i:int = 0; i < _savings_list.length; i++)
			{
				var rate:Number = _savings_list[i].rate;
				_savings_list[i].weight += rate*weight1;
				
				if(_user_data.benefit1 == _savings_list[i].benefit1 || _user_data.benefit1 == _savings_list[i].benefit2 ||  _user_data.benefit1 == _savings_list[i].benefit3)
					_savings_list[i].weight += 1.6*weight2;
				
				if(_user_data.benefit2 == _savings_list[i].benefit1 || _user_data.benefit2 == _savings_list[i].benefit2 || _user_data.benefit2 == _savings_list[i].benefit3)
					_savings_list[i].weight += 1.6*weight3;
				
				_result_datas.push(_savings_list[i].weight + ".0/" + i);
			}
		}
		private function compareBank():void
		{
			var user_bank:String = _user_data.bank;
			for(var i:int = 0; i < _savings_list.length; i++)
			{
				if(_savings_list[i].bank == user_bank)
					_savings_list[i].weight += BANK_ADD_POINT;
			}
		}
		private function removeWithMoney():void
		{
			var remove_arr_index:Array = new Array;
			var user_money:Number = _user_data.money;
//			if(user_money == 0)	return;
			for(var i:int = 0; i < _savings_list.length; i++)
			{
				if(_savings_list[i].limit_start == 0)
					continue;
				
				if(user_money < _savings_list[i].limit_start)
				{
					remove_arr_index.push(i);
					continue;
				}
				if(_savings_list[i].limit_end == 0)
					continue;
				
				if(user_money > _savings_list[i].limit_end)
					remove_arr_index.push(i);
			}
			
			while(remove_arr_index.length)
				_savings_list.splice(remove_arr_index.pop(), 1);
		}
		private function removeWithMathod():void
		{
			var remove_arr_index:Array = new Array;
			
			for(var i:int = 0; i < _savings_list.length; i++)
			{
				if(_savings_list[i].mathod != _user_data.mathod)
					remove_arr_index.push(i);
			}
			
			while(remove_arr_index.length)
				_savings_list.splice(remove_arr_index.pop(), 1);
		}
		private function removeWithPeriod():void
		{
			var remove_arr_index:Array = new Array;
			
			for(var i:int = 0; i < _savings_list.length; i++)
			{
				if(_savings_list[i].period != _user_data.period)
					remove_arr_index.push(i);
			}
			
			while(remove_arr_index.length)
				_savings_list.splice(remove_arr_index.pop(), 1);
		}
		private function removeWithAge():void
		{
			var remove_arr_index:Array = new Array;
			
			for(var i:int = 0; i < _savings_list.length; i++)
			{
				if(_savings_list[i].age == "null")
					continue;
				
				if(Number(_savings_list[i].age) > Number(_user_data.age))
					remove_arr_index.push(i);
			}
			
			while(remove_arr_index.length)
				_savings_list.splice(remove_arr_index.pop(), 1);
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