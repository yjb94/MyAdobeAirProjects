package Page.Home
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.RadioButton;
	import Displays.Text;
	
	import Footer.TabBar;
	
	import Header.Header;
	import Header.NavigationBar;
	import Header.TabBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	import Page.Home.Tabs.PrevItem;
	
	import Scroll.Scroll;
	
	public class Register extends BasePage
	{
		private const ANCHOR_TWEEN_DURATION:Number = 0.3;
		private const BASE_Y_INTERVAL:Number = 30;
		
		private var _project_data:Object;
		
		private var _display:Scroll;
		
		private var _project_info_spr:Sprite = new Sprite;
		
		private var _buyer_info_spr:Sprite = new Sprite;

		private var _reserver_info_spr:Sprite = new Sprite;
		
		private var _register_type_radiobtn:RadioButton;
		
		private var _coupon_spr:Sprite = new Sprite;
		
		private var _policy_agree:Button;
		private var _policy_display:Button;
		
		private var _finish:Button
		
		public function Register(params:Object=null)
		{
			super();
			_project_data = params.model;
			
			_display = new Scroll();
			addChild(_display);
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = Text.newText("주문/결제", 26, 0xffffff);
			(Elever.Main.footer.getChildByName("TabBar") as Footer.TabBar).disable = true;
			
			//여기 아래있는 모든 좌표같은건 임의로 넣은거임.
			
			//_project_info_spr init
				//thumbnail
			var mask:Bitmap = BitmapControl.newBitmap(BitmapControl.TEMP_NO_IMAGE, 0, 0);
			_project_info_spr.addChild(mask);
			loadImage(_project_data.gathering_sub_image, _project_info_spr, mask);
				//name
			var txt:TextField = Text.newText(_project_data.gathering_name, 19, 0x000000, 100, mask.height + 50);
			_project_info_spr.addChild(txt);
				//date
			txt = Text.newText(_project_data.gathering_ymd, 19, 0x000000, txt.x, txt.y + 50);
			_project_info_spr.addChild(txt);
				//time
			txt = Text.newText(_project_data.gathering_start_time + _project_data.gathering_end_time, 19, 0x000000, txt.x, txt.y + 50);
			_project_info_spr.addChild(txt);
//				//num - 이건 이전 페이지에서 넘겨받을것
			txt = Text.newText(params.member, 19, 0x000000, txt.x, txt.y + 50);
			txt.name = "Member";
			_project_info_spr.addChild(txt);
			
			_display.addObject(_project_info_spr);
			
			//_buyer_info_spr init
				//name
			txt = Text.newText(Elever.UserInfo.user_name, 19, 0x000000, txt.x, txt.y + 100);
			_buyer_info_spr.addChild(txt);
				//phoneno
			txt = Text.newText(Elever.UserInfo.user_phoneno, 19, 0x000000, txt.x, txt.y + 50);
			_buyer_info_spr.addChild(txt);
				//email
			txt = Text.newText(Elever.UserInfo.user_email, 19, 0x000000, txt.x, txt.y + 50);
			_buyer_info_spr.addChild(txt);
			
			_display.addObject(_buyer_info_spr);
			
			//_reserver_info_spr init
				//reserver type tab button
			var btn:Button = new Button(BitmapControl.TEMP_BUTTON_UP, BitmapControl.TEMP_BUTTON_DOWN, onReserverTypeTabbed, 0, 0, false, true);
			btn.x = txt.x; btn.y = txt.y + 100;
			btn.name = "Button";
			_reserver_info_spr.addChild(btn);
				//name inputtextbox
			var obj:Object = Text.newInputTextbox(BitmapControl.TEXTFIELD, 24, "", 0x000000, btn.x, btn.y + 100);
			(obj.txt as TextField).name = "Name";
			(obj.txt as TextField).addEventListener(MouseEvent.CLICK, onClickInputText);
			(obj.txt as TextField).addEventListener(FocusEvent.FOCUS_OUT, onFocusInputText);
			_reserver_info_spr.addChild(obj.bmp); _reserver_info_spr.addChild(obj.txt);
				//phonenum inputtextbox
			obj = Text.newInputTextbox(BitmapControl.TEXTFIELD, 24, "", 0x000000, obj.bmp.x, obj.bmp.y + 80);
			(obj.txt as TextField).name = "PhoneNumber";
			(obj.txt as TextField).addEventListener(MouseEvent.CLICK, onClickInputText);
			(obj.txt as TextField).addEventListener(FocusEvent.FOCUS_OUT, onFocusInputText);
			_reserver_info_spr.addChild(obj.bmp); _reserver_info_spr.addChild(obj.txt);
				//email inputtextbox
			obj = Text.newInputTextbox(BitmapControl.TEXTFIELD, 24, "", 0x000000, obj.bmp.x, obj.bmp.y + 80);
			(obj.txt as TextField).name = "Email";
			(obj.txt as TextField).addEventListener(MouseEvent.CLICK, onClickInputText);
			(obj.txt as TextField).addEventListener(FocusEvent.FOCUS_OUT, onFocusInputText);
			_reserver_info_spr.addChild(obj.bmp); _reserver_info_spr.addChild(obj.txt);
			
			setReserverText(Elever.UserInfo.user_name, Elever.UserInfo.user_phoneno, Elever.UserInfo.user_email);
			
			_display.addObject(_reserver_info_spr);
			
			//_register_type_radiobtn init
			_register_type_radiobtn = new RadioButton();
			_register_type_radiobtn.addButton(BitmapControl.TEMP_BUTTON_UP, BitmapControl.TEMP_BUTTON_DOWN);
			_register_type_radiobtn.addButton(BitmapControl.TEMP_BUTTON_UP, BitmapControl.TEMP_BUTTON_DOWN);
			_register_type_radiobtn.addButton(BitmapControl.TEMP_BUTTON_UP, BitmapControl.TEMP_BUTTON_DOWN);
			_register_type_radiobtn.x = obj.bmp.x;
			_register_type_radiobtn.y = obj.bmp.y + 120;
			_register_type_radiobtn.Tab = 2;
			
			_display.addObject(_register_type_radiobtn);
			
			//coupon inputtextbox
			obj = Text.newInputTextbox(BitmapControl.TEXTFIELD, 24, "", 0x000000, _register_type_radiobtn.x, _register_type_radiobtn.y + _register_type_radiobtn.height + 20);
			(obj.txt as TextField).name = "Coupon";
			(obj.txt as TextField).addEventListener(MouseEvent.CLICK, onClickInputText);
			(obj.txt as TextField).addEventListener(FocusEvent.FOCUS_OUT, onFocusInputText);
			_coupon_spr.addChild(obj.bmp); _coupon_spr.addChild(obj.txt);
			
			_display.addObject(_coupon_spr);
			
			//policy agree button
			_policy_agree = new Button(BitmapControl.TEMP_BUTTON_UP, BitmapControl.TEMP_BUTTON_DOWN, null, 0,0,false, true);
			_policy_agree.x = 20;
			_policy_agree.y = obj.bmp.y + obj.bmp.height + 100;
			_display.addObject(_policy_agree);
			
			//policy display button
			_policy_display = new Button(BitmapControl.TEMP_BUTTON_UP, BitmapControl.TEMP_BUTTON_DOWN, onPolicyDisplay);
			_policy_display.x = _policy_agree.x + _policy_agree.width + 20;
			_policy_display.y = _policy_agree.y;
			_display.addObject(_policy_display);
			
			//finish join button
			_finish = new Button(BitmapControl.TEMP_BUTTON_UP, BitmapControl.TEMP_BUTTON_DOWN, onFinish);
			_finish.x = Elever.Main.PageWidth/2 - _finish.width/2;
			_finish.y = _policy_agree.y + _policy_agree.height + 50;
			_display.addObject(_finish);
			
		}
		private function onClickInputText(e:MouseEvent):void
		{
			if(e.type == MouseEvent.CLICK)
			{
				anchor(-(e.currentTarget as TextField).y - _display.scroller.getY() + BASE_Y_INTERVAL);
			}
		}
		private function onFocusInputText(e:FocusEvent):void
		{
			if(e.type == FocusEvent.FOCUS_OUT)
			{
				if(stage.focus == null)
					anchor(0);
			}
		}
		private function anchor(y:Number):void
		{
			TweenLite.to(_display, ANCHOR_TWEEN_DURATION, { y:y });
		}
		private function loadImage(url:String, base_spr:Sprite, mask:Bitmap):void
		{
			if(url == "" || url == null)
			{
				trace("Register error : load Image with no url");
				return;
			}
			
			var file:File = File.applicationStorageDirectory.resolvePath("Images/"+url);
			if(file.exists)
			{
				var bytes:ByteArray=new ByteArray;
				var stream:FileStream=new FileStream;
				stream.open(file, FileMode.READ);
				stream.readBytes(bytes);
				stream.close();
				
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void
				{
					var decodedBitmapData:BitmapData = Bitmap(e.target.content).bitmapData;
					var bmp:Bitmap = new Bitmap();
					bmp.bitmapData = decodedBitmapData;
					bmp.smoothing = true;
					bmp.width = mask.width;
					bmp.height = mask.height;
					if(bmp.scaleX > bmp.scaleY) bmp.scaleX = bmp.scaleY;
					else bmp.scaleY = bmp.scaleX;
					bmp.name = "Thumbnail";
					bmp.mask = mask;
					
					base_spr.addChildAt(bmp, 0);
				});
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void
				{
					Elever.Main.LoadingVisible = false;
				});
				loader.loadBytes(bytes);
			}
			else
				trace("Register error : url path no file in app directory error");
		}
		private function setReserverText(name:String, phoneno:String, email:String):void
		{
			var txt:TextField = _reserver_info_spr.getChildByName("Name") as TextField;
			txt.text = name;
			
			txt = _reserver_info_spr.getChildByName("PhoneNumber") as TextField;
			txt.text = phoneno;
			
			txt = _reserver_info_spr.getChildByName("Email") as TextField;
			txt.text = email;
		}
		
		private function onReserverTypeTabbed(e:MouseEvent):void
		{
			var btn:Button = _reserver_info_spr.getChildByName("Button") as Button;
			if(btn.isTabbed)
				setReserverText("","","");
			else
				setReserverText(Elever.UserInfo.user_name, Elever.UserInfo.user_phoneno, Elever.UserInfo.user_email);
		}
		private function onPolicyDisplay(e:MouseEvent):void
		{
			
		}
		private function onFinish(e:MouseEvent):void
		{
			if(isOktoFinish())
			{
				var params:URLVariables = new URLVariables;
				params.user_seq = Elever.UserInfo.user_seq;
				params.gathering_seq = _project_data.gathering_seq;
				params.user_name = (_reserver_info_spr.getChildByName("Name") as TextField).text;
				params.user_phoneno = (_reserver_info_spr.getChildByName("PhoneNumber") as TextField).text;
				params.user_email = (_reserver_info_spr.getChildByName("Email") as TextField).text;
				params.member = (_project_info_spr.getChildByName("Member") as TextField).text;
				var account_way:int = _register_type_radiobtn.Tab+1;
				if(account_way == 1)	account_way = 0;	//무통장입금
				params.account_way = account_way;
				params.coupon_seq = (_coupon_spr.getChildByName("Coupon") as TextField).text;
				Elever.Main.LoadingVisible = true;
				Elever.Connection.post("Gatheringcommit", params, onLoadComplete);
			}
		}
		private function onLoadComplete(data:String):void
		{
			Elever.Main.LoadingVisible = false;
			
			if(data)
			{
				var result:Object = JSON.parse(data);
				
				if(result.isCheck)
					trace("Register Complete");
				else
					trace("Register error : Failed to register");
				
				var params:URLVariables = new URLVariables;
				params.user_seq = Elever.UserInfo.user_seq;
				Elever.Main.LoadingVisible = true;
				Elever.Connection.post("Myticket", params, function(data:String):void
				{
					Elever.Main.LoadingVisible = false;
					Elever.saveEnviroment("ticket.db", JSON.parse(data));
					Elever.Main.changePage("HomePage");
				});
			}
		}
		private function isOktoFinish():Boolean
		{
			if(_policy_agree.isTabbed == false)
			{
				trace("Join Error : Policy not agreed");
				return false;
			}
			
			if((_reserver_info_spr.getChildByName("Name") as TextField).text.length == 0) return false;
			
			var txt:String = (_reserver_info_spr.getChildByName("PhoneNumber") as TextField).text.split("-").join("");
			if(txt.length != 11) return false;
			
			var emailPattern : RegExp = /^[0-9a-zA-Z][-._a-zA-Z0-9]*@([0-9a-zA-Z][-._0-9a-zA-Z]*\.)+[a-zA-Z]{2,4}$/;
			if((_reserver_info_spr.getChildByName("Email") as TextField).text.match(emailPattern) == null) return false;
			
			return true;
		}
		public override function init():void
		{
			_display.scroller.fold((Elever.Main.header.getChildByName("NavigationBar") as NavigationBar), 1);
		}
		public override function onResize():void
		{
		}
		
		public override function dispose():void
		{
			_display.scroller.resetFoldObj();
		}
	}
}
