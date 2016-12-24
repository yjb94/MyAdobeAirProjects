//brainAccountNotLoginPage
package Page.Account
{	
	import com.thanksmister.touchlist.renderers.DisplayObjectItemRenderer;
	import com.thanksmister.touchlist.renderers.SpaceItemRenderer;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MediaEvent;
	import flash.events.MouseEvent;
	import flash.events.RemoteNotificationEvent;
	import flash.events.SoftKeyboardEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.media.CameraRoll;
	import flash.media.CameraUI;
	import flash.media.MediaPromise;
	import flash.media.MediaType;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.LoaderContext;
	import flash.text.ReturnKeyLabel;
	import flash.text.SoftKeyboardType;
	import flash.text.StageText;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	import flash.utils.setTimeout;
	
	import Page.BasePage;
	
	import co.uk.mikestead.net.URLFileVariable;
	
	import jp.shichiseki.exif.ExifLoader;
	
	import kr.pe.hs.tween.Tween;
	import kr.pe.hs.ui.TabbedButton;
	
	public class NewBaby2 extends BasePage
	{
		[Embed(source = "assets/page/account/new_baby2/title.png")]
		private static const TITLE:Class;
		
		[Embed(source = "assets/top_menu/button_prev.png")]
		private static const BUTTON_PREV:Class;
		
		[Embed(source = "assets/page/account/new_baby2/button_search.png")]
		private static const BUTTON_SEARCH:Class;
		[Embed(source = "assets/page/account/new_baby2/button_search_on.png")]
		private static const BUTTON_SEARCH_ON:Class;
		private var _btn_search:TabbedButton;
		
		[Embed(source = "assets/page/account/new_baby2/button_take.png")]
		private static const BUTTON_TAKE:Class;
		[Embed(source = "assets/page/account/new_baby2/button_take_on.png")]
		private static const BUTTON_TAKE_ON:Class;
		private var _btn_take:TabbedButton;
		
		[Embed(source = "assets/page/account/new_baby2/button_reg.png")]
		private static const BUTTON_REG:Class;
		[Embed(source = "assets/page/account/new_baby2/button_reg_on.png")]
		private static const BUTTON_REG_ON:Class;
		private var _btn_reg:TabbedButton;
		
		
		[Embed(source = "assets/page/account/new_baby2/photo.png")]
		private static const PHOTO:Class;
		[Embed(source = "assets/page/account/new_baby2/default_image.png")]
		private static const DEFAULT_IMAGE:Class;
		[Embed(source = "assets/page/account/new_baby2/frame.png")]
		private static const PROFILE_FRAME:Class;
		
		private var _profile:Sprite;
		private var _profileLoader:Loader;
		private var _profileCache:Loader;
		private var _profileArea:Bitmap;
		
		public function NewBaby2()
		{
			super();
			
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
			
			
			//buttons
			bmp    = new BUTTON_SEARCH;    bmp.smoothing    = true;
			bmp_on = new BUTTON_SEARCH_ON; bmp_on.smoothing = true;
			_btn_search = new TabbedButton(bmp, bmp_on, bmp_on); _btn_search.x = 26; _btn_search.y = 425-Brain.TopMenuHeight;
			_btn_search.addEventListener(MouseEvent.CLICK, searchPhotoClicked); addChild(_btn_search);
			
			bmp    = new BUTTON_TAKE;    bmp.smoothing    = true;
			bmp_on = new BUTTON_TAKE_ON; bmp_on.smoothing = true;
			_btn_take = new TabbedButton(bmp, bmp_on, bmp_on); _btn_take.x = 278; _btn_take.y = 425-Brain.TopMenuHeight;
			_btn_take.addEventListener(MouseEvent.CLICK, takePhotoClicked); addChild(_btn_take);
			
			bmp    = new BUTTON_REG;    bmp.smoothing    = true;
			bmp_on = new BUTTON_REG_ON; bmp_on.smoothing = true;
			_btn_reg = new TabbedButton(bmp, bmp_on, bmp_on); _btn_reg.x = 25; _btn_reg.y = 565-Brain.TopMenuHeight;
			_btn_reg.addEventListener(MouseEvent.CLICK, regBabyClicked); addChild(_btn_reg);
			
			//bgs
			bmp = new PHOTO; 	 	 bmp.smoothing=true; bmp.x =  45; bmp.y = 120-Brain.TopMenuHeight; addChild(bmp);
			
			_profile=new Sprite;
			
			_profileArea = new DEFAULT_IMAGE; _profileArea.smoothing = true;
			_profileArea.x=2; _profileArea.y=3;
			_profile.addChild(_profileArea);
			
			var bmpFrame:Bitmap=new PROFILE_FRAME; bmpFrame.smoothing=true;
			_profile.addChild(bmpFrame);
			
			_profile.x = 191;
			_profile.y = 189-Brain.TopMenuHeight;
			addChild(_profile);
		}
		private function prevClicked(e:MouseEvent):void
		{
			Brain.Main.setPage("brainAccountBabyManagePage", null, BrainPageEffect.RIGHT, BrainPageEffect.RIGHT);
		}
		private function takePhotoClicked(e:MouseEvent):void
		{
			//Take photo
			var cameraUI:CameraUI = new CameraUI();
			if( CameraUI.isSupported )
			{
				cameraUI.addEventListener( MediaEvent.COMPLETE, imageSelected );
				//cameraUI.addEventListener( Event.CANCEL, browseCanceled );
				//cameraUI.addEventListener( ErrorEvent.ERROR, mediaError );
				cameraUI.launch( MediaType.IMAGE );
			}
			else
			{
				trace( "CameraUI is not supported.");
			}	
		}
		private function searchPhotoClicked(e:MouseEvent):void
		{
			//Pick from album
			var cameraRoll:CameraRoll = new CameraRoll();
			
			if( CameraRoll.supportsBrowseForImage )
			{
				cameraRoll.addEventListener( MediaEvent.SELECT, imageSelected );
				//cameraRoll.addEventListener( Event.CANCEL, browseCanceled );
				//cameraRoll.addEventListener( ErrorEvent.ERROR, mediaError );
				cameraRoll.browseForImage();
			}
			else
			{
				trace( "Image browsing is not supported on this device.");
			}
		}
		
		private function regBabyClicked(e:MouseEvent):void
		{
			Brain.Main.setPage("brainAccountBabyManagePage");
		}
		public override function onResize():void
		{
		}
		
		public override function dispose():void
		{
			Brain.Main.TopMenu.LeftButton.removeEventListener(MouseEvent.CLICK, prevClicked);
			
			_btn_search.removeEventListener(MouseEvent.CLICK, searchPhotoClicked);
			_btn_search = null;
			
			_btn_take.removeEventListener(MouseEvent.CLICK, takePhotoClicked);
			_btn_take = null;
			
			_btn_reg.removeEventListener(MouseEvent.CLICK, regBabyClicked);
			_btn_reg = null;
		}
		
		
		//이미지 업로드
		private var dataSource:IDataInput;
		private function imageSelected( event:MediaEvent ):void
		{
			Brain.Main.LoadingVisible = true;
			var imagePromise:MediaPromise = event.data;
			dataSource = imagePromise.open();
			
			if( imagePromise.isAsync )
			{
				var eventSource:IEventDispatcher = dataSource as IEventDispatcher;            
				eventSource.addEventListener( Event.COMPLETE, imageLoaded );         
			}
			else
			{
				imageLoaded();
			}
		}
		private function imageLoaded(event:Event=null):void
		{
			var imageBytes:ByteArray = new ByteArray();
			dataSource.readBytes( imageBytes );
			
			var loader:ExifLoader=new ExifLoader;
			loader.loadBytes(imageBytes);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(e:Event):void
			{
				if(loader.exif.ifds != null)
				{
					var orientation:Number=loader.exif.ifds.primary["Orientation"];
					var gps:Object=loader.exif.ifds.gps;
					
					var bitmap:Bitmap=loader.content as Bitmap;
					var bitmapData:BitmapData=bitmap.bitmapData;
					
					var scaleX:Number=1280/bitmapData.width;
					var scaleY:Number=1280/bitmapData.height;
					if(scaleX<scaleY) scaleY=scaleX;
					else scaleX=scaleY;
					
					var resizeBitmapData:BitmapData;
					var matrix:Matrix=new Matrix;
					
					/*
					orientation 값 (iPad2에서 테스트됨)
					1 - 정방향
					3 - 거꾸로
					6 - 왼쪽90도
					8 - 오른쪽90도
					*/
					
					if(orientation==6 || orientation==8)
					{
						resizeBitmapData=new BitmapData(bitmapData.height*scaleY,bitmapData.width*scaleX,false,0xFFFFFF);
						matrix.scale(scaleX,scaleY);
						if(orientation==6){
							matrix.translate(0,-resizeBitmapData.width);
							matrix.rotate(Math.PI/2);
						}
						else if(orientation==8){
							matrix.translate(-resizeBitmapData.height,0);
							matrix.rotate(-Math.PI/2);
						}
					}
					else
					{
						resizeBitmapData=new BitmapData(bitmapData.width*scaleX,bitmapData.height*scaleY,false,0xFFFFFF);
						matrix.scale(scaleX,scaleY);
						if(orientation==3)
						{
							matrix.scale(-1,-1);
							matrix.translate(resizeBitmapData.width,resizeBitmapData.height);
						}
					}
				}
				else
				{
					bitmap=loader.content as Bitmap;
					bitmapData=bitmap.bitmapData;
					
					scaleX=1280/bitmapData.width;
					scaleY=1280/bitmapData.height;
					if(scaleX<scaleY) scaleY=scaleX;
					else scaleX=scaleY;
					
					matrix=new Matrix;
					
					resizeBitmapData=new BitmapData(bitmapData.width*scaleX,bitmapData.height*scaleY,false,0xFFFFFF);
					matrix.scale(scaleX,scaleY);
				}
				
				resizeBitmapData.draw(bitmapData,matrix,null,null,null,true);
				
				var jpgOption:JPEGEncoderOptions=new JPEGEncoderOptions();
				var resizeBytes:ByteArray=new ByteArray;
				resizeBitmapData.encode(resizeBitmapData.rect,jpgOption,resizeBytes);
				
				
				
				var filename:String=Math.floor(Math.random()*100000).toString()+".jpg";
				
				var params:URLVariables = new URLVariables;
				params.user_seq = Brain.UserInfo.user_seq;
				params.child_seq = Brain.Main.PageParameters.child_seq;
				params.file=new URLFileVariable(resizeBytes,filename);
				Brain.Connection.post("cognitiveChildPicUpdateAction.cog", params, onUploadComplete);
			});
		}
		private function onUploadComplete(data:String):void
		{		
			Brain.Main.LoadingVisible = false;	
			if(data)
			{
				var result:Object=JSON.parse(data);
				
				if(result.j_errorMsg.length>0){
					new Alert(result.j_errorMsg).show();
					return;
				}
				
				Brain.UserInfo.child_pic = result.j_childInfo[0].child_pic;
				Brain.UserInfo.child_pic_thumbnail = result.j_childInfo[0].child_pic_thumbnail;
				Brain.UserInfo.rep_child_yn = true;
				Brain.saveEnviroment();
				
				if(_profileLoader){
					_profileLoader.mask=null;
					_profileLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onProfileLoadComplete);
					if(_profileLoader.parent)
						_profileLoader.parent.removeChild(_profileLoader);
					_profileLoader=null;
				}
				_profileLoader=new Loader;
				_profileLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onProfileLoadComplete);
				_profileLoader.load(new URLRequest(Config.SERVER_PATH+Brain.UserInfo.child_pic));
				
				return;
			}
			
			new Alert("사진 업로드 실패").show();
		}
		private function onProfileLoadComplete(e:Event):void
		{
			if(_profileLoader==null) return;
			
			var loaderInfo:LoaderInfo=e.currentTarget as LoaderInfo;
			var loader:Loader=loaderInfo.loader;
			
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onProfileLoadComplete);
			if(loader.content is Bitmap)
			{
				(loader.content as Bitmap).smoothing=true;
			}
			
			if(_profileLoader==loader)
			{
				if(_profileCache!=null)
				{
					_profileCache.contentLoaderInfo.removeEventListener(Event.COMPLETE,onProfileLoadComplete);
					if(_profileCache.parent) 
						_profileCache.parent.removeChild(_profileCache);
					_profileCache=null;
				}
				
				var file:File=File.applicationStorageDirectory.resolvePath("cache/profile.jpg");
				file.parent.createDirectory();
				if(!file.exists || file.size!=_profileLoader.contentLoaderInfo.bytesTotal)
				{
					var fs:FileStream=new FileStream;
					fs.open(file,FileMode.WRITE);
					fs.writeBytes(_profileLoader.contentLoaderInfo.bytes);
					fs.close();
				}
			}
			
			loader.width=191;
			loader.height=189;
			if(loader.scaleX<loader.scaleY)
				loader.scaleX=loader.scaleY;
			else
				loader.scaleY=loader.scaleX;
			
			loader.x=2+191/2-loader.width/2;
			loader.y=3+189/2-loader.height/2;
			
			loader.mask=_profileArea;
			_profile.addChildAt(loader,_profile.numChildren-1);
			
			Brain.Main.invalidateAnimateBitmap();
		}
	}
}
