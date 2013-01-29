package org.component.flixel.movement 
{
	import org.component.flixel.Anchor;
	import org.component.Message;
	import org.flixel.FlxObject;
	import org.flixel.FlxG;
	import org.component.flixel.FlxObjectComponent;
	import org.component.Component;
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class FollowCursor extends Component 
	{
		private var object : FlxObject;
		
		private var _xoffset : Number = 0;
		private var _yoffset : Number = 0;
		private var _clickMessage : String = "click";
		private var _releasedMessage : String = "release";
		private var _anchor : String = null;
		
		public function FollowCursor() 
		{
			super();
			addRequisiteComponent(FlxObjectComponent);
		}
		
		public function get anchor():Anchor
		{
			var anchors : Vector.<Component> = getSiblingComponents(Anchor);
			
			for each (var anchor : Anchor in anchors)
			{
				if (anchor.id == _anchor)
				{
					return anchor;
				}
			}
			
			return null;
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			var c : Component = entity.getComponentByType(FlxObjectComponent);
			var foc : FlxObjectComponent = (FlxObjectComponent)(c);
			
			object = foc.object;
		}
		
		override public function loadContent(xml : XML):void
		{
			super.loadContent(xml);
			
			if (xmlElementExists(xml, "xOffset"))
			{
				_xoffset = parseFloat(xml.xOffset);
			}
			
			if (xmlElementExists(xml, "yOffset"))
			{
				_yoffset = parseFloat(xml.yOffset);
			}
			
			if (xmlElementExists(xml, "clickMessage"))
			{
				_clickMessage = xml.clickMessage;
			}
			
			if (xmlElementExists(xml, "releasedMessage"))
			{
				_releasedMessage = xml.releasedMessage;
			}
			
			if (xmlElementExists(xml, "anchor"))
			{
				_anchor = xml.anchor;
			}
		}
		
		override public function update():void
		{
			super.update();
			
			var a : Anchor = anchor;
			
			if (a != null)
			{
				a.moveObjectViaAnchor(FlxG.mouse.x, FlxG.mouse.y, object);
			} else {
				object.x = FlxG.mouse.x + _xoffset;
				object.y = FlxG.mouse.y + _yoffset;
			}
			
			if (FlxG.mouse.justPressed())
			{
				var m : Message = new Message();
				m.type = _clickMessage;
				m.sender = this;
				
				entity.sendMessage(m);
			}
			
			if (FlxG.mouse.justReleased())
			{
				m = new Message();
				m.type = _releasedMessage;
				m.sender = this;
				
				entity.sendMessage(m);
			}
		}
		
	}

}