package as2.etc 
{
	import as2.SmartphoneButtonComponent;
	import org.component.Component;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class UISquelcherComponent extends Component 
	{
		private static var _squelch : Boolean = false;
		
		public static function get squelch():Boolean
		{
			return _squelch;
		}
		
		public function UISquelcherComponent() 
		{
			
		}
		
		override public function initialize():void
		{
			_squelch = true;
		}
		
		override public function resolve():void
		{
			SmartphoneButtonComponent.setVisibleAndEnabled(false);
		}
		
		override public function destroy():void
		{
			SmartphoneButtonComponent.setVisibleAndEnabled(true);
			_squelch = false;
		}
		
	}

}