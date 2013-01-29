package org.component.flixel 
{
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class SpriteLibrary 
	{
		private static var library : Array = new Array();
		
		public function SpriteLibrary() 
		{
			
		}
		
		public function initialize():void
		{
			
		}
		
		public static function addSprite(key : String, sprite : Class):void
		{
			library[key] = sprite;
		}
		
		public static function getSpriteClass(key : String):Class
		{
			var out : Class = library[key];
			if (out == null)
			{
				trace("SPRITE NOT FOUND FOR KEY \"" + key + "\"");
			}
			return out;
		}
		
	}

}