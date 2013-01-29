package org.component.flixel.collision 
{
	import org.flixel.FlxObject;
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	
	import org.component.flixel.FlxObjectComponent;
	import org.component.Component;
	import org.component.Message;
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class CollisionComponent extends Component
	{
		protected static var _groups : Array = new Array();
		protected static var _groupsLength : int = 0;
		
		protected var _object : FlxObject;
		protected var _collisionIdentity : uint;
		protected var _collideWith : uint;
		
		public function CollisionComponent()
		{
			super();
			
			addRequisiteComponent(FlxObjectComponent);
		}
		
		public function get collisionIdentity():uint
		{
			return _collisionIdentity;
		}
		
		public function get collideWith():uint
		{
			return _collideWith;
		}
		
		public function addCollisionIdentity(group : String):void
		{
			var id : Object = _groups[group];
			
			if (id != null)
			{
				_collisionIdentity |= (uint)(id);
			}
		}
		
		public function addCollideWith(group : String):void
		{
			var id : Object = _groups[group]
			
			if (id != null)
			{
				_collideWith |= (uint)(id);
			}
		}
		
		public function removeCollisionIdentity(group : String):void
		{
			var id : Object = _groups[group];
			
			if (id != null)
			{
				_collisionIdentity -= (uint)(id);
			}
		}
		
		public function removeCollideWith(group : String):void
		{
			var id : Object = _groups[group]
			
			if (id != null)
			{
				_collideWith -= (uint)(id);
			}
		}
		
		public function doesCollideWith(group : String):Boolean
		{
			var id : Object = _groups[group];
			
			if (id != null)
			{
				return (_collideWith & (uint)(id)) > 0;
			} else {
				return false;
			}
		}
		
		public function hasCollisionIdentity(group : String):Boolean
		{
			var id : Object = _groups[group];
			
			if (id != null)
			{
				return (_collisionIdentity & (uint)(id)) > 0;
			} else {
				return false;
			}
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			var objc : Component = entity.getComponentByType(FlxObjectComponent);
			var foc : FlxObjectComponent = (FlxObjectComponent)(objc);
			
			_object = foc.object;
			
			CollisionManager.addCollidable(_object, this);
		}
		
		override public function destroy():void
		{
			CollisionManager.removeCollidable(this);
			_object = null;
		}
		
		public function get object():FlxObject
		{
			return _object;
		}
		
		protected function doCollision(collisionMessage : CollisionMessage):void
		{
			//
		}
		
		override public function receiveMessage(message : Message):void
		{
			if (message is CollisionMessage)
			{
				var cm : CollisionMessage = (CollisionMessage)(message);
				
				doCollision(cm);
			}
		}
		
		public function shouldCollideWith(other : CollisionComponent):Boolean
		{
			var result : uint = (this.collisionIdentity & other.collideWith ||
								 other.collisionIdentity & this.collideWith);
			return (result > 0);
		}
		
		protected function extractCollisionGroups(groups : String, collideWith : String):void
		{
			var s_collisionGroups : String = groups;
			var collisionGroups : Array = s_collisionGroups.split(" ");
			
			for each (var s : String in collisionGroups)
			{
				var gn : Object = _groups[s];
				var gni : uint = 0;
				
				if (gn == null)
				{
					gni = (uint)(Math.pow(2, _groupsLength));
					_groups[s] = gni;
					_groupsLength++;
				} else {
					gni = (uint)(gn);
				}
				
				_collisionIdentity |= gni;
			}
			
			s_collisionGroups = collideWith;
			collisionGroups = s_collisionGroups.split(" ");
			
			for each (s in collisionGroups)
			{
				gn = _groups[s];
				
				if (gn == null)
				{
					gni = (uint)(Math.pow(2, _groupsLength));
					_groups[s] = gni;
					_groupsLength++;
				} else {
					gni = (uint)(gn);
				}
				
				_collideWith |= gni;
			}
		}
		
		override public function loadContent(xml : XML):void
		{
			super.loadContent(xml);
			
			extractCollisionGroups(xml.identity, xml.collideWith);
		}
			
	}
}