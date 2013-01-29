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
	 * ...
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
		
		override protected function getDialogManagerEntity():Entity
		{
			return TaggedObjectComponent.getObjectByTag(Assignment2State.DIALOG_TAG);
		}
		
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