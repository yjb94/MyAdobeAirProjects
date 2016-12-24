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
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import spark.effects.CallAction;
	
	import Page.BasePage;
	
	import kr.pe.hs.tween.Tween;
	import kr.pe.hs.ui.TabbedButton;
	
	public class Tutorial4 extends BasePage
	{
		private static const ANIMAL_APPEAR_TIME = 1000;
		private static const DELAY = 200;
		
		[Embed(source = "assets/page/game/game4/bg.png")]
		private static const BG:Class;
		
		[Embed(source = "assets/page/game/tutorial/game1-1.png")]
		private static const START_TUTORIAL:Class;
		[Embed(source = "assets/page/game/tutorial/game1-2.png")]
		private static const SEE_POINT:Class;
		[Embed(source = "assets/page/game/tutorial/game4-1.png")]
		private static const REMEMBER:Class;
		[Embed(source = "assets/page/game/tutorial/game4-2.png")]
		private static const FIND:Class;
		[Embed(source = "assets/page/game/tutorial/game1-4.png")]
		private static const START:Class;
		
		private var _popup:Sprite;
		private var _tutorial_index:int=0;
		
		
		private var _is_answer_mode:Boolean = false;	//정답 모드인지
		
		public function Tutorial4()
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
				showPopup(REMEMBER);
			}
			else if(_tutorial_index == 4)
			{
				_animal_sound = new Sound();
				_animal_sound.addEventListener(IOErrorEvent.IO_ERROR, isAnimalSoundError);
				_animal_sound.addEventListener(Event.COMPLETE, onAnimalSoundLoaded);
				_animal_sound.load(new URLRequest("sound/"+"dog.mp3"));
				
				showAnimal(DOG);
				setTimeout(indexDelay, ANIMAL_APPEAR_TIME);
				_popup = null;
			}
			else if(_tutorial_index == 5)
			{
				removeChild(_animal);
				setTimeout(indexDelay, DELAY);
				_popup = null;
			}
			else if(_tutorial_index == 6)
			{
				_animal_sound = new Sound();
				_animal_sound.addEventListener(IOErrorEvent.IO_ERROR, isAnimalSoundError);
				_animal_sound.addEventListener(Event.COMPLETE, onAnimalSoundLoaded);
				_animal_sound.load(new URLRequest("sound/"+"cat.mp3"));
				
				showAnimal(CAT);
				setTimeout(indexDelay, ANIMAL_APPEAR_TIME);
				_popup = null;
			}
			else if(_tutorial_index == 7)
			{
				removeChild(_animal);
				setTimeout(indexDelay, DELAY);
				_popup = null;
			}
			else if(_tutorial_index == 8)
			{
				drawQuestion();
								
				showPopup(FIND);
			}
			else if(_tutorial_index == 9)
			{
				for(var i:int = 0; i < 6; i++)
					_bmp_animal_question[i].addEventListener(MouseEvent.CLICK, onAnimalClick);
				_popup = null;
			}
			else if(_tutorial_index == 10)
				showPopup(START);
			else
				Brain.Main.setPage("brainGame4Page");
		}
		
		//2
		[Embed(source = "assets/page/game/game1/point.png")]
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
		//4
		private var _animal_sound:Sound;
		private function isAnimalSoundError(e:IOErrorEvent):void
		{
			trace(e.errorID);
		}
		private function onAnimalSoundLoaded(e:Event):void
		{
			if(_animal_sound) _animal_sound.removeEventListener(Event.COMPLETE, onAnimalSoundLoaded);
			var localSound:Sound = e.target as Sound;
			localSound.play();
		}
		[Embed(source = "assets/page/game/game4/dog.png")]
		private static const DOG:Class;
		private var _animal:Bitmap;
		private function showAnimal(name:Class):void
		{
			_animal = new name;
			_animal.smoothing = true;
			_animal.x = Brain.Main.PageWidth/2 - _animal.width/2;
			_animal.y = 480 - _animal.height/2;
			addChild(_animal);
		}
		//6
		[Embed(source = "assets/page/game/game4/cat.png")]
		private static const CAT:Class;
		//8
		[Embed(source = "assets/page/game/game4/bull.png")]
		private static const BULL:Class;
		[Embed(source = "assets/page/game/game4/chicken.png")]
		private static const CHICKEN:Class;
		[Embed(source = "assets/page/game/game4/frog.png")]
		private static const FROG:Class;
		[Embed(source = "assets/page/game/game4/goat.png")]
		private static const GOAT:Class;
		[Embed(source = "assets/page/game/game4/animal_bg.png")]
		private static const ANIMAL_BG:Class;
		[Embed(source = "assets/page/game/tutorial/border.png")]
		private static const BORDER:Class;
		[Embed(source = "assets/page/game/game2/button_next.png")]
		private static const BUTTON_NEXT:Class;
		private var _btn_next:TabbedButton;
		private var _bmp_animal_question:Vector.<Sprite>;
		private var _bmp_animal_bg:Vector.<Bitmap>;
		private var _bmp_animal_border:Vector.<Bitmap>;
		private function drawQuestion():void
		{
			var bmp:Bitmap   = new BUTTON_NEXT;    bmp.smoothing    = true;
			var bmp_on:Bitmap = new BUTTON_NEXT; bmp_on.smoothing = true; bmp_on.alpha = 0.6;
			_btn_next = new TabbedButton(bmp, bmp_on, bmp_on); _btn_next.x = 40; _btn_next.y =  Brain.Main.PageHeight-18-_btn_next.height;
			_btn_next.addEventListener(MouseEvent.CLICK, nextClicked); addChild(_btn_next);
			_btn_next.alpha = 0.6;
			
			_bmp_animal_question = new Vector.<Sprite>(6, false);
			_bmp_animal_bg = new Vector.<Bitmap>(6, false);
			_bmp_animal_border = new Vector.<Bitmap>(2, false);
			
			newBG(0, 105, 232.5);
			newAnimal(BULL, 0, 105, 232.5);
			
			newBG(1, 105+185, 232.5+165);
			newAnimal(CHICKEN, 1, 105+185, 232.5+165);
			
			newBG(2, 105, 232.5+165*2);
			newAnimal(CAT, 2, 105, 232.5+165*2);
			newBorder(0, 105, 232.5+165*2);
			
			newBG(3, 105+185, 232.5);
			newAnimal(DOG, 3, 105+185, 232.5);
			newBorder(1, 105+185, 232.5);
			
			newBG(4, 105, 232.5+165);
			newAnimal(FROG, 4, 105, 232.5+165);
			
			newBG(5, 105+185, 232.5+165*2);
			newAnimal(GOAT, 5, 105+185, 232.5+165*2);
		}
		private function newBG(index:int, x:Number, y:Number):void
		{
			_bmp_animal_bg[index] = new ANIMAL_BG;
			_bmp_animal_bg[index].x = x;
			_bmp_animal_bg[index].y = y;
			scaleBG(_bmp_animal_bg[index], 185, 165);
			addChild(_bmp_animal_bg[index]);
		}
		private function scaleBG(img:Bitmap, width:int, height:int):void
		{
			img.width = width;
			img.height = height;
		}
		private function newAnimal(name:Class, index:int, x:Number, y:Number):void
		{
			var bmp:Bitmap = new name;
			_bmp_animal_question[index] = new Sprite;
			_bmp_animal_question[index].addChild(bmp);
			_bmp_animal_question[index].x = x;
			_bmp_animal_question[index].y = y;
			scaleImage(_bmp_animal_question[index], 185, 162);
			addChild(_bmp_animal_question[index]);
		}
		private function scaleImage(img:Sprite, width:int, height:int):void
		{
			img.width = width;
			img.height = height;
			if(img.scaleX > img.scaleY) img.scaleX = img.scaleY;
			else						img.scaleY = img.scaleX;
		}
		private function newBorder(index:int, x:Number, y:Number):void
		{
			_bmp_animal_border[index] = new BORDER;
			_bmp_animal_border[index].x = x;
			_bmp_animal_border[index].y = y;
			scaleBG(_bmp_animal_border[index], 185, 165);
			addChild(_bmp_animal_border[index]);
		}
		//9
		private var _clicked_time:int = 0;
		private var _user_answer:Array = new Array;
		private function onAnimalClick(e:MouseEvent):void
		{
			var index:int = getIndex(mouseX, mouseY);
			
			var spr:Sprite = (e.currentTarget as Sprite);
			
			var selected_animal:int;
			
			if(spr.alpha == 1)
			{
				_clicked_time++;
				spr.alpha = 0.7;
				_user_answer.push(index);
			}
			else
			{
				_clicked_time--;
				spr.alpha = 1.0;
				for(var i:int = 0; i < _user_answer.length; i++)
					if(_user_answer[i] == index)
						_user_answer.splice(i,1);
			}
						
			if(_clicked_time >= 2)
				_btn_next.alpha = 1.0;
			else
				_btn_next.alpha = 0.6;
		}
		private function nextClicked(e:MouseEvent):void
		{
			if(_btn_next.alpha == 1.0)
				checkAnswer();//endGame();
		}
		private function getIndex(mouse_x:Number, mouse_y:Number):int
		{
			
			var animal_num:Number = 6;
			
			var wid:Number = _bmp_animal_bg[0].width;
			var hei:Number = _bmp_animal_bg[0].height;
			
			var start_x:Number;
			var start_y:Number;
			
			if(_bmp_animal_question.length <=6) { start_x = 105; start_y = 232.5; }
			else if(_bmp_animal_question.length <=8) { start_x = 130; start_y = 200; }
			else if(_bmp_animal_question.length <=10) { start_x = 130; start_y = 130; }
			
			if((start_x <= mouse_x && mouse_x <= start_x + wid) &&
				(start_y <= mouse_y && mouse_y <= start_y + hei))	// 0
				return 0;
			else if((start_x + wid <= mouse_x && mouse_x <= start_x + wid*2) &&
				(start_y <= mouse_y && mouse_y <= start_y + hei))
				return animal_num/2;
			else if((start_x <= mouse_x && mouse_x <= start_x + wid) &&
				(start_y + hei <= mouse_y && mouse_y <= start_y + hei*2))
				return 1;
			else if((start_x + wid <= mouse_x && mouse_x <= start_x + wid*2) &&
				(start_y + hei <= mouse_y && mouse_y <= start_y + hei*2))
				return animal_num/2+1;
			else if((start_x <= mouse_x && mouse_x <= start_x + wid) &&
				(start_y + hei*2 <= mouse_y && mouse_y <= start_y + hei*3))
				return 2;
			else if((start_x + wid <= mouse_x && mouse_x <= start_x + wid*2) &&
				(start_y + hei*2 <= mouse_y && mouse_y <= start_y + hei*3))
				return animal_num/2+2;
			else if((start_x <= mouse_x && mouse_x <= start_x + wid) &&
				(start_y + hei*3 <= mouse_y && mouse_y <= start_y + hei*4))
				return 3;
			else if((start_x + wid <= mouse_x && mouse_x <= start_x + wid*2) &&
				(start_y + hei*3 <= mouse_y && mouse_y <= start_y + hei*4))
				return animal_num/2+3;
			else if((start_x <= mouse_x && mouse_x <= start_x + wid) &&
				(start_y + hei*4 <= mouse_y && mouse_y <= start_y + hei*5))
				return 4;
			else if((start_x + wid <= mouse_x && mouse_x <= start_x + wid*2) &&
				(start_y + hei*4 <= mouse_y && mouse_y <= start_y + hei*5))
				return animal_num/2+4;
			
			return -1;
		}
		private var _is_gameover:Boolean = false;
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
		private function checkAnswer():void
		{
			if(_is_gameover)	return;
			_effect = new Sound();
			_effect.addEventListener(IOErrorEvent.IO_ERROR, isError);
			_effect.addEventListener(Event.COMPLETE, onSoundLoaded);
			if((_user_answer[0] == 2 && _user_answer[1] == 3) || (_user_answer[1] == 2 && _user_answer[0] == 3))
			{
				_bmp_state = new O;
				_effect.load(new URLRequest("sound/correct.mp3"));
				_is_gameover = true;
			}
			else
			{
				_effect.load(new URLRequest("sound/wrong.mp3"));
				_bmp_state = new X;
			}
			_bmp_state.smoothing = true;   _bmp_state.alpha = 0;
			_bmp_state.x = Brain.Main.PageWidth/2 - _bmp_state.width/2;
			_bmp_state.y = 480 - _bmp_state.height/2;
			addChild(_bmp_state);
			FadeTween();
		}
		//etc
		private function indexDelay():void
		{
			_tutorial_index++;
			onClick(null);
		}
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
							if(_is_gameover)
								indexDelay();
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
			_animal_sound.removeEventListener(Event.COMPLETE, onAnimalSoundLoaded);
		}
	}
}
