package org.component.flixel 
{
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class CMFlxSprite extends FlxSprite implements EntityInterface 
	{
		public var entity : Entity;
		
		public function CMFlxSprite(X : Number, Y : Number, SimpleGraphic : Class) 
		{
			super(X, Y, SimpleGraphic);
		}
		
		public function getEntity():Entity
		{
			return entity;
		}
		
	}

}