package as2 
{
	import org.flixel.FlxG;
	/**
	 * Associates Strings with sound files so they can be referenced in the unity editor
	 * and loaded in the game.
	 * @author Marek Kapolka
	 */
	public class AS2SoundManager 
	{
		[Embed(source = "../../res/sounds/down.mp3")]
		public static const DOWN_MP3 : Class;
		
		[Embed(source = "../../res/sounds/over.mp3")]
		public static const OVER_MP3 : Class;
		
		[Embed(source = "../../res/sounds/points.mp3")]
		public static const POINTS_MP3 : Class;
		
		[Embed(source = "../../res/sounds/powerup.mp3")]
		public static const POWERUP_MP3 : Class;
		
		[Embed(source = "../../res/sounds/smartphone_2.mp3")]
		public static const SMARTPHONE_MP3 : Class;
		
		[Embed(source = "../../res/sounds/quest_complete_3.mp3")]
		public static const QUEST_COMPLETE_MP3 : Class;
		
		[Embed(source = "../../res/sounds/quest_complete.mp3")]
		public static const LEVEL_UP_MP3 : Class;
		
		[Embed(source = "../../res/sounds/quest_start.mp3")]
		public static const QUEST_START_MP3 : Class;
		
		[Embed(source = "../../res/sounds/club_music.mp3")]
		public static const CLUB_MP3 : Class;
		
		[Embed(source = "../../res/sounds/wakeup.mp3")]
		public static const WAKEUP_MP3 : Class;
		
		private static var _sounds : Array = new Array();
		
		public function AS2SoundManager() 
		{
			
		}
		
		public static function initialize():void
		{
			_sounds["down"] = DOWN_MP3;
			_sounds["over"] = OVER_MP3;
			_sounds["points"] = POINTS_MP3;
			_sounds["powerup"] = POWERUP_MP3;
			_sounds["smartphone"] = SMARTPHONE_MP3;
			_sounds["quest_complete"] = QUEST_COMPLETE_MP3;
			_sounds["quest_start"] = QUEST_START_MP3;
			_sounds["level_up"] = LEVEL_UP_MP3;
			_sounds["club"] = CLUB_MP3;
			_sounds["wakeup"] = WAKEUP_MP3;
		}
		
		public static function playSound(sound : Class, volume : Number = 1.0, looped : Boolean = false):void
		{
			FlxG.play(sound, volume, looped);
		}
		
		public static function playSoundID(sound : String):void
		{
			playSound(_sounds[sound]);
		}
		
	}

}
