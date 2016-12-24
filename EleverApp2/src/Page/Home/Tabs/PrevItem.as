package Page.Home.Tabs
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.Text;
	
	import Header.Header;
	import Header.NavigationBar;
	import Header.Tab;
	import Header.TabBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	
	import Scroll.Scroll;
	
	public class PrevItem extends BasePage
	{
		private const TOUCH_SENSITIVE:Number = 15;
		private const BUDULBUDUL_TEMP:Number = 1;
		
		private const EXPLAIN_TEXT_LEFT_MARGIN:Number = 40;
		private const EXPLAIN_TEXT_RIGHT_MARGIN:Number = 52;
		
		private var _item_spr_vector:Vector.<Sprite> = new Vector.<Sprite>;
		
		private var _displays:Scroll;
		
		private var _downPos:Point = new Point;
		
		public function PrevItem(params:Object=null)
		{
			super();
			
			_displays = new Scroll(false, -1, params.height);
			addChild(_displays);
			
			if(Elever.PrevItemList != null)
			{
				for(var i:int = 0; i < Elever.PrevItemList.length; i++)
				{
					makeItem(i);
				}
			}
		}
		private function makeItem(index:int):Sprite
		{
			var spr:Sprite = new Sprite;
			
			//init base image
			var bmp:Bitmap = BitmapControl.newBitmap(BitmapControl.ITEM_NO_IMAGE);
			spr.addChild(bmp);
			
			//loadImage
			loadImage(Elever.PrevItemList[index].gathering_sub_image, spr, bmp, index);
			
			//mouseEvent and pageControl.
			spr.addEventListener(MouseEvent.MOUSE_DOWN, onItemClick);
			spr.addEventListener(MouseEvent.MOUSE_UP, onItemClick);
			spr.name = Elever.PrevItemList[index].gathering_name;
			
			_item_spr_vector.push(spr);
			setItems();
			_displays.addObject(_item_spr_vector[_item_spr_vector.length-1]);
			
			return spr;
		}
		private function setItems():void
		{
			for(var i:int = 1; i < _item_spr_vector.length; i++)
			{
				_item_spr_vector[i].y = _item_spr_vector[i-1].y + _item_spr_vector[i-1].height - BUDULBUDUL_TEMP;
			}
		}
		private function set EveryAlpha(alpha:Number):void
		{
			for(var i:int = 0; i < _item_spr_vector.length; i++)
			{
				_item_spr_vector[i].alpha = alpha;
			}
		}
		private function onItemClick(e:MouseEvent=null):void
		{
			if(e.type == MouseEvent.MOUSE_DOWN)
			{
				_downPos.x = mouseX;
				_downPos.y = mouseY;
				
				(e.currentTarget as Sprite).alpha = 0.6;
				stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			}
			else if(e.type == MouseEvent.MOUSE_UP)
			{				
				if(Point.distance(_downPos, new Point(mouseX, mouseY)) > TOUCH_SENSITIVE)
					return;
				
				var param:Object = new Object;
				param.model = Elever.PrevItemList[_item_spr_vector.indexOf(e.currentTarget as Sprite)];
				param.now_item = true;
				param.prev_item = false;
				Elever.Main.changePage("ProjectInfoPage", PageEffect.LEFT, param);
			}
		}
		private function onStageMouseUp(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			EveryAlpha = 1.0;
		}
		private function loadImage(url:String, base_spr:Sprite, mask:Bitmap, index:int):void
		{
			if(url == "")
			{
				trace("Now Item error : load Image with no url");
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
					bmp.mask = mask;
					base_spr.addChild(bmp);
					
					//Add Explain
					var explain_bmp:Bitmap = BitmapControl.newBitmap(BitmapControl.ITEM_EXPLAIN_BG);
					explain_bmp.y = mask.height - explain_bmp.height - BUDULBUDUL_TEMP//base_spr.height - explain_bmp.height;
					base_spr.addChild(explain_bmp);
					
					var txt:TextField = Text.newText(Elever.PrevItemList[index].gathering_ymd, 27, 0xffffff, EXPLAIN_TEXT_LEFT_MARGIN);
					txt.y = explain_bmp.y + explain_bmp.height/2 - txt.height/2;
					base_spr.addChild(txt);
					
					txt = Text.newText(Elever.PrevItemList[index].gathering_localname2, 27, 0xffffff);
					txt.x = explain_bmp.width - txt.width - EXPLAIN_TEXT_RIGHT_MARGIN;
					txt.y = explain_bmp.y + explain_bmp.height/2 - txt.height/2;
					base_spr.addChild(txt);
				});
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void
				{
					Elever.Main.LoadingVisible = false;
				});
				loader.loadBytes(bytes);
			}
			else
				trace("Now Item error : url path no file in app directory error");
		}
		public override function init():void
		{
		}
		public override function onResize():void
		{
		}
		public override function dispose():void
		{
		}
	}
}