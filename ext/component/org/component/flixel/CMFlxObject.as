package org.component.flixel 
{
	import org.flixel.FlxObject;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class CMFlxObject extends FlxObject implements EntityInterface
	{
		public var entity : Entity;
		
		public function CMFlxObject(X:Number=0, Y:Number=0, Width:Number=0, Height:Number=0) 
		{
			super(X, Y, Width, Height);
		}
		
		public function getEntity():Entity
		{
			return entity;
		}
		
	}

}