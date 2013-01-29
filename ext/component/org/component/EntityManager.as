package org.component
{
	import flash.text.ime.CompositionAttributeRange;
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class EntityManager 
	{		
		private static var _entities : Vector.<Entity> = new Vector.<Entity>();
		private static var _components : Vector.<Component> = new Vector.<Component>();
		
		public function EntityManager() 
		{
		
		}
		
		public static function broadcastMessage(message : Message):void
		{
			for each (var e : Entity in _entities)
			{
				e.sendMessage(message);
			}
		}
		
		public static function getComponentByUID(uid : uint):Component
		{
			//todo: make this fast
			/*if (_components.length <= uid)
			{
				return getComponentByUIDSlow(uid);
			}
			
			var output : Component = _components[uid];
			
			if (output.uid != uid)
			{
				_components.
				
				return getComponentByUIDSlow(uid);
			}*/
			
			return getComponentByUIDSlow(uid);
			
			//return output;
		}
		
		private static function bsearch(uid : uint):Component
		{
			var n : uint = 2;
			var index : uint = _components.length / n;
			
			if (_components[index].uid > uid)
			{
				
			}
			
			if (_components[index].uid < uid)
			{
			
			}
			
			if (_components[index].uid == uid)
			{
				return _components[index];
			}
			
			return null;
		}
		
		private static function getComponentByUIDSlow(uid : uint):Component
		{
			for each (var c : Component in _components)
			{
				if (c.uid == uid)
				{
					return c;
				}
			}
			
			return null;
		}
		
		public static function getAllComponents():Vector.<Component>
		{			
			return _components;
		}
		
		public static function getAllEntities():Vector.<Entity>
		{
			return _entities;
		}
		
		public static function getAllComponentsOfType(type : Class):Vector.<Component>
		{
			var output : Vector.<Component> = new Vector.<Component>();
			
			for each (var c : Component in _components)
			{
				if (c is type)
				{
					output.push(c);
				}
			}
			
			return output;
		}
		
		public static function addEntity(e : Entity):void
		{
			_entities.push(e);
		}
		
		public static function removeEntity(e : Entity, destroy : Boolean = true ):void 
		{
			if (destroy)
			{
				e.destroy();
			}
			
			_entities.splice(_entities.indexOf(e), 1);
		}
		
		public static function removeAllEntities():void
		{
			for each (var e : Entity in _entities)
			{
				e.destroy();
			}
			
			_entities = new Vector.<Entity>();
		}
		
		public static function addComponent(c : Component, sort : Boolean = true):void
		{
			_components.push(c);
			
			if (sort)
			{
				sortComponents();
			}
		}
		
		public static function removeComponent(c : Component):void
		{
			_components.splice(_components.indexOf(c), 1);
		}
		
		public static function sortComponents():void
		{
			_components.sort(sort_components);
		}
		
		private static function sort_components(A : Object, B : Object):Number
		{
			var ca : Component = (Component)(A);
			var cb : Component = (Component)(B);
			
			if (ca.uid > cb.uid) return 1;
			if (ca.uid < cb.uid) return -1;
			return 0;
		}
		
		public static function get entities():Vector.<Entity>
		{
			return _entities;
		}
		
		public static function getEntityByName(name : String):Entity
		{
			for each (var entity : Entity in _entities)
			{
				if (entity.name == name) return entity;
			}
			
			return null;
		}
		
		public static function getEntitiesByName(name : String):Vector.<Entity>
		{
			var output : Vector.<Entity> = new Vector.<Entity>();
			
			for each (var entity : Entity in _entities)
			{
				if (entity.name == name) output.push(entity);
			}
			
			return output;
		}
		
		public static function getEntityByUID(uid : uint):Entity
		{
			for each (var entity : Entity in _entities)
			{
				if (entity.uid == uid) return entity;
			}
			
			return null;
		}
		
		public static function update():void
		{
			for each (var entity : Entity in _entities)
			{
				entity.updateComponents();
			}
		}
		
	}

}