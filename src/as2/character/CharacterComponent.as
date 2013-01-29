package as2.character 
{
	import as2.AS2GameData;
	import as2.data.PersonData;
	import org.component.Component;
	
	/**
	 * Component frontend for PersonData entities
	 * @author Marek Kapolka
	 */
	public class CharacterComponent extends Component 
	{		
		private var _data : PersonData;
		
		public function CharacterComponent() 
		{
			super();
		}
		
		public function get characterName():String
		{
			return _data.name;
		}
		
		public function get characterID():String
		{
			return _data.id;
		}
		
		public function get characterType():String
		{
			return _data.type;
		}
		
		public function get portraitID():uint
		{
			return _data.portraitID;
		}
		
		public function get data():PersonData
		{
			return _data;
		}
		
		override public function loadContent(xml : XML):void
		{
			super.loadContent(xml);
			
			if (xmlElementExists(xml, "personID"))
			{
				var d : PersonData = AS2GameData.loadPerson(xml.personID);
				if (d != null)
				{
					_data = d;
				} else {
					trace("PROBLEM: Couldn't initialize person with id \"" + xml.personID + "\" in entity \"" + entity.name +"\"");
					initialized = false;
				}
			}
		}
		
	}

}