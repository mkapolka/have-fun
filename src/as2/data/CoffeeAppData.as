package as2.data 
{
	import as2.AS2GameData;
	import as2.AS2SoundManager;
	import as2.etc.TextInputComponent;
	import as2.ui.ProgressPopupComponent;
	import flash.display.InteractiveObject;
	import flash.geom.Vector3D;
	/**
	 * Static class for managing data pertaining to the Coffee App (Called Coffee Life in game)
	 * @author Marek Kapolka
	 */
	public class CoffeeAppData 
	{
		public static const COFFEE_APPID : String = "coffee";
		public static const ICON_ID : int = 5;
		public static const TNL_PER_LEVEL : int = 4;
		
		private static var _current_type : String;
		private static var _current_size : String;
		private static var _current_flavor : String;
		private static var _current_extra : String;
		
		public static const RANK_NAMES : Array = new Array (
			"Brew Newbie",
			"Java Lover",
			"Coffee Fiend",
			"Joe Junkie",
			"Mocha Master",
			"Latte Leader",
			"Americano President",
			"Espresso Royalty",
			"Caffeine Queen"
		)
		
		public static const MAX_POINTS : int = 10;
		
		public function CoffeeAppData() 
		{
			
		}
		
		/**
		 * Takes the same form as component.dialog.DialogPartner.checkConditional(Array)
		 * Given an exploded string conditional, return the value of that conditional.
		 * "false" is equivalent to "I can't evaluate this". If you want to use these conditionals make
		 * sure you add "coffee " to the begining of your conditional. AS2ConversationPartner will know
		 * to send it to this class' checkConditional if you do that, and strip off the word "coffee" before it sends
		 * it. For example, if you want to check if the player has more than 100 coffee points, your conditional
		 * would be <conditional test="coffee points > 100"> <topic ...> ... </conditional> 
		 * @param	a An exploded conditional in the same form that can be found in res/dialog.xml. I.e. if the conditional
		 * is "points >= 100" the Array would be a[0] == "points" a[1] == ">=" a[2] == "100"
		 * @return True if this expression evaluates to true (in the example above, it would be if the player 
		 */
		public static function checkConditional(a : Array):Boolean
		{			
			//if (data == null) return false;
			
			switch (a[0])
			{
				//How many coffee points does the player have?
				//Form: points (operand) (value)
				//Valid operands: >, >=
				case "points":
					if (data == null) return false;
					
					switch (a[1])
					{
						case ">":
							return points > parseInt(a[2]);
						break;
						
						case ">=":
							return points >= parseInt(a[2]);
						break;
					}
				break;
				
				//What coffee rank is the player?
				//Form: rank (operand) (value)
				//Valid operands: >, !> (less than)
				case "rank":
					if (data == null) return false;
					
					switch (a[1])
					{
						case ">":
							return rank > a[2];
						break;
						
						case "!>":
							return rank < a[2];
						break;
					}
				break;
				
				//Has the player bought a coffee today, according to the coffee app?
				//Form: has_coffee
				case "has_coffee":
					if (data == null) return false;
					return AS2GameData.data.has_coffee > 0;
				break;
				
				//Does the player not have coffee?
				//Form: no_coffee
				case "no_coffee":
					if (data == null) return true;
					return AS2GameData.data.has_coffee < 1;
				break;
				
				//Has the player talked to the given person yet?
				//Form: talked_today (person_id)
				case "talked_today":
					if (data.talkies[a[1]] == null) return false;
					var last_talked : int = data.talkies[a[1]];
					if (last_talked == AS2GameData.date) return true;
				break;
				
				//Is the type of coffee the player holding this one?
				//Form: coffee_type (type)
				//Valid types: coffee, mocha, latte
				case "coffee_type":
					return _current_type == a[1];
				break;
				
				//Did the player correctly navigate the coffee recital maze?
				//(That is where a person asks the player to remember what, exactly, they got)
				//Form: recital_correct
				case "recital_correct":
					return currentCoffee == lastCoffee;
				break;
			}
			
			return false;
		}
		
		public static function get hasCoffee():Boolean
		{
			return AS2GameData.data.has_coffee > 0;
		}
		
		/**
		 * Returns the full name of the type of coffee the player is currently talking about. 
		 * all the _current* values are filled while the player is talking about a coffee,
		 * i.e. ordering one or playing the coffee recital game. The coffee that the player is actually
		 * holding is stored in lastCoffee.
		 */
		public static function get currentCoffee():String
		{
			return _current_size + " " + _current_flavor + " " + _current_type + " " + _current_extra;
		}
		
		/**
		 * The callback to inform the coffee app that the player has bonded with the given
		 * person over a nice cup of joe.
		 * @param	who The id of the person the player talked it.
		 */
		public static function talk(who : String):void
		{
			if (data == null) return;
			
			var s : int = data.talkies[who];
			if (s != AS2GameData.date)
			{
				points += 1;
				data.talkies[who] = AS2GameData.date;
				
				QuestAppData.completeQuest("quest_coffee_talk");
			}
		}
		
		/**
		 * Takes the same form as component.dialog.ConversationPartner.doResults(Array).
		 * The array is an exploded string that represents the information about the result
		 * to accomplish. Any result that should be parsed by this method should be preceeded with
		 * "coffee". I.e. if you want to add 5 coffee points to the player the result should be
		 * [coffee addpoints 5]. The "coffee" string will be stripped by AS2DialogPartner before
		 * it is sent to this method.
		 * @param	a The exploded input. I.e. if the method was "addpoints 5" then the array will be
		 * a[0] == "addpoints" a[1] == 5.
		 */
		public static function doResults(a : Array):void
		{
			//Adds the "Choose the Coffee Life" quest to the player. This is the quest that prompts
			//the player to download the coffee life app.
			if (a[0] == "getappquest")
			{
				if (!AS2GameData.hasApp("coffee"))
				{
					QuestAppData.addQuest("quest_get_coffee_app", "Choose The Coffee Life");
				}
			}
			
			if (data == null) return;
			
			switch (a[0])
			{				
				//Adds the specifed number of coffee points
				//Form: addpoints (amount)
				case "addpoints":
					points += parseInt(a[1]);
				break;
				
				//Removes the specifed number of coffee points
				//Form: removepoints (amount)
				case "removepoints":
					points -= a[1];
				break;
				
				//Buys the current coffee
				case "buycoffee":
					//More points if you get the same coffee every day
					if (currentCoffee == lastCoffee)
					{
						routineBonus++;
						
						ProgressPopupComponent.showSimple("Routine Bonus! " + routineBonus + "x chain!", ICON_ID);
					} else {
						if (routineBonus > 0)
						{
							ProgressPopupComponent.showSimple("Routine Bonus Lost...", ICON_ID);
						}
						
						routineBonus = 0;
					}
				
					lastCoffeeDate = AS2GameData.date;
					lastCoffee = currentCoffee;
					AS2GameData.data.has_coffee = 1;
					
					points += 1 + routineBonus;
					
					QuestAppData.completeQuest("quest_buy_coffee");
				break;
				
				//Bond with someone over a cup of coffee
				//Form: talk (person_id)
				case "talk":
					talk(a[1]);
				break;
				
				//Sets the type of coffee the player is talking about
				//Form: settype (type_of_coffee)
				//Examples: coffee, latte, mocha, etc.
				case "settype":
					var type : String = "";
					
					for (var i : int = 1; i < a.length; i++)
					{
						type += a[i];
						
						if (i != a.length - 1)
						{
							type += " ";
						}
					}
					_current_type = type;
				break;
				
				//Sets the size of coffee the player is talking about
				//Form: setsize (size_of_coffee)
				//Examples: grande, venti, etc
				case "setsize":
					var size : String = "";
					
					for (i = 1; i < a.length; i++)
					{
						size += a[i];
						
						if (i != a.length - 1)
						{
							size += " ";
						}
					}
				
					_current_size = size;
				break;
				
				//Sets the flavor of coffee the player is talking about
				//Form: setflavor (flavor_of_coffee)
				//Examples: Turkish Blend (for coffee), pumpkin (for mochas), etc
				case "setflavor":
					var flavor : String = "";
					
					for (i = 1; i < a.length; i++)
					{
						flavor += a[i];
						
						if (i != a.length - 1)
						{
							flavor += " ";
						}
					}
					_current_flavor = flavor;
				break;
				
				//Sets any extra options for this coffee
				//Form: setextra (name_of_extra)
				//Examples: with whip (for mochas), with cream and sugar (for coffee)
				case "setextra":
					var extra : String = "";
					
					for (i = 1; i < a.length; i++)
					{
						extra += a[i];
						
						if (i != a.length - 1)
						{
							extra += " ";
						}
					}
					_current_extra = extra;
				break;
			}
		}
		
		/**
		 * Replaces any relevant hash codes with the appropriate value. For example, if #coffee_points is given
		 * as the input, the number of coffee points the player has will be returned.
		 * @param	s The input string
		 * @return Either the relevant value, or if this function cannot process the input string, return null.
		 */
		public static function filterHashCode(s : String):String
		{
			if (data == null) return null;
			
			switch (s)
			{
				case "#coffee_points":
					return points.toString();
				break;
				
				case "#coffee_rank":
					return Math.round(rank).toString();
				break;
				
				case "#coffee_rank_title":
					return rankTitle;
				break;
				
				case "#coffee_nextrank":
					return nextRank.toString();
				break;
				
				//The coffee the player is currently talking about
				case "#current_coffee":
					return currentCoffee;
				break;
				
				//The last coffee the player bought
				case "#last_coffee":
					return lastCoffee;
				break;
				
				case "#current_type":
					return _current_type
				break;
				
				case "#current_size":
					return _current_size;
				break;
				
				case "#current_extra":
					return _current_extra;
				break;
				
				case "#current_flavor":
					return _current_flavor;
				break;
			}
			
			return null;
		} 
		
		/**
		 * Returns the underlying XML that stores the coffee app data.
		 */
		public static function get data():XML
		{
			for each (var x : XML in AS2GameData.data.apps.app)
			{
				if (x.id == COFFEE_APPID)
				{
					return x;
				}
			}
			
			return null;
		}
		
		public static function get prevRank():int
		{
			return parseInt(data.prevrank);
		}
		
		public static function set prevRank(value : int):void
		{
			data.prevrank = value;
		}
		
		public static function get nextRank():int
		{
			return parseInt(data.nextrank);
		}
		
		public static function set nextRank(value : int):void
		{
			data.nextrank = value;
		}
		
		/**
		 * How many more coffee points it will take to get to the next coffee rank.
		 */
		public static function get nextGap():int
		{
			return parseInt(data.nextgap);
		}
		
		public static function set nextGap(value : int):void
		{
			data.nextgap = value;
		}
		
		public static function get rank():int
		{
			return parseInt(data.rank);
		}
		
		public static function set rank(value : int):void
		{
			data.rank = value;
		}
		
		public static function get points():int
		{
			return parseInt(data.points);
		}
		
		public static function set points(n : int):void
		{
			if (n > points)
			{
				var p1 : Number = (points - prevRank) / (nextRank - prevRank);
				var p2 : Number = (n - prevRank) / (nextRank - prevRank);
				ProgressPopupComponent.showProgressBar("Gained " + (n - points) + " Coffee Points!", ICON_ID, p1, p2);
				AS2SoundManager.playSound(AS2SoundManager.POINTS_MP3);
			}
			
			if (n >= nextRank)
			{
				rank++;
				prevRank = nextRank;
				nextRank += nextGap;
				nextGap += TNL_PER_LEVEL;
				ProgressPopupComponent.showSimple("Achieved Rank: " + rankTitle, ICON_ID);
				AS2SoundManager.playSound(AS2SoundManager.LEVEL_UP_MP3);
			}
			
			data.points = n.toString();
		}
		
		public static function getRankTitle(rank : int):String
		{
			if (rank < RANK_NAMES.length)
			{
				return RANK_NAMES[rank]
			} else {
				return "Undefined";
			}
		}
		
		public static function get routineBonus():int
		{
			return parseInt(data.routine_bonus);
		}
		
		public static function set routineBonus(value : int):void
		{
			data.routine_bonus = value.toString();
		}
		
		public static function get rankTitle():String
		{
			return RANK_NAMES[rank];
		}
		
		public static function get lastCoffeeDate():int
		{
			return parseInt(data.last_coffee_date);
		}
		
		public static function set lastCoffeeDate(n : int):void
		{
			data.last_coffee_date = n;
		}
		
		public static function set lastCoffee(value : String):void
		{
			data.last_coffee = value;
		}
		
		public static function get lastCoffee():String
		{
			return data.last_coffee;
		}
		
	}

}