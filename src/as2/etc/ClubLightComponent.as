package as2.etc 
{
	import org.component.Component;
	import org.component.flixel.FlxSpriteComponent;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class ClubLightComponent extends Component 
	{
		
		public function ClubLightComponent() 
		{
			super();
		}
		
		public function get sprite():FlxSprite
		{
			var comp : FlxSpriteComponent = getSiblingComponent(FlxSpriteComponent) as FlxSpriteComponent;
			
			if (comp != null)
			{
				return comp.sprite;
			} else {
				return null;
			}
		}
		
		override public function resolve():void
		{
			super.resolve();
			
			sprite.angularVelocity = 100;
			sprite.angle = Math.random() * 360;
			sprite.origin.x = 0;
			sprite.origin.y = sprite.height / 2;
		}
		
	}

}