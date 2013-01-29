package as2.etc 
{
	import org.component.Component;
	import org.component.flixel.FlxObjectComponent;
	import org.component.Message;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class BounceComponent extends Component 
	{
		public static const START_BOUNCING : String = "start_bouncing";
		public static const STOP_BOUNCING : String = "stop_bouncing";
		
		private var _distance : Number = 0;
		private var _speed : Number = 1;
		private var _t : Number = 0;
		private var _startY : Number = 0;
		
		private var _bouncing : Boolean = true;
		
		public function BounceComponent() 
		{
			super();
			
			addRequisiteComponent(FlxObjectComponent);
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			_startY = object.y;
		}
		
		private function get object():FlxObject
		{
			var c : FlxObjectComponent = objectComponent;
			
			if (c != null)
			{
				return c.object;
			} else {
				return null;
			}
		}
		
		private function get objectComponent():FlxObjectComponent
		{
			return (FlxObjectComponent)(getSiblingComponent(FlxObjectComponent));
		}
		
		public function get distance():Number 
		{
			return _distance;
		}
		
		public function set distance(value:Number):void 
		{
			_distance = value;
		}
		
		public function get speed():Number 
		{
			return _speed;
		}
		
		public function set speed(value:Number):void 
		{
			_speed = value;
		}
		
		public function get offset():Number 
		{
			return _t;
		}
		
		public function set offset(value:Number):void 
		{
			_t = value;
		}
		
		override public function receiveMessage(message : Message):void
		{
			super.receiveMessage(message);
			
			if (message.type == START_BOUNCING)
			{
				_bouncing = true;
			}
			
			if (message.type == STOP_BOUNCING)
			{
				_bouncing = false;
			}
		}
		
		override public function update():void
		{
			super.update();
			
			var o : FlxObject = object;
			
			if (o != null)
			{
				if (_bouncing)
				{
					_t += FlxG.elapsed * Math.PI * _speed;
					
					if (_t > Math.PI * 2)
					{
						_t -= Math.PI * 2;
					}
					
					object.y = _startY - Math.abs(Math.sin(_t) * _distance);
				} else {
					object.y = _startY;
				}
			}
		}
		
		override public function loadContent(xml : XML):void
		{
			super.loadContent(xml);
			
			if (xmlElementExists(xml, "distance"))
			{
				_distance = parseFloat(xml.distance);
			}
			
			if (xmlElementExists(xml, "speed"))
			{
				_speed = parseFloat(xml.speed);
			}
			
			if (xmlElementExists(xml, "offset"))
			{
				_t += parseFloat(xml.offset) * Math.PI;
			}
		}
		
	}

}