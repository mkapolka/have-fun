package org.component.flixel 
{
	import org.component.Component;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class WorldBoundsComponent extends Component 
	{
		
		public function WorldBoundsComponent() 
		{
			super();
		}
		
		override public function loadContent(xml : XML):void
		{
			super.loadContent(xml);
			
			var cameraBounds : Boolean = true;
			var worldBounds : Boolean = true;
			
			if (xmlElementExists(xml, "cameraBounds"))
			{
				cameraBounds = extractXMLBoolean(xml.cameraBounds);
			}
			
			if (xmlElementExists(xml, "worldBounds"))
			{
				worldBounds = extractXMLBoolean(xml.worldBounds);
			}
			
			var x : Number = parseFloat(xml.x);
			var y : Number = parseFloat(xml.y);
			var width : Number = parseFloat(xml.width);
			var height : Number = parseFloat(xml.height);
			
			if (worldBounds)
			{
				FlxG.worldBounds.x = x;
				FlxG.worldBounds.y = y;
				FlxG.worldBounds.width = width;
				FlxG.worldBounds.height = height;
			}
			
			if (cameraBounds)
			{
				for each (var c : FlxCamera in FlxG.cameras)
				{
					c.setBounds(x, y, width, height);
				}
			}
		}
		
	}

}