package model.graph 
{
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class Connection 
	{
		public static const DEFAULT_NAME : String = "Connection";
		public static const DEFAULT_TYPE : String = "connection";
		public static const DEFAULT_DISTANCE : Number = 1;
		
		protected var _name : String;
		protected var _type : String;
		protected var _other : Node;
		
		protected var _oldDistance : Number = DEFAULT_DISTANCE;
		protected var _newDistance : Number = 0;
		protected var _nInfluences : int = 0;
		
		protected var _atrophyQuotient : Number = 1;
		
		public function Connection() 
		{
			_name = DEFAULT_NAME;
			_type = DEFAULT_TYPE;
			_oldDistance = DEFAULT_DISTANCE;
		}
		
		public function beginTick():void
		{
			//Only update the old distance if someone actually tried to influence it, otherwise 
			//stay the same
			if (_nInfluences != 0)
			{
				_oldDistance = _newDistance / _nInfluences;
			}
			
			_newDistance = _oldDistance * atrophyQuotient;
			_nInfluences = 1;
		}
		
		public function influenceDistance(value : Number, weight : int = 1):void
		{
			if (isNaN(value) || isNaN(weight) || weight == 0)
			{
				return;
			}
			/*if (value > 1 || value < 0)
			{
				trace("Invalid value for influencing connection \"" + _name + "\": " + value);
				return;
			}*/
			
			_newDistance += value * weight;
			_nInfluences += weight;
		}
		
		public function get distance():Number
		{
			return _oldDistance;
		}
		
		public function set distance(n : Number):void
		{
			_oldDistance = n;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function set name(value:String):void 
		{
			_name = value;
		}
		
		public function get type():String 
		{
			return _type;
		}
		
		public function set type(value:String):void 
		{
			_type = value;
		}
		
		public function get other():Node 
		{
			return _other;
		}
		
		public function set other(value:Node):void 
		{
			_other = value;
		}
		
		public function get atrophyQuotient():Number
		{
			return _atrophyQuotient;
		}
		
		public function set atrophyQuotient(n : Number):void
		{
			_atrophyQuotient = n;
		}
		
	}

}