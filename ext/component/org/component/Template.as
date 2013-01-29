package org.component 
{
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class Template 
	{
		private static var _templates : Array = new Array();
		
		private var _data : XML;
		private var _id : String;
		
		public function Template(data : XML) 
		{
			_data = data;
		}
		
		public function get data():XML
		{
			return _data;
		}
		
		public static function storeTemplate(id : String, template : Template):void
		{
			template._id = id;
			_templates[id] = template;
		}
		
		public static function removeTemplate(id : String):void
		{
			_templates[id] = null;
		}
		
		public static function getTemplate(id : String):Template
		{
			return _templates[id];
		}
		
		public static function createEntityViaTemplate(id : String, add : Boolean = true):Entity
		{
			var template : Template = getTemplate(id);
			
			if (template != null)
			{
				var entity : Entity = ContentLoader.createEntity(template.data, add);
				return entity;
			} else {
				trace("ERROR: Could not find Template for id \"" + id + "\"");
				return null;
			}
		}
		
	}

}