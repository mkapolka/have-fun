package as2.dialog 
{
	import as2.AS2GameData;
	import as2.Assignment2State;
	import as2.data.PersonData;
	import as2.TaggedObjectComponent;
	import org.component.dialog.ConversationLibrary;
	import org.component.dialog.DialogPartner;
	import org.component.Entity;
	/**
	 * A subclass of DialogInitiatorComponent that is more tailored to the AS2 ("Have Fun") project
	 * than its superclass. It creates an AS2DialogPartner to pass to the Dialog UI and has more
	 * settings specific to the features of the AS2DialogParnter class.
	 * @author Marek Kapolka
	 */
	public class AS2DialogInitiatorComponent extends DialogInitiatorComponent 
	{
		protected var _partnerName : String = "";
		protected var _partnerPortraitID : uint = 0;
		protected var _type : String;
		
		public function AS2DialogInitiatorComponent() 
		{
			super();
		}
		
		override protected function createDialogPartner():DialogPartner
		{
			var partner : AS2DialogPartner;//= new AS2DialogPartner();
			
			//Which subclass of DialogPartner should be used?
			switch (_type)
			{
				case "Default":
					partner = new AS2DialogPartner();
				break;
				
				case "Person":
					var person : PersonData = AS2GameData.loadPerson(_dialogPartnerID);
					
					partner = new CharacterDialogPartner(person);
				break;
				
				case "Smartphone":
					partner = new SmartphoneDialogPartner();
				break;
				
				case "Dresser":
					partner = new DresserDialogPartner();
				break;
			}
			
			partner.id = _dialogPartnerID;
			partner.name = _partnerName;
			partner.portraitID = _partnerPortraitID;
			
			ConversationLibrary.buildDialogPartner(partner);
			
			return partner;
		}
		
		/**
		 * Returns the Entity that is tagged with Assignment2State.DIALOG_TAG. 
		 * This entity and its children contain all the information for handling the
		 * dialog system of "Have Fun", most importantly the AS2DialogManagerComponent
		 * at the top entity.
		 * @return The Entity responsible for handling dialog messages.
		 */
		override protected function getDialogManagerEntity():Entity
		{
			return TaggedObjectComponent.getObjectByTag(Assignment2State.DIALOG_TAG);
		}
		
		/**
		 * Special parameters available to AS2DialogInitiatorComponent:
			 * "partnerName": The "name" value of the partner, which will be revealed to the player.
			 * "partnerPortraitID": The index of the portrait to show to the player.
			 * "partnerType": Which subclass of AS2DialogPartner to send to the dialog manager. Possible values include:
				 * 	"Default", "Smartphone", "Person", "Dresser".
		 * @param	xml
		 */
		override public function loadContent(xml : XML):void
		{
			super.loadContent(xml);
			
			if (xmlElementExists(xml, "partnerName"))
			{
				_partnerName = xml.partnerName;
			}
			
			if (xmlElementExists(xml, "partnerPortraitID"))
			{
				_partnerPortraitID = parseInt(xml.partnerPortraitID);
			}
			
			if (xmlElementExists(xml, "partnerType"))
			{
				_type = xml.partnerType;
			}
		}
		
	}

}