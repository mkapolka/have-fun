package model 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class DeltaRelationship extends SimpleRelationship 
	{
		private var _oldValues : Dictionary;
		private var _coefficient : Number;
		
		public function DeltaRelationship(parent : Parameter, child : Parameter, mode : uint, coefficient : Number=1) 
		{
			super(parent, child, mode);
			_oldValues = new Dictionary();
			_coefficient = coefficient;
		}
		
		override public function init():void
		{
			for each(var v : Value in parents[0].values)
			{
				_oldValues[v] = v.value;
			}
		}
		
		override protected function update(parentValue : Value, childValue : Value):void
		{
			var delta : Number = parentValue.value - _oldValues[parentValue];
			
			childValue.value += delta * _coefficient;
			
			_oldValues[parentValue] = parentValue.value;
		}
		
	}

}