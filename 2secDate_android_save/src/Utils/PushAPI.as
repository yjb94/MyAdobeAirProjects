package Utils
{
//	import com.afterisk.shared.ane.lib.GCMEvent;
//	import com.afterisk.shared.ane.lib.GCMPushInterface;
	
	import com.afterisk.shared.ane.lib.GCMEvent;
	import com.afterisk.shared.ane.lib.GCMPushInterface;
	
	import flash.desktop.NativeApplication;
	import flash.events.InvokeEvent;
	import flash.events.RemoteNotificationEvent;
	import flash.notifications.NotificationStyle;
	import flash.notifications.RemoteNotifier;
	import flash.notifications.RemoteNotifierSubscribeOptions;
	import flash.system.Capabilities;
	
	public class PushAPI
	{
		private var tokenId:String=null;
		public function get TokenID():String{ return tokenId; }
		private var UDID_seq:String=null;
		public function get UDID():String{ return UDID_seq; }
		public function set UDID(str:String):void { UDID_seq = str; }
		
		private var preferredStyles:Vector.<String> = new Vector.<String>(); 
		private var subscribeOptions:RemoteNotifierSubscribeOptions = new RemoteNotifierSubscribeOptions(); 
		private var remoteNot:RemoteNotifier = new RemoteNotifier();
		
		private var _gcmi:GCMPushInterface;
		private var _payload:String;
		
		private var osValue:String = Capabilities.os;
		
		private var _callback:Function;
		
		public function PushAPI()
		{
			osValue = Capabilities.os;
			
			UDID = Elever.loadEnviroment("UDID", UDID_seq) as String;
			
//			if(osValue.substr(0,9)=="iPhone OS")
//			{
//				preferredStyles.push(NotificationStyle.ALERT ,NotificationStyle.BADGE,NotificationStyle.SOUND );
//				subscribeOptions.notificationStyles = preferredStyles; 
//				
//				remoteNot.addEventListener(RemoteNotificationEvent.TOKEN,onTokenId);
//			}
//			else
			{
				_gcmi = new GCMPushInterface();
				
				_gcmi.addEventListener(GCMEvent.REGISTERED, handleRegistered, false, 0, true);
				_gcmi.addEventListener(GCMEvent.MESSAGE, handleMessage, false, 0, true);
			}
		}
		private function onTokenId(e:RemoteNotificationEvent):void
		{
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
		
		public function register(callback:Function=null):Boolean
		{
			_callback = callback;
			
			var temp:String = RemoteNotifier.supportedNotificationStyles.toString();
			if(RemoteNotifier.supportedNotificationStyles.toString() != "") 
			{
				remoteNot.subscribe(subscribeOptions);
				return true;
			} 
			else
			{				
				var response:String = _gcmi.register("241894691053");
				trace(response);
				
				if(response.indexOf("registrationID:") != -1)
				{
					tokenId = response.substr(response.indexOf(":") + 1);
					checkPendingFromLaunchPayload();
				}
				return true;
			}
			return false;
		}
		private function handleRegistered(e:GCMEvent):void
		{
			trace("\n\nreceived device registrationID: " + e.deviceRegistrationID);
			tokenId = e.deviceRegistrationID;
			_callback();
		}
		private function handleMessage(e:GCMEvent):void
		{
			//get payload
			trace("app is in the background: adding GCM app invoke listener");
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke, false, 0, true);
		}
		private function onInvoke(e:InvokeEvent):void
		{
			trace("app was invoked by gcm notification");
			NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, onInvoke);
			handlePayload();
		}
		public function unregister():void
		{
			remoteNot.unsubscribe();
			_gcmi.unregister();
		}
		public function checkPendingFromLaunchPayload():void
		{
			_payload = _gcmi.checkPendingPayload();
			if(_payload != GCMPushInterface.NO_MESSAGE)
			{
				trace("\n\npending payload:" + _payload);
				handlePayload();
			}
		}
		public function handlePayload():void
		{
			//you can parse and treat gcm payload here
			//dispatch an event or open an appropriate view
		}
	}
}