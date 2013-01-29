package org.component
{
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class Entity 
	{
		public static const DESTROY_ENTITY_MESSAGE : String = "entity_destroy";
		
		private var _componentList : Vector.<Component> = new Vector.<Component>();
		private var _children : Vector.<Entity> = new Vector.<Entity>();
		private var _parent : Entity;
		
		public var name : String;
		public var uid : uint;
		
		private var _markedForDeletion : Boolean = false;
		
		public function Entity() 
		{
			
		}
		
		public function get children():Vector.<Entity>
		{
			return _children;
		}
		
		public function get parent():Entity
		{
			return _parent;
		}
		
		public function get markedForDeletion():Boolean
		{
			return _markedForDeletion;
		}
		
		public function initialize():void
		{
			for each (var component : Component in _componentList)
			{
				if (!component.initialized)
				{
					initializeComponent(component);
				}
			}
			
			for each (var child : Entity in _children)
			{
				child.initialize();
			}
		}
		
		public function resolve():void
		{
			for each (var component : Component in _componentList)
			{
				component.resolve();
			}
			
			for each (var child : Entity in _children)
			{
				child.resolve();
			}
		}
		
		private function initializeComponent(component : Component):void
		{
			for each (var c : Class in component.requisiteComponents)
			{
				var comp : Component = getComponentByType(c);
				
				if (comp == null)
				{
					trace("ERROR: Component type " + c + " required by component " + getQualifiedClassName(component) + " not found in entity " + name + ". Stopping initialization.");
					continue;
				}
				
				if (!comp.initialized)
				{
					initializeComponent(comp);
				}
			}
			
			component.initialize();
		}
		
		public function destroy(severParentLink : Boolean = true):void
		{
			if (severParentLink && parent != null)
			{
				parent.removeEntity(this);
			}
			
			clearComponents();
			
			for each (var e : Entity in _children)
			{
				e.destroy(false);
			}
			
			_children.splice(0, _children.length);
			
			_markedForDeletion = true;
		}
		
		public function clearComponents():void
		{
			for each (var component : Component in _componentList)
			{
				component.destroy();
				EntityManager.removeComponent(component);
			}
			
			_componentList.splice(0, _componentList.length);
		}
		
		public function get components():Vector.<Component>
		{
			return _componentList;
		}
		
		public function addEntity(entity : Entity):void
		{
			children.push(entity);
			entity._parent = this;
		}
		
		public function removeEntity(entity : Entity):void
		{
			children.splice(children.indexOf(entity), 1);
			entity._parent = null;
		}
		
		public function addComponent(component : Component, sort : Boolean = true):void
		{
			_componentList.push(component);
			component.entity = this;
			
			EntityManager.addComponent(component, sort);
		}
		
		public function removeComponent(component : Component):void
		{
			_componentList.splice(_componentList.indexOf(component), 1);
			
			EntityManager.removeComponent(component);
			component.destroy();
		}
		
		public function removeComponentByType(type : Class):void
		{
			var toRemove : Vector.<Component> = new Vector.<Component>();
			
			for each (var component : Component in _componentList)
			{
				if (component is type)
				{
					toRemove.push(component);
				}
			}
			
			for each (component in toRemove)
			{
				removeComponent(component);
			}
		}
		
		public function getChildByName(name : String):Entity
		{
			for each (var child : Entity in children)
			{
				if (child.name == name)
				{
					return child;
				}
			}
			
			return null;
		}
		
		public function sendMessage(message : Message, recursive : Boolean = true):void
		{
			//Entity related messages
			if (message.type == DESTROY_ENTITY_MESSAGE)
			{
				destroy(true);
				return;
			}
			
			for each (var component : Component in _componentList)
			{
				if (component.enabled)
				{
					component.receiveMessage(message);
				}
			}
			
			if (recursive)
			{
				for each (var entity : Entity in _children)
				{
					entity.sendMessage(message, true);
				}
			}
		}
		
		public function hasComponentOfType(type : Class):Boolean
		{
			return (getComponentByType(type) != null);
		}
		
		public function getComponentByType(type : Class):Component 
		{
			for each (var component : Component in _componentList)
			{
				if (component is type) return component;
			}
			
			return null;
		}
		
		public function getComponentsByType(type : Class):Vector.<Component>
		{
			var out : Vector.<Component> = new Vector.<Component>();
			
			for each (var component : Component in _componentList)
			{
				if (component is type) out.push(component);
			}
			
			return out;
		}
		
		public function getComponentByName(name : String):Component
		{
			for each (var component : Component in _componentList)
			{
				if (component.name == name) return component;
			}
			
			return null;
		}
		
		public function getComponentsByName(name : String):Vector.<Component>
		{
			var out : Vector.<Component> = new Vector.<Component>();
			
			for each (var component : Component in _componentList)
			{
				if (component.name == name) out.push(component);
			}
			
			return out;
		}
		
		public function updateComponents():void
		{
			for each (var component : Component in _componentList)
			{
				if (component.enabled)
				{
					component.update();
				}
			}
		}
		
		public function updateComponentsOfType(type : Class):void
		{
			for each (var component : Component in _componentList)
			{
				if (component is type)
				{
					component.update();
				}
			}
		}
		
	}

}