package as2.dialog 
{
	import as2.AS2GameData;
	import org.component.Component;
	import org.component.dialog.DialogManagerComponent;
	import org.component.dialog.DialogMessage;
	import org.component.flixel.FlxObjectComponent;
	import org.component.flixel.FlxTextComponent;
	import org.component.Message;
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class DialogNameComponent extends Component 
	{
		
		public function DialogNameComponent() 
		{
			super();
			
			addRequisiteComponent(FlxTextComponent);
		}
		
		public function get text():FlxText
		{
			var ftc : FlxTextComponent = (FlxTextComponent)(getSiblingComponent(FlxTextComponent));
			
			if (ftc != null)
			{
				return ftc.text;
			} else {
				return null;
			}
		}
		
		private function setVisibility(visible : Boolean):void
		{
			var message : Message = new Message();
			message.sender = this;
			
			if (!visible)
			{
				message.type = FlxObjectComponent.HIDE;
			} else {
				message.type = FlxObjectComponent.SHOW;
			}
			
			entity.parent.sendMessage(message);
		}
		
		override public function receiveMessage(message : Message):void
		{
			super.receiveMessage(message);
			
			if (message is DialogMessage)
			{
				if (message.type == DialogMessage.UPDATE_PARTNER || message.type == DialogMessage.OPEN_DIALOG)
				{					
					var dm : DialogMessage = (DialogMessage)(message);
					
					if (dm.partner is AS2DialogPartner)
					{
						var partner : AS2DialogPartner = (AS2DialogPartner)(dm.partner);
						
						if (partner.name == null || partner.name == "")
						{
							setVisibility(false);
						} else {
							setVisibility(true);
						}
						
						text.text = partner.name;	
					}
					
					if (!AS2GameData.hasSmartphone)
					{
						setVisibility(false);
					}
				}
			}
		}
		
		
	}

}