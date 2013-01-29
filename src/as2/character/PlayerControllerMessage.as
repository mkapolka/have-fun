package as2.character 
{
	import org.component.Entity;
	import org.component.Message;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class PlayerControllerMessage extends Message 
	{
		public static const QUEUE_ACTION : String = "queue_message";
		public static const CLEAR_QUEUE : String = "clear_queue";
		
		public var fireMessage : Message;
		public var messageTarget : Entity;
		public var waitForMessage : String;
		public var cancelMessage : Message;
		
		public function PlayerControllerMessage() 
		{
			super();
		}
		
	}

}