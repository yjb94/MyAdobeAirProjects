package Page.Buy
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.net.URLVariables;
	import flash.net.dns.ARecord;
	import flash.text.TextField;
	
	import Displays.BitmapControl;
	import Displays.Button;
	import Displays.Text;
	import Displays.WebImage;
	
	import Header.NavigationBar;
	
	import Page.BasePage;
	import Page.PageEffect;
	
	import Scroll.Scroll;
	
	public class RequestList extends BasePage
	{
		private const START_Y:Number = 0*Config.ratio;
		private const DRAG_COEFFICIENT:Number = 15*Config.ratio;
		private const TITLE_FONT_SIZE:Number = 50*Config.ratio;
		private const OTHER_FONT_SIZE:Number = 36*Config.ratio;
		private const NAME_FONT_SIZE:Number = 45*Config.ratio;
		
		private const STRANGE_ADD_NUMBER:Number = 37;
		private const BOTTOM_LINE_NUMBER:Number = 50;
		
		private var _displays:Scroll;
		
		private var _item_list:Vector.<Sprite> = new Vector.<Sprite>;
		private var _downPos:Point = new Point;
		
		private var _params:Object;
		
		private var _list:Array = new Array;
		
		public function RequestList(params:Object=null)
		{
			super();
			
			Elever.Main.LoadingVisible = false;
			
			var title:String = "견적목록";
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).clearPrev();
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).Middle = Text.newText(title, TITLE_FONT_SIZE, 0xffffff);
			
			_displays = new Scroll(true, -1, -1, -1, params.y, refreshDataList);
			addChild(_displays);
			
			(Elever.Main.header.getChildByName("NavigationBar") as NavigationBar).addMiddleTouchCallBack(_displays.toTop);
			
			if(Elever._user_info == null)
			{
				var txt:TextField = Text.newText("로그인 해주세요.", 50);
				txt.x = Elever.Main.PageWidth/2 - txt.width/2;
				txt.y = Elever.Main.PageHeight/2 - Elever.Main.HeaderHeight - txt.height/2;
				addChild(txt);
				return;
			}
			else if(Elever._user_info.type == "0")
			{
				var parameters:URLVariables = new URLVariables;
				parameters.id = Elever._user_info.id;
				Elever.Main.LoadingVisible = true;
				Elever.Connection.post("temp15.jsp", parameters, function(data:String):void
				{
					Elever.Main.LoadingVisible = false;
					if(data)
					{
						var result:Object = JSON.parse(data);
						
						if(result.length)
						{
							Elever._request_list = new Array;
							for(var i:int = 0; i < result.length; i++)
								Elever._request_list.push(result[i]);
							setRequestPlace();
						}
						else
						{
							txt = Text.newText("요청한 견적이 없습니다.", 50);
							txt.x = Elever.Main.PageWidth/2 - txt.width/2;
							txt.y = Elever.Main.PageHeight/2 - Elever.Main.HeaderHeight - txt.height/2;
							addChild(txt);
						}
					}
				});
				return;
			}
			
			getRequestData();
		}
		
		private function setRequestPlace():void
		{
			for(var i:int = 0; i < Elever._request_list.length; i++)
				_displays.addObject(makeItem(Elever._car_data[Elever._request_list[i].car_seq].thumbnail,
											 Elever._car_data[Elever._request_list[i].car_seq].name, Elever._request_list[i].user_comment, i.toString()));
			setItems();
			_displays.onResize();
		}
		private function getRequestData():void
		{
			refreshDataList();
//			var data:Object = Elever.loadEnviroment("request_info", data);
//			if(data == null)
//			{
//			}
//			else
//			{
//				Elever._request_list = new Array;
//				for(var i:int = 0; i < data.length; i++)
//					Elever._request_list.push(data[i]);
//				setRequestPlace();
//			}
		}
		private function refreshDataList():void
		{
			var params:URLVariables = new URLVariables;
			Elever.Main.LoadingVisible = true;
			Elever.Connection.post("temp12.jsp", params, function(data:String):void
			{
				Elever.Main.LoadingVisible = false;
				if(data)
				{
					var result:Object = JSON.parse(data);
					
					if(result)
					{
//						Elever.saveEnviroment("request_info", result);
						Elever._request_list = new Array;
						for(var i:int = 0; i < result.length; i++)
							Elever._request_list.push(result[i]);
						setRequestPlace();
					}
				}
			});
		}
		private function makeItem(url:String, name:String, comment:String, seq:String):Sprite
		{
			var spr:Sprite = new Sprite;
			spr.name = seq;
			
			//item main bg
			spr.addChild(BitmapControl.newBitmap(BitmapControl.REQUEST_ITEM_BG));
			
			//item image
			var img:WebImage = new WebImage(url, BitmapControl.REQUEST_CAR_MASK);
			img.x = 25;
			img.y = 18;
			spr.addChild(img);
			
			//차 이름
			var txt:TextField = Text.newText(name, 35*Config.ratio, 0x000000, 140, 0, "left", "NanumBarunGothic", 0, 0, { bold:true });
			txt.y = spr.height/2 - txt.height;
			txt.name = "name";
			spr.addChild(txt);
			
			//남기는 말
			if(comment.length > 30)
				comment = comment.substr(0, 30) + "...";
			txt = Text.newText(comment, 30*Config.ratio, 0x494949, txt.x, 0);
			txt.y = spr.height/2 + txt.height - 17;
			txt.name = "comment";
			spr.addChild(txt);
			
			spr.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
			
			_item_list.push(spr);
			
			return spr;
		}
		private function setItems():void
		{
			_item_list[0].y = START_Y;
			
			for(var i:int = 1; i < _item_list.length; i++)
			{
				_item_list[i].y = _item_list[i-1].y + _item_list[i-1].height;
			}
		}
		private function onMouseEvent(e:MouseEvent):void
		{
			if(e.type == MouseEvent.MOUSE_DOWN)
			{
				(e.currentTarget as Sprite).addEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
				
				_downPos.x = mouseX;
				_downPos.y = mouseY;
			}
			else if(e.type == MouseEvent.MOUSE_UP)
			{
				(e.currentTarget as Sprite).removeEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
				
				if(Point.distance(_downPos, new Point(mouseX, mouseY)) > DRAG_COEFFICIENT)
					return;
				
				var item:Sprite = _item_list[Number((e.currentTarget as Sprite).name)];
				var index:int = Number(item.name);
				
				Elever.Main.changePage("RequestDetailPage", PageEffect.LEFT, { car_data:Elever._car_data[Elever._request_list[index].car_seq], request_data:Elever._request_list[index] });
			}
		}
		
		public override function init():void
		{
			_displays.scroller.fold((Elever.Main.header.getChildByName("NavigationBar") as NavigationBar), 1);
		}
		public override function onResize():void
		{
		}
		
		public override function dispose():void
		{
			_displays.scroller.resetFoldObj();
		}
	}
}
