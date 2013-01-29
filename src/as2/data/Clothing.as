package as2.data 
{
	import as2.AS2GameData;
	import flash.display.InteractiveObject;
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class Clothing 
	{
		public static const SLOT_TOP : uint = 0;
		public static const SLOT_BOTTOM : uint = 1;
		
		private var _data : XML;
		
		public function Clothing(xml : XML = null) 
		{
			if (xml == null)
			{
				_data = new XML("<clothing></clothing>");
			} else {
				_data = xml;
			}
		}
		
		public static function getRandomNameShirt():String
		{
			var adjs : Array = (String)(AS2GameData.data.clothing_adjectives).split(", ");
			var brands : Array = (String)(AS2GameData.data.clothing_brands).split(", ");
			var shirts : Array = (String)(AS2GameData.data.shirt_names).split(", ");
			
			var a : String = adjs[Math.floor(Math.random() * adjs.length)];
			var b : String = brands[Math.floor(Math.random() * brands.length)];
			var s : String = shirts[Math.floor(Math.random() * shirts.length)];
			
			return a + " " + b + " " + s;
		}
		
		public static function getRandomNamePants():String
		{
			var adjs : Array = (String)(AS2GameData.data.clothing_adjectives).split(", ");
			var brands : Array = (String)(AS2GameData.data.clothing_brands).split(", ");
			var shirts : Array = (String)(AS2GameData.data.pants_names).split(", ");
			
			var a : String = adjs[Math.floor(Math.random() * adjs.length)];
			var b : String = brands[Math.floor(Math.random() * brands.length)];
			var s : String = shirts[Math.floor(Math.random() * shirts.length)];
			
			return a + " " + b + " " + s;
		}
		
		public function get data():XML
		{
			return _data;
		}
		
		public function get name():String
		{
			return data.name;
		}
		
		public function set name(s : String):void
		{
			data.name = s;
		}
		
		public function get dateBought():int
		{
			return parseInt(data.dateBought);
		}
		
		public function set dateBought(value : int):void
		{
			data.dateBought = value;
		}
		
		public function get toBeDelivered():int
		{
			return parseInt(data.toBeDelivered);
		}
		
		public function set toBeDelivered(value : int):void 
		{
			data.toBeDelivered = value;
		}
		
		public function get funkiness():Number
		{
			return parseFloat(data.funkiness);
		}
		
		public function set funkiness(value : Number):void
		{
			data.funkiness = value;
		}
		
		public function get description():String
		{
			return data.description;
		}
		
		public function set description(s : String):void
		{
			data.description = s;
		}
		
		public function get id():String
		{
			return data.id;
		}
		
		public function set id(s : String):void
		{
			data.id = s;
		}
		
		public function get texture():uint
		{
			return parseInt(data.texture);
		}
		
		public function set texture(n : uint):void
		{
			data.texture = n;
		}
		
		public function get slot():uint
		{
			return parseInt(data.slot);
		}
		
		public function set slot(n : uint):void
		{
			data.slot = n;
		}
	}

}