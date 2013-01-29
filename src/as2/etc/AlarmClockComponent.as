package as2.etc 
{
	import as2.AS2GameData;
	import as2.RoomManager;
	import org.component.Component;
	import org.component.Entity;
	import org.component.flixel.AnimatedFlxSpriteComponent;
	import org.component.flixel.FlxObjectComponent;
	import org.component.flixel.FlxSpriteComponent;
	import org.component.flixel.FlxTextComponent;
	import org.component.Message;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class AlarmClockComponent extends Component 
	{
		public static const NUMERAL_ENTITY_NAME : String = "ClockReadout";
		public static const CLICK_ENTITY_NAME : String = "ClockClick";
		public static const TEXT_ENTITY_NAME : String = "ClockText";
		public static const TEXT_TEXT_NAME : String = "ClockText"; //name of the entity that has the flxText component
		public static const BLINKY_NAME : String = "Dots"; // Name of the blinky lights entity
		public static const YES_BUTTON_NAME : String = "YesButton";
		public static const NO_BUTTON_NAME : String = "NoButton";
		
		public static const NO_PRESSED_MESSAGE : String = "no_pressed";
		public static const YES_PRESSED_MESSAGE : String = "yes_pressed";
		
		public static const CLICK_TRIGGER : String = "click";
		
		public static const NUMERAL_1 : String = "Numeral_1";
		public static const NUMERAL_2 : String = "Numeral_2";
		public static const NUMERAL_3 : String = "Numeral_3";
		public static const NUMERAL_4 : String = "Numeral_4";
		
		public static const BLINK_COUNTDOWN : Number = 1; // time between blinks
		
		public static const MODE_COUNTDOWN : uint = 0;
		public static const MODE_CLICK : uint = 1;
		public static const MODE_TEXT : uint = 2;
		public static const MODE_SNOOZEFAIL : uint = 3;
		
		private var _numerals : Entity;
		private var _click : Entity;
		private var _text : Entity;
		
		private var _mode : uint = 0;
		private var _clickMode : Boolean = false;
		
		private var _curTime : Date = new Date();
		private var _timeRemaining : Number = 0;
		private var _elapsed : Number = 0;
		
		private var _blinkCountdown : Number = BLINK_COUNTDOWN;
		
		public function AlarmClockComponent() 
		{
			super();
			
			_curTime.hours = 7;
			_curTime.minutes = 59;
		}
		
		public function get numeralEntity():Entity
		{
			return entity.getChildByName(NUMERAL_ENTITY_NAME);
		}
		
		public function get clickEntity():Entity
		{
			return entity.getChildByName(CLICK_ENTITY_NAME);
		}
		
		public function get textEntity():Entity
		{
			return entity.getChildByName(TEXT_ENTITY_NAME);
		}
		
		private function get textText():FlxTextComponent
		{
			var te : Entity = textEntity;
			
			if (te != null)
			{
				return te.getChildByName(TEXT_TEXT_NAME).getComponentByType(FlxTextComponent) as FlxTextComponent;
			} else {
				return null;
			}
		}
		
		override public function resolve():void
		{
			super.resolve();
			
			_numerals = entity.getChildByName(NUMERAL_ENTITY_NAME);
			_click = entity.getChildByName(CLICK_ENTITY_NAME);
			_text = entity.getChildByName(TEXT_ENTITY_NAME);
			
			setMode(MODE_COUNTDOWN);
		}
		
		override public function receiveMessage(message : Message):void 
		{
			super.receiveMessage(message);
			
			if (message.type == CLICK_TRIGGER)
			{
				if (mode == MODE_CLICK)
				{
					setMode(MODE_TEXT);
				}
			}
			
			if (MODE_TEXT)
			{
				if (message.type == YES_PRESSED_MESSAGE)
				{
					var wup : int = parseInt(AS2GameData.data.wakeup_points);
					wup -= 100;
					AS2GameData.data.wakeup_points = wup;
					_curTime.minutes += 29;
					FlxG.fade(0x0, 3, unfade);
				}
				
				if (message.type == NO_PRESSED_MESSAGE)
				{
					RoomManager.transition(RoomManager.HOME_KEY, RoomManager.FADE, "bed");
				}
			}	
		}
		
		private function unfade():void
		{
			FlxG.camera.stopFX();
			FlxG.flash(0x0, 1, null);
			setMode(MODE_COUNTDOWN);
		}
		
		public function set mode(mode : uint):void
		{
			setMode(mode);
		}
		
		public function get mode():uint
		{
			return _mode;
		}
		
		public function setMode(mode : uint):void
		{
			var message : Message = new Message();
			message.sender = this;
			message.type = FlxObjectComponent.HIDE;
			entity.sendMessage(message);
			message.type = FlxObjectComponent.DISABLE;
			entity.sendMessage(message);
			
			message.type = FlxObjectComponent.SHOW;
			
			var message2 : Message = new Message();
			message2.sender = this;
			message2.type = FlxObjectComponent.ENABLE;
			
			switch (mode)
			{
				case MODE_COUNTDOWN:
					numeralEntity.sendMessage(message);
					numeralEntity.sendMessage(message2);
					_timeRemaining = Math.random() * 5;
					updateReadout();
				break;
				
				case MODE_CLICK:
					clickEntity.sendMessage(message);
					clickEntity.sendMessage(message2);
					_timeRemaining = 1;
					_elapsed = 0;
					_curTime.minutes += 1;
					updateReadout();
				break;
				
				case MODE_TEXT:
					textEntity.sendMessage(message);
					textEntity.sendMessage(message2);
					var s : Number = (1 - _elapsed) * 10;
					if (s < 0) s = 1;
					var funGained : int = Math.round(s * 5);
					var pointsGained : int = Math.round(s * 10);
					var curwup : Number = parseInt(AS2GameData.data.wakeup_points);
					curwup += pointsGained;
					AS2GameData.data.wakeup_points = curwup;
					
					textText.text.text = "Good Morning! You woke up in " + _elapsed.toFixed(2) + " seconds! You have earned " + pointsGained + " WakeUp points and " + funGained + " Fun! You have " + curwup + " WakeUp points! Would you like to buy a snooze for 100 points?";
					AS2GameData.playerData.fun += funGained;
					
					if (curwup < 100)
					{
						var nb : Entity = getYesButton();
						
						if (nb != null)
						{
							message.type = FlxObjectComponent.DISABLE;
							nb.sendMessage(message);
						}
					} else {
						var yb : Entity = getYesButton();
						
						if (yb != null)
						{
							message.type = FlxObjectComponent.ENABLE;
							yb.sendMessage(message);
						}
					}
				break;
			}
			
			_mode = mode;
		}
		
		private function getBlinky():Entity
		{
			var readout : Entity = numeralEntity;
			
			if (readout != null)
			{
				return readout.getChildByName(BLINKY_NAME);
			} else {
				return null;
			}
		}
		
		private function getBlinkySprite():FlxSpriteComponent
		{
			var blink_entity : Entity = getBlinky();
			
			if (blink_entity != null)
			{
				return blink_entity.getComponentByType(FlxSpriteComponent) as FlxSpriteComponent;
			} else {
				return null;
			}
		}
		
		private function getNumeral(name : String):AnimatedFlxSpriteComponent
		{
			var ne : Entity = numeralEntity;
			
			if (ne != null)
			{
				return ne.getChildByName(name).getComponentByType(AnimatedFlxSpriteComponent) as AnimatedFlxSpriteComponent;
			} else {
				return null;
			}
		}
		
		private function getNumeral1():AnimatedFlxSpriteComponent
		{
			return getNumeral(NUMERAL_1);
		}
		
		private function getNumeral2():AnimatedFlxSpriteComponent
		{
			return getNumeral(NUMERAL_2);
		}

		private function getNumeral3():AnimatedFlxSpriteComponent
		{
			return getNumeral(NUMERAL_3);
		}

		private function getNumeral4():AnimatedFlxSpriteComponent
		{
			return getNumeral(NUMERAL_4);
		}
		
		private function getYesButton():Entity
		{
			var te : Entity = textEntity;
			
			if (te != null)
			{
				return te.getChildByName(YES_BUTTON_NAME);
			} else {
				return null;
			}
		}
		
		private function getNoButton():Entity
		{
			var te : Entity = textEntity;
			
			if (te != null)
			{
				return te.getChildByName(NO_BUTTON_NAME);
			} else {
				return null;
			}
		}
		
		public function updateReadout():void
		{
			var hours : String = "";
			if (_curTime.hours < 10)
			{
				hours += "0";
			}
			hours += _curTime.hours;
			
			var minutes : String = "";
			if (_curTime.minutes < 10)
			{
				minutes += "0";
			}
			minutes += _curTime.minutes;
			
			getNumeral1().sprite.frame = parseInt(hours.charAt(0));
			getNumeral2().sprite.frame = parseInt(hours.charAt(1));
			getNumeral3().sprite.frame = parseInt(minutes.charAt(0));
			getNumeral4().sprite.frame = parseInt(minutes.charAt(1));
		}
		
		private function clickModeToggle():void
		{
			var hm : Message = new Message();
			hm.sender = this;
			hm.type = FlxObjectComponent.HIDE;
			
			var sm : Message = new Message();
			sm.sender = this;
			sm.type = FlxObjectComponent.SHOW;
			
			if (_clickMode)
			{
				numeralEntity.sendMessage(hm);
				clickEntity.sendMessage(sm);
			} else {
				numeralEntity.sendMessage(sm);
				clickEntity.sendMessage(hm);
			}
			
			_clickMode = !_clickMode;
		}
		
		override public function update():void
		{
			super.update();
			
			switch (mode)
			{
				case MODE_COUNTDOWN:
					_timeRemaining -= FlxG.elapsed;
					_blinkCountdown -= FlxG.elapsed;
					
					if (_blinkCountdown < 0)
					{
						_blinkCountdown = BLINK_COUNTDOWN;
						
						var fs : FlxSpriteComponent = getBlinkySprite();
						
						if (fs != null)
						{
							fs.sprite.alpha = 1 - fs.sprite.alpha;
						}
					}
					
					if (_timeRemaining < 0)
					{
						setMode(MODE_CLICK);
						_timeRemaining = 1;
					}
				break;
				
				case MODE_CLICK:
					_timeRemaining -= FlxG.elapsed;
					_elapsed += FlxG.elapsed;
					
					if (_timeRemaining < 0)
					{
						_timeRemaining = 1;
						clickModeToggle();
					}
				break;
			}
		}
		
	}

}
