package model 
{
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class StreamRelationship extends SimpleRelationship 
	{
		private var _coefficient : Number;
		
		public function StreamRelationship(parent:Parameter, child:Parameter, mode:uint, coefficient:Number = 1) 
		{
			super(parent, child, mode);
			_coefficient = coefficient;
		}
		
		override protected function update(parentValue : Value, childValue : Value):void
		{
			childValue.value += parentValue.value * _coefficient;
		}
		
	}

}