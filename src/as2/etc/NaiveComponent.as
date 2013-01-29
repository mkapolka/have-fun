package as2.etc 
{
	import as2.AS2GameData;
	import org.component.Component;
	import org.component.flixel.FlxObjectComponent;
	import org.component.Message;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class NaiveComponent extends Component 
	{
		public static var instance : NaiveComponent = null;
		
		public function NaiveComponent() 
		{
			super();
		}
		
		public static function hide():void
		{
			if (instance != null)
			{
				var m : Message = new Message();
				m.type = FlxObjectComponent.HIDE;
				m.sender = instance;
				instance.entity.sendMessage(m);
				
				m.type = FlxObjectComponent.DISABLE;
				instance.entity.sendMessage(m);
			}
			
		}
		
		override public function resolve():void
		{
			super.resolve();
			
			instance = this;
			
			if (parseInt(AS2GameData.data.naive_day) > 4)
			{
				hide();
			}
		}
		
	}

}