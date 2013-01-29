package org.component
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class ContentLoader 
	{
		public static var factories : Array = new Array();
		private static var _factoriesInitialized : Boolean = false;
		private static var _highestUID : uint = 0;
		
		public function ContentLoader() 
		{
			
		}
		
		private static function initialize():void
		{
			if (!_factoriesInitialized)
			{
				factories["Component"] = Component;
			
				_factoriesInitialized = true;
			}
		}
		
		private static function stringToBool(string : String):Boolean
		{
			if (string.toLowerCase() == "false" || parseInt(string) <= 0)
			{
				return false;
			} else {
				return true;
			}
		}
		
		private static function deleteNode(node:XML):void
		{
			if (node != null && node.parent() != null)
			{
				delete node.parent().children()[node.childIndex()];
			}
		}
		
		private static function instantiateEntity(xml : XML, componentDictionary : Dictionary):Entity
		{
			//Check for non-instantiating template, do not continue if it does not warrant it
			for each (var cx : XML in xml.elements())
			{
				if (cx.name() == "Template")
				{
					var templateXML : XML = new XML(xml);
					for each (var x2 : XML in templateXML.elements())
					{
						if (x2.name() == "Template")
						{
							deleteNode(x2);
						}
					}
					
					var template : Template = new Template(templateXML);
					
					Template.storeTemplate(cx.id, template);
					
					if (!stringToBool(cx.instantiate))
					{
						return null;
					}
				}
			}
			
			var entity : Entity = new Entity();
			entity.name = xml.attribute("name");
			entity.uid = parseInt(xml.attribute("uid"));
			
			var uidOffset : uint = _highestUID;
			
			for each (cx in xml.elements())
			{
				if (cx.name() == "entity")
				{
					var ec : Entity = instantiateEntity(cx, componentDictionary);
					
					if (ec != null)
					{
						entity.addEntity(ec);
					}
					
					continue;
				}
				
				if (cx.name() == "Template")
				{
					
				}
				
				var c : Class = factories[cx.name()];
				
				if (c != null)
				{
					var component : Component = new c();
					component.name = cx.name();
					component.uid = parseInt(cx.attribute("uid")[0]);// uidOffset + parseInt(cx.attribute("uid")[0]);
					
					//if (component.uid > _highestUID) _highestUID = component.uid;
					
					entity.addComponent(component, false);
					
					componentDictionary[component] = cx;
				} else {
					trace("Factory not found for component: " + cx.name() + " in entity: " + xml.attribute("name"));
				}
			}
			
			EntityManager.addEntity(entity);
			
			return entity;
		}
		
		public static function createEntity(xml : XML, add : Boolean = true):Entity
		{
			var componentDictionary : Dictionary = new Dictionary();
			var entity : Entity = instantiateEntity(xml, componentDictionary);
			
			if (entity == null) return null;
			
			for (var object : Object in componentDictionary)
			{
				var component : Component = (Component)(object);
				
				component.loadContent(componentDictionary[component]);
			}
			
			entity.initialize();
			entity.resolve();
			
			if (add)
			{
				EntityManager.addEntity(entity);
			}
			
			return entity;
		}
		
		public static function loadContent(xml : XML):Vector.<Entity>
		{
			initialize();
			
			var componentDictionary : Dictionary = new Dictionary();
			var component : Component;
			var entities : Vector.<Entity> = new Vector.<Entity>();
			
			//Construction phase
			for each (var ex : XML in xml.entity)
			{
				var entity : Entity = instantiateEntity(ex, componentDictionary);
				if (entity == null) continue;
				entities.push(entity);
			}
			
			EntityManager.sortComponents();
			
			//Load content phase
			for (var object : Object in componentDictionary)
			{
				component = (Component)(object);
				
				component.loadContent(componentDictionary[component]);
			}
			
			//Initialize phase - ready components for inter-component communication
			for each (var e : Entity in entities)
			{
				e.initialize();
			}
			
			//Resolve phase- for inter-component / entity communication
			for each(e in entities)
			{
				e.resolve();
			}
			
			return entities;
		}
		
	}

}