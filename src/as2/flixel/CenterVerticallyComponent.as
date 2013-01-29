package as2.flixel 
{
	import org.component.Component;
	import org.component.flixel.FlxObjectComponent;
	import org.flixel.FlxObject;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class CenterVerticallyComponent extends Component 
	{
		
		public function CenterVerticallyComponent() 
		{
			super();
			
			addRequisiteComponent(FlxObjectComponent);
		}
		
		public function get object():FlxObject
		{
			return (FlxObjectComponent)(getSiblingComponent(FlxObjectComponent)).object;
		}
		
		public function get target():FlxObject
		{
			return (FlxObjectComponent)(entity.parent.getComponentByType(FlxObjectComponent)).object;
		}
		
		override public function update():void
		{
			super.update();
			
			object.y = target.y + (target.height / 2 - object.height / 2);
		}
		
	}

}