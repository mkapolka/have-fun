package as2 
{
	import org.component.flixel.SpriteLibrary;
	/**
	 * Associates Strings with sprites so they can be referenced in the unity editor and loaded
	 * in the game.
	 * @author Marek Kapolka
	 */
	public class AS2SpriteLibrary 
	{
		//Clock Scene
		[Embed(source = "../../res/alarmclock/click.png")]
		public static var CLICK_PNG : Class;
		
		[Embed(source = "../../res/alarmclock/clock_body.png")]
		public static var CLOCK_BODY_PNG : Class;
		
		[Embed(source = "../../res/alarmclock/dots.png")]
		public static var DOTS_PNG : Class;
		
		[Embed(source = "../../res/alarmclock/numerals.png")]
		public static var NUMERALS_PNG : Class;
		
		[Embed(source = "../../res/alarmclock/background.png")]
		public static var CLOCK_BACKGROUND_PNG : Class;
		
		//Normal stuff
		
		//[Embed(source = "../../res/walker.png")]
		[Embed(source="../../res/walker_2.png")]
		public static var WALKER_PNG : Class;
		
		[Embed(source = "../../res/background.png")]
		public static var BACKGROUND_PNG : Class;
		
		[Embed(source = "../../res/room_background.png")]
		public static var ROOM_BACKGROUND_PNG : Class;
		
		[Embed(source = "../../res/gym_background.png")]
		public static var GYM_BACKGROUND_PNG : Class;
		
		//UI
		[Embed(source = "../../res/dialog_portraits.png")]
		public static var DIALOG_PORTRAITS_PNG : Class;
		
		[Embed(source = "../../res/dialog_background.png")]
		public static var DIALOG_BACKGROUND_PNG : Class;
		
		[Embed(source = "../../res/icons.png")]
		public static var ICONS_PNG : Class;
		
		[Embed(source = "../../res/textbox_option_2.png")]
		public static var TEXTBOX_OPTION_PNG : Class;
		
		[Embed(source = "../../res/smartphone_icon.png")]
		public static var SMARTPHONE_ICON_PNG : Class;
		
		[Embed(source = "../../res/portrait_background.png")]
		public static var PORTRAIT_BACKGROUND_PNG : Class;
		
		[Embed(source = "../../res/ui/smartphone.png")]
		public static var SMARTPHONE_PNG : Class;
		
		[Embed(source = "../../res/quest_icon.png")]
		public static var QUEST_ICON_PNG : Class;
		
		[Embed(source = "../../res/quest_new.png")]
		public static var QUEST_NEW_ICON_PNG : Class;
		
		[Embed(source = "../../res/ui/dialog_bubble.png")]
		public static var DIALOG_BUBBLE_PNG : Class;
		
		[Embed(source = "../../res/ui/input_bubble.png")]
		public static var INPUT_BUBBLE_PNG : Class;
		
		[Embed(source = "../../res/ui/left_arrow.png")]
		public static var LEFT_ARROW_PNG : Class;
		
		[Embed(source = "../../res/ui/right_arrow.png")]
		public static var RIGHT_ARROW_PNG : Class;
		
		[Embed(source = "../../res/ui/goodbye_option.png")]
		public static var GOODBYE_OPTION_PNG : Class;
		
		[Embed(source = "../../res/ui/option_bubbles.png")]
		public static var OPTION_BUBBLES_PNG : Class;
		
		[Embed(source = "../../res/ui/time_bg.png")]
		public static var TIME_BG_PNG : Class;
		
		[Embed(source = "../../res/ui/black.png")]
		public static var BLACK_PNG : Class;
		
		[Embed(source = "../../res/characters.png")]
		public static var CHARACTERS_PNG : Class;
		
		//Room
		[Embed(source = "../../res/bathroom_background.png")]
		public static var BATHROOM_BACKGROUND_PNG : Class;
		
		//CAFE
		[Embed(source = "../../res/cafe_background_wide.jpg")]
		public static var CAFE_BACKGROUND_JPG : Class;
		
		[Embed(source = "../../res/counters.png")]
		public static var COUNTERS_PNG : Class;
		
		[Embed(source = "../../res/table.png")]
		public static var TABLE_PNG : Class;
		
		[Embed(source = "../../res/table_2.png")]
		public static var TABLE_2_PNG : Class;
		
		//Cafe 2
		[Embed(source = "../../res/cafe_2_background.png")]
		public static const CAFE_2_BACKGROUND_PNG : Class;
		
		//TEST
		[Embed(source = "../../res/test_mask.png")]
		public static const TEST_MASK_PNG : Class;
		
		[Embed(source = "../../res/walker_mask.png")]
		public static const WALKER_MASK_PNG : Class;
		
		[Embed(source = "../../res/test_patterns.png")]
		public static const TEST_PATTERN_PNG : Class;

		//Club
		[Embed(source = "../../res/light.png")]
		public static const LIGHT_PNG : Class;
		
		[Embed(source = "../../res/club_background.png")]
		public static const CLUB_BACKGROUND_PNG : Class;

		[Embed(source = "../../res/dancers.png")]
		public static const DANCERS_PNG : Class;
		
		[Embed(source = "../../res/title.png")]
		public static const TITLE_PNG : Class;
		
		public function AS2SpriteLibrary() 
		{
			
		}
		
		public static function initialize():void
		{
			//Alarm clock
			SpriteLibrary.addSprite("clock_bg", CLOCK_BACKGROUND_PNG);
			SpriteLibrary.addSprite("clock_body", CLOCK_BODY_PNG);
			SpriteLibrary.addSprite("clock_numerals", NUMERALS_PNG);
			SpriteLibrary.addSprite("clock_dots", DOTS_PNG);
			SpriteLibrary.addSprite("clock_click", CLICK_PNG);
			
			//Characters, UI
			SpriteLibrary.addSprite("walker", WALKER_PNG);
			SpriteLibrary.addSprite("background", BACKGROUND_PNG);
			SpriteLibrary.addSprite("dialog_portraits", DIALOG_PORTRAITS_PNG);
			SpriteLibrary.addSprite("option_bg", TEXTBOX_OPTION_PNG);
			SpriteLibrary.addSprite("smartphone_icon", SMARTPHONE_ICON_PNG);
			SpriteLibrary.addSprite("portrait_background", PORTRAIT_BACKGROUND_PNG);
			SpriteLibrary.addSprite("characters", CHARACTERS_PNG);
			
			//UI
			SpriteLibrary.addSprite("ui_smartphone", SMARTPHONE_PNG);
			SpriteLibrary.addSprite("ui_quest_icon", QUEST_ICON_PNG);
			SpriteLibrary.addSprite("ui_quest_new", QUEST_NEW_ICON_PNG);
			SpriteLibrary.addSprite("ui_dialog_bubble", DIALOG_BUBBLE_PNG);
			SpriteLibrary.addSprite("ui_smartphone_dialog", DIALOG_BUBBLE_PNG);
			SpriteLibrary.addSprite("ui_input_bubble", INPUT_BUBBLE_PNG);
			SpriteLibrary.addSprite("ui_option_bubbles", OPTION_BUBBLES_PNG);
			SpriteLibrary.addSprite("ui_icons", ICONS_PNG);
			SpriteLibrary.addSprite("ui_dialog_background", DIALOG_BACKGROUND_PNG);
			SpriteLibrary.addSprite("ui_left_arrow", LEFT_ARROW_PNG);
			SpriteLibrary.addSprite("ui_right_arrow", RIGHT_ARROW_PNG);
			SpriteLibrary.addSprite("ui_goodbye_option", GOODBYE_OPTION_PNG);
			SpriteLibrary.addSprite("ui_time_bg", TIME_BG_PNG);
			SpriteLibrary.addSprite("ui_black", BLACK_PNG);
			
			//Room
			SpriteLibrary.addSprite("room_background", ROOM_BACKGROUND_PNG);
			SpriteLibrary.addSprite("bathroom_background", BATHROOM_BACKGROUND_PNG);
			
			//Cafe
			SpriteLibrary.addSprite("cafe_background", CAFE_BACKGROUND_JPG);
			SpriteLibrary.addSprite("counters", COUNTERS_PNG);
			SpriteLibrary.addSprite("table", TABLE_PNG);
			SpriteLibrary.addSprite("table_2", TABLE_2_PNG);
			
			//Cafe 2
			SpriteLibrary.addSprite("cafe_2_background", CAFE_2_BACKGROUND_PNG);
			
			//Gym
			SpriteLibrary.addSprite("gym_background", GYM_BACKGROUND_PNG);

			//Club
			SpriteLibrary.addSprite("club_background", CLUB_BACKGROUND_PNG);
			SpriteLibrary.addSprite("light", LIGHT_PNG);
			SpriteLibrary.addSprite("dancers", DANCERS_PNG);
			
			//etc
			SpriteLibrary.addSprite("title", TITLE_PNG);
			
			//Test
			SpriteLibrary.addSprite("test_pattern", TEST_PATTERN_PNG);
			SpriteLibrary.addSprite("test_mask", TEST_MASK_PNG);
			SpriteLibrary.addSprite("walker_mask", WALKER_MASK_PNG);
		}
		
	}

}
