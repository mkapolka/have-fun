package as2.character 
{
	import org.component.Entity;
	import org.component.Message;
	
	/**
	 * This message can be used to queue an action in PlayerControllerComponent. See PlayerControllerComponent for
	 * the meanings of the different parameters in this message, as they are the same as those in the PlayerControllerAction
	 * class.
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