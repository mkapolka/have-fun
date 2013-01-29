package org.component.dialog 
{
	import org.component.Component;
	import org.component.Entity;
	import org.component.EntityManager;
	import org.component.Message;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class DialogManagerComponent extends Component 
	{
		
		protected var _partner : DialogPartner;
		
		public function DialogManagerComponent() 
		{
			super();
		}
		
		public function get partner():DialogPartner
		{
			return _partner;
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			/*var register_message : DialogMessage = new DialogMessage();
			register_message.sender = this;
			register_message.type = DialogMessage.REGISTER_MANAGER;
			entity.sendMessage(register_message);*/
		}
		
		public function query(query : String):void
		{
			var dr : DialogResponse = _partner.query(query);
			
			if (dr == null) return;
				
			var out_message : DialogMessage = new DialogMessage();
			out_message.sender = this;
			out_message.type = DialogMessage.SHOW_RESPONSE;
			out_message.response = dr;
			
			entity.sendMessage(out_message);
		}
		
		override public function receiveMessage(m : Message):void
		{
			if (m.type == DialogMessage.QUERY)
			{
				var dm : DialogMessage = (DialogMessage)(m);
				
				query(dm.message);
			}
			
			if (m.type == DialogMessage.OPEN_DIALOG)
			{
				dm = (DialogMessage)(m);
				
				_partner = dm.partner;
				query(dm.partner.defaultKeyword);
			}
		}
		
		override public function loadContent(xml : XML):void
		{
			super.loadContent(xml);
		}
		
	}

}