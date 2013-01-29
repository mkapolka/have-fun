package org.component.flixel
{
	import org.component.ContentLoader;
	import org.component.flixel.sprite.LoopingSpriteComponent;
	import org.component.flixel.sprite.TriggeredColorComponent;
	
	import org.component.flixel.collision.*;
	import org.component.flixel.movement.*;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class FlixelFactories 
	{
		
		public function FlixelFactories() 
		{
			
		}
		
		public static function initialize():void
		{
			ContentLoader.factories["FlxSprite"] = FlxSpriteComponent;
			ContentLoader.factories["AnimatedFlxSprite"] = AnimatedFlxSpriteComponent;
			ContentLoader.factories["FlxObject"] = FlxObjectComponent;
			ContentLoader.factories["FlxText"] = FlxTextComponent;
			
			ContentLoader.factories["Cursor"] = FollowCursor;
			ContentLoader.factories["PlayerController"] = PlayerWalkingComponent;
			
			ContentLoader.factories["Collision"] = CollisionComponent;
			ContentLoader.factories["AnimationMessageBridge"] = AnimationMessageBridgeComponent;
			ContentLoader.factories["Anchor"] = Anchor;
			
			ContentLoader.factories["ColorTrigger"] = TriggeredColorComponent;
			ContentLoader.factories["WorldBounds"] = WorldBoundsComponent;
			ContentLoader.factories["CameraFollow"] = CameraFollowComponent;
			ContentLoader.factories["ShowMouse"] = ShowMouseComponent;
			
			ContentLoader.factories["LoopingSprite"] = LoopingSpriteComponent;
		}
		
	}

}