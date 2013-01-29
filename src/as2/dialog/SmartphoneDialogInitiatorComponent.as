package as2.dialog 
{
	import org.component.dialog.ConversationLibrary;
	import org.component.dialog.DialogPartner;
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class SmartphoneDialogInitiatorComponent extends AS2DialogInitiatorComponent 
	{
		
		public function SmartphoneDialogInitiatorComponent() 
		{
			super();
		}
		
		override public function initialize():void
		{
			super.initialize();
		}
		
		override protected function createDialogPartner():DialogPartner
		{
			var output : SmartphoneDialogPartner = new SmartphoneDialogPartner();
			output.portraitID = 1;
			output.id = "smartphone";
			output.name = "Siri";
			
			ConversationLibrary.buildDialogPartner(output);
			return output;
		}
		
	}

}