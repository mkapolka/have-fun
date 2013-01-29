package as2 
{
	import org.component.Component;
	import org.component.Message;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class OnStartTriggerComponent extends Component 
	{
		protected var _message : String = null;
		
		public function OnStartTriggerComponent() 
		{
			super();
		}
		
		override public function resolve():void
		{
			super.resolve();
			
			if (_message != null)
			{
				var message : Message = new Message();
				message.sender = this;
				message.type = _message;
				entity.sendMessage(message);
			}
		}
		
		override public function loadContent(xml : XML):void
		{
			super.loadContent(xml);
			
			if (xmlElementExists(xml, "message"))
			{
				_message = xml.message;
			}
		}
		
	}

}