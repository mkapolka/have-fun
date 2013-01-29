package org.component.dialog 
{
	import org.component.Component;
	import org.component.flixel.FlxTextComponent;
	import org.component.Message;
	import org.flixel.FlxText;
	
	/**
	 * ...
	 * @author Marek Kapolka
	 */
	public class DialogTextBoxComponent extends Component 
	{
		
		public function DialogTextBoxComponent() 
		{
			super();
			
			addRequisiteComponent(FlxTextComponent);
		}
		
		public function get text():FlxText
		{
			var c : Component = getSiblingComponent(FlxTextComponent);
			
			if (c != null)
			{
				var ftc : FlxTextComponent = (FlxTextComponent)(c);
				return ftc.text;
			}
			
			return null;
		}
		
		public function get textComponent():FlxTextComponent
		{
			var c : Component = getSiblingComponent(FlxTextComponent);
			
			if (c != null)
			{
				return (FlxTextComponent)(c);
			} else {
				return null;
			}
		}
		
		override public function receiveMessage(m : Message):void
		{
			super.receiveMessage(m);
			
			if (m.type == DialogMessage.SHOW_RESPONSE)
			{
				var dm : DialogMessage = (DialogMessage)(m);
				
				setText(dm.response.text);
			}
		}
		
		protected function setText(input : String):void
		{			
			textComponent.setText(input);
		}
		
	}

}