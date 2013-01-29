package org.component.flixel.sprite 
{
	import org.component.Component;
	import org.component.flixel.FlxSpriteComponent;
	import org.component.Message;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class TriggeredColorComponent extends Component 
	{
		
		private var _array : Array = new Array();
		
		public function TriggeredColorComponent() 
		{
			super();
			
			addRequisiteComponent(FlxSpriteComponent);
		}
		
		public function get sprite():FlxSprite
		{
			var c : Component = entity.getComponentByType(FlxSpriteComponent);
			
			if (c != null)
			{
				return (FlxSpriteComponent)(c).sprite;
			}
			
			return null;
		}
		
		override public function receiveMessage(m : Message):void
		{
			for (var trigger : String in _array)
			{
				if (m.type == trigger)
				{
					sprite.color = _array[trigger];
					sprite.alpha = ColorUtils.ARGBtoAlpha(_array[trigger]); 
					return;
				}
			}
		}
		
		override public function loadContent(xml : XML):void
		{
			super.loadContent(xml);
			
			if (xmlElementExists(xml, "triggers"))
			{
				var a : Array = extractArray(xml.triggers);
				
				for each (var s : String in a)
				{
					var trigger : Array = s.split(" ");
					
					_array[trigger[0]] = trigger[1];
				}
			}
		}
		
	}

}