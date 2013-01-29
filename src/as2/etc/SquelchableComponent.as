package as2.etc 
{
	import as2.RoomManager;
	import org.component.Component;
	import org.component.flixel.FlxObjectComponent;
	import org.component.Message;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class SquelchableComponent extends Component 
	{
		
		public function SquelchableComponent() 
		{
			super();
		}
		
		private function hide():void
		{
			var m : Message = new Message();
			m.sender = this;
			m.type = FlxObjectComponent.HIDE;
			entity.sendMessage(m);
			
			m.type = FlxObjectComponent.DISABLE;
			entity.sendMessage(m);
		}
		
		private function show():void
		{
			var m : Message = new Message();
			m.sender = this;
			m.type = FlxObjectComponent.SHOW;
			entity.sendMessage(m);
			
			m.type = FlxObjectComponent.ENABLE;
			entity.sendMessage(m);
		}
		
		override public function resolve():void
		{
			super.resolve();
			
			if (UISquelcherComponent.squelch)
			{
				hide();
			} else {
				show();
			}
		}
		
		override public function receiveMessage(message : Message):void
		{
			super.receiveMessage(message);
			
			if (message.type == RoomManager.ROOM_ENTER_MESSAGE)
			{
				if (UISquelcherComponent.squelch)
				{
					hide();
				} else {
					show();
				}
			}
		}
		
	}

}