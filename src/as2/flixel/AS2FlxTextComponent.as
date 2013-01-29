package as2.flixel 
{
	import flash.text.TextFormat;
	import org.component.flixel.FlxTextComponent;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class AS2FlxTextComponent extends FlxTextComponent 
	{
		public static const HIGHLIGHT_COLOR : int = 0xCB7629;
		
		public function AS2FlxTextComponent() 
		{
			super();
		}
		
		public function get as2FlxText():AS2FlxText
		{
			return _text as AS2FlxText;
		}
		
		override protected function initializeText(x : Number, y : Number, width : Number, text : String):void
		{
			_text = new AS2FlxText(x,y,width,text);
		}
		
		override public function setText(s : String):void
		{
			var hltf : TextFormat = new TextFormat(_text.font, _text.size, HIGHLIGHT_COLOR, true);
			
			var ranges : Vector.<int> = new Vector.<int>();
			var n_tags : int = 0;
			var ioffs : int = 0;
			var si : int = 0;
			var ei : int = 0;
			var doing : Boolean = false;
			
			for (var i : int = 0; i < s.length; i++)
			{
				if (!doing)
				{
					var c : String = s.charAt(i);
					if (s.charAt(i) == "%")
					{
						//Escape- write an actual '%' character
						if (s.charAt(i + 1) == "%")
						{
							i++;
							n_tags++;
							doing = false;
						} else {
							si = i + ioffs;
							doing = true;
						}
					}
				} else {
					
					if (s.charAt(i).match("[^a-zA-Z]"))
					{
						doing = false;
						ranges.push(si, ei);
						n_tags++;
						ioffs--;
					} else {
						ei = i + ioffs;
					}
				}
			}
			
			//String loop ended at end of string
			if (doing)
			{
				doing = false;
				ranges.push(si, ei);
				n_tags++;
			}
			
			for (i = 0; i < n_tags; i++)
			{
				s = s.replace("%", "");
			}
			
			
			super.setText(s);
			
			for (i = 0; i < ranges.length; i += 2)
			{
				as2FlxText.setTextFormat(hltf, ranges[i], ranges[i + 1]);
			}
		}
		
	}

}