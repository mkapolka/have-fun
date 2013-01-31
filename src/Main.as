package 
{
	import as2.AS2TitleScreen;
	import as2.Assignment2State;
	import flash.ui.Mouse;
	import org.flixel.FlxGame;
	
	[SWF(width = "800", height = "600", backgroundColor = "#000000")]
	[Frame(factoryClass = "Preloader")]	
	
	/**
	 * Entry point. Following the flixel framework it's pretty sparse. All the magic starts in Assignment2State.as.
	 * @author Marek Kapolka
	 */
	public class Main extends FlxGame 
	{
		public function Main():void 
		{
			super(800, 600, Assignment2State , 1, 60, 60);
			useSystemCursor = true;
			Mouse.show();
		}
	}
	
}
