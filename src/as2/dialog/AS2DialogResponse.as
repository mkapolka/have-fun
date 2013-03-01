package as2.dialog 
{
	import org.component.dialog.DialogResponse;
	
	/**
	 * A DialogResponse with options specific to the AS2 ("Have Fun") project.
	 * Include settings for changing the name and portrait of the currently displayed
	 * dialogpartner, as well as showing or hiding the "input" field (the text field that
	 * the player can type repsonses into)
	 * @author Marek Kapolka
	 */
	public class AS2DialogResponse extends DialogResponse 
	{
		private var _portrait : uint = 0;
		private var _name : uint = 0;
		private var _input : Boolean = false;
		
		public function AS2DialogResponse() 
		{
			super();
		}
		
		public function get portrait():uint
		{
			return _portrait;
		}
		
		public function set portrait(n : uint ):void
		{
			_portrait = n;
		}
		
		public function get input():Boolean
		{
			return _input;
		}
		
		public function set input(b : Boolean):void
		{
			_input = b;
		}
	}

}