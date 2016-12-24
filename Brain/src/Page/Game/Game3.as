package Page.Game
{	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapEncodingColorSpace;
	import flash.display.DisplayObject;
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
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.html.script.Package;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.text.AntiAliasType;
	import flash.text.ReturnKeyLabel;
	import flash.text.SoftKeyboardType;
	import flash.text.StageText;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import Page.BasePage;
	
	import Popup.CancelGamePopup;
	import Popup.Game3Popup;
	import Popup.TestPopup;
	
	import kr.pe.hs.tween.Tween;
	import kr.pe.hs.ui.TabbedButton;
	
	public class Game3 extends BasePage
	{	
		//게임 데이터 상수값.
		private var GAME_LENGTH:Number = 10;				//게임 횟수
		private var ADDITIONAL_GAME_LENGTH:Number = 5;		//추가 수행 횟수
		private var GAME_ACCUR:Number = 0.8;				//게임 성공률 기준
		
		private static const FADE_IN:Number = 300;
		private static const FADE_OUT:Number = 300;
		private static const GAME_DELAY:Number = 800;
		
		[Embed(source = "assets/page/game/game3/bg.png")]
		private static const BG:Class;
		
		[Embed(source = "assets/page/game/game3/point.png")]
		private static const POINT:Class;
		private var _bmp_point:Bitmap;
		private var _blink_timer:Timer;
		
		[Embed(source = "assets/page/game/game3/banana.png")]
		private static const BANANA:Class;
		[Embed(source = "assets/page/game/game3/grape.png")]
		private static const GRAPE:Class;
		[Embed(source = "assets/page/game/game3/strawberry.png")]
		private static const STRAWBERRY:Class;
		[Embed(source = "assets/page/game/game3/watermelon.png")]
		private static const WATERMELON:Class;
		[Embed(source = "assets/page/game/game3/banana_2.png")]
		private static const BANANA_2:Class;
		[Embed(source = "assets/page/game/game3/grape_2.png")]
		private static const GRAPE_2:Class;
		[Embed(source = "assets/page/game/game3/strawberry_2.png")]
		private static const STRAWBERRY_2:Class;
		[Embed(source = "assets/page/game/game3/watermelon_2.png")]
		private static const WATERMELON_2:Class;
		private var _bmp_fruit:Bitmap;
		private var _bmp_left_fruit:Bitmap;
		private var _bmp_right_fruit:Bitmap;
		
		private var _game_start:Boolean;
		
		private var _game_level:int = 1;	//난이도 - 1,2
		
		private var _end_game_id:uint;		//타이머 삭제용.
		
		//이건 래밸 1용
		private var _prev_fruit:int = 0;	//이전 과일... 0 - 없음 1 - 원래바나나 2 - 원래포도 3 - 원래딸기 4 - 원래수박 5 - 이상바나나 6 - 이상포도 7 - 이상딸기 8 - 이상수
		private var _curr_fruit:int = 0;	//이번 과일... 0 - 없음 1 - 원래바나나 2 - 원래포도 3 - 원래딸기 4 - 원래수박 5 - 이상바나나 6 - 이상포도 7 - 이상딸기 8 - 이상수
		
		//이건 래밸 2용
		private var _prev_left_fruit:int = 0;	//이전 과일... 0 - 없음 1 - 원래바나나 2 - 원래포도 3 - 원래딸기 4 - 원래수박 5 - 이상바나나 6 - 이상포도 7 - 이상딸기 8 - 이상수
		private var _prev_right_fruit:int = 0;	//이전 과일... 0 - 없음 1 - 원래바나나 2 - 원래포도 3 - 원래딸기 4 - 원래수박 5 - 이상바나나 6 - 이상포도 7 - 이상딸기 8 - 이상수
		private var _curr_left_fruit:int = 0;	//이번 과일... 0 - 없음 1 - 원래바나나 2 - 원래포도 3 - 원래딸기 4 - 원래수박 5 - 이상바나나 6 - 이상포도 7 - 이상딸기 8 - 이상수
		private var _curr_right_fruit:int = 0;	//이번 과일... 0 - 없음 1 - 원래바나나 2 - 원래포도 3 - 원래딸기 4 - 원래수박 5 - 이상바나나 6 - 이상포도 7 - 이상딸기 8 - 이상수
		
		private var _is_timeout:Boolean = false;	//시간초과로 끝났는지.
		
		private var _game_index:int = 0;	//몇 번째 게임인지 인덱스. 0에서 시작해서 게임 끝날때 증가함.
		private var _total_game_index:int = 0;	//몇 번째 게임인지 인덱스. 0에서 시작해서 게임 끝날때 증가함.
		
		private var _game_order:Object;	//게임 패턴이 나오는 순서를 정의함.
		
		private var _user_selection:Object;	//0 - 미응답 1 - 정답 2 - 오답.
		private var _user_is_addit:Object;	//추가수행인지 0 - 아님 1 - 맞음.
		private var _user_pattern:Object;	//무슨패턴인지
		private var _user_level:Object;		//래밸
		
		private var _user_correct_cnt:int = 0;	//유저 정답 갯수.
		private var _is_additional_game:Boolean = false;	//추가수행게임인지.
		private var _did_get_level_down:Boolean = false;	//레밸이 내려갔었는지.
		
		private var _leftover_game:int;	//게임 몇 회 남았는지.
		
		private var _is_infinite_game:Boolean = false;	//계속하는 게임인지(난이도 1 - 
		
		//private var _game_pattern
		
		[Embed(source = "assets/page/game/index/button_quit.png")]
		private static const BUTTON_QUIT:Class;
		private var _btn_quit:TabbedButton;
		
		//private var _timeout_id:uint;
		
		
		private var _tween_alpha:Tween;		
		
		[Embed(source = "assets/page/game/index/O.png")]
		private static const O:Class;
		[Embed(source = "assets/page/game/index/X.png")]
		private static const X:Class;
		private var _bmp_state:Bitmap;
		
		[Embed(source = "assets/page/game/game3/time_bg.png")]
		private static const TIME_BG:Class;
		private var _time:TextField;
		[Embed(source = "assets/page/game/game3/process_bg.png")]
		private static const PROCESS_BG:Class;
		private var _process:TextField;
		
		[Embed(source = "assets/page/game/game3/yes.png")]
		private static const YES:Class;
		private var _button_yes:TabbedButton;
		[Embed(source = "assets/page/game/game3/no.png")]
		private static const NO:Class;
		private var _button_no:TabbedButton;
		
		private var _tick_time:Timer;

		public function Game3()
		{
			super();
			
			if(Brain.isTestGame)
			{
				GAME_LENGTH = 2;				//게임 횟수
				ADDITIONAL_GAME_LENGTH = 0;		//추가 수행 횟수
				GAME_ACCUR = 1.1;				//게임 성공률 기준
			}
			
			_leftover_game = GAME_LENGTH;
			Brain.Main.TopMenuVisible = false;
			
			//bg
			var bmp:Bitmap = new BG; bmp.smoothing = true; addChild(bmp);
			bmp = new TIME_BG; bmp.smoothing = true; bmp.x = 437; bmp.y = 83; bmp.name = "time_bg"; addChild(bmp);
			_time = new TextField;
			_time.width = bmp.height; _time.height = 24*1.3;
			_time.x = bmp.x+bmp.width/2+15; _time.y = bmp.y+15;
			var fmt:TextFormat = _time.defaultTextFormat; fmt.color = 0xffffff; fmt.font="Main"; fmt.size = 24; fmt.align = "center";
			_time.defaultTextFormat = fmt;
			_time.embedFonts = true;
			_time.antiAliasType = AntiAliasType.ADVANCED;
			_time.rotation = 90;
			_time.text = "1 : 00";
			addChild(_time);
			
			bmp = new PROCESS_BG; bmp.smoothing = true; bmp.x = 485; bmp.y = 367; bmp.name = "process_bg"; addChild(bmp);
			_process = new TextField;
			_process.width = bmp.height; _process.height = 22*1.3;
			_process.x = bmp.x+bmp.width-_process.height/2; _process.y = bmp.y;
			fmt = _process.defaultTextFormat; fmt.color = 0xffffff; fmt.font="Main"; fmt.size = 22; fmt.align = "center";
			_process.defaultTextFormat = fmt;
			_process.embedFonts = true;
			_process.antiAliasType = AntiAliasType.ADVANCED;
			_process.text = "0회 진행 중";
			_process.rotation = 90;
			addChild(_process);
			
			bmp = new BUTTON_QUIT;    bmp.smoothing    = true;
			var bmp_on:Bitmap = new BUTTON_QUIT; bmp_on.smoothing = true; bmp_on.alpha = 0.6;
			_btn_quit = new TabbedButton(bmp, bmp_on, bmp_on); _btn_quit.x = 486; _btn_quit.y =  Brain.Main.PageHeight-18-_btn_quit.height;
			addChild(_btn_quit);
			
			bmp = new YES;    bmp.smoothing    = true;
			bmp_on = new YES; bmp_on.smoothing = true; bmp_on.alpha = 0.6;
			_button_yes = new TabbedButton(bmp, bmp_on, bmp_on); _button_yes.x = 19; _button_yes.y = 80;
			_button_yes.visible = false;
			_button_yes.addEventListener(MouseEvent.CLICK, mouseDown); addChild(_button_yes);

			bmp = new NO;    bmp.smoothing    = true;
			bmp_on = new NO; bmp_on.smoothing = true; bmp_on.alpha = 0.6;
			_button_no = new TabbedButton(bmp, bmp_on, bmp_on); _button_no.x = 19; _button_no.y = 680;
			_button_no.visible = false;
			_button_no.addEventListener(MouseEvent.CLICK, mouseDown); addChild(_button_no);
			
			setTimeout(wait, 500);
		}
		private function wait():void
		{
			Brain.Main.showPopup(new Game3Popup(InitDatas));
		}
		private var _isPopupOn:Boolean = false;		//이거 60초동안 팝업 켜놓으면 꺼질거임. 버그있음.
		public function quitClicked(e:MouseEvent):void
		{
			//팝업
			if(!_isDelay && _start_timer)
			{
				Brain.Main.showPopup(new CancelGamePopup(popupClicked));
				_remainTimer.stop();
				
				clearTimeout(_end_game_id);
			}
		}
		private function popupClicked(value:Boolean):void
		{
			if(value)
				Brain.Main.setPage("brainGameIndexPage", null, BrainPageEffect.RIGHT, BrainPageEffect.RIGHT);
			Brain.Main.closePopup();
			
			if(_prev_fruit || _prev_left_fruit)
			{
				if(5000-_tick_time.currentCount > 0) 
					_end_game_id = setTimeout(endGame, 5000-_tick_time.currentCount);
			}
			else
			{
				if(1000-_tick_time.currentCount > 0) 
					_end_game_id = setTimeout(endGame, 1000-_tick_time.currentCount);
			}
			
			_remainTimer.start();
		}
		private function InitDatas():void
		{
			//point
			_bmp_point = new POINT; _bmp_point.smoothing = true;
			_bmp_point.x = Brain.Main.PageWidth/2 - _bmp_point.width/2;
			_bmp_point.y = 480 - _bmp_point.height/2;
			addChild(_bmp_point);
			
			//game not started
			_game_start = false;
			
			//eventListner add
			addEventListener(MouseEvent.CLICK, mouseDown);
			addEventListener(Event.ENTER_FRAME, EnterFrame);
			
			//user datas init
			_user_selection = new Object;
			_user_is_addit = new Object;
			_user_pattern = new Object;
			_user_level = new Object;
			
			//game order init
			_game_order = new Object;
			makeGameOrder(0, GAME_LENGTH);
		}
		public function startTimer():void
		{
			_blink_timer.removeEventListener(TimerEvent.TIMER, blinkTimer);
			_btn_quit.addEventListener(MouseEvent.CLICK, quitClicked);
			removeChild(_bmp_point);
			
			//_remainTime=60;
			//_remainTimeTick=getTimer();
			_remainTimer=new Timer(1000, 60);
			_remainTimer.addEventListener(TimerEvent.TIMER,remainTimer_onTick);
			_remainTimer.start();
			
			_start_timer = true;
			_game_start = true;
		}
		private var _remainTimer:Timer;
		//private var _remainTime:Number;
		//private var _remainTimeTick:Number;
		private function remainTimer_onTick(e:TimerEvent):void
		{
			printRemainTime();
		}
		private function printRemainTime():void
		{
			var time:int = 60-_remainTimer.currentCount;
			
			if(time <= 0)
				time = 0;
			if(!time)
			{
				gameOverWithTimeout();
				_remainTimer.removeEventListener(TimerEvent.TIMER, remainTimer_onTick);
			}
			
			var sec:int = (time%60);
			var min:int = (time/60);
			
			var result:String="";
			
			result+=min;
			result+=" : ";
			if(sec<10) result+="0";
			result+=sec;
			
			_time.text=result;
		}
		public function makeGameOrder(start_index:int, game_length:int):void
		{
//			if(_game_level == 1)	//난이도가 1이면.
//			{
				//난이도 1일때는 맞는거 5개 틀린거 5개.(GAME_LENGTH/2)
				
				var correctCnt:int = 0;
				var incorrectCnt:int = 0;
				var i:int = start_index;
				
				if(game_length%2)	//게임 길이가 홀수면
				{
					_game_order[start_index] = rand(0, 2);		//랜덤으로 하나 넣어주고
					i++;	///i가 start_index+1부터 시작.
					if(i >= game_length + start_index)
						return;
				}
				while(true)
				{
					var dataOk:Boolean = false;
					
					var flag:int = rand(0, 2);		//	0, 1 맞는거 틀린거.
					
					if(flag){
						if(correctCnt < game_length/2){
							correctCnt++;
							dataOk = true;
					}}
					else{
						if(incorrectCnt < game_length/2){
							incorrectCnt++; 
							dataOk = true;
					}}
					
					if(dataOk)
					{
						_game_order[i] = flag;
						i++;
					}
					if(i >= game_length + start_index)
						break;
				}
//			}
//			else if(_game_level == 2)	//난이도 2이면.
//			{
//			}
		}
		public function gameOverWithTimeout():void
		{
			//게임 시간 초과로 종료시 호출되는 메소드.
			_is_timeout = true;
			gameOver();
		}
		private var isComplete:Boolean = false;
		public function gameOver():void
		{
			if(isComplete)	return;
			isComplete = true;
			//게임 종료 메소드.
			
			_game_start = false;
			if(!Brain.isTestGame && Brain.UserInfo.child_seq != -1)
			{
				var params:URLVariables = new URLVariables;
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
				params.test_id = "003";
				params.test_level = "";
				params.test_pattern = "";
				params.test_type = "";
				params.test_rebirth = "";
				params.test_timeout = _is_timeout ? 1 : 0;
				for(var i:int = 0; i < _total_game_index; i++)
				{
					params.test_level = params.test_level + _user_level[i] + "%";
					params.test_pattern = params.test_pattern + _user_pattern[i] + "%";
					params.test_type = params.test_type + _user_selection[i] + "%";
					params.test_rebirth = params.test_rebirth + _user_is_addit[i] + "%";
				}
				
				Brain.Connection.post("cognitiveGameAction3.cog", params, onLoadComplete);
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
				for(var i:int = 0; i < _total_game_index; i++)
				{
					if(_user_selection[i] == "1")
						cnt++
				}
				result.j_gameResultModelO.index1 = String(cnt)+"/"+String(_total_game_index);
				
				
				var intIndex2:Number = ((cnt)/(_total_game_index)) * 100 ;
				result.j_gameResultModelO.index2 = intIndex2.toFixed(2) +"%";
				
				//result.j_gameResultModelO.index2 = String((cnt)/(_total_game_index))+"%";
				Brain.Main.setPage("brainGameResultPage", result.j_gameResultModelO, BrainPageEffect.LEFT, BrainPageEffect.LEFT);
				
				return;
			}
			
			new Alert("데이터 저장 실패.").show();
		}
		public function EnterFrame(e:Event):void
		{
			if(!_blink_timer)
			{
				_blink_timer = new Timer(250, 4);
				_blink_timer.addEventListener(TimerEvent.TIMER, blinkTimer);
				_blink_timer.start();
				
				setTimeout(startTimer, 1000);
			}
			
			if(_game_start)
			{
				_game_start = false;
				gameMethod();
			}
		}
		
		public function gameMethod():void
		{	
			_button_yes.visible = (_prev_fruit || _prev_left_fruit) ? true : false;
			_button_no.visible = (_prev_fruit || _prev_left_fruit) ? true : false;
			
			_tick_time = new Timer(1);
			_tick_time.start();
			
			if(_is_infinite_game && !Brain.isTestGame)
			{
				_user_level[_total_game_index] = _game_level;
				
				if(_game_level == 1)
				{
					if(_prev_fruit)	//과일이 있었던 경우.(최초시작아니면.)
					{
						_end_game_id = setTimeout(endGame, 5000);		//아무입력 없이 5초 뒤면 게임 끝남.
					}
					else		//최초시작인 경우.
					{
						_end_game_id = setTimeout(endGame, 1000);		//1초간 과일 보여줌.
					}
					
					_user_is_addit[_total_game_index] = _is_additional_game ? 1 : 0;	//추가수행인지 아닌지 계속 기록
					_user_selection[_total_game_index] = 0;	//초기화를 미응답으로 해주고 선택시에 값을 바꾼다.
					_curr_fruit = addFruitLevel1();		//과일 이미지 띄우고 이전 과일 저장.
				}
				else if(_game_level == 2)
				{
					if(_prev_left_fruit)	//과일이 있었던 경우.(최초시작 x) 어차피 왼쪽 오른쪽 동시초기화니까 왼쪽만 검사함.
					{
						_end_game_id = setTimeout(endGame, 5000);		//아무입력 없이 5초 뒤면 게임 끝남.
					}
					else					//레벨2 최초시작인경우.
					{
						_end_game_id = setTimeout(endGame, 1000);;		//1초간 과일 보여줌.
					}
					
					_user_is_addit[_total_game_index] = _is_additional_game ? 1 : 0;	//추가수행인지 아닌지 계속 기록
					_user_selection[_total_game_index] = 0;	//초기화를 미응답으로 해주고 선택시에 값을 바꾼다.
					addFruitLevel2();
				}
				
				return;
			}
			
			if(_leftover_game)		//게임 남아있으면.
			{
				_user_level[_total_game_index] = _game_level;
				
				if(_game_level == 1)
				{
					if(_prev_fruit)	//과일이 있었던 경우.(최초시작아니면.)
					{
						_end_game_id = setTimeout(endGame, 5000);		//아무입력 없이 5초 뒤면 게임 끝남.
					}
					else		//최초시작인 경우.
					{
						_end_game_id = setTimeout(endGame, 1000);		//1초간 과일 보여줌.
					}
					
					_user_is_addit[_total_game_index] = _is_additional_game ? 1 : 0;	//추가수행인지 아닌지 계속 기록
					_user_selection[_total_game_index] = 0;	//초기화를 미응답으로 해주고 선택시에 값을 바꾼다.
					_curr_fruit = addFruitLevel1();		//과일 이미지 띄우고 이전 과일 저장.
				}
				else if(_game_level == 2)
				{
					if(_prev_left_fruit)	//과일이 있었던 경우.(최초시작 x) 어차피 왼쪽 오른쪽 동시초기화니까 왼쪽만 검사함.
					{
						_end_game_id = setTimeout(endGame, 5000);		//아무입력 없이 5초 뒤면 게임 끝남.
					}
					else					//레벨2 최초시작인경우.
					{
						_end_game_id = setTimeout(endGame, 1000);;		//1초간 과일 보여줌.
					}
					
					_user_is_addit[_total_game_index] = _is_additional_game ? 1 : 0;	//추가수행인지 아닌지 계속 기록
					_user_selection[_total_game_index] = 0;	//초기화를 미응답으로 해주고 선택시에 값을 바꾼다.
					addFruitLevel2();
				}
			}
			else					//남은 게임 없으면.
			{
				if(_game_level == 1)	//난이도 1
				{
					if(Brain.isTestGame)
					{
						if(_game_index >= GAME_LENGTH)
						{
							changeGameLevel(2);
							return;
						}
					}
					
					if(_is_additional_game)		//추가 게임이면.
					{
						if(!_did_get_level_down)		//레밸 안내려갔을 경우
						{
							if(_user_correct_cnt < ADDITIONAL_GAME_LENGTH*GAME_ACCUR)		//일정 퍼센테이지 미만으로 맞춘경우.
								gameOver();
							else
								changeGameLevel(2);	//난이도 2로 넘어감.
						}
						else
						{
							if(_user_correct_cnt < ADDITIONAL_GAME_LENGTH*GAME_ACCUR)		//일정 퍼센테이지 미만으로 맞춘경우.
							{
								_is_infinite_game = true;//게임 계속되게함.
								_game_start = true;
								makeGameOrder(_game_index, 1);
								
								//레밸 1
								_prev_fruit = 0;		//이전 과일... 0 - 없음 1 - 원래바나나 2 - 원래포도 3 - 원래딸기 4 - 원래수박
								_curr_fruit = 0;		//이전 과일... 0 - 없음 1 - 원래바나나 2 - 원래포도 3 - 원래딸기 4 - 원래수박
								
								//래밸 2
								_prev_left_fruit = 0;	//이전 과일... 0 - 없음 1 - 원래바나나 2 - 원래포도 3 - 원래딸기 4 - 원래수박
								_prev_right_fruit = 0;	//이전 과일... 0 - 없음 1 - 원래바나나 2 - 원래포도 3 - 원래딸기 4 - 원래수박
								_curr_left_fruit = 0;	//이번 과일... 0 - 없음 1 - 원래바나나 2 - 원래포도 3 - 원래딸기 4 - 원래수박
								_curr_right_fruit = 0;	//이번 과일... 0 - 없음 1 - 원래바나나 2 - 원래포도 3 - 원래딸기 4 - 원래수박
							}
							else
								changeGameLevel(2);	//난이도 2로 넘어감.
						}
					}
					else						//추가 게임 아니면.
					{
						if(_user_correct_cnt < GAME_LENGTH*GAME_ACCUR)		//일정 퍼센테이지 미만으로 맞춘경우.
						{
							_is_additional_game = true;		//추가게임이라고 해주고
							_leftover_game += ADDITIONAL_GAME_LENGTH;	//추가게임횟수만큼 남은 게임 더해준다.
							makeGameOrder(_game_index, ADDITIONAL_GAME_LENGTH);		//이 코드 제대로 되는지 모르겠음. 아무튼 게임 순서 만드는 코드임.
							_game_start = true;
						}
						else
							changeGameLevel(2);	//난이도 2로 넘어감.
					}
				}
				else if(_game_level == 2)
				{
					if(Brain.isTestGame)
					{
						if(_game_index >= GAME_LENGTH)
						{
							gameOver();
							return;
						}
					}
					if(!_is_additional_game)						//추가 게임 아니면.
					{
						if(_user_correct_cnt < GAME_LENGTH*GAME_ACCUR)		//일정 퍼센테이지 미만으로 맞춘경우.
						{
							_did_get_level_down = true;		//난이도 내려
							changeGameLevel(1);	//난이도 1로 내려감.
							_is_additional_game = true;		//추가게임이라고 해주고
							_leftover_game += ADDITIONAL_GAME_LENGTH;
							_game_order = null;
							_game_order = new Object;
							makeGameOrder(0, ADDITIONAL_GAME_LENGTH);		//이 코드 제대로 되는지 모르겠음. 아무튼 게임 순서 만드는 코드임.
						}
						else
						{
							_is_infinite_game = true; //게임 계속되게함.
							_game_start = true;
							makeGameOrder(_game_index, 1);
							
							//레밸 1
							_prev_fruit = 0;		//이전 과일... 0 - 없음 1 - 원래바나나 2 - 원래포도 3 - 원래딸기 4 - 원래수박
							_curr_fruit = 0;		//이전 과일... 0 - 없음 1 - 원래바나나 2 - 원래포도 3 - 원래딸기 4 - 원래수박
							
							//래밸 2
							_prev_left_fruit = 0;	//이전 과일... 0 - 없음 1 - 원래바나나 2 - 원래포도 3 - 원래딸기 4 - 원래수박
							_prev_right_fruit = 0;	//이전 과일... 0 - 없음 1 - 원래바나나 2 - 원래포도 3 - 원래딸기 4 - 원래수박
							_curr_left_fruit = 0;	//이번 과일... 0 - 없음 1 - 원래바나나 2 - 원래포도 3 - 원래딸기 4 - 원래수박
							_curr_right_fruit = 0;	//이번 과일... 0 - 없음 1 - 원래바나나 2 - 원래포도 3 - 원래딸기 4 - 원래수박
						}
					}
					else
						new Alert("레밸2 추가게임코드 에러").show();
				}
			}
		}
		public function changeGameLevel(level:int):void
		{
			//게임 레밸 바뀌면서 처리해줘야 할 것들.
			_game_level = level;
			
			_game_start = true;
			
			_game_index = 0;
			
			_is_additional_game = false;
			
			_user_correct_cnt = 0;
			
			if(!_did_get_level_down)
			{
				_leftover_game = GAME_LENGTH;
				_game_order = null;	//지금까지 한 패턴을 굳이 기록할 필요가 없어보임. 인덱스도 다 초기화 하니까 어차피.
				_game_order = new Object;
				makeGameOrder(0, GAME_LENGTH);		//레벨 1로 하는건 내려가는 경우 밖에 없으니까 이거 하면 안됨.
			}
			
			//레밸 1
			_prev_fruit = 0;		//이전 과일... 0 - 없음 1 - 원래바나나 2 - 원래포도 3 - 원래딸기 4 - 원래수박
			_curr_fruit = 0;		//이전 과일... 0 - 없음 1 - 원래바나나 2 - 원래포도 3 - 원래딸기 4 - 원래수박
			
			//래밸 2
			_prev_left_fruit = 0;	//이전 과일... 0 - 없음 1 - 원래바나나 2 - 원래포도 3 - 원래딸기 4 - 원래수박
			_prev_right_fruit = 0;	//이전 과일... 0 - 없음 1 - 원래바나나 2 - 원래포도 3 - 원래딸기 4 - 원래수박
			_curr_left_fruit = 0;	//이번 과일... 0 - 없음 1 - 원래바나나 2 - 원래포도 3 - 원래딸기 4 - 원래수박
			_curr_right_fruit = 0;	//이번 과일... 0 - 없음 1 - 원래바나나 2 - 원래포도 3 - 원래딸기 4 - 원래수박
		}
		
		public function addFruitLevel1():int
		{
			//여기는 생성만 함.
			
			var pattern:int = rand(0,2);	//0 - 1.1   1 - 1.2
			var which_fruit:int;
			
			if(_prev_fruit)
			{
				switch(pattern)
				{
					case 0:		which_fruit = GamePattern1_1();	break;
					case 1:		which_fruit = GamePattern1_2();	break;
				}
				_user_pattern[_total_game_index] = pattern+1;
			}
			else
			{
				which_fruit = GamePattern1_1();
				_user_pattern[_total_game_index] = 1;
			}
			//나중에 색깔 바뀌었을 때도 할 것.
			
			_bmp_fruit.smoothing = true;
			_bmp_fruit.x = Brain.Main.PageWidth/2 - _bmp_fruit.width/2;
			_bmp_fruit.y = 480 - _bmp_fruit.height/2;
			addChild(_bmp_fruit);
			
			//이번 과일 데이터 저장.
			return which_fruit;
		}
		public function addFruitLevel2():void
		{
			//과일 2개 보여주고 curr_left, right에 저장도 해줘야함.
			var pattern:int = rand(0,3);	//0 - 2.1   1 - 2.2	  2 - 2.3
			
			if(_prev_left_fruit)
			{
				switch(pattern)
				{
					case 0:		GamePattern2_1();	break;
					case 1:		GamePattern2_2();	break;
					case 2:		GamePattern2_3();	break;
				}
				_user_pattern[_total_game_index] = pattern+1;
			}
			else
			{
				GamePattern2_1();
				_user_pattern[_total_game_index] = 1;
			}
			
			_bmp_left_fruit.smoothing = true;
			_bmp_left_fruit.scaleX = 0.8;
			_bmp_left_fruit.scaleY = 0.8;
			_bmp_left_fruit.x = Brain.Main.PageWidth/2 - _bmp_left_fruit.width/2;
			_bmp_left_fruit.y = 480 - 100 - (_bmp_left_fruit.height)/2;
			addChild(_bmp_left_fruit);
			
			_bmp_right_fruit.smoothing = true;
			_bmp_right_fruit.scaleX = 0.8;
			_bmp_right_fruit.scaleY = 0.8;
			_bmp_right_fruit.x = Brain.Main.PageWidth/2 - _bmp_right_fruit.width/2;
			_bmp_right_fruit.y = 480 + 100 - (_bmp_right_fruit.height)/2;
			addChild(_bmp_right_fruit);
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
		public function endGame():void
		{
			if(stage == null)	return;
		
			if(_prev_fruit || _prev_left_fruit)
			{
				
				_effect = new Sound();
				_effect.addEventListener(IOErrorEvent.IO_ERROR, isError);
				_effect.addEventListener(Event.COMPLETE, onSoundLoaded);
				
				if(_user_selection[_total_game_index] == 0)
				{
					if(_bmp_state)	removeChild(_bmp_state);
					_bmp_state = new X;
					_effect.load(new URLRequest("sound/wrong.mp3"));
				}
				else
				{
					if(_bmp_state)	removeChild(_bmp_state);
					if(_user_selection[_total_game_index]-1)
					{
						_bmp_state = new X;
						_effect.load(new URLRequest("sound/wrong.mp3"));
					}
					else
					{
						_bmp_state = new O;
						_effect.load(new URLRequest("sound/correct.mp3"));
					}
				}
				_bmp_state.smoothing = true;   _bmp_state.alpha = 0;
				_bmp_state.x = Brain.Main.PageWidth/2 - _bmp_state.width/2;
				_bmp_state.y = 480 - _bmp_state.height/2;
				addChild(_bmp_state);
				FadeTween();
			}
			
			if(_game_level == 1)
			{
				if(_prev_fruit)			//이전 과일이 한번 있고 나서부터 게임 시작이므로 그 다음부터 추가한다.
				{
					_game_index++;				//게임 인덱스 다음번으로 넘김.
					_total_game_index++;		//전체 게임 인덱스.
					_process.text = String(_total_game_index) + "회 진행 중";
					_leftover_game--;			//남은 게임 하나 씩 줄임.
				}
				removeChild(_bmp_fruit);	//이전 과일 삭제.
				_bmp_fruit = null;			//이걸 널값으로 만들어서 0.2초 딜레이동안 터치 안되게 함.
				_prev_fruit = _curr_fruit;	//이번 과일을 저번 과일로 바꿔줌.
				
				clearTimeout(_end_game_id);	//만약 타이머 있으면 삭제(이거 이프문으로 널값인지 아닌지 검사했더니 에러남. 그냥 해줘도 됨.)
				setTimeout(gameDelay, GAME_DELAY);	//게임 끝나고 과일 뜨는 딜레이 줌.
				_isDelay = true;
			}
			else if(_game_level == 2)
			{
				if(_prev_left_fruit)			//이전 과일이 한번 있고 나서부터 게임 시작이므로 그 다음부터 추가한다.
				{
					_game_index++;				//게임 인덱스 다음번으로 넘김.
					_total_game_index++;		//전체 게임 인덱스.
					_process.text = String(_total_game_index) + "회 진행 중";
					_leftover_game--;			//남은 게임 하나 씩 줄임.
				}
				removeChild(_bmp_left_fruit);	//이전 과일들 삭제.
				removeChild(_bmp_right_fruit);
				_bmp_left_fruit = null;			//이걸 널값으로 만들어서 0.2초 딜레이동안 터치 안되게 함.
				_prev_left_fruit = _curr_left_fruit;	//이번 과일을 저번 과일들로 바꿔줌.
				_prev_right_fruit = _curr_right_fruit;
				
				clearTimeout(_end_game_id);	//만약 타이머 있으면 삭제(이거 이프문으로 널값인지 아닌지 검사했더니 에러남. 그냥 해줘도 됨.)
				setTimeout(gameDelay, GAME_DELAY);	//게임 끝나고 과일 뜨는 딜레이 줌.
				_isDelay = true;
			}
			
			if(_is_infinite_game)
			{
				makeGameOrder(_game_index, 1);	//계속 하나씩 만듬.
			}
		}
		private var _isDelay:Boolean = true;
		public function gameDelay():void
		{	
			_game_start = true;		//게임 시작.
			_isDelay = false;
		}
		public function blinkTimer(e:Event):void
		{
			if(_bmp_point.visible)
				_bmp_point.visible = false;
			else
				_bmp_point.visible = true;
		}
		private var _start_timer:Boolean = false;

		public function mouseDown(e:Event):void
		{
			var mouse_x:Number = this.mouseY;
			var mouse_y:Number = this.mouseX;
			if(_btn_quit.y <= mouse_x && mouse_x <= _btn_quit.y+_btn_quit.height)
					if(_btn_quit.x <= mouse_y && mouse_y <= _btn_quit.x+_btn_quit.width)
						return;
			
			if(_game_level == 1)
			{
				if(_bmp_fruit)
				{
					if(_prev_fruit)		//이전 과일이 있을 경우.(최초시작 x)
					{
						mouse_x = this.mouseY;		//x에다 y넣는 이유는 landscape방향이라 그런데 내가 계산할때 머리아파서 그럼.
						if(mouse_x < Brain.Main.PageHeight/2)		//왼쪽(yes)
						{
							if(_prev_fruit == _curr_fruit)
							{
								_user_selection[_total_game_index] = 1;	//맞은거 기록.
								_user_correct_cnt++;
							}
							else{
								_user_selection[_total_game_index] = 2;	//틀린거 기록.
							}
						}
						else										//오른쪽(no)
						{
							if(_prev_fruit != _curr_fruit)
							{
								_user_selection[_total_game_index] = 1;	//맞은거 기록.
								_user_correct_cnt++;
							}
							else{
								_user_selection[_total_game_index] = 2;	//틀린거 기록.
							}
						}
						
						endGame();
					}
				}
			}
			else if(_game_level == 2)
			{
				if(_bmp_left_fruit)
				{
					if(_prev_left_fruit)		//이전 과일이 있을 경우.(최초시작 x)
					{
						mouse_x = this.mouseY;		//x에다 y넣는 이유는 landscape방향이라 그런데 내가 계산할때 머리아파서 그럼.
						if(mouse_x < Brain.Main.PageHeight/2)		//왼쪽(yes)
						{
							if(_prev_left_fruit == _curr_left_fruit && _prev_right_fruit == _curr_right_fruit)
							{
								_user_selection[_total_game_index] = 1;	//맞은거 기록.
								_user_correct_cnt++;
							}
							else{
								_user_selection[_total_game_index] = 2;	//틀린거 기록.
							}
						}
						else										//오른쪽(no)
						{
							if(_prev_left_fruit != _curr_left_fruit && _prev_right_fruit != _curr_right_fruit)
							{
								_user_selection[_total_game_index] = 1;	//맞은거 기록.
								_user_correct_cnt++;
							}
							else{
								_user_selection[_total_game_index] = 2;	//틀린거 기록.
							}	
						}
						
						endGame();
					}
				}
			}
		}
		
		public function GamePattern1_1():int
		{
			var which_fruit:int = rand(1, 5);		//1 - 원래바나나 2 - 원래포도 3 - 원래딸기 4 - 원래수박 5 - 이상바나나 6 - 이상포도 7 - 이상딸기 8 - 이상수박
			
			if(_prev_fruit)		//이전 과일 있을 때만.
			{
				if(_game_order[_game_index] == 1)		//맞는거 나와야 할 때
				{
					which_fruit = _prev_fruit;
				}
				else									//틀린거 나와야 할 때
				{
					while(true)
					{
						which_fruit = rand(1, 5);
						if(which_fruit != _prev_fruit)	//틀린거 나올때까지 무한루프.
							break;
					}
				}
			}
			
			switch(which_fruit)
			{
				case 1:		_bmp_fruit = new BANANA;		break;
				case 2:		_bmp_fruit = new GRAPE;			break;
				case 3:		_bmp_fruit = new STRAWBERRY;	break;
				case 4:		_bmp_fruit = new WATERMELON;	break;
				case 5:		_bmp_fruit = new BANANA_2;		break;
				case 6:		_bmp_fruit = new GRAPE_2;		break;
				case 7:		_bmp_fruit = new STRAWBERRY_2;	break;
				case 8:		_bmp_fruit = new WATERMELON_2;	break;
			}
			
			return which_fruit;
		}
		public function GamePattern1_2():int
		{
			var which_fruit:int = rand(1, 9);		//1 - 원래바나나 2 - 원래포도 3 - 원래딸기 4 - 원래수박 5 - 이상바나나 6 - 이상포도 7 - 이상딸기 8 - 이상수박
			
			if(_prev_fruit)		//이전 과일 있을 때만.
			{
				if(_game_order[_game_index] == 1)		//맞는거 나와야 할 때
				{
					which_fruit = _prev_fruit;
				}
				else									//틀린거 나와야 할 때
				{
					if(1 <= _prev_fruit && _prev_fruit <= 4)
						which_fruit = _prev_fruit + 4;
					else if(5 <= _prev_fruit && _prev_fruit <= 8)
						which_fruit = _prev_fruit - 4;
				}
			}
			
			switch(which_fruit)
			{
				case 1:		_bmp_fruit = new BANANA;		break;
				case 2:		_bmp_fruit = new GRAPE;			break;
				case 3:		_bmp_fruit = new STRAWBERRY;	break;
				case 4:		_bmp_fruit = new WATERMELON;	break;
				case 5:		_bmp_fruit = new BANANA_2;		break;
				case 6:		_bmp_fruit = new GRAPE_2;		break;
				case 7:		_bmp_fruit = new STRAWBERRY_2;	break;
				case 8:		_bmp_fruit = new WATERMELON_2;	break;
			}
			
			return which_fruit;
		}
		public function GamePattern2_1():void
		{
			var left_fruit:int = rand(1, 5);
			var right_fruit:int = rand(1, 5);
			
			if(_prev_left_fruit)		//이전 과일 있을 때만.
			{
				if(_game_order[_game_index] == 1)		//맞는거 나와야 할 때
				{
					left_fruit = _prev_left_fruit;
					right_fruit = _prev_right_fruit;
				}
				else									//틀린거 나와야 할 때
				{
					while(true)
					{
						left_fruit = rand(1, 5);
						if(left_fruit != _prev_left_fruit)	//틀린거 나올때까지 무한루프.
							break;
					}
					
					while(true)
					{
						right_fruit = rand(1, 5);			//왼쪽이랑 오른쪽과일 다르게.
						if(left_fruit != right_fruit)		//틀린거 나올때까지 무한루프.
							break;
					}
				}
			}
			else
			{
				while(true)
				{
					right_fruit = rand(1, 5);			//왼쪽이랑 오른쪽과일 다르게.
					if(left_fruit != right_fruit)		//틀린거 나올때까지 무한루프.
						break;
				}
			}
			
			switch(left_fruit)
			{
				case 1:		_bmp_left_fruit = new BANANA;		break;
				case 2:		_bmp_left_fruit = new GRAPE;		break;
				case 3:		_bmp_left_fruit = new STRAWBERRY;	break;
				case 4:		_bmp_left_fruit = new WATERMELON;	break;
				case 5:		_bmp_left_fruit = new BANANA_2;		break;
				case 6:		_bmp_left_fruit = new GRAPE_2;		break;
				case 7:		_bmp_left_fruit = new STRAWBERRY_2;	break;
				case 8:		_bmp_left_fruit = new WATERMELON_2;	break;
			}
			switch(right_fruit)
			{
				case 1:		_bmp_right_fruit = new BANANA;		break;
				case 2:		_bmp_right_fruit = new GRAPE;		break;
				case 3:		_bmp_right_fruit = new STRAWBERRY;	break;
				case 4:		_bmp_right_fruit = new WATERMELON;	break;
				case 5:		_bmp_right_fruit = new BANANA_2;	break;
				case 6:		_bmp_right_fruit = new GRAPE_2;		break;
				case 7:		_bmp_right_fruit = new STRAWBERRY_2;break;
				case 8:		_bmp_right_fruit = new WATERMELON_2;break;
			}
			
			_curr_left_fruit = left_fruit;
			_curr_right_fruit = right_fruit;
		}
		public function GamePattern2_2():void
		{
			var left_fruit:int = rand(1, 5);
			var right_fruit:int = rand(1, 5);
			
			if(_game_order[_game_index] == 1)		//맞는거 나와야 할 때
			{
				left_fruit = _prev_left_fruit;
				right_fruit = _prev_right_fruit;
			}
			else									//틀린거 나와야 할 때(위치만 바꿈)
			{
				left_fruit = _prev_right_fruit;
				right_fruit = _prev_left_fruit;
			}
			
			switch(left_fruit)
			{
				case 1:		_bmp_left_fruit = new BANANA;		break;
				case 2:		_bmp_left_fruit = new GRAPE;		break;
				case 3:		_bmp_left_fruit = new STRAWBERRY;	break;
				case 4:		_bmp_left_fruit = new WATERMELON;	break;
				case 5:		_bmp_left_fruit = new BANANA_2;		break;
				case 6:		_bmp_left_fruit = new GRAPE_2;		break;
				case 7:		_bmp_left_fruit = new STRAWBERRY_2;	break;
				case 8:		_bmp_left_fruit = new WATERMELON_2;	break;
			}
			switch(right_fruit)
			{
				case 1:		_bmp_right_fruit = new BANANA;		break;
				case 2:		_bmp_right_fruit = new GRAPE;		break;
				case 3:		_bmp_right_fruit = new STRAWBERRY;	break;
				case 4:		_bmp_right_fruit = new WATERMELON;	break;
				case 5:		_bmp_right_fruit = new BANANA_2;	break;
				case 6:		_bmp_right_fruit = new GRAPE_2;		break;
				case 7:		_bmp_right_fruit = new STRAWBERRY_2;break;
				case 8:		_bmp_right_fruit = new WATERMELON_2;break;
			}
			
			_curr_left_fruit = left_fruit;
			_curr_right_fruit = right_fruit;
		}
		public function GamePattern2_3():void
		{
			var left_fruit:int = rand(1, 9);//1 - 원래바나나 2 - 원래포도 3 - 원래딸기 4 - 원래수박 5 - 이상바나나 6 - 이상포도 7 - 이상딸기 8 - 이상수박
			var right_fruit:int = rand(1, 9);//1 - 원래바나나 2 - 원래포도 3 - 원래딸기 4 - 원래수박 5 - 이상바나나 6 - 이상포도 7 - 이상딸기 8 - 이상수박
			
			if(_game_order[_game_index] == 1)		//맞는거 나와야 할 때
			{
				left_fruit = _prev_left_fruit;
				right_fruit = _prev_right_fruit;
			}
			else									//틀린거 나와야 할 때
			{
				if(1 <= _prev_left_fruit && _prev_left_fruit <= 4)
					left_fruit = _prev_left_fruit + 4;
				else if(5 <= _prev_left_fruit && _prev_left_fruit <= 8)
					left_fruit = _prev_left_fruit - 4;
				
				while(true)
				{
					right_fruit = rand(1, 9);			//왼쪽이랑 오른쪽과일 다르게.
					if(left_fruit != right_fruit && left_fruit + 4 != right_fruit && left_fruit - 4 != right_fruit)//틀린거 나올때까지 무한루프.
						break;
				}
			}
			
			switch(left_fruit)
			{
				case 1:		_bmp_left_fruit = new BANANA;		break;
				case 2:		_bmp_left_fruit = new GRAPE;		break;
				case 3:		_bmp_left_fruit = new STRAWBERRY;	break;
				case 4:		_bmp_left_fruit = new WATERMELON;	break;
				case 5:		_bmp_left_fruit = new BANANA_2;		break;
				case 6:		_bmp_left_fruit = new GRAPE_2;		break;
				case 7:		_bmp_left_fruit = new STRAWBERRY_2;	break;
				case 8:		_bmp_left_fruit = new WATERMELON_2;	break;
			}
			switch(right_fruit)
			{
				case 1:		_bmp_right_fruit = new BANANA;		break;
				case 2:		_bmp_right_fruit = new GRAPE;		break;
				case 3:		_bmp_right_fruit = new STRAWBERRY;	break;
				case 4:		_bmp_right_fruit = new WATERMELON;	break;
				case 5:		_bmp_right_fruit = new BANANA_2;	break;
				case 6:		_bmp_right_fruit = new GRAPE_2;		break;
				case 7:		_bmp_right_fruit = new STRAWBERRY_2;break;
				case 8:		_bmp_right_fruit = new WATERMELON_2;break;
			}
			
			_curr_left_fruit = left_fruit;
			_curr_right_fruit = right_fruit;
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
						if(isFinish)
						{
							
						}
					});
				}
			});
		}
		public override function onResize():void
		{
		}
		public function rand(min:int, max:int):int
		{
			return min + (max - min) * Math.random();
		}
		public override function dispose():void
		{
			removeEventListener(MouseEvent.CLICK, mouseDown);
			removeEventListener(Event.ENTER_FRAME, EnterFrame);
			
			_remainTimer.removeEventListener(TimerEvent.TIMER, remainTimer_onTick);
			clearTimeout(_end_game_id);
						
			if(_isPopupOn)
				Brain.Main.closePopup();
		}
	}
}