package as2.data 
{
	import as2.AS2GameData;
	import as2.ui.ProgressPopupComponent;
	import flash.display.InteractiveObject;
	/**
	 * Static class containing methods to handle data pertaining to the Walking App.
	 * @author Marek Kapolka
	 */
	public class WalkingAppData 
	{
		public static const APP_ID : String = "walking";
		public static const PROGRESS_ICON : uint = 6;
		public static const TNL_PER_LEVEL : int = 500;
		
		public static var builtUpPoints : int = 0;
		
		public function WalkingAppData() 
		{
			
		}
		
		public static function get data():XML
		{
			return AS2GameData.getApp(APP_ID);
		}
		
		public static function get points():int
		{
			if (AS2GameData.hasApp(APP_ID))
			{
				return parseInt(data.points);
			} else 
			{
				return -1;
			}
		}
		
		public static function set points(i : int):void
		{
			if (!AS2GameData.hasApp(APP_ID)) return;
			
			if (i > points)
			{
				var p1 : Number = (points - prevBonus) / (nextBonus - prevBonus);
				var p2 : Number = (i - prevBonus) / (nextBonus - prevBonus);
				ProgressPopupComponent.showProgressBar("Walked " + (i - points) + " meters!", PROGRESS_ICON, p1, p2);
				
				if (i > nextBonus)
				{
					QuestAppData.completeQuest("quest_walking_milestone");
				}
			}
			
			data.points = i;
		}
		
		public static function get toBonus():int
		{
			return nextBonus - points;
		}
		
		public static function get prevBonus():int
		{
			return nextBonus - (nextGap - TNL_PER_LEVEL);
		}
		
		public static function get nextBonus():int
		{
			if (AS2GameData.hasApp(APP_ID))
			{
				return parseInt(data.nextbonus);
			} else {
				return 1000;
			}
		}
		
		public static function set nextBonus(value : int):void
		{
			if (AS2GameData.hasApp(APP_ID))
			{
				data.nextbonus = value;
			} else {
				//
			}
		}
		
		public static function get nextGap():int
		{	
			if (AS2GameData.hasApp(APP_ID))
			{
				return parseInt(data.nextgap);
			} else {
				return -1;
			}
		}
		
		public static function set nextGap(value : int):void
		{
			if (AS2GameData.hasApp(APP_ID))
			{
				data.nextgap = value;
			}
		}
		
		public static function get sinceBonus():int
		{
			return points - prevBonus;
		}
		
		public static function checkConditional(array : Array):Boolean
		{		
			return false;
		}
		
		/**
		 * See the documentation for as2.dialog.AS2DialogPartner.filterHashCode(Array).
		 * @param	text The hash code string that should be replaced
		 * @return The resulting string
		 */
		public static function filterHashCode(s : String):String
		{
			switch(s)
			{
				case "#walking_pmilestone":
					return prevBonus.toString();
				break;
				
				case "#walking_nmilestone":
					return nextBonus.toString();
				break;
				
				case "#walking_currentpoints":
					return points.toString();
				break;
			}
			
			return null;
		}
		
		/**
		 * See the documentation for component.dialog.ConversationPartner.doResults(Array).
		 * @param	data The exploded string of results passed in from the DialogManager
		 */
		public static function doResults(data : Array):void
		{
			if (AS2GameData.hasApp(APP_ID))
			{
				switch (data[0])
				{
					case "walk":
						builtUpPoints += Math.round(Math.random() * 50) + 475;
					break;
					
					case "walkinstant":
						points += Math.round(Math.random() * 50) + 475;
					break;
					
					case "completequest":
						nextBonus += nextGap;
						nextGap += TNL_PER_LEVEL;
					break;
				}
			}			
		}
		
	}

}