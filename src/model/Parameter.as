package model 
{
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class Parameter 
	{
		public static const DEFAULT_NAME : String = "Unnamed Parameter";
		
		private var _name : String;
		private var _contexts : Array;
		private var _relationships : Vector.<Relationship> = new Vector.<Relationship>();
		
		/**
		 * Default constructor
		 * @param	... args Any number of arrays of strings. Each array represents a context group. Values will be created for every
		 * permutation of contexts between context groups.
		 */
		public function Parameter( ... args) 
		{
			_name = DEFAULT_NAME;
			_contexts = new Array();
			
			//Sanity check
			for each (var a : Object in args)
			{
				if (!(a is Array))
				{
					trace("Problem: Parameter was given inputs that were not arrays");
					return;
				}
			}
			
			init_r("", args);
		}
		
		private function init_r(initial_string : String, a : Array):void
		{
			var first_array : Array = a[0];
			var remaining_array : Array = a.slice(1);
			if (initial_string.charAt(0) == ".") initial_string = initial_string.slice(1);
			
			if (remaining_array.length == 0)
			{
				for each (var s : String in first_array)
				{
					if (initial_string == "")
					{
						createContext(s);
					} else {
						createContext(initial_string + "." + s);
					}
				}
			} else {
				for each (s in first_array)
				{
					if (initial_string == "")
					{
						init_r(s, remaining_array);
					} else {
						init_r(initial_string + "." + s, remaining_array);
					}
					
				}
			}
		}
		
		private function createContext(name : String):void
		{
			_contexts[name] = new Value();
		}
		
		public function getValue(name : String):Value
		{
			return _contexts[name];
		}
		
		public function get values():Array
		{
			return _contexts;
		}
		
		public function setValue(name : String, n : Number):void
		{
			var v : Value = _contexts[name];
			
			if (v != null)
			{
				v.value = n;
			} else {
				trace("ERROR: No value \"" + name + "\" found in parameter " + name);
				return;
			}
		}
		
		public function get relationships():Vector.<Relationship>
		{
			return _relationships;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set name(s : String):void
		{
			_name = s;
		}
		
	}

}