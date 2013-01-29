package model 
{
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class SimpleRelationship extends Relationship
	{
		//apply the operation to the child value classes that do not match the parent classes
		public static const MODE_COMBINE : uint = 0;
		
		//apply the operation to the child value classes that do match the parent classes
		public static const MODE_MERGE : uint = 1;
		
		//apply the operation to all the child values
		public static const MODE_ALL : uint = 2;
		
		private var _mode : uint;
		
		public function SimpleRelationship(parent : Parameter, child : Parameter, mode : uint) 
		{
			_mode = mode;
			_parents.push(parent);
			_children.push(child);
		}
		
		public function get mode():uint
		{
			return _mode;
		}
		
		public function set mode(m : uint):void
		{
			_mode = m;
		}
		
		override public function visit():void
		{
			switch (_mode)
			{
				case MODE_COMBINE:
					visitCombine();
				break;
				
				case MODE_MERGE:
					visitMerge();
				break;
				
				case MODE_ALL:
					visitAll();
				break;
			}
		}
		
		protected function visitCombine():void
		{
			for (var pc : String in parents[0].values)
			{
				for (var cc : String in children[0].values)
				{
					var cca : Array = cc.split(".");
					for each (var s : String in cca)
					{
						if (s != pc)
						{
							update(parents[0].values[pc], children[0].values[cc]);
							continue;
						}
					}
				}
			}
		}
		
		protected function visitMerge():void
		{
			for (var pc : String in parents[0].values)
			{
				for (var cc : String in children[0].values)
				{
					var cca : Array = cc.split(".");
					for each (var s : String in cca)
					{
						if (s == pc)
						{
							update(parents[0].values[pc], children[0].values[cc]);
							continue;
						}
					}
				}
			}
		}
		
		protected function visitAll():void
		{
			for each (var pv : Value in parents[0].values)
			{
				for each (var cv : Value in children[0].values)
				{
					update(pv, cv);
				}
			}
		}
		
		protected function update(parent : Value, child : Value):void
		{
			//default implementation does nothing
		}
		
	}

}