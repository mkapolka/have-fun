package as2.dialog 
{
	import as2.AS2GameData;
	import as2.Assignment2State;
	import as2.data.Clothing;
	import as2.flixel.MaskMessage;
	import as2.flixel.PersonMaskComponent;
	import org.component.dialog.DialogResponse;
	import org.component.Entity;
	import org.component.Message;
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class DresserDialogPartner extends AS2DialogPartner 
	{
		//This is what a request to open the dialog for an article of clothing starts with
		public static const CLOTHING_TOPIC_START : String = "c_";
		
		public static const CLOTHING_NAME_HASH : String = "#clothing_name";
		public static const CLOTHING_DESCRIPTION_HASH : String = "#clothing_description";
		public static const CLOTHING_SLOT_HASH : String = "#clothing_slot";
		
		//Which mask to use when displaying the dialog shot of the protagonist
		//Holding up the clothing
		public static const MASK_INDEX : uint = 2;
		
		public static const CLOTHING_INFO_TOPIC : String = "info";
		
		public static const CLOTHING_LIST_HASH : String = "#clothing";
		
		protected var _currentClothing : Clothing;
		
		public function DresserDialogPartner() 
		{
			super();
		}
		
		override public function query(topic : String):DialogResponse
		{
			var output : DialogResponse = super.query(topic);
			
			if (topic.substr(0, CLOTHING_TOPIC_START.length) == CLOTHING_TOPIC_START)
			{
				var clothing_id : String = topic.substr(CLOTHING_TOPIC_START.length);
				
				var wardrobe : Vector.<Clothing> = AS2GameData.playerData.wardrobe;
				
				for each (var c : Clothing in wardrobe)
				{
					if (c.id == clothing_id)
					{
						_currentClothing = c;
						
						//Send a message to the dialog manager to display the texture of the clothing
						sendUpdateMaskMessage();
						
						sendUpdatePartnerMessage();
					}
				}
				
				return super.query(CLOTHING_INFO_TOPIC);
			}
			
			return output;
		}
		
		override public function peekQuery(topic : String):DialogResponse
		{
			/*if (topic.substr(0, CLOTHING_TOPIC_START.length) == CLOTHING_TOPIC_START)
			{
				var clothing_id : String = topic.substr(CLOTHING_TOPIC_START.length);
				
				var wardrobe : Vector.<Clothing> = AS2GameData.playerData.wardrobe;
				
				for each (var c : Clothing in wardrobe)
				{
					if (c.id == clothing_id)
					{
						_currentClothing = c;
						
						//Send a message to the dialog manager to display the texture of the clothing
						sendUpdateMaskMessage();
						
						sendUpdatePartnerMessage();
					}
				}
				
				return super.peekQuery(CLOTHING_INFO_TOPIC);
			} else {
				return super.peekQuery(topic);
			}*/
			
			return super.peekQuery(topic);
		}
		
		protected function sendUpdateMaskMessage():void
		{
			var cm : MaskMessage = MaskMessage.makeSetMaskMessage(MASK_INDEX, _currentClothing.texture);
			dialogManager.sendMessage(cm);
		}
		
		override public function checkConditional(conditional : String):Boolean
		{
			var split : Array = conditional.split(" ");
				
			switch (split[0])
			{
				case "no_clothes":
					return AS2GameData.playerData.wardrobe.length == 0;
				break;
			}
			
			return super.checkConditional(conditional);
		}
		
		override public function expandMetaOptions(array : DialogResponse):void
		{
			super.expandMetaOptions(array);
			
			for (var i : int = 0; i < array.options.length; i++)
			{
				if (array.options[i] == CLOTHING_LIST_HASH)
				{
					array.options.splice(i, 1);
					i--;
					
					var wardrobe : Vector.<Clothing> = AS2GameData.playerData.wardrobe;
					
					for each (var c : Clothing in wardrobe)
					{
						var option : String = c.name;
						option += "|";
						option += CLOTHING_TOPIC_START + c.id;
						array.options.push(option);
						i++;
						
						var buffer : String = array.options[i];
						array.options[i] = array.options[array.options.length - 1];
						array.options[array.options.length - 1] = buffer;
					}
				}
			}
		}
		
		override protected function doResults(results : Vector.<String>):void
		{
			super.doResults(results);
			
			for each (var s : String in results)
			{
				var a : Array = s.split(" ");
				
				switch (a[0])
				{
					case "wear":
						var currentlyWorn : Clothing = AS2GameData.playerData.getClothing(_currentClothing.slot);
						AS2GameData.playerData.doffClothing(currentlyWorn.slot, true);
						AS2GameData.playerData.removeClothingFromWardrobe(_currentClothing);
						AS2GameData.playerData.wearClothing(_currentClothing);
						
						_currentClothing = currentlyWorn;
						
						sendUpdateMaskMessage();
						rebuildDialog();
						
						var playerEntity : Entity = Assignment2State.getPlayerEntity();
						
						if (playerEntity != null)
						{
							var updateMessage : Message = new Message();
							updateMessage.sender = null;
							updateMessage.type = PersonMaskComponent.UPDATE_MASK_MESSAGE;
							
							playerEntity.sendMessage(updateMessage);
							dialogManager.sendMessage(updateMessage);
						}
					break;
					
					case "ditch":
						AS2GameData.playerData.removeClothingFromWardrobe(_currentClothing);
						
						rebuildDialog();
					break;
				}
			}
		}
		
		override protected function filterHashCode(code : String):String
		{
			var sup : String = super.filterHashCode(code);
			if (sup != code) return sup;
			
			switch (code)
			{
				case CLOTHING_NAME_HASH:
					return _currentClothing.name;
				break;
				
				case CLOTHING_DESCRIPTION_HASH:
					if (_currentClothing != null && _currentClothing.description != null)
					{
						return _currentClothing.description;
					} else {
						return CLOTHING_DESCRIPTION_HASH;
					}
				break;
				
				case CLOTHING_SLOT_HASH:
					switch (_currentClothing.slot)
					{
						case Clothing.SLOT_TOP:
							return "shirt";
						break;
						
						case Clothing.SLOT_BOTTOM:
							return "pants";
						break;
					}
				break;
				
				case "#clothing_age":
					return (AS2GameData.date - _currentClothing.dateBought).toString();
				break;
			}
			
			return code;
		}
		
	}

}