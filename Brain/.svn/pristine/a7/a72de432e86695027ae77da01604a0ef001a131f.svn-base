package kr.pe.hs.push
{
	import flash.events.RemoteNotificationEvent;
	import flash.notifications.NotificationStyle;
	import flash.notifications.RemoteNotifier;
	import flash.notifications.RemoteNotifierSubscribeOptions;

	public class ApplePush
	{
		private var tokenId:String=null;
		public function get TokenID():String{ return tokenId; }
		
		private var preferredStyles:Vector.<String> = new Vector.<String>(); 
		private var subscribeOptions:RemoteNotifierSubscribeOptions = new RemoteNotifierSubscribeOptions(); 
		private var remoteNot:RemoteNotifier = new RemoteNotifier(); 
		public function ApplePush()
		{
			preferredStyles.push(NotificationStyle.ALERT ,NotificationStyle.BADGE,NotificationStyle.SOUND );
			subscribeOptions.notificationStyles= preferredStyles; 
			
			remoteNot.addEventListener(RemoteNotificationEvent.TOKEN,onTokenId); 
			/*remoteNot.addEventListener(RemoteNotificationEvent.NOTIFICATION,notificationHandler);
			remoteNot.addEventListener(StatusEvent.STATUS,statusHandler); */
		}
		
		private function onTokenId(e:RemoteNotificationEvent):void{
			tokenId=e.tokenId;
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			remoteNot.addEventListener(type,listener,useCapture,priority,useWeakReference); 
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			remoteNot.removeEventListener(type,listener,useCapture); 
		}
		
		public function register():Boolean{
			if(RemoteNotifier.supportedNotificationStyles.toString() != "") 
			{     
				remoteNot.subscribe(subscribeOptions);
				return true;
			} 
			else{ 
				//지원하지 않음
				return false;
			} 
		}  
		public function unregister():void{ 
			remoteNot.unsubscribe(); 
		} 		
	}
}