package Page.Home
{	
	import com.devactionscript.datetimepicker.DateTimePickerEvent;
	import com.devactionscript.datetimepicker.FreeAneDateTimePicker;
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLVariables;
	import flash.text.TextField;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.SlideImage;
	import Displays.Text;
	
	import Header.NavigationBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	
	import Scroll.Scroll;
	
	import Utils.Timer;
	
	import pl.mateuszmackowiak.nativeANE.dialogs.NativeAlertDialog;
	
	public class GrowPage extends BasePage
	{
		private const TWEEN_DURATION:Number = 0.2;
		private const ANIME_DELAY:Number = 500;
		
		private const TOTAL_TIMER:Number = 1000;
		
		private const TITLE_FONT_SIZE:Number = 32*Config.ratio;
		private const TEXT_FONT_SIZE:Number = 40*Config.ratio;
		
		private var _animate_timer:Timer;
		private var _total_timer:Timer;
		private var _anime:Sprite = new Sprite;
		private var _anime_index:int = 0;
		
		private var _cur_exp:Number = 0;
		private var _cur_level:int = 0;
		private const _exp_arr:Array = new Array(100, 200, 200);
		private var _level_arr:Array = new Array(BitmapControl.ANIME_1, BitmapControl.ANIME_2, BitmapControl.ANIME_3, BitmapControl.ANIME_4);
		
		private var _exp_spr:Sprite;
		private var _exp_bar:Sprite;
		
		public function GrowPage(params:Object=null)
		{
			tweenHeader(-Elever.Main.HeaderHeight);
			
			var obj:Object = Elever.loadEnviroment("Level", null);
			if(obj == null)
				_cur_level = 0;
			else
			{
				_cur_level = int(obj);
				_cur_exp = int(Elever.loadEnviroment("Exp", _cur_exp));
			}
			
			calcExp();
			
			_anime.y = -Elever.Main.HeaderHeight;
			addChild(_anime);
			
			if(_cur_level != 3)
			{
				_exp_spr = new Sprite;
				_exp_spr.graphics.beginFill(0x000000);
				_exp_spr.graphics.drawRect(0, 0, 550, 42);
				_exp_spr.graphics.endFill();
				addChild(_exp_spr);
				
				_exp_bar = new Sprite;
				_exp_bar.graphics.beginFill(0xf6ff00);
				_exp_bar.graphics.drawRect(0, 0, 538, 30);
				_exp_bar.graphics.endFill();
				_exp_bar.x = 6;
				_exp_bar.y = 6;
				_exp_bar.scaleX = _cur_exp/_exp_arr[_cur_level];
				_exp_spr.addChild(_exp_bar);
				
				_exp_spr.x = Elever.Main.PageWidth/2 - _exp_spr.width/2;
			}
			
			animate(_level_arr[_cur_level]);
		}
		private function animate(arr:Array):void
		{
			var bmp:Bitmap = BitmapControl.newBitmap(arr[_anime_index++]);
			_anime.addChild(bmp);
			_animate_timer = new Timer(ANIME_DELAY, function():void
			{
				_anime.removeChild(bmp);
				bmp = BitmapControl.newBitmap(arr[_anime_index++]);
				_anime.addChild(bmp);
			}, arr.length-1, true, function():void
			{
				if(arr == BitmapControl.ANIME_1)
				{
					var index:int = 2;
					_animate_timer = new Timer(ANIME_DELAY, function():void
					{
						_anime.removeChild(bmp);
						bmp = BitmapControl.newBitmap(arr[index]);
						_anime.addChild(bmp);
						index = (index == 2) ? 3 : 2;
					});
				}
				else
				{
					_anime_index = 0;
					animate(_level_arr[_cur_level]);
				}
			});
		}
		private function evolve():void
		{
			if(_cur_level == 3) return;
			
			_cur_exp = 0;
			Elever.saveEnviroment("Exp", _cur_exp);
			Elever.saveEnviroment("Level", ++_cur_level);
//			animate(_level_arr[_cur_level]);
		}
		private function calcExp():void
		{
			var lazy:Number = Home.calculateRate();
			_cur_exp += lazy;
			
			if(_cur_exp >= _exp_arr[_cur_level])
				evolve();
			trace(_cur_exp+"/"+_exp_arr[_cur_level], _cur_level);
			
			Elever.saveEnviroment("Exp", _cur_exp);
		}
		private function tweenHeader(y:Number):void
		{
			TweenLite.to(Elever.Main.header.getChildByName("NavigationBar"), TWEEN_DURATION, { y:y });
		}
		public override function init():void
		{
		}
		public override function onResize():void
		{
		}
		
		public override function dispose():void
		{
			Elever.saveEnviroment("Exp", _cur_exp);
			Elever.saveEnviroment("Level", _cur_level);
			tweenHeader(0);
		}
	}
}
