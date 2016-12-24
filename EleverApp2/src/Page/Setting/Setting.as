package Page.Setting
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.Text;
	
	import Header.Header;
	import Header.NavigationBar;
	import Header.SlideBar;
	import Header.TabBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	
	import Scroll.Scroll;
	
	public class Setting extends BasePage
	{
		private const TOUCH_SENSITIVE:Number = 15;
		private const LEFT_MARGIN:Number = 50;
		private const TEXT_MARGIN:Number = 10;
		private const RIGHT_MARGIN:Number = 50;
		private const FONT_SIZE:Number = 27;
		
		private const SPRITE_LEFT_MARGIN:Number = 12;
		private const ITEM_FIRST_MARGIN:Number = 19;
		private const ITEM_SMALL_MARGIN:Number = 5;
		private const ITEM_BIG_MARGIN:Number = 31;
		
		private var _displays:Scroll;
		
		//temp
		private var _temp_scroll:Scroll; 
		
		private var _item_spr_vector:Vector.<Sprite> = new Vector.<Sprite>;
		private var _item_func_dict:Dictionary = new Dictionary;
		
		private var _login_info_btn:Button;
		private var _purchase_btn:Button;
		private var _push_setting_btn:Button;
		private var _client_center_btn:Button;
		private var _auto_login_btn:Button;
		
		private var _downPos:Point = new Point;
		
		public function Setting(params:Object=null)
		{
			super();
			
			if(params) _displays = new Scroll(true, -1, -1, -1, params.y);
			else	   _displays = new Scroll();
			addChild(_displays);
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).clearPrev();
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = Text.newText("내정보", 26, 0xffffff);
			
			//LoginInfo
			var login_spr:Sprite = new Sprite;
			var txt:TextField = Text.newText("", FONT_SIZE, 0xdd5858);
			if(Elever.UserInfo) txt.text = Elever.UserInfo.user_name;
			login_spr.addChild(txt);
			_login_info_btn = new Button(BitmapControl.SETTING_NEXT_BUTTON, BitmapControl.SETTING_NEXT_BUTTON, null);
			_login_info_btn.x = txt.x + txt.width + TEXT_MARGIN;
			txt.y = _login_info_btn.height/2 - txt.height/2;
			login_spr.addChild(_login_info_btn);
			_displays.addObject(addItem("LoginInfo", 87, 
			{
				left:Text.newText("로그인 정보", FONT_SIZE),
				right:login_spr,
				func:function():void
				{
					Elever.Main.changePage("LoginInfoPage");
				}
			}));
			
			//Purchase
			_purchase_btn = new Button(BitmapControl.SETTING_NEXT_BUTTON, BitmapControl.SETTING_NEXT_BUTTON);
			_displays.addObject(addItem("Purchase", 87, 
			{
				left:Text.newText("구매 내역", FONT_SIZE), 
				right:_purchase_btn,
				func:function():void
				{
					Elever.Main.changePage("PurchasePage");
				}
			}));
			
			//AutoLogin
			_auto_login_btn = new Button(BitmapControl.SETTING_ON_BUTTON, BitmapControl.SETTING_OFF_BUTTON, null, 0, 0, false, true);
			var result:Object = Elever.loadEnviroment("AutoLogin.db", _auto_login_btn.isTabbed);
			_auto_login_btn.isTabbed = (result == null) ? true : result;
			_displays.addObject(addItem("AutoLogin", 87, 
			{ 
				left:Text.newText("자동 로그인", FONT_SIZE), 
				right:_auto_login_btn
			}));
			
			//PushSetting
			_push_setting_btn = new Button(BitmapControl.SETTING_ON_BUTTON, BitmapControl.SETTING_OFF_BUTTON, pushSettingTabbed, 0, 0, false, true);
			result = Elever.loadEnviroment("PushSetting.db", _push_setting_btn.isTabbed);
			_push_setting_btn.isTabbed = (result == null) ? true : result;
			_displays.addObject(addItem("PushSetting", 87, 
			{ 
				left:Text.newText("알림(Push) 설정", FONT_SIZE),
				right:_push_setting_btn
			}));
			
			//ClientCenter
			_client_center_btn = new Button(BitmapControl.SETTING_NEXT_BUTTON, BitmapControl.SETTING_NEXT_BUTTON);
			_displays.addObject(addItem("ClientCenter", 87, 
			{
				left:Text.newText("고객 센터", FONT_SIZE), 
				right:_client_center_btn,
				func:function():void
				{
					var u:URLRequest = new URLRequest("mailto:"+"nautilus@tiein.co.kr");
					var v:URLVariables = new URLVariables();
					v.subject = "";
					v.body = "";
					u.data = v;
					navigateToURL(u, "_self");
				} 
			}));
			
			//VersionInfo
			_displays.addObject(addItem("VersionInfo", 87, 
			{
				left:Text.newText("버전 정보", FONT_SIZE),
				right:Text.newText(Config.VERSION_NUMBER, FONT_SIZE) 
			}));
		}
		private function addItem(name:String, height:Number=87, obj:Object=null):Sprite
		{
			var spr:Sprite = new Sprite;
			
			//lines
			spr.graphics.beginFill(0xffffff);
			spr.graphics.drawRect(SPRITE_LEFT_MARGIN, 0, Elever.Main.FullWidth - SPRITE_LEFT_MARGIN*2, height);
			spr.graphics.endFill();
			
			//mouseEvent and pageControl.
			spr.addEventListener(MouseEvent.MOUSE_DOWN, onItemClick);
			spr.addEventListener(MouseEvent.MOUSE_UP, onItemClick);
			spr.name = name;
			
			//left and right displayObject control
			if(obj)
			{
				if(obj.left)
				{
					var left:DisplayObject = obj.left as DisplayObject;
					left.x = spr.x + LEFT_MARGIN;
					left.y = spr.y + spr.height/2 - left.height/2;
					spr.addChild(left);
				}
				if(obj.right)
				{
					var right:DisplayObject = obj.right as DisplayObject;
					right.x = spr.width - RIGHT_MARGIN - right.width;
					right.y = spr.y + spr.height/2 - right.height/2
					spr.addChild(right);
				}
				if(obj.func)
				{
					_item_func_dict[name] = obj.func;
				}
			}
			
			_item_spr_vector.push(spr);
			setItems();
			
			return spr;
		}
		private function setItems():void
		{
			_item_spr_vector[0].y = ITEM_FIRST_MARGIN;
			for(var i:int = 1; i < _item_spr_vector.length; i++)
			{
				_item_spr_vector[i].y = _item_spr_vector[i-1].y + _item_spr_vector[i-1].height
					+ (((i == 1) || (i == 3) || (i==5)) ? ITEM_BIG_MARGIN : ITEM_SMALL_MARGIN);
			}
		}
		private function onItemClick(e:MouseEvent=null):void
		{
			var spr:Sprite = _item_spr_vector[_item_spr_vector.indexOf(e.currentTarget as Sprite)];
			
			if(e.type == MouseEvent.MOUSE_DOWN)
			{
				_downPos.x = mouseX;
				_downPos.y = mouseY;
				
				if(spr.name == "LoginInfo")
					_login_info_btn.isTabbed = true;
				else if(spr.name == "ClientCenter")
					_client_center_btn.isTabbed = true;
				else if(spr.name == "Purchase")
					_purchase_btn.isTabbed = true;
				
				stage.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void
				{
					if(_login_info_btn.isTabbed)
						_login_info_btn.isTabbed = false;
					if(_client_center_btn.isTabbed)
						_client_center_btn.isTabbed = false;
					if(_purchase_btn.isTabbed)
						_purchase_btn.isTabbed = false;
				});
			}
			else if(e.type == MouseEvent.MOUSE_UP)
			{	
				if(Point.distance(_downPos, new Point(mouseX, mouseY)) > TOUCH_SENSITIVE)
					return;
				
				if(_item_func_dict[spr.name])
					_item_func_dict[spr.name]();
			}
		}
		private function pushSettingTabbed(e:MouseEvent=null):void
		{
			
		}
		public override function init():void
		{
			if(!(Elever.UserInfo && Elever.UserInfo.user_seq))
				Elever.Main.changePage("LoginPage");
		}
		
		public override function onResize():void
		{
		}
		
		public override function dispose():void
		{
			Elever.saveEnviroment("AutoLogin.db", _auto_login_btn.isTabbed);
			Elever.saveEnviroment("PushSetting.db", _push_setting_btn.isTabbed);
			
			_displays.dispose();
		}
	}
}

