package model.graph 
{
	import as2.dialog.DialogInitiatorComponent;
	import flash.display.InteractiveObject;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class Node 
	{
		public static const DEFAULT_NAME : String = "Node";
		public static const DEFAULT_TYPE : String = "Node";
		
		private var _name : String;
		private var _type : String;
		private var _connections : Dictionary = new Dictionary(); // Key = Node, Value = Connection
		private var _uid : int;
		
		private var _numConnections : int = 0;
		
		private var _connectionsDirty : Boolean = false;
		
		public function Node() 
		{
			_name = DEFAULT_NAME;
			_type = DEFAULT_TYPE;
			_uid = -1;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set name(s : String):void
		{
			_name = s;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function set type(s : String):void
		{
			_type = s;
		}
		
		public function addConnection(c : Connection):void
		{			
			if (_connections[c.other] == null)
			{
				_numConnections++;
			}
			
			_connections[c.other] = c;
		}
		
		public function removeConnection(c : Connection):void
		{			
			if (_connections[c.other] != null)
			{
				_numConnections--;
				delete connections[c.other];
			}
		}
		
		public function removeConnectionWith(other : Node):void
		{
			if (_connections[other] != null)
			{
				_numConnections--;
				delete connections[other];
			}
		}
		
		public function hasConnectionWith(other : Node):Boolean
		{
			return _connections[other] != null;
		}
		
		public function getConnectionWith(other : Node):Connection
		{			
			return _connections[other];
		}
		
		public function getCommonNodes(other : Node):Vector.<Node>
		{
			var output : Vector.<Node> = new Vector.<Node>();
			
			for (var n : Object in connections)
			{
				if (other.hasConnectionWith(n as Node))
				{
					output.push(n);
				}
			}
			
			return output;
		}
		
		public function getCommonNodesVector(vector : Vector.<Node>):Vector.<Node>
		{
			var output : Vector.<Node> = new Vector.<Node>();
			
			for each (var n : Node in vector)
			{
				if (hasConnectionWith(n as Node))
				{
					output.push(n);
				}
			}
			
			return output;
		}
		
		public static function getCommonNodes(inputs : Vector.<Node>):Vector.<Node>
		{
			if (inputs.length == 0) return new Vector.<Node>();
			
			if (inputs.length == 1)
			{
				var output : Vector.<Node> = new Vector.<Node>();
				
				for (var o : Object in inputs[0].connections)
				{
					var n : Node = o as Node;
					output.push(n);
				}
				
				return output;
			}
			
			if (inputs.length == 2)
			{
				return inputs[0].getCommonNodes(inputs[1]);
			}
			
			var rollingOutput : Vector.<Node>;
			
			rollingOutput = inputs[0].getCommonNodes(inputs[1]);
			
			for (var i : int = 2; i < inputs.length; i++)
			{
				rollingOutput = inputs[i].getCommonNodesVector(rollingOutput);
			}
			
			return rollingOutput;
		}
		
		/**
		 * Returns the number of connections this node has in common with the other node.
		 * A connection is considered to be "in common" with the target node if the target of the
		 * connection is the same for both objects. The specific Connection object does not have to 
		 * be the same.
		 * @param	other The other node
		 * @return The number of connections in common
		 */		
		public function getRelatedness(other : Node):int
		{
			return getCommonNodes(other).length;
		}
		
		public function getNormalizedRelatedness(other : Node):Number
		{
			return getRelatedness(other) / connections.length;
		}
		
		/**
		 * Calculates the "Adjusted Relatedness", which is a value between 0 and 1 that represents
		 * how many connections the target node and this one share, adjusted for this node's distance
		 * to the common nodes. That is, if the distance between this node and the common node is high,
		 * the "Adjusted Relatedness" will rise. 
		 * @param	other
		 * @return
		 */
		public function getAdjustedRelatedness(other : Node):Number
		{			
			var d1 : Dictionary = connections;
			var d2 : Dictionary = other.connections;
			
			var total : int = 0;
			var distance_total : Number = 0;
			
			commonNodesGeneric(d1, d2, function(n : Node):void
			{
				total++;
				distance_total += n.connections[other].distance;
			});
			
			if (total == 0) return 0;
			return distance_total / total;
		}
		
		protected static function commonNodesGeneric(d1 : Dictionary, d2 : Dictionary, foundTargetCallback : Function):void
		{
			for (var n : Object in d1)
			{
				if (d2[n] != null)
				{
					foundTargetCallback(n);
				}
			}
		}
		
		public function get connections():Dictionary
		{			
			return _connections;
		}
		
		public function get uid():int 
		{
			return _uid;
		}
		
		public function set uid(value:int):void 
		{
			_uid = value;
		}
		
		protected function sort_connection_vector(a : Connection, b : Connection):Number
		{
			if (a.other.uid > b.other.uid)
			{
				return 1;
			} else {
				return -1;
			}
		}
		
		protected function sort_connection_vector_distance(a : Connection, b : Connection):Number
		{
			if (a.distance > b.distance)
			{
				return 1;
			} else if (a.distance < b.distance){
				return -1;
			} else {
				return 0;
			}
		}
		
		public function preUpdate():void
		{
			
		}
		
		public function update():void
		{
			
		}
		
		public function postUpdate():void
		{
			
		}
		
		/**
		 * Calculates and returns the distance from this node to the other node in connections.
		 * I.e. how many links you need to traverse to get to the target node
		 * @param	other The target node
		 * @return The number of links to travel to get to that node
		 */
		public function distanceFrom(other : Node):int
		{
			if (other == this) return 0;
			
			var hit : Vector.<Node> = new Vector.<Node>();
			var stack : Vector.<Object> = new Vector.<Object>();
			
			var o : Object = new Object();
			o.node = this;
			o.distance = 0;
			stack.push(o);
			
			while (stack.length > 0)
			{
				var next : Object = stack.pop();
				var currentDistance : int = next.distance;
				
				for each (var c : Connection in next.node.connections)
				{
					if (c.other == other) return currentDistance + 1;
					if (hit.indexOf(c.other) == -1)
					{
						hit.push(c.other);
						o = new Object();
						o.node = c.other;
						o.distance = currentDistance + 1;
						
						stack.push(o);
					}
				}
			}
			
			return -1;
		}
		
		public function toString():String
		{
			var output : String = "";
			
			output += name + ": " + type;
			output += "\n";
			
			for each (var c : Connection in connections)
			{
				output += c.type + " -> " + c.other.name + "(" + c.distance.toFixed(2) + ")" + "AR: " + getAdjustedRelatedness(c.other) + "\n"
			}
			
			return output;
		}
		
	}

}