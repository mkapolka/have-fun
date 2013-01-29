package as2.etc 
{
	import org.component.Component;
	import org.component.Message;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class EchoToParentComponent extends Component 
	{
		private var _messages : Vector.<String> = new Vector.<String>();
		
		public function EchoToParentComponent() 
		{
			super();
		}
		
		override public function receiveMessage(message : Message):void
		{
			for each (var check : String in _messages)
			{
				if (message.type == check)
				{
					if (entity.parent != null)
					{
						entity.parent.sendMessage(message, false);
					}
				}
			}
		}
		
		override public function loadContent(xml : XML):void
		{
			super.loadContent(xml);
			
			if (xmlElementExists(xml, "messages"))
			{
				var a : Array = extractArray(xml.messages);
				
				for each (var s : String in a)
				{
					_messages.push(s);
				}
			}
		}
		
	}

}