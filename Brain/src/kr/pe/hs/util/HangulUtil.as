package kr.pe.hs.util
{
	public class HangulUtil
	{
		private static const CHO:String="ㄱㄲㄴㄷㄸㄹㅁㅂㅃㅅㅆㅇㅈㅉㅊㅋㅌㅍㅎ";
		private static const JUNG:String="ㅏㅐㅑㅒㅓㅔㅕㅖㅗㅘㅙㅚㅛㅜㅝㅞㅟㅠㅡㅢㅣ";
		private static const JONG:String=" ㄱㄲㄳㄴㄵㄶㄷㄹㄺㄻㄼㄽㄾㄿㅀㅁㅂㅄㅅㅆㅇㅈㅊㅋㅌㅍㅎ";		
		
		public static function getChosung(value:String,length:int=0):String{
			var result:String="";
			if(length==0) length=value.length;
			if(length>value.length) length=value.length;
			for(var i:int=0;i<length;i++){
				if(value.charCodeAt(i) >= 0xAC00) //한글일 때 
				{
					var indexVal:int=value.charCodeAt(i)-0xAC00;
					var cho:int=((indexVal-(indexVal%28))/28)/21;
					var jung:int=((indexVal-(indexVal%28))/28)%21;
					var jong:int=indexVal%28;
					
					result+=CHO.substr(cho,1);
				}
				else{
					result+=value.substr(i,1);
				}
			}
			
			return result;
		}
	}
}