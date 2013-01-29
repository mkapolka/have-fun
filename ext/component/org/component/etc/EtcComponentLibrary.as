package org.component.etc 
{
	import org.component.ContentLoader;
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class EtcComponentLibrary 
	{
		
		public function EtcComponentLibrary() 
		{
			
		}
		
		public static function initialize():void
		{
			var entities : Array = ContentLoader.factories;
			
			entities["Relay"] = RelayComponent;
			entities["Timer"] = TimerComponent;
		}
		
	}

}