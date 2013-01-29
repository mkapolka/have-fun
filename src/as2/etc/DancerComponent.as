package as2.etc 
{
	import org.component.Component;
	import org.component.flixel.AnimatedFlxSpriteComponent;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class DancerComponent extends Component 
	{
		public static var spriteIndex : uint = 0;
		
		public function DancerComponent() 
		{
			super();
			
			addRequisiteComponent(AnimatedFlxSpriteComponent);
		}
		
		public function get sprite():FlxSprite
		{
			var comp : AnimatedFlxSpriteComponent = getSiblingComponent(AnimatedFlxSpriteComponent) as AnimatedFlxSpriteComponent;
			
			if (comp != null)
			{
				return comp.sprite;
			} else {
				return null;
			}
		}
		
		public function get bounce():BounceComponent
		{
			return getSiblingComponent(BounceComponent) as BounceComponent;
		}
		
		override public function resolve():void
		{
			super.resolve();
			
			//sprite.frame = Math.floor(Math.random() * 11);
			sprite.frame = (spriteIndex++ % 11);
			
			bounce.distance = 40 + (Math.random() * 20);
			bounce.offset = Math.random();
			bounce.speed = 1.75 + (Math.random() * .5);
		}
		
	}

}