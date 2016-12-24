package
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import kr.pe.hs.tween.Tween;

	public class Alert
	{
		private var _txt:TextField;
		private var _tween:Tween;
		
		public function Alert(message:String)
		{
			_txt=new TextField;
			_txt.type=TextFieldType.DYNAMIC;
			_txt.selectable=false;
			var fmt:TextFormat=_txt.defaultTextFormat;
			fmt.size=30;
			fmt.color=0xFFFFFF;
			_txt.defaultTextFormat=fmt;
			_txt.autoSize=TextFieldAutoSize.LEFT;
			_txt.backgroundColor=0x000000;
			_txt.background=true;
			_txt.text=message;
		}
		public function show():void{
			_txt.x=Brain.Main.stage.stageWidth/2-_txt.width/2;
			_txt.y=Brain.Main.stage.stageHeight/2-_txt.height/2;
			Brain.Main.stage.addChild(_txt);
			
			_tween=new Tween(_txt.alpha,0,1000,500,function(value:Number,isFinish:Boolean):void{
				_txt.alpha=value;
				if(isFinish){
					_txt.parent.removeChild(_txt);
					_txt=null;
					_tween=null;
				}
			});
		}
	}
}