package org.component.etc 
{
	import org.component.Component;
	import org.component.Message;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class TimerComponent extends Component 
	{
		public static const DEFAULT_DELAY : Number = 1;
		public static const DEFAULT_REPEAT : Boolean = false;
		
		private var _delay : Number = DEFAULT_DELAY;
		private var _timer : Number = 0;
		private var _message : String = "";
		private var _repeat : Boolean = DEFAULT_REPEAT;
		
		public function TimerComponent() 
		{
			super();
		}
		
		override public function update():void
		{
			super.update();
			
			_timer -= FlxG.elapsed;
			
			if (_timer <= 0)
			{
				_timer = _delay;
				
				var outMessage : Message = new Message();
				outMessage.type = _message;
				outMessage.sender = this;
				entity.sendMessage(outMessage);
			}
		}
		
		override public function loadContent(xml : XML):void
		{
			super.loadContent(xml);
			
			if (xmlElementExists(xml, "delay"))
			{
				_delay = parseFloat(xml.delay);
				_timer = _delay;
			}
			
			if (xmlElementExists(xml, "message"))
			{
				_message = xml.message;
			}
			
			if (xmlElementExists(xml, "repeat"))
			{
				_repeat = extractXMLBoolean(xml.repeat);
			}
		}
		
	}

}