package Page.Main
{
	import Page.BasePage;
	import Page.PageEffect;
	
	public class Main extends BasePage
	{		
		public function Main(params:Object=null)
		{
			super();
		}
		public override function init():void
		{
			Elever.Main.changePage("HomePage", PageEffect.NONE);
		}
		public override function onResize():void
		{
		}
		
		public override function dispose():void
		{
		}
	}
}