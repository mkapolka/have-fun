package org.component.dialog 
{
	import org.component.Component;
	import org.component.Entity;
	import org.component.flixel.FlxObjectComponent;
	import org.component.flixel.FlxTextComponent;
	import org.component.Message;
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class DialogOptionComponent extends Component 
	{
		
		protected var _offset : uint = 0;
		protected var _trigger : String;
		protected var _manager : DialogManagerComponent;
		protected var _queryText : String;
		
		public function DialogOptionComponent() 
		{
			super();
			
			addRequisiteComponent(FlxTextComponent);
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			_manager = rec_findDialogManager(entity);
			
			if (_manager == null)
			{
				enabled = false;
			}
		}
		
		private function rec_findDialogManager(entity : Entity):DialogManagerComponent
		{
			if (entity == null) return null;
			
			var output : DialogManagerComponent = (DialogManagerComponent)(entity.getComponentByType(DialogManagerComponent));
			if (output != null)
			{
				return output;
			} else {
				return rec_findDialogManager(entity.parent);
			}
		}
		
		public function get text():FlxText
		{
			var c : Component = getSiblingComponent(FlxTextComponent);
			
			if (c != null)
			{
				var ftc : FlxTextComponent = (FlxTextComponent)(c);
				
				return ftc.text;
			}
			
			return null;
		}
		
		public function get textComponent():FlxTextComponent
		{
			var c : Component = getSiblingComponent(FlxTextComponent);
			
			if (c != null)
			{
				return (FlxTextComponent)(c);
			} else {
				return null;
			}
		}
		
		public function get offset():uint
		{
			return _offset;
		}
		
		public function set offset(n : uint):void
		{
			_offset = n;
		}
		
		public function get queryText():String
		{
			return _queryText;
		}
		
		public function set queryText(s : String):void
		{
			_queryText = s;
		}
		
		public function setText(s : String):void
		{
			//Split reply into two parts
			var a : Array = s.split("|");
			
			var optionText : String;
			var queryText : String;
			
			if (a.length == 1)
			{
				optionText = s;
				queryText = s;
			} else 		
			if (a.length == 2)
			{
				optionText = a[0];
				queryText = a[1];
			} else 
			{
				trace("PROBLEM: Dialog option had more than two segments. Text: " + s);
				optionText = s;
				queryText = s;
			}
			
			var uc : String = optionText.toUpperCase();
			optionText = uc.charAt(0) + optionText.substr(1, optionText.length);
			
			setOptionText(optionText);
			setQueryText(queryText);			
		}
		
		public function setOptionText(s : String):void
		{
			textComponent.setText(s);
		}
		
		public function setQueryText(s : String):void
		{
			_queryText = s;
		}
		
		public function setHidden(hidden : Boolean):void
		{
			if (hidden)
			{
				//Hide & Disable object
				outMessage = new Message();
				outMessage.sender = this;
				
				outMessage.type = FlxObjectComponent.DISABLE;
				entity.sendMessage(outMessage);
				outMessage.type = FlxObjectComponent.HIDE;
				entity.sendMessage(outMessage);
			} else {
				//Show & Enable object
				var outMessage : Message = new Message();
				outMessage.sender = this;
				outMessage.type = FlxObjectComponent.ENABLE;
				entity.sendMessage(outMessage);
				outMessage.type = FlxObjectComponent.SHOW;
				entity.sendMessage(outMessage);
			}
		}
		
		override public function receiveMessage(m : Message):void
		{
			super.receiveMessage(m);
			
			if (m.type == _trigger)
			{
				var message : DialogMessage = new DialogMessage();
				message.type = DialogMessage.QUERY;
				message.sender = this;
				//message.message = text.text;
				message.message = queryText;
				
				_manager.entity.sendMessage(message);
			}
			
			if (m.type == DialogMessage.SHOW_RESPONSE)
			{
				var dm : DialogMessage = (DialogMessage)(m);
				
				if (dm.response.options.length > offset)
				{
					setText(dm.response.options[offset]);
					text.active = true;
					
					setHidden(false);
				} else {
					textComponent.setText("");
					text.active = false;
					
					setHidden(true);
				}
			}
		}
		
		override public function loadContent(xml : XML):void
		{
			super.loadContent(xml);
			
			if (xmlElementExists(xml, "offset"))
			{
				_offset = parseInt(xml.offset);
			}
			
			if (xmlElementExists(xml, "trigger"))
			{
				_trigger = xml.trigger;
			}
		}
		
	}

}