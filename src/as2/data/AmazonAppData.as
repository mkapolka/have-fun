package as2.data 
{
	import as2.AS2GameData;
	import as2.Assignment2State;
	import as2.flixel.MaskMessage;
	import as2.ui.ProgressPopupComponent;
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class AmazonAppData 
	{
		public static const ICON_ID : int = 13;
		
		//public static var offers : Vector.<Clothing> = new Vector.<Clothing>();
		public static var _upperOffer : Clothing;
		public static var _lowerOffer : Clothing;
		
		public static var _currentClothing : Clothing = null;
		
		public function AmazonAppData() 
		{
			
		}
		
		public static function doResults(result : Array):void
		{
			switch (result[0])
			{
				case "buy_upper":
					//AS2GameData.playerData.addClothingToWardrobe(_upperOffer);
					AS2GameData.orderClothing(_upperOffer);
					ProgressPopupComponent.showSimple("Ordered " + _upperOffer.name, ICON_ID);
				break;
				
				case "buy_lower":
					//AS2GameData.playerData.addClothingToWardrobe(_lowerOffer);
					AS2GameData.orderClothing(_lowerOffer);
					ProgressPopupComponent.showSimple("Ordered " + _lowerOffer.name, ICON_ID);
				break;
				
				case "setmask":
					if (result[1] == "upper")
					{
						var mm : MaskMessage = MaskMessage.makeSetMaskMessage(2, _upperOffer.texture);
						Assignment2State.getDialogEntity().sendMessage(mm);
					} else {
						mm = MaskMessage.makeSetMaskMessage(2, _lowerOffer.texture);
						Assignment2State.getDialogEntity().sendMessage(mm);
					}
				break;
			}
		}
		
		public static function filterHashCode(value : String):String
		{
			switch (value)
			{
				case "#upper_offer_name":
					return _upperOffer.name;
				break;
				
				case "#lower_offer_name":
					return _lowerOffer.name;
				break;
			}
			
			return null;
		}
		
		public static function generateOffers():void
		{			
			_upperOffer = new Clothing();
			AS2GameData.genClothing(_upperOffer, AS2GameData.data.upper_clothing_slots, true);
			_upperOffer.dateBought = AS2GameData.date;
			_upperOffer.toBeDelivered = AS2GameData.date + 1;
			
			_lowerOffer = new Clothing();
			AS2GameData.genClothing(_lowerOffer, AS2GameData.data.lower_clothing_slots, false);
			_lowerOffer.dateBought = AS2GameData.date;
			_lowerOffer.toBeDelivered = AS2GameData.date + 1;
		}
	}

}