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
	
	public class AHP extends BasePage
	{
		private const SURVEY_POINT:Array = [ 3, 2, 1, 1/2, 1/3];
		
		private const TITLE_FONT_SIZE:Number = 50*Config.ratio;
		private const TEXT_FONT_SIZE:Number = 40*Config.ratio;
		private const INPUT_TEXT_FONT_SIZE:Number = 42*Config.ratio;
		
		private const TEXT_Y_MARGIN:Number = 40;
		
		private var _factor1:String = "금리";
		private var _factor2:String = "factor2";
		private var _factor3:String = "factor3";
		
		private var _displays:Scroll;
		private var _datas:Object = new Object;
		
		public function AHP(params:Object=null)
		{
			super();
			_datas = params;
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = Text.newText("선호도파악", TITLE_FONT_SIZE, 0xffffff);
			
			_displays = new Scroll();
			addChild(_displays);
			
			//데이터 설정
			if(_datas.benefit1) _factor2 = _datas.benefit1;
			
			//질문 1
			var txt:TextField = Text.newText(_factor1+"가 "+_factor2+"보다 얼마나 중요하다고 생각하십니까?", TEXT_FONT_SIZE, 0x2c2c2c,  35, TEXT_Y_MARGIN+20, "left", "NanumBarunGothic", 0, 0);
			_displays.addObject(txt);
			
			//라디오 버튼
			var survey_btn:RadioButton = new RadioButton(false, 20, null, 0, 0, 5);
			survey_btn.name = "1";
			survey_btn.y = txt.y + txt.height + TEXT_Y_MARGIN;
			survey_btn.addButton(BitmapControl.THREE_UP, BitmapControl.THREE_DOWN);
			survey_btn.addButton(BitmapControl.TWO_UP, BitmapControl.TWO_DOWN);
			survey_btn.addButton(BitmapControl.ONE_UP, BitmapControl.ONE_DOWN);
			survey_btn.addButton(BitmapControl.HALF_UP, BitmapControl.HALF_DOWN);
			survey_btn.addButton(BitmapControl.THONE_UP, BitmapControl.THONE_DOWN);
			_displays.addObject(survey_btn);
			
			if(_datas.benefit2) _factor3 = _datas.benefit2;
			else 
			{
				btn = new Button(BitmapControl.BUTTON_NEXT, BitmapControl.BUTTON_NEXT, onButtonNext, 0, survey_btn.y + survey_btn.height + TEXT_Y_MARGIN);
				btn.x = Elever.Main.PageWidth/2 - btn.width/2;
				_displays.addObject(btn);
				
				bmp = BitmapControl.newBitmap(BitmapControl.BUY_SEPERATE_LINE, 0, btn.y + btn.height + TEXT_Y_MARGIN);
				_displays.addObject(bmp);
				
				return;
			}
			
			var bmp:Bitmap = BitmapControl.newBitmap(BitmapControl.BUY_SEPERATE_LINE, 0, survey_btn.y + survey_btn.height + TEXT_Y_MARGIN);
			_displays.addObject(bmp);
			
			
			
			//질문 2
			txt = Text.newText(_factor1+"가 "+_factor3+"보다 얼마나 중요하다고 생각하십니까?", TEXT_FONT_SIZE, 0x2c2c2c,  35, bmp.y + bmp.height + TEXT_Y_MARGIN, "left", "NanumBarunGothic", 0, 0);
			_displays.addObject(txt);
			
			//라디오 버튼
			survey_btn = new RadioButton(false, 20, null, 0, 0, 5);
			survey_btn.name = "2";
			survey_btn.y = txt.y + txt.height + TEXT_Y_MARGIN;
			survey_btn.addButton(BitmapControl.THREE_UP, BitmapControl.THREE_DOWN);
			survey_btn.addButton(BitmapControl.TWO_UP, BitmapControl.TWO_DOWN);
			survey_btn.addButton(BitmapControl.ONE_UP, BitmapControl.ONE_DOWN);
			survey_btn.addButton(BitmapControl.HALF_UP, BitmapControl.HALF_DOWN);
			survey_btn.addButton(BitmapControl.THONE_UP, BitmapControl.THONE_DOWN);
			_displays.addObject(survey_btn);
			
			bmp = BitmapControl.newBitmap(BitmapControl.BUY_SEPERATE_LINE, 0, survey_btn.y + survey_btn.height + TEXT_Y_MARGIN);
			_displays.addObject(bmp);
			
			
			//질문 3
			txt = Text.newText(_factor2+"이(가) "+_factor3+"보다 얼마나 중요하다고 생각하십니까?", TEXT_FONT_SIZE, 0x2c2c2c,  35, bmp.y + bmp.height + TEXT_Y_MARGIN, "left", "NanumBarunGothic", 0, 0);
			_displays.addObject(txt);
			
			//라디오 버튼
			survey_btn = new RadioButton(false, 20, null, 0, 0, 5);
			survey_btn.name = "3";
			survey_btn.y = txt.y + txt.height + TEXT_Y_MARGIN;
			survey_btn.addButton(BitmapControl.THREE_UP, BitmapControl.THREE_DOWN);
			survey_btn.addButton(BitmapControl.TWO_UP, BitmapControl.TWO_DOWN);
			survey_btn.addButton(BitmapControl.ONE_UP, BitmapControl.ONE_DOWN);
			survey_btn.addButton(BitmapControl.HALF_UP, BitmapControl.HALF_DOWN);
			survey_btn.addButton(BitmapControl.THONE_UP, BitmapControl.THONE_DOWN);
			_displays.addObject(survey_btn);
			
			var btn:Button = new Button(BitmapControl.BUTTON_NEXT, BitmapControl.BUTTON_NEXT, onButtonNext, 0, survey_btn.y + survey_btn.height + TEXT_Y_MARGIN);
			btn.x = Elever.Main.PageWidth/2 - btn.width/2;
			_displays.addObject(btn);
			
			bmp = BitmapControl.newBitmap(BitmapControl.BUY_SEPERATE_LINE, 0, btn.y + btn.height + TEXT_Y_MARGIN);
			_displays.addObject(bmp);
		}
		private function onButtonNext(e:MouseEvent):void
		{
			var popup:Popup = new Popup(Popup.YESNO_TYPE, { main_text:"이대로 제출하시겠습니까? ", callback:function(type:String):void
			{
				if(type == "yes")
				{
					_datas.weight1 = 0;
					_datas.weight2 = 0;
					_datas.weight3 = 0;
					
					var weight_matrix:Vector.<Number>;
					
					if(_factor3 != "factor3")
					{
						weight_matrix = threeByThreeMatrixCalculate();
						_datas.weight3 = weight_matrix[2];
					}
					else
						weight_matrix = twoByTwoMatrixCaculate();
					
					_datas.weight1 = weight_matrix[0];
					_datas.weight2 = weight_matrix[1];
					
					Elever.Main.changePage("ResultPage", PageEffect.LEFT, _datas);
				}
			}});
		}
		private function twoByTwoMatrixCaculate():Vector.<Number>
		{
			//행렬 곱 계산
			var num1:Number = SURVEY_POINT[(_displays.scroller.getChildByName("1") as RadioButton).Tab];
			var matrix:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>;
			var arr:Vector.<Number> = new Vector.<Number>;
			arr.push(1);		arr.push(num1);		matrix.push(arr);
			arr = new Vector.<Number>;
			arr.push(1/num1);	arr.push(1);		matrix.push(arr);
			matrix = twoByTwoMatrixMultiply(matrix, matrix);
			
			//행렬 덧셈
			var add_matrix:Vector.<Number> = new Vector.<Number>(2, true);
			add_matrix[0] = matrix[0][0] +  matrix[0][1];
			add_matrix[1] = matrix[1][0] +  matrix[1][1];
			var total:Number = add_matrix[0] + add_matrix[1];
			
			//가중치 도출
			var weight_matrix:Vector.<Number> = new Vector.<Number>(2,true);
			weight_matrix[0] = add_matrix[0]/total;
			weight_matrix[1] = add_matrix[1]/total;
			
			return weight_matrix;
		}
		private function twoByTwoMatrixMultiply(a:Vector.<Vector.<Number>>, b:Vector.<Vector.<Number>>):Vector.<Vector.<Number>>
		{
			var c:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>(2,true);
			var low_arr:Vector.<Number> = new Vector.<Number>(2,true);
			c[0] = low_arr;
			low_arr = new Vector.<Number>(3,true);
			c[1] = low_arr;
			
			for(var i:int = 0; i < 2; i++)
			{
				for(var j:int = 0; j < 2; j++)
				{
					c[i][j] = a[i][0]*b[0][j] + a[i][1]*b[1][j];
				}
			}
			
			return c;
		}
		private function threeByThreeMatrixCalculate():Vector.<Number>
		{
			//행렬 곱 계산	
			var num1:Number = SURVEY_POINT[(_displays.scroller.getChildByName("1") as RadioButton).Tab];
			var num2:Number = SURVEY_POINT[(_displays.scroller.getChildByName("2") as RadioButton).Tab];
			var num3:Number = SURVEY_POINT[(_displays.scroller.getChildByName("3") as RadioButton).Tab];
			var matrix:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>;
			var arr:Vector.<Number> = new Vector.<Number>;
			arr.push(1);		arr.push(num1);		arr.push(num2);		matrix.push(arr);
			arr = new Vector.<Number>;
			arr.push(1/num1);	arr.push(1);		arr.push(num3);		matrix.push(arr);
			arr = new Vector.<Number>;
			arr.push(1/num2);	arr.push(1/num3);	arr.push(1);		matrix.push(arr);
			matrix = threeByThreeMatrixMultiply(matrix, matrix);
			
			//행렬 덧셈
			var add_matrix:Vector.<Number> = new Vector.<Number>(3, true);
			add_matrix[0] = matrix[0][0] +  matrix[0][1] +  matrix[0][2];
			add_matrix[1] = matrix[1][0] +  matrix[1][1] +  matrix[1][2];
			add_matrix[2] = matrix[2][0] +  matrix[2][1] +  matrix[2][2];
			var total:Number = add_matrix[0] + add_matrix[1] + add_matrix[2];
			
			//가중치 도출
			var weight_matrix:Vector.<Number> = new Vector.<Number>(3,true);
			weight_matrix[0] = add_matrix[0]/total;
			weight_matrix[1] = add_matrix[1]/total;
			weight_matrix[2] = add_matrix[2]/total;
			
			return weight_matrix;
		}
		private function threeByThreeMatrixMultiply(a:Vector.<Vector.<Number>>, b:Vector.<Vector.<Number>>):Vector.<Vector.<Number>>
		{
			var c:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>(3,true);
			var low_arr:Vector.<Number> = new Vector.<Number>(3,true);
			c[0] = low_arr;
			low_arr = new Vector.<Number>(3,true);
			c[1] = low_arr;
			low_arr = new Vector.<Number>(3,true);
			c[2] = low_arr;
			
			for(var i:int = 0; i < 3; i++)
			{
				for(var j:int = 0; j < 3; j++)
				{
					c[i][j] = a[i][0]*b[0][j] + a[i][1]*b[1][j] + a[i][2]*b[2][j];
				}
			}
			
			return c;
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

