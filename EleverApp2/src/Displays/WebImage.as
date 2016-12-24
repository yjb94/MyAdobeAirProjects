package Displays
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
	import flash.utils.ByteArray;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.Text;
	
	import Utils.JPEGAsyncCompleteEvent;
	import Utils.JPEGAsyncEncoder;
	
	public class WebImage extends Sprite
	{		
		private const MARGIN_WIDTH:Number = 0;
		private const MARGIN_HEIGHT:Number = 0;
		
		private var _mask:Bitmap;
		
		private var _loader:Loader;
		private var _cache:Loader
		
		private var _url:String
		
		public function WebImage(url:String, file_name:Class)
		{
			_url = url;
			
			loadImage();
			
			_mask = new file_name; _mask.smoothing = true;
			_mask.x = MARGIN_WIDTH;
			_mask.y = MARGIN_HEIGHT;
			addChildAt(_mask,0);
		}
		private function loadImage():void
		{			
			if(_url == "")
			{
				trace("Ticket Item Error : No url");
				return;
			}
			_loader=new Loader;
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onProfileLoadComplete);
			_loader.load(new URLRequest(_url));
			
			var file:File=File.applicationStorageDirectory.resolvePath("Images/"+_url);
			if(file.exists)
			{
				_cache=new Loader;
				_cache.contentLoaderInfo.addEventListener(Event.COMPLETE, onProfileLoadComplete);
				
				var bytes:ByteArray=new ByteArray;
				
				var fs:FileStream=new FileStream;
				fs.open(file,FileMode.READ);
				fs.readBytes(bytes);
				fs.close();
				
				var loaderContext:LoaderContext=new LoaderContext;
				loaderContext.allowCodeImport=false;
				loaderContext.allowLoadBytesCodeExecution=true;
			}
		}
		private function onProfileLoadComplete(e:Event):void
		{			
			if(_loader==null) return;
			
			var loaderInfo:LoaderInfo=e.currentTarget as LoaderInfo;
			var loader:Loader=loaderInfo.loader;
			
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onProfileLoadComplete);
			if(loader.content is Bitmap)
			{
				(loader.content as Bitmap).smoothing=true;
			}
			
			if(_loader==loader)
			{
				if(_cache!=null)
				{
					_cache.contentLoaderInfo.removeEventListener(Event.COMPLETE,onProfileLoadComplete);
					if(_cache.parent) 
						_cache.parent.removeChild(_cache);
					_cache=null;
				}
				
				var file:File=File.applicationStorageDirectory.resolvePath("Images/"+_url);
				file.parent.createDirectory();
				if(!file.exists || file.size!=_loader.contentLoaderInfo.bytesTotal)
				{
					var fs:FileStream=new FileStream;
					fs.open(file,FileMode.WRITE);
					fs.writeBytes(_loader.contentLoaderInfo.bytes);
					fs.close();
				}
			}

			loader.width = _mask.width;
			loader.height = _mask.height;
			loader.x = MARGIN_WIDTH;
			loader.y = MARGIN_HEIGHT;
			loader.mask = _mask;
			
			addChild(loader);
		}
	}
}

