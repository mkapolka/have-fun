package org.component.flixel.movement 
{
	import org.component.flixel.FlxSpriteComponent;
	import org.component.Message;
	import org.flixel.FlxObject;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	import org.component.Component;
	import org.component.flixel.FlxObjectComponent;
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class PlayerWalkingComponent extends Component 
	{
		protected var _target : FlxObject = null;
		
		protected var _upKey : String = "UP";
		protected var _downKey : String = "DOWN";
		protected var _leftKey : String = "LEFT";
		protected var _rightKey : String = "RIGHT";
		
		protected var _speed : Number = 0;
		
		public function PlayerWalkingComponent() 
		{
			super();
			
			addRequisiteComponent(FlxObjectComponent);
		}
		
		override public function destroy():void
		{
			_target = null;
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			var component : Component = entity.getComponentByType(FlxObjectComponent);
			var foc : FlxObjectComponent = (FlxObjectComponent)(component);
			_target = foc.object;
		}
		
		override public function update():void
		{
			super.update();
			
			if (_target == null) return;
			
			var m : Message = new Message();
			m.sender = this;
			
			var pressed : Boolean = false;
			
			var sprite : FlxSprite = null;
			
			if (_target is FlxSprite)
			{
				sprite = (FlxSprite)(_target);
			}
			
			if (FlxG.keys.pressed(_upKey))
			{
				_target.velocity.y = -_speed;
				
				if (sprite != null) sprite.facing = FlxObject.UP;
				
				m.type = "up";
				entity.sendMessage(m);
				pressed = true;
			}
			
			if (FlxG.keys.pressed(_downKey))
			{
				_target.velocity.y = _speed;
				
				if (sprite != null) sprite.facing = FlxObject.DOWN;
				
				m.type = "down";
				entity.sendMessage(m);
				pressed = true;
			}
			
			if (FlxG.keys.pressed(_leftKey))
			{
				_target.velocity.x = -_speed;
				
				if (sprite != null) sprite.facing = FlxObject.LEFT;
				
				m.type = "left";
				entity.sendMessage(m);
				pressed = true;
			}
			
			if (FlxG.keys.pressed(_rightKey))
			{
				_target.velocity.x = _speed;
				
				if (sprite != null) sprite.facing = FlxObject.RIGHT;
				
				m.type = "right";
				entity.sendMessage(m);
				pressed = true;
			}
			
			if (!pressed)
			{
				m.type = "none";
				entity.sendMessage(m);
			}
		}
		
		override public function loadContent(x : XML):void
		{
			super.loadContent(x);
			
			if (xmlElementExists(x, "upKey"))
			{
				_upKey = x.upKey;
			}
			
			if (xmlElementExists(x, "downKey"))
			{
				_downKey = x.downKey;
			}
			
			if (xmlElementExists(x, "leftKey"))
			{
				_leftKey = x.leftKey;
			}
			
			if (xmlElementExists(x, "rightKey"))
			{
				_rightKey = x.rightKey;
			}
			
			if (xmlElementExists(x, "speed"))
			{
				_speed = parseFloat(x.speed);
			}
		}
		
	}

}