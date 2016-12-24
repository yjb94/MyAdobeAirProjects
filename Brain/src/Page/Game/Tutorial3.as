package Page.Game
{	
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.RemoteNotificationEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.text.ReturnKeyLabel;
	import flash.text.SoftKeyboardType;
	import flash.text.StageText;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import spark.effects.CallAction;
	
	import Page.BasePage;
	
	import kr.pe.hs.tween.Tween;
	import kr.pe.hs.ui.TabbedButton;
	
	public class Tutorial3 extends BasePage
	{	
		[Embed(source = "assets/page/game/game3/bg.png")]
		private static const BG:Class;
		
		[Embed(source = "assets/page/game/tutorial/game1-1.png")]
		private static const START_TUTORIAL:Class;
		[Embed(source = "assets/page/game/tutorial/game3-2.png")]
		private static const SEE_POINT:Class;
		[Embed(source = "assets/page/game/tutorial/game3-6.png")]
		private static const START:Class;
		[Embed(source = "assets/page/game/tutorial/game3-3.png")]
		private static const REMEMBER_FRUIT:Class;
		[Embed(source = "assets/page/game/tutorial/game3-4.png")]
		private static const IS_SAME:Class;
		[Embed(source = "assets/page/game/tutorial/game3-5.png")]
		private static const IS_SAME2:Class;
		[Embed(source = "assets/page/game/tutorial/game3-7.png")]
		private static const IS_SAME3:Class;
		private var _popup:Sprite;
		private var _tutorial_index:int=0;
		
		
		private var _is_answer_mode:Boolean = false;	//정답 모드인지
		
		public function Tutorial3()
		{
			super();
			
			Brain.Main.TopMenuVisible = false;
			
			var bmp:Bitmap = new BG; bmp.smoothing = true; addChild(bmp);
			
			showPopup(START_TUTORIAL);
		}
		public function showPopup(popup:Class):void
		{
			_popup = new Sprite;
			
			_popup.graphics.clear();
			_popup.graphics.beginFill(0x000000,0.6);
			_popup.graphics.drawRect(0,0,Brain.Main.PageWidth,Brain.Main.PageHeight);
			_popup.graphics.endFill();
			
			var bmp:Bitmap = new popup;
			bmp.smoothing = true;
			bmp.x = Brain.Main.PageWidth/2 - bmp.width/2;
			bmp.y = Brain.Main.PageHeight/2 - bmp.height/2;
			_popup.addChild(bmp);
			
			_popup.addEventListener(MouseEvent.CLICK, onClick);
			
			addChild(_popup);
			
			_tutorial_index++;
		}
		private function removeFruit():void
		{
			removeChild(_fruit);
		}
		private function showIsSame():void
		{
			showPopup(IS_SAME);
		}
		private function showIsSame2():void
		{
			showPopup(IS_SAME2);
		}
		private function showIsSame3():void
		{
			showPopup(IS_SAME3);
		}
		private function onClick(e:MouseEvent):void
		{
			if(_popup)
			{
				_popup.removeEventListener(MouseEvent.CLICK, onClick);
				removeChild(_popup);
			}
			
			if(_tutorial_index == 1)
			{
				showPopup(SEE_POINT);
			}
			else if(_tutorial_index == 2)
			{
				setTimeout(function():void
				{	
					_bmp_point = new POINT; _bmp_point.smoothing = true;
					_bmp_point.x = Brain.Main.FullWidth/2 - _bmp_point.width/2;
					_bmp_point.y = 480 - _bmp_point.height/2;
					addChild(_bmp_point);
					
					_blink_timer = new Timer(250, 4);
					_blink_timer.addEventListener(TimerEvent.TIMER, blinkTimer);
					_blink_timer.start();
					
					setTimeout(startTimer, 1700);
				}, 700);
				_popup = null;
			}
			else if(_tutorial_index == 3)
			{
				showFruit(GRAPE);
				setTimeout(indexDelay, 1000);
				_popup = null;
			}
			else if(_tutorial_index == 4)
			{
				showPopup(REMEMBER_FRUIT);
			}
			else if(_tutorial_index == 5)
			{
				setTimeout(removeFruit, 1500);
				setTimeout(indexDelay, 2500);
				_popup = null;
			}
			else if(_tutorial_index == 6)
			{
				showFruit(GRAPE);
				setTimeout(showIsSame, 1000);
			}
			else if(_tutorial_index == 7)
			{
				var bmp:Bitmap = new YES;    bmp.smoothing    = true;
				var bmp_on:Bitmap = new YES; bmp_on.smoothing = true; bmp_on.alpha = 0.6;
				_button_yes = new TabbedButton(bmp, bmp_on, bmp_on); _button_yes.x = 19; _button_yes.y = 80;
				_button_yes.addEventListener(MouseEvent.CLICK, yesClick); addChild(_button_yes);
				
				bmp = new NO;    bmp.smoothing    = true;
				bmp_on = new NO; bmp_on.smoothing = true; bmp_on.alpha = 0.6;
				_button_no = new TabbedButton(bmp, bmp_on, bmp_on); _button_no.x = 19; _button_no.y = 680;
				_button_no.addEventListener(MouseEvent.CLICK, noClick); addChild(_button_no);
				
				_bmp_state = new O;
				_bmp_state.alpha = 0;
				addChild(_bmp_state);
				
				_popup = null;
			}
			else if(_tutorial_index == 8)
			{
				_button_yes.removeEventListener(MouseEvent.CLICK, yesClick);
				_button_no.removeEventListener(MouseEvent.CLICK, noClick);
				setTimeout(indexDelay, 700);
				_popup = null;
			}
			else if(_tutorial_index == 9)
			{
				showFruit(BANANA);
				setTimeout(showIsSame2, 1000);
			}
			else if(_tutorial_index == 10)
			{
				_button_yes.addEventListener(MouseEvent.CLICK, yesClick);
				_button_no.addEventListener(MouseEvent.CLICK, noClick);
				_popup = null;
			}
			else if(_tutorial_index == 11)
			{
				showTwoFruit(GRAPE, BANANA);
				setTimeout(showIsSame3, 1000);
			}
			else if(_tutorial_index == 12)
			{
				_button_yes.addEventListener(MouseEvent.CLICK, yesClick);
				_button_no.addEventListener(MouseEvent.CLICK, noClick);
				_popup = null;
			}
			else if(_tutorial_index == 13)
			{
				showPopup(START);
			}
			else
				Brain.Main.setPage("brainGame3Page");
		}
		private function indexDelay():void
		{
			_tutorial_index++;
			onClick(null);
		}
		//2
		[Embed(source = "assets/page/game/game3/point.png")]
		private static const POINT:Class;
		private var _bmp_point:Bitmap;
		private var _blink_timer:Timer;
		public function blinkTimer(e:Event):void
		{
			if(_bmp_point.visible)
				_bmp_point.visible = false;
			else
				_bmp_point.visible = true;
		}
		public function startTimer():void
		{
			_blink_timer.removeEventListener(TimerEvent.TIMER, blinkTimer);
			removeChild(_bmp_point);
			
			indexDelay();
		}
		//3
		[Embed(source = "assets/page/game/game3/banana.png")]
		private static const BANANA:Class;
		[Embed(source = "assets/page/game/game3/grape.png")]
		private static const GRAPE:Class;
		private var _fruit:Bitmap;
		private function showFruit(name:Class):void
		{
			_fruit = new name;
			_fruit.smoothing = true;
			_fruit.x = Brain.Main.PageWidth/2 - _fruit.width/2;
			_fruit.y = 480 - _fruit.height/2;
			addChild(_fruit);
		}
		private var _fruit2:Bitmap;
		private function showTwoFruit(name1:Class, name2:Class):void
		{
			_fruit = new name1;
			_fruit.smoothing = true;
			_fruit.scaleX = 0.8;
			_fruit.scaleY = 0.8;
			_fruit.x = Brain.Main.PageWidth/2 - _fruit.width/2;
			_fruit.y = 480 - 100 - (_fruit.height)/2;
			addChild(_fruit);
			
			_fruit2 = new name2;
			_fruit2.smoothing = true;
			_fruit2.scaleX = 0.8;
			_fruit2.scaleY = 0.8;
			_fruit2.x = Brain.Main.PageWidth/2 - _fruit2.width/2;
			_fruit2.y = 480 + 100 - (_fruit2.height)/2;
			addChild(_fruit2);
		}
		//7
		[Embed(source = "assets/page/game/game3/yes.png")]
		private static const YES:Class;
		private var _button_yes:TabbedButton;
		[Embed(source = "assets/page/game/game3/no.png")]
		private static const NO:Class;
		private var _button_no:TabbedButton;
		private var _correct:Boolean = false;
		private var _effect:Sound;
		private function isError(e:IOErrorEvent):void
		{
			trace(e.errorID);
		}
		private function onSoundLoaded(e:Event):void
		{
			var localSound:Sound = e.target as Sound;
			localSound.play();
		}
		private function yesClick(e:MouseEvent):void
		{
			if(_bmp_state.alpha != 0)	return;
			
			_effect = new Sound();
			_effect.addEventListener(IOErrorEvent.IO_ERROR, isError);
			_effect.addEventListener(Event.COMPLETE, onSoundLoaded);
			
			if(_bmp_state)	removeChild(_bmp_state);
						
			if(_tutorial_index == 7)
			{
				_bmp_state = new O;
				_effect.load(new URLRequest("sound/correct.mp3"));
				_correct = true;
			}
			else if(_tutorial_index == 10 || _tutorial_index == 12)
			{
				_bmp_state = new X;
				_effect.load(new URLRequest("sound/wrong.mp3"));
			}
			_bmp_state.smoothing = true;   _bmp_state.alpha = 0;
			_bmp_state.x = Brain.Main.PageWidth/2 - _bmp_state.width/2;
			_bmp_state.y = 480 - _bmp_state.height/2;
			addChild(_bmp_state);
			FadeTween();
		}
		private function noClick(e:MouseEvent):void
		{
			if(_bmp_state.alpha != 0)	return;
			
			_effect = new Sound();
			_effect.addEventListener(IOErrorEvent.IO_ERROR, isError);
			_effect.addEventListener(Event.COMPLETE, onSoundLoaded);
			
			if(_bmp_state)	removeChild(_bmp_state);
			
			
			if(_tutorial_index == 7)
			{
				_bmp_state = new X;
				_effect.load(new URLRequest("sound/wrong.mp3"));
			}
			else if(_tutorial_index == 10 || _tutorial_index == 12)
			{
				_bmp_state = new O;
				_effect.load(new URLRequest("sound/correct.mp3"));
				_correct = true;
			}
			_bmp_state.smoothing = true;   _bmp_state.alpha = 0;
			_bmp_state.x = Brain.Main.PageWidth/2 - _bmp_state.width/2;
			_bmp_state.y = 480 - _bmp_state.height/2;
			addChild(_bmp_state);
			FadeTween();
		}
		
		//etc
		public function rand(min:int, max:int):int
		{
			return min + (max - min) * Math.random();
		}
		
		[Embed(source = "assets/page/game/index/O.png")]
		private static const O:Class;
		[Embed(source = "assets/page/game/index/X.png")]
		private static const X:Class;
		private var _bmp_state:Bitmap;
		
		private var _tween_alpha:Tween;
		public function FadeTween():void
		{
			_tween_alpha = new Tween(_bmp_state.alpha, 1, 0, 400, function(value:Number,isFinish:Boolean):void
			{	
				_bmp_state.alpha = value;
				if(isFinish)
				{
					_tween_alpha = new Tween(_bmp_state.alpha, 0, 0, 400, function(value:Number,isFinish:Boolean):void
					{	
						_bmp_state.alpha = value;
						if(isFinish)
						{
							if(_correct)
							{
								removeChild(_fruit);
								if(_fruit2) removeChild(_fruit2);
								setTimeout(indexDelay, 500);
								_correct = false;
							}
						}
					});
				}
			});
		}
		public override function onResize():void
		{
		}
		
		public override function dispose():void
		{
			_effect.removeEventListener(Event.COMPLETE, onSoundLoaded);
		}
	}
}