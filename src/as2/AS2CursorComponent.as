package as2 
{
	import flash.geom.Point;
	import org.component.Component;
	import org.component.Entity;
	import org.component.flixel.collision.CollisionComponent;
	import org.component.flixel.collision.CollisionManager;
	import org.component.flixel.FlxObjectComponent;
	import org.component.flixel.FlxSpriteComponent;
	import org.component.flixel.FlxTextComponent;
	import org.component.Message;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import as2.character.PlayerControllerMessage;
	import as2.character.CharacterNavigationMessage;
	import as2.character.CharacterNavigationComponent;
	
	/**
	 * Controls the mouse-driven interactions with the player. Its chief responsibility is to see if
	 * it's hovering over an interactable object, update the mouse over text, and send instructions
	 * to the player entity to interact with that object if the user clicks on it.
	 * @author Marek Kapolka
	 */
	public class AS2CursorComponent extends Component 
	{
		//States- used to ignore certain objects
		//when in different situations.
		
		//MODE_GAME is for when the player is moving around the screen
		public static const MODE_GAME : uint = 0;
		//MODE_DIALOG is for when the player is talking to an NPC
		public static const MODE_DIALOG : uint = 1;
		//MODE_SMARTPHONE is for when the player is in a dialog with the smartphone.
		public static const MODE_SMARTPHONE : uint = 2;
		//MODE_TRANSITION is used when RoomManager is transitioning between two rooms
		public static const MODE_TRANSITION : uint = 3;
		
		protected var _mode : uint = 0;
		
		public function AS2CursorComponent() 
		{
			super();
			
			addRequisiteComponent(FlxTextComponent);
		}
		
		public function get textComponent():FlxTextComponent
		{
			var c : Component = getSiblingComponent(FlxTextComponent);
			
			if (c != null)
			{
				var fc : FlxTextComponent = (FlxTextComponent)(c);
				
				return fc;
			} else {
				return null;
			}
		}
		
		public function get mode():uint
		{
			return _mode;
		}
		
		public function set mode(m : uint ):void
		{
			_mode = m;
			
			showMouseOverText(null);
		}
		
		public function get playerEntity():Entity
		{
			return TaggedObjectComponent.getObjectByTag(Assignment2State.PLAYER_TAG);
		}
		
		private function sendSelfMessage(type : String):void
		{
			var message : Message = new Message();
			message.sender = this;
			message.type = type;
			
			entity.sendMessage(message);
		}
		
		/**
		 * Sets the mouse over text to the given string. If null or an empty string is passed, it will hide the 
		 * mouse over text.
		 * @param	s The mouse over text to be displayed.
		 */
		private function showMouseOverText(s : String):void
		{
			if (s != null && s != "")
			{
				textComponent.text.text = s;
				sendSelfMessage(FlxObjectComponent.SHOW);
			} else {
				sendSelfMessage(FlxObjectComponent.HIDE);
			}
		}
		
		override public function update():void
		{
			super.update();
			
			//Player is moving around, not in a conversation
			if (mode == MODE_GAME)
			{
				//Find the components closest to the cursor with the appropriate type
				
				var objects : Vector.<FlxObjectComponent> = FlxObjectComponent.getObjectsAt(FlxG.mouse.x, FlxG.mouse.y, true);
				var nearest : Entity = null;
				var nearest_d : Number = -Infinity;
				var nearest_type : String = "";
				
				for each (var component : FlxObjectComponent in objects)
				{
				if (component.object.active == true && component.object.visible == true && (
					component.getSiblingComponent(ActableComponent) != null ||
					component.getSiblingComponent(WalkableAreaComponent) != null || 
					component.getSiblingComponent(ButtonComponent) != null))
					{						
						var d : Number = component.depth;
						
						if (d > nearest_d)
						{
							nearest_d = d;
							nearest = component.entity;
							
							if (component.getSiblingComponent(ActableComponent) != null)
							{
								nearest_type = "actable";
							} else if (component.getSiblingComponent(WalkableAreaComponent) != null)
							{
								nearest_type = "walkable";
							} else {
								nearest_type = "button";
							}
						}
					}
				}
				
				if (nearest != null)
				{
					if (nearest_type == "actable")
					{
						var actableComponent : ActableComponent = (ActableComponent)(nearest.getComponentByType(ActableComponent));
						
						showMouseOverText(actableComponent.mouseOverName);
						
						if (FlxG.mouse.justPressed())
						{
							var clearMessage : Message = new Message();
							clearMessage.sender = this;
							clearMessage.type = PlayerControllerMessage.CLEAR_QUEUE;
							playerEntity.sendMessage(clearMessage);
							
							if (actableComponent.walkTo)
							{
								var walkMessage : PlayerControllerMessage = new PlayerControllerMessage();
								walkMessage.type = PlayerControllerMessage.QUEUE_ACTION;
								
								var walkToMessage : CharacterNavigationMessage = new CharacterNavigationMessage();
								walkToMessage.sender = this;
								walkToMessage.type = CharacterNavigationMessage.SET_TARGET;
								walkToMessage.data = actableComponent.getActionPoint();
								
								var walkCancelMessage : Message = new Message();
								walkCancelMessage.sender = this;
								walkCancelMessage.type = CharacterNavigationMessage.CANCEL_TARGET;
								
								walkMessage.messageTarget = playerEntity;
								walkMessage.fireMessage = walkToMessage;
								walkMessage.cancelMessage = walkCancelMessage;
								walkMessage.waitForMessage = (CharacterNavigationComponent)(playerEntity.getComponentByType(CharacterNavigationComponent)).stoppedMessage;
								
								playerEntity.sendMessage(walkMessage);
							}
							
							//Direction
							var object : FlxObject = (FlxObjectComponent)(actableComponent.getSiblingComponent(FlxObjectComponent)).object;
							var facingMessage : Message = new Message();
							facingMessage.sender = this;
							
							if (((object.x + (object.width / 2)) - actableComponent.getActionPoint().x) < 0)
							{
								facingMessage.type = FlxSpriteComponent.FACE_LEFT_MESSAGE;
							} else {
								facingMessage.type = FlxSpriteComponent.FACE_RIGHT_MESSAGE;
							}
							
							var fqm : PlayerControllerMessage = new PlayerControllerMessage();
							fqm.sender = this;
							fqm.type = PlayerControllerMessage.QUEUE_ACTION;
							fqm.fireMessage = facingMessage;
							fqm.messageTarget = playerEntity;
							
							playerEntity.sendMessage(fqm);
							
							switch (actableComponent.interactionType)
							{
								case ActableComponent.INTERACTION_USE:
									var qimp : PlayerControllerMessage = new PlayerControllerMessage();
									qimp.type = PlayerControllerMessage.QUEUE_ACTION;
									
									var qimp_message : Message = new Message();
									qimp_message.sender = this;
									qimp_message.type = "action";
									qimp.fireMessage = qimp_message;
									qimp.messageTarget = playerEntity;
									
									playerEntity.sendMessage(qimp);
								break;
								
								case ActableComponent.INTERACTION_SMARTPHONE:
									qimp = new PlayerControllerMessage();
									qimp.type = PlayerControllerMessage.QUEUE_ACTION;
									
									qimp_message = new Message();
									qimp_message.sender = this;
									qimp_message.type = "phone";
									qimp.fireMessage = qimp_message;
									qimp.messageTarget = playerEntity;
									
									playerEntity.sendMessage(qimp);
								break;
							}
							
							var qimt : PlayerControllerMessage = new PlayerControllerMessage();
							qimt.type = PlayerControllerMessage.QUEUE_ACTION;
							
							var qimt_message : Message = new Message();
							qimt_message.sender = this;
							qimt_message.type = "action";
							qimt.fireMessage = qimt_message;
							qimt.messageTarget = actableComponent.entity;
							
							playerEntity.sendMessage(qimt);
						}
					}
					
					if (nearest_type == "walkable")
					{
						showMouseOverText("Walk here");
						
						if (FlxG.mouse.justPressed())
						{
							clearMessage = new Message();
							clearMessage.sender = this;
							clearMessage.type = PlayerControllerMessage.CLEAR_QUEUE;
							playerEntity.sendMessage(clearMessage);
							
							walkToMessage = new CharacterNavigationMessage();
							walkToMessage.sender = this;
							walkToMessage.type = CharacterNavigationMessage.SET_TARGET;
							walkToMessage.data = new Point(FlxG.mouse.x, FlxG.mouse.y);
							
							playerEntity.sendMessage(walkToMessage);
						}
					}
					
					if (nearest_type == "button")
					{
						if (nearest.getComponentByType(SmartphoneButtonComponent))
						{
							//showMouseOverText("Smartphone");
							showMouseOverText("");
						} else {
							showMouseOverText("");
						}
					}
				} else {
					showMouseOverText(null);
				}
			}
		}
		
	}

}