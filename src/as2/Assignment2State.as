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
	import org.flixel.FlxState;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class Assignment2State extends FlxState 
	{
		public static const FULLSCREEN : Boolean = false;
		
		[Embed(source = "../../res/liberation_serif_bold.ttf", fontFamily = "helvetica", embedAsCFF="false")]
		public var fontHelvetica : String;
		
		public static const DIALOG_TAG : String = "Dialog";
		public static const MOUSE_TAG : String = "Mouse";
		public static const PLAYER_TAG : String = "Player";
		
		[Embed(source = "../../res/level.xml", mimeType = "application/octet-stream")]
		public static const LEVEL_XML : Class;
		
		[Embed(source = "../../res/ui.xml", mimeType = "application/octet-stream")]
		public static const UI_XML : Class;
		
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
		
		[Embed(source = "../../res/templates.xml", mimeType = "application/octet-stream")]
		public static const TEMPLATES_XML : Class;
		
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
			Mouse.show();
			
			if (FULLSCREEN)
			{
				//Presentation Fullscreen mode
				FlxG.stage.displayState = StageDisplayState.FULL_SCREEN;
				FlxG.stage.fullScreenSourceRect = new Rectangle(0, 0, FlxG.width, FlxG.height);
			}
			
			FlxObjectComponent.initializeGroup();
			
			FlixelFactories.initialize();
			DialogFactories.initialize();
			EtcComponentLibrary.initialize();
			
			AS2SpriteLibrary.initialize();
			AS2ComponentLibrary.initialize();
			
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
			
			//_mouseManager.update();
			EntityManager.update();
		}
		
	}

}