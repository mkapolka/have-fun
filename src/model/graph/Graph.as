package model.graph 
{
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class Graph 
	{
		private var _nodes : Vector.<Node> = new Vector.<Node>();
		private var _maxIndex : int = 0;
		
		public function Graph() 
		{
			
		}
		
		public function get nodes():Vector.<Node>
		{
			return _nodes;
		}
		
		public function addNode(n : Node):void
		{
			if (_nodes.indexOf(n) == -1) {
				n.uid = _maxIndex++;
				_nodes.push(n);
			}
		}
		
		public function update():void
		{
			for each (var n : Node in _nodes)
			{
				n.preUpdate();
				
				for each (var c : Connection in n.connections)
				{
					c.beginTick();
				}
			}
			
			for each (n in _nodes)
			{
				n.update();
			}
			
			for each (n in _nodes)
			{
				n.postUpdate();
			}
		}
		
	}

}