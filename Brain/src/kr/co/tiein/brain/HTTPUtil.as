package kr.co.tiein.brain
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import co.uk.mikestead.net.URLRequestBuilder;

	public class HTTPUtil
	{
		private var _basePath:String;
		public function get BasePath():String{ return _basePath; }
		
		private var _urlLoader:URLLoader
		
		private var _path:Vector.<String>;
		private var _params:Vector.<URLVariables>;
		private var _callback:Vector.<Function>;
		
		private var _currentParams:URLVariables;
		
		private var _isBusy:Boolean;
		
		public function get CurrentParameters():URLVariables{ return _currentParams; }
		
		public function HTTPUtil(basePath:String)
		{
			_path=new Vector.<String>;
			_params=new Vector.<URLVariables>;
			_callback=new Vector.<Function>;
			
			_basePath=basePath;
			
			_urlLoader=new URLLoader;
			_urlLoader.addEventListener(Event.COMPLETE, onComplete);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			
			_isBusy=false;
		}
		
		public function post(path:String,params:URLVariables,callback:Function):void{
			_path[_path.length]=_basePath+path;
			_callback[_callback.length]=callback;
			_params[_params.length]=params;
			
			next();
		}
		
		public function remove(path:String):void{
			for(var i:int=(_isBusy?1:0);i<_path.length;i++){
				if(_path[i]==path){
					_path.splice(i,1);
					_params.splice(i,1);
					_callback.splice(i,1);
					
					i--;
					continue;
				}
			}
		}
		
		private function next():void{
			if(_isBusy || _path.length==0) return;
			
			_currentParams=_params[0];
			
			var urlReq:URLRequest=new URLRequestBuilder(_currentParams).build();
			
			urlReq.url=_path[0];
			urlReq.method = URLRequestMethod.POST;
			
			trace("load " + urlReq.url);
			
			_urlLoader.load(urlReq);
			
			_isBusy=true;
		}
		
		private function onComplete(e:Event):void{
			
			trace("complete");
			
			if(_callback!=null){
				var urlLoader:URLLoader=(e.currentTarget as URLLoader);
				var result:String=urlLoader.data;
				
				if(!result) result="";
				else{
					var startPos:int=result.lastIndexOf("<textarea");
					if(startPos>=0){
						startPos=result.indexOf(">",startPos)+1;
						var endPos:int=result.indexOf("</textarea>",startPos);
						
						result=result.substr(startPos,endPos-startPos);
					}
				}
				
				try{
					_callback[0](result);
				}
				catch(e:Error){
					
				}
			}
			
			_path.splice(0,1);
			_params.splice(0,1);
			_callback.splice(0,1);
			
			_isBusy=false;
			
			next();
		}
		
		private function onError(e:IOErrorEvent):void{
			_isBusy=false;
			
			if(_callback[0]!=null){
				_callback[0](null);
			}
			
			_path.splice(0,1);
			_params.splice(0,1);
			_callback.splice(0,1);
			
			next();
		}
	}
}