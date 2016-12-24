package
{
	import Page.Account.Index1;
	import Page.Account.Index2;
	import Page.Account.Info;
	import Page.Account.Join;
	import Page.Account.Login;
	import Page.Account.ManageBaby;
	import Page.Account.NewBaby;
	import Page.Account.SetPassword;
	import Page.Game.Game1;
	import Page.Game.Index;
	import Page.Game.Result;
	import Page.Game.Tutorial1;
	import Page.Help.Index;
	import Page.Help.Info;
	import Page.Login.Index;
	import Page.Main.Index;

	public class PageConnector
	{
		private static const PageClass:Object={
			"brainMainPage":Page.Main.Index,
			"brainUserLoginPage":Page.Login.Index,
			"brainAccountNotLoginPage":Page.Account.Index1,
			"brainAccountLoginPage":Page.Account.Index2,
			"brainAccountInfoPage":Page.Account.Info,
			"brainAccountJoinPage":Page.Account.Join,
			"brainLoginPage":Page.Account.Login,
			"brainAccountBabyManagePage":Page.Account.ManageBaby,
			"brainAccountNewBabyRegPage":Page.Account.NewBaby,
			"brainAccountNewBabyRegPage2":Page.Account.NewBaby2,
			"brainAccountSetPassword":Page.Account.SetPassword,
			"brainHelpPage":Page.Help.Index,
			"brainInfoPage":Page.Help.Info,
			
			"brainTutorial1Page":Page.Game.Tutorial1,
			"brainTutorial2Page":Page.Game.Tutorial2,
			"brainTutorial3Page":Page.Game.Tutorial3,
			"brainTutorial4Page":Page.Game.Tutorial4,
			"brainTutorial5Page":Page.Game.Tutorial5,
			"brainGameIndexPage":Page.Game.Index,
			"brainGameResultPage":Page.Game.Result,
			"brainGame1Page":Page.Game.Game1,
			"brainGame2Page":Page.Game.Game2,
			"brainGame3Page":Page.Game.Game3,
			"brainGame4Page":Page.Game.Game4,
			"brainGame5Page":Page.Game.Game5
		};
		
		public function PageConnector()
		{
		}
		
		public static function GetPageClass(name:String):Class{
			return PageClass[name];
		}
	}
}