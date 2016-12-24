package Page.Account
{
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLVariables;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import Page.BasePage;
	
	import co.uk.mikestead.net.URLFileVariable;
	
	import flashx.textLayout.formats.Float;
	
	import kr.pe.hs.ui.TabbedButton;
	
	public class SetPassword extends BasePage
	{
		[Embed(source = "assets/top_menu/button_prev.png")]
		private var BUTTON_PREV:Class;
		
		[Embed(source = "assets/page/account/set_password/title.png")]
		private var TITLE:Class;
		
		[Embed(source = "assets/page/account/set_password/touch_field.png")]
		private var TOUCH_FIELD:Class;
		private var _bmp_touch_field:Bitmap;
		
		[Embed(source = "assets/page/account/set_password/password_field.png")]
		private var PASSWORD_FIELD:Class;
		private var _bmp_password_field:Bitmap;
		
		[Embed(source = "assets/page/account/set_password/selected.png")]
		private var SELECTED:Class;
		private var _bmp_selected:Bitmap;
		
		private var _txt_main:TextField;
		
		private var _txt_number:Vector.<TextField>;
		private var _txt_cancle:TextField;
		private var _selected_item:int;
		
		private var _txt_password:Vector.<TextField>;
		private static var _brain_password:String;
		private var _cur_password:int;
		private var _check_password:String;
		private var _first_password:String;
		private static var _second_password:String;
		private var _is_first_time:Boolean;
		private var _have_password:Boolean;
		
		private var _scaled_height:Number;
		public static function loadEnviroment():void
		{
			//return;
			var appStorage:File=File.applicationStorageDirectory;
			var dbFile:File = appStorage.resolvePath("Password.db");
			if(dbFile.exists)
			{
				var fs:FileStream=new FileStream;
				fs.open(dbFile,FileMode.READ);
				var result:Object=JSON.parse(fs.readUTF());
				fs.close();
				
				_brain_password = String(result);
			}
		}
		
		public static function saveEnviroment():void
		{
			var appStorage:File = File.applicationStorageDirectory;
			var dbFile:File = appStorage.resolvePath("Password.db");
			var fs:FileStream=new FileStream;
			fs.open(dbFile,FileMode.WRITE);
			fs.writeUTF(JSON.stringify(_second_password));
			fs.close();
		}
		public function SetPassword()
		{
			super();
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, onTouch);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onTouch);
			this.addEventListener(MouseEvent.MOUSE_UP  , onTouchUp);
			loadEnviroment();
			
			//Top Menu Control
			Brain.Main.TopMenu.clearAddedChild();
			Brain.Main.TopMenuVisible = true;
			//title
			var bmp:Bitmap = new TITLE;
			bmp.smoothing=true;
			Brain.Main.TopMenu.Title=bmp;
			//left menu
			bmp = new BUTTON_PREV;
			bmp.smoothing = true;
			var bmp_on:Bitmap = new BUTTON_PREV;
			bmp_on.smoothing = true;
			bmp_on.alpha = 0.6;
			var btn_left_top:TabbedButton = new TabbedButton(bmp, bmp_on, bmp_on);
			Brain.Main.TopMenu.LeftButton = btn_left_top;
			Brain.Main.TopMenu.LeftButton.addEventListener(MouseEvent.CLICK, prevClicked);
			
			//bg
			//			_bmp_bg = new BG;
			//			_bmp_bg.smoothing = true;
			//			_bmp_bg.x = 0;
			//			_bmp_bg.y = 0-75;
			//			addChild(_bmp_bg);
			
			//touch_field
			_bmp_touch_field = new TOUCH_FIELD;
			_bmp_touch_field.smoothing = true;
			_bmp_touch_field.x = 0;
			_bmp_touch_field.y = 521-Brain.TopMenuHeight-35.5;
			addChild(_bmp_touch_field);	
			
			//password_field
			_bmp_password_field = new PASSWORD_FIELD;
			_bmp_password_field.smoothing = true;
			_bmp_password_field.x = 76;
			_bmp_password_field.y = 299-Brain.TopMenuHeight-35.5;
			addChild(_bmp_password_field);
			
			//selected
			_bmp_selected = new SELECTED;
			_bmp_selected.smoothing = true;
			_bmp_selected.x = 0;
			_bmp_selected.y = 0-Brain.TopMenuHeight-35.5;
			_bmp_selected.visible = false;
			addChild(_bmp_selected);
			
			//txt
			
			_txt_main = new TextField;
			_txt_main.type = TextFieldType.DYNAMIC;
			_txt_main.x = 0; _txt_main.y = 217-Brain.TopMenuHeight-35.5; _txt_main.width = 540; _txt_main.height = 29.81;
			var fmt:TextFormat = new TextFormat;
			fmt = _txt_main.defaultTextFormat; fmt.font = "Main"; fmt.color = 0x595959; fmt.size = _txt_main.height/1.3; fmt.align = TextFormatAlign.CENTER; _txt_main.defaultTextFormat = fmt;
			_txt_main.embedFonts = true;
			_txt_main.antiAliasType = AntiAliasType.ADVANCED;
			_have_password = _brain_password ? true : false;
			if(_have_password)
			{
				_txt_main.text = "현재의 암호를 입력해 주세요.";
				_check_password = "";
			}
			else
				_txt_main.text = "새로운 암호를 입력해주세요.";
			addChild(_txt_main);
			
			_txt_number = new Vector.<TextField>;
			var index:int = 1;
			
			for(var i:int = 0; i < 3; i++)
			{
				for(var j:int = 0; j < 3; j++)		//9까지만 출력.
				{
					txt = new TextField;
					txt.type = TextFieldType.DYNAMIC;
					txt.x = 180*j; txt.y = 560+111*i-Brain.TopMenuHeight-35.5; txt.width = 180; txt.height = 110;
					fmt = new TextFormat;
					fmt = txt.defaultTextFormat; fmt.font = "Main"; fmt.color = 0xffffff; fmt.size = 26.63; fmt.align = TextFormatAlign.CENTER;
					txt.defaultTextFormat = fmt;
					txt.alpha = 0.6;
					txt.embedFonts = true;
					txt.antiAliasType = AntiAliasType.ADVANCED;
					txt.text = String(index);
					_txt_number.push(txt);
					addChild(_txt_number[index-1]);
					index++;
				}
			}
			var txt:TextField = new TextField;
			txt.type = TextFieldType.DYNAMIC;
			txt.x = 180; txt.y = 892-Brain.TopMenuHeight-35.5; txt.width = 180; txt.height = 34.62;
			fmt = new TextFormat;
			fmt = txt.defaultTextFormat; fmt.font = "Main"; fmt.color = 0xffffff; fmt.size = txt.height/1.3; fmt.align = TextFormatAlign.CENTER;
			txt.defaultTextFormat = fmt;
			txt.alpha = 0.6;
			txt.embedFonts = true;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.text = "0";
			_txt_number.push(txt);
			addChild(_txt_number[9]);
			
			_txt_cancle = new TextField;
			_txt_cancle.type = TextFieldType.DYNAMIC;
			_txt_cancle.x = 360; _txt_cancle.y = 892-Brain.TopMenuHeight-35.5; _txt_cancle.width = 180; _txt_cancle.height = 34.62;
			fmt = new TextFormat;
			fmt = _txt_cancle.defaultTextFormat; fmt.font = "Main"; fmt.color = 0xffffff; fmt.size = _txt_cancle.height/1.3; fmt.align = TextFormatAlign.CENTER;
			_txt_cancle.defaultTextFormat = fmt;
			_txt_cancle.alpha = 0.6;
			_txt_cancle.embedFonts = true;
			_txt_cancle.antiAliasType = AntiAliasType.ADVANCED;
			_txt_cancle.text = "취소";
			addChild(_txt_cancle);
			
			//password
			_txt_password = new Vector.<TextField>;
			
			//resizing
			bgResize();
			
			//initialize
			_selected_item = -1;
			_first_password = "";
			_second_password = "";
			_cur_password = 0;
			_is_first_time = true;
		}
		
		private function prevClicked(e:MouseEvent):void
		{
			Brain.Main.setPage("brainAccountInfoPage",null,BrainPageEffect.RIGHT,BrainPageEffect.RIGHT);
		}
		
		private function onTouch(e:MouseEvent):void
		{
			_selected_item = touchedIndex(this.mouseX, this.mouseY);
			var row:int = _selected_item/3;
			var col:int = _selected_item%3;
			if(row != 3 || col != 0)
			{
				_bmp_selected.x = 180*col+col;
				_bmp_selected.y = _bmp_touch_field.y+_bmp_selected.height*row+row+1;
				_bmp_selected.visible = true;
			}
		}
		
		private function onTouchUp(e:MouseEvent):void
		{
			_selected_item = touchedIndex(this.mouseX, this.mouseY);
			var row:int = _selected_item/3;
			var col:int = _selected_item%3;
			
			//_selected_item이 마우스 땐 곳 위치랑 다르면 입력하게 처리.
			_bmp_selected.visible = false;
			
			if(_selected_item != -1)
			{
				//지우는코드.
				if(row == 3 && col == 2)
				{
					if(_cur_password > 0)
					{
						removeChild(_txt_password[_cur_password-1]);
						_txt_password.pop();
						_cur_password--;
					}
					else
					{
						Brain.Main.setPage("brainAccountInfoPage",null,BrainPageEffect.RIGHT,BrainPageEffect.RIGHT);
					}
				}
				else if(row != 3 || col != 0)
				{
					//무슨 숫자 선택했는지.
					_selected_item++;
					if(_selected_item == 11)
						_selected_item = 0;
					
					if(!_have_password)
					{
						if(_is_first_time)
							_first_password = _first_password+_selected_item;
						else
							_second_password = _second_password+_selected_item;
					}
					else
						_check_password = _check_password+_selected_item;
					
					var txt:TextField = new TextField;
					txt.type = TextFieldType.DYNAMIC;
					txt.x = _bmp_password_field.x+_cur_password*100; txt.y = _bmp_password_field.y+11; txt.width = 86; txt.height = 86*0.9;
					var fmt:TextFormat = new TextFormat;
					fmt = txt.defaultTextFormat; fmt.font = "Main"; fmt.color = 0x525252; fmt.size = txt.height/1.3; fmt.align = TextFormatAlign.CENTER;
					txt.defaultTextFormat = fmt;
					txt.embedFonts = true;
					txt.antiAliasType = AntiAliasType.ADVANCED;
					txt.text = String(_selected_item);
					_txt_password.push(txt);
					addChild(_txt_password[_cur_password]);
					
					for(var i:int = 0; i < _cur_password; i++)
						_txt_password[i].text = "●";
					
					if(_cur_password == 3)
					{
						//띄운 메인텍스트 바꿔주고 _txt_password초기화해주고 첫번째 입력한 암호 저장해주고
						if(_have_password)
						{
							if(_check_password == _brain_password)
							{
								_txt_main.text = "새로운 암호를 입력해주세요.";
								for( _cur_password; _cur_password >= 0; _cur_password--)
								{
									removeChild(_txt_password[_cur_password]);
									_txt_password.pop();
								}
								_have_password = false;
							}
							else
							{
								//다시입력하라고 띄우고 첨으로
								new Alert("입력한 비밀번호가 다릅니다.").show();
								for( _cur_password; _cur_password >= 0; _cur_password--)
								{
									removeChild(_txt_password[_cur_password]);
									_txt_password.pop();
								}
								_check_password = "";
							}
						}
						else
						{
							if(_is_first_time)
							{
								_txt_main.text = "입력한 암호를 확인해주세요.";
								for( _cur_password; _cur_password >= 0; _cur_password--)
								{
									removeChild(_txt_password[_cur_password]);
									_txt_password.pop();
								}
								_is_first_time = false;
							}
							else
							{
								if(_first_password == _second_password)
								{
									saveEnviroment();
									Brain.Main.setPage("brainAccountInfoPage",null,BrainPageEffect.RIGHT,BrainPageEffect.RIGHT);
								}
								else
								{
									//다시입력하라고 띄우고 첨으로
									new Alert("입력한 비밀번호가 다릅니다.").show();
									for( _cur_password; _cur_password >= 0; _cur_password--)
									{
										removeChild(_txt_password[_cur_password]);
										_txt_password.pop();
									}
									_second_password = "";
								}
							}
						}
					}
					_cur_password++;
				}
			}
		}
		private function touchedIndex(x:int, y:int):int
		{
			var index:int = 0;
			for(var i:int = 0; i < 4; i++)
			{
				for(var j:int = 0; j < 3; j++)
				{
					if(180*j <= x && 180*(j+1) >= x && 
						(521+109.75*i-Brain.TopMenuHeight-35.5)-_scaled_height <= y && (521+109.75*(i+1)-_scaled_height-Brain.TopMenuHeight-35.5) >= y)
						return index;
					index++;
				}
			}
			
			return -1;
		}
		private function submit_onClick(e:MouseEvent):void
		{
			if(Brain.Main.TopMenu.alpha == 1.0)
				Brain.Main.setPage("brainAccountInfoPage",null,BrainPageEffect.RIGHT,BrainPageEffect.RIGHT);
		}
		
		private function bgResize():void
		{
			var touch_field_view_height:Number = Brain.Main.PageHeight - _bmp_touch_field.height;
			_scaled_height = _bmp_touch_field.y - touch_field_view_height;
			_bmp_touch_field.y = touch_field_view_height;
			
			_bmp_password_field.y = _bmp_password_field.y - _scaled_height/2;
			_txt_main.y = _txt_main.y - _scaled_height/2;
			
			for(var i:int = 0; i < 10; i++)
				_txt_number[i].y = _txt_number[i].y - _scaled_height;
			_txt_cancle.y = _txt_cancle.y - _scaled_height;
		}
		
		public override function onResize():void
		{
			
		}
		
		public override function dispose():void
		{
			Brain.Main.TopMenu.LeftButton.removeEventListener(MouseEvent.CLICK, prevClicked);

			this.removeEventListener(MouseEvent.MOUSE_DOWN, onTouch);
			this.removeEventListener(MouseEvent.MOUSE_MOVE, onTouch);
			this.removeEventListener(MouseEvent.MOUSE_UP  , onTouchUp);
		}
	}
}

