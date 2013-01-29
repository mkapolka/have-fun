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
	 * ...
	 * @author Marek Kapolka
	 */
	public class ActableComponent extends Component 
	{
		public static const INTERACTION_USE : String = "Use";
		public static const INTERACTION_TALK : String = "Talk";
		public static const INTERACTION_EXAMINE : String = "Examine";
		public static const INTERACTION_SMARTPHONE : String = "Smartphone";
		
		public static const ACTION_MESSAGE : String = "action";
		
		private var _mouseOverName : String = "Something";
		private var _actionPointAnchor : String = "action";
		private var _interactionType : String = INTERACTION_USE;
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