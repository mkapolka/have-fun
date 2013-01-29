package model 
{
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class Relationship 
	{		
		protected var _parents : Vector.<Parameter> = new Vector.<Parameter>();
		protected var _children : Vector.<Parameter> = new Vector.<Parameter>();
		
		public function Relationship() 
		{
			
		}
		
		public function get parents():Vector.<Parameter>
		{
			return _parents;
		}
		
		public function get children():Vector.<Parameter>
		{
			return _children;
		}
		
		public function init():void
		{
			//
		}
		
		public function visit():void
		{
			//default implementation does nothing
		}
		
	}

}