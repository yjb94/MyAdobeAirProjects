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
	import flash.geom.Rectangle;
	import flash.html.script.Package;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.profiler.Telemetry;
	import flash.text.ReturnKeyLabel;
	import flash.text.SoftKeyboardType;
	import flash.text.StageText;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import Page.BasePage;
	import Page.Main.Index;
	
	import Popup.CancelGamePopup;
	import Popup.Game2Popup;
	
	import kr.pe.hs.tween.Tween;
	import kr.pe.hs.ui.TabbedButton;
	
	public class Game2 extends BasePage
	{	
		private var GAME_LENGTH:Number = 2;				//난이도 세분별당 게임 횟수
		private var GAME_ACCUR:Number = 2/3;				//게임 성공률
		
		private static const FADE_IN:Number = 300;
		private static const FADE_OUT:Number = 300;

		
		[Embed(source = "assets/page/game/game2/bg.png")]
		private static const BG:Class;
		[Embed(source = "assets/page/game/game2/bg2.png")]
		private static const BG2:Class;
		private var _bg:Bitmap;
		
		[Embed(source = "assets/page/game/game2/tiny_cake.png")]
		private static const TINY_CAKE:Class;
		[Embed(source = "assets/page/game/game2/tiny_pizza.png")]
		private static const TINY_PIZZA:Class;
		[Embed(source = "assets/page/game/game2/small_cake.png")]
		private static const SMALL_CAKE:Class;
		[Embed(source = "assets/page/game/game2/small_pizza.png")]
		private static const SMALL_PIZZA:Class;
		[Embed(source = "assets/page/game/game2/big_cake.png")]
		private static const BIG_CAKE:Class;
		[Embed(source = "assets/page/game/game2/big_pizza.png")]
		private static const BIG_PIZZA:Class;
		private var _bmp_food:Vector.<Bitmap>;
		private var _bmp_sel_food:Bitmap;
		private var _bmp_answ_food:Vector.<Bitmap>;

		[Embed(source = "assets/page/game/index/button_quit.png")]
		private static const BUTTON_QUIT:Class;
		private var _btn_quit:TabbedButton;
		
		private var _game_start:Boolean = false;
		private var _game_playing:Boolean = false;	//GameMethod~EndGame구간에서 참.
		private var _game_level:int = 1;	//난이도..
		private var _game_index:int = 0;
		private var _game_total_index:int = 0;
		private var _user_correct_cnt:int = 0;
		private var _user_add_correct_cnt:int = 0;
		private var _answer:String;
		
		private var _sel_food:int = 0;	//선택한 음식 0 - 아직 선택 안함 1 -피자 2 - 케이크
		private var _user_answer:String = "00000000";
		
		private var _user_selection:Object;	//0 - 오답 1 - 정답
		private var _user_is_addit:Object;	//추가수행인지 0 - 아님 1 - 맞음.
		private var _user_pattern:Object;	//무슨패턴인지
		private var _user_level:Object;		//래밸
		
		private var _game_pattern:Object;
		
		private var _is_answer_mode:Boolean = false;	//정답 모드인지
		
		private var _is_additional_game:Boolean = false;
		
		private var _tween_alpha:Tween;
		private var _tween_index:Number = 0;
		
		
		[Embed(source = "assets/page/game/index/O.png")]
		private static const O:Class;
		[Embed(source = "assets/page/game/index/X.png")]
		private static const X:Class;
		private var _bmp_state:Bitmap;
		
		[Embed(source = "assets/page/game/game2/button_next.png")]
		private static const BUTTON_NEXT:Class;
		private var _btn_next:TabbedButton;
		
		public function Game2()
		{	
			super();
			
			Brain.Main.TopMenuVisible = false;
			
			if(Brain.isTestGame)
			{
				GAME_LENGTH = 1;
				GAME_ACCUR = 0;
			}
			
			//bg
			_bg = new BG; _bg.smoothing = true; addChild(_bg);
			
			var bmp:Bitmap   = new BUTTON_QUIT;    bmp.smoothing    = true;
			var bmp_on:Bitmap = new BUTTON_QUIT; bmp_on.smoothing = true; bmp_on.alpha = 0.6;
			_btn_quit = new TabbedButton(bmp, bmp_on, bmp_on); _btn_quit.x = 486; _btn_quit.y =  Brain.Main.PageHeight-18-_btn_quit.height;
			addChild(_btn_quit);
			
			setTimeout(wait, 500);
		}
		private function wait():void
		{
			Brain.Main.showPopup(new Game2Popup(InitDatas));
		}
		public function quitClicked(e:MouseEvent):void
		{
			//팝업
			Brain.Main.showPopup(new CancelGamePopup(popupClicked));
		}
		private function popupClicked(value:Boolean):void
		{
			if(value)
				Brain.Main.setPage("brainGameIndexPage", null, BrainPageEffect.RIGHT, BrainPageEffect.RIGHT);
			Brain.Main.closePopup();
		}
		private function InitDatas():void
		{			
			//game not started
			_game_start = false;
			
			//user_data_init
			_user_selection = new Object;
			_user_is_addit = new Object;
			_user_pattern = new Object;
			_user_level = new Object;
			
			//vector init
			_bmp_food = new Vector.<Bitmap>;
			_bmp_answ_food = new Vector.<Bitmap>(8, false);
			
			//init datas
			_game_pattern = new Object;
			setPattern();
			
			//eventListner add
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			addEventListener(Event.ENTER_FRAME, EnterFrame);
			setTimeout(startTimer, 1000);
		}
		public function startTimer():void
		{
			_btn_quit.addEventListener(MouseEvent.CLICK, quitClicked); 
			
			_game_start = true;
		}
		
		public function EnterFrame(e:Event):void
		{			
			if(_game_start)
			{
				_game_start = false;
				gameMethod();
			}
		}
		public function gameMethod():void
		{
			if(_game_level == 1)
			{
				switch(_game_pattern[_game_index])
				{
					case 0:		_answer = GamePattern1_1();	break;
					case 1:		_answer = GamePattern1_2();	break;
					case 2:		_answer = GamePattern1_3();	break;
				}
				_user_pattern[_game_total_index] = _game_pattern[_game_index]+1;
			}
			else if(_game_level == 2)
			{
				switch(_game_pattern[_game_index])
				{
					case 0:		_answer = GamePattern2_1();	break;
					case 1:		_answer = GamePattern2_2();	break;
				}
				_user_pattern[_game_total_index] = _game_pattern[_game_index]+1;
			}
			else if(_game_level == 3)
			{
				switch(_game_pattern[_game_index])
				{
					case 0:		_answer = GamePattern3_1();	break;
					case 1:		_answer = GamePattern3_2();	break;
				}
				_user_pattern[_game_total_index] = _game_pattern[_game_index]+1;
			}
			else if(_game_level == 4)
			{
				_answer = GamePattern4_1();
				_user_pattern[_game_total_index] = 1;
			}
			
			if(_game_total_index > 0)
			{
				if(_bmp_state)	removeChild(_bmp_state);
								
				if(_user_selection[_game_total_index-1])
				{
					_bmp_state = new O;
				}
				else
				{
					_bmp_state = new X;
				}
				_bmp_state.smoothing = true;   _bmp_state.alpha = 0;
				_bmp_state.x = Brain.Main.PageWidth/2 - _bmp_state.width/2;
				_bmp_state.y = 480 - _bmp_state.height/2;
				addChild(_bmp_state);
				FadeTween();
			}

			_user_level[_game_total_index] = _game_level;
			_user_is_addit[_game_total_index] = _is_additional_game ? 1: 0;
			_game_playing = true;
		}
		
		private var _effect:Sound;
		private function isError(e:IOErrorEvent):void
		{
			trace(e.errorID);
		}
		private function onSoundLoaded(e:Event):void
		{
			var localSound:Sound = e.target as Sound;
			localSound.play();
			if(_effect) _effect.removeEventListener(Event.COMPLETE, onSoundLoaded);
		}
		public function setPattern():void
		{
			if(_game_level == 1)
			{
				var i:int = 0;
				var count1:int = 0;
				var count2:int = 0;
				var count3:int = 0;
				while(true)
				{
					var dataOk:Boolean = false;
					
					var flag:int = rand(0, 3);		//0, 1, 2
					
					if(flag == 0)
					{
						if(count1 < GAME_LENGTH)
						{
							count1++;
							dataOk = true;
						}
					}
					else if(flag == 1)
					{
						if(count2 < GAME_LENGTH)
						{
							count2++;
							dataOk = true;
						}
					}
					else if(flag == 2)
					{
						if(count3 < GAME_LENGTH)
						{
							count3++;
							dataOk = true;
						}	
					}
					
					if(dataOk)
					{
						_game_pattern[i] = flag;
						i++;
					}
					if(i >= GAME_LENGTH*3)
						break;
				}
			}
			else if(_game_level == 2 || _game_level == 3)
			{
				i = 0;
				count1 = 0;
				count2 = 0;
				while(true)
				{
					dataOk = false;
					
					flag = rand(0, 2);		//0, 1
					
					if(flag == 0)
					{
						if(count1 < GAME_LENGTH)
						{
							count1++;
							dataOk = true;
						}
					}
					else if(flag == 1)
					{
						if(count2 < GAME_LENGTH)
						{
							count2++;
							dataOk = true;
						}
					}
					
					if(dataOk)
					{
						_game_pattern[i] = flag;
						i++;
					}
					if(i >= GAME_LENGTH*2)
						break;
				}
			}
			else if(_game_level == 4)
			{
				_game_pattern[0] = 0;
				if(!Brain.isTestGame) _game_pattern[1] = 0;
			}
		}
		public function mouseDown(e:MouseEvent):void
		{
			var mouse_x:Number = this.mouseY;
			var mouse_y:Number = this.mouseX;
			
			if(_btn_quit.y <= mouse_x && mouse_x <= _btn_quit.y+_btn_quit.height)
				if(_btn_quit.x <= mouse_y && mouse_y <= _btn_quit.x+_btn_quit.width)
					_quit_touched = true;
			
			if(_game_playing)
			{
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
		}
		private var _quit_touched:Boolean = false;
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
		private var isComplete:Boolean = false;
		public function GameOver():void
		{
			if(isComplete)	return;
			isComplete = true;
			
			if(_bmp_state)	removeChild(_bmp_state);
			
			if(_user_selection[_game_total_index-1])
			{
				_bmp_state = new O;
			}
			else
			{
				_bmp_state = new X;
			}
			_bmp_state.smoothing = true;   _bmp_state.alpha = 0;
			_bmp_state.x = Brain.Main.PageWidth/2 - _bmp_state.width/2;
			_bmp_state.y = 480 - _bmp_state.height/2;
			addChild(_bmp_state);
			FadeTween();
			
			if((!(Brain.isTestGame)) && Brain.UserInfo.child_seq != -1)
			{
				//데이터 종합, 서버연동
				var params:URLVariables = new URLVariables;
	//			input 
	//			1. user_seq : 사용자번호
	//			2. child_seq : 아이번호
	//			3. test_id : 테스트 ID - 001로 셋팅 (임시)
	//			4. test_level : 난이도 
	//			5. test_pattern : 패턴 
	//			6. test_type : 정답유무 
	//			7. test_rebirth : 패자부활유무
	//			8. test_timeout : 제한시간지났는지유무
				params.user_seq = Brain.UserInfo.user_seq;
				params.child_seq = Brain.UserInfo.child_seq;
				params.test_id = "002";
				params.test_level = "";
				params.test_pattern = "";
				params.test_type = "";
				params.test_rebirth = "";
				//나중에 없어짐.
				for(var i:int = 0; i < _game_total_index; i++)
				{
					params.test_level = params.test_level + _user_level[i] + "%";
					params.test_pattern = params.test_pattern + _user_pattern[i] + "%";
					params.test_type = params.test_type + _user_selection[i] + "%";
					params.test_rebirth = params.test_rebirth + _user_is_addit[i] + "%";
				}
				
				Brain.Connection.post("cognitiveGameAction2.cog", params, onLoadComplete);
			}
			else
				Brain.Main.setPage("brainGameResultPage");
		}
		private function onLoadComplete(data:String):void
		{	
			if(data)
			{
				var result:Object = JSON.parse(data);
				
				//				output
				//				1. j_user_seq : 사용자번호
				//				2. j_child_seq : 아이번호
				//				3. j_regYn : 등록유무
				if(result.j_errorMsg.length>0)
				{
					new Alert(result.j_errorMsg).show();
				}
				if(result.j_regYn == "N")
					new Alert("데이터 등록 실패.").show();
				
				var cnt:int = 0;
				for(var i:int = 0; i < _game_total_index; i++)
				{
					if(_user_selection[i] == "1")
						cnt++
				}
				result.j_gameResultModelO.index1 = String(cnt)+"/"+String(_game_total_index);
				
				var intIndex2:Number = ((cnt)/(_game_total_index)) * 100 ;
				result.j_gameResultModelO.index2 = intIndex2.toFixed(2) +"%";
				
				//result.j_gameResultModelO.index2 = String((cnt)/(_game_total_index))+"%";
				Brain.Main.setPage("brainGameResultPage", result.j_gameResultModelO, BrainPageEffect.LEFT, BrainPageEffect.LEFT);
				
				return;
			}
			
			new Alert("데이터 저장 실패.").show();
		}
		public function mouseUp(e:MouseEvent):void
		{
			var mouse_x:Number = this.mouseY;
			var mouse_y:Number = this.mouseX;
			
			if(_quit_touched)
			{
				_quit_touched = false;
				return;
			}
			
			if(_game_playing)
			{
				if(!_is_answer_mode)
				{
					changeMode();
				}
				else
				{
					
				}
			}
			
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
		public function changeMode():void		//정답 입력으로 모드를 바꿈.
		{
			for(var i:int = 0; i < _bmp_food.length; i++)
				removeChild(_bmp_food[i]);
			_bmp_food = null;
			_bmp_food = new Vector.<Bitmap>;
			
			removeChild(_bg);
			_bg = new BG2; _bg.smoothing = true; _bg.x = 0; _bg.y = 0; addChild(_bg);
			
			removeChild(_btn_quit);
			var bmp:Bitmap   = new BUTTON_QUIT;    bmp.smoothing    = true;
			var bmp_on:Bitmap = new BUTTON_QUIT; bmp_on.smoothing = true; bmp_on.alpha = 0.6;
			_btn_quit = new TabbedButton(bmp, bmp_on, bmp_on); _btn_quit.x = 486; _btn_quit.y =  Brain.Main.PageHeight-18-_btn_quit.height;
			_btn_quit.addEventListener(MouseEvent.CLICK, quitClicked); addChild(_btn_quit);
			
			_is_answer_mode = true;
			DrawMiniPattern();
			
			if(_btn_next) removeChild(_btn_next);
			bmp   = new BUTTON_NEXT;    bmp.smoothing    = true;
			bmp_on = new BUTTON_NEXT; bmp_on.smoothing = true; bmp_on.alpha = 0.6;
			_btn_next = new TabbedButton(bmp, bmp_on, bmp_on); _btn_next.x = 40; _btn_next.y =  Brain.Main.PageHeight-18-_btn_next.height;
			_btn_next.addEventListener(MouseEvent.CLICK, nextClicked); addChild(_btn_next);
		}
		private function nextClicked(e:MouseEvent):void
		{
			var mouse_x:Number = this.mouseY;
			var mouse_y:Number = this.mouseX;
			
			//정답검사,기록
			_user_selection[_game_total_index] = (_answer == _user_answer) ? 1 : 0;
			
			_effect = new Sound();
			_effect.addEventListener(IOErrorEvent.IO_ERROR, isError);
			_effect.addEventListener(Event.COMPLETE, onSoundLoaded);
			
			if(_user_selection[_game_total_index])
				_effect.load(new URLRequest("sound/correct.mp3"));
			else
				_effect.load(new URLRequest("sound/wrong.mp3"));
			
			if(_user_selection[_game_total_index])
			{
				if(_is_additional_game)
					_user_add_correct_cnt++;
				else
					_user_correct_cnt++;
			}
			
			if(_game_pattern[_game_index+1] == null)
			{
				if(_user_correct_cnt >= (_game_index+1)*GAME_ACCUR)
				{
					if(_game_level == 4)
						GameOver();
					else
						toNextLevel();
				}
				else
				{
					if(!_is_additional_game)
					{
						_is_additional_game = true;
						if(_game_level == 4)
							_game_pattern[_game_index+1] = 0;
						else
						{
							var random:int = rand(0, 2);
							_game_pattern[_game_index+1] = random ? 1 : 0;
							_game_pattern[_game_index+2] = !random ? 1 : 0;
							if(_game_level == 1)
								_game_pattern[_game_index+3] = 2;
						}
						endGame();
					}
					else
					{
						if(_game_level == 4)
							GameOver();
						else
						{
							var minus:int = 0;
							if(_game_level == 1)	minus = 6;
							else if(_game_level == 2)	minus = 4;
							else if(_game_level == 3)	minus = 4;
							
							if(_user_add_correct_cnt >= (_game_index-minus+1)*GAME_ACCUR)
								toNextLevel();
							else
								GameOver();
						}
					}
				}
			}
			else
			{
				endGame();
			}
		}
		public function endGame():void
		{	
			removeChild(_bg);
			_bg = new BG; _bg.smoothing = true; _bg.x = 0; _bg.y = 0; addChild(_bg);
			
			_btn_next.removeEventListener(MouseEvent.CLICK, nextClicked);
			removeChild(_btn_quit);
			var bmp:Bitmap   = new BUTTON_QUIT;    bmp.smoothing    = true;
			var bmp_on:Bitmap = new BUTTON_QUIT; bmp_on.smoothing = true; bmp_on.alpha = 0.6;
			_btn_quit = new TabbedButton(bmp, bmp_on, bmp_on); _btn_quit.x = 486; _btn_quit.y =  Brain.Main.PageHeight-18-_btn_quit.height;
			_btn_quit.addEventListener(MouseEvent.CLICK, quitClicked); addChild(_btn_quit);
			
			_is_answer_mode = false;
			
			_game_index++;				//게임 인덱스 다음번으로 넘김.
			_game_total_index++;				//게임 인덱스 다음번으로 넘김.
			
			for(var i:int = 0; i < _bmp_food.length; i++)
				removeChild(_bmp_food[i]);
			_bmp_food = null;
			_bmp_food = new Vector.<Bitmap>;
			
			for(i = 0; i < _bmp_answ_food.length; i++)
				if(_bmp_answ_food[i] != null)
					removeChild(_bmp_answ_food[i]);
			_bmp_answ_food = null;
			_bmp_answ_food = new Vector.<Bitmap>(8, false);

			_sel_food = 0;
			_user_answer = "00000000";
			
			_answer = null;
			
			_game_start = true;
			
			_game_playing = false;
		}
		
		public function toNextLevel():void
		{	
			_game_level++;
			_game_pattern = null;
			_game_pattern = new Object;
			setPattern();
			
			removeChild(_bg);
			_bg = new BG; _bg.smoothing = true; _bg.x = 0; _bg.y = 0; addChild(_bg);
			
			_btn_next.removeEventListener(MouseEvent.CLICK, nextClicked);
			removeChild(_btn_quit);
			var bmp:Bitmap   = new BUTTON_QUIT;    bmp.smoothing    = true;
			var bmp_on:Bitmap = new BUTTON_QUIT; bmp_on.smoothing = true; bmp_on.alpha = 0.6;
			_btn_quit = new TabbedButton(bmp, bmp_on, bmp_on); _btn_quit.x = 486; _btn_quit.y =  Brain.Main.PageHeight-18-_btn_quit.height;
			_btn_quit.addEventListener(MouseEvent.CLICK, quitClicked); addChild(_btn_quit);
					
			_is_answer_mode = false;
			_is_additional_game = false;
			_game_index = 0;				//게임 인덱스 초기화
			_game_total_index++;				//게임 인덱스 다음번으로 넘김.
			_user_correct_cnt = 0;
			_user_add_correct_cnt = 0;
			
			for(var i:int = 0; i < _bmp_food.length; i++)
				removeChild(_bmp_food[i]);
			_bmp_food = null;
			_bmp_food = new Vector.<Bitmap>;
			
			for(i = 0; i < _bmp_answ_food.length; i++)
				if(_bmp_answ_food[i] != null)
					removeChild(_bmp_answ_food[i]);
			_bmp_answ_food = null;
			_bmp_answ_food = new Vector.<Bitmap>(8, false);

			
			_sel_food = 0;
			_user_answer = "00000000";
			
			_answer = null;
			
			_game_start = true;
			
			_game_playing = false;
		}
		
		//1 - 390, 302   2 - 390, 719	3 - 140, 302
		private var _prev_start_place:int = -1;
		public function GamePattern1_1():String
		{
			var start_place:int = rand(0, 8);
			if(!_is_answer_mode)
				_prev_start_place = start_place
			
			var index:int = 0;
			for(var i:int = 0; i < 3; i++)
			{
				for(var j:int = 0; j < i+1; j++)
				{
					if(_is_answer_mode)
						var bmp:Bitmap = new TINY_PIZZA;
					else
						bmp = new SMALL_PIZZA;
					bmp.smoothing = true;
					bmp.rotation = 45*(start_place+j);
					if(_is_answer_mode)
						bmp.rotation = 45*(_prev_start_place+j);
					//bmp.alpha = 0;
					
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
			}
			
			//alphaTween();
			
			var answer:String;
			
			switch(start_place)
			{
				case 0:		answer = "11110000";	break;
				case 1:		answer = "01111000";	break;
				case 2:		answer = "00111100";	break;
				case 3:		answer = "00011110";	break;
				case 4:		answer = "00001111";	break;
				case 5:		answer = "10000111";	break;
				case 6:		answer = "11000011";	break;
				case 7:		answer = "11100001";	break;
			}
			
			return answer;
		}
		public function GamePattern1_2():String
		{
			var start_place:int = rand(0, 8);
			if(!_is_answer_mode)
				_prev_start_place = start_place
			
			var index:int = 0;
			for(var i:int = 0; i < 3; i++)
			{
				if(_is_answer_mode)
					var bmp:Bitmap = new TINY_PIZZA;
				else
					bmp = new SMALL_PIZZA;
				if(_is_answer_mode)
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
		private var _prev_start_food:int;
		public function GamePattern1_3():String
		{
			var start_place:int = rand(0, 8);
			var start_food:int = rand(1, 3);	//1 - 피자 2 - 케이크
			if(!_is_answer_mode)
			{
				_prev_start_place = start_place
				_prev_start_food = start_food;
			}
			
			var index:int = 0;
			for(var i:int = 0; i < 3; i++)
			{
				if(_is_answer_mode)
				{
					if((_prev_start_food + i)%2 == 1)
						var bmp:Bitmap = new TINY_PIZZA;
					else
						bmp = new TINY_CAKE;
				}
				else
				{
					if((start_food + i)%2 == 1)
						bmp = new SMALL_PIZZA;
					else
						bmp = new SMALL_CAKE;
				}
				
				bmp.smoothing = true;
				bmp.rotation = 45*start_place;
				if(_is_answer_mode)
					bmp.rotation = 45*(_prev_start_place);
				
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
			
			var answer:String = "00000000";
			var food:String = (start_food-1) ? "1" : "2";
			
			answer = answer.substr(0, start_place) + food + answer.substr(start_place+1, 8);
			
			return answer;
		}
		public function GamePattern2_1():String
		{
			var start_place:int = rand(0, 8);
			var start_food:int = rand(1, 3);	//1 - 피자 2 - 케이크
			if(!_is_answer_mode)
			{
				_prev_start_place = start_place
				_prev_start_food = start_food;
			}
			
			var index:int = 0;
			for(var i:int = 0; i < 3; i++)
			{
				
				if(_is_answer_mode)
				{
					if((_prev_start_food + i)%2 == 1)
						var bmp:Bitmap = new TINY_PIZZA;
					else
						bmp = new TINY_CAKE;
				}
				else
				{
					if((start_food + i)%2 == 1)
						bmp = new SMALL_PIZZA;
					else
						bmp = new SMALL_CAKE;
				}
				
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
			
			var answer:String = "00000000";
			var food:String = (start_food-1) ? "1" : "2";
			
			if(start_place <= 4)
				answer = answer.substr(0, start_place+3) + food + answer.substr(start_place+4, 8);
			else
				answer = answer.substr(0, start_place-5) + food + answer.substr(start_place-4, 8);
			
			return answer;
		}

		public function GamePattern2_2():String
		{
			var start_place:int = rand(0, 8);
			var start_food:int = rand(1, 3);	//1 - 피자 2 - 케이크
			var not_start_food:int = (start_food-1) ? 1 : 2;
			if(!_is_answer_mode)
			{
				_prev_start_place = start_place
				_prev_start_food = start_food;
			}

			
			var index:int = 0;
			for(var i:int = 0; i < 3; i++)
			{
				for(var j:int = 0; j < i+1; j++)
				{
					var bmp:Bitmap;
					// j%2 0 - 시작 1 - 시작아님
					// start_food-1 0 - 피자 1 - 케이크
					// j - 0, 01, 012
					
					if(!_is_answer_mode)
					{
						if(j%2 == 0)	//시작인거
							(start_food-1) ? (bmp = new SMALL_CAKE) : (bmp = new SMALL_PIZZA);
						else			//시작아닌거
							(start_food-1) ? (bmp = new SMALL_PIZZA) : (bmp = new SMALL_CAKE);
					}
					else
					{
						if(j%2 == 0)	//시작인거
							(_prev_start_food-1) ? (bmp = new TINY_CAKE) : (bmp = new TINY_PIZZA);
						else			//시작아닌거
							(_prev_start_food-1) ? (bmp = new TINY_PIZZA) : (bmp = new TINY_CAKE);
					}
					
					bmp.smoothing = true;
					bmp.rotation = 45*(start_place+j);
					if(_is_answer_mode)
						bmp.rotation = 45*(_prev_start_place+j);
					
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
			}
			
			var answer:String = "00000000";
			var food:String;
			
			for(i = 0; i < 4; i++)
			{
				food = (i%2) ? String(not_start_food) : String(start_food);
				
				answer = answer.substr(0, start_place+i) + food + answer.substr(start_place+i+1, 8);
			}
			var tempString:String = answer.substr(8, answer.length);
			answer = tempString + answer.substr(tempString.length, 8-tempString.length);
			
			return answer;
		}
		public function GamePattern3_1():String
		{
			var start_place:int = rand(0, 8);
			if(!_is_answer_mode)
				_prev_start_place = start_place;
					
			var index:int = 0;
			for(var i:int = 0; i < 3; i++)
			{
				for(var j:int = 0; j < i+1; j++)
				{
					if(_is_answer_mode)
						var bmp:Bitmap = new TINY_PIZZA;
					else
						bmp = new SMALL_PIZZA;
					bmp.smoothing = true;
					bmp.rotation = 45*(start_place+index);
					if(_is_answer_mode)
						bmp.rotation = 45*(_prev_start_place+index);
					
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
			}
			
			var answer:String = "00000000";
			var answer_start_place:int = start_place+6;
			if(answer_start_place > 7)
				answer_start_place -= 8;
			
			for(i = 0; i < 4; i++)
			{	
				answer = answer.substr(0, answer_start_place+i) + "1" + answer.substr(answer_start_place+i+1, 8);
			}
			var tempString:String = answer.substr(8, answer.length);
			answer = tempString + answer.substr(tempString.length, 8-tempString.length);
			
			return answer;
		}
		public function GamePattern3_2():String
		{
			var start_place:int = rand(0, 8);
			if(!_is_answer_mode)
				_prev_start_place = start_place;
			
			var index:int = 0;
			for(var i:int = 0; i < 3; i++)
			{
				for(var j:int = 0; j < i+1; j++)
				{
					if(_is_answer_mode)
						var bmp:Bitmap = new TINY_PIZZA;
					else
						bmp = new SMALL_PIZZA;
					bmp.smoothing = true;
					bmp.rotation = 45*(start_place+j*2);
					if(_is_answer_mode)
						bmp.rotation = 45*(_prev_start_place+j*2);
					
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
			}
			
			var answer:String;
			
			if(start_place%2 == 0)
				answer = "10101010";
			else
				answer = "01010101";
			
			return answer;
		}
		public function GamePattern4_1():String
		{
			var start_place:int = rand(0, 8);
			var start_food:int = rand(1, 3);	//1 - 피자 2 - 케이크
			if(!_is_answer_mode)
			{
				_prev_start_place = start_place
				_prev_start_food = start_food;
			}
			
			var index:int = 0;
			for(var i:int = 0; i < 3; i++)
			{
				for(var j:int = 0; j < i+1; j++)
				{
					if((_prev_start_food + i)%2 == 1)
					{
						if(_is_answer_mode)
							var bmp:Bitmap = new TINY_PIZZA;
						else
							bmp = new SMALL_PIZZA;
					}
					else
					{
						if(_is_answer_mode)
							bmp = new TINY_CAKE;
						else
							bmp = new SMALL_CAKE;
					}
					bmp.smoothing = true;
					bmp.rotation = 45*(start_place+index);
					if(_is_answer_mode)
						bmp.rotation = 45*(_prev_start_place+index);
					
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
			}
			
			var answer:String = "00000000";
			var food:String = (start_food-1) ? "1" : "2";
			var answer_start_place:int = start_place+6;
			if(answer_start_place > 7)
				answer_start_place -= 8;
			
			for(i = 0; i < 4; i++)
			{	
				answer = answer.substr(0, answer_start_place+i) + food + answer.substr(answer_start_place+i+1, 8);
			}
			var tempString:String = answer.substr(8, answer.length);
			answer = tempString + answer.substr(tempString.length, 8-tempString.length);
			
			return answer;
		}
		public function DrawMiniPattern():void
		{
			if(_game_level == 1)
			{
				switch(_game_pattern[_game_index])
				{
					case 0:		GamePattern1_1();	break;
					case 1:		GamePattern1_2();	break;
					case 2:		GamePattern1_3();	break;
				}
			}
			else if(_game_level == 2)
			{
				switch(_game_pattern[_game_index])
				{
					case 0:		GamePattern2_1();	break;
					case 1:		GamePattern2_2();	break;
				}
			}
			else if(_game_level == 3)
			{
				switch(_game_pattern[_game_index])
				{
					case 0:		GamePattern3_1();	break;
					case 1:		GamePattern3_2();	break;
				}
			}
			else if(_game_level == 4)
			{
				GamePattern4_1();
			}
		}
		public function alphaTween():void
		{
			_tween_alpha = new Tween(_bmp_food[_tween_index].alpha, 1, 0, 200, function(value:Number,isFinish:Boolean):void
			{	
				_bmp_food[_tween_index].alpha += value;
				if(isFinish)
				{
					_tween_index++;
					alphaTween();
				}
			});
		}
		public function FadeTween():void
		{
			_tween_alpha = new Tween(_bmp_state.alpha, 1, 0, FADE_IN, function(value:Number,isFinish:Boolean):void
			{	
				_bmp_state.alpha = value;
				if(isFinish)
				{
					_tween_alpha = new Tween(_bmp_state.alpha, 0, 0, FADE_OUT, function(value:Number,isFinish:Boolean):void
					{	
						_bmp_state.alpha = value;
					});
				}
			});
		}
		public function rand(min:int, max:int):int
		{
			return min + (max - min) * Math.random();
		}
		public override function onResize():void
		{
		}
		public override function dispose():void
		{
			//if(_effect) _effect.removeEventListener(Event.COMPLETE, onSoundLoaded);
		}
	}
}
