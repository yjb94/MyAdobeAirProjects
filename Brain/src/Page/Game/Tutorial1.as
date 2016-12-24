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
	
	import Page.BasePage;
	
	import kr.pe.hs.tween.Tween;
	import kr.pe.hs.ui.TabbedButton;
	
	public class Tutorial1 extends BasePage
	{	
		[Embed(source = "assets/page/game/game1/bg.png")]
		private static const BG:Class;
		
		[Embed(source = "assets/page/game/tutorial/game1-1.png")]
		private static const START_TUTORIAL:Class;
		[Embed(source = "assets/page/game/tutorial/game1-2.png")]
		private static const SEE_POINT:Class;
		[Embed(source = "assets/page/game/tutorial/game1-3.png")]
		private static const TOUCH_BEAR:Class;
		[Embed(source = "assets/page/game/tutorial/game1-4.png")]
		private static const START:Class;
		private var _popup:Sprite;
		private var _tutorial_index:int=0;
		
		[Embed(source = "assets/page/game/game1/off.png")]
		private static const OFF:Class;
		[Embed(source = "assets/page/game/game1/on.png")]
		private static const ON:Class;
		[Embed(source = "assets/page/game/game1/bear.png")]
		private static const BEAR:Class;
		private var _bmp_left:Bitmap;
		private var _bmp_right:Bitmap;
		
		[Embed(source = "assets/page/game/game1/point.png")]
		private static const POINT:Class;
		private var _bmp_point:Bitmap;
		
		private var _window_dir:int;
		
		public function Tutorial1()
		{
			super();
			
			Brain.Main.TopMenuVisible = false;
			
			//bg
			var bmp:Bitmap = new BG; bmp.smoothing = true; addChild(bmp);
			
			//window
			_bmp_left = new OFF; _bmp_left.smoothing = true;
			_bmp_left.x = 112;
			_bmp_left.y = Brain.Main.FullHeight/4 - _bmp_left.height/2;
			addChild(_bmp_left);
			
			_bmp_right = new OFF; _bmp_right.smoothing = true;
			_bmp_right.x = 112;
			_bmp_right.y = Brain.Main.FullHeight*(3/4) - _bmp_right.height/2;
			addChild(_bmp_right);
			
			showPopup(START_TUTORIAL);
		}
		public function showPopup(popup:Class, delay:Number=0):void
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
			
			if(!delay)
				_tutorial_index++;
			else
				setTimeout(indexDelay, delay);
		}
		private function indexDelay():void
		{
			_tutorial_index++;
			onClick(null);
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
					_bmp_point.y = Brain.Main.FullHeight/2 - _bmp_point.height/2;
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
				setTimeout(removeLight, 1000);
				setTimeout(displayBear, 1500);
				
				_window_dir = rand(0,2);
				
				if(rand(0,2))
				{
					removeChild(_bmp_left);
					_bmp_left = new ON; _bmp_left.smoothing = true;
					_bmp_left.x = 112;
					_bmp_left.y = Brain.Main.FullHeight/4 - _bmp_left.height/2;
					addChild(_bmp_left);
				}
				else
				{
					removeChild(_bmp_right);
					_bmp_right = new ON; _bmp_right.smoothing = true;
					_bmp_right.x = 112;
					_bmp_right.y = Brain.Main.FullHeight*(3/4) - _bmp_right.height/2;
					addChild(_bmp_right);
				}
				_popup = null;
			}
			else if(_tutorial_index == 4)
			{
				showPopup(TOUCH_BEAR);
			}
			else if(_tutorial_index == 5)
			{
				addEventListener(MouseEvent.CLICK, onTouch);
				_popup = null;
			}
			else if(_tutorial_index == 6)
			{
				removeEventListener(MouseEvent.CLICK, onTouch);
				showPopup(START, 2000);
			}
			else
			{
				Brain.Main.setPage("brainGame1Page");
				_popup = null;
			}
		}
		
		//2
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
			
			_tutorial_index++;
			onClick(null);
		}
		
		//3
		public function removeLight(e:TimerEvent = null):void
		{
			//좌우 불끄기.
			removeChild(_bmp_left);
			_bmp_left = new OFF; _bmp_left.smoothing = true;
			_bmp_left.x = 112;
			_bmp_left.y = Brain.Main.FullHeight/4 - _bmp_left.height/2;
			addChild(_bmp_left);
			
			removeChild(_bmp_right);
			_bmp_right = new OFF; _bmp_right.smoothing = true;
			_bmp_right.x = 112;
			_bmp_right.y = Brain.Main.FullHeight*(3/4) - _bmp_right.height/2;
			addChild(_bmp_right);
		}
		public function displayBear(e:TimerEvent = null):void
		{
			if(_window_dir)
			{
				removeChild(_bmp_left);
				_bmp_left = new BEAR; _bmp_left.smoothing = true;
				_bmp_left.x = 112;
				_bmp_left.y = Brain.Main.FullHeight/4 - _bmp_left.height/2 + 11/2;		//11/2한거는 이미지 좌우대칭이 안되서 그럼.
				addChild(_bmp_left);
			}
			else
			{
				removeChild(_bmp_right);
				_bmp_right = new BEAR; _bmp_right.smoothing = true;
				_bmp_right.x = 112;
				_bmp_right.y = Brain.Main.FullHeight*(3/4) - _bmp_right.height/2 + 11/2;		//11/2한거는 이미지 좌우대칭이 안되서 그럼.
				addChild(_bmp_right);
			}
			setTimeout(indexDelay, 1000);
		}
		
		
		//4
		[Embed(source = "assets/page/game/index/O.png")]
		private static const O:Class;
		[Embed(source = "assets/page/game/index/X.png")]
		private static const X:Class;
		private var _bmp_state:Bitmap;
		
		private var _correct:Boolean = false;
		private var _isTouchedOnce:Boolean = false;
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
		private function onTouch(e:MouseEvent):void
		{	
			if(!_isTouchedOnce)
			{
				_isTouchedOnce = true;
				return;
			}
			if(_correct) return;
			if(_bmp_state)	removeChild(_bmp_state);
			
			_effect = new Sound();
			_effect.addEventListener(IOErrorEvent.IO_ERROR, isError);
			_effect.addEventListener(Event.COMPLETE, onSoundLoaded);
			
			if(this.mouseY <= Brain.Main.PageHeight/2)
			{
				if(_window_dir)
				{
					_bmp_state = new O;
					_effect.load(new URLRequest("sound/correct.mp3"));
					_correct = true;
				}
				else
				{
					_bmp_state = new X;
					_effect.load(new URLRequest("sound/wrong.mp3"));
				}
			}
			else
			{
				if(_window_dir)
				{
					_bmp_state = new X;
					_effect.load(new URLRequest("sound/wrong.mp3"));
				}
				else
				{
					_bmp_state = new O;
					_effect.load(new URLRequest("sound/correct.mp3"));
					_correct = true;
				}
			}
			_bmp_state.smoothing = true;   _bmp_state.alpha = 0;
			_bmp_state.x = Brain.Main.PageWidth/2 - _bmp_state.width/2;
			_bmp_state.y = Brain.Main.FullHeight/2 - _bmp_state.height/2;
			addChild(_bmp_state);
			FadeTween();
		}
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
								setTimeout(indexDelay, 500);
						}
					});
				}
			});
		}
		//etc
		public function rand(min:int, max:int):int
		{
			return min + (max - min) * Math.random();
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