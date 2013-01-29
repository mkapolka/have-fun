package as2.dialog 
{
	import org.component.Component;
	import org.component.dialog.DialogMessage;
	import org.component.dialog.DialogPartner;
	import org.component.Entity;
	import org.component.Message;
	
	/**
	 * ...
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