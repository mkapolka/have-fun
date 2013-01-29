package org.component
{
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class Component 
	{
		public static const DEFAULT_NAME : String = "baseComponent";
		
		protected var _requisiteComponents : Vector.<Class>;
		protected var _entity : Entity;
		
		protected var _name : String;
		protected var _uid : uint;
		
		protected var _enabled : Boolean = false;
		public var initialized : Boolean = false;
		
		public function Component() 
		{
			_name = DEFAULT_NAME;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set name(s : String):void
		{
			_name = s;
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function set enabled(b : Boolean):void
		{
			_enabled = b;
		}
		
		public function get entity():Entity
		{
			return _entity;
		}
		
		public function set entity(entity : Entity):void
		{
			_entity = entity;
		}
		
		public function set uid(uid : uint):void
		{
			_uid = uid;
		}
		
		public function get uid():uint 
		{
			return _uid;
		}
		
		public function get requisiteComponents():Vector.<Class>
		{
			return _requisiteComponents;
		}
		
		public function addRequisiteComponent(type : Class):void
		{
			if (_requisiteComponents == null) _requisiteComponents = new Vector.<Class>();
			_requisiteComponents.push(type);
		}
		
		public function initialize():void
		{
			for each (var type : Class in _requisiteComponents)
			{
				if (!entity.hasComponentOfType(type))
				{
					trace("ERROR: Component " + _name + " requires a sibling component of type " + type + " but its parent entity does not have one.");
					enabled = false;
					return;
				}
			}
			
			enabled = true;
			initialized = true;
		}
		
		public function resolve():void
		{
			
		}
		
		public function destroy():void
		{
			
		}
		
		public function getSiblingComponent(type : Class):Component
		{
			return entity.getComponentByType(type);
		}
		
		public function getSiblingComponents(type : Class):Vector.<Component>
		{
			return entity.getComponentsByType(type);
		}
		
		public function loadContent(xml : XML):void
		{
			if (xml.attribute("name") != null)
			{
				_name = xml.attribute("name");
			} else {
				_name = xml.name();
			}
			
			if (xmlElementExists(xml, "startEnabled"))
			{
				enabled = extractXMLBoolean(xml.startEnabled);
			}
		}
		
		public function receiveMessage(message : Message):void
		{
			
		}
		
		public function update():void
		{
			//
		}
		
		protected function xmlElementExists(xml : XML, name : String):Boolean
		{
			if (xml.elements(name).length() > 0) return true;
			return false;
		}
		
		protected function extractArray(xml : XMLList):Array
		{
			var out : Array = new Array();
			
			for each (var entry : XML in xml.entry)
			{
				out.push(entry.toString());
			}
			
			return out;
		}
		
		protected function stringToBool(s : String):Boolean
		{			
			if (s.toLowerCase() == "true" || parseInt(s) > 0)
			{
				return true;
			}
			
			if (s.toLowerCase() == "false" || parseInt(s) <= 0)
			{
				return false;
			}
			
			return false;
		}
		
		protected function extractXMLBoolean(xml : XMLList):Boolean
		{
			var s : String = (String)(xml[0]);
			
			return stringToBool(s);
		}
		
	}

}