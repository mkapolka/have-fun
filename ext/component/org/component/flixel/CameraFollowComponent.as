package org.component.flixel 
{
	import org.component.Component;
	import org.component.flixel.FlxObjectComponent;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class CameraFollowComponent extends Component 
	{
		
		public function CameraFollowComponent() 
		{
			super();
			
			addRequisiteComponent(FlxObjectComponent);
		}
		
		override public function initialize():void
		{
			super.initialize();
			var oc : FlxObjectComponent = (FlxObjectComponent)(getSiblingComponent(FlxObjectComponent));
			
			FlxG.camera.follow(oc.object);
		}
		
	}

}