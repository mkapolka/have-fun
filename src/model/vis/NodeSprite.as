package model.vis 
{
	import model.graph.Node;
	import org.flixel.FlxSprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class NodeSprite extends Sprite 
	{		
		private var _node : Node;
		
		private var _icon : Sprite;
		private var _text : TextField;
		
		private var _mouseOver : Boolean = false;
		private var _mouseDown : Boolean = false;
		
		public function NodeSprite(parameter : Node) 
		{
			super();
			
			_node = parameter;
			
			_icon = new Sprite();
			//_icon.graphics.beginFill(0x000000, 1);
			_icon.graphics.lineStyle(1, 0, 1);
			_icon.graphics.drawCircle(0, 0, 20);
			addChild(_icon);
			
			_text = new TextField();
			var textFormat : TextFormat = new TextFormat();
			textFormat.align = TextFormatAlign.CENTER;
			textFormat.color = 0xFF0000;
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
			_text.x = -_text.width / 2;
			//_text.y = -_text.height / 2;
			
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
			//output += _node.name;
			output += _node.toString();
			
			/*if (_mouseOver)
			{
				output += "\n";
				for (var s : String in _node.values)
				{
					output += s + " : " + _node.values[s].value + "\n";
				}
			}*/
			
			return output;
		}
		
	}

}