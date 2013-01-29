package as2.ui 
{
	import as2.AS2GameData;
	import as2.character.CharacterComponent;
	import as2.data.PersonData;
	import as2.dialog.CharacterDialogInitiatorComponent;
	import as2.dialog.CharacterDialogPartner;
	import org.component.Component;
	import org.component.dialog.DialogMessage;
	import org.component.dialog.DialogPartner;
	import org.component.Entity;
	import org.component.flixel.FlxObjectComponent;
	import org.component.flixel.FlxTextComponent;
	import org.component.Message;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class LevelTextComponent extends Component 
	{
		private var _currentPartner : DialogPartner;
		private var _visible : Boolean = true;
		
		public function LevelTextComponent() 
		{
			super();
		}
		
		private function show(show : Boolean):void
		{
			var message : Message = new Message();
			message.sender = this;
			message.type = show?FlxObjectComponent.SHOW:FlxObjectComponent.HIDE;
			
			entity.sendMessage(message);
			
			message.type = show?FlxObjectComponent.ENABLE:FlxObjectComponent.DISABLE;
			
			entity.sendMessage(message);
		}
		
		override public function update():void
		{
			super.update();
			
			if (!(_currentPartner is CharacterDialogPartner) && _visible)
			{
				show(false);
			}
		}
		
		override public function receiveMessage(message : Message):void
		{
			super.receiveMessage(message);
		
			if (message.type == FlxObjectComponent.SHOW)
			{
				_visible = true;
			}
			
			if (message.type == FlxObjectComponent.HIDE)
			{
				_visible = false;
			}
			
			if (message is DialogMessage)
			{
				if (message.type == DialogMessage.OPEN_DIALOG)
				{
					var other : DialogPartner = (DialogMessage)(message).partner;
					_currentPartner = other;
					
					if (other is CharacterDialogPartner)
					{
						var cdp : CharacterDialogPartner = other as CharacterDialogPartner;
						
						show(true);
						
						var text : Entity = entity.getChildByName("Text");
						(FlxTextComponent)(text.getComponentByType(FlxTextComponent)).text.text = "Level " + AS2GameData.loadPerson(cdp.id).funLevel;
					} else {
						show(false);
					}
					
					if (!AS2GameData.hasSmartphone)
					{
						show(false);
					}
				}
			}
		}
		
	}

}