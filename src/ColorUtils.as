package  
{
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class ColorUtils 
	{
		
		public function ColorUtils() 
		{
			
		}
		
		public static function ARGBtoRGB(input : uint):uint
		{
			input <<= 8;
			input &= 0xFFFFFF00;
			return input << 8;
		}
		
		public static function ARGBtoAlpha(input : uint):Number
		{
			var output : Number = 0;
			input >>= 24;
			input &= 0x000000FF;
			output = input / 255;
			
			return output;
		}
		
	}

}