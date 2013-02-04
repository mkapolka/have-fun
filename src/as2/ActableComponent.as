package as2 
{
	import flash.geom.Point;
	import org.component.Component;
	import org.component.Entity;
	import org.component.flixel.Anchor;
	import org.component.flixel.FlxObjectComponent;
	import org.component.flixel.FlxTextComponent;
	import org.component.Message;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	
	/**
	 * Defines a component that can be interacted with. When an entity has this component,
	 * the game will update the mouse-over text when the user hovers their mouse over this object.
	 * If the user clicks on this object, it will send the relevant action commands to the player
	 * to walk over and interact with it. The code for updating the mouse-over text and sending the
	 * movement instructions to the player can be found in AS2CursorComponent.as. Once the player character
	 * reaches this object, it sends a message of type ActableComponent.ACTION_MESSAGE to the component's
	 * parent entity, to be parsed by a component such as AS2DialogInitiatorComponent.
	 * @author Marek Kapolka
	 */
	public class ActableComponent extends Component 
	{
		//The different types of interactions- these determine what messages are sent
		//to what entities when the player interacts with them in addition to the ACTION_MESSAGE message
		//that is always sent to this component's parent entity.
		
		//"Use": When the player reaches this object it will send a "use" message to the player, in order to play the "use" animation
		public static const INTERACTION_USE : String = "Use";
		//"talk": sends a message to the player in order to play the "talking" animation
		public static const INTERACTION_TALK : String = "Talk";
		//"examine": no additional messages
		public static const INTERACTION_EXAMINE : String = "Examine";
		//"smartphone": sends a message to the player to play the "looking-at-smartphone" animation
		public static const INTERACTION_SMARTPHONE : String = "Smartphone";
		
		public static const ACTION_MESSAGE : String = "action";
		
		private var _mouseOverName : String = "Something";
		private var _actionPointAnchor : String = "action";
		private var _interactionType : String = INTERACTION_USE;
		//Should the player walk over to this object or can they interact with it from wherever (i.e. UI buttons?)
		private var _walkTo : Boolean = false;
		
		public function ActableComponent() 
		{
			super();
			
			addRequisiteComponent(FlxObjectComponent);
		}
		
		public function get mouseOverName():String
		{
			return _mouseOverName;
		}
		
		public function get interactionType() : String
		{
			return _interactionType;
		}
		
		public function get walkTo():Boolean
		{
			return _walkTo;
		}
		
		/**
		 * The anchor specifies where the player should move to when they walk up to this object.
		 */
		public function get anchor():Anchor
		{
			var anchors : Vector.<Component> = getSiblingComponents(Anchor);
			
			for each (var a : Anchor in anchors)
			{
				if (a.id == _actionPointAnchor)
				{
					return a;
				}
			}
			
			return null;
		}
		
		public function getActionPoint():Point 
		{
			var acAnchor : Anchor = anchor;
			
			var p : Point = new Point();
				
			if (acAnchor != null)
			{
				var fp : FlxPoint = acAnchor.getWorldPoint((FlxObjectComponent)(getSiblingComponent(FlxObjectComponent)).object);
				
				p.x = fp.x;
				p.y = fp.y;
			} else {
				var object : FlxObject = (FlxObjectComponent)(getSiblingComponent(FlxObjectComponent)).object;
				
				p.x = object.x;
				p.y = object.y;
			}
			
			return p;
		}
		
		override public function receiveMessage(message : Message):void
		{
			super.receiveMessage(message);
		}
		
		override public function loadContent(xml : XML):void
		{
			super.loadContent(xml);
			
			if (xmlElementExists(xml, "mouseOverName"))
			{
				_mouseOverName = xml.mouseOverName;
			}
			
			if (xmlElementExists(xml, "actionPointAnchor"))
			{
				_actionPointAnchor = xml.actionPointAnchor;
			}
			
			if (xmlElementExists(xml, "interactionType"))
			{
				_interactionType = xml.interactionType;
			}
			
			if (xmlElementExists(xml, "walkTo"))
			{
				_walkTo = extractXMLBoolean(xml.walkTo);
			}
		}
		
	}

}