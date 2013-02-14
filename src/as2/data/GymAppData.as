package as2.data 
{
	import as2.AS2GameData;
	import as2.ui.ProgressPopupComponent;
	import org.component.dialog.DialogResponse;
	/**
	 * Static class for accessing and working with data pertaining to the Gym App
	 * @author Marek Kapolka
	 */
	public class GymAppData 
	{
		public static const APP_ID : String = "gym";
		public static const APP_ICON : uint = 10;
		
		public static const RANK_NAMES : Array = [
			"Squishy",
			"Toned",
			"Taut",
			"Firm",
			"Ripped",
			"Bulked",
			"Cranked",
			"Slammed",
			"Juiced",
			"Jacked",
			"Hulked Out"
		];
		
		public function GymAppData() 
		{
			
		}
		
		public static function get data():XML
		{
			return AS2GameData.getApp(APP_ID);
		}
		
		/**
		 * See the documentation for component.dialog.ConversationPartner.doResults(Array).
		 * @param	data The exploded string of results passed in from the DialogManager
		 */
		public static function doResults(results : Array):void
		{
			switch (results[0])
			{
				case "workout":
					workOut(results[1]);
				break;
				
				case "next_rank_quest":
					QuestAppData.addQuest("quest_gym_rank_up", "Get " + nextRankTitle + "!");
				break;
			}
		}
		
		/**
		 * See the documentation for as2.dialog.AS2DialogPartner.filterHashCode(Array).
		 * @param	text The hash code string that should be replaced
		 * @return The resulting string
		 */
		public static function filterHashCode(code : String):String
		{
			switch (code)
			{
				case "#gym_rank_name":
					return rankTitle;
				break;
				
				case "#gym_next_rank":
					return nextRankTitle;
				break;
			}
			
			return null;
		}
		
		/**
		 * See the documentation for component.dialog.ConversationPartner.checkConditional(Array).
		 * @param	data The exploded conditional as passed in from the DialogManager
		 * @return The processed conditional.
		 */
		public static function checkConditional(conditional : Array):Boolean
		{
			switch (conditional[0])
			{
				case "worked_out_today":
					return parseInt(data.lastVisited) == AS2GameData.date;
				break;
			}
			
			return false;
		}
		
		/**
		 * See the documentation for org.component.dialog.DialogPartner.expandMetaOptions(DialogResponse)
		 * @param	response The response to expand the meta options for.
		 */
		public static function expandMetaOptions(response : DialogResponse):void
		{
			for (var i : int = 0; i < response.options.length; i++)
			{
				//Procedurally generate a list of ever-increasing weights and ever-increasing speeds
				//for the player to lift or run on
				if (response.options[i] == "#weights")
				{
					response.options.splice(i, 1);
					
					response.options.push(parseInt(data.strength) * 10 + " lbs|weights_low");
					response.options.push(parseInt(data.strength) * 20 + " lbs|weights_med");
					response.options.push(parseInt(data.strength) * 30 + " lbs|weights_high");
					
					i--;
					continue;
				}
				
				if (response.options[i] == "#bells")
				{
					response.options.splice(i, 1);
					
					response.options.push(parseInt(data.bulk) * 1 + " lbs|weights_low");
					response.options.push(parseInt(data.bulk) * 2 + " lbs|weights_med");
					response.options.push(parseInt(data.bulk) * 3 + " lbs|weights_high");
					
					i--;
					continue;
				}
				
				if (response.options[i] == "#treadmill")
				{
					response.options.splice(i, 1);
					
					response.options.push(parseInt(data.tone) * 1 + " mph|mill_low");
					response.options.push(parseInt(data.tone) * 2 + " mph|mill_med");
					response.options.push(parseInt(data.tone) * 3 + " mph|mill_high");
					
					i--;
					continue;
				}
			}
		}
		
		public static function workedOutToday():Boolean
		{
			return parseInt(data.lastvisited) == AS2GameData.date;
		}
		
		/**
		 * Does everything pertaining to working out.
		 * @param	type Which workout to do? Valid values: "tone", "bulk", or "strength",
		 * which refer to the treadmill, the barbells, and the bench press, respectively
		 */
		public static function workOut(type : String):void
		{
			var d : XML = data;
			
			QuestAppData.completeQuest("quest_gym_work_out");
			
			//Streak bonus
			if (parseInt(d.lastvisited) - AS2GameData.date > 1)
			{
				d.streak = 0;
			}
			
			//Consistency bonus for working out every day
			if (parseInt(d.lastvisited) != AS2GameData.date)
			{
				d.streak = parseInt(d.streak) + 1;
				QuestAppData.completeQuest("quest_gym_routine");
			}
			
			d.lastvisited = AS2GameData.date;
			
			var points : int = 2 + (3 * parseInt(d.streak));
			
			var p1 : Number = (parseInt(d.points) - parseInt(d.ptnl)) / (parseInt(d.tnl) - parseInt(d.ptnl));
			var p2 : Number = ((parseInt(d.points) + points) - parseInt(d.ptnl) / (parseInt(d.tnl) - parseInt(d.ptnl)));
			ProgressPopupComponent.showProgressBar("Gained " + points + " Gym Points!", APP_ICON, p1, p2);
			
			d.points = parseInt(d.points) + points;
			
			if (parseInt(d.points) > parseInt(d.tnl))
			{
				d.rank = parseInt(d.rank) + 1;
				d.ptnl = parseInt(d.tnl);
				d.tnl = parseInt(d.tnl) + parseInt(d.ntnl);
				d.ntnl = parseInt(d.ntnl) + 5;
				
				ProgressPopupComponent.showSimple("Gym Rank Up: You are now " + rankTitle, APP_ICON);
				QuestAppData.completeQuest("quest_gym_rank_up");
			}
			
			if (type == "tone")
			{
				d.tone = parseInt(d.tone) + 1;
				
				ProgressPopupComponent.showSimple("Gained 1 Tone!", APP_ICON);
			}
			
			if (type == "bulk")
			{
				d.bulk = parseInt(d.bulk) + 1;
				
				ProgressPopupComponent.showSimple("Gained 1 Bulk!", APP_ICON);
			}
			
			if (type == "strength")
			{
				d.strength = parseInt(d.strength) + 1;
				
				ProgressPopupComponent.showSimple("Gained 1 Strength!", APP_ICON);
			}
			
			//AS2GameData.dayTime -= 30;
		}
		
		public static function getRankTitle(rank : uint):String
		{
			if (rank >= RANK_NAMES.length)
			{
				return "Hulked Out";
			} else {
				return RANK_NAMES[rank];
			}
		}
		
		public static function get nextRankTitle():String
		{
			var i : int = parseInt(data.rank) + 1;
			return getRankTitle(i);
		}
		
		public static function get rankTitle():String
		{
			var i : int = parseInt(data.rank);
			return getRankTitle(i);
		}
		
	}

}
