package Page
{	
	import Page.Etc.CheckPassword;
	import Page.Etc.FindPassword;
	import Page.Etc.Join;
	import Page.Etc.Login;
	import Page.Home.Home;
	import Page.Home.ProjectInfo;
	import Page.Home.Register;
	import Page.Home.Tabs.PrevItem;
	import Page.Setting.Purchase;
	import Page.Setting.Setting;
	import Page.Setting.LoginInfo.LoginInfo;
	import Page.Setting.LoginInfo.ModifyUserInfo;
	import Page.Ticket.Ticket;

	public class PageConnector
	{
		private static const PageClass:Object=
		{
			"HomePage":Page.Home.Home,
			"PrevItem":Page.Home.Tabs.PrevItem,
			"NowItem":Page.Home.Tabs.NowItem,
			"ProjectInfoPage":Page.Home.ProjectInfo,
			"RegisterPage":Page.Home.Register,
			
			"TicketPage":Page.Ticket.Ticket,
			
			"SettingPage":Page.Setting.Setting,
			"PurchasePage":Page.Setting.Purchase,
			"LoginInfoPage":Page.Setting.LoginInfo.LoginInfo,
			"ModifyUserInfoPage":Page.Setting.LoginInfo.ModifyUserInfo,
			
			"LoginPage":Page.Etc.Login,
			"FindPasswordPage":Page.Etc.FindPassword,
			"JoinPage":Page.Etc.Join,
			"CheckPasswordPage":Page.Etc.CheckPassword
		};
		
		public function PageConnector()
		{
		}
		
		public static function GetPageClass(name:String):Class
		{
			return PageClass[name];
		}
	}
}