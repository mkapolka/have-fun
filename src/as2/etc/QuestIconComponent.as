package as2.etc 
{
	import as2.AS2GameData;
	import as2.SmartphoneButtonComponent;
	import flash.events.KeyboardEvent;
	import org.component.Component;
	import org.component.Entity;
	import org.component.flixel.FlxObjectComponent;
	import org.component.flixel.FlxSpriteComponent;
	import org.component.Message;
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class QuestIconComponent extends SmartphoneButtonComponent
	{
		public static const NEW_ICON_NAME : String = "NewSprite";
		public static const NEW_MESSAGE : String = "new";
		public static const OLD_MESSAGE : String = "old";
		
		private static var _showNewIcon : Boolean = true;
		private static var _instance : QuestIconComponent = null;
		
		public function QuestIconComponent() 
		{
			super();
		}
		
		override public function resolve():void
		{
			super.resolve();
			
			_instance = this;
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			_instance = null;
		}
		
		public static function touch():void
		{
			if (_instance != null)
			{
				var m : Message = new Message();
				m.sender = _instance;
				m.type = OLD_MESSAGE;
				
				_instance.entity.sendMessage(m);
				
				m.type = BounceComponent.STOP_BOUNCING;
				
				_instance.entity.sendMessage(m);
			}			
		}
		
		public static function set showNewIcon(value : Boolean):void
		{
			_showNewIcon = value;
		}
		
		public function get newIcon():Entity
		{
			return entity.getChildByName(NEW_ICON_NAME);
		}
		
		override public function receiveMessage(message : Message):void
		{
			super.receiveMessage(message);
			
			if (message.type == "up")
			{				
				var m : Message = new Message();
				m.sender = this;
				m.type = OLD_MESSAGE;
				
				entity.sendMessage(m);
				
				m.type = BounceComponent.STOP_BOUNCING;
				
				entity.sendMessage(m);
			}
		}
		
		override public function update():void
		{
			super.update();
			if (AS2GameData.hasSmartphone && _showNewIcon)
			{
				_showNewIcon = false;
				
				var m : Message = new Message();
				m.sender = this;
				m.type = NEW_MESSAGE;
				
				entity.sendMessage(m);
				
				m.type = BounceComponent.START_BOUNCING;
				
				entity.sendMessage(m);
			}
		}
		
		
	}

}