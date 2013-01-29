package as2 
{
	import org.component.Component;
	import org.component.flixel.FlxObjectComponent;
	import org.component.Message;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class ButtonComponent extends Component 
	{
		public static const OVER_MESSAGE : String = "over";
		public static const OUT_MESSAGE : String = "out";
		public static const DOWN_MESSAGE : String = "down";
		public static const UP_MESSAGE : String = "up";
		public static const ENABLED_MESSAGE : String = "enabled";
		public static const DISABLED_MESSAGE : String = "disabled";
		
		protected var _overMessage : String;
		protected var _outMessage : String;
		protected var _downMessage : String;
		protected var _upMessage : String;
		protected var _enabledMessage : String;
		protected var _disabledMessage : String;
		
		protected var _object : FlxObject;
		protected var _objectComponent : FlxObjectComponent;
		
		protected var _over : Boolean = false;
		protected var _down : Boolean = false;
		protected var _objectEnabled : Boolean;
		
		public function ButtonComponent() 
		{
			super();
			
			addRequisiteComponent(FlxObjectComponent);
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			_objectComponent = (FlxObjectComponent)(getSiblingComponent(FlxObjectComponent));
			_object = _objectComponent.object;
			_objectEnabled = _object.active;
		}
		
		protected function sendMessage(type : String):void
		{
			var m : Message = new Message();
			m.sender = this;
			m.type = type;
			
			entity.sendMessage(m);
		}
		
		override public function update():void
		{
			super.update();
			
			if (_objectEnabled && !_object.active)
			{
				sendMessage(DISABLED_MESSAGE);
				_objectEnabled = false;
			}
			
			if (!_objectEnabled && _object.active)
			{
				sendMessage(ENABLED_MESSAGE);
				_objectEnabled = true;
			}
			
			//Check overlapping, clicking logics
			if (_object.active)
			{
				var mp : FlxPoint = new FlxPoint(FlxG.mouse.x, FlxG.mouse.y);
				if (!_over)
				{
					if (_object.overlapsPoint(mp, true))
					{
						_over = true;
						sendMessage(_overMessage);
					}
				} else {
					if (!_object.overlapsPoint(mp, true))
					{
						_over = false;
						sendMessage(_outMessage);
					}
				}
				
				if (_over)
				{
					if (FlxG.mouse.justPressed())
					{
						sendMessage(_downMessage);
						_down = true;
					}
					
					if (_down && FlxG.mouse.justReleased())
					{
						sendMessage(_upMessage);
					}
				}
			} else { // overlapping, clicking logics
				if (_over)
				{
					sendMessage(_outMessage);
				}
				_over = false;
				_down = false;
			}
			
			if (FlxG.mouse.justReleased()) _down = false;
		}
		
		override public function loadContent(xml : XML):void
		{
			super.loadContent(xml);
			
			if (xmlElementExists(xml, "overMessage"))
			{
				_overMessage = xml.overMessage;
			} else {
				_overMessage = OVER_MESSAGE;
			}
			
			if (xmlElementExists(xml, "outMessage"))
			{
				_outMessage = xml.outMessage;
			} else {
				_outMessage = OUT_MESSAGE;
			}
			
			if (xmlElementExists(xml, "downMessage"))
			{
				_downMessage = xml.downMessage;
			} else {
				_downMessage = DOWN_MESSAGE;
			}
			
			if (xmlElementExists(xml, "upMessage"))
			{
				_upMessage = xml.upMessage;
			} else {
				_upMessage = UP_MESSAGE;
			}
			
			if (xmlElementExists(xml, "enabledMessage"))
			{
				_enabledMessage = xml.enabledMessage;
			} else {
				_enabledMessage = ENABLED_MESSAGE;
			}
			
			if (xmlElementExists(xml, "disabledMessage"))
			{
				_disabledMessage = xml.disabledMessage;
			} else {
				_disabledMessage = DISABLED_MESSAGE;
			}
		}
		
	}

}