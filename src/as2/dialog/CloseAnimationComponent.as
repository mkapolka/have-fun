package as2.dialog 
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
	public class CloseAnimationComponent extends Component 
	{
		public static const CLOSE_TRIGGER : String = "animated_close";
		public static const OPEN_TRIGGER : String = "animated_open";
		
		public static const LEFT : uint = 0;
		public static const UP : uint = 1;
		public static const RIGHT : uint = 2;
		public static const DOWN : uint = 3;
		
		public static const SPEED : Number = 6000;
		
		private var _startPoint : FlxPoint;
		private var _endPoint : FlxPoint;
		private var _direction : uint;
		private var _active : Boolean = false;
		private var _showing : Boolean = false;
		
		public function CloseAnimationComponent() 
		{
			super();
			
			addRequisiteComponent(FlxObjectComponent);
		}
		
		public function get flxObjectComponent():FlxObjectComponent
		{
			return getSiblingComponent(FlxObjectComponent) as FlxObjectComponent;
		}
		
		public function get flxObject():FlxObject
		{
			var foc : FlxObjectComponent = flxObjectComponent;
			
			return (foc==null)?null:foc.object;
		}
		
		override public function resolve():void
		{
			var flxo : FlxObject = flxObject;
			
			_startPoint = new FlxPoint(flxo.x, flxo.y);
			_endPoint = new FlxPoint();
			
			switch (_direction)
			{
				case LEFT:
					_endPoint.x = flxo.x - FlxG.width;
					_endPoint.y = flxo.y;
				break;
				
				case RIGHT:
					_endPoint.x = flxo.x + FlxG.width;
					_endPoint.y = flxo.y;
				break;
					
				case UP:
					_endPoint.x = flxo.x;
					_endPoint.y = flxo.y - FlxG.height;
				break;
				
				case DOWN:
					_endPoint.x = flxo.x;
					_endPoint.y = flxo.y + FlxG.height;
				break;
			}
			
			flxo.x = _endPoint.x;
			flxo.y = _endPoint.y;
		}
		
		private function sendMessage(m : String):void
		{
			var message : Message = new Message();
			message.sender = this;
			message.type = m;
			
			entity.sendMessage(message, false);
		}
		
		override public function update():void
		{
			super.update();
			
			if (_active)
			{
				var flxo : FlxObject = flxObject;
				if (_showing)
				{
					var dx : int = _startPoint.x - flxo.x;
					var dy : int = _startPoint.y - flxo.y;
					var d : Number = Math.atan2(dy, dx);
					
					flxo.x += Math.cos(d) * SPEED * FlxG.elapsed;
					flxo.y += Math.sin(d) * SPEED * FlxG.elapsed;
					
					if (Math.sqrt(dx * dx + dy * dy) < SPEED * FlxG.elapsed)
					{
						flxo.x = _startPoint.x;
						flxo.y = _startPoint.y;
						
						_active = false;
					}
				} else {
					dx = _endPoint.x - flxo.x;
					dy = _endPoint.y - flxo.y;
					d = Math.atan2(dy, dx);
					
					//flxo.x += Math.cos(d) * SPEED * FlxG.elapsed;
					//flxo.y += Math.sin(d) * SPEED * FlxG.elapsed;
					
					//hack
					
					flxo.x = _endPoint.x;
					flxo.y = _endPoint.y;
					
					if (Math.sqrt(dx * dx + dy * dy) < SPEED * FlxG.elapsed)
					{
						flxo.x = _endPoint.x;
						flxo.y = _endPoint.y;
						
						_active = false;
						sendMessage("disable");
						sendMessage("hide");
					}
				}
			}
		}
		
		override public function receiveMessage(message : Message):void
		{
			super.receiveMessage(message);
			
			if (message.type == OPEN_TRIGGER)
			{
				_active = true;
				_showing = true;
				
				sendMessage("enable");
				sendMessage("show");
				
				var flxo : FlxObject = flxObject;
				flxo.x = _endPoint.x;
				flxo.y = _endPoint.y;
			}
			
			if (message.type == CLOSE_TRIGGER)
			{
				_active = true;
				_showing = false;
			}
		}
		
		override public function loadContent(xml : XML):void
		{
			super.loadContent(xml);
			
			if (xmlElementExists(xml, "direction"))
			{
				var s : String = xml.direction;
				switch (s)
				{
					case "Left":
						_direction = LEFT;
					break;
					
					case "Right":
						_direction = RIGHT;
					break;
					
					case "Up":
						_direction = UP;
					break;
					
					case "Down":
						_direction = DOWN;
					break;
				}
			}
		}
		
	}

}