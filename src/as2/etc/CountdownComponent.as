package as2.etc 
{
	import as2.AS2GameData;
	import as2.SmartphoneButtonComponent;
	import org.component.Component;
	import org.component.Entity;
	import org.component.flixel.FlxObjectComponent;
	import org.component.flixel.FlxTextComponent;
	import org.component.Message;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class CountdownComponent extends Component 
	{
		public static const TEXT_NAME : String = "Text";
		
		private var _visible : Boolean = true;
		public static var paused : Boolean = false;
		
		public function CountdownComponent() 
		{
			super();
		}
		
		public function sendMessage(type : String):void
		{
			var out : Message = new Message();
			out.sender = this;
			out.type = type;
			entity.sendMessage(out);
		}
		
		public function get flxObjectComponent():FlxObjectComponent
		{
			return getSiblingComponent(FlxObjectComponent) as FlxObjectComponent;
		}
		
		override public function update():void
		{
			super.update();
			
			/*if (FlxG.keys.justPressed("SPACE"))
			{
				AS2GameData.dayTime = 5;
			}*/
			
			if ((!AS2GameData.hasSmartphone && flxObjectComponent.object.visible) || UISquelcherComponent.squelch)
			{
				sendMessage(FlxObjectComponent.HIDE);
				sendMessage(FlxObjectComponent.DISABLE);
			}
			
			if (AS2GameData.hasSmartphone && !flxObjectComponent.object.visible && !UISquelcherComponent.squelch)
			{
				sendMessage(FlxObjectComponent.SHOW);
				sendMessage(FlxObjectComponent.ENABLE);
				paused = false;
			}
			
			if (flxObjectComponent.object.visible)
			{
				if (AS2GameData.dayTime > 0 && !paused)
				{
					AS2GameData.dayTime -= FlxG.elapsed;
				}
				
				updateText();
			}
		}
		
		public function get textEntity():Entity
		{
			return entity.getChildByName(TEXT_NAME);
		}
		
		public function get textComponent():FlxTextComponent
		{
			var e : Entity = textEntity;
			
			if (e != null)
			{
				return e.getComponentByType(FlxTextComponent) as FlxTextComponent;
			} else {
				return null;
			}
		}
		
		public function updateText():void
		{
			var time : Number = AS2GameData.dayTime;
			
			var minutes : int = Math.floor(time / 60);
			var seconds : int = Math.floor(time) % 60;
			var s_seconds : String = (seconds<10?"0":"") + seconds;
			var millisecond : int = Math.floor(time * 100) % 100;
			var s_millisecond : String = (millisecond < 10?"0":"") + millisecond;
			
			textComponent.text.text = minutes + ":" + s_seconds + ":" + s_millisecond;
		}
		
	}

}