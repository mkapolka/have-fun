package as2.dialog 
{
	import as2.character.CharacterComponent;
	import as2.flixel.MaskMessage;
	import org.component.Component;
	import org.component.dialog.ConversationLibrary;
	import org.component.dialog.DialogPartner;
	import org.component.Message;
	/**
	 * A DialogInitiatorComponent that works specifically with
	 * entities containing a CharacterComponent
	 * @author Marek Kapolka
	 */
	public class CharacterDialogInitiatorComponent extends AS2DialogInitiatorComponent 
	{
		public static const DEFAULT_INITIAL_TOPIC : String = "greeting";
		public static const TRIGGER : String = "action";
		
		public function CharacterDialogInitiatorComponent() 
		{
			super();
			
			addRequisiteComponent(CharacterComponent);
			
			_initialTopic = DEFAULT_INITIAL_TOPIC;
		}
		
		public function get characterComponent():CharacterComponent
		{
			return getSiblingComponent(CharacterComponent) as CharacterComponent;
		}
		
		override public function resolve():void
		{
			super.resolve();
			
			var cc : CharacterComponent = characterComponent;
			
			_partnerName = cc.characterName;
			_dialogPartnerID = cc.characterID;
			_partnerPortraitID = cc.portraitID;
			_trigger = TRIGGER;
		}
		
		override public function receiveMessage(message : Message):void
		{
			super.receiveMessage(message);
			
			if (message.type == _trigger)
			{
				var cc : CharacterComponent = characterComponent;
				
				if (cc.data.upperClothing != null)
				{
					var maskMessage1 : MaskMessage = MaskMessage.makeSetMaskMessage(0, cc.data.upperClothing.texture);
					getDialogManagerEntity().sendMessage(maskMessage1);
				}
				
				if (cc.data.lowerClothing != null)
				{
					var maskMessage2 : MaskMessage = MaskMessage.makeSetMaskMessage(1, cc.data.lowerClothing.texture);
					getDialogManagerEntity().sendMessage(maskMessage2);	
				}
			}
		}
		
		override protected function createDialogPartner():DialogPartner
		{
			var output : CharacterDialogPartner = new CharacterDialogPartner(characterComponent.data);
			output.name = _partnerName;
			output.portraitID = _partnerPortraitID;
			output.id = _dialogPartnerID;
			
			ConversationLibrary.buildDialogPartner(output);
			return output;
		}
		
	}

}