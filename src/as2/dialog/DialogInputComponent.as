package as2.dialog 
{
	import as2.etc.TextInputComponent;
	import org.component.Component;
	import org.component.dialog.ConversationLibrary;
	import org.component.dialog.DialogManagerComponent;
	import org.component.dialog.DialogMessage;
	import org.component.dialog.DialogResponse;
	import org.component.Entity;
	import org.component.flixel.FlxObjectComponent;
	import org.component.Message;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class DialogInputComponent extends Component 
	{
		public static const QUERY_DEFAULT : String = "input_default";
		public static const INPUT_HASHCODE : String = "#input";
		public static const DEFAULT_TEXT : String = "<Enter a Response>";
		
		private var _enterTrigger : String = "enter";
		
		public function DialogInputComponent() 
		{
			super();
			
			addRequisiteComponent(TextInputComponent);
		}
		
		public function get queryText():String
		{
			return textInputComponent.textField.text;
		}
		
		override public function receiveMessage(message : Message):void
		{
			super.receiveMessage(message);
			
			if (message.type == _enterTrigger)
			{
				//Determine whether to send an actual query or the special
				//"input default" query, for investigative peoples
				
				var qt : String = queryText;
				var dmc : DialogManagerComponent = dialogManager;
				var kw : String = ConversationLibrary.KEYWORDS[qt];
				if (kw != null) qt = kw;
				var response : DialogResponse = dmc.partner.peekQuery(qt);
				if (response == null) qt = QUERY_DEFAULT;
				
				var queryMessage : DialogMessage = new DialogMessage();
				queryMessage.type = DialogMessage.QUERY;
				queryMessage.message = qt;
				queryMessage.sender = this;
				
				dialogManager.entity.sendMessage(queryMessage);
			}
			
			if (message.type == DialogMessage.SHOW_RESPONSE)
			{
				var dm : DialogMessage = message as DialogMessage;
				
				var has_input : Boolean = false;
				
				if (dm.response is AS2DialogResponse)
				{
					var as2dr : AS2DialogResponse = dm.response as AS2DialogResponse;
					
					has_input = as2dr.input;
				}
				
				var m : Message = new Message();
				m.sender = this;
				if (has_input)
				{
					m.type = FlxObjectComponent.ENABLE;
					entity.sendMessage(m);
					m.type = FlxObjectComponent.SHOW;
					entity.sendMessage(m);
					
					var tic : TextInputComponent = textInputComponent;
					
					tic.textField.text = DEFAULT_TEXT;
					tic.textField.setSelection(0, tic.textField.length);
				} else {
					m.type = FlxObjectComponent.DISABLE;
					entity.sendMessage(m);
					m.type = FlxObjectComponent.HIDE;
					entity.sendMessage(m);
				}
			}
		}
		
		public function get dialogManager():DialogManagerComponent
		{
			return rec_findDialogManager(entity);
		}
		
		private function rec_findDialogManager(entity : Entity):DialogManagerComponent
		{
			if (entity == null) return null;
			
			var output : DialogManagerComponent = (DialogManagerComponent)(entity.getComponentByType(DialogManagerComponent));
			if (output != null)
			{
				return output;
			} else {
				return rec_findDialogManager(entity.parent);
			}
		}
		
		public function get textInputComponent():TextInputComponent
		{
			return getSiblingComponent(TextInputComponent) as TextInputComponent;
		}
		
	}

}