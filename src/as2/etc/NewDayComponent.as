package as2.etc 
{
	import as2.AS2GameData;
	import as2.RoomManager;
	import org.component.Component;
	import org.component.flixel.FlxTextComponent;
	import org.flixel.FlxG;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class NewDayComponent extends Component 
	{
		public static const PART_LENGTH : Number = 1;
		private var _part : uint = 0;
		private var _cd : Number = PART_LENGTH;
		
		public function NewDayComponent() 
		{
			super();
		}
		
		public function get textComponent():FlxTextComponent
		{
			return getSiblingComponent(FlxTextComponent) as FlxTextComponent;
		}
		
		override public function resolve():void
		{
			super.resolve();
			
			part = 0;
		}
		
		private function set part(value : uint):void
		{
			switch (value)
			{
				case 0:
					textComponent.text.text = "";
				break;
				
				case 1:
					textComponent.text.text = "Days Played:\n";
				break;
				
				case 2:
					textComponent.text.text = "Days Played:\n" + AS2GameData.date;
				break;
			}
			
			_part = value;
		}
		
		private function get part():uint
		{
			return _part;
		}
		
		override public function update():void
		{
			super.update();
			
			_cd -= FlxG.elapsed;
			
			/*if (_cd < 0)
			{
				_cd = PART_LENGTH;
				part++;
			}
			
			if (_part >= 2 && FlxG.mouse.justPressed())
			{
				RoomManager.transition(RoomManager.ALARM_KEY, RoomManager.FADE, null);
			}*/
			
			if (_cd < 0)
			{
				RoomManager.transition(RoomManager.ALARM_KEY, RoomManager.FADE, null);
			}
		}
		
	}

}