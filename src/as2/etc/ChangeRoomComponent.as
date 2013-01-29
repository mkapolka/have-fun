package as2.etc 
{
	import as2.Assignment2State;
	import as2.RoomManager;
	import org.component.Component;
	import org.component.Message;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class ChangeRoomComponent extends Component 
	{		
		private var _trigger : String = "action";
		private var _room : String = "room";
		private var _transitionType : uint = 0;
		private var _entrance : String = null;
		
		public function ChangeRoomComponent() 
		{
			super();
		}
		
		override public function receiveMessage(message : Message):void
		{
			super.receiveMessage(message);
			
			if (message.type == _trigger)
			{
				RoomManager.transition(_room, _transitionType, _entrance);
			}
		}
		
		override public function loadContent(xml : XML):void
		{
			super.loadContent(xml);
			
			if (xmlElementExists(xml, "trigger"))
			{
				_trigger = xml.trigger;
			}
			
			if (xmlElementExists(xml, "room"))
			{
				_room = xml.room;
			}
			
			if (xmlElementExists(xml, "entrance"))
			{
				_entrance = xml.entrance;
				
				if (_entrance == "") _entrance = null;
			}
			
			if (xmlElementExists(xml, "transitionType"))
			{
				var tt : String = xml.transitionType;
				switch (tt)
				{
					case "None":
						_transitionType = RoomManager.NONE;
					break;
					
					case "Fade":
						_transitionType = RoomManager.FADE;
					break;
				}
			}
		}
		
	}

}