package as2.data 
{
	import as2.AS2GameData;
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class MailAppData 
	{
		public static const MAIL_APP_ID : String = "mail";
		public function MailAppData() 
		{
			
		}
		
		public static function get data():XML
		{
			return AS2GameData.getApp(MAIL_APP_ID);
		}
		
		public static function get emails():XMLList
		{
			return data.emails;
		}
		
		public static function getDialogOptions():Vector.<String>
		{
			var output : Vector.<String> = new Vector.<String>();
			
			for each (var x : XML in emails.email)
			{
				var s : String = "";
				var s_read : String = x.read;
				if (parseInt(s_read) == 0)
				{
					s += "*";
				}
				
				s += x.name + "|" + x.id;
				
				output.push(s);
			}
			
			return output;
		}
		
		public static function addEmail(id : String, name : String):void
		{
			var newEmail : XML = new XML("<email></email>");
			
			newEmail.id = id;
			newEmail.name = name;
			
			emails.appendChild(newEmail);
		}
		
		public static function deleteEmail(id : String):void
		{
			var emails : XMLList = emails;
			for (var i : int = 0; i < emails.length(); i++)
			{
				if (emails[i].id == id)
				{
					delete emails[i];
					return;
				}
			}
		}
		
		public static function readEmail(id : String):void
		{
			var emails : XMLList = emails;
			
			for each (var x : XML in emails.email)
			{
				if (x.id == id)
				{
					x.read = 1;
				}
			}
		}
		
	}

}