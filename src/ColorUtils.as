package  
{
	/**
	 * Contains a few methods for converting between the different color
	 * formats that the different libraries and languages use.
	 * @author Marek Kapolka
	 */
	public class ColorUtils 
	{		
		/**
		 * Converts a uint value from the format 0xAARRGGBB to 0xRRGGBB00
		 * @param	input A color value in the form 0xAARRGGBB where AA is the alpha value, RR is the red value, etc.
		 * @return The same color value, stripped of its alpha channel, in the form 0xRRGGBB.
		 */
		public static function ARGBtoRGB(input : uint):uint
		{
			input <<= 8;
			input &= 0xFFFFFF00;
			return input << 8;
		}
		
		/**
		 * Extracts the value of the alpha channel of an ARGB uint and returns it as a Number from 0.0 -> 1.0
		 * @param	input A color in the form 0xAARRGGBB
		 * @return The alpha value of the input color as a Number between 0.0 and 1.0.
		 */
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