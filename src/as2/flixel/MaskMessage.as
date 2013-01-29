package as2.flixel 
{
	import org.component.Message;
	
	/**
	 * Class for sending messages to a MaskComponent. Currently only supports a single operation: the command to
	 * change which frame the mask will use for a particular mask.
	 * @author Marek Kapolka
	 */
	public class MaskMessage extends Message 
	{
		//For switching which 
		public static const SET_FRAME : String = "set_frame";
		
		private var _maskIndex : uint = 0;
		private var _frameIndex : uint = 0;
		
		public static function makeSetMaskMessage(maskIndex : uint, frameIndex : uint):MaskMessage
		{
			var output : MaskMessage = new MaskMessage();
			output.type = SET_FRAME;
			output._maskIndex = maskIndex;
			output._frameIndex = frameIndex;
			return output;
		}
		
		public function MaskMessage() 
		{
			super();
		}
		
		public function get maskIndex():uint 
		{
			return _maskIndex;
		}
		
		public function set maskIndex(value:uint):void 
		{
			_maskIndex = value;
		}
		
		public function get frameIndex():uint 
		{
			return _frameIndex;
		}
		
		public function set frameIndex(value:uint):void 
		{
			_frameIndex = value;
		}
		
		
		
	}

}