package as2.data 
{
	import as2.AS2GameData;
	import as2.ui.ProgressPopupComponent;
	import flash.display.InteractiveObject;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class FourSquareAppData 
	{
		public static const APP_ID : String = "foursquare";
		public static const ICON_ID : uint = 9;
		
		public static const FUN_REWARD : int = 100;
		public static const POINT_REWARD : int = 10;
			
		public function FourSquareAppData() 
		{
			
		}
		
		public static function get appData():XML
		{
			return AS2GameData.getApp(APP_ID);
		}
		
		public static function lastCheckIn(location_id : String):int
		{
			if (!AS2GameData.hasApp(APP_ID)) return -1;
			
			var x : XMLList = appData.checked_in[location_id];
			
			if (x != null && (String)(x) != "")
			{
				return parseInt(appData.checked_in[location_id]);
			} else {
				return -1;
			}
			
			return -1;
		}
		
		public static function setLastCheckIn(location_id : String, date : int):void
		{			
			appData.checked_in[location_id] = date;
		}
		
		public static function get currentPoints():int
		{
			return parseInt(appData.points);
		}
		
		public static function set currentPoints(value : int):void
		{
			if (parseInt(appData.points) < value)
			{
				ProgressPopupComponent.showSimple("Gained " + Math.floor((value - currentPoints) / 2) + " FourSquare points!", ICON_ID);
				setLocationPoints(AS2GameData.currentLocation, "player", getLocationPoints(AS2GameData.currentLocation, "player") + Math.floor((value - currentPoints) / 2));
				
				if (mentor != "none")
				{
					var person : PersonData = AS2GameData.loadPerson(mentor);
					var mpoints : int = Math.floor((value - currentPoints) / 2);
					ProgressPopupComponent.showSimple(person.name + " gained " + mpoints + " FourSquare points!", ICON_ID);
					setLocationPoints(AS2GameData.currentLocation, mentor, getLocationPoints(AS2GameData.currentLocation, mentor) + mpoints);
					patronPoints += mpoints;
				}
			}
			
			appData.points = value;
		}
		
		public static function getLocationPoints(location : String, who : String):int
		{
			if (appData != null)
			{
				var xml : XML = appData.location_points[location][0];
				return parseInt(xml[who]);
			} else {
				return -1;
			}
		}
		
		public static function setLocationPoints(location : String, who : String, value : int):void
		{
			if (appData != null)
			{
				var xml : XML = appData.location_points[location][0];
				xml[who] = value;
			} else {
				return;
			}
		}
		
		public static function addLocationPoints(location : String, who : String, value : int):void
		{
			setLocationPoints(location, who, getLocationPoints(location, who) + value);
		}
		
		public static function getMayor(location : String):String
		{
			if (appData == null) return "";
			
			var points : XML = appData.location_points[location][0];
			
			var highest_points : int = 0;
			var highest_person : String = "none";
			
			for each (var x : XML in points.children())
			{
				var p : int = parseInt(x);
				if (p > highest_points)
				{
					highest_points = p;
					highest_person = x.name();
				}
			}
			
			return highest_person;
		}
		
		public static function getMayorName(location : String):String
		{
			var mayor : String = getMayor(location);
			var mperson : PersonData = AS2GameData.loadPerson(mayor);
			
			if (mperson != null)
			{
				return mperson.name;
			} else {
				return "No One";
			}
		}
		
		public static function get mentor():String
		{
			return appData.mentor;
		}
		
		public static function set mentor(value : String):void
		{
			appData.mentor = value;
		}
		
		public static function getFunReward():int
		{
			return FUN_REWARD;
		}
		
		public static function getPointReward():int
		{
			return POINT_REWARD;
		}
		
		public static function doResults(data : Array):void
		{
			switch (data[0])
			{
				case "check_in":
					if (AS2GameData.date > lastCheckIn(AS2GameData.currentLocation))
					{
						currentPoints += getPointReward();
						AS2GameData.playerData.fun += getFunReward();
						setLastCheckIn(AS2GameData.currentLocation, AS2GameData.date);
					}
				break;
				
				case "set_mentor":
					mentor = data[1];
					var person : PersonData = AS2GameData.loadPerson(data[1]);
					ProgressPopupComponent.showSimple("Pledged Loyalty to " + person.name, ICON_ID);
					QuestAppData.completeQuest("quest_foursquare_pledge_loyalty");
					patronPoints = 0;
					QuestAppData.addQuest("quest_foursquare_help_patron", "Go Forth And Check In!");
				break;
			}
		}
		
		public static function checkConditional(data : Array):Boolean
		{
			switch (data[0])
			{
				case "checked_in_today":
					return lastCheckIn(AS2GameData.currentLocation) == AS2GameData.date;
				break;
				
				case "is_mayor":
					return getMayor(AS2GameData.currentLocation) == "player";
				break;
			}
			return false;
		}
		
		public static function set patronPoints(value : int):void
		{
			if (patronPoints > 20)
			{
				QuestAppData.completeQuest("quest_foursquare_help_patron");
			}
			
			appData.patron_points = value;
		}
		
		public static function get patronPoints():int
		{
			return parseInt(appData.patron_points);
		}
		
		public static function filterHashCode(text : String):String
		{
			switch (text)
			{
				case "#fs_location":
					switch (AS2GameData.currentLocation)
					{
						case "home":
							return "Your House";
						break;
						
						case "starbucks":
							return "Starbucks";
						break;
						
						case "cafe_2":
							return "Morts";
						break;
					}
				break;
				
				case "#fs_mayor":
					return getMayorName(AS2GameData.currentLocation);
				break;
				
				case "#fs_patronname":
					return AS2GameData.loadPerson(mentor).name;
				break;
				
				case "#fs_fun":
					return getFunReward().toString();
				break;
				
				case "#fs_points":
					return getPointReward().toString();
				break;
			}
			
			return null;
		}
		
	}

}