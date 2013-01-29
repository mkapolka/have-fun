package as2.data 
{
	import as2.AS2GameData;
	import as2.AS2SoundManager;
	import as2.etc.TextInputComponent;
	import as2.ui.ProgressPopupComponent;
	import flash.display.InteractiveObject;
	import flash.geom.Vector3D;
	/**
	 * ...
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
		
		public static function checkConditional(a : Array):Boolean
		{			
			//if (data == null) return false;
			
			switch (a[0])
			{
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
				
				case "has_coffee":
					if (data == null) return false;
					//return lastCoffee == AS2GameData.date;
					return AS2GameData.data.has_coffee > 0;
				break;
				
				case "no_coffee":
					if (data == null) return true;
					//return lastCoffee != AS2GameData.date;
					return AS2GameData.data.has_coffee < 1;
				break;
				
				case "talked_today":
					if (data.talkies[a[1]] == null) return false;
					var last_talked : int = data.talkies[a[1]];
					if (last_talked == AS2GameData.date) return true;
				break;
				
				case "coffee_type":
					return _current_type == a[1];
				break;
				
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
		
		public static function get currentCoffee():String
		{
			return _current_size + " " + _current_flavor + " " + _current_type + " " + _current_extra;
		}
		
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
		
		public static function doResults(a : Array):void
		{
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
				case "addpoints":
					points += parseInt(a[1]);
				break;
				
				case "removepoints":
					points -= a[1];
				break;
				
				case "buycoffee":
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
				
				case "talk":
					talk(a[1]);
				break;
				
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
				
				case "#current_coffee":
					return currentCoffee;
				break;
				
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