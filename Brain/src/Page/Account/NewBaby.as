//brainAccountNotLoginPage
package Page.Account
{	
	import com.thanksmister.touchlist.controls.TouchList;
	import com.thanksmister.touchlist.renderers.DisplayObjectItemRenderer;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.RemoteNotificationEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLVariables;
	import flash.system.Capabilities;
	import flash.text.AntiAliasType;
	import flash.text.ReturnKeyLabel;
	import flash.text.SoftKeyboardType;
	import flash.text.StageText;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;
	
	import Page.BasePage;
	
	import kr.pe.hs.tween.Tween;
	import kr.pe.hs.ui.AppTextField;
	import kr.pe.hs.ui.TabbedButton;
	
	import pl.mateuszmackowiak.nativeANE.dialogs.NativeDatePickerDialog;
	import pl.mateuszmackowiak.nativeANE.events.NativeDialogEvent;
	
	public class NewBaby extends BasePage
	{
		[Embed(source = "assets/page/account/new_baby/title.png")]
		private static const TITLE:Class;
		
		[Embed(source = "assets/top_menu/button_prev.png")]
		private static const BUTTON_PREV:Class;
		
		[Embed(source = "assets/page/account/new_baby/button_next.png")]
		private static const BUTTON_NEXT:Class;
		
		[Embed(source = "assets/page/account/new_baby/button_male.png")]
		private static const BUTTON_MALE:Class;
		[Embed(source = "assets/page/account/new_baby/button_male_on.png")]
		private static const BUTTON_MALE_ON:Class;
		private var _btn_male:TabbedButton;
		
		[Embed(source = "assets/page/account/new_baby/button_female.png")]
		private static const BUTTON_FEMALE:Class;
		[Embed(source = "assets/page/account/new_baby/button_female_on.png")]
		private static const BUTTON_FEMALE_ON:Class;
		private var _btn_female:TabbedButton;
		
		[Embed(source = "assets/page/account/new_baby/name.png")]
		private static const NAME:Class;
		[Embed(source = "assets/page/account/new_baby/birthyear.png")]
		private static const BIRTHYEAR:Class;
		[Embed(source = "assets/page/account/new_baby/gender.png")]
		private static const GENDER:Class;
		
		[Embed(source = "assets/page/account/join/textfield.png")]
		private static const TEXTFIELD:Class;
		private var _name_text:TextField;
		private var _birth_text:StageText;
		
		
		private var _currentTarget:DisplayObject;
		private var _dialogHeight:Number;
		
		public function NewBaby()
		{
			super();
			
			_dialogHeight = 0;
			
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
			var btn:TabbedButton = new TabbedButton(bmp, bmp_on, bmp_on);
			Brain.Main.TopMenu.LeftButton = btn;
			Brain.Main.TopMenu.LeftButton.addEventListener(MouseEvent.CLICK, prevClicked);
			//right menu
			bmp    = new BUTTON_NEXT;    bmp.smoothing = true;
			bmp_on = new BUTTON_NEXT; bmp_on.smoothing = true; bmp_on.alpha = 0.6;
			btn	   = new TabbedButton(bmp, bmp_on, bmp_on);
			Brain.Main.TopMenu.RightButton = btn;
			Brain.Main.TopMenu.RightButton.alpha = 0.6;
			Brain.Main.TopMenu.RightButton.addEventListener(MouseEvent.CLICK, nextClicked);
			
			
			//buttons
			bmp    = new BUTTON_MALE;    bmp.smoothing    = true;
			bmp_on = new BUTTON_MALE_ON; bmp_on.smoothing = true;
			_btn_male = new TabbedButton(bmp, bmp_on, bmp_on); _btn_male.x = 26; _btn_male.y = 425-Brain.TopMenuHeight;
			_btn_male.isTabbed = true;
			_btn_male.addEventListener(MouseEvent.CLICK, maleClicked); addChild(_btn_male);
			
			bmp    = new BUTTON_FEMALE;    bmp.smoothing    = true;
			bmp_on = new BUTTON_FEMALE_ON; bmp_on.smoothing = true;
			_btn_female = new TabbedButton(bmp, bmp_on, bmp_on); _btn_female.x = 278; _btn_female.y = 425-Brain.TopMenuHeight;
			_btn_female.isTabbed = false;
			_btn_female.addEventListener(MouseEvent.CLICK, femaleClicked); addChild(_btn_female);
			
			//bgs
			bmp = new NAME; 	 bmp.smoothing=true; bmp.x = 45; bmp.y = 120-Brain.TopMenuHeight; addChild(bmp);
			bmp = new BIRTHYEAR; bmp.smoothing=true; bmp.x = 45; bmp.y = 252-Brain.TopMenuHeight; addChild(bmp);
			bmp = new GENDER;  	 bmp.smoothing=true; bmp.x = 45; bmp.y = 387-Brain.TopMenuHeight; addChild(bmp);
			
			//textfield			
			bmp = new TEXTFIELD; bmp.smoothing = true; bmp.x = 28; bmp.y = 154-Brain.TopMenuHeight; addChild(bmp);
			
			_name_text = new TextField;
			_name_text.type = TextFieldType.INPUT;
			_name_text.height = 32;
			var fmt:TextFormat = _name_text.defaultTextFormat; fmt.font = "Main"; fmt.size = _name_text.height/1.3; _name_text.defaultTextFormat = fmt;
			_name_text.embedFonts = true;
			_name_text.x = bmp.x + 10;
			_name_text.y = bmp.y + 12;
			_name_text.width = bmp.width - 20;
			_name_text.addEventListener(Event.CHANGE, isChanged);
			
			addChild(_name_text);
			
			bmp = new TEXTFIELD; bmp.smoothing = true; bmp.x = 28; bmp.y = 286-Brain.TopMenuHeight; addChild(bmp);
			
//			_birth_text = new TextField;
//			_birth_text.type=TextFieldType.DYNAMIC;
//			_birth_text.width = bmp.width - 20; _birth_text.height = 32; _birth_text.x = bmp.x + 10; _birth_text.y = bmp.y + 12;
//			fmt = _birth_text.defaultTextFormat; fmt.font="Arial"; fmt.size=_birth_text.height/1.3; fmt.align=TextFormatAlign.CENTER; _birth_text.defaultTextFormat=fmt;
//			_birth_text.antiAliasType = AntiAliasType.ADVANCED;
//			_birth_text.addEventListener(MouseEvent.CLICK, startDate_onFocus);
			
			_birth_text = new StageText;
			_birth_text.visible = true;
			_birth_text.returnKeyLabel=ReturnKeyLabel.NEXT;
			_birth_text.softKeyboardType=SoftKeyboardType.NUMBER;
			_birth_text.addEventListener(Event.CHANGE, isChanged);
			_birth_text.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE,onSoftkeyboard_birthyear);
			
			
		}
		private function prevClicked(e:MouseEvent):void
		{
			Brain.Main.setPage("brainAccountBabyManagePage", null, BrainPageEffect.RIGHT, BrainPageEffect.RIGHT);
		}
		private function nextClicked(e:MouseEvent):void
		{
			if(Brain.Main.TopMenu.RightButton.alpha == 1.0)
			{
				var params:URLVariables = new URLVariables;
				//			input 
				//			1. user_seq - 사용자번호
				//			2. child_name - 이름
				//			3. child_year : 태어난년도 4자리
				//			4. child_sex : 성별 1:남자, 2:여자
				//			5. child_pic : 사진, 미구현 
				params.user_seq = Brain.UserInfo.user_seq;
				params.child_name = _name_text.text;
				params.child_year = _birth_text.text;
				params.child_sex = _btn_male.isTabbed ? "1" : "2";
				//params.child_pic = "";
				
				Brain.Connection.post("childRegAction.cog", params, onLoadComplete);
			}
		}
		private function onLoadComplete(data:String):void
		{	
			if(data)
			{
				var result:Object = JSON.parse(data);
				
//				output
//				1. j_user_seq : 사용자번호
//				2. j_rep_childYn : 대표아동 유
//				2. j_child_seq : 아동번호
//				2. j_regYn : 등록유무
//				3. j_errorMsg : 에러메시지
				if(result.j_errorMsg.length>0)
				{
					new Alert(result.j_errorMsg).show();
					return;
				}
				
				if(result.j_regYn == "Y")
				{
					var params:Object = new Object;
					params.child_seq = result.j_child_seq;
					if(result.j_rep_childYn == "Y")
						Brain.UserInfo.child_seq = result.j_child_seq;
					Brain.saveEnviroment();
					Brain.Main.setPage("brainAccountNewBabyRegPage2", params);
				}
				else
				{
					new Alert("등록 실패.").show();
				}
				
				return;
			}
			
			new Alert("데이터 저장 실패.").show();
		}
		private function maleClicked(e:MouseEvent):void
		{
			if(_btn_male.isTabbed == false)
			{
				_btn_male.isTabbed = true;
				_btn_female.isTabbed = false;
			}
			checkNext();
		}
		private function femaleClicked(e:MouseEvent):void
		{
			if(_btn_female.isTabbed == false)
			{
				_btn_male.isTabbed = false;
				_btn_female.isTabbed = true;
			}
			checkNext();
		}
		private function isChanged(e:Event):void
		{
			if(_birth_text.text.length >= 4)
			{
				_birth_text.text = _birth_text.text.substr(0,4);
			}
			checkNext();
		}
		private function checkNext():void
		{
			if(_name_text.text.length  == 0 || _birth_text.text.length != 4)
			{
				Brain.Main.TopMenu.RightButton.alpha = 0.3;
				return;
			}
			
			Brain.Main.TopMenu.RightButton.alpha = 1.0;
		}
		
		private function onSoftkeyboard_birthyear(e:Event):void
		{
			if(e.type == SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE)
			{
				
			}
		}
		public override function onResize():void
		{	
			var g_pt:Point = this.localToGlobal(new Point(28 + 10, 286-Brain.TopMenuHeight + 12));
			var g_size:Point = this.localToGlobal(new Point(486-20, 32));	//width랑 height인데 height는 폰트 때문에 안씀.
		
			var rect:Rectangle;
			rect = _birth_text.viewPort;
			rect.width = g_size.x;
			rect.height = 32*1.2;
			rect.x = g_pt.x;
			rect.y = g_pt.y;
			_birth_text.stage = stage;
			_birth_text.viewPort = rect;
			_birth_text.fontSize = _birth_text.viewPort.height/1.2;
		}
		
		public override function dispose():void
		{
			Brain.Main.TopMenu.LeftButton.removeEventListener(MouseEvent.CLICK, prevClicked);
			Brain.Main.TopMenu.RightButton.removeEventListener(MouseEvent.CLICK, nextClicked);
			
			_btn_male.removeEventListener(MouseEvent.CLICK, maleClicked);
			_btn_male = null;
			
			_btn_female.removeEventListener(MouseEvent.CLICK, femaleClicked);
			_btn_female = null;
			
			_birth_text.stage=null;
			_birth_text.dispose();
			_birth_text=null;
			//_birth_text.removeEventListener(MouseEvent.CLICK, startDate_onFocus);
			//_birth_text = null;
		}
	}
}
