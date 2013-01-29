package as2 
{
	import flash.ui.Mouse;
	import org.component.flixel.FlxObjectComponent;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import flash.geom.Rectangle;
	import flash.display.StageDisplayState;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class AS2TitleScreen extends FlxState 
	{
		[Embed(source = "../../res/title.png")]
		public static const TITLE_PNG : Class;
		
		public function AS2TitleScreen() 
		{
			super();
		}
		
		override public function create():void
		{
			super.create();
			
			var title : FlxSprite = new FlxSprite(0, 0, TITLE_PNG);
			add(title);
			
			FlxG.stage.displayState = StageDisplayState.FULL_SCREEN;
			FlxG.stage.fullScreenSourceRect = new Rectangle(0, 0, FlxG.width, FlxG.height);
			
			Mouse.show();
		}
		
		override public function update():void
		{
			super.update();
			
			if (FlxG.mouse.justPressed())
			{
				FlxG.fade(0x0, 1, fadeCallback, false);;
			}
		}
		
		public function fadeCallback():void
		{
			FlxG.switchState(new Assignment2State());	
		}
	}

}