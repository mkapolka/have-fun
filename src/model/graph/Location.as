package model.graph 
{
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class Location extends Node 
	{
		private var _attendees : Vector.<Person> = new Vector.<Person>();
		
		public function Location() 
		{
			
		}
		
		public function get attendees():Vector.<Person>
		{
			return _attendees;
		}
		
		override public function postUpdate():void
		{
			super.preUpdate();
			
			_attendees.splice(0, _attendees.length);
		}
		
		public function addAttendee(person : Person):void
		{
			_attendees.push(person);
		}
		
		
		
	}

}