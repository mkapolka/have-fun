package as2.dialog 
{
	import as2.AS2GameData;
	import as2.data.Item;
	import as2.data.MailAppData;
	import as2.data.QuestAppData;
	import org.component.dialog.DialogResponse;
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class SmartphoneDialogPartner extends AS2DialogPartner 
	{
		public static const APPS_HASHCODE : String = "#apps";
		public static const INVENTORY_HASHCODE : String = "#items";
		public static const EMAIL_LIST_HASHCODE : String = "#maillist";
		public static const EMAIL_OPTIONS_HASHCODE : String = "#mailoptions";
		public static const QUEST_LIST_HASHCODE : String = "#quest_list";
		public static const QUEST_OPTIONS_HASHCODE : String = "#quest";
		
		public static const DEFAULT_ID : String = "smartphone";
		public static const DEFAULT_NAME : String = "Siri";
		public static const DEFAULT_PORTRAIT : uint = 1;
		
		public static const MODE_DEFAULT : uint = 0;
		public static const MODE_EMAIL : uint = 1;
		
		private var _mode : uint = 0;
		
		private var _lastReadEmail : String;
		
		public function SmartphoneDialogPartner() 
		{
			super();
			id = DEFAULT_ID;
			name = DEFAULT_NAME;
			portraitID = DEFAULT_PORTRAIT;
		}
		
		override public function checkConditional(conditional : String):Boolean
		{
			if (super.checkConditional(conditional)) return true;
			
			var a : Array = conditional.split(" ");
			if (a.length == 0) return false;
			
			switch (a[0])
			{
				
			}
			
			return false;
		}
		
		override protected function doResults(functions : Vector.<String>):void
		{
			super.doResults(functions);
			
			for each (var result : String in functions)
			{
				var a : Array = result.split(" ");
				if (a.length == 0) continue;
				
				switch (a[0])
				{
					case "setmail":
						mode = MODE_EMAIL;
					break;
					
					case "setdefault":
						mode = MODE_DEFAULT;
					break;
				}
			}
		}
		
		override public function expandMetaOptions(response : DialogResponse):void
		{
			super.expandMetaOptions(response);
			
			for (var i : int = 0; i < response.options.length; i++)
			{
				switch (response.options[i])
				{
					case APPS_HASHCODE:
						response.options.splice(i, 1);
						var o : int = addApps(response.options, i);
						i += o;
					break;
					
					case INVENTORY_HASHCODE:
						response.options.splice(i, 1);
						o = addItems(response.options, i);
						i += o;
					break;
					
					case EMAIL_LIST_HASHCODE:
						if (AS2GameData.hasApp("email"))
						{
							response.options.splice(i, 1);
							var emails : Vector.<String> = MailAppData.getDialogOptions();
							for each (var s : String in emails)
							{
								array_join(response.options, emails, i);
							}
							i += emails.length;
						}
						
					break;
					
					case EMAIL_OPTIONS_HASHCODE:
						if (AS2GameData.hasApp("email"))
						{
							response.options.splice(i, 1);
							response.options.push("delete");
							response.options.push("back|mail");
							i += 2;
						}						
					break;
					
					case QUEST_LIST_HASHCODE:
						response.options.splice(i, 1);
						var quests : Vector.<String> = QuestAppData.getDialogOptions();						
						array_join(response.options, quests, i);
						i += quests.length;
					break;
					
					case QUEST_OPTIONS_HASHCODE:
						response.options.splice(i, 1);
						
						if (QuestAppData.isQuestComplete(response.name))
						{
							response.options.push("complete|" + response.name + "_complete");
						}
					break;
				}
			}
		}
		
		private function array_join(a1 : Vector.<String>, a2 : Vector.<String>, si : int):void
		{
			if (a2.length == 0) return;
			
			var il : int = a1.length;
			for each (var o : String in a2)
			{
				a1.push(o);
			}
			
			for (var i : int = 0; i < a1.length; i++)
			{
				if (i >= si && i < si + a2.length)
				{
					var b : String = a1[i];
					a1[i] = a1[il + i];
					a1[il + i] = b;
				}
			}
		}
		
		private function addApps(a : Vector.<String>, startIndex : int):int
		{
			var apps : XMLList = AS2GameData.apps;
			var a2 : Vector.<String> = new Vector.<String>();
			
			var output : int = 0;
			
			for each (var app : XML in apps)
			{
				var id : String = app.id;
				var name : String = app.name;
				var s : String;
				if (name == null || name == "" || name == " ")
				{
					s = id;
				} else {
					s = name + "|" + id;
				}
				
				a2.push(s);
				output++;
			}
			
			array_join(a, a2, startIndex);
			
			return output;
		}
		
		override public function query(topic : String):DialogResponse
		{
			switch (mode)
			{
				default:
				case MODE_DEFAULT:
					return super.query(topic);
				break;
				
				case MODE_EMAIL:
					var output : DialogResponse = super.query(topic);
					
					_lastReadEmail = topic;
					
					MailAppData.readEmail(topic);
					
					output.options.push("#mailoptions");
					expandMetaOptions(output);
					rebuildDialog();
					
					return output;
				break;
			}
		}
		
		private function addItems(a : Vector.<String>, startIndex : int):int
		{
			var items : Vector.<Item> = AS2GameData.playerData.inventory;
			var a2 : Vector.<String> = new Vector.<String>();
			
			var output : int = 0;
			
			for each (var i : Item in items)
			{
				var n : String = i.name;
				var id : String = i.id;
				if (n == "" || n == " " || n == null) n = id;
				var s : String = n + "|" + id
				a2.push(s);
				output++;
			}
			
			array_join(a, a2, startIndex);
			
			return output;
		}
		
		public function get mode():uint
		{
			return _mode;
		}
		
		public function set mode(n : uint):void
		{
			_mode = n;
		}
	}

}