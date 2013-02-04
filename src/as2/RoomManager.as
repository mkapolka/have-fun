package as2 
{
	import as2.character.CharacterComponent;
	import as2.character.CharacterNavigationComponent;
	import as2.character.PlayerControllerComponent;
	import as2.etc.RoomEntranceComponent;
	import org.component.Component;
	import org.component.ContentLoader;
	import org.component.Entity;
	import org.component.EntityManager;
	import org.component.flixel.Anchor;
	import org.component.flixel.FlxObjectComponent;
	import org.component.Message;
	import org.component.Template;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	/**
	 * Handles loading and unloading the content of rooms. The entities contained in rooms
	 * are tracked separately from EntityManager's total list so that some entities (UI elements for instance)
	 * can be shared.
	 * @author Marek Kapolka
	 */
	public class RoomManager 
	{
		//Transition types
		public static const NONE : uint = 0;
		public static const FADE : uint = 1;
		
		[Embed(source = "../../res/alarmclock/alarmclock.xml", mimeType = "application/octet-stream")]
		public static var ALARMCLOCK_LEVEL_XML : Class;
		
		[Embed(source = "../../res/rooms/newday.xml", mimeType = "application/octet-stream")]
		public static var NEWDAY_XML : Class;
		
		[Embed(source = "../../res/level.xml", mimeType = "application/octet-stream")]
		public static var ROOM_XML : Class;
		
		[Embed(source = "../../res/bathroom_level.xml", mimeType = "application/octet-stream")]
		public static var BATHROOM_XML : Class;
		
		[Embed(source = "../../res/room_2.xml", mimeType = "application/octet-stream")]
		public static var ROOM_2_XML : Class;
		
		[Embed(source = "../../res/cafe_level.xml", mimeType = "application/octet-stream")]
		public static const CAFE_ROOM_XML : Class;
		
		[Embed(source = "../../res/cafe_2_level.xml", mimeType = "application/octet-stream")]
		public static const CAFE_2_ROOM_XML : Class;
		
		[Embed(source = "../../res/test_level.xml", mimeType = "application/octet-stream")]
		public static const TEST_LEVEL_XML  : Class;
		
		[Embed(source = "../../res/rooms/gym_level.xml", mimeType = "application/octet-stream")]
		public static const GYM_ROOM_XML : Class;
		
		[Embed(source = "../../res/rooms/club_level.xml", mimeType = "application/octet-stream")]
		public static const CLUB_ROOM_XML : Class;
		
		[Embed(source = "../../res/rooms/title.xml", mimeType = "application/octet-stream")]
		public static const TITLE_XML : Class;
		
		public static const DEFAULT_KEY : String = TITLE_KEY;
		
		//IDs for the rooms so they can be referenced in the unity editor
		public static const HOME_KEY : String = "home";
		public static const CAFE_KEY : String = "starbucks";
		public static const CAFE_2_KEY : String = "cafe_2";
		public static const ALARM_KEY : String = "alarm_clock";
		public static const NEWDAY_KEY : String = "newday_key";
		public static const GYM_KEY : String = "gym";
		public static const CLUB_KEY : String = "club";
		public static const TITLE_KEY : String = "title";
		
		public static const PLAYER_TEMPLATE_ID : String = "player";	
		//These messages are sent to all entities (including those not tracked by RoomManager
		//when a room is loaded or unloaded.
		public static const ROOM_ENTER_MESSAGE : String = "room_enter";
		public static const ROOM_LEAVE_MESSAGE : String = "room_leave";
		
		private static var _rooms : Array; // Array of xml objects keyed on strings representing the level xml data and that level's id
		
		private static var _currentRoomContents : Vector.<Entity>;
		
		//The room that is currently being transitioned into
		private static var _room : String;
		//The entrance to put the player at once they enter the room
		private static var _entrance : String;
		
		public function RoomManager() 
		{
			
		}
		
		/**
		 * Sets up the array that associates strings with classes (representing
		 * the XML file that contains the information for a certain room) for use
		 * in referring to and loading that room.
		 */
		public static function initialize():void
		{
			_rooms = new Array();
			var r : Array = _rooms;
			
			r[DEFAULT_KEY] = ROOM_XML;
			r[HOME_KEY] = ROOM_XML;
			r["outside"] = ROOM_2_XML;
			r[CAFE_KEY] = CAFE_ROOM_XML;
			r[CAFE_2_KEY] = CAFE_2_ROOM_XML;
			r["bathroom"] = BATHROOM_XML;
			r[ALARM_KEY] = ALARMCLOCK_LEVEL_XML;
			r[NEWDAY_KEY] = NEWDAY_XML;
			r["test_level"] = TEST_LEVEL_XML;
			r[GYM_KEY] = GYM_ROOM_XML;
			r[CLUB_KEY] = CLUB_ROOM_XML;
			r[TITLE_KEY] = TITLE_XML;
		}
		
		/**
		 * Loads the given room. This will automatically unload the currently loaded room.
		 * @param	key The string name of the room to load. These are given by the static consts
		 * defined in this class with the names *_KEY .
		 */
		public static function loadRoom(key : String):void
		{	
			FlxG.camera.follow(null);
			
			if (_rooms[key] == null)
			{
				trace("ERROR: Could not find room with key \"" + key + "\"");
				return;
			}
			
			if (_currentRoomContents != null)
			{
				unloadRoom();
			}
			
			var xml : XML = new XML(new _rooms[key]());
			
			if (xml == null)
			{
				xml = _rooms[DEFAULT_KEY];
			}
			
			//Hack to make restarting better
			if (key == TITLE_KEY)
			{
				AS2GameData.initialize();
			}
			
			_currentRoomContents = ContentLoader.loadContent(xml);
			
			AS2GameData.currentLocation = key;
			
			var lrm : Message = new Message;
			lrm.sender = null;
			lrm.type = ROOM_ENTER_MESSAGE;
			//Remaining entities get the "entering room" message
			for each (var entity : Entity in EntityManager.getAllEntities())
			{
				entity.sendMessage(lrm);
			}
			
			FlxG.camera.scroll.x = 0;
			FlxG.camera.scroll.y = 0;
		}
		
		/**
		 * Removes all currently loaded entities that are managed by the room manager.
		 * Sends a message with type RoomManager.ROOM_LEAVE_MESSAGE to all remaining entities.
		 */
		public static function unloadRoom():void
		{
			for each (var entity : Entity in _currentRoomContents)
			{
				EntityManager.removeEntity(entity, true);
			}
			
			var lrm : Message = new Message;
			lrm.sender = null;
			lrm.type = ROOM_LEAVE_MESSAGE;
			//Remaining entities get the "leaving room" message
			for each (entity in EntityManager.getAllEntities())
			{
				entity.sendMessage(lrm);
			}
		}
		
		public static function get entranceName():String
		{
			return _entrance;
		}
		
		/**
		 * Creates a visual effect (such as fading) before loading the next room.
		 * @param	roomid The room to load after the effect.
		 * @param	transitionType The type of transition. Valid values are RoomManager.NONE and RoomManager.FADE
		 * @param	entranceName Which entrance to move the player to when they arrive in the loaded room.
		 */
		public static function transition(roomid : String, transitionType : uint, entranceName : String = null):void
		{
			_room = roomid;
			_entrance = entranceName;
			
			AS2GameData.currentLocation = roomid;
			
			switch (transitionType)
			{
				default:
				case NONE:
					delayLoad();
				break;
				
				case FADE:
					FlxG.fade(0x0, 1, delayLoadFlash, false);
					
					var player : Entity = Assignment2State.getPlayerEntity();
					if (player != null)
					{
						var dm : Message = new Message();
						dm.type = "disable";
						Assignment2State.getPlayerEntity().sendMessage(dm);
					}
					
				break;
			}
		}
		
		private static function delayLoad():void
		{
			RoomManager.loadRoom(_room);
		}
		
		private static function delayLoadFlash():void
		{
			RoomManager.loadRoom(_room);
			FlxG.camera.stopFX();
			FlxG.flash(0x0, 1);
		}
		
		
	}

}
