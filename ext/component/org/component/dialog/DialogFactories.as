package org.component.dialog 
{	
	import org.component.ContentLoader;
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class DialogFactories 
	{
		
		public function DialogFactories() 
		{
			
		}
		
		public static function initialize():void
		{
			var f : Array = ContentLoader.factories;
			
			f["DialogBox"] = DialogTextBoxComponent;
			f["DialogManager"] = DialogManagerComponent;
			f["DialogOption"] = DialogOptionComponent;
		}
		
	}

}