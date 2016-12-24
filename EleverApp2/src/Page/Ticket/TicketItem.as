package Page.Ticket
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.Text;
	
	import Utils.JPEGAsyncCompleteEvent;
	import Utils.JPEGAsyncEncoder;

	public class TicketItem extends Sprite
	{		
		private var MARGIN_HEIGHT:Number = 94;
		private var TEXT_NUMBER:Number = 6;
		private var FONT_SIZE:Number = 27;
		
		private var _mask:Bitmap;
		
		private var _loader:Loader;
		private var _cache:Loader
		
		private var _url:String
		
		private var _index:int;
		
		public function TicketItem(obj:Object, file_name:Class, index:int)
		{
			_index = index;
			_url = obj.gathering_sub_image;
			
			loadImage();
			
			var btn:Button = new Button(BitmapControl.BUTTON_TICKET_CANCEL, BitmapControl.BUTTON_TICKET_CANCEL, deleteTicket);
			btn.x = Elever.Main.PageWidth/2 - btn.width/2;
			btn.y = Elever.Main.PageHeight - btn.height - MARGIN_HEIGHT;
			addChild(btn);
			
			var txt:TextField = Text.newText("예약 일자 : "+obj.ymd, FONT_SIZE, 0x000000);
			txt.name = "ymd"; txt.x = 40; txt.y = Elever.Main.PageHeight/2;
			addChild(txt);
			
			MARGIN_HEIGHT = ((btn.y - Elever.Main.PageHeight/2) - (txt.height * TEXT_NUMBER)) / TEXT_NUMBER;
			
			txt = Text.newText("예약 시간 : "+obj.start_time+" - "+obj.end_time, FONT_SIZE);
			txt.name = "time"; txt.x = getChildByName("ymd").x; txt.y = getChildByName("ymd").y + getChildByName("ymd").height + MARGIN_HEIGHT;
			addChild(txt);
			
			txt = Text.newText("진행 상태 : " + obj.status, FONT_SIZE, 0x000000);
			var fmt:TextFormat = txt.defaultTextFormat;
			fmt.color = 0xdd5858;
			txt.setTextFormat(fmt, 8, txt.length);
			txt.name = "status"; txt.x = getChildByName("time").x; txt.y = getChildByName("time").y + getChildByName("time").height + MARGIN_HEIGHT;
			addChild(txt);
			
			txt = Text.newText("주문 번호 : "+obj.order_no, FONT_SIZE, 0x000000);
			txt.name = "order_no"; txt.x = getChildByName("status").x; txt.y = getChildByName("status").y + getChildByName("status").height + MARGIN_HEIGHT;
			addChild(txt);
			
			txt = Text.newText("예약 인원 : "+obj.member+"명", FONT_SIZE);
			txt.name = "member"; txt.x = getChildByName("order_no").x; txt.y = getChildByName("order_no").y + getChildByName("order_no").height + MARGIN_HEIGHT;
			addChild(txt);
			
			_mask = new file_name; _mask.smoothing = true;
			_mask.x = Elever.Main.PageWidth/2 - _mask.width/2;
			_mask.y = Elever.Main.PageHeight/2/2 - _mask.height/2;
			addChildAt(_mask,0);
		}
		private function loadImage():void
		{
			if(_url == "" || _url == null)
			{
				trace("Register error : load Image with no url");
				return;
			}
			
			var file:File = File.applicationStorageDirectory.resolvePath("Images/"+_url);
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
					bmp.width = _mask.width;
					bmp.height = _mask.height;
					if(bmp.scaleX > bmp.scaleY) bmp.scaleX = bmp.scaleY;
					else bmp.scaleY = bmp.scaleX;
					bmp.name = "Thumbnail";
					bmp.mask = _mask;
					bmp.x = Elever.Main.PageWidth/2 - bmp.width/2;
					bmp.y = Elever.Main.PageHeight/2/2 - bmp.height/2;
					
					addChildAt(bmp, 0);
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
//		private function loadImage():void
//		{			
//			if(_url == "")
//			{
//				trace("Ticket Item Error : No url");
//				return;
//			}
//			_loader=new Loader;
//			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onProfileLoadComplete);
//			_loader.load(new URLRequest(_url));
//			
//			var file:File=File.applicationStorageDirectory.resolvePath(_url);
//			if(file.exists)
//			{
//				_cache=new Loader;
//				_cache.contentLoaderInfo.addEventListener(Event.COMPLETE, onProfileLoadComplete);
//				
//				var bytes:ByteArray=new ByteArray;
//				
//				var fs:FileStream=new FileStream;
//				fs.open(file,FileMode.READ);
//				fs.readBytes(bytes);
//				fs.close();
//				
//				var loaderContext:LoaderContext=new LoaderContext;
//				loaderContext.allowCodeImport=false;
//				loaderContext.allowLoadBytesCodeExecution=true;
//			}
//		}
//		private function onProfileLoadComplete(e:Event):void
//		{			
//			if(_loader==null) return;
//			
//			var loaderInfo:LoaderInfo=e.currentTarget as LoaderInfo;
//			var loader:Loader=loaderInfo.loader;
//			
//			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onProfileLoadComplete);
//			if(loader.content is Bitmap)
//			{
//				(loader.content as Bitmap).smoothing=true;
//			}
//			
//			if(_loader==loader)
//			{
//				if(_cache!=null)
//				{
//					_cache.contentLoaderInfo.removeEventListener(Event.COMPLETE,onProfileLoadComplete);
//					if(_cache.parent) 
//						_cache.parent.removeChild(_cache);
//					_cache=null;
//				}
//				
//				var file:File=File.applicationStorageDirectory.resolvePath(_url);
//				file.parent.createDirectory();
//				if(!file.exists || file.size!=_loader.contentLoaderInfo.bytesTotal)
//				{
//					var fs:FileStream=new FileStream;
//					fs.open(file,FileMode.WRITE);
//					fs.writeBytes(_loader.contentLoaderInfo.bytes);
//					fs.close();
//				}
//			}
//
//			loader.height = (loader.height > Elever.Main.PageHeight/2 - MARGIN_HEIGHT) ? Elever.Main.PageHeight/2 - MARGIN_HEIGHT : loader.height;
//			loader.scaleX = loader.scaleY;
//			loader.x = Elever.Main.PageWidth/2 - loader.width/2;
//			loader.y = MARGIN_HEIGHT;
//			loader.mask = _mask;
//			
//			addChild(loader);
//		}
		private function deleteTicket(e:MouseEvent):void
		{
			(parent as Ticket).deleteTicket(_index);
		}
	}
}