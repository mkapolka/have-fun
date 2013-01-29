package as2.etc 
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import org.component.Component;
	import org.component.flixel.FlxObjectComponent;
	import org.component.Message;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class TextInputComponent extends Component
	{
		public static const ENTER_KEYCODE : uint = 13;
		public static const ENTER_MESSAGE : String = "enter";
		
		private var _textField : TextField;
		private var _focusTrigger : String = "focus";
		
		private var _font : String = "Times New Roman";
		private var _textSize : Number = 10;
		private var _textColor : uint = 0x00000000;
		private var _alignment : String = "left";
		
		public function TextInputComponent() 
		{
			_textField = new TextField();
			_textField.type = TextFieldType.INPUT;
			
			addRequisiteComponent(FlxObjectComponent);
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			FlxG.stage.addChild(_textField);
			_textField.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			_textField.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			if (_textField.parent != null)
			{
				_textField.parent.removeChild(_textField);
			}
		}
		
		override public function resolve():void
		{
			super.resolve();
			
			relocateTextBox();
		}
		
		override public function loadContent(xml : XML):void
		{
			super.loadContent(xml);
			
			if (xmlElementExists(xml, "textColor"))
			{
				_textColor = parseInt(xml.textColor);
			}
			
			if (xmlElementExists(xml, "textSize"))
			{
				_textSize = parseFloat(xml.textSize);
			}
			
			if (xmlElementExists(xml, "textAlignment"))
			{
				_alignment = xml.textAlignment;
			}
			
			if (xmlElementExists(xml, "font"))
			{
				_font = xml.font;
			}
			
			if (xmlElementExists(xml, "focusTrigger"))
			{
				_focusTrigger = xml.focusTrigger;
			}
			
			updateFormat();
		}
		
		override public function update():void
		{
			super.update();
			
			relocateTextBox();
		}
		
		override public function receiveMessage(message : Message):void
		{
			super.receiveMessage(message);
			
			if (message.type == _focusTrigger)
			{
				_textField.stage.focus = _textField;
				_textField.setSelection(0, _textField.length);
			}
			
			if (message.type == FlxObjectComponent.HIDE)
			{
				_textField.visible = false;
			}
			
			if (message.type == FlxObjectComponent.SHOW)
			{
				_textField.visible = true;
			}
			
			if (message.type == FlxObjectComponent.DISABLE)
			{
				_textField.visible = false;
				
				if (_textField.stage != null && _textField.stage.focus == _textField)
				{
					_textField.stage.focus = null;
				}
			}
			
			if (message.type == FlxObjectComponent.ENABLE)
			{
				
			}
		}
		
		/**
		 * Unique Functions
		 */
		
		private function relocateTextBox():void
		{
			var ob : FlxObject = flxObject;
			
			if (ob != null)
			{
				_textField.x = ob.x;
				_textField.y = ob.y;
				_textField.width = ob.width;
				_textField.height = ob.height;
			}
		}
		
		private function updateFormat():void
		{
			var format : TextFormat = new TextFormat();
			
			format.font = _font;
			format.size = _textSize;
			format.color = _textColor;
			format.align = _alignment;
			
			_textField.defaultTextFormat = format;
		}
		
		private function onKeyDown(ke : KeyboardEvent):void
		{
			if (ke.keyCode == ENTER_KEYCODE)
			{
				var em : Message = new Message();
				em.sender = this;
				em.type = ENTER_MESSAGE;
				entity.sendMessage(em);
			}
		}
		
		/**
		 * Accessors
		 */
		
		public function get flxObjectComponent():FlxObjectComponent
		{
			return getSiblingComponent(FlxObjectComponent) as FlxObjectComponent;
		}
		
		public function get flxObject():FlxObject
		{
			var foc : FlxObjectComponent = flxObjectComponent;
			
			if (foc != null)
			{
				return foc.object;
			} else {
				return null;
			}
		}
		
		public function get textField():TextField
		{
			return _textField;
		}
		
	}

}