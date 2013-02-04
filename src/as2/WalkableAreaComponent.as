package as2 
{
	import flash.geom.Point;
	import org.component.Component;
	import org.component.Entity;
	import org.component.Message;
	import org.flixel.FlxG;
	
	/**
	 * Defines an area that can be walked on. The dimensions of the walkable area will be taken
	 * from this components' sibling FlxObjectComponent. 
	 * @author Marek Kapolka
	 */
	public class WalkableAreaComponent extends Component 
	{
		
		private var _walkTrigger : String = "down";
		
		public function WalkableAreaComponent() 
		{
			super();
		}
		
		override public function receiveMessage(message : Message):void
		{
			/*if (message.type == _walkTrigger)
			{
				var player : Entity = TaggedObjectComponent.getObjectByTag("Player");
				
				var outMessage : CharacterNavigationMessage = new CharacterNavigationMessage();
				outMessage.sender = this;
				outMessage.data = new Point(FlxG.mouse.x, FlxG.mouse.y);
				outMessage.type = CharacterNavigationMessage.SET_TARGET;
				
				player.sendMessage(outMessage);
			}*/
		}
		
		override public function loadContent(xml : XML):void
		{
			super.loadContent(xml);
			
			if (xmlElementExists(xml, "walkTrigger"))
			{
				_walkTrigger = xml.walkTrigger;
			}
		}
		
	}

}