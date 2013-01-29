package as2 
{
	import org.component.Entity;
	import org.component.flixel.FlxObjectComponent;
	import org.component.Message;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class MouseManager 
	{
		public static const DOWN_MESSAGE : String = "down";
		public static const UP_MESSAGE : String = "up";
		public static const OVER_MESSAGE : String = "over";
		public static const OUT_MESSAGE : String = "out";
		
		private var _requireVisible : Boolean = true;
		private var _requireActive : Boolean = true;
		
		private var _overs : Vector.<FlxObjectComponent> = new Vector.<FlxObjectComponent>();
		private var _down : FlxObjectComponent;
		
		private var _highestOver : FlxObjectComponent = null;
		private var _highest_d : Number = -Infinity;
		
		private var _listeners : Vector.<Entity> = new Vector.<Entity>();
		
		public function MouseManager() 
		{
			
		}
		
		public function get requireVisible():Boolean
		{
			return _requireVisible;
		}
		
		public function get requireActive():Boolean
		{
			return _requireActive;
		}
		
		public function set requireVisible(b : Boolean):void
		{
			_requireVisible = b;
		}
		
		public function set requireActive(b : Boolean):void
		{
			_requireActive = b;
		}
		
		public function addListener(entity : Entity):void
		{
			if (_listeners.indexOf(entity) == -1)
			{
				_listeners.push(entity);
			}
		}
		
		public function removeListener(entity : Entity):void
		{
			var i : int = _listeners.indexOf(entity);
			
			if (i != -1)
			{
				_listeners.splice(i, 1);
			}
		}
		
		public function get listeners():Vector.<Entity>
		{
			return _listeners;
		}
		
		public function shouldSendOverMessage(objectComponent : FlxObjectComponent):Boolean
		{
			return true;
		}
		
		public function shouldSendOutMessage(objectComponent : FlxObjectComponent):Boolean
		{
			return true;
		}
		
		public function shouldSendDownMessage(objectComponent : FlxObjectComponent):Boolean
		{
			return true;
		}
		
		public function shouldSendUpMessage(objectComponent : FlxObjectComponent):Boolean
		{
			return true;
		}
		
		protected function sendMessage(message : String, entity : Entity):void
		{
			var outMessage : Message = new Message();
			outMessage.sender = null;
			outMessage.type = message;
			
			entity.sendMessage(outMessage);
		}
		
		protected function sendDownMessage(entity : Entity):void
		{
			sendMessage(DOWN_MESSAGE, entity);
		}
		
		protected function sendUpMessage(entity : Entity):void
		{
			sendMessage(UP_MESSAGE, entity);
		}
		
		protected function sendOverMessage(entity : Entity):void
		{
			sendMessage(OVER_MESSAGE, entity);
		}
		
		protected function sendOutMessage(entity : Entity):void
		{
			sendMessage(OUT_MESSAGE, entity);
		}
		
		public function update():void
		{
			var mousePoint : FlxPoint = new FlxPoint(FlxG.mouse.x, FlxG.mouse.y);
			
			for each (var objectComponent : FlxObjectComponent in FlxObjectComponent.objectComponents)
			{
				var object : FlxObject = objectComponent.object;
				
				if ((!requireVisible || object.visible) && (!requireActive || object.active))
				{
					if (object.overlapsPoint(mousePoint, true))
					{
						addToOverList(objectComponent);
					} else {
						removeFromOverList(objectComponent);
					}
				} else {
					removeFromOverList(objectComponent);
				}
			} // For each objectcomponent
			
			
			//Figure out which of these objects is the highest one, so that you only click on one at a time
			for each (var oc : FlxObjectComponent in _overs)
			{
				if (oc.depth > _highest_d)
				{
					_highest_d = oc.depth;
					_highestOver = oc;
				}
			}
			
			//Mouse down
			if (_highestOver != null && FlxG.mouse.justPressed())
			{
				if (shouldSendDownMessage(_highestOver))
				{
					sendDownMessage(_highestOver.entity);
				}
				
				_down = _highestOver;
			}
			
			//Mouse up
			if (_highestOver == _down && FlxG.mouse.justReleased())
			{
				if (shouldSendUpMessage(_highestOver))
				{
					sendUpMessage(_highestOver.entity);
				}
				
				_down = null;
			}
		}
		
		private function addToOverList(objectComponent : FlxObjectComponent):void
		{
			if (_overs.indexOf(objectComponent) == -1)
			{				
				//if (shouldSendOverMessage(objectComponent))
				//{
					sendOverMessage(objectComponent.entity);
				//}
				
				_overs.push(objectComponent);
			}
		}
		
		private function removeFromOverList(objectComponent : FlxObjectComponent):void
		{
			if (_overs.indexOf(objectComponent) != -1)
			{
				_overs.splice(_overs.indexOf(objectComponent), 1);
				
				//if (shouldSendOutMessage(objectComponent))
				//{
					sendOutMessage(objectComponent.entity);
				//}
				
				if (_highestOver == objectComponent)
				{
					_highestOver = null;
					_highest_d = -Infinity;
				}
				
				if (_down == objectComponent)
				{
					_down = null;
				}
			}
		}
		
	}

}