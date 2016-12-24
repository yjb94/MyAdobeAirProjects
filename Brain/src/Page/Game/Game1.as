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
	import flash.system.Capabilities;
	import flash.text.ReturnKeyLabel;
	import flash.text.SoftKeyboardType;
	import flash.text.StageText;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import Page.BasePage;
	
	import Popup.BasePopup;
	import Popup.CancelGamePopup;
	
	import kr.pe.hs.tween.Tween;
	import kr.pe.hs.ui.TabbedButton;
	
	public class Game1 extends BasePage
	{	
		private static const FADE_IN:Number = 300;
		private static const FADE_OUT:Number = 300;

		private var GAME_INDEX:Number = 20;
		
		[Embed(source = "assets/page/game/game1/bg.png")]
		private static const BG:Class;
		
		[Embed(source = "assets/page/game/game1/point.png")]
		private static const POINT:Class;
		private var _bmp_point:Bitmap;
		
		[Embed(source = "assets/page/game/game1/off.png")]
		private static const OFF:Class;
		[Embed(source = "assets/page/game/game1/on.png")]
		private static const ON:Class;
		[Embed(source = "assets/page/game/game1/bear.png")]
		private static const BEAR:Class;
		
		[Embed(source = "assets/page/game/index/button_quit.png")]
		private static const BUTTON_QUIT:Class;
		private var _btn_quit:TabbedButton;
		
		[Embed(source = "assets/page/game/index/O.png")]
		private static const O:Class;
		[Embed(source = "assets/page/game/index/X.png")]
		private static const X:Class;
		private var _bmp_state:Bitmap;
		
		private var _bmp_left:Bitmap;
		private var _bmp_right:Bitmap;
		
		private var _blink_timer:Timer;
		
		private var _game_start:Boolean;
		private var _bear_appeared:Boolean;
		
		private var _end_game_id:uint;
		private var _light_id:uint;
		private var _bear_id:uint;
		private var _last_game_id:uint;
		
		private var _window_dir:Object;
		private var _window_index:int;
		private var _start_time:Date;
		
		private var _light_dir:Object;
		
		private var _user_selection:Object;//-1 미응답 0 오답 1 정답.
		private var _user_react:Object;
		private var _user_condition:Object;
		
		private var _tick_time:Timer;
		
		private var _effect:Sound;
		
		public function Game1()
		{
			super();
			
			Brain.Main.TopMenuVisible = false;
			
			if(Brain.isTestGame)
				GAME_INDEX = 5;
			
			//bg
			var bmp:Bitmap = new BG; bmp.smoothing = true; addChild(bmp);
			//point
			_bmp_point = new POINT; _bmp_point.smoothing = true;
			_bmp_point.x = Brain.Main.FullWidth/2 - _bmp_point.width/2;
			_bmp_point.y = Brain.Main.FullHeight/2 - _bmp_point.height/2;
			addChild(_bmp_point);
			
			//window
			_bmp_left = new OFF; _bmp_left.smoothing = true;
			_bmp_left.x = 112;
			_bmp_left.y = Brain.Main.FullHeight/4 - _bmp_left.height/2;
			addChild(_bmp_left);
			
			_bmp_right = new OFF; _bmp_right.smoothing = true;
			_bmp_right.x = 112;
			_bmp_right.y = Brain.Main.FullHeight*(3/4) - _bmp_right.height/2;
			addChild(_bmp_right);
			
			bmp    = new BUTTON_QUIT;    bmp.smoothing    = true;
			var bmp_on:Bitmap = new BUTTON_QUIT; bmp_on.smoothing = true; bmp_on.alpha = 0.6;
			_btn_quit = new TabbedButton(bmp, bmp_on, bmp_on); _btn_quit.x = 486; _btn_quit.y = Brain.Main.PageHeight-18-_btn_quit.height;
			addChild(_btn_quit);
			
			
			//window dir init, user_sel and user_react
			_user_selection = new Object;
			_user_react = new Object;
			_user_condition = new Object;
			
			_window_dir = new Object;
			_light_dir = new Object;
			for(var i:int = 0; i < GAME_INDEX; i++)
				_window_dir[i] = i%2;
			
			var correctCnt:int = 0;
			var incorrectCnt:int = 0;
			for(i = 0; i < GAME_INDEX; i++)
			{
				var rand1:int = rand(0, GAME_INDEX); var rand2:int = rand(0, GAME_INDEX);
				var temp:int = _window_dir[rand1];
				_window_dir[rand1] = _window_dir[rand2];
				_window_dir[rand2] = temp;
			}
			i = 0;
			while(true)
			{
				var dataOk:Boolean = false;
				
				var flag:int = rand(0, 2);		//0, 1
				
				if(flag)
				{
					if(correctCnt < 10)
					{
						correctCnt++;
						dataOk = true;
					}
				}
				else
				{
					if(incorrectCnt < 10)
					{
						incorrectCnt++; 
						dataOk = true;
					}
				}
				
				if(dataOk)
				{
					_light_dir[i] = flag ? _window_dir[i] : !_window_dir[i];
					i++;
				}
				if(i == GAME_INDEX)
				{
					break;
				}
			}
			
			for(i = 0; i < GAME_INDEX; i++)
			{
				if(_light_dir[i] == _window_dir[i])
					_user_condition[i] = 1;
				else
					_user_condition[i] = 0;
				
				_user_selection[i] = 0;
				_user_react[i] = 0;
			}
				
			_window_index = -1;
				
			_game_start = false;
			_bear_appeared = false;
			
			addEventListener(MouseEvent.CLICK, mouseDown);
			setTimeout(wait, 1000);
		}
		public function wait():void
		{
			addEventListener(Event.ENTER_FRAME, EnterFrame);
		}
		public function EnterFrame(e:Event):void
		{
			//if(Brain.Main.isPageChanged)
			//{
				if(!_blink_timer)
				{
					_blink_timer = new Timer(250, 4);
					_blink_timer.addEventListener(TimerEvent.TIMER, blinkTimer);
					_blink_timer.start();
					
					setTimeout(startTimer, 1000);
				}
			//}
			
			if(_game_start && _window_index < GAME_INDEX)
			{
				_game_start = false;
				gameMethod();
			}
		}
		private var _popupOpened:Boolean = false;
		public function quitClicked(e:MouseEvent):void
		{
			//팝업
			if(!_game_delay && _start_timer)
			{
				Brain.Main.showPopup(new CancelGamePopup(popupClicked));
				_popupOpened = true;
				
				clearTimeout(_end_game_id);
				clearTimeout(_light_id);
				clearTimeout(_bear_id);
				clearTimeout(_last_game_id);
			}
		}
		private function popupClicked(value:Boolean):void
		{
			if(value)
				Brain.Main.setPage("brainGameIndexPage", null, BrainPageEffect.RIGHT, BrainPageEffect.RIGHT);
			Brain.Main.closePopup();
			_popupOpened = false;
			
			if(4500-_tick_time.currentCount > 0) _end_game_id = setTimeout(endGame, 4500-_tick_time.currentCount);
			if(1000-_tick_time.currentCount > 0) _light_id = setTimeout(removeLight, 1000-_tick_time.currentCount);
			if(1500-_tick_time.currentCount > 0) _bear_id = setTimeout(displayBear, 1500-_tick_time.currentCount);
			
			if(_window_index == 19)
				if(4500-_tick_time.currentCount > 0)
					_last_game_id = setTimeout(lastGame, 4500-_tick_time.currentCount);
		}
		public function blinkTimer(e:Event):void
		{
			if(_bmp_point.visible)
				_bmp_point.visible = false;
			else
				_bmp_point.visible = true;
		}
		private var _start_timer:Boolean;
		public function startTimer():void
		{
			_blink_timer.removeEventListener(TimerEvent.TIMER, blinkTimer);
			_btn_quit.addEventListener(MouseEvent.CLICK, quitClicked); 
			_start_timer = true;
			_game_start = true;
		}
		public function gameMethod():void
		{
			removeLight();
			_window_index++;
			if(_window_index >= 0)
				clearTimeout(_end_game_id);
			_end_game_id = setTimeout(endGame, 4500);
			_light_id = setTimeout(removeLight, 1000);
			_bear_id = setTimeout(displayBear, 1500);
			_tick_time = new Timer(1);
			_tick_time.start();
			
			if(_window_index == GAME_INDEX-1)
				_last_game_id = setTimeout(lastGame, 4500);

			if(_window_index < GAME_INDEX)
			{
				if(_light_dir[_window_index])
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
			}
		}
		private var isComplete:Boolean = false;
		public function lastGame():void
		{
			if(isComplete)	return;
			isComplete = true;
			clearTimeout(_last_game_id);
			removeLight();
			if(_user_selection[_window_index] == 0)
			{
				if(_bmp_state)	removeChild(_bmp_state);
				_bmp_state = new X;
			}
			else
			{
				if(_bmp_state)	removeChild(_bmp_state);
				if(_user_selection[_window_index]-1)
					_bmp_state = new X;
				else
					_bmp_state = new O;
			}
			_bmp_state.smoothing = true;   _bmp_state.alpha = 0;
			_bmp_state.x = Brain.Main.PageWidth/2 - _bmp_state.width/2;
			_bmp_state.y = 480 - _bmp_state.height/2;
			addChild(_bmp_state);
			FadeTween();
			//창전환.
			//Brain.Main.setPage("brainGameResultPage");
			
			//데이터 종합.
			if(!Brain.isTestGame && Brain.UserInfo.child_seq != -1)
			{
				var params:URLVariables = new URLVariables;
//				input 
//				1. user_seq : 사용자번호
//				2. child_seq : 아이번호
//				3. test_id : 테스트 ID - 001로 셋팅 (임시)
//				4. response_time : 응답시간 ex) 100%100%140%300%200%  이런식으로 '%' 구분자 줘서 줘
//				5. response_type : 응답유형  0:무반응 1:일치 2:불일치 ex) 1%1%1%0%2%  이런식으로 '%' 구분자 줘서 줘
//				6. response_condition : 일치불일치조건 0:불 켜진 곳과 곰돌이 나온 곳이 불일치  1:불 켜진 곳과 곰돌이 나온 곳이 일치  ex) 0%1%  이런식으로 '%' 구분자 줘서 줘
				params.user_seq = Brain.UserInfo.user_seq;
				params.child_seq = Brain.UserInfo.child_seq;
				params.test_id = "001";
				params.response_time = "";
				params.response_type = "";
				params.response_condition = "";
				for(var i:int = 0; i < GAME_INDEX; i++)
				{
					params.response_type = params.response_type + _user_selection[i] + "%";
					params.response_time = params.response_time + _user_react[i] + "%";
					params.response_condition = params.response_condition + _user_condition[i] + "%";
				}
			
				Brain.Connection.post("cognitiveGameAction1.cog", params, onLoadComplete);
			}
			else
			{
				Brain.Main.setPage("brainGameResultPage");
			}
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
//				4. j_gameResultModelO : 클래스로 넘김
//				- avr_correct_avr_time : 모든 응답자의 반응시간 평균
//				- std_correct_avr_time : 모든 응답자의 반응시간 표준편차
//				- avr_correct_acc_type : 모든 응답자의 일치 정확도 평균
//				- std_correct_acc_type : 모든 응답자의 일치 정확도 표준편차
//				- correct_avr_time : 해당 이용자의 반응시간 평균
//				- correct_acc_type : 해당 이용자의 정확도 평균
				if(result.j_errorMsg.length>0)
				{
					new Alert(result.j_errorMsg).show();
				}
				if(result.j_regYn == "N")
					new Alert("데이터 등록 실패.").show();
				
				var total_correct:Number = 0;
				for(var i:int = 0; i < GAME_INDEX; i++)
				{
					if(_user_selection[i] == "1")
						total_correct++;
				}
				result.j_gameResultModelO.index1 = String(result.j_gameResultModelO.correct_avr_time)+"초";
				result.j_gameResultModelO.index2 = String(total_correct)+"/"+String(GAME_INDEX);
				Brain.Main.setPage("brainGameResultPage", result.j_gameResultModelO, BrainPageEffect.LEFT, BrainPageEffect.LEFT);
				
				return;
			}
			
			new Alert("데이터 저장 실패.").show();
		}
		public function endGame(e:TimerEvent=null):void
		{
			removeLight();
			clearTimeout(_end_game_id);
			_effect = new Sound();
			_effect.addEventListener(IOErrorEvent.IO_ERROR, isError);
			_effect.addEventListener(Event.COMPLETE, onSoundLoaded);
			if(_user_selection[_window_index] == 0)
			{
				if(_bmp_state)	removeChild(_bmp_state);
				_bmp_state = new X;
				_effect.load(new URLRequest("sound/wrong.mp3"));
			}
			else
			{
				if(_bmp_state)	removeChild(_bmp_state);
				if(_user_selection[_window_index]-1)
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
			_bmp_state.y = Brain.Main.PageHeight/2 - _bmp_state.height/2;
			addChild(_bmp_state);
			FadeTween();
			setTimeout(gameDelay, 1000);
			_game_delay = true;
		}
		private var _game_delay:Boolean = false;
		public function gameDelay():void
		{
			_game_delay = false;
			//_game_start = true;
			_blink_timer = null;
		}
		public function displayBear(e:TimerEvent = null):void
		{
			//곰 나타내기, 어느쪽에 나타내야할지 보고.
			_bear_appeared = true;
			if(_window_dir[_window_index])
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
			_start_time = new Date;
		}
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
		private function convertTimeToMillisecond(date:Date):Number
		{
			var h:Number = date.hours * 3600000;
			var m:Number = date.minutes * 60000;
			var s:Number = date.seconds * 1000;
			var ms:Number = date.milliseconds;
			var total:Number = h+m+s+ms;
			return total;
		}
		public function mouseDown(e:Event):void
		{
			if(_btn_quit.x <= this.mouseX && this.mouseX <= _btn_quit.x+_btn_quit.width)
				if(_btn_quit.y <= this.mouseY && this.mouseY <= _btn_quit.y+_btn_quit.height)
					return;
			
			if(_bear_appeared)
			{
				var end_time:Date = new Date;
				var start_milli:Number = convertTimeToMillisecond(_start_time);
				var end_milli:Number = convertTimeToMillisecond(end_time);
				_user_react[_window_index] =  end_milli - start_milli;
				
				//end_time.
				
				var mouse_x:Number = this.mouseY;
				_bear_appeared = false;
				
				if(_window_dir[_window_index])
				{
					if(mouse_x < Brain.Main.PageHeight/2)
						_user_selection[_window_index] = 1;//맞춘거 기록.
					else
						_user_selection[_window_index] = 2;//틀린거 기록.
				}
				else
				{
					if(mouse_x > Brain.Main.PageHeight/2)
						_user_selection[_window_index] = 1;//맞춘거 기록.
					else
						_user_selection[_window_index] = 2;//틀린거 기록.
				}
				
				endGame();
				if(_window_index >= GAME_INDEX-1)
					lastGame();
			}
		}
		
		public override function onResize():void
		{
		}
		private var _tween_alpha:Tween;
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
		public function rand(min:int, max:int):int
		{
			return min + (max - min) * Math.random();
		}
		public override function dispose():void
		{
			if(_popupOpened)
				Brain.Main.closePopup();
			
			removeEventListener(Event.ENTER_FRAME, EnterFrame);
			//if(_effect) _effect.removeEventListener(Event.COMPLETE, onSoundLoaded);
			
			clearTimeout(_end_game_id);
			clearTimeout(_light_id);
			clearTimeout(_bear_id);
			clearTimeout(_last_game_id);
			
			_blink_timer.stop();
			_blink_timer.removeEventListener(TimerEvent.TIMER, blinkTimer);
			_blink_timer = null;
		}
	}
}
