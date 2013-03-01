package as2.dialog 
{
	import org.component.Component;
	import org.component.dialog.DialogMessage;
	import org.component.dialog.DialogPartner;
	import org.component.Entity;
	import org.component.Message;
	
	/**
	 * Component that brings up a dialog screen when a certain trigger message is received.
	 * This version of DialogInitiatorComponent creates a DialogPartner object, as opposed
	 * to the subclasses of DialogInitiatorComponent, such as AS2DialogInitiatorComponent or
	 * SmartphoneDialogInitiatorComponent, which create different subclasses of DialogPartner.
	 * 
	 * This class should be considered virtual, as it does not implement the "getDialogManagerEntity",
	 * which is meant to return the entity that will be used to identify the dialog manager.
	 * Subclasses of this should be sure to properly implement this method. Take a look at AS2DialogInitiatorComponent
	 * for an example implementation of this method.
	 * @author Marek Kapolka
	 */
	public class DialogInitiatorComponent extends Component 
	{
		protected var _trigger : String;
		protected var _dialogPartnerID : String;
		protected var _initialTopic : String = null;
		
		public function DialogInitiatorComponent() 
		{
			super();
		}
		
		protected function createDialogPartner():DialogPartner
		{
			var dialogPartner : DialogPartner = new DialogPartner();
			dialogPartner.id = _dialogPartnerID;
			
			return dialogPartner;
		}
		
		/**
		 * Returns the Entity that will serve as the dialog manager. 
		 * When the trigger message is received by this component, it will send
		 * a message of type DialogMessage to the entity returned by this message
		 * to initiate the dialog. 
		 * @return An entity capable of responding to DialogMessage objects.
		 */
		protected function getDialogManagerEntity():Entity
		{
			return null;
		}
		
		override public function receiveMessage(message : Message):void
		{
			super.receiveMessage(message);
			
			if (message.type == _trigger)
			{
				var dialogPartner : DialogPartner = createDialogPartner();
				var dialogManager : Entity = getDialogManagerEntity();
				
				if (dialogManager != null)
				{
					var dm : DialogMessage = new DialogMessage();
					dm.sender = this;
					dm.type = DialogMessage.OPEN_DIALOG;
					dm.partner = dialogPartner;
					
					dialogManager.sendMessage(dm);
					
					if (_initialTopic != null)
					{
						dm.type = DialogMessage.QUERY;
						dm.message = _initialTopic;
						
						dialogManager.sendMessage(dm);
					}
				}
			}
		}
		
		/**
		 * This component takes the following values:
			 * "trigger"- the type value of the message that will tell this component to bring up the dialog UI
			 * "dialogPartnerID" - The ID of the DialogPartner that will be passed to the dialog UI
			 * "initialTopic" - The id of the topic that will be queried when the dialog screen is shown.
		 * 
		 * @param	xml The XML object that will contain the data for building this component.
		 */
		override public function loadContent(xml : XML):void
		{
			super.loadContent(xml);
			
			if (xmlElementExists(xml, "trigger"))
			{
				_trigger = xml.trigger;
			}
			
			if (xmlElementExists(xml, "dialogPartnerID"))
			{
				_dialogPartnerID = xml.dialogPartnerID;
			}
			
			if (xmlElementExists(xml, "initialTopic"))
			{
				if (xml.initialTopic != "")
				{
					_initialTopic = xml.initialTopic;
				}
			}
		}
		
	}

}