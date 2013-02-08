package as2.data 
{
	import as2.AS2GameData;
	import as2.ui.ProgressPopupComponent;
	import flash.display.InteractiveObject;
	/**
	 * Static class for managing data pertaining to the deodorant events
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
		
		/**
		 * Takes the same form as component.dialog.ConversationPartner.doResults(Array).
		 * The array is an exploded string that represents the information about the result
		 * to accomplish. Any result that should be parsed by this method should be preceeded with
		 * "deodorant". I.e. if you want the player to use the "dove" brand deodorant you would call
		 * [deodorant use_dove] The "deodorant" string will be stripped by AS2DialogPartner before
		 * it is sent to this method.
		 * @param	a The exploded input. I.e. if the method was "addpoints 5" then the array will be
		 * a[0] == "addpoints" a[1] == 5.
		 */
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
		
		/**
		 * Takes the same form as component.dialog.DialogPartner.checkConditional(Array)
		 * Given an exploded string conditional, return the value of that conditional.
		 * "false" is equivalent to "I can't evaluate this". If you want to use these conditionals make
		 * sure you add "coffee " to the begining of your conditional. AS2ConversationPartner will know
		 * to send it to this class' checkConditional if you do that, and strip off the word "deodorant" before it sends
		 * it.
		 * @param	a An exploded conditional in the same form that can be found in res/dialog.xml. I.e. if the conditional
		 * is "points >= 100" the Array would be a[0] == "points" a[1] == ">=" a[2] == "100"
		 * @return True if this expression evaluates to true (in the example above, it would be if the player 
		 */
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