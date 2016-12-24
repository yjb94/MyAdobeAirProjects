package Page.Ticket
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
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
	
	import Utils.JPEGAsyncCompleteEvent;
	import Utils.JPEGAsyncEncoder;
	
	public class Ticket extends BasePage
	{
		private const TWEEN_DURATION:Number = 0.3;
		private const DOT_HEIGHT_MARGIN:Number = 28;
		private const DOT_WIDTH_MARGIN:Number = 5;
		private const MOVE_PER_TOUCH:Number = 0.5;
		
		private var _ticket_data:Object;
		
		private var _ticketItem:TicketItem;
		private var _nextItem:TicketItem;
		private var _ticketDot:Vector.<Bitmap> = new Vector.<Bitmap>;
		
		private var _cur_index:int = 0;
		
		private var _is_tweening:Boolean = false;
		
		private var _prev_x:Number;
		
		public function loadEnviroment():void
		{
			_ticket_data = null;
			
			var appStorage:File=File.applicationStorageDirectory;
			var dbFile:File = appStorage.resolvePath("ticket.db");
			if(dbFile.exists)
			{
				var fs:FileStream=new FileStream;
				fs.open(dbFile,FileMode.READ);
				var result:Object=JSON.parse(fs.readUTF());
				fs.close();
				
				_ticket_data = result;
			}
		}
		public function saveEnviroment():void
		{			
			var appStorage:File=File.applicationStorageDirectory;
			var dbFile:File = appStorage.resolvePath("ticket.db");
			var fs:FileStream=new FileStream;
			fs.open(dbFile,FileMode.WRITE);
			fs.writeUTF(JSON.stringify(_ticket_data));
			fs.close();
		}
		
		public function Ticket(params:Object=null)
		{
			super();
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).clearPrev();
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = Text.newText("티켓", 26, 0xffffff);
		
			if(params && params.doNotLoad)
				loadEnviroment();
			else
				loadData();
			if(_ticket_data)
			{
				itemIndex = 0;
			}
			addEventListener(Event.ADDED_TO_STAGE, function(e:Event):void
			{
				stage.addEventListener(TransformGestureEvent.GESTURE_SWIPE, onSwipeEvent);
//				stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
//				stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseEvent);
			});
		}
//		private function onMouseEvent(e:MouseEvent):void
//		{
//			if(e.type == MouseEvent.MOUSE_DOWN)
//			{
//				_prev_x = mouseX;
//			}
//			else if(e.type == MouseEvent.MOUSE_MOVE)
//			{
//				if(_prev_x - mouseX < 10)	//not dragged
//					return;
//				
//				var distance:Number = (_prev_x - mouseX);
//				_ticketItem.x += -distance*MOVE_PER_TOUCH;
//				_prev_x = mouseX;
//			}
//		}
		private function onSwipeEvent(e:TransformGestureEvent):void
		{
			if(_is_tweening) return;
			
			if(!e.offsetY)
			{
				if(e.offsetX == 1)
				{
					if(_cur_index)  //왼쪽->
					{
						itemIndex = _cur_index-1;
					}
				}
				else if(e.offsetX == -1)
				{ 
					if(_cur_index < _ticket_data.total_count-1) //오른쪽<-
					{
						itemIndex = _cur_index+1; 
					}
				}
			}
		}
		private function loadData():void
		{
			loadEnviroment();
			if(_ticket_data == null)
			{
				if(Elever.UserInfo && Elever.UserInfo.user_seq)
				{
					var params:URLVariables = new URLVariables;
					params.user_seq = Elever.UserInfo.user_seq;
					Elever.Main.LoadingVisible = true;
					Elever.Connection.post("Myticket", params, onLoadComplete);
				}
			}
		}
		private function onLoadComplete(data:String):void
		{
			Elever.Main.LoadingVisible = false;
			if(data)
			{
				_ticket_data = JSON.parse(data);
				saveEnviroment();
				itemIndex = 0;
			}
		}
		private function drawItem(index:int=0):void
		{
			if(index != _cur_index)
			{
				var obj:Object = _ticket_data.ticketInfoList[index];
				_nextItem = new TicketItem(obj, BitmapControl.TEMP_NO_IMAGE, index);
				addChild(_nextItem);
				
				var dir:int = (index > _cur_index) ? 1 : -1;
				_nextItem.x = dir*Elever.Main.PageWidth;
				
				_is_tweening = true;
				TweenLite.to(_ticketItem, TWEEN_DURATION, { x:-1*dir*Elever.Main.PageWidth });
				TweenLite.to(_nextItem, TWEEN_DURATION, { x:0, onComplete:function():void
				{
					_is_tweening = false;
					removeChild(_ticketItem);
					_ticketItem = _nextItem;
				}});
			}
			else
			{
				if(_ticket_data.total_count != "0")
				{
					obj = _ticket_data.ticketInfoList[index];
					_ticketItem = new TicketItem(obj, BitmapControl.TEMP_NO_IMAGE, index);
					addChild(_ticketItem);
				}
				else
				{
					
				}
			}
		}
		private function set itemIndex(index:int):void
		{			
			drawItem(index);
			
			while(_ticketDot.length)
				removeChild(_ticketDot.pop());
			
			if(_ticket_data.total_count > 1)
			{
				for(var i:int = 0; i < _ticket_data.total_count; i++)
				{
					var len:int = _ticket_data.total_count;
					var cls:Class = (i==index) ? BitmapControl.TICKET_DOT_DOWN : BitmapControl.TICKET_DOT_UP;
					var bmp:Bitmap = BitmapControl.newBitmap(cls);
					bmp.y = Elever.Main.PageHeight - bmp.height - DOT_HEIGHT_MARGIN;
					bmp.x = Elever.Main.PageWidth/2 - (len/2-i)*(bmp.width + DOT_WIDTH_MARGIN);
						
					_ticketDot.push(bmp);
					addChild(bmp);
				}
			}
			
			_cur_index = index;
		}
		public function deleteTicket(index:int):void
		{
			var params:URLVariables = new URLVariables;
			params.user_seq = Elever.UserInfo.user_seq;
			params.product = "project";
			params.schedule_seq = _ticket_data.ticketInfoList[index].schedule_seq;
			Elever.Main.LoadingVisible = true;
			Elever.Connection.post("rsvCancelRequest", params, function(data:String):void
			{
				Elever.Main.LoadingVisible = false;
				
				if(data)
				{
					var result:Object = JSON.parse(data);
					
					if(result.isCheck)
					{
						var params:URLVariables = new URLVariables;
						params.user_seq = Elever.UserInfo.user_seq;
						Elever.Main.LoadingVisible = true;
						Elever.Connection.post("Myticket", params, function(data:String):void
						{
							Elever.Main.LoadingVisible = false;
							_ticket_data = JSON.parse(data);
							saveEnviroment();
							Elever.Main.changePage("TicketPage", PageEffect.NONE, { doNotLoad:true }, 0.5, true);
						});
					}
					else
						trace("Ticket Delete Error : Failed to delete");
				}
			});
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
		}
	}
}