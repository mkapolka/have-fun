package model 
{
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class Value 
	{
		private var _value : Number;
		
		public function Value() 
		{
			_value = 0;
		}
		
		public function get value():Number
		{
			return _value;
		}
		
		public function set value(n : Number):void
		{
			_value = n;
		}
		
	}

}