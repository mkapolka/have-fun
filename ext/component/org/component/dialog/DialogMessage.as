package org.component.dialog 
{
	import org.component.Message;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class DialogMessage extends Message 
	{
		public static const REGISTER_MANAGER : String = "register_manager";
		public static const OPEN_DIALOG : String = "open_dialog";
		public static const QUERY : String = "query";
		public static const SHOW_RESPONSE : String = "response";
		public static const UPDATE_PARTNER : String = "update_partner";
		public static const CLOSE_DIALOG : String = "close_dialog";
		
		public var partner : DialogPartner;
		public var message : String;
		public var response : DialogResponse;
		
		public function DialogMessage() 
		{
			super();
		}
		
	}

}