package as2.data 
{
	import as2.AS2GameData;
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class Item 
	{
		private var _data : XML;
		
		public function Item(xml : XML) 
		{
			_data = xml;
		}
		
		public static function getItemTemplate(s : String):Item
		{
			for each (var x : XML in AS2GameData.data.items.item)
			{
				if (x.id == s)
				{
					return new Item(x);
				}
			}
			
			return null;
		}
		
		public static function copyItemTemplate(s : String):Item
		{
			var template : Item = getItemTemplate(s);
			var output : XML;
			
			if (template != null)
			{
				output = template.data.copy();
			} else {
				output = new XML("<item></item>");
				output.id = s;
			}
			
			return new Item(output);
		}
		
		public function get id():String 
		{
			return _data.id;
		}
		
		public function set id(s : String):void
		{
			_data.id = s;
		}
		
		public function get name():String
		{
			return _data.name;
		}
		
		public function set name(n : String):void
		{
			_data.name = n;
		}
		
		public function get data():XML
		{
			return _data;
		}
		
		public function get quantity():int
		{
			if (_data.quantity.length() == 0)
			{
				return 1;
			} else {
				return parseInt(_data.quantity);
			}	
		}
		
		public function set quantity(n : int):void
		{
			_data.quantity = n;
		}
		
	}

}