package as2.flixel 
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import org.flixel.FlxText;
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class AS2FlxText extends FlxText 
	{
		
		public function AS2FlxText(X:Number, Y:Number, Width:uint, Text:String=null, EmbeddedFont:Boolean=true) 
		{
			super(X, Y, Width, Text, EmbeddedFont);
		}
		
		public function get textField():TextField
		{
			return _textField;
		}
		
		public function set textField(tf : TextField):void
		{
			_textField = tf;
		}
		
		public function setTextFormat(tf : TextFormat, beginIndex : int = -1, endIndex : int = -1):void
		{
			_textField.setTextFormat(tf, beginIndex, endIndex);
			
			_regen = true;
			calcFrame();
		}
		
		override protected function calcFrame():void
		{
			if(_regen)
			{
				//Need to generate a new buffer to store the text graphic
				var i:uint = 0;
				var nl:uint = _textField.numLines;
				height = 0;
				while(i < nl)
					height += _textField.getLineMetrics(i++).height;
				height += 4; //account for 2px gutter on top and bottom
				_pixels = new BitmapData(width,height,true,0);
				frameHeight = height;
				_textField.height = height*1.2;
				_flashRect.x = 0;
				_flashRect.y = 0;
				_flashRect.width = width;
				_flashRect.height = height;
				_regen = false;
			}
			else	//Else just clear the old buffer before redrawing the text
				_pixels.fillRect(_flashRect,0);
			
			if((_textField != null) && (_textField.text != null) && (_textField.text.length > 0))
			{
				//Now that we've cleared a buffer, we need to actually render the text to it
				var format:TextFormat = _textField.defaultTextFormat;
				var formatAdjusted:TextFormat = format;
				_matrix.identity();
				//If it's a single, centered line of text, we center it ourselves so it doesn't blur to hell
				if((format.align == "center") && (_textField.numLines == 1))
				{
					formatAdjusted = new TextFormat(format.font,format.size,format.color,null,null,null,null,null,"left");
					_textField.setTextFormat(formatAdjusted);				
					_matrix.translate(Math.floor((width - _textField.getLineMetrics(0).width)/2),0);
				}
				//Render a single pixel shadow beneath the text
				if(_shadow > 0)
				{
					_textField.setTextFormat(new TextFormat(formatAdjusted.font,formatAdjusted.size,_shadow,null,null,null,null,null,formatAdjusted.align));				
					_matrix.translate(1,1);
					_pixels.draw(_textField,_matrix,_colorTransform);
					_matrix.translate(-1,-1);
					_textField.setTextFormat(new TextFormat(formatAdjusted.font,formatAdjusted.size,formatAdjusted.color,null,null,null,null,null,formatAdjusted.align));
				}
				//Actually draw the text onto the buffer
				_pixels.draw(_textField,_matrix,_colorTransform);
				//_textField.setTextFormat(new TextFormat(format.font,format.size,format.color,null,null,null,null,null,format.align));
			}
			
			//Finally, update the visible pixels
			if((framePixels == null) || (framePixels.width != _pixels.width) || (framePixels.height != _pixels.height))
				framePixels = new BitmapData(_pixels.width,_pixels.height,true,0);
			framePixels.copyPixels(_pixels,_flashRect,_flashPointZero);
		}
		
	}

}