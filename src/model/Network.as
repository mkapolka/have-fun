package model 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class Network 
	{
		private var _parameters : Vector.<Parameter> = new Vector.<Parameter>();
		private var _relationships : Vector.<Relationship> = new Vector.<Relationship>();
		
		private var _cachedOrder : Vector.<Relationship> = new Vector.<Relationship>();
		private var _dirty : Boolean = false;
		
		public function Network() 
		{
			
		}
		
		public function initialize():void
		{
			for each (var r : Relationship in _relationships)
			{
				r.init();
			}
		}
		
		public function get parameters():Vector.<Parameter>
		{
			return _parameters;
		}
		
		public function get relationships():Vector.<Relationship>
		{
			return _relationships;
		}
		
		public function addParameter(p : Parameter):void
		{
			_parameters.push(p);
			_dirty = true;
		}
		
		public function removeParameter(p : Parameter):void
		{
			_parameters.splice(_parameters.indexOf(p), 1);
			_dirty = true;
		}
		
		public function addRelationship(r : Relationship):void
		{
			_relationships.push(r);
			_dirty = true;
		}
		
		public function removeRelationship(r : Relationship):void
		{
			_relationships.splice(_relationships.indexOf(r), 1);
			_dirty = true;
		}
		
		public function setDirty():void
		{
			_dirty = true;
		}
		
		public function get dirty():Boolean
		{
			return _dirty;
		}
		
		public function set dirty(b : Boolean):void
		{
			_dirty = b;
		}
		
		public function tick():void
		{
			if (_dirty)
			{
				order();
				_dirty = false;
			}
			
			for (var i : int = 0; i < _cachedOrder.length; i++)
			{
				_cachedOrder[i].visit();
			}
		}
		
		public function order():void
		{
			_cachedOrder = new Vector.<Relationship>();
			
			var objects : Dictionary = new Dictionary();
			var order : Array = new Array();
			var stack : Array = new Array();
			
			//Populate the objects list
			for each (var p : Parameter in _parameters)
			{
				var o : Object = new Object();
				o.in_edges = 0;
				o.type = "parameter";
				o.object = p;
				
				objects[p] = o;
			}
			
			for each (var r : Relationship in _relationships)
			{
				o = new Object();
				o.in_edges = r.parents.length;
				o.type = "relationship";
				o.object = r;
				
				for each (p in r.children)
				{
					objects[p].in_edges++;
				}
				
				objects[r] = o;
			}
			
			//find first objects w/ 0 in-edges
			for each (o in objects)
			{
				if (o.in_edges == 0)
				{
					stack.push(o);
				}
			}
			
			while (stack.length > 0)
			{
				var target : Object = stack.pop();
				
				if (o.object is Parameter)
				{
					p = o.object as Parameter;
					for each (r in p.relationships)
					{
						var o2 : Object = objects[r];
						o2.in_edges--;
						if (o2.in_edges == 0) stack.push(o2);
					}
				}
				
				if (o.object is Relationship)
				{
					r = o.object as Relationship;
					
					_cachedOrder.push(r);
					
					for each (p in r.children)
					{
						o2 = objects[p];
						o2.in_edges--;
						if (o2.in_edges == 0) stack.push(o2);
					}
				}
			}
		}
		
	}

}