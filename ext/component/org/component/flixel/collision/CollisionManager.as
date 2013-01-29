package org.component.flixel.collision 
{
	import flash.utils.Dictionary;
	import org.component.flixel.CMFlxObject;
	import org.component.flixel.EntityInterface;
	import org.flixel.FlxCamera;
	import org.flixel.FlxGroup;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxU;
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class CollisionManager 
	{
		private static var _collisionGroup : FlxGroup = new FlxGroup();
		private static var _collisionDictionary : Dictionary = new Dictionary();
		
		public function CollisionManager() 
		{
			
		}
		
		public static function addCollidable(object : FlxObject, component : CollisionComponent):void
		{
			_collisionGroup.add(object);
			_collisionDictionary[object] = component;
		}
		
		public static function removeCollidable(collidable : CollisionComponent):void
		{
			_collisionGroup.remove(collidable.object, true);
			delete _collisionDictionary[collidable.object];
		}
		
		public static function clearCollidables():void
		{
			_collisionGroup.members.splice(0, _collisionGroup.members.length);
			
			for (var o : Object in _collisionDictionary)
			{
				delete _collisionDictionary[o];
			}
		}
		
		public static function getCollisionComponent(object : FlxObject):CollisionComponent
		{
			return _collisionDictionary[object];
		}
		
		public static function getCollidablesAt(X : Number, Y : Number, inScreenSpace : Boolean = false, camera : FlxCamera = null):Vector.<CollisionComponent>
		{
			var point : FlxPoint = new FlxPoint(X, Y);
			var out : Vector.<CollisionComponent> = new Vector.<CollisionComponent>();
			
			for each (var e : FlxObject in _collisionGroup.members)
			{
				if (e.overlapsPoint(point, inScreenSpace, camera))
				{
					out.push(getCollisionComponent(e));
				}
			}
			
			return out;
		}
		
		public static function collide():void
		{
			FlxG.overlap(_collisionGroup, null, callback, null);
		}
		
		private static function callback(A : FlxObject, B : FlxObject):void
		{
			var collisionMessage : CollisionMessage = new CollisionMessage();
			
			var compA : CollisionComponent = _collisionDictionary[A];
			var compB : CollisionComponent = _collisionDictionary[B];
			
			if (compA == null || compB == null)
			{
				return;
			}
			
			if (!compA.object.active || !compB.object.active)
			{
				return;
			}
			
			collisionMessage.other = compB;
			collisionMessage.self = compA;
			compA.entity.sendMessage(collisionMessage);
			
			collisionMessage.other = compA;
			collisionMessage.self = compB;
			compB.entity.sendMessage(collisionMessage);
			
			if (compA.collisionIdentity & compB.collideWith ||
				compB.collisionIdentity & compA.collideWith)
			{
				FlxObject.separate(A, B);
			}
		}
		
	}

}