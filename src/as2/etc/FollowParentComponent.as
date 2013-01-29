package as2.etc 
{
	import org.component.Component;
	import org.component.Entity;
	import org.component.flixel.FlxObjectComponent;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class FollowParentComponent extends Component 
	{
		
		private var _offset : FlxPoint = new FlxPoint();
		
		public function FollowParentComponent() 
		{
			super();
			
			addRequisiteComponent(FlxObjectComponent);
		}
		
		private function get objectComponent():FlxObjectComponent
		{
			return (FlxObjectComponent)(getSiblingComponent(FlxObjectComponent));
		}
		
		private function get object():FlxObject
		{
			var foc : FlxObjectComponent = objectComponent;
			
			if (foc != null)
			{
				return foc.object;
			} else {
				return null;
			}
		}
		
		private function get parentObjectComponent():FlxObjectComponent
		{
			if (entity.parent == null) return null;
			
			return (FlxObjectComponent)(entity.parent.getComponentByType(FlxObjectComponent));
		}
		
		private function get parentObject():FlxObject
		{
			return (parentObjectComponent!=null?parentObjectComponent.object:null);
		}
		
		override public function resolve():void
		{
			super.resolve();
			
			var parent : Entity = entity.parent;
			
			if (parent != null)
			{
				var po : FlxObject = parentObject;
				
				if (po != null)
				{
					_offset.x = po.x - object.x;
					_offset.y = po.y - object.y;
				}
			}
		}
		
		override public function update():void
		{
			super.update();
			
			var o : FlxObject = object;
			var po : FlxObject = parentObject;
			
			if (o != null && po != null)
			{
				o.x = po.x - _offset.x;
				o.y = po.y - _offset.y;
			}
		}
		
	}

}