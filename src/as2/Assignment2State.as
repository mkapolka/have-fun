package as2 
{
	import flash.display.StageDisplayState;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import org.component.ContentLoader;
	import org.component.dialog.ConversationLibrary;
	import org.component.dialog.DialogFactories;
	import org.component.Entity;
	import org.component.EntityManager;
	import org.component.etc.EtcComponentLibrary;
	import org.component.flixel.FlixelFactories;
	import org.component.flixel.FlxObjectComponent;
	import org.flixel.FlxG;
	import org.flixel.FlxGame;
	import org.flixel.FlxState;
	
	/**
	 * Assignment2State is mostly responsible for calling the initialization methods of the top level systems,
	 * such as the component framework, the dialog manager, and any sprite or data libraries.
	 * Game logic is handled mostly by components.
	 * @author Marek Kapolka
	 */
	public class Assignment2State extends FlxState 
	{
		public static const FULLSCREEN : Boolean = false;
		
		//I ended up going with a serif typeface for the game font
		//even though i used the term "helvetica" generically to mean "this game's default font".
		[Embed(source = "../../res/liberation_serif_bold.ttf", fontFamily = "helvetica", embedAsCFF="false")]
		public var fontHelvetica : String;
		
		//These strings are used to identify which entities correspond to the dialog UI elements,
		//the mouse's UI elements, or the player, respectively.
		public static const DIALOG_TAG : String = "Dialog";
		public static const MOUSE_TAG : String = "Mouse";
		public static const PLAYER_TAG : String = "Player";
		
		//The following XML files were generated with the component framework's Unity-based editor.
		[Embed(source = "../../res/level.xml", mimeType = "application/octet-stream")]
		public static const LEVEL_XML : Class;
		
		[Embed(source = "../../res/ui.xml", mimeType = "application/octet-stream")]
		public static const UI_XML : Class;
		
		[Embed(source = "../../res/templates.xml", mimeType = "application/octet-stream")]
		public static const TEMPLATES_XML : Class;
		
		//The following are XML files that store the dialog data for the game
		
		[Embed(source = "../../res/dialog/dialog.xml", mimeType = "application/octet-stream")]
		public static const DIALOG_XML : Class;
		
		[Embed(source = "../../res/dialog/smartphone.xml", mimeType = "application/octet-stream")]
		public static const DIALOG_SMARTPHONE_XML : Class;
		
		[Embed(source = "../../res/dialog/naive.xml", mimeType = "application/octet-stream")]
		public static const DIALOG_NAIVE_XML : Class;
		
		[Embed(source = "../../res/dialog/bro.xml", mimeType = "application/octet-stream")]
		public static const DIALOG_BRO_XML : Class;
		
		[Embed(source = "../../res/dialog/cynic.xml", mimeType = "application/octet-stream")]
		public static const DIALOG_CYNIC_XML : Class;
		
		//private var _mouseManager : MouseManager = new MouseManager();
		
		public function Assignment2State() 
		{
			super();
		}
		
		public static function getMouseEntity():Entity
		{
			return TaggedObjectComponent.getObjectByTag(MOUSE_TAG);
		}
		
		public static function getPlayerEntity():Entity
		{
			return TaggedObjectComponent.getObjectByTag(PLAYER_TAG);
		}
		
		public static function getDialogEntity():Entity
		{
			return TaggedObjectComponent.getObjectByTag(DIALOG_TAG);
		}
		
		override public function create():void
		{			
			if (FULLSCREEN)
			{
				//Presentation Fullscreen mode
				FlxG.stage.displayState = StageDisplayState.FULL_SCREEN;
				FlxG.stage.fullScreenSourceRect = new Rectangle(0, 0, FlxG.width, FlxG.height);
			}
			
			//All the FlxObjects that are created by FlxObjectComponent and its subclasses
			//are added to a static FlxGroup that keeps track of them
			FlxObjectComponent.initializeGroup();
			
			//The entity framework builds entities by associating strings
			//with actionscript classes. These String->Class associations are established
			//By calling the folowing initialization methods
			FlixelFactories.initialize();
			DialogFactories.initialize();
			EtcComponentLibrary.initialize();
			
			AS2SpriteLibrary.initialize();
			AS2ComponentLibrary.initialize();
			
			//Set up the initial game data (player relationships, quest status, etc)
			AS2GameData.initialize();
			
			RoomManager.initialize();
			
			AS2SoundManager.initialize();
			
			ConversationLibrary.initialize(new XML(new DIALOG_XML()));
			ConversationLibrary.addDialogFile(new XML(new DIALOG_SMARTPHONE_XML()));
			ConversationLibrary.addDialogFile(new XML(new DIALOG_NAIVE_XML()));
			ConversationLibrary.addDialogFile(new XML(new DIALOG_BRO_XML()));
			ConversationLibrary.addDialogFile(new XML(new DIALOG_CYNIC_XML()));
			
			ContentLoader.loadContent(new XML(new TEMPLATES_XML()));
			ContentLoader.loadContent(new XML(new UI_XML()));
			
			//Start the game off in the starting room
			RoomManager.loadRoom(RoomManager.DEFAULT_KEY);
			//RoomManager.loadRoom(RoomManager.HOME_KEY);
		}
		
		override public function update():void
		{
			super.update();
			
			if (FULLSCREEN && FlxG.stage.displayState != StageDisplayState.FULL_SCREEN)
			{
				FlxG.stage.displayState = StageDisplayState.FULL_SCREEN;
				FlxG.stage.fullScreenSourceRect = new Rectangle(0, 0, FlxG.width, FlxG.height);
			}
			
			//Ticks the entity logic
			EntityManager.update();
		}
		
	}

}