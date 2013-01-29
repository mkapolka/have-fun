package as2.character 
{
	import org.component.Message;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class CharacterNavigationMessage extends Message 
	{
		public static const SET_TARGET : String = "set_target";
		public static const CANCEL_TARGET : String = "cancel_target";
		
		public var data : Object;
		
		public function CharacterNavigationMessage() 
		{
			super();
		}
		
	}

}