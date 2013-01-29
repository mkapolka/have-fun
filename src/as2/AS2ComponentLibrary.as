package as2 
{
	import as2.character.CharacterComponent;
	import as2.data.WalkingEntranceComponent;
	import as2.dialog.AS2DialogInitiatorComponent;
	import as2.dialog.AS2DialogManagerComponent;
	import as2.dialog.CharacterDialogInitiatorComponent;
	import as2.dialog.CloseAnimationComponent;
	import as2.dialog.DialogInputComponent;
	import as2.dialog.DialogNameComponent;
	import as2.dialog.DialogOptionOffsetComponent;
	import as2.dialog.DialogPortraitComponent;
	import as2.dialog.GoodbyeOptionComponent;
	import as2.dialog.SmartphoneDialogInitiatorComponent;
	import as2.etc.AlarmClockComponent;
	import as2.etc.BounceComponent;
	import as2.etc.CafeAnimationComponent;
	import as2.etc.ChangeRoomComponent;
	import as2.etc.ClubJudgementComponent;
	import as2.etc.ClubLightComponent;
	import as2.etc.CountdownComponent;
	import as2.etc.DancerComponent;
	import as2.etc.EchoToParentComponent;
	import as2.etc.FollowParentComponent;
	import as2.etc.NaiveComponent;
	import as2.etc.NewDayComponent;
	import as2.etc.QuestIconComponent;
	import as2.etc.RoomEntranceComponent;
	import as2.etc.SquelchableComponent;
	import as2.etc.TextInputComponent;
	import as2.etc.UIScrollFactorComponent;
	import as2.etc.UISquelcherComponent;
	import as2.flixel.AS2FlxTextComponent;
	import as2.flixel.CenterVerticallyComponent;
	import as2.flixel.MaskComponent;
	import as2.flixel.PersonMaskComponent;
	import as2.ui.LevelTextComponent;
	import as2.ui.ProgressBarComponent;
	import as2.ui.ProgressPopupComponent;
	import org.component.ContentLoader;
	import as2.character.CharacterNavigationComponent;
	import as2.character.PlayerControllerComponent;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class AS2ComponentLibrary 
	{
		
		public function AS2ComponentLibrary() 
		{
			
		}
		
		public static function initialize():void
		{
			var factories : Array = ContentLoader.factories;
			
			//Alarm Clock
			factories["AlarmClock"] = AlarmClockComponent;
			
			factories["OnStartTrigger"] = OnStartTriggerComponent;
			factories["AS2Cursor"] = AS2CursorComponent;
			factories["ActableObject"] = ActableComponent;
			factories["TaggedObject"] = TaggedObjectComponent;
			factories["Button"] = ButtonComponent;
			factories["CharacterNavigation"] = CharacterNavigationComponent;
			factories["WalkableArea"] = WalkableAreaComponent;
			factories["PlayerController"] = PlayerControllerComponent;
			
			//UI
			factories["DialogPortrait"] = DialogPortraitComponent;
			factories["DialogName"] = DialogNameComponent;
			factories["DialogManager"] = AS2DialogManagerComponent; // Note that this is a switcheroo
			factories["DialogOptionOffset"] = DialogOptionOffsetComponent;
			factories["GoodbyeOption"] = GoodbyeOptionComponent;
			factories["Countdown"] = CountdownComponent;
			factories["LevelText"] = LevelTextComponent;
			
			factories["ProgressBar"] = ProgressBarComponent;
			factories["ProgressPopup"] = ProgressPopupComponent;
			
			factories["AS2DialogInitiator"] = AS2DialogInitiatorComponent;
			
			factories["CenterVertically"] = CenterVerticallyComponent;
			factories["EchoToParent"] = EchoToParentComponent;
			
			factories["SmartphoneButton"] = SmartphoneButtonComponent;
			factories["SmartphoneDialogInitiator"] = SmartphoneDialogInitiatorComponent;
			
			//etc
			factories["FollowParent"] = FollowParentComponent;
			factories["ChangeRoom"] = ChangeRoomComponent;
			factories["RoomEntrance"] = RoomEntranceComponent;
			factories["UISquelcher"] = UISquelcherComponent;
			factories["Squelchable"] = SquelchableComponent;
			factories["NewDay"] = NewDayComponent;
			factories["WalkingEntrance"] = WalkingEntranceComponent;
			factories["QuestIcon"] = QuestIconComponent;
			factories["Bounce"] = BounceComponent;
			factories["Naive"] = NaiveComponent;
			factories["Sound"] = SoundComponent;
			
			factories["UIScrollFactor"] = UIScrollFactorComponent;
			
			factories["Character"] = CharacterComponent;
			factories["CharacterDialogInitiator"] = CharacterDialogInitiatorComponent;
			
			factories["TextInput"] = TextInputComponent;
			factories["DialogInput"] = DialogInputComponent;
			
			factories["AnimatedClose"] = CloseAnimationComponent;
			
			//Flixel Things
			factories["Mask"] = MaskComponent;
			factories["PersonMask"] = PersonMaskComponent;
			
			//Experimental switcheroos
			factories["AS2FlxText"] = AS2FlxTextComponent;
			
			//Cafe components
			factories["CafeAnimation"] = CafeAnimationComponent;
			
			//Club components
			factories["Dancer"] = DancerComponent;
			factories["ClubLight"] = ClubLightComponent;
			factories["ClubJudgement"] = ClubJudgementComponent;
		}
		
	}

}