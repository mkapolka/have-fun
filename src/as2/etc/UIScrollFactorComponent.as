package as2.etc 
{
	import org.component.Component;
	import org.component.Entity;
	import org.component.flixel.FlxSpriteComponent;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class UIScrollFactorComponent extends Component 
	{
		
		public function UIScrollFactorComponent() 
		{
			super();
		}
		
		override public function update():void
		{
			super.update();
			
			scrollFactorRecursive(entity);
			
			entity.removeComponent(this);
		}
		
		private function scrollFactorRecursive(entity : Entity):void
		{
			var sc : Component = entity.getComponentByType(FlxSpriteComponent);
			
			if (sc != null)
			{
				(FlxSpriteComponent)(sc).sprite.scrollFactor = new FlxPoint();
			}
			
			for each (var child : Entity in entity.children)
			{
				scrollFactorRecursive(child);
			}
		}
		
	}

}