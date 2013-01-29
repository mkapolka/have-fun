package org.component.flixel.collision 
{
	import org.flixel.FlxObject;
	import org.component.Message;
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class CollisionMessage extends Message 
	{
		public static const COLLISION_ENTER : String = "collision_enter";
		public static const COLLISION_EXIT : String = "collision_exit";
		public static const COLLISION : String = "collision";
		
		public var other : CollisionComponent;
		public var self : CollisionComponent;
		
		public function CollisionMessage() 
		{
			super();
		}
	}

}