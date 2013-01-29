package model.vis 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import model.Parameter;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class ParameterSprite extends Sprite 
	{
		private var _parameter : Parameter;
		private var _text : TextField;
		
		private var _mouseOver : Boolean = false;
		private var _mouseDown : Boolean = false;
		
		public function ParameterSprite(parameter : Parameter ) 
		{
			super();
			
			_parameter = parameter;
			
			graphics.drawCircle(0, 0, 10);
			
			_text = new TextField();
			var textFormat : TextFormat = new TextFormat();
			textFormat.align = TextFormatAlign.CENTER;
			_text.setTextFormat(textFormat);
			
			addChild(_text);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			//addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		public function onEnterFrame(e : Event):void
		{
			_text.text = getParameterText();
			
			if (_mouseDown)
			{
				x = parent.mouseX;
				y = parent.mouseY;
			}
		}
		
		public function onMouseOver(me : MouseEvent):void
		{
			_mouseOver = true;
		}
		
		public function onMouseOut(me : MouseEvent):void
		{
			_mouseOver = false;
		}
		
		public function onMouseDown(me : MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			_mouseDown = true;
		}
		
		public function onMouseUp(me : MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			_mouseDown = false;
		}
		
		public function getParameterText():String
		{
			var output : String = "";
			output += _parameter.name;
			
			if (_mouseOver)
			{
				output += "\n";
				for (var s : String in _parameter.values)
				{
					output += s + " : " + _parameter.values[s].value + "\n";
				}
			}
			
			return output;
		}
		
	}

}