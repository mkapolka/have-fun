package org.component.flixel.sprite 
{
	import org.component.Component;
	import org.component.flixel.FlxSpriteComponent;
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class LoopingSpriteComponent extends Component 
	{
		
		private var _loopVertical : Boolean = false;
		private var _loopHorizontal : Boolean = false;
		
		public function LoopingSpriteComponent() 
		{
			super();
		}
		
		public function get spriteComponent():FlxSpriteComponent
		{
			return (FlxSpriteComponent)(getSiblingComponent(FlxSpriteComponent));
		}
		
		public function get sprite():FlxSprite
		{
			var sc : FlxSpriteComponent = spriteComponent;
			
			if (sc != null)
			{
				return sc.sprite;
			} else {
				return null;
			}
		}
		
		override public function update():void
		{
			super.update();
			
			var s : FlxSprite = sprite;
			
			if (s != null)
			{
				if (!s.onScreen())
				{
					var point : FlxPoint = new FlxPoint();
					s.getScreenXY(point);
					
					if (_loopHorizontal)
					{
						if (point.x > FlxG.camera.width / 2)
						{
							s.x -= FlxG.camera.width + s.width;
						} else {
							s.x += FlxG.camera.width + s.width;
						}
					}
					
					if (_loopVertical)
					{
						if (point.y > FlxG.camera.height / 2)
						{
							s.y -= FlxG.camera.height + s.height;
						} else {
							s.y += FlxG.camera.height + s.height;
						}
					}
				}
			}
		}
		
		override public function loadContent(xml : XML):void
		{
			super.loadContent(xml);
			
			if (xmlElementExists(xml, "loopHorizontal"))
			{
				_loopHorizontal = extractXMLBoolean(xml.loopHorizontal);
			}
			
			if (xmlElementExists(xml, "loopVertical"))
			{
				_loopVertical = extractXMLBoolean(xml.loopVertical);
			}
		}
		
	}

}