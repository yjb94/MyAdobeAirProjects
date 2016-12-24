//brainAccountNotLoginPage
package Page.Account
{	
	import com.thanksmister.touchlist.controls.TouchList;
	import com.thanksmister.touchlist.renderers.DisplayObjectItemRenderer;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.RemoteNotificationEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.LoaderContext;
	import flash.text.AntiAliasType;
	import flash.text.ReturnKeyLabel;
	import flash.text.SoftKeyboardType;
	import flash.text.StageText;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import Page.BasePage;
	
	import Popup.DeletePopup;
	import Popup.RepRegPopup;
	
	import kr.pe.hs.tween.Tween;
	import kr.pe.hs.ui.TabbedButton;
	
	public class ManageBaby extends BasePage
	{
		[Embed(source = "assets/page/account/manage_baby/title.png")]
		private static const TITLE:Class;
		
		[Embed(source = "assets/top_menu/button_prev.png")]
		private static const BUTTON_PREV:Class;
		
		[Embed(source = "assets/page/account/manage_baby/button_add.png")]
		private static const BUTTON_ADD:Class;
		
		[Embed(source = "assets/page/account/manage_baby/test_baby.png")]
		private static const TEST_BABY:Class;
		
		[Embed(source = "assets/page/account/manage_baby/index_bg.png")]
		private static const INDEX_BG:Class;
		private var _list_bg:Vector.<Bitmap>;
		
		private var _list_text:Vector.<TextField>;
		private var _txt_text:Vector.<String>;
		
		[Embed(source = "assets/page/account/manage_baby/frame.png")]
		private static const PROFILE_FRAME:Class;
		[Embed(source = "assets/page/account/manage_baby/default_img.png")]
		private static const NO_PROFILE:Class;
		private var _list_thumbnail:Vector.<String>;
		
		private var _profile:Vector.<Sprite>;
		private var _profileLoader:Object;
		private var _profileArea:Vector.<Bitmap>;
		
		private var _send_index:int = 0;
		private var _recieve_index:int = 0;
		
		private var _downPoint:Point;
		
		private var _listSprite:Vector.<Sprite>;
		private var _touchList:TouchList;
		
		private var _list_child_seq:Vector.<int>;
		private var _child_seq_index:int;
		
		private var _have_baby:Boolean = false;
		
		[Embed(source = "assets/page/account/manage_baby/button_delete.png")]
		private static const BUTTON_DELETE:Class;
		private var _list_delete:Vector.<TabbedButton>;
		
		[Embed(source = "assets/page/account/manage_baby/button_rep_child.png")]
		private static const BUTTON_REP_CHILD:Class;
		[Embed(source = "assets/page/account/manage_baby/button_rep_child_on.png")]
		private static const BUTTON_REP_CHILD_ON:Class;
		private var _list_rep_child:Vector.<TabbedButton>;
		
		public function ManageBaby()
		{
			super();
			_downPoint=new Point;
			//this.addEventListener(MouseEvent.CLICK, onTouch);
			//this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
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
			bmp    = new BUTTON_ADD;    bmp.smoothing = true;
			bmp_on = new BUTTON_ADD; bmp_on.smoothing = true; bmp_on.alpha = 0.6;
			btn	   = new TabbedButton(bmp, bmp_on, bmp_on);
			Brain.Main.TopMenu.RightButton = btn;
			Brain.Main.TopMenu.RightButton.addEventListener(MouseEvent.CLICK, addClicked);
			
			//검사아동 코드
			//init
			_list_bg = new Vector.<Bitmap>;
			_list_text = new Vector.<TextField>;
			_txt_text = new Vector.<String>;
			_list_thumbnail = new Vector.<String>;
			_list_delete = new Vector.<TabbedButton>;
			_list_rep_child = new Vector.<TabbedButton>;
			_profile = new Vector.<Sprite>;
			//_profileLoader = new Vector.<Loader>;
			_profileLoader = new Object;
			_profileArea = new Vector.<Bitmap>;
			
			//서버 연결
			Brain.loadEnviroment();
			var params:URLVariables = new URLVariables;
			params.user_seq = Brain.UserInfo.user_seq;
			Brain.Connection.post("childListAction.cog", params, onLoadComplete);
			
			//listSprite initialize
			_listSprite = new Vector.<Sprite>(1, true);
			
			_listSprite[0] = new Sprite;
			_listSprite[0].graphics.beginFill(0x000000,0);
			_listSprite[0].graphics.drawRect(0,0,540,1);
			_listSprite[0].graphics.endFill();
		}
		private var _rep_child_index:int = -1;
		private function onLoadComplete(data:String):void
		{	
			if(data)
			{
				_list_child_seq = new Vector.<int>;
				var result:Object = JSON.parse(data);
//				output
//				1. j_user_seq
//				2. j_list
//				- user_seq : 사용자번호
//				- child_seq : 자식번호
//				- child_name : 자식이름
//				- child_year : 년도
//				- child_sex : 성별
//				- child_pic : 사진경로
//				- child_pic_thumbnail : 썸네일경로
				if(result.j_errorMsg.length>0)
				{
					new Alert(result.j_errorMsg).show();
					return;
				}
				for(var i:int; i < result.j_list.length; i++)
				{
					var txt:String = "";
					txt = txt + result.j_list[i].child_year + "년생 ";
					if(result.j_list[i].child_sex == "1")
						txt = txt + "남아\n";
					else if(result.j_list[i].child_sex == "2")
						txt = txt + "여아\n";
					txt = txt + result.j_list[i].child_name;
					_txt_text.push(txt);
					
					//아동 seq저장.
					_list_child_seq.push(result.j_list[i].child_seq);
					
					_list_thumbnail.push(result.j_list[i].child_pic);
				}
				if(result.j_list.length == 0)
				{
					_txt_text.push("등록된 아동이 없습니다.\n아동을 추가해 주세요.");
				}
				else
				{
					_have_baby = true;
				}
				
				//initializing after loading.
				initializeData();
				return;
			}
			
			new Alert("데이터 저장 실패.").show();
		}
		private function initializeData():void
		{
			for(var i:int = 0; i < _txt_text.length; i++)
			{	
				//list_bg
				var bmp:Bitmap = new INDEX_BG;
				bmp.smoothing = true;
				bmp.x = 0;
				bmp.y = 131-Brain.TopMenuHeight+118*i;
				_list_bg.push(bmp);
				_listSprite[0].addChild(_list_bg[i]);
				
				//text				
				var txt:TextField = new TextField;
				txt.x = 96.61; txt.y = 131-Brain.TopMenuHeight+39.5+118*i; txt.width = 400; txt.height = 19*1.3*2;
				var fmt:TextFormat = txt.defaultTextFormat;
				fmt.color = 0x585858;
				fmt.font="Main";
				fmt.size = 19;
				fmt.align = "left";
				txt.embedFonts = true;
				txt.defaultTextFormat = fmt;
				txt.antiAliasType = AntiAliasType.ADVANCED;
				txt.text = _txt_text[i];
				_list_text.push(txt);
				_listSprite[0].addChild(_list_text[i]);
				
				if(!_have_baby)	break;
				
				bmp    = new BUTTON_REP_CHILD;    bmp.smoothing = true;
				var bmp_on:Bitmap = new BUTTON_REP_CHILD_ON; bmp_on.smoothing = true;
				var btn:TabbedButton = new TabbedButton(bmp, bmp_on, bmp_on);
				btn.x = 407;
				btn.y = 173-Brain.TopMenuHeight+118*i;
				btn.addEventListener(MouseEvent.CLICK, onTouch);
				if(_list_child_seq[i] == Brain.UserInfo.child_seq)
				{
					btn.isTabbed = true;
					_rep_child_index = i;
				}
				_list_rep_child.push(btn);
				_listSprite[0].addChild(_list_rep_child[i]);
				
				//delete
				bmp    = new BUTTON_DELETE;    bmp.smoothing = true;
				bmp_on = new BUTTON_DELETE; bmp_on.smoothing = true; bmp_on.alpha = 0.6;
				btn = new TabbedButton(bmp, bmp_on, bmp_on);
				btn.x = 471;
				btn.y = 176-Brain.TopMenuHeight+118*i;
				btn.addEventListener(MouseEvent.CLICK, deleteClicked);
				_list_delete.push(btn);
				_listSprite[0].addChild(_list_delete[i]);
				
				_profile[i]=new Sprite;
				
				_profileArea[i]=new NO_PROFILE; _profileArea[i].smoothing=true;
				_profileArea[i].x=2; _profileArea[i].y=1;
				_profile[i].addChild(_profileArea[i]);
				
				if(_list_thumbnail[i] && _list_thumbnail[i].length > 0)
				{
					_profileLoader[i]=new Loader;
					_profileLoader[i].contentLoaderInfo.addEventListener(Event.COMPLETE,onProfileLoadComplete);
					_profileLoader[i].load(new URLRequest(Config.SERVER_PATH+_list_thumbnail[i]));
				}
				
				var bmpFrame:Bitmap=new PROFILE_FRAME; bmpFrame.smoothing=true;
				_profile[i].addChild(bmpFrame);
				
				_profile[i].x=28; 
				_profile[i].y=169-Brain.TopMenuHeight+118*i;
				_listSprite[0].addChild(_profile[i]);
			}
			//touchlist initialize
			_touchList = new TouchList(Brain.Main.PageWidth, Brain.Main.PageHeight);
			_touchList.addEventListener(Event.ADDED_TO_STAGE,touchList_onAdded);
			addChild(_touchList);
			
			//bg
			bmp = new TEST_BABY; bmp.smoothing = true; bmp.x = 0; bmp.y = 80-Brain.TopMenuHeight; addChild(bmp);
		}
		private function onProfileLoadComplete(e:Event):void
		{
			for(var i:int = 0; i < _list_thumbnail.length; i++)
			{
				if(_list_thumbnail[i] != "")
				{
					var loaderInfo:LoaderInfo=e.currentTarget as LoaderInfo;
					var loader:Loader=loaderInfo.loader;
					
					if(_profileLoader[i] == loader)
					{
						loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onProfileLoadComplete);
						if(loader.content is Bitmap){
							(loader.content as Bitmap).smoothing=true;
						}
						
						loader.width=56;
						loader.height=56;
						if(loader.scaleX<loader.scaleY)
							loader.scaleX=loader.scaleY;
						else
							loader.scaleY=loader.scaleX;
						
						loader.x=2+56/2-loader.width/2;
						loader.y=1+56/2-loader.height/2;
						
						loader.mask=_profileArea[i];
						_profile[i].addChildAt(loader,_profile[i].numChildren-1);
						
						Brain.Main.invalidateAnimateBitmap();
					}
				}
			}
		}
		private function touchList_onAdded(e:Event=null):void
		{
			_touchList.removeListItems();
			onResize();
			for(var i:int = 0; i < _listSprite.length; i++) 
			{
				_touchList.addListItem(new DisplayObjectItemRenderer(_listSprite[i]));
			}
		}
		private function prevClicked(e:MouseEvent):void
		{
			Brain.Main.setPage("brainAccountLoginPage", null, BrainPageEffect.RIGHT, BrainPageEffect.RIGHT);
		}
		private function addClicked(e:MouseEvent):void
		{
			Brain.Main.setPage("brainAccountNewBabyRegPage");
		}
		private function onMouseDown(e:MouseEvent):void
		{
			_downPoint.x=this.mouseX;
			_downPoint.y=this.mouseY;
		}
		private function onTouch(e:MouseEvent):void
		{
			//몇번째 인덱스 선택했는지 뽑아준다. 이걸로 터치 처리하면 됨. 선택된 영역에 인덱스가 없으면 -1리턴됨.
			var index:int = touchedIndex(this.mouseX, this.mouseY);
			
			if(index != -1)
			{
				_list_rep_child[_rep_child_index].isTabbed = false;
				_rep_child_index = index;
				_list_rep_child[_rep_child_index].isTabbed = true;
				
				var params:URLVariables = new URLVariables;
				params.user_seq = Brain.UserInfo.user_seq;
				params.child_seq = _list_child_seq[index];
				_child_seq_index = index;
				Brain.Connection.post("cognitiveChildRepRegAction.cog", params, onChildRepRegComplete);
			}
		}
		private var _delete_index:int = -1;
		private function deleteClicked(e:MouseEvent):void
		{
			var index:int = touchedIndex(this.mouseX, this.mouseY);
			if(index != -1)
			{
				Brain.Main.showPopup(new DeletePopup(deletePopup));
				_delete_index = index;
			}
		}
		private function deletePopup(value:Boolean):void
		{
			if(value)
			{
				var params:URLVariables = new URLVariables;
				params.user_seq = Brain.UserInfo.user_seq;
				params.child_seq = _list_child_seq[_delete_index];
				_child_seq_index = _delete_index;
				Brain.Connection.post("cognitiveChildDeleteAction.cog", params, onChildDelComplete);
			}
		}
		private function onChildDelComplete(data:String):void
		{
			if(data)
			{
				var result:Object = JSON.parse(data);
//				output
//				1.j_user_seq : 사용자 번호
//				2.j_rep_childYn : Y 이면, 삭제한 아동이 대표아동이라는 것, N이면 대표아동이 아니라는 것
//				3.j_rep_child_seq : 대표아동번호, 대표아동 삭제가 아닌 경우에는 ""로 들어감
//				2.j_delYn : Y 삭제 완료 N 뭔가 오류
//				3.j_errorMsg : 에러메시지
				if(result.j_errorMsg.length>0)
				{
					new Alert(result.j_errorMsg).show();
					return;
				}
				
				if(result.j_delYn == "Y")
				{
					if(result.j_rep_childYn == "Y")
					{
						Brain.UserInfo.child_seq = result.j_rep_child_seq;
						Brain.saveEnviroment();
					}
					
					Brain.Main.setPage("brainAccountLoginPage", null, BrainPageEffect.RIGHT, BrainPageEffect.RIGHT);
				}
				else
					new Alert("아동 삭제 실패.").show();
				
				return;
			}
			
			new Alert("아동 삭제 실패.").show();
		}
		private function onChildRepRegComplete(data:String):void
		{
			if(data)
			{
				var result:Object = JSON.parse(data);
				
				if(result.j_errorMsg.length>0)
				{
					new Alert(result.j_errorMsg).show();
					return;
				}
				
				if(result.j_regYn == "Y")
				{
					Brain.UserInfo = { 
						user_seq:Brain.UserInfo.user_seq,
							child_seq:_list_child_seq[_child_seq_index],
							child_pic:result.j_childInfo[0].child_pic,
							child_pic_thumbnail:result.j_childInfo[0].child_pic_thumbnail,
							rep_child_yn:true 
					};
					Brain.saveEnviroment();
					
					Brain.Main.showPopup(new RepRegPopup(function():void{
						Brain.Main.closePopup; }));
				}
				else
					new Alert("대표 아동 등록 실패.").show();
				
				return;
			}
			
			new Alert("대표 아동 등록 실패.").show();
		}
		private function touchedIndex(mousex:int, mousey:int):int
		{	
			var scrolly:Number = -_touchList.ScrollTop;
			if(_have_baby == false)	return -1;
			
			for(var i:int = 0; i < _txt_text.length; i++)
			{
				if(_list_bg[i].x <= mousex && _list_bg[i].x+_list_bg[i].width >= mousex &&
					_list_bg[i].y <= mousey-scrolly && _list_bg[i].y+_list_bg[i].height >= mousey-scrolly)
					return i;
			}
			return -1;
		}
		public override function onResize():void
		{
		}
		
		public override function dispose():void
		{
			Brain.Main.TopMenu.LeftButton.removeEventListener(MouseEvent.CLICK, prevClicked);
			Brain.Main.TopMenu.RightButton.removeEventListener(MouseEvent.CLICK, addClicked);
		}
	}
}

