package org.component.etc 
{
	import org.component.Component;
	import org.component.Entity;
	import org.component.EntityManager;
	import org.component.Message;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class RelayComponent extends Component 
	{
		
		private var _target : Entity;
		private var _relays : Array = new Array;
		
		public function RelayComponent() 
		{
			super();
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			if (_target == null)
			{
				trace("ERROR: Relay Component in Entity " + entity.name + " could not find  its target.");
				enabled = false;
			}
		}
		
		override public function receiveMessage(message : Message):void
		{
			super.receiveMessage(message);
			
			for (var index : String in _relays)
			{
				if (message.type == index && message.sender != this)
				{
					var outMessage : Message = new Message();
					outMessage.sender = this;
					outMessage.type = _relays[index];
					_target.sendMessage(outMessage);
				}
			}
		}
		
		override public function loadContent(xml : XML):void
		{
			super.loadContent(xml);
			
			if (xmlElementExists(xml, "target"))
			{
				var t : Component = EntityManager.getComponentByUID(parseInt(xml.target));
				_target = t.entity;
			}
			
			if (xmlElementExists(xml, "relays"))
			{
				var a : Array = extractArray(xml.relays);
				
				for each (var s : String in a)
				{
					var relay : Array = s.split(" ");
					_relays[relay[0]] = relay[1]
				}
			}
		}
		
		
		
	}

}