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
	
	public class Tutorial2 extends BasePage
	{	
		[Embed(source = "assets/page/game/game2/bg.png")]
		private static const BG:Class;
		[Embed(source = "assets/page/game/game2/bg2.png")]
		private static const BG2:Class;
		
		[Embed(source = "assets/page/game/tutorial/game1-1.png")]
		private static const START_TUTORIAL:Class;
		[Embed(source = "assets/page/game/tutorial/game1-4.png")]
		private static const START:Class;
		[Embed(source = "assets/page/game/tutorial/game2-2.png")]
		private static const NEXT_PIZZA:Class;
		[Embed(source = "assets/page/game/tutorial/game2-3.png")]
		private static const GIVE_ANSWER:Class;
		private var _popup:Sprite;
		private var _tutorial_index:int=0;
		
		
		private var _is_answer_mode:Boolean = false;	//정답 모드인지
		
		public function Tutorial2()
		{
			super();
			
			Brain.Main.TopMenuVisible = false;
			
			var bmp:Bitmap = new BG; bmp.smoothing = true; addChild(bmp);
			
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
			
			if(popup == START)
				setTimeout(indexDelay, 2000);
			
			
			if(!delay)
				_tutorial_index++;
			else
				setTimeout(indexDelay, delay);
		}
		private var touch_tween:Tween;
		
		[Embed(source = "assets/page/game/tutorial/touch.png")]
		private static const TOUCH:Class;
		private var _touch:TabbedButton;
		private var stopTween:Boolean;
		private function TouchTween():void
		{
			if(stopTween) return;
			touch_tween = new Tween(_touch.alpha, 1, 0, 500, function(value:Number,isFinish:Boolean):void
			{
				_touch.alpha = value;
				if(isFinish)
				{
					touch_tween = new Tween(_touch.alpha, 0, 0, 500, function(value:Number,isFinish:Boolean):void
					{
						_touch.alpha = value;
						if(isFinish)
						{
							TouchTween();
						}
					});
				}
			});
		}
		private function Touch(e:MouseEvent):void
		{
			touch_tween = null;
			stopTween = true;
			_touch.removeEventListener(MouseEvent.CLICK, Touch);
			removeChild(_touch);
			_touch = null;
			indexDelay();
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
				_bmp_food = new Vector.<Bitmap>;
				_answer = GamePattern1_2();
				setTimeout(indexDelay, 1000);
				_popup = null;
			}
			else if(_tutorial_index == 2)
			{
				showPopup(NEXT_PIZZA);
			}
			else if(_tutorial_index == 3)
			{
				bmp = new TOUCH; bmp.smoothing = true;
				_touch = new TabbedButton(bmp, bmp, bmp);
				_touch.x = 91;
				_touch.y = 658;
				_touch.alpha = 0;
				_touch.addEventListener(MouseEvent.CLICK, Touch);
				addChild(_touch);
				TouchTween();
				_popup=null;
			}
			else if(_tutorial_index == 4)
			{
				_bmp_answ_food = new Vector.<Bitmap>(8, false);
				
				var bmp:Bitmap = new BG2; bmp.smoothing = true; addChild(bmp);
				
				bmp   = new BUTTON_NEXT;    bmp.smoothing    = true;
				var bmp_on:Bitmap = new BUTTON_NEXT; bmp_on.smoothing = true; bmp_on.alpha = 0.6;
				_btn_next = new TabbedButton(bmp, bmp_on, bmp_on); _btn_next.x = 40; _btn_next.y =  Brain.Main.PageHeight-18-_btn_next.height;
				_btn_next.alpha = 0.6;
				_btn_next.addEventListener(MouseEvent.CLICK, nextClicked); addChild(_btn_next);
				
				for(var i:int = 0; i < _bmp_food.length; i++)
					removeChild(_bmp_food[i]);
				_bmp_food = null;
				_bmp_food = new Vector.<Bitmap>;
				_is_answer_mode = true;
				GamePattern1_2();
				showAnswer();
				setTimeout(indexDelay, 500);
				
				_popup = null;
			}
			else if(_tutorial_index == 5)
			{
				showPopup(GIVE_ANSWER);
			}
			else if(_tutorial_index == 6)
			{
				addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
				addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
				addEventListener(MouseEvent.MOUSE_UP, mouseUp);
				
				_popup = null;
			}
			else if(_tutorial_index == 7)
			{
				removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
				removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
				removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
				showPopup(START);
			}
			else
				Brain.Main.setPage("brainGame2Page");
		}
		private function indexDelay():void
		{
			_tutorial_index++;
			onClick(null);
		}
		
		//1
		private var _prev_start_place:int = -1;
		[Embed(source = "assets/page/game/game2/tiny_pizza.png")]
		private static const TINY_PIZZA:Class;
		[Embed(source = "assets/page/game/game2/small_pizza.png")]
		private static const SMALL_PIZZA:Class;
		[Embed(source = "assets/page/game/game2/big_cake.png")]
		private static const BIG_CAKE:Class;
		[Embed(source = "assets/page/game/game2/big_pizza.png")]
		private static const BIG_PIZZA:Class;
		private var _bmp_food:Vector.<Bitmap>;
		private var _answer:String = "";
		
		
		public function GamePattern1_2():String
		{
			var start_place:int = 0;
			if(!_is_answer_mode)
				_prev_start_place = start_place
			
			var index:int = 0;
			for(var i:int = 0; i < 3; i++)
			{
				if(_is_answer_mode)
					var bmp:Bitmap = new TINY_PIZZA;
				else
					bmp = new SMALL_PIZZA;
				bmp.smoothing = true;
				bmp.rotation = 45*(start_place+i);
				if(_is_answer_mode)
					bmp.rotation = 45*(_prev_start_place+i);
				
				if(_is_answer_mode)
				{
					if(i == 0)
					{
						bmp.x = 443;
						bmp.y = 175;
					}
					else if(i == 1)
					{
						bmp.x = 271;
						bmp.y = 175;
					}
					else if(i == 2)
					{
						bmp.x = 96;
						bmp.y = 175;
					}
				}
				else
				{
					if(i == 0)
					{
						bmp.x = 390;
						bmp.y = 302;
					}
					else if(i == 1)
					{
						bmp.x = 390;
						bmp.y = 719;
					}
					else if(i == 2)
					{
						bmp.x = 140;
						bmp.y = 302;
					}
				}
				
				_bmp_food.push(bmp);
				addChild(_bmp_food[index++]);
			}
			
			var answer:String;
			
			switch(start_place)
			{
				case 5:		answer = "10000000";	break;
				case 6:		answer = "01000000";	break;
				case 7:		answer = "00100000";	break;
				case 0:		answer = "00010000";	break;
				case 1:		answer = "00001000";	break;
				case 2:		answer = "00000100";	break;
				case 3:		answer = "00000010";	break;
				case 4:		answer = "00000001";	break;
			}
			
			return answer;
		}
		
		//2
		[Embed(source = "assets/page/game/game2/button_next.png")]
		private static const BUTTON_NEXT:Class;
		private var _btn_next:TabbedButton;
		private var _bmp_sel_food:Bitmap;
		private var _bmp_answ_food:Vector.<Bitmap>;
		private var _bmp_alpha_food:Bitmap;
		
		public function showAnswer():void
		{		
			_bmp_alpha_food = new BIG_PIZZA;
			_bmp_alpha_food.smoothing = true;
			_bmp_alpha_food.rotation = 45*(3);
			_bmp_alpha_food.x = 255;
			_bmp_alpha_food.y = 674;
			_bmp_alpha_food.alpha = 0.6;
			addChild(_bmp_alpha_food);
		}
		
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
		private function nextClicked(e:MouseEvent):void
		{
			if(_btn_next.alpha == 1.0)
			{
				if(_correct) return;
				if(_bmp_state)	removeChild(_bmp_state);
				
				_effect = new Sound();
				_effect.addEventListener(IOErrorEvent.IO_ERROR, isError);
				_effect.addEventListener(Event.COMPLETE, onSoundLoaded);
				
				if(_user_answer == _answer)
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
				_bmp_state.smoothing = true;   _bmp_state.alpha = 0;
				_bmp_state.x = Brain.Main.PageWidth/2 - _bmp_state.width/2;
				_bmp_state.y = 480 - _bmp_state.height/2;
				addChild(_bmp_state);
				FadeTween();
			}
		}
		
		private var _sel_food:int = 0;	//선택한 음식 0 - 아직 선택 안함 1 -피자 2 - 케이크
		private var _user_answer:String = "00000000";
		public function mouseDown(e:MouseEvent):void
		{
			var mouse_x:Number = this.mouseY;
			var mouse_y:Number = this.mouseX;
		
			if(_is_answer_mode)
			{
				if(367 <= mouse_x && mouse_x <= 487)
				{
					if(61 <= mouse_y && mouse_y <= 231)		//피자
					{
						_bmp_sel_food = new BIG_PIZZA;
						_bmp_sel_food.smoothing = true;
						_bmp_sel_food.rotation = -90;
						_bmp_sel_food.x = mouse_y - _bmp_sel_food.width/2;
						_bmp_sel_food.y = mouse_x + _bmp_sel_food.height/2;
						addChild(_bmp_sel_food);
						_sel_food = 1;
					}
					else if(306 <= mouse_y && mouse_y <= 479)		//케이크
					{
						_bmp_sel_food = new BIG_CAKE;
						_bmp_sel_food.smoothing = true;
						_bmp_sel_food.rotation = -90;
						_bmp_sel_food.x = mouse_y - _bmp_sel_food.width/2;
						_bmp_sel_food.y = mouse_x + _bmp_sel_food.height/2;
						addChild(_bmp_sel_food);
						_sel_food = 2;
					}
				}
				
				var index:int = getIndex(mouse_x, mouse_y);
				
				if(514 <= mouse_x && mouse_x <= 835)
				{
					if(94 <= mouse_y && mouse_y <= 414)
					{
						if(_bmp_answ_food[index] != null)
						{
							_sel_food = Number(_user_answer.substr(index, 1));
							_user_answer = _user_answer.substr(0, index) + "0" + _user_answer.substr(index+1, 8);
							
							if(_sel_food == 1)
								_bmp_sel_food = new BIG_PIZZA;
							else if(_sel_food == 2)
								_bmp_sel_food = new BIG_CAKE;
							
							_bmp_sel_food.smoothing = true;
							_bmp_sel_food.x = 255;
							_bmp_sel_food.y = 674;
							_bmp_sel_food.rotation = 45*index;
							
							addChild(_bmp_sel_food);
							
							removeChild(_bmp_answ_food[index]);
							_bmp_answ_food[index] = null;
						}
					}
				}
			}
		}
		public function mouseMove(e:MouseEvent):void
		{
			var mouse_x:Number = this.mouseY;
			var mouse_y:Number = this.mouseX;
			
			if(_sel_food)//선택한 음식 0 - 아직 선택 안함 1 -피자 2 - 케이크
			{
				if(_bmp_sel_food != null)
				{
					_bmp_sel_food.rotation = -90;
					_bmp_sel_food.x = mouse_y - _bmp_sel_food.width/2;
					_bmp_sel_food.y = mouse_x + _bmp_sel_food.height/2;
					
					if(514 <= mouse_x && mouse_x <= 835)
					{
						if(94 <= mouse_y && mouse_y <= 414)
						{
							_bmp_sel_food.x = 255;
							_bmp_sel_food.y = 674;
							_bmp_sel_food.rotation = 45*getIndex(mouse_x, mouse_y);
						}
					}
				}
			}
		}
		public function mouseUp(e:MouseEvent):void
		{
			var mouse_x:Number = this.mouseY;
			var mouse_y:Number = this.mouseX;
			
			if(_sel_food)//선택한 음식 0 - 아직 선택 안함 1 -피자 2 - 케이크
			{
				if(_bmp_sel_food != null)
				{
					removeChild(_bmp_sel_food);
					_bmp_sel_food = null;
				}
				
				var index:int = getIndex(mouse_x, mouse_y);
				
				if(514 <= mouse_x && mouse_x <= 835)
				{
					if(94 <= mouse_y && mouse_y <= 414)
					{
						if(_bmp_answ_food[index] != null)
							removeChild(_bmp_answ_food[index]);
						
						if(_sel_food == 1)
							_bmp_answ_food[index] = new BIG_PIZZA;
						else if(_sel_food == 2)
							_bmp_answ_food[index] = new BIG_CAKE;
						
						_bmp_answ_food[index].smoothing = true;
						_bmp_answ_food[index].rotation = 45*index;
						_bmp_answ_food[index].x = 255;
						_bmp_answ_food[index].y = 674;
						addChild(_bmp_answ_food[index]);
						
						_user_answer = _user_answer.substr(0, index) + _sel_food + _user_answer.substr(index+1, 8);
						
						_btn_next.alpha = 1.0;
					}
				}
			}
		}
		public function getIndex(x:Number, y:Number):int
		{
			//354, 71   556, 275   763, 481
			var a:Number = (y-255)/(x-674);
			if(a > 0)	//  기울기가 /
			{
				if(a < 1)	//아래
				{
					if(x-674 > 0)
						return 0;
					else
						return 4;
				}
				else		//위
				{
					if(x-674 > 0)
						return 7;
					else
						return 3;
				}
			}
			else		//	기울기가 \
			{
				if(a > -1)	//아래
				{
					if(x-674 < 0)
						return 5;
					else
						return 1;
				}
				else		//위
				{
					if(x-673 < 0)
						return 6;
					else
						return 2;
				}
			}
			
			return -1;
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
								setTimeout(indexDelay, 200);
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