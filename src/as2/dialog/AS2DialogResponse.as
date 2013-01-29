package as2.dialog 
{
	import org.component.dialog.DialogResponse;
	
	/**
	 * ...
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