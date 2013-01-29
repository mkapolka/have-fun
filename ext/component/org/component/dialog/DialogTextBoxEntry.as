package org.component.dialog 
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class DialogTextBoxEntry extends DialogTextBoxButton 
	{
		public static const ENTER_KEYCODE : uint = 13;
		
		protected var _textField : TextField;
		protected var _onEnter : Function;
		
		public function DialogTextBoxEntry(X:Number, Y:Number, Width:Number, Height:Number)
		{
			super(X, Y, Width, Height);
			
			remove(_text, true);
			
			_textField = new TextField();
			_textField.type = TextFieldType.INPUT;
			
			var tf : TextFormat = new TextFormat(_text.font, _text.size, _text.color, null, null, null, null, null, _text.alignment);
			_textField.defaultTextFormat = tf;
			
			_textField.text = "<Enter Your Response>";
			_textField.x = X;
			_textField.y = Y;
			_textField.width = Width;
			_textField.selectable = false;
			
			_textField.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			FlxG.stage.addChild(_textField);
			
			_onClick = callback;
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			FlxG.stage.removeChild(_textField);
		}
		
		override public function set x(n : Number):void
		{
			_textField.x = n;// + width / 2;
			super.x = n;
		}
		
		override public function set y(n : Number):void
		{
			_textField.y = n;
			super.y = n;
		}
		
		override public function set onClick(f : Function):void
		{
			_onEnter = f;
		}
		
		override public function get onClick():Function
		{
			return _onEnter;
		}
		
		override public function set text(s : String):void
		{
			_textField.text = s;
		}
		
		override public function get text():String
		{
			return _textField.text;
		}
		
		private function callback(a : Array):void
		{
			FlxG.stage.focus = _textField;
			_textField.setSelection(0, _textField.length);
		}
		
		protected function onKeyDown(e : KeyboardEvent):void
		{
			if (e.charCode == ENTER_KEYCODE)
			{
				_params[0] = _textField.text;
				_onEnter(_params);
			}
		}
		
		override protected function updateColors(over : Boolean):void
		{
			if (over)
			{
				_textField.textColor = TEXT_COLOR_ON;
			} else {
				_textField.textColor = TEXT_COLOR_OFF;
			}
			
			super.updateColors(over);
		}
		
		override public function update():void
		{
			if (visible == false)
			{
				if (_textField.visible)
				{
					_textField.visible = false;
				}
			} else {
				if (!_textField.visible)
				{
					_textField.visible = true;
				}
			}
			
			super.update();
		}
		
	}

}