package org.component.flixel 
{
	import org.component.flixel.FlxObjectComponent;
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class FlxTextComponent extends FlxSpriteComponent 
	{
		
		protected var _text : FlxText;
		
		public function FlxTextComponent() 
		{
			super();
		}
		
		public function get text():FlxText
		{
			return _text;
		}
		
		public function setText(text : String):void
		{
			_text.text = text;
		}
		
		public function getText():String
		{
			return _text.text;
		}
		
		override public function initialize():void
		{
			super.initialize();
		}
		
		protected function initializeText(x : Number, y : Number, width : Number, text : String):void
		{
			_text = new FlxText(x, y, width, text);
		}
		
		override public function loadContent(xml : XML):void
		{
			var x : Number = parseFloat(xml.x);
			var y : Number = parseFloat(xml.y);
			var width : Number = parseFloat(xml.width);
			var text : String = xml.text;
			var size : Number = parseFloat(xml.textSize);
			
			initializeText(x,y,width,text);
			
			_text.size = size;
			_object = _text;
			_sprite = _text;
			_text.alignment = xml.alignment;
			
			if (xmlElementExists(xml, "font") && xml.font != "")
			{
				_text.font = xml.font;
			}
			
			var color : uint = parseInt(xml.color);
			var alpha : Number = ColorUtils.ARGBtoAlpha(color);
			
			_text.color = color;// parseInt(xml.color);
			_text.alpha = alpha;// parseInt(xml.color_alpha) / 255;
			
			loadPositionData(xml);
		}
		
	}

}