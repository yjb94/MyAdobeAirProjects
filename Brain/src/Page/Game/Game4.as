package Page.Game
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import Page.BasePage;
	
	import Popup.CancelGamePopup;
	import Popup.Game3Popup;
	import Popup.Game4Popup;
	
	import kr.pe.hs.tween.Tween;
	import kr.pe.hs.ui.TabbedButton;

	public class Game4 extends BasePage
	{
		private static var GAME_LENGTH:Number = 7;
		
		private static const ANIMAL_APPEAR_TIME:Number = 800;
		private static const DELAY:Number = 200;
		
		
		[Embed(source = "assets/page/game/game4/bg.png")]
		private static const BG:Class;
		
		[Embed(source = "assets/page/game/game2/point.png")]
		private static const POINT:Class;
		private var _bmp_point:Bitmap;
		private var _blink_timer:Timer;
		
		[Embed(source = "assets/page/game/index/button_quit.png")]
		private static const BUTTON_QUIT:Class;
		private var _btn_quit:TabbedButton;
		
		[Embed(source = "assets/page/game/game4/animal_bg.png")]
		private static const ANIMAL_BG:Class;		//6개 - 185x165 8,10 - 157x140
		private var _bmp_animal_bg:Vector.<Bitmap>;
		
		[Embed(source = "assets/page/game/game4/bull.png")]
		private static const BULL:Class;
		[Embed(source = "assets/page/game/game4/cat.png")]
		private static const CAT:Class;
		[Embed(source = "assets/page/game/game4/chicken.png")]
		private static const CHICKEN:Class;
		[Embed(source = "assets/page/game/game4/dog.png")]
		private static const DOG:Class;
		[Embed(source = "assets/page/game/game4/frog.png")]
		private static const FROG:Class;
		[Embed(source = "assets/page/game/game4/goat.png")]
		private static const GOAT:Class;
		[Embed(source = "assets/page/game/game4/lion.png")]
		private static const LION:Class;
		[Embed(source = "assets/page/game/game4/mouse.png")]
		private static const MOUSE:Class;
		[Embed(source = "assets/page/game/game4/owl.png")]
		private static const OWL:Class;
		[Embed(source = "assets/page/game/game4/pig.png")]
		private static const PIG:Class;
		
		private static const ANIMALS:Array = new Array(BULL, CAT, CHICKEN, DOG, FROG, GOAT, LION, MOUSE, OWL, PIG);
		private var _bmp_animal:Bitmap;	//0-소,1-고양이,2-닭,3-개,4-개구리,5-염소,6-사자,7-쥐,8-부엉이,9-돼지
		private var _bmp_animal_question:Vector.<Sprite>;
		
		private var _animal_order:Object;
		
		private var _game_index:int = 0;
		
		private var _game_start:Boolean;
		
		private var _end_turn_id:uint;
		private var _end_game_id:uint;
		
		private var _game_level:int = 1;
		
		private var _game_cnt:int = 0; 	//게임 총 실행 횟수
		
		private var _user_answer:Array;
		
		[Embed(source = "assets/page/game/game2/button_next.png")]
		private static const BUTTON_NEXT:Class;
		private var _btn_next:TabbedButton;
		
		private var _animal_sound_name:Array = new Array("bull.mp3","cat.mp3", "chicken.mp3", "dog.mp3", "frog.mp3", "goat.mp3", "lion.mp3", "mouse.mp3", "owl.mp3", "pig.mp3");
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
		
		public function Game4()
		{
			
			if(Brain.isTestGame)
				GAME_LENGTH = 3;				//게임 횟수
			
			super();
			
			Brain.Main.TopMenuVisible = false;
			
			var bmp:Bitmap = new BG; bmp.smoothing = true; addChild(bmp);
			
			bmp = new BUTTON_QUIT;    bmp.smoothing    = true;
			var bmp_on:Bitmap = new BUTTON_QUIT; bmp_on.smoothing = true; bmp_on.alpha = 0.6;
			_btn_quit = new TabbedButton(bmp, bmp_on, bmp_on); _btn_quit.x = 486; _btn_quit.y =  Brain.Main.PageHeight-18-_btn_quit.height;
			addChild(_btn_quit);
			
			_animal_order = new Object;
			
			setTimeout(wait, 500);
		}
		private function MakeOrder():void
		{
			var animal_num:int = _game_level+1;
			if(animal_num > 7)	animal_num = 7;
			
			for(var i:int = 0; i < animal_num; i++)
			{
				_animal_order[i] = rand(0,ANIMALS.length);	//0-소,1-고양이,2-닭,3-개,4-개구리,5-염소,6-사자,7-쥐,8-부엉이,9-돼지
				for(var j:int = 0; j < i; j++)
					if(_animal_order[i] == _animal_order[j])
						i--;
			}
		}
		private function wait():void
		{
			Brain.Main.showPopup(new Game4Popup(InitDatas));
		}
		public function blinkTimer(e:Event):void
		{
			if(_bmp_point.visible)
				_bmp_point.visible = false;
			else
				_bmp_point.visible = true;
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
			addEventListener(Event.ENTER_FRAME, EnterFrame);
			
			MakeOrder();
		}
		public function EnterFrame(e:Event):void
		{
			if(isComplete)	return;
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
		private var _tick_time:Timer;
		private var __delay_id:uint;
		public function gameMethod():void
		{			
			_tick_time = new Timer(1);
			_tick_time.start();
			
			_bmp_animal = new ANIMALS[_animal_order[_game_index]];	
			_bmp_animal.x = Brain.Main.PageWidth/2 - _bmp_animal.width/2;
			_bmp_animal.y = 480 - _bmp_animal.height/2;
			addChild(_bmp_animal);
			
			_animal_sound = new Sound();
			_animal_sound.addEventListener(IOErrorEvent.IO_ERROR, isAnimalSoundError);
			_animal_sound.addEventListener(Event.COMPLETE, onAnimalSoundLoaded);
			_animal_sound.load(new URLRequest("sound/"+_animal_sound_name[_animal_order[_game_index]]));
			
			clearTimeout(__delay_id);
			__delay_id = setTimeout(delay, ANIMAL_APPEAR_TIME);
		}
		private var isDelayMode:Boolean = false;
		public function delay():void
		{
			removeChild(_bmp_animal);
			clearTimeout(__delay_id);
			isDelayMode = true;
			_end_turn_id = setTimeout(endTurn, DELAY);
		}
		public function endTurn():void
		{
			_game_index++;
			clearTimeout(_end_turn_id);
			isDelayMode = false;
			
			//init after here.
			var animal_num:int = _game_level+1;
			if(animal_num > 7)	animal_num = 7;
			
			if(_game_index == animal_num)
				showQuestion();
			else
				_game_start = true;
		}
		private var _questionMode:Boolean = false;
		public function showQuestion():void
		{
			_questionMode = true;
			clearTimeout(_end_game_id);
			_end_game_id = setTimeout(endGame, 10000);
			
			_user_answer = new Array;
			
			DrawQuestion();
			_game_cnt++;
			
			if(_btn_next) removeChild(_btn_next);
			var bmp:Bitmap   = new BUTTON_NEXT;    bmp.smoothing    = true;
			var bmp_on:Bitmap = new BUTTON_NEXT; bmp_on.smoothing = true; bmp_on.alpha = 0.6;
			_btn_next = new TabbedButton(bmp, bmp_on, bmp_on); _btn_next.x = 40; _btn_next.y =  Brain.Main.PageHeight-18-_btn_next.height;
			_btn_next.addEventListener(MouseEvent.CLICK, nextClicked); addChild(_btn_next);
			_btn_next.alpha = 0.6;
		}
		private function nextClicked(e:MouseEvent):void
		{
			if(_btn_next.alpha == 1.0)
				endGame();
		}
		private var _question:Array;
		private var result_animal:Array;
		private function DrawQuestion():void
		{
			var result_animal:Array = new Array;
			
			var animals:Array = AnimalArrayWithout();
			shuffleArray(animals);
			
			var answer_num:int = _game_level+1;
			if(answer_num > 7)	answer_num = 7;
			var question_num:int = answer_num+4-answer_num%2;
			
			var answer_length:int = 0;
			for(var i:int = 0; _animal_order[i] != null; i++)
				answer_length++;
			for(i = 0; i < question_num-answer_length; i++)
				result_animal.push(animals[i]);
			for(i = question_num-answer_length; i < question_num; i++)
				result_animal.push(ANIMALS[_animal_order[i-question_num+answer_length]]);
			shuffleArray(result_animal);
			
			_bmp_animal_question = new Vector.<Sprite>(result_animal.length, false);
			_bmp_animal_bg = new Vector.<Bitmap>(result_animal.length, false);
			_question = new Array;
			
			var index:int = 0;
			for(i = 0; i < 2; i++)
			{
				for(var j:int = 0; j < result_animal.length/2; j++)
				{
					var bmp:Bitmap = new result_animal[index];
					_bmp_animal_question[index] = new Sprite;
					_bmp_animal_question[index].addChild(bmp);
					
					var wid:int = (result_animal.length <= 6) ? 185 : 157;
					var hei:int = (result_animal.length <= 6) ? 165 : 140;
					
					var base_x:Number;
					var base_y:Number;
					if(result_animal.length <=6) { base_x = 105; base_y = 232.5; }
					else if(result_animal.length <=8) { base_x = 130; base_y = 200; }
					else if(result_animal.length <=10) { base_x = 130; base_y = 130; }
					
					_bmp_animal_bg[index] = new ANIMAL_BG;
					_bmp_animal_bg[index].x = i*wid+base_x;
					_bmp_animal_bg[index].y = j*hei+base_y;
					scaleBG(_bmp_animal_bg[index], wid, hei);
					
					_bmp_animal_question[index].x = _bmp_animal_bg[index].x;
					_bmp_animal_question[index].y = _bmp_animal_bg[index].y;
					scaleImage(_bmp_animal_question[index], wid, hei);
					_bmp_animal_question[index].x = _bmp_animal_bg[index].x+_bmp_animal_bg[index].width/2-_bmp_animal_question[index].width/2;
					_bmp_animal_question[index].y = _bmp_animal_bg[index].y+_bmp_animal_bg[index].height/2-_bmp_animal_question[index].height/2;
					
					_bmp_animal_question[index].addEventListener(MouseEvent.CLICK, onAnimalClick);
					addChild(_bmp_animal_bg[index]);
					addChild(_bmp_animal_question[index]);
					
					index++;
				}
			}
			for(j = 0; j < result_animal.length; j++)
				for(i = 0; i < ANIMALS.length; i++)
					if(ANIMALS[i] == result_animal[j])
						_question.push(i);
		}
		private var _clicked_index:Array;
		private var _clicked_time:int = 0;
		private function onAnimalClick(e:MouseEvent):void
		{
			//0-소,1-고양이,2-닭,3-개,4-개구리,5-염소,6-사자,7-쥐,8-부엉이,9-돼지
			//_clicked_index = new Array(false,false,false,false,false,false,false,false);
			clearTimeout(_end_game_id);
			_end_game_id = setTimeout(endGame, 10000);
			
			var index:int = getIndex(mouseX, mouseY);
			
			var spr:Sprite = (e.currentTarget as Sprite);
			
			//_clicked_index[index] = !_clicked_index[index];
			var selected_animal:int;
			
//			for(i = 0; i < ANIMALS.length; i++)
//				for(var j = 0; j < _question.length; j++)
//					if(ANIMALS[i] == _question[j])
//						_question.push(i);
			
			if(spr.alpha == 1)
			{
				_clicked_time++;
				spr.alpha = 0.7;
				_user_answer.push(_question[index]);
			}
			else
			{
				_clicked_time--;
				spr.alpha = 1.0;
				for(var i:int = 0; i < _user_answer.length; i++)
					if(_user_answer[i] == _question[index])
						_user_answer.splice(i,1);
			}
				
			var answer_num:int = _game_level+1;
			if(answer_num > 7)	answer_num = 7;
			
			if(_clicked_time >= answer_num)
				_btn_next.alpha = 1.0;
			else
				_btn_next.alpha = 0.6;
		}
		private function getIndex(mouse_x:Number, mouse_y:Number):int
		{
			
			var animal_num:Number = (_bmp_animal_question.length <= 6) ? 6 : 8;
			if(_bmp_animal_question.length == 10) animal_num = 10;
			
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
		private function scaleBG(img:Bitmap, width:int, height:int):void
		{
			img.width = width;
			img.height = height;
		}
		private function scaleImage(img:Sprite, width:int, height:int):void
		{
			img.width = width;
			img.height = height;
			if(img.scaleX > img.scaleY) img.scaleX = img.scaleY;
			else						img.scaleY = img.scaleX;
		}
		private function shuffleArray(arr:Array):Array
		{
			for(var i:int = 0; i < arr.length; i++)
			{
				var rand_num:int = rand(0, arr.length);
				var temp:Object = arr[i];
				arr[i] = arr[rand_num];
				arr[rand_num] = temp;
			}
			return arr;
		}
		public function AnimalArrayWithout():Array
		{
			var arr:Array = toArray(ANIMALS);
			var animals:Array = new Array;
			
			for(var i:int = 0; _animal_order[i] != null; i++)
				animals.push(ANIMALS[_animal_order[i]]);
			
			for(i = 0; i < animals.length; i++)
				for(var j:int = 0; j < arr.length; j++)
					if(arr[j] == animals[i])
						arr.splice(j,1);
			
			return arr;
		}
		public function toArray(iterable:*):Array 
		{
			var ret:Array = [];
			for each (var elem:Class in iterable) ret.push(elem);
			return ret;
		}
		private var _endDelay:Boolean = false;
		private var _end_delay_id:uint;	
		private var _wrong_cnt:int = 0;
		private var _game_over:Boolean = false;
		public function endGame():void
		{
			_questionMode = false;
			clearTimeout(_end_game_id);
			_clicked_time = 0;
			
			for(var i:int = 0; i < _bmp_animal_question.length; i++)
			{
				_bmp_animal_question[i].removeEventListener(MouseEvent.CLICK, onAnimalClick);
				removeChild(_bmp_animal_question[i]);
				removeChild(_bmp_animal_bg[i]);
			}
			
			_endDelay = true;
			
			//정답검사.
			var correct_cnt:int = 0;
			for(i = 0; i < _user_answer.length; i++)
				for(var j:int = 0; _animal_order[j] != null; j++)
					if(_user_answer[i] == _animal_order[j])
						correct_cnt++;
			
			var answer_num:int = _game_level+1;
			if(answer_num > 7)	answer_num = 7;
			var type:Class = ((correct_cnt==answer_num)?O:X);
			if(_user_answer.length != (j))	type = X;
			
			
			showOX(type);
			if(type == X)
			{
				if(_wrong_cnt)
					_game_over = true;
				_game_level--;
				_wrong_cnt++;
			}
			else
				_wrong_cnt = 0;
			
			if(_game_level == GAME_LENGTH)
				_game_over = true;
		}
		private var isComplete:Boolean = false;
		private var _test_level:Object = new Object;
		private var _test_type:Object = new Object;
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
				params.user_seq = Brain.UserInfo.user_seq;
				params.child_seq = Brain.UserInfo.child_seq;
				params.test_id = "004";
				params.test_level = "";
				params.test_type = "";
				
				for(var i:int = 0; i < _game_cnt; i++)
				{
					params.test_level = params.test_level + _test_level[i] + "%";
					params.test_type = params.test_type + _test_type[i] + "%";
				}
				
				//Brain.Main.setPage("brainGameResultPage", null, BrainPageEffect.LEFT, BrainPageEffect.LEFT);
				Brain.Connection.post("cognitiveGameAction4.cog", params, onLoadComplete);
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
				
				result.j_gameResultModelO.index1 = String(_game_level)+"개";
				
				var intIndex2:Number = ((_game_level)/(GAME_LENGTH)) * 100 ;
				result.j_gameResultModelO.index2 = intIndex2.toFixed(2) +"%";
				result.j_gameResultModelO.correct_point = String(_game_level);
				
				//result.j_gameResultModelO.index2 = String((cnt)/(_total_game_index))+"%";
				Brain.Main.setPage("brainGameResultPage", result.j_gameResultModelO, BrainPageEffect.LEFT, BrainPageEffect.LEFT);
				
				return;
			}
			
			new Alert("데이터 저장 실패.").show();
		}
		private var _tween_alpha:Tween;
		[Embed(source = "assets/page/game/index/O.png")]
		private static const O:Class;
		[Embed(source = "assets/page/game/index/X.png")]
		private static const X:Class;
		private var _bmp_state:Bitmap;
		private function showOX(cls:Class):void
		{
			if(_bmp_state)	removeChild(_bmp_state);
			_bmp_state = new cls;
			_bmp_state.smoothing = true;   _bmp_state.alpha = 0;
			_bmp_state.x = Brain.Main.PageWidth/2 - _bmp_state.width/2;
			_bmp_state.y = 480 - _bmp_state.height/2;
			addChild(_bmp_state);
			FadeTween();
			
			_effect = new Sound();
			_effect.addEventListener(IOErrorEvent.IO_ERROR, isError);
			_effect.addEventListener(Event.COMPLETE, onSoundLoaded);
			if(cls == O)
			{
				_effect.load(new URLRequest("sound/correct.mp3"));
				_test_type[_game_cnt-1] = "1";
				_test_level[_game_cnt-1] = _game_level;
			}
			else
			{
				_effect.load(new URLRequest("sound/wrong.mp3"));
				_test_type[_game_cnt-1] = "0";
				_test_level[_game_cnt-1] = _game_level;
			}
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
		private static const FADE_IN:Number = 300;
		private static const FADE_OUT:Number = 300;
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
							clearTimeout(_end_delay_id);
							_end_delay_id = setTimeout(EndDelay, 1000);
							if(_game_over) gameOver();
						}
					});
				}
			});
		}
		private function EndDelay():void
		{
			clearTimeout(_end_delay_id);
			_endDelay = false;
			
			_game_level++;
			_game_index = 0;
			_game_start = true;
			MakeOrder();
		}
		public function startTimer():void
		{
			_blink_timer.removeEventListener(TimerEvent.TIMER, blinkTimer);
			_btn_quit.addEventListener(MouseEvent.CLICK, quitClicked);
			removeChild(_bmp_point);
			
			_game_start = true;
		}
		public function quitClicked(e:MouseEvent):void
		{
			//팝업
			Brain.Main.showPopup(new CancelGamePopup(popupClicked));
			clearTimeout(_end_turn_id);
			clearTimeout(_end_game_id);
			clearTimeout(_end_delay_id);
			clearTimeout(__delay_id);
		}
		private function popupClicked(value:Boolean):void
		{
			if(value)
			{
				if(_animal_sound) _animal_sound.removeEventListener(Event.COMPLETE, onAnimalSoundLoaded);
				Brain.Main.setPage("brainGameIndexPage", null, BrainPageEffect.RIGHT, BrainPageEffect.RIGHT);
			}
			Brain.Main.closePopup();
			
			if(isDelayMode)
			{
				if(200-_tick_time.currentCount > 0) 
					_end_turn_id = (endTurn, 200-_tick_time.currentCount);
				else
					_end_turn_id = setTimeout(endTurn, 200);
			}
			else
			{
				if(_questionMode)
				{
					if(10000-_tick_time.currentCount > 0) 
						_end_game_id = setTimeout(endGame, 10000-_tick_time.currentCount);
					else
						_end_game_id = setTimeout(endGame, 10000);
				}
				else if(_endDelay)
				{
					if(1000-_tick_time.currentCount > 0) 
						_end_delay_id = setTimeout(EndDelay, 1000-_tick_time.currentCount);
					else
						_end_delay_id = setTimeout(EndDelay, 1000);	
				}
				else
				{
					if(800-_tick_time.currentCount > 0) 
						__delay_id = setTimeout(delay, 800-_tick_time.currentCount);
					else
						__delay_id = setTimeout(delay, 800);	
				}
			}
			
			if(value)
			{
				clearTimeout(_end_turn_id);
				clearTimeout(_end_game_id);
				clearTimeout(_end_delay_id);
				clearTimeout(__delay_id);
			}
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
			clearTimeout(_end_turn_id);
			clearTimeout(_end_game_id);
			clearTimeout(_end_delay_id);
			clearTimeout(__delay_id);
			
			removeEventListener(Event.ENTER_FRAME, EnterFrame);
			
			clearTimeout(_end_game_id);
		}
	}
}