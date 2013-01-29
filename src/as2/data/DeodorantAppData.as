package as2.data 
{
	import as2.AS2GameData;
	import as2.ui.ProgressPopupComponent;
	import flash.display.InteractiveObject;
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class DeodorantAppData 
	{
		public static const DOVE : uint = 0;
		public static const SECRET : uint = 1;
		public static const NEITHER : uint = 2;
		
		public static const DOVE_ICON : uint = 8;
		public static const SECRET_ICON : uint = 7;
		
		public function DeodorantAppData() 
		{
		}
		
		public static function doResults(data : Array):void
		{
			switch (data[0])
			{
				case "use_dove":
					useDeodorant(DOVE);
				break;
				
				case "use_secret":
					useDeodorant(SECRET);
				break;
				
				case "agonize":
					if (nextDoveAward > nextSecretAward)
					{
						nextSecretAward = Math.floor(nextDoveAward * 1.5);
						nextDoveAward = nextSecretAward + 1;
					} else {
						nextDoveAward = Math.floor(nextSecretAward * 1.5);
						nextSecretAward = nextDoveAward + 1;
					}
				break;
			}
		}
		
		public static function checkConditional(array : Array):Boolean
		{			
			if (array[0] == "used_deodorant_today")
			{
				return AS2GameData.data.last_deodorant_date >= AS2GameData.date;
			}
			
			return false;
		}
		
		public static function get doveLoyalty():int
		{
			return AS2GameData.data["dove_loyalty"];
		}
		
		public static function set doveLoyalty(value : int):void
		{
			if (doveLoyalty < value)
			{
				ProgressPopupComponent.showSimple("Gained " + (value - doveLoyalty) + " Dove Loyalty!", DOVE_ICON);
			}
			
			if (doveLoyalty >= 3)
			{
				QuestAppData.completeQuest("quest_deodorant_loyalty");
			}
			
			AS2GameData.data["dove_loyalty"] = value;
		}
		
		public static function get secretLoyalty():int
		{
			return AS2GameData.data["secret_loyalty"];
		}
		
		public static function set secretLoyalty(n : int):void
		{
			if (secretLoyalty < n)
			{
				ProgressPopupComponent.showSimple("Gained " + (n - secretLoyalty) + " Secret Loyalty!", SECRET_ICON);
			}
			
			if (secretLoyalty >= 3)
			{
				QuestAppData.completeQuest("quest_deodorant_loyalty");
			}
			
			AS2GameData.data["secret_loyalty"] = n;
		}
		
		public static function get nextDoveAward():int
		{
			return AS2GameData.data["next_dove_award"];
		}
		
		public static function set nextDoveAward(n : int):void
		{
			AS2GameData.data["next_dove_award"] = n;
		}
		
		public static function get nextSecretAward():int
		{
			return AS2GameData.data["next_secret_award"];
		}
		
		public static function set nextSecretAward(n : int):void
		{
			AS2GameData.data["next_secret_award"] = n;
		}
		
		public static function get lastUsed():String
		{
			return AS2GameData.data["last_deodorant"];
		}
		
		public static function set lastUsed(s : String):void
		{
			AS2GameData.data["last_deodorant"] = s;
		}
		
		public static function get usedToday():Boolean
		{
			return parseInt(AS2GameData.data["last_deodorant_date"]) == AS2GameData.date;
		}
		
		public static function useDeodorant(which : uint):void
		{
			QuestAppData.completeQuest("quest_deodorant_start");
			
			switch (which)
			{
				case DOVE:
					var switched : Boolean = lastUsed != "dove";
					lastUsed = "dove";
					doveLoyalty += 1;
					
					AS2GameData.playerData.fun += nextDoveAward;
					
					if (switched) {
						nextSecretAward = 100 + doveLoyalty * 10;
					}
					
					nextDoveAward = 10;
				break;
				
				case SECRET:
					switched = lastUsed != "secret";
					lastUsed = "secret";
					secretLoyalty += 1;
					
					AS2GameData.playerData.fun += nextSecretAward;
					
					if (switched)
					{
						nextDoveAward = 100 + secretLoyalty * 10;
					}
					
					nextSecretAward = 10;
				break;
			}
			
			AS2GameData.data.last_deodorant_date = AS2GameData.date;
		}
	}

}