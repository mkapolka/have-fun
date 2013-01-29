package as2 
{
	import org.component.Component;
	import org.component.Message;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class SoundComponent extends Component 
	{
		
		private var _trigger : String;
		private var _sound : String;
		
		public function SoundComponent() 
		{
			super();
		}
		
		override public function receiveMessage(message : Message):void
		{
			super.receiveMessage(message);
			
			if (message.type == _trigger)
			{
				AS2SoundManager.playSoundID(_sound);
			}
		}
		
		override public function loadContent(xml : XML):void
		{
			super.loadContent(xml);
			
			if (xmlElementExists(xml, "trigger"))
			{
				_trigger = xml.trigger;
			}
			
			if (xmlElementExists(xml, "sound"))
			{
				_sound = xml.sound;
			}
		}
		
	}

}