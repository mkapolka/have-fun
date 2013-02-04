package as2 
{
	import as2.dialog.SmartphoneDialogInitiatorComponent;
	import org.component.Component;
	import org.component.Entity;
	import org.component.flixel.FlxObjectComponent;
	import org.component.flixel.FlxSpriteComponent;
	import org.component.Message;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	
	/**
	 * This component is for the HUD button that opens the smartphone interface.
	 * @author Marek Kapolka
	 */
	public class SmartphoneButtonComponent extends Component 
	{
		public static const TAG_ID : String = "SmartphoneDialogButton";
		
		private var _shouldBeEnabled : Boolean = true;
		private var _shouldBeVisible : Boolean = true;
		
		public function SmartphoneButtonComponent() 
		{
			super();
			
			addRequisiteComponent(FlxSpriteComponent);
		}
		
		public static function getInstance():Entity
		{
			return TaggedObjectComponent.getObjectByTag(TAG_ID);
		}
		
		public static function setVisibleAndEnabled(value : Boolean):void
		{
			var instance : Entity = getInstance();
			
			if (instance != null)
			{
				var sbc : SmartphoneButtonComponent = instance.getComponentByType(SmartphoneButtonComponent) as SmartphoneButtonComponent;
				sbc._shouldBeEnabled = value;
				sbc._shouldBeVisible = value;
			}
		}
		
		public static function isVisible():Boolean
		{
			var instance : Entity = getInstance();
			
			if (instance != null)
			{
				var sbc : SmartphoneButtonComponent = instance.getComponentByType(SmartphoneButtonComponent) as SmartphoneButtonComponent;
				return sbc._shouldBeVisible;
			} else {
				return false;
			}
		}
		
		public function get flxObjectComponent():FlxObjectComponent
		{
			return getSiblingComponent(FlxObjectComponent) as FlxObjectComponent;
		}
		
		public function get flxObject():FlxObject
		{
			var foc : FlxObjectComponent = flxObjectComponent;
			
			return foc == null?null:foc.object;
		}
		
		private function sendMessage(s : String):void
		{
			var m : Message = new Message();
			m.type = s;
			m.sender = this;
			
			entity.sendMessage(m);
		}
		
		override public function update():void
		{
			super.update();
			
			//Only show the button if the player actually has a smartphone
			if (!AS2GameData.hasSmartphone)
			{
				var fo : FlxObject = flxObject;
				
				if (fo.visible)
				{
					sendMessage(FlxObjectComponent.HIDE);
				}
				
				if (fo.active)
				{
					sendMessage(FlxObjectComponent.DISABLE);
				}
			} else {
				fo = flxObject;
				
				if (_shouldBeEnabled && !fo.active)
				{
					sendMessage(FlxObjectComponent.ENABLE);
				}
				
				if (_shouldBeVisible && !fo.visible)
				{
					sendMessage(FlxObjectComponent.SHOW);
				}
				
				if (!_shouldBeEnabled && fo.active)
				{
					sendMessage(FlxObjectComponent.DISABLE);
				}
				
				if (!_shouldBeVisible && fo.visible)
				{
					sendMessage(FlxObjectComponent.HIDE);
				}
			}
		}
		
		override public function receiveMessage(message : Message):void
		{
			super.receiveMessage(message);
			
			var mouseEntity : Entity = Assignment2State.getMouseEntity();
			
			if (message.type == "up")
			{
				var phoneMessage : Message = new Message();
				phoneMessage.sender = this;
				phoneMessage.type = "phone";
				Assignment2State.getPlayerEntity().sendMessage(phoneMessage);
				setSpriteScale(1, 1);
			}
			
			if (message.type == "over")
			{
				setSpriteScale(1.3, 1.3);
			}
			
			if (message.type == "out")
			{
				setSpriteScale(1, 1);
			}
			
			if (message.type == "down")
			{
				setSpriteScale(.8, .8);
			}
			
			if (message.sender != this)
			{
				if (message.type == FlxObjectComponent.DISABLE)
				{
					_shouldBeEnabled = false;
				}
				
				if (message.type == FlxObjectComponent.ENABLE)
				{
					_shouldBeEnabled = true;
				}
				
				if (message.type == FlxObjectComponent.SHOW)
				{
					_shouldBeVisible = true;
				}
				
				if (message.type == FlxObjectComponent.DISABLE)
				{
					_shouldBeVisible = false;
				}
			}
		}
		
		private function setSpriteScale(xs : Number, ys : Number):void
		{
			var sc : FlxSpriteComponent = flxSpriteComponent;
			
			sc.sprite.scale.x = xs;
			sc.sprite.scale.y = ys;
		}
		
		public function get flxSpriteComponent():FlxSpriteComponent
		{
			return getSiblingComponent(FlxSpriteComponent) as FlxSpriteComponent;
		}
		
	}

}