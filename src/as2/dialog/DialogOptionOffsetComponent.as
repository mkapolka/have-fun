package as2.dialog 
{
	import org.component.Component;
	import org.component.dialog.DialogManagerComponent;
	import org.component.dialog.DialogMessage;
	import org.component.dialog.DialogOptionComponent;
	import org.component.dialog.DialogResponse;
	import org.component.Entity;
	import org.component.flixel.FlxObjectComponent;
	import org.component.Message;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class DialogOptionOffsetComponent extends Component 
	{
		private var _offset : int = 0;
		private var _numOptions : int = 0;
		private var _currentResponse : DialogResponse;
		private var _trigger : String = "up";
		
		public function DialogOptionOffsetComponent() 
		{
			super();
		}
		
		public function get dialogManager():DialogManagerComponent
		{
			var parent : Entity = entity.parent;
			
			while (parent != null)
			{
				var dm : DialogManagerComponent = parent.getComponentByType(DialogManagerComponent) as DialogManagerComponent;
				
				if (dm != null) return dm;
				
				parent = parent.parent;
			}
			
			return null;
		}
		
		public function set offset(value : int):void
		{
			var diff : int = value - _offset;
			_offset = value;
			
			var dialogManager : DialogManagerComponent = dialogManager;
			updateOffsetsRecursive(dialogManager.entity, diff);
			
			setVisibilityAsAppropriate();
		}
		
		public function get offset():int
		{
			return _offset;
		}
		
		private function updateOffsetsRecursive(entity : Entity, diff : int):void
		{
			var option : DialogOptionComponent = entity.getComponentByType(DialogOptionComponent) as DialogOptionComponent;
			
			if (option != null)
			{
				//option.offset += diff;
				if (_currentResponse.options.length > option.offset + _offset)
				{
					option.setText(_currentResponse.options[option.offset + _offset]);
					option.setHidden(false);
				} else {
					option.setHidden(true);
				}
			}
			
			var optionOffset : DialogOptionOffsetComponent = entity.getComponentByType(DialogOptionOffsetComponent) as DialogOptionOffsetComponent;
			
			if (optionOffset != null && optionOffset != this)
			{
				//Notie : using direct reference here to bypass the updating- not really best practices
				optionOffset._offset += diff;
				optionOffset.setVisibilityAsAppropriate();
			}
			
			for each (var e : Entity in entity.children)
			{
				updateOffsetsRecursive(e, diff);
			}
		}
		
		private function setVisibilityAsAppropriate():void
		{
			var object : FlxObjectComponent = getSiblingComponent(FlxObjectComponent) as FlxObjectComponent;
			if (_numOptions > 0)
			{
				if (_currentResponse.options.length > _offset + _numOptions)
				{
					object.object.visible = true;
					object.object.active = true;
				} else {
					object.object.visible = false;
					object.object.active = false;
				}
			} else {
				if (_offset > 0)
				{
					object.object.visible = true;
					object.object.active = true;
				} else {
					object.object.visible = false;
					object.object.active = false;
				}
			}
		}
		
		override public function receiveMessage(message : Message):void
		{
			super.receiveMessage(message);
			
			switch (message.type)
			{
				case DialogMessage.SHOW_RESPONSE:
					_offset = 0;
					
					var dm : DialogMessage = message as DialogMessage;
					_currentResponse = dm.response;
					
					setVisibilityAsAppropriate();
				break;
				
				case _trigger:
					offset += _numOptions;
				break;
			}
		}
		
		override public function loadContent(xml : XML):void
		{
			super.loadContent(xml);
			
			if (xmlElementExists(xml, "trigger"))
			{
				_trigger = xml.trigger;
			}
			
			if (xmlElementExists(xml, "numOptions"))
			{
				_numOptions = parseInt(xml.numOptions);
			}
		}
		
	}

}