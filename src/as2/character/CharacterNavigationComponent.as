package as2.character 
{
	import flash.geom.Point;
	import org.component.Component;
	import org.component.flixel.Anchor;
	import org.component.flixel.FlxObjectComponent;
	import org.component.Message;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	/**
	 * Handles moving characters around. Send this component CharacterNavigationMessages to
	 * tell it where to go. CharacterNavigationComponent responds to two types of CharacterNavigationMessage:
	 * CharacterNavigationMessage.SET_TARGET and CharacterNavigationMessage.CANCEL_TARGET. The first message
	 * tells this component where the character should be moved to, the second tells it to stop moving
	 * towards that target.
	 * @author Marek Kapolka
	 */
	public class CharacterNavigationComponent extends Component 
	{
		//Speed measured in flixel's speed units (pixels / second I believe?)
		private var _speed : Point = new Point();
		private var _target : Point = new Point();
		private var _anchor : String = null;
		private var _graceDistance : Number = 0;
		
		private var _walkingMessage : String = "walk";
		private var _stoppedMessage : String = "stop";
		
		private var _object : FlxObjectComponent;
		
		private var _isWalking : Boolean = false;
		
		public function CharacterNavigationComponent() 
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
			
			if (foc != null)
			{
				return foc.object;
			} else {
				return null;
			}
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			_object = (FlxObjectComponent)(getSiblingComponent(FlxObjectComponent));
		}
		
		public function get anchor():Anchor
		{
			var anchors : Vector.<Component> = getSiblingComponents(Anchor);
			
			for each (var a : Anchor in anchors)
			{
				if (a.id == _anchor)
				{
					return a;
				}
			}
			
			return null;
		}
		
		public function get walkingMessage():String
		{
			return _walkingMessage;
		}
		
		public function get stoppedMessage():String
		{
			return _stoppedMessage;
		}
		
		public function set walkingMessage(s : String):void
		{
			_walkingMessage = s;
		}
		
		public function set stoppedMessage(s : String):void
		{
			_stoppedMessage = s;
		}
		
		private function getObjectPosition():Point
		{
			var p : Point = new Point();
			
			var a : Anchor = anchor;
			
			if (a != null)
			{
				var xp : FlxPoint = a.getWorldPoint(_object.object);
				p.x = xp.x;
				p.y = xp.y;
			} else {
				p.x = _object.object.x;
				p.y = _object.object.y;
			}
			
			return p;
		}
		
		private function isAtTarget():Boolean
		{
			var p : Point = getObjectPosition();
			
			var dx : Number = _target.x - p.x;
			var dy : Number = _target.y - p.y;
			
			var d : Number = Math.sqrt(dx * dx + dy * dy);
			
			if (d < _graceDistance)
			{
				return true;
			} else {
				return false;
			}
		}
		
		override public function receiveMessage(message : Message):void
		{
			super.receiveMessage(message);
			
			if (message is CharacterNavigationMessage)
			{
				var cnm : CharacterNavigationMessage = (CharacterNavigationMessage)(message);
				
				if (cnm.type == CharacterNavigationMessage.SET_TARGET)
				{
					setTarget((Point)(cnm.data));
				}
			}
			
			if (message.type == CharacterNavigationMessage.CANCEL_TARGET)
			{
				setTarget(null);
			}
		}
		
		public function setTarget(point : Point):void
		{
			if (point != null)
			{
				_target = point;
				_isWalking = true;
				sendEntityMessage(_walkingMessage);
			} else {
				_isWalking = false;
			}
		}
		
		override public function update():void
		{
			super.update();
			
			if (_isWalking)
			{
				if (!isAtTarget())
				{
					var p : Point = getObjectPosition();
					
					var dx : Number = _target.x - p.x;
					var dy : Number = _target.y - p.y;
					var d : Number = Math.sqrt(dx * dx + dy * dy);
					
					_object.object.velocity.x = (dx / d) * _speed.x;
					_object.object.velocity.y = (dy / d) * _speed.y;
					
					if (_object.object is FlxSprite)
					{
						var fs : FlxSprite = (FlxSprite)(_object.object);
						
						if (dx < 0)
						{
							fs.facing = FlxObject.LEFT;
						} else {
							fs.facing = FlxObject.RIGHT;
						}
					}
				} else {
					_object.object.velocity.x = 0;
					_object.object.velocity.y = 0;
					
					_isWalking = false;
					
					sendEntityMessage(_stoppedMessage);
				}
			}
		}
		
		private function sendEntityMessage(value : String):void
		{
			var message : Message = new Message();
			message.sender = this;
			message.type = value;
			
			entity.sendMessage(message);
		}
		
		override public function loadContent(xml : XML):void
		{
			super.loadContent(xml);
			
			if (xmlElementExists(xml, "graceDistance"))
			{
				_graceDistance = parseFloat(xml.graceDistance);
			}
			
			if (xmlElementExists(xml, "speed_x"))
			{
				_speed.x = parseFloat(xml.speed_x);
			}
			
			if (xmlElementExists(xml, "speed_y"))
			{
				_speed.y = parseFloat(xml.speed_y);
			}
			
			if (xmlElementExists(xml, "target_x"))
			{
				_target.x = parseFloat(xml.target_x);
			}
			
			if (xmlElementExists(xml, "target_y"))
			{
				_target.y = parseFloat(xml.target_y);
			}
			
			if (xmlElementExists(xml, "anchor"))
			{
				_anchor = xml.anchor;
			}
			
			if (xmlElementExists(xml, "walkingMessage"))
			{
				_walkingMessage = xml.walkingMessage;
			}
			
			if (xmlElementExists(xml, "stoppedMessage"))
			{
				_stoppedMessage = xml.stoppedMessage;
			}
			
			if (xmlElementExists(xml, "startWalking"))
			{
				_isWalking = extractXMLBoolean(xml.startWalking);
			}
		}
		
		
		
	}

}