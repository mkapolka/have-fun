package as2.data 
{
	import as2.AS2GameData;
	import as2.AS2SoundManager;
	import as2.AS2Utils;
	import as2.etc.QuestIconComponent;
	import as2.ui.ProgressPopupComponent;
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class QuestAppData 
	{
		public static const APP_ID : String = "quests";
		public function QuestAppData() 
		{
			
		}
		
		public static function get data():XML
		{
			return AS2GameData.getApp(APP_ID);
		}
		
		public static function getDialogOptions():Vector.<String>
		{
			var output : Vector.<String> = new Vector.<String>();
			
			for each (var x : XML in data.quests.quest)
			{
				var s : String = "";
				
				s += x.name + (parseInt(x.complete)>0?"(Complete)":"") + "|" + x.id;
				
				output.push(s);
			}
			
			return output;
		}
		
		public static function addQuest(id : String, name : String):void
		{
			if (!hasQuest(id))
			{
				var x : XML = new XML("<quest></quest>");
				x.id = id;
				x.name = name;
				x.complete = 0;
				x.read = 0;
				
				ProgressPopupComponent.showSimple("New Quest: " + name, 3);
				QuestIconComponent.showNewIcon = true;
				AS2SoundManager.playSound(AS2SoundManager.QUEST_START_MP3);
				
				data.quests.appendChild(x);
			}
		}
		
		public static function getQuestName(id : String):String
		{
			for each (var x : XML in data.quests.quest)
			{
				if (x.id == id)
				{
					return x.name;
				}
			}
			
			return null;
		}
		
		public static function hasQuest(id : String):Boolean
		{
			for each (var x : XML in data.quests.quest)
			{
				if (x.id == id)
				{
					return true;
				}
			}
			
			return false;
		}
		
		public static function isQuestComplete(id : String):Boolean
		{
			for each (var x : XML in data.quests.quest)
			{
				if (x.id == id)
				{
					return parseInt(x.complete) > 0;
				}
			}
			
			return false;
		}
		
		public static function setQuestComplete(id : String, value : Boolean):void
		{
			for each (var x : XML in data.quests.quest)
			{
				if (x.id == id)
				{
					x.complete = value?1:0;
				}
			}
		}
		
		public static function removeQuest(id : String):void
		{
			for each (var x : XML in data.quests.quest)
			{
				if (x.id == id)
				{
					AS2Utils.deleteNode(x);
				}
			}
		}
		
		public static function completeQuest(id : String):void
		{
			for each (var x : XML in data.quests.quest)
			{
				if (x.id == id)
				{
					if (!isQuestComplete(id))
					{
						ProgressPopupComponent.showSimple("Quest Completed: " + x.name, 4);
						AS2SoundManager.playSound(AS2SoundManager.QUEST_COMPLETE_MP3);
						setQuestComplete(id, true);
						QuestIconComponent.showNewIcon = true;
					}
				}
			}
		}
	}

}