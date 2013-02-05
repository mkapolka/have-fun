package as2.character 
{
	import as2.etc.RoomEntranceComponent;
	import as2.RoomManager;
	import flash.geom.Point;
	import org.component.Component;
	import org.component.flixel.Anchor;
	import org.component.flixel.FlxObjectComponent;
	import org.component.Message;
	import org.flixel.FlxObject;
	
	/**
	 * PlayerControllerComponent establishes a queue of actions to be completed by the entity.
	 * Each action is represented by a PlayerControllerAction, which has 4 properties: 
	 * fireMessgae, messageTarget, waitMessage, and cancelMessage. "fireMessage" is the type of 
	 * message to be sent to the entity when this action is dequeued. "messageTarget" is the entity
	 * that should receive the message. "waitMessage" is the message that this component will wait for
	 * in order to trigger the next action in the queue. "cancelMessage" is the message that is sent if this 
	 * action is canceled before it has a chance to complete. A PlayerControllerAction can be sent to the 
	 * PlayerControllerComponent via a PlayerControllerMessage.
	 * 
	 * @author Marek Kapolka
	 */
	public class PlayerControllerComponent extends Component 
	{		
		private var _busy : Boolean = false;
		private var _currentAction : PlayerControllerAction;
		
		private var _actionQueue : Vector.<PlayerControllerAction> = new Vector.<PlayerControllerAction>();
		
		public function PlayerControllerComponent() 
		{
			super();
			
			addRequisiteComponent(CharacterNavigationComponent);
		}
		
		override public function resolve():void
		{
			super.resolve();
			
			//Move the player to the appropriate entrance in the room when a room is loaded.
			if (RoomManager.entranceName != null)
			{
				var entrance : RoomEntranceComponent = RoomEntranceComponent.getEntrance(RoomManager.entranceName);
				if (entrance == null) return;
				
				var entranceObject : FlxObject = entrance.flxObject;
				if (entranceObject == null) return;
				
				var anchors : Vector.<Component> = getSiblingComponents(Anchor);
				var flxoc : FlxObjectComponent = getSiblingComponent(FlxObjectComponent) as FlxObjectComponent;
				var flxo : FlxObject = flxoc.object;
				
				for each (var a : Anchor in anchors)
				{
					if (a.id == "base")
					{
						a.moveObjectViaAnchor(entranceObject.x, entranceObject.y, flxo);
						break;
					}
				}
			}
		}
		
		private function get characterNavigationComponent():CharacterNavigationComponent
		{
			var cnm : CharacterNavigationComponent = (CharacterNavigationComponent)(getSiblingComponent(CharacterNavigationComponent));
			
			return cnm;
		}
		
		override public function receiveMessage(message : Message):void
		{			
			if (message is PlayerControllerMessage)
			{
				if (message.type == PlayerControllerMessage.QUEUE_ACTION)
				{
					var pcm : PlayerControllerMessage = (PlayerControllerMessage)(message);
					
					var action : PlayerControllerAction = new PlayerControllerAction();
					action.fireMessage = pcm.fireMessage;
					action.messageTarget = pcm.messageTarget;
					action.waitForMessage = pcm.waitForMessage;
					action.cancelMessage = pcm.cancelMessage;
					
					pushAction(action);
				}
			}
			
			if (_busy && message.type == PlayerControllerMessage.CLEAR_QUEUE)
			{
				_currentAction.messageTarget.sendMessage(_currentAction.cancelMessage);
				_actionQueue.splice(0, _actionQueue.length);
				_busy = false;
				_currentAction = null;
			}
			
			if (_busy)
			{
				if (message.type == _currentAction.waitForMessage)
				{
					_busy = false;
					_currentAction = null;
					popAction();
				}
			}
		}
		
		private function pushAction(action : PlayerControllerAction):void
		{
			if (!_busy)
			{
				startAction(action);
			} else {
				_actionQueue.push(action);
			}
		}
		
		private function startAction(action : PlayerControllerAction):void
		{
			action.messageTarget.sendMessage(action.fireMessage);
			
			if (action.waitForMessage != null)
			{
				_busy = true;
				_currentAction = action;
			} else {
				popAction();
			}
		}
		
		private function popAction():void
		{
			if (_actionQueue.length > 0)
			{
				var action : PlayerControllerAction = _actionQueue[0];
				_actionQueue.splice(0, 1);
				startAction(action);
			}
		}
		
	}
}
import org.component.Entity;
import org.component.Message;

class PlayerControllerAction
{
	public var fireMessage : Message;
	public var messageTarget : Entity;
	public var waitForMessage : String;
	public var cancelMessage : Message;
	
	public function PlayerControllerAction()
	{
		
	}
}