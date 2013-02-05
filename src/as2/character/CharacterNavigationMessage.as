package as2.character 
{
	import org.component.Message;
	
	/**
	 * Used to tell CharacterNavigationComponents where to go. The two possible types
	 * are CharacterNavigationMessgae.SET_TARGET and CharacterNavigationMessage.CANCEL_TARGET.
	 * SET_TARGET expects the "data" variable to be a flash.geom.Point with the x and y coordinates
	 * of the target location.
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